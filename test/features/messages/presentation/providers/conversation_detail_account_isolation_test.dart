import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/messages/data/repositories/messages_repository_impl.dart';
import 'package:lehiboo/features/messages/domain/entities/conversation.dart';
import 'package:lehiboo/features/messages/domain/entities/conversation_route.dart';
import 'package:lehiboo/features/messages/domain/entities/message.dart';
import 'package:lehiboo/features/messages/domain/repositories/messages_repository.dart';
import 'package:lehiboo/features/messages/presentation/providers/conversation_detail_provider.dart';

final _activeAccountProvider = StateProvider<String?>((ref) => 'account-a');

const _detailKey = (
  uuid: 'shared-conversation-uuid',
  route: ConversationRoute.participant,
);

void main() {
  late _ControlledDetailRepository repository;
  late ProviderContainer container;
  late ProviderSubscription<ConversationDetailState> subscription;

  setUp(() {
    repository = _ControlledDetailRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          _NeverCompletingAuthRepository(),
        ),
        authSessionUserIdProvider.overrideWith(
          (ref) => ref.watch(_activeAccountProvider),
        ),
        messagesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    subscription = container.listen(
      conversationDetailProvider(_detailKey),
      (_, __) {},
      fireImmediately: true,
    );
  });

  tearDown(() {
    subscription.close();
    container.dispose();
  });

  test('never fetches or exposes a conversation without an active account',
      () async {
    subscription.close();
    container.dispose();
    repository = _ControlledDetailRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          _NeverCompletingAuthRepository(),
        ),
        authSessionUserIdProvider.overrideWithValue(null),
        messagesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    subscription = container.listen(
      conversationDetailProvider(_detailKey),
      (_, __) {},
      fireImmediately: true,
    );
    await pumpEventQueue();

    expect(repository.detailRequests, isEmpty);
    expect(
      container
          .read(conversationDetailProvider(_detailKey))
          .conversation
          .valueOrNull,
      isNull,
    );
  });

  test('account switch clears A immediately and rejects A late response',
      () async {
    await pumpEventQueue();
    expect(repository.detailRequests, hasLength(1));

    container.read(_activeAccountProvider.notifier).state = 'account-b';
    await pumpEventQueue();
    expect(repository.detailRequests, hasLength(2));
    expect(_visibleSubject(container), isNull);

    repository.detailRequests[0].complete(_conversation('private-account-a'));
    await pumpEventQueue();
    expect(_visibleSubject(container), isNull);

    repository.detailRequests[1].complete(_conversation('private-account-b'));
    await pumpEventQueue();
    expect(_visibleSubject(container), 'private-account-b');

    container.read(_activeAccountProvider.notifier).state = null;
    await pumpEventQueue();
    expect(_visibleSubject(container), isNull);
    expect(repository.detailRequests, hasLength(2));
  });

  test('latest detail request wins within the same account', () async {
    await pumpEventQueue();
    final notifier =
        container.read(conversationDetailProvider(_detailKey).notifier);

    final refresh = notifier.load();
    await pumpEventQueue();
    expect(repository.detailRequests, hasLength(2));

    repository.detailRequests[1].complete(_conversation('fresh-response'));
    await refresh;
    expect(_visibleSubject(container), 'fresh-response');

    repository.detailRequests[0].complete(_conversation('stale-response'));
    await pumpEventQueue();
    expect(_visibleSubject(container), 'fresh-response');
  });

  test('old-account mutation completions cannot alter B conversation',
      () async {
    await pumpEventQueue();
    repository.detailRequests.single.complete(
      _conversation(
        'private-account-a',
        messages: [_message('editable'), _message('deletable')],
      ),
    );
    await pumpEventQueue();

    final notifierA =
        container.read(conversationDetailProvider(_detailKey).notifier);
    final send = notifierA.sendMessage(content: 'from account A');
    final edit = notifierA.editMessage('editable', 'edited by A');
    final delete = notifierA.deleteMessage('deletable');
    final close = notifierA.closeConversation();
    final report = notifierA.reportConversation('spam', null);
    await pumpEventQueue();

    container.read(_activeAccountProvider.notifier).state = 'account-b';
    await pumpEventQueue();
    repository.detailRequests[1].complete(
      _conversation(
        'private-account-b',
        messages: [_message('account-b-message')],
      ),
    );
    await pumpEventQueue();

    repository.sendRequests.single.complete(_message('sent-by-account-a'));
    repository.editRequests.single.complete(_message('editable-edited'));
    repository.deleteRequests.single.complete();
    repository.closeRequests.single.complete(
      _conversation('closed-account-a', status: 'closed'),
    );
    repository.reportRequests.single.complete(
      const ReportConversationResult(reportUuid: 'account-a-report'),
    );

    await Future.wait([send, edit, delete, close]);
    await expectLater(report, throwsStateError);
    await pumpEventQueue();

    final visible = container
        .read(conversationDetailProvider(_detailKey))
        .conversation
        .requireValue;
    expect(visible.subject, 'private-account-b');
    expect(visible.status, 'open');
    expect(visible.messages.map((message) => message.uuid), [
      'account-b-message',
    ]);
  });
}

String? _visibleSubject(ProviderContainer container) => container
    .read(conversationDetailProvider(_detailKey))
    .conversation
    .valueOrNull
    ?.subject;

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _authenticated = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _authenticated.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ControlledDetailRepository implements MessagesRepository {
  final detailRequests = <Completer<Conversation>>[];
  final sendRequests = <Completer<Message>>[];
  final editRequests = <Completer<Message>>[];
  final deleteRequests = <Completer<void>>[];
  final closeRequests = <Completer<Conversation>>[];
  final reportRequests = <Completer<ReportConversationResult>>[];

  @override
  Future<Conversation> getConversation(String uuid) {
    final request = Completer<Conversation>();
    detailRequests.add(request);
    return request.future;
  }

  @override
  Future<ConversationsListResult> getConversations({
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async =>
      const ConversationsListResult(
        conversations: [],
        hasMore: false,
        currentPage: 1,
        totalCount: 0,
      );

  @override
  Future<Message> sendMessage({
    required String conversationUuid,
    String? content,
  }) {
    final request = Completer<Message>();
    sendRequests.add(request);
    return request.future;
  }

  @override
  Future<Message> editMessage({
    required String conversationUuid,
    required String messageUuid,
    required String content,
  }) {
    final request = Completer<Message>();
    editRequests.add(request);
    return request.future;
  }

  @override
  Future<void> deleteMessage({
    required String conversationUuid,
    required String messageUuid,
  }) {
    final request = Completer<void>();
    deleteRequests.add(request);
    return request.future;
  }

  @override
  Future<Conversation> closeConversation(String uuid) {
    final request = Completer<Conversation>();
    closeRequests.add(request);
    return request.future;
  }

  @override
  Future<ReportConversationResult> reportConversation({
    required String conversationUuid,
    required String reason,
    String? comment,
  }) {
    final request = Completer<ReportConversationResult>();
    reportRequests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Conversation _conversation(
  String subject, {
  String status = 'open',
  List<Message> messages = const [],
}) =>
    Conversation(
      uuid: _detailKey.uuid,
      subject: subject,
      status: status,
      conversationType: 'participant_vendor',
      unreadCount: 0,
      isSignalement: false,
      userHasReported: false,
      messages: messages,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

Message _message(String uuid) => Message(
      uuid: uuid,
      senderType: 'participant',
      isSystem: false,
      content: uuid,
      isDeleted: false,
      isEdited: false,
      isRead: false,
      isDelivered: false,
      isMine: true,
      createdAt: DateTime(2026),
    );

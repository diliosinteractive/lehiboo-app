import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/petit_boo/data/models/conversation_dto.dart';
import 'package:lehiboo/features/petit_boo/domain/repositories/petit_boo_repository.dart';
import 'package:lehiboo/features/petit_boo/presentation/providers/conversation_list_provider.dart';

class _NeverCompletingAuthRepository implements AuthRepository {
  final _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(Ref ref, HbUser? user)
      : super(_NeverCompletingAuthRepository(), ref) {
    setUser(user);
  }

  void setUser(HbUser? user) {
    state = AuthState(
      status:
          user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated,
      user: user,
    );
  }
}

class _ListRequest {
  final int page;
  final Completer<ConversationsResult> response =
      Completer<ConversationsResult>();

  _ListRequest(this.page);
}

class _DetailRequest {
  final String uuid;
  final Completer<ConversationDto> response = Completer<ConversationDto>();

  _DetailRequest(this.uuid);
}

class _ControlledPetitBooRepository implements PetitBooRepository {
  final listRequests = <_ListRequest>[];
  final detailRequests = <_DetailRequest>[];

  @override
  Future<ConversationsResult> getConversations({
    int page = 1,
    int perPage = 20,
  }) {
    final request = _ListRequest(page);
    listRequests.add(request);
    return request.response.future;
  }

  @override
  Future<ConversationDto> getConversation(String uuid) {
    final request = _DetailRequest(uuid);
    detailRequests.add(request);
    return request.response.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _accountA = HbUser(
  id: 'account-a',
  email: 'a@example.test',
  displayName: 'Account A',
);

const _accountB = HbUser(
  id: 'account-b',
  email: 'b@example.test',
  displayName: 'Account B',
);

ConversationDto _conversation(String uuid) => ConversationDto(
      uuid: uuid,
      title: uuid,
      createdAt: '2026-07-31T10:00:00Z',
    );

ConversationsResult _result(
  String uuid, {
  int page = 1,
  int totalPages = 1,
}) =>
    ConversationsResult(
      conversations: [_conversation(uuid)],
      currentPage: page,
      totalPages: totalPages,
      totalItems: totalPages,
    );

({ProviderContainer container, _TestAuthNotifier auth}) _createContainer(
  _ControlledPetitBooRepository repository, {
  HbUser? user = _accountA,
}) {
  late _TestAuthNotifier auth;
  final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) {
        auth = _TestAuthNotifier(ref, user);
        return auth;
      }),
      petitBooRepositoryProvider.overrideWithValue(repository),
    ],
  );
  container.read(authProvider);
  return (container: container, auth: auth);
}

void main() {
  test('history list switches account without publishing the old response',
      () async {
    final repository = _ControlledPetitBooRepository();
    final scope = _createContainer(repository);
    final subscription = scope.container.listen(
      conversationListProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    addTearDown(scope.container.dispose);

    expect(repository.listRequests, hasLength(1));
    scope.auth.setUser(_accountB);
    await pumpEventQueue();
    expect(repository.listRequests, hasLength(2));

    repository.listRequests.first.response.complete(_result('account-a'));
    await pumpEventQueue();
    expect(
      scope.container.read(conversationListProvider).conversations,
      isEmpty,
    );

    repository.listRequests.last.response.complete(_result('account-b'));
    await pumpEventQueue();
    expect(
      scope.container.read(conversationListProvider).conversations.single.uuid,
      'account-b',
    );
  });

  test('rapid A to B to A recreates blank history and rejects the first A',
      () async {
    final repository = _ControlledPetitBooRepository();
    final scope = _createContainer(repository);
    final subscription = scope.container.listen(
      conversationListProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    addTearDown(scope.container.dispose);

    final firstANotifier =
        scope.container.read(conversationListProvider.notifier);
    expect(repository.listRequests, hasLength(1));

    scope.auth.setUser(_accountB);
    scope.auth.setUser(_accountA);

    final replacementANotifier =
        scope.container.read(conversationListProvider.notifier);
    expect(replacementANotifier, isNot(same(firstANotifier)));
    expect(
        scope.container.read(conversationListProvider).conversations, isEmpty);
    expect(repository.listRequests, hasLength(2));

    repository.listRequests.first.response.complete(_result('first-a'));
    await pumpEventQueue();
    expect(
        scope.container.read(conversationListProvider).conversations, isEmpty);

    repository.listRequests.last.response.complete(_result('replacement-a'));
    await pumpEventQueue();
    expect(
      scope.container.read(conversationListProvider).conversations.single.uuid,
      'replacement-a',
    );
  });

  test('logout clears history immediately and does not fetch anonymously',
      () async {
    final repository = _ControlledPetitBooRepository();
    final scope = _createContainer(repository);
    final subscription = scope.container.listen(
      conversationListProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    addTearDown(scope.container.dispose);

    repository.listRequests.single.response.complete(_result('account-a'));
    await pumpEventQueue();
    expect(
      scope.container.read(conversationListProvider).conversations,
      hasLength(1),
    );

    scope.auth.setUser(null);
    await pumpEventQueue();

    final state = scope.container.read(conversationListProvider);
    expect(state.conversations, isEmpty);
    expect(state.isLoading, isFalse);
    expect(repository.listRequests, hasLength(1));
  });

  test('history list clears loaded data while the next account loads',
      () async {
    final repository = _ControlledPetitBooRepository();
    final scope = _createContainer(repository);
    final subscription = scope.container.listen(
      conversationListProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    addTearDown(scope.container.dispose);

    repository.listRequests.single.response.complete(_result('account-a'));
    await pumpEventQueue();
    expect(
      scope.container.read(conversationListProvider).conversations.single.uuid,
      'account-a',
    );

    scope.auth.setUser(_accountB);
    await pumpEventQueue();

    final state = scope.container.read(conversationListProvider);
    expect(state.conversations, isEmpty);
    expect(state.isLoading, isTrue);
    expect(repository.listRequests, hasLength(2));
    repository.listRequests.last.response.complete(_result('account-b'));
    await pumpEventQueue();
  });

  test('the latest refresh wins when responses arrive out of order', () async {
    final repository = _ControlledPetitBooRepository();
    final scope = _createContainer(repository);
    final subscription = scope.container.listen(
      conversationListProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    addTearDown(scope.container.dispose);

    repository.listRequests.single.response.complete(_result('initial'));
    await pumpEventQueue();

    final notifier = scope.container.read(conversationListProvider.notifier);
    final olderRefresh = notifier.refresh();
    final newerRefresh = notifier.refresh();
    expect(repository.listRequests, hasLength(3));

    repository.listRequests[2].response.complete(_result('newer'));
    await newerRefresh;
    repository.listRequests[1].response.complete(_result('older'));
    await olderRefresh;

    expect(
      scope.container.read(conversationListProvider).conversations.single.uuid,
      'newer',
    );
  });

  test('history detail switches account without publishing the old response',
      () async {
    final repository = _ControlledPetitBooRepository();
    final scope = _createContainer(repository);
    final provider = conversationDetailProvider('shared-uuid');
    final subscription = scope.container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    addTearDown(scope.container.dispose);

    expect(repository.detailRequests, hasLength(1));
    scope.auth.setUser(_accountB);
    await pumpEventQueue();
    expect(repository.detailRequests, hasLength(2));

    repository.detailRequests.first.response.complete(_conversation('a-data'));
    await pumpEventQueue();
    expect(scope.container.read(provider).valueOrNull, isNull);

    repository.detailRequests.last.response.complete(_conversation('b-data'));
    await pumpEventQueue();
    expect(scope.container.read(provider).requireValue.uuid, 'b-data');
  });

  test('history detail clears loaded data while the next account loads',
      () async {
    final repository = _ControlledPetitBooRepository();
    final scope = _createContainer(repository);
    final provider = conversationDetailProvider('shared-uuid');
    final subscription = scope.container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    addTearDown(scope.container.dispose);

    repository.detailRequests.single.response.complete(_conversation('a-data'));
    await pumpEventQueue();
    expect(scope.container.read(provider).requireValue.uuid, 'a-data');

    scope.auth.setUser(_accountB);
    await pumpEventQueue();

    expect(repository.detailRequests, hasLength(2));
    expect(scope.container.read(provider).valueOrNull, isNull);
    repository.detailRequests.last.response.complete(_conversation('b-data'));
    await pumpEventQueue();
    expect(scope.container.read(provider).requireValue.uuid, 'b-data');
  });

  test('history detail clears on logout and never fetches anonymously',
      () async {
    final repository = _ControlledPetitBooRepository();
    final scope = _createContainer(repository);
    final provider = conversationDetailProvider('account-a-conversation');
    final subscription = scope.container.listen(
      provider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    addTearDown(scope.container.dispose);

    repository.detailRequests.single.response.complete(
      _conversation('account-a-conversation'),
    );
    await pumpEventQueue();
    expect(scope.container.read(provider).hasValue, isTrue);

    scope.auth.setUser(null);
    await pumpEventQueue();

    final detail = scope.container.read(provider);
    expect(detail.valueOrNull, isNull);
    expect(
      detail.error,
      isA<ConversationHistoryAuthenticationRequiredException>(),
    );
    expect(repository.detailRequests, hasLength(1));
  });
}

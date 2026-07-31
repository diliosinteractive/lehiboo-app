import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/messages/data/repositories/messages_repository_impl.dart';
import 'package:lehiboo/features/messages/domain/entities/broadcast.dart';
import 'package:lehiboo/features/messages/domain/entities/conversation.dart';
import 'package:lehiboo/features/messages/domain/entities/conversation_report.dart';
import 'package:lehiboo/features/messages/domain/repositories/messages_repository.dart';
import 'package:lehiboo/features/messages/presentation/providers/admin_conversations_provider.dart';
import 'package:lehiboo/features/messages/presentation/providers/conversations_provider.dart';
import 'package:lehiboo/features/messages/presentation/providers/support_conversations_provider.dart';
import 'package:lehiboo/features/messages/presentation/providers/vendor_broadcasts_provider.dart';
import 'package:lehiboo/features/messages/presentation/providers/vendor_conversations_provider.dart';
import 'package:lehiboo/features/messages/presentation/providers/vendor_org_conversations_provider.dart';

typedef _PaginationSnapshot = ({
  int rows,
  int page,
  bool isLoading,
  Object? error,
});

final _messageSessionUserIdProvider =
    StateProvider<String?>((ref) => 'account-a');

void main() {
  late _FakeMessagesRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _FakeMessagesRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          _NeverCompletingAuthRepository(),
        ),
        authSessionUserIdProvider.overrideWithValue('test-user'),
        messagesRepositoryProvider.overrideWithValue(repository),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('participant pagination preserves rows and requires explicit retry',
      () async {
    container.read(conversationsProvider);
    await pumpEventQueue();
    final notifier = container.read(conversationsProvider.notifier);

    await _verifyFailureAndRetry(
      repository: repository,
      requestKey: 'participant',
      loadMore: notifier.loadMore,
      retry: notifier.retryLoadMore,
      refresh: notifier.refresh,
      snapshot: () {
        final state = container.read(conversationsProvider);
        return (
          rows: state.conversations.valueOrNull?.length ?? 0,
          page: state.currentPage,
          isLoading: state.isLoadingMore,
          error: state.loadMoreError,
        );
      },
    );
  });

  test('support pagination preserves rows and requires explicit retry',
      () async {
    container.read(supportConversationsProvider);
    await pumpEventQueue();
    final notifier = container.read(supportConversationsProvider.notifier);

    await _verifyFailureAndRetry(
      repository: repository,
      requestKey: 'support',
      loadMore: notifier.loadMore,
      retry: notifier.retryLoadMore,
      refresh: notifier.refresh,
      snapshot: () {
        final state = container.read(supportConversationsProvider);
        return (
          rows: state.conversations.valueOrNull?.length ?? 0,
          page: state.currentPage,
          isLoading: state.isLoadingMore,
          error: state.loadMoreError,
        );
      },
    );
  });

  test('vendor client pagination preserves rows and requires explicit retry',
      () async {
    container.read(vendorConversationsProvider);
    await pumpEventQueue();
    final notifier = container.read(vendorConversationsProvider.notifier);

    await _verifyFailureAndRetry(
      repository: repository,
      requestKey: 'vendor:participant_vendor',
      loadMore: notifier.loadMore,
      retry: notifier.retryLoadMore,
      refresh: notifier.refresh,
      snapshot: () {
        final state = container.read(vendorConversationsProvider);
        return (
          rows: state.conversations.valueOrNull?.length ?? 0,
          page: state.currentPage,
          isLoading: state.isLoadingMore,
          error: state.loadMoreError,
        );
      },
    );
  });

  test('vendor support pagination preserves rows and requires explicit retry',
      () async {
    container.read(vendorSupportProvider);
    await pumpEventQueue();
    final notifier = container.read(vendorSupportProvider.notifier);

    await _verifyFailureAndRetry(
      repository: repository,
      requestKey: 'vendor:vendor_admin',
      loadMore: notifier.loadMore,
      retry: notifier.retryLoadMore,
      refresh: notifier.refresh,
      snapshot: () {
        final state = container.read(vendorSupportProvider);
        return (
          rows: state.conversations.valueOrNull?.length ?? 0,
          page: state.currentPage,
          isLoading: state.isLoadingMore,
          error: state.loadMoreError,
        );
      },
    );
  });

  test('vendor partner pagination preserves rows and requires explicit retry',
      () async {
    container.read(vendorOrgConversationsProvider);
    await pumpEventQueue();
    final notifier = container.read(vendorOrgConversationsProvider.notifier);

    await _verifyFailureAndRetry(
      repository: repository,
      requestKey: 'vendor:organization',
      loadMore: notifier.loadMore,
      retry: notifier.retryLoadMore,
      refresh: notifier.refresh,
      snapshot: () {
        final state = container.read(vendorOrgConversationsProvider);
        return (
          rows: state.conversations.valueOrNull?.length ?? 0,
          page: state.currentPage,
          isLoading: state.isLoadingMore,
          error: state.loadMoreError,
        );
      },
    );
  });

  test('admin pagination preserves rows and requires explicit retry', () async {
    final provider = adminConversationsProvider('user_support');
    container.read(provider);
    await pumpEventQueue();
    final notifier = container.read(provider.notifier);

    await _verifyFailureAndRetry(
      repository: repository,
      requestKey: 'admin:user_support',
      loadMore: notifier.loadMore,
      retry: notifier.retryLoadMore,
      refresh: notifier.refresh,
      snapshot: () {
        final state = container.read(provider);
        return (
          rows: state.conversations.valueOrNull?.length ?? 0,
          page: state.currentPage,
          isLoading: state.isLoadingMore,
          error: state.loadMoreError,
        );
      },
    );
  });

  test('broadcast pagination preserves rows and requires explicit retry',
      () async {
    container.read(vendorBroadcastsProvider);
    await pumpEventQueue();
    final notifier = container.read(vendorBroadcastsProvider.notifier);

    await _verifyFailureAndRetry(
      repository: repository,
      requestKey: 'broadcasts',
      loadMore: notifier.loadMore,
      retry: notifier.retryLoadMore,
      refresh: notifier.refresh,
      snapshot: () {
        final state = container.read(vendorBroadcastsProvider);
        return (
          rows: state.broadcasts.valueOrNull?.length ?? 0,
          page: state.currentPage,
          isLoading: state.isLoadingMore,
          error: state.loadMoreError,
        );
      },
    );
  });

  test('report pagination preserves rows and requires explicit retry',
      () async {
    container.read(adminReportsProvider);
    await pumpEventQueue();
    final notifier = container.read(adminReportsProvider.notifier);

    await _verifyFailureAndRetry(
      repository: repository,
      requestKey: 'reports',
      loadMore: notifier.loadMore,
      retry: notifier.retryLoadMore,
      refresh: notifier.refresh,
      snapshot: () {
        final state = container.read(adminReportsProvider);
        return (
          rows: state.reports.valueOrNull?.length ?? 0,
          page: state.currentPage,
          isLoading: state.isLoadingMore,
          error: state.loadMoreError,
        );
      },
    );
  });

  test('message lists stay empty and make no requests without an account',
      () async {
    container.dispose();
    final controlledRepository = _ControlledMessagesRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          _NeverCompletingAuthRepository(),
        ),
        authSessionUserIdProvider.overrideWithValue(null),
        messagesRepositoryProvider.overrideWithValue(controlledRepository),
      ],
    );

    _listenToAllMessageLists(container);
    await pumpEventQueue();

    expect(controlledRepository.totalRequests, 0);
    _expectAllMessageLists(container, marker: null);
  });

  test('late message-list responses cannot cross account boundaries', () async {
    container.dispose();
    final controlledRepository = _ControlledMessagesRepository();
    container = _accountScopedContainer(controlledRepository);
    _listenToAllMessageLists(container);
    await pumpEventQueue();
    controlledRepository.expectEveryRequestCount(1);

    container.read(_messageSessionUserIdProvider.notifier).state = 'account-b';
    await pumpEventQueue();
    controlledRepository.expectEveryRequestCount(2);

    controlledRepository.completeEveryRequest(1, 'account-b');
    await pumpEventQueue();
    _expectAllMessageLists(container, marker: 'account-b');

    controlledRepository.completeEveryRequest(0, 'account-a');
    await pumpEventQueue();
    _expectAllMessageLists(container, marker: 'account-b');
  });

  test('late filter and refresh responses cannot replace newer list state',
      () async {
    container.dispose();
    final controlledRepository = _ControlledMessagesRepository();
    container = _accountScopedContainer(controlledRepository);
    _listenToAllMessageLists(container);
    await pumpEventQueue();
    controlledRepository.expectEveryRequestCount(1);

    container.read(conversationsProvider.notifier).setSearchQuery('new query');
    container
        .read(supportConversationsProvider.notifier)
        .setSearchQuery('new query');
    container
        .read(vendorConversationsProvider.notifier)
        .setSearchQuery('new query');
    container
        .read(vendorOrgConversationsProvider.notifier)
        .setSearchQuery('new query');
    container
        .read(adminConversationsProvider('user_support').notifier)
        .setSearchQuery('new query');
    container
        .read(vendorBroadcastsProvider.notifier)
        .setSearchQuery('new query');
    container.read(adminReportsProvider.notifier).setSearch('new query');
    unawaited(container.read(vendorSupportProvider.notifier).refresh());
    await pumpEventQueue();
    controlledRepository.expectEveryRequestCount(2);

    controlledRepository.completeEveryRequest(1, 'new-query');
    await pumpEventQueue();
    _expectAllMessageLists(container, marker: 'new-query');

    controlledRepository.completeEveryRequest(0, 'old-query');
    await pumpEventQueue();
    _expectAllMessageLists(container, marker: 'new-query');
  });
}

ProviderContainer _accountScopedContainer(
  _ControlledMessagesRepository repository,
) {
  return ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        _NeverCompletingAuthRepository(),
      ),
      authSessionUserIdProvider.overrideWith(
        (ref) => ref.watch(_messageSessionUserIdProvider),
      ),
      messagesRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

void _listenToAllMessageLists(ProviderContainer container) {
  container.listen(conversationsProvider, (_, __) {}, fireImmediately: true);
  container.listen(
    supportConversationsProvider,
    (_, __) {},
    fireImmediately: true,
  );
  container.listen(
    vendorConversationsProvider,
    (_, __) {},
    fireImmediately: true,
  );
  container.listen(vendorSupportProvider, (_, __) {}, fireImmediately: true);
  container.listen(
    vendorOrgConversationsProvider,
    (_, __) {},
    fireImmediately: true,
  );
  container.listen(
    adminConversationsProvider('user_support'),
    (_, __) {},
    fireImmediately: true,
  );
  container.listen(vendorBroadcastsProvider, (_, __) {}, fireImmediately: true);
  container.listen(adminReportsProvider, (_, __) {}, fireImmediately: true);
}

void _expectAllMessageLists(
  ProviderContainer container, {
  required String? marker,
}) {
  String? conversationUuid(AsyncValue<List<Conversation>> value) =>
      value.valueOrNull?.firstOrNull?.uuid;
  String? broadcastUuid(AsyncValue<List<Broadcast>> value) =>
      value.valueOrNull?.firstOrNull?.uuid;
  String? reportUuid(AsyncValue<List<ConversationReport>> value) =>
      value.valueOrNull?.firstOrNull?.uuid;

  final suffix = marker == null ? null : '-$marker';
  expect(
    conversationUuid(container.read(conversationsProvider).conversations),
    marker == null ? isNull : 'participant$suffix',
  );
  expect(
    conversationUuid(
      container.read(supportConversationsProvider).conversations,
    ),
    marker == null ? isNull : 'support$suffix',
  );
  expect(
    conversationUuid(container.read(vendorConversationsProvider).conversations),
    marker == null ? isNull : 'vendor-client$suffix',
  );
  expect(
    conversationUuid(container.read(vendorSupportProvider).conversations),
    marker == null ? isNull : 'vendor-support$suffix',
  );
  expect(
    conversationUuid(
      container.read(vendorOrgConversationsProvider).conversations,
    ),
    marker == null ? isNull : 'vendor-org$suffix',
  );
  expect(
    conversationUuid(
      container.read(adminConversationsProvider('user_support')).conversations,
    ),
    marker == null ? isNull : 'admin$suffix',
  );
  expect(
    broadcastUuid(container.read(vendorBroadcastsProvider).broadcasts),
    marker == null ? isNull : 'broadcast$suffix',
  );
  expect(
    reportUuid(container.read(adminReportsProvider).reports),
    marker == null ? isNull : 'report$suffix',
  );
}

Future<void> _verifyFailureAndRetry({
  required _FakeMessagesRepository repository,
  required String requestKey,
  required Future<void> Function() loadMore,
  required Future<void> Function() retry,
  required Future<void> Function() refresh,
  required _PaginationSnapshot Function() snapshot,
}) async {
  expect(snapshot(), (rows: 1, page: 1, isLoading: false, error: null));

  await loadMore();
  final failed = snapshot();
  expect(failed.rows, 1);
  expect(failed.page, 1);
  expect(failed.isLoading, isFalse);
  expect(failed.error, isA<StateError>());
  expect(repository.pageTwoCalls(requestKey), 1);

  await loadMore();
  expect(repository.pageTwoCalls(requestKey), 1,
      reason: 'scroll-triggered loadMore must remain blocked after failure');

  await refresh();
  expect(snapshot(), (rows: 1, page: 1, isLoading: false, error: null),
      reason: 'a successful first-page refresh must clear the stale footer');

  await loadMore();
  expect(snapshot().error, isA<StateError>());
  expect(repository.pageTwoCalls(requestKey), 2);

  repository.allowPageTwo(requestKey);
  await retry();
  expect(snapshot(), (rows: 2, page: 2, isLoading: false, error: null));
  expect(repository.pageTwoCalls(requestKey), 3);
}

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _authenticated = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _authenticated.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ControlledMessagesRepository implements MessagesRepository {
  final participantRequests = <Completer<ConversationsListResult>>[];
  final supportRequests = <Completer<ConversationsListResult>>[];
  final vendorClientRequests = <Completer<ConversationsListResult>>[];
  final vendorSupportRequests = <Completer<ConversationsListResult>>[];
  final vendorOrgRequests = <Completer<ConversationsListResult>>[];
  final adminRequests = <Completer<ConversationsListResult>>[];
  final broadcastRequests = <Completer<BroadcastsListResult>>[];
  final reportRequests = <Completer<ConversationReportsListResult>>[];

  int get totalRequests =>
      participantRequests.length +
      supportRequests.length +
      vendorClientRequests.length +
      vendorSupportRequests.length +
      vendorOrgRequests.length +
      adminRequests.length +
      broadcastRequests.length +
      reportRequests.length;

  void expectEveryRequestCount(int count) {
    expect(participantRequests, hasLength(count));
    expect(supportRequests, hasLength(count));
    expect(vendorClientRequests, hasLength(count));
    expect(vendorSupportRequests, hasLength(count));
    expect(vendorOrgRequests, hasLength(count));
    expect(adminRequests, hasLength(count));
    expect(broadcastRequests, hasLength(count));
    expect(reportRequests, hasLength(count));
  }

  void completeEveryRequest(int index, String marker) {
    participantRequests[index].complete(
      _conversationResult('participant-$marker'),
    );
    supportRequests[index].complete(_conversationResult('support-$marker'));
    vendorClientRequests[index].complete(
      _conversationResult('vendor-client-$marker'),
    );
    vendorSupportRequests[index].complete(
      _conversationResult('vendor-support-$marker'),
    );
    vendorOrgRequests[index].complete(
      _conversationResult('vendor-org-$marker'),
    );
    adminRequests[index].complete(_conversationResult('admin-$marker'));
    broadcastRequests[index].complete(
      BroadcastsListResult(
        broadcasts: [_broadcast('broadcast-$marker')],
        hasMore: false,
        currentPage: 1,
        totalCount: 1,
      ),
    );
    reportRequests[index].complete(
      ConversationReportsListResult(
        reports: [_report('report-$marker')],
        hasMore: false,
        currentPage: 1,
        totalCount: 1,
      ),
    );
  }

  ConversationsListResult _conversationResult(String uuid) {
    return ConversationsListResult(
      conversations: [_conversation(uuid)],
      hasMore: false,
      currentPage: 1,
      totalCount: 1,
    );
  }

  Future<ConversationsListResult> _requestConversation(
    List<Completer<ConversationsListResult>> requests,
  ) {
    final completer = Completer<ConversationsListResult>();
    requests.add(completer);
    return completer.future;
  }

  @override
  Future<ConversationsListResult> getConversations({
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) =>
      _requestConversation(participantRequests);

  @override
  Future<ConversationsListResult> getSupportConversations({
    int page = 1,
    int perPage = 15,
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
  }) =>
      _requestConversation(supportRequests);

  @override
  Future<ConversationsListResult> getVendorConversations({
    String? conversationType,
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) =>
      _requestConversation(
        conversationType == 'vendor_admin'
            ? vendorSupportRequests
            : vendorClientRequests,
      );

  @override
  Future<ConversationsListResult> getOrgConversations({
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) =>
      _requestConversation(vendorOrgRequests);

  @override
  Future<ConversationsListResult> getAdminConversations({
    String? conversationType,
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) =>
      _requestConversation(adminRequests);

  @override
  Future<BroadcastsListResult> getBroadcasts({
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) {
    final completer = Completer<BroadcastsListResult>();
    broadcastRequests.add(completer);
    return completer.future;
  }

  @override
  Future<ConversationReportsListResult> getAdminConversationReports({
    String? search,
    String? reason,
    int page = 1,
    int perPage = 20,
  }) {
    final completer = Completer<ConversationReportsListResult>();
    reportRequests.add(completer);
    return completer.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeMessagesRepository implements MessagesRepository {
  final Map<String, int> _pageTwoCalls = {};
  final Set<String> _allowedPageTwo = {};

  int pageTwoCalls(String key) => _pageTwoCalls[key] ?? 0;

  void allowPageTwo(String key) => _allowedPageTwo.add(key);

  void _failPageTwoWhenRequired(String key, int page) {
    if (page != 2) return;
    _pageTwoCalls[key] = (_pageTwoCalls[key] ?? 0) + 1;
    if (!_allowedPageTwo.contains(key)) {
      throw StateError('technical pagination failure for $key');
    }
  }

  ConversationsListResult _conversations(String key, int page) {
    _failPageTwoWhenRequired(key, page);
    return ConversationsListResult(
      conversations: [_conversation('$key-$page')],
      hasMore: page == 1,
      currentPage: page,
      totalCount: 2,
    );
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
      _conversations('participant', page);

  @override
  Future<ConversationsListResult> getSupportConversations({
    int page = 1,
    int perPage = 15,
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
  }) async =>
      _conversations('support', page);

  @override
  Future<ConversationsListResult> getVendorConversations({
    String? conversationType,
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async =>
      _conversations('vendor:$conversationType', page);

  @override
  Future<ConversationsListResult> getOrgConversations({
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async =>
      _conversations('vendor:organization', page);

  @override
  Future<ConversationsListResult> getAdminConversations({
    String? conversationType,
    String? status,
    bool? unreadOnly,
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async =>
      _conversations('admin:$conversationType', page);

  @override
  Future<BroadcastsListResult> getBroadcasts({
    String? search,
    String? period,
    int page = 1,
    int perPage = 15,
  }) async {
    _failPageTwoWhenRequired('broadcasts', page);
    return BroadcastsListResult(
      broadcasts: [_broadcast('broadcast-$page')],
      hasMore: page == 1,
      currentPage: page,
      totalCount: 2,
    );
  }

  @override
  Future<ConversationReportsListResult> getAdminConversationReports({
    String? search,
    String? reason,
    int page = 1,
    int perPage = 20,
  }) async {
    _failPageTwoWhenRequired('reports', page);
    return ConversationReportsListResult(
      reports: [_report('report-$page')],
      hasMore: page == 1,
      currentPage: page,
      totalCount: 2,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Conversation _conversation(String uuid) => Conversation(
      uuid: uuid,
      subject: uuid,
      status: 'open',
      conversationType: 'participant_vendor',
      unreadCount: 0,
      isSignalement: false,
      userHasReported: false,
      messages: const [],
      createdAt: DateTime(2026, 7, 31),
      updatedAt: DateTime(2026, 7, 31),
    );

Broadcast _broadcast(String uuid) => Broadcast(
      uuid: uuid,
      subject: uuid,
      body: 'Body',
      recipientsCount: 1,
      readCount: 0,
      conversationsCreated: 0,
      isSent: true,
      events: const [],
      createdAt: DateTime(2026, 7, 31),
    );

ConversationReport _report(String uuid) => ConversationReport(
      uuid: uuid,
      reason: 'spam',
      status: 'pending',
      createdAt: DateTime(2026, 7, 31),
    );

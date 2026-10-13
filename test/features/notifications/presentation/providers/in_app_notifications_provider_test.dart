import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/notifications/domain/entities/in_app_notification.dart';
import 'package:lehiboo/features/notifications/domain/repositories/in_app_notifications_repository.dart';
import 'package:lehiboo/features/notifications/presentation/providers/in_app_notifications_provider.dart';

import '../../../../helpers/fake_auth_repository.dart';
import '../../../../helpers/fake_in_app_notifications_repository.dart';

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

class _NotificationsRequest {
  final int page;
  final bool unreadOnly;
  final String context;
  final Completer<InAppNotificationsPage> response = Completer();

  _NotificationsRequest({
    required this.page,
    required this.unreadOnly,
    required this.context,
  });
}

class _UnreadRequest {
  final String context;
  final Completer<int> response = Completer();

  _UnreadRequest(this.context);
}

class _ControlledNotificationsRepository
    implements InAppNotificationsRepository {
  final notificationRequests = <_NotificationsRequest>[];
  final unreadRequests = <_UnreadRequest>[];

  @override
  Future<InAppNotificationsPage> getNotifications({
    int page = 1,
    int perPage = 20,
    bool unreadOnly = false,
    String? type,
    required String context,
    String? organizationId,
    String? search,
  }) {
    final request = _NotificationsRequest(
      page: page,
      unreadOnly: unreadOnly,
      context: context,
    );
    notificationRequests.add(request);
    return request.response.future;
  }

  @override
  Future<int> getUnreadCount({
    required String context,
    String? organizationId,
  }) {
    final request = _UnreadRequest(context);
    unreadRequests.add(request);
    return request.response.future;
  }

  @override
  Future<void> deleteNotification(String id) async {}

  @override
  Future<int> deleteReadNotifications({
    required String context,
    String? organizationId,
  }) async =>
      0;

  @override
  Future<InAppNotification> getNotification(String id) async =>
      _notification(id);

  @override
  Future<int> markAllAsRead({
    required String context,
    String? organizationId,
  }) async =>
      0;

  @override
  Future<void> markAsRead(String id) async {}
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

const _organizer = HbUser(
  id: 'organizer',
  email: 'organizer@example.test',
  displayName: 'Organizer',
  role: UserRole.partner,
);

_UnreadRequest _pendingUnread(
  _ControlledNotificationsRepository repository,
  String context,
) =>
    repository.unreadRequests.lastWhere(
      (request) => request.context == context && !request.response.isCompleted,
    );

InAppNotification _notification(String id) => InAppNotification(
      id: id,
      type: 'reminder',
      title: id,
      message: id,
      isRead: false,
      createdAt: DateTime(2026),
    );

InAppNotificationsPage _page(
  int page,
  List<InAppNotification> notifications, {
  int lastPage = 1,
}) =>
    InAppNotificationsPage(
      notifications: notifications,
      currentPage: page,
      lastPage: lastPage,
      perPage: 20,
      total: notifications.length,
    );

({
  ProviderContainer container,
  _TestAuthNotifier auth,
  _ControlledNotificationsRepository repository,
  ProviderSubscription<InAppNotificationsState> subscription,
}) _createAuthenticatedContainer({HbUser user = _accountA}) {
  final repository = _ControlledNotificationsRepository();
  late _TestAuthNotifier auth;
  final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) {
        auth = _TestAuthNotifier(ref, user);
        return auth;
      }),
      inAppNotificationsRepositoryProvider.overrideWithValue(repository),
    ],
  );
  final subscription = container.listen(
    inAppNotificationsProvider,
    (_, __) {},
    fireImmediately: true,
  );
  return (
    container: container,
    auth: auth,
    repository: repository,
    subscription: subscription,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('notification state can retain and clear a pagination error', () {
    final failure = Exception('next page failed');
    final failed = const InAppNotificationsState().copyWith(
      loadMoreError: failure,
    );

    expect(failed.loadMoreError, same(failure));
    expect(failed.copyWith().loadMoreError, same(failure));
    expect(failed.copyWith(loadMoreError: null).loadMoreError, isNull);
  });

  test('load does not call protected API while unauthenticated', () async {
    final notificationsRepository = FakeInAppNotificationsRepository();
    final container = ProviderContainer(
      overrides: [
        analyticsServiceProvider.overrideWithValue(
          const NoopAnalyticsService(),
        ),
        authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        inAppNotificationsRepositoryProvider.overrideWithValue(
          notificationsRepository,
        ),
      ],
    );
    addTearDown(container.dispose);

    await container
        .read(inAppNotificationsProvider.notifier)
        .load(refresh: true);

    final state = container.read(inAppNotificationsProvider);
    expect(state.notifications.valueOrNull, isEmpty);
    expect(state.unreadCount, 0);
    expect(notificationsRepository.loadCount, 0);
    expect(notificationsRepository.unreadCountCalls, 0);
  });

  test('late unread count from the previous account is discarded', () async {
    final scope = _createAuthenticatedContainer();
    addTearDown(scope.subscription.close);
    addTearDown(scope.container.dispose);

    expect(scope.repository.unreadRequests, hasLength(1));
    final accountARequest = scope.repository.unreadRequests.single;

    scope.auth.setUser(_accountB);
    await pumpEventQueue();

    expect(scope.repository.unreadRequests, hasLength(2));
    accountARequest.response.complete(99);
    await pumpEventQueue();
    expect(scope.container.read(inAppNotificationsProvider).unreadCount, 0);

    scope.repository.unreadRequests.last.response.complete(3);
    await pumpEventQueue();
    expect(scope.container.read(inAppNotificationsProvider).unreadCount, 3);
  });

  test('late inbox response cannot populate the next account', () async {
    final scope = _createAuthenticatedContainer();
    addTearDown(scope.subscription.close);
    addTearDown(scope.container.dispose);
    scope.repository.unreadRequests.single.response.complete(0);
    await pumpEventQueue();

    final accountALoad = scope.container
        .read(inAppNotificationsProvider.notifier)
        .load(refresh: true);
    final accountARequest = scope.repository.notificationRequests.single;

    scope.auth.setUser(_accountB);
    await pumpEventQueue();
    accountARequest.response.complete(_page(1, [_notification('secret-a')]));
    await accountALoad;
    await pumpEventQueue();

    final state = scope.container.read(inAppNotificationsProvider);
    expect(state.notifications.valueOrNull, isEmpty);
    expect(state.hasLoadedInbox, isFalse);
    expect(state.unreadCount, 0);

    scope.repository.unreadRequests.last.response.complete(2);
  });

  test('late pagination response cannot populate the next account', () async {
    final scope = _createAuthenticatedContainer();
    addTearDown(scope.subscription.close);
    addTearDown(scope.container.dispose);
    scope.repository.unreadRequests.single.response.complete(0);
    await pumpEventQueue();

    final initialLoad = scope.container
        .read(inAppNotificationsProvider.notifier)
        .load(refresh: true);
    scope.repository.notificationRequests.single.response.complete(
      _page(1, [_notification('account-a-page-1')], lastPage: 2),
    );
    await pumpEventQueue();
    scope.repository.unreadRequests.last.response.complete(1);
    await initialLoad;

    final loadMore =
        scope.container.read(inAppNotificationsProvider.notifier).loadMore();
    final paginationRequest = scope.repository.notificationRequests.last;
    expect(paginationRequest.page, 2);

    scope.auth.setUser(_accountB);
    await pumpEventQueue();
    paginationRequest.response.complete(
      _page(2, [_notification('account-a-page-2')], lastPage: 2),
    );
    await loadMore;
    await pumpEventQueue();

    final state = scope.container.read(inAppNotificationsProvider);
    expect(state.notifications.valueOrNull, isEmpty);
    expect(state.isLoadingMore, isFalse);
    expect(state.hasLoadedInbox, isFalse);

    scope.repository.unreadRequests.last.response.complete(0);
  });

  test('newest inbox filter request wins within one account', () async {
    final scope = _createAuthenticatedContainer();
    addTearDown(scope.subscription.close);
    addTearDown(scope.container.dispose);
    scope.repository.unreadRequests.single.response.complete(0);
    await pumpEventQueue();

    final allLoad = scope.container
        .read(inAppNotificationsProvider.notifier)
        .load(refresh: true, unreadOnly: false);
    final unreadLoad = scope.container
        .read(inAppNotificationsProvider.notifier)
        .load(refresh: true, unreadOnly: true);
    final allRequest = scope.repository.notificationRequests.first;
    final unreadRequest = scope.repository.notificationRequests.last;

    allRequest.response.complete(_page(1, [_notification('stale-all')]));
    await allLoad;
    unreadRequest.response.complete(_page(1, [_notification('latest-unread')]));
    await pumpEventQueue();
    scope.repository.unreadRequests.last.response.complete(1);
    await unreadLoad;

    final state = scope.container.read(inAppNotificationsProvider);
    expect(state.unreadOnly, isTrue);
    expect(
      state.notifications.valueOrNull?.map((item) => item.id),
      ['latest-unread'],
    );
  });

  test('a participant account has a single inbox context', () async {
    final scope = _createAuthenticatedContainer();
    addTearDown(scope.subscription.close);
    addTearDown(scope.container.dispose);

    await scope.container
        .read(inAppNotificationsProvider.notifier)
        .setContext('vendor');

    final state = scope.container.read(inAppNotificationsProvider);
    expect(state.availableContexts, ['participant']);
    expect(state.context, 'participant');
    expect(scope.repository.notificationRequests, isEmpty);
    expect(
      scope.repository.unreadRequests.map((request) => request.context),
      ['participant'],
    );
  });

  test('an organizer can switch the inbox to the participant context',
      () async {
    final scope = _createAuthenticatedContainer(user: _organizer);
    addTearDown(scope.subscription.close);
    addTearDown(scope.container.dispose);
    final notifier = scope.container.read(inAppNotificationsProvider.notifier);

    var state = scope.container.read(inAppNotificationsProvider);
    expect(state.availableContexts, ['vendor', 'participant']);
    expect(state.context, 'vendor');

    _pendingUnread(scope.repository, 'vendor').response.complete(2);
    _pendingUnread(scope.repository, 'participant').response.complete(5);
    await pumpEventQueue();
    state = scope.container.read(inAppNotificationsProvider);
    expect(state.unreadCount, 2);
    expect(state.otherContextUnreadCounts, {'participant': 5});
    expect(state.totalUnreadCount, 7);

    final switching = notifier.setContext('participant');
    state = scope.container.read(inAppNotificationsProvider);
    expect(state.context, 'participant');
    expect(state.unreadCount, 5);
    expect(state.otherContextUnreadCounts, {'vendor': 2});
    expect(state.notifications.isLoading, isTrue);

    final request = scope.repository.notificationRequests.single;
    expect(request.context, 'participant');
    request.response.complete(_page(1, [_notification('event-start')]));
    await pumpEventQueue();
    _pendingUnread(scope.repository, 'participant').response.complete(4);
    await switching;
    await pumpEventQueue();
    _pendingUnread(scope.repository, 'vendor').response.complete(3);
    await pumpEventQueue();

    state = scope.container.read(inAppNotificationsProvider);
    expect(
      state.notifications.valueOrNull?.map((item) => item.id),
      ['event-start'],
    );
    expect(state.unreadCount, 4);
    expect(state.otherContextUnreadCounts, {'vendor': 3});
    expect(state.totalUnreadCount, 7);
  });

  test('a late page of the previous context cannot fill the new one', () async {
    final scope = _createAuthenticatedContainer(user: _organizer);
    addTearDown(scope.subscription.close);
    addTearDown(scope.container.dispose);
    _pendingUnread(scope.repository, 'vendor').response.complete(0);
    _pendingUnread(scope.repository, 'participant').response.complete(0);
    await pumpEventQueue();
    final notifier = scope.container.read(inAppNotificationsProvider.notifier);

    final vendorLoad = notifier.load(refresh: true);
    final vendorRequest = scope.repository.notificationRequests.single;
    final switching = notifier.setContext('participant');
    vendorRequest.response.complete(_page(1, [_notification('vendor-only')]));
    await vendorLoad;

    final participantRequest = scope.repository.notificationRequests.last;
    expect(participantRequest.context, 'participant');
    participantRequest.response.complete(
      _page(1, [_notification('participant-only')]),
    );
    await pumpEventQueue();
    _pendingUnread(scope.repository, 'participant').response.complete(1);
    await switching;

    final state = scope.container.read(inAppNotificationsProvider);
    expect(
      state.notifications.valueOrNull?.map((item) => item.id),
      ['participant-only'],
    );
  });

  test('a profile update keeps the selected context', () async {
    final scope = _createAuthenticatedContainer(user: _organizer);
    addTearDown(scope.subscription.close);
    addTearDown(scope.container.dispose);
    _pendingUnread(scope.repository, 'vendor').response.complete(0);
    _pendingUnread(scope.repository, 'participant').response.complete(0);
    await pumpEventQueue();
    final notifier = scope.container.read(inAppNotificationsProvider.notifier);

    final switching = notifier.setContext('participant');
    scope.repository.notificationRequests.single.response.complete(
      _page(1, const []),
    );
    await pumpEventQueue();
    _pendingUnread(scope.repository, 'participant').response.complete(0);
    await switching;

    scope.auth.setUser(_organizer.copyWith(displayName: 'Renamed'));
    await pumpEventQueue();

    expect(
      scope.container.read(inAppNotificationsProvider).context,
      'participant',
    );
    expect(scope.repository.notificationRequests.last.context, 'participant');
  });
}

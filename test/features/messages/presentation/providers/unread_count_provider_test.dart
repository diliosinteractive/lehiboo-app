import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/messages/data/datasources/messages_api_datasource.dart';
import 'package:lehiboo/features/messages/data/datasources/messages_polling_datasource.dart';
import 'package:lehiboo/features/messages/presentation/providers/unread_count_provider.dart';

class _NeverCompletingAuthRepository implements AuthRepository {
  final Completer<bool> _isAuthenticated = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _isAuthenticated.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestAuthNotifier extends AuthNotifier {
  _TestAuthNotifier(Ref ref, HbUser? initialUser)
      : super(_NeverCompletingAuthRepository(), ref) {
    setUser(initialUser);
  }

  void setUser(HbUser? user) {
    state = AuthState(
      status:
          user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated,
      user: user,
    );
  }
}

class _FakeMessagesPollingDatasource extends MessagesPollingDatasource {
  _FakeMessagesPollingDatasource() : super(MessagesApiDataSource(Dio()));

  final totalRequests = <Completer<int>>[];
  final vendorRequests = <Completer<int>>[];
  final adminRequests = <Completer<int>>[];

  @override
  Future<int> getTotalUnreadCount() {
    final request = Completer<int>();
    totalRequests.add(request);
    return request.future;
  }

  @override
  Future<int> getVendorUnreadCount() {
    final request = Completer<int>();
    vendorRequests.add(request);
    return request.future;
  }

  @override
  Future<int> getAdminUnreadCount() {
    final request = Completer<int>();
    adminRequests.add(request);
    return request.future;
  }
}

HbUser _user(String id, UserRole role) {
  return HbUser(
    id: id,
    email: '$id@example.com',
    displayName: id,
    role: role,
  );
}

({
  ProviderContainer container,
  _TestAuthNotifier auth,
}) _createContainer({
  required HbUser? initialUser,
  required _FakeMessagesPollingDatasource polling,
}) {
  late _TestAuthNotifier auth;
  final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) {
        auth = _TestAuthNotifier(ref, initialUser);
        return auth;
      }),
      messagesPollingDatasourceProvider.overrideWithValue(polling),
    ],
  );
  container.read(unreadCountProvider);
  return (container: container, auth: auth);
}

void main() {
  test('loads the authoritative role-specific count on cold start and switch',
      () async {
    final polling = _FakeMessagesPollingDatasource();
    final scope = _createContainer(
      initialUser: _user('subscriber', UserRole.subscriber),
      polling: polling,
    );
    addTearDown(scope.container.dispose);

    expect(scope.container.read(unreadCountProvider), 0);
    expect(polling.totalRequests, hasLength(1));
    polling.totalRequests.single.complete(4);
    await pumpEventQueue();
    expect(scope.container.read(unreadCountProvider), 4);

    scope.auth.setUser(_user('partner', UserRole.partner));
    expect(scope.container.read(unreadCountProvider), 0);
    expect(polling.vendorRequests, hasLength(1));
    polling.vendorRequests.single.complete(7);
    await pumpEventQueue();
    expect(scope.container.read(unreadCountProvider), 7);

    scope.auth.setUser(_user('admin', UserRole.admin));
    expect(scope.container.read(unreadCountProvider), 0);
    expect(polling.adminRequests, hasLength(1));
    polling.adminRequests.single.complete(9);
    await pumpEventQueue();
    expect(scope.container.read(unreadCountProvider), 9);
  });

  test('discards a late response from the previous account', () async {
    final polling = _FakeMessagesPollingDatasource();
    final scope = _createContainer(
      initialUser: _user('account-a', UserRole.subscriber),
      polling: polling,
    );
    addTearDown(scope.container.dispose);

    final accountARequest = polling.totalRequests.single;
    scope.auth.setUser(_user('account-b', UserRole.subscriber));

    expect(scope.container.read(unreadCountProvider), 0);
    expect(polling.totalRequests, hasLength(2));
    final accountBRequest = polling.totalRequests.last;

    accountARequest.complete(12);
    await pumpEventQueue();
    expect(scope.container.read(unreadCountProvider), 0);

    accountBRequest.complete(3);
    await pumpEventQueue();
    expect(scope.container.read(unreadCountProvider), 3);

    scope.container
        .read(unreadCountProvider.notifier)
        .decrementBy(2, forUserId: 'account-a');
    expect(scope.container.read(unreadCountProvider), 3);
  });

  test('guest state is zero and refresh performs no request', () async {
    final polling = _FakeMessagesPollingDatasource();
    final scope = _createContainer(
      initialUser: _user('subscriber', UserRole.subscriber),
      polling: polling,
    );
    addTearDown(scope.container.dispose);

    polling.totalRequests.single.complete(5);
    await pumpEventQueue();
    expect(scope.container.read(unreadCountProvider), 5);

    scope.auth.setUser(null);
    expect(scope.container.read(unreadCountProvider), 0);

    await scope.container.read(unreadCountProvider.notifier).refresh();
    expect(scope.container.read(unreadCountProvider), 0);
    expect(polling.totalRequests, hasLength(1));
  });

  test('explicit refresh preserves the last count and propagates failure',
      () async {
    final polling = _FakeMessagesPollingDatasource();
    final scope = _createContainer(
      initialUser: _user('subscriber', UserRole.subscriber),
      polling: polling,
    );
    addTearDown(scope.container.dispose);

    polling.totalRequests.single.complete(6);
    await pumpEventQueue();

    final refresh =
        scope.container.read(unreadCountProvider.notifier).refresh();
    expect(polling.totalRequests, hasLength(2));
    polling.totalRequests.last.completeError(Exception('unavailable'));

    await expectLater(refresh, throwsException);
    expect(scope.container.read(unreadCountProvider), 6);
  });
}

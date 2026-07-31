import 'dart:async';
import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/notifications/data/datasources/device_token_datasource.dart';

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

LoginOtpResult _loginResult(HbUser user) {
  return LoginOtpResult(
    requiresOtp: false,
    authResult: AuthResult(
      user: user,
      accessToken: 'access-${user.id}',
      refreshToken: 'refresh-${user.id}',
      expiresIn: 3600,
    ),
  );
}

class _ControlledAuthRepository implements AuthRepository {
  final Queue<Completer<bool>> authenticatedResponses = Queue();
  final Queue<Completer<HbUser?>> currentUserResponses = Queue();
  final Queue<Completer<LoginOtpResult>> loginResponses = Queue();
  Completer<void>? logoutResponse;

  HbUser? persistedUser;
  HbUser? cachedUser;
  int isAuthenticatedCalls = 0;
  int currentUserCalls = 0;
  int loginCalls = 0;
  int logoutCalls = 0;
  int clearLocalCalls = 0;
  int persistCalls = 0;
  final clearObserved = Completer<void>();
  final loginStarted = Completer<void>();
  final logoutStarted = Completer<void>();

  @override
  Future<bool> isAuthenticated() async {
    isAuthenticatedCalls++;
    if (authenticatedResponses.isNotEmpty) {
      return authenticatedResponses.removeFirst().future;
    }
    return persistedUser != null;
  }

  @override
  Future<HbUser?> getCurrentUser() async {
    currentUserCalls++;
    if (currentUserResponses.isNotEmpty) {
      cachedUser = await currentUserResponses.removeFirst().future;
    }
    return cachedUser ?? persistedUser;
  }

  @override
  Future<LoginOtpResult> login({
    required String email,
    required String password,
  }) async {
    loginCalls++;
    if (!loginStarted.isCompleted) loginStarted.complete();
    final result = await loginResponses.removeFirst().future;
    final user = result.authResult?.user;
    if (user != null) {
      persistedUser = user;
      cachedUser = user;
    }
    return result;
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
    if (!logoutStarted.isCompleted) logoutStarted.complete();
    final response = logoutResponse;
    if (response != null) await response.future;
    persistedUser = null;
    cachedUser = null;
  }

  @override
  Future<void> clearLocalAuthData() async {
    clearLocalCalls++;
    persistedUser = null;
    cachedUser = null;
    if (!clearObserved.isCompleted) clearObserved.complete();
  }

  @override
  Future<void> persistUser(HbUser user) async {
    persistCalls++;
    persistedUser = user;
    cachedUser = user;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoopDeviceTokenDataSource extends DeviceTokenDataSource {
  _NoopDeviceTokenDataSource() : super(Dio());

  @override
  Future<bool> unregisterAllTokens() async => true;
}

Future<void> _flush() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

ProviderContainer _container(_ControlledAuthRepository repository) {
  return ProviderContainer(
    overrides: [
      analyticsServiceProvider.overrideWithValue(const NoopAnalyticsService()),
      authRepositoryProvider.overrideWithValue(repository),
      deviceTokenDataSourceProvider.overrideWithValue(
        _NoopDeviceTokenDataSource(),
      ),
    ],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('late cold-start rehydrate cannot replace a directly adopted account',
      () async {
    final repository = _ControlledAuthRepository()
      ..persistedUser = _accountA
      ..authenticatedResponses.add(Completer<bool>()..complete(true));
    final oldRehydrate = Completer<HbUser?>();
    repository.currentUserResponses.add(oldRehydrate);
    final container = _container(repository);
    addTearDown(container.dispose);

    container.read(authProvider);
    await _flush();
    expect(repository.currentUserCalls, 1);

    container.read(authProvider.notifier).setAuthenticatedUser(_accountB);
    expect(container.read(authProvider).user?.id, _accountB.id);

    oldRehydrate.complete(_accountA);
    await _flush();
    await _flush();

    expect(container.read(authProvider).status, AuthStatus.authenticated);
    expect(container.read(authProvider).user?.id, _accountB.id);
    expect(repository.persistedUser?.id, _accountB.id);
  });

  test('overlapping logins publish and persist only the latest invocation',
      () async {
    final repository = _ControlledAuthRepository();
    final firstResponse = Completer<LoginOtpResult>();
    final secondResponse = Completer<LoginOtpResult>();
    repository.loginResponses
      ..add(firstResponse)
      ..add(secondResponse);
    final container = _container(repository);
    addTearDown(container.dispose);

    container.read(authProvider);
    await _flush();

    final first = container
        .read(authProvider.notifier)
        .login(email: _accountA.email, password: 'password');
    final second = container
        .read(authProvider.notifier)
        .login(email: _accountB.email, password: 'password');
    await _flush();

    expect(repository.loginCalls, 1);
    firstResponse.complete(_loginResult(_accountA));
    expect(await first, isNull);
    await _flush();

    expect(repository.loginCalls, 2);
    expect(container.read(authProvider).status, AuthStatus.loading);
    expect(container.read(authProvider).user, isNull);

    secondResponse.complete(_loginResult(_accountB));
    expect(await second, isNotNull);

    expect(container.read(authProvider).status, AuthStatus.authenticated);
    expect(container.read(authProvider).user?.id, _accountB.id);
    expect(repository.persistedUser?.id, _accountB.id);
  });

  test('force logout wins over an in-flight login and clears its late write',
      () async {
    final repository = _ControlledAuthRepository();
    final loginResponse = Completer<LoginOtpResult>();
    repository.loginResponses.add(loginResponse);
    final container = _container(repository);
    addTearDown(container.dispose);

    container.read(authProvider);
    await _flush();

    final login = container
        .read(authProvider.notifier)
        .login(email: _accountA.email, password: 'password');
    await _flush();
    await container.read(authProvider.notifier).forceLogout();

    expect(container.read(authProvider).status, AuthStatus.unauthenticated);
    expect(container.read(authProvider).user, isNull);

    loginResponse.complete(_loginResult(_accountA));
    expect(await login, isNull);
    await repository.clearObserved.future;
    await _flush();

    expect(repository.clearLocalCalls, 1);
    expect(repository.persistedUser, isNull);
    expect(container.read(authProvider).status, AuthStatus.unauthenticated);
    expect(container.read(authProvider).user, isNull);
  });

  test('a newer login waits for logout cleanup and cannot be signed out by it',
      () async {
    final repository = _ControlledAuthRepository()..persistedUser = _accountA;
    final logoutResponse = Completer<void>();
    final loginResponse = Completer<LoginOtpResult>();
    repository
      ..logoutResponse = logoutResponse
      ..loginResponses.add(loginResponse);
    final container = _container(repository);
    addTearDown(container.dispose);

    container.read(authProvider);
    await _flush();
    container.read(authProvider.notifier).setAuthenticatedUser(_accountA);
    await _flush();

    final logout = container.read(authProvider.notifier).logout();
    await repository.logoutStarted.future;
    expect(repository.logoutCalls, 1);

    final login = container
        .read(authProvider.notifier)
        .login(email: _accountB.email, password: 'password');
    await _flush();
    expect(repository.loginCalls, 0);
    expect(container.read(authProvider).user, isNull);

    logoutResponse.complete();
    await repository.loginStarted.future;
    expect(repository.loginCalls, 1);

    loginResponse.complete(_loginResult(_accountB));
    await logout;
    expect(await login, isNotNull);

    expect(container.read(authProvider).status, AuthStatus.authenticated);
    expect(container.read(authProvider).user?.id, _accountB.id);
    expect(repository.persistedUser?.id, _accountB.id);
  });

  test('refresh waits for an in-flight login before reading stored auth',
      () async {
    final repository = _ControlledAuthRepository();
    final loginResponse = Completer<LoginOtpResult>();
    repository.loginResponses.add(loginResponse);
    final container = _container(repository);
    addTearDown(container.dispose);

    container.read(authProvider);
    await _flush();
    final initialAuthChecks = repository.isAuthenticatedCalls;

    final login = container
        .read(authProvider.notifier)
        .login(email: _accountA.email, password: 'password');
    await _flush();
    final refresh = container.read(authProvider.notifier).refreshAuthStatus();
    await _flush();

    expect(repository.isAuthenticatedCalls, initialAuthChecks);
    loginResponse.complete(_loginResult(_accountA));
    expect(await login, isNull);
    await refresh;

    expect(repository.isAuthenticatedCalls, initialAuthChecks + 1);
    expect(container.read(authProvider).status, AuthStatus.authenticated);
    expect(container.read(authProvider).user?.id, _accountA.id);
    expect(repository.persistedUser?.id, _accountA.id);
  });
}

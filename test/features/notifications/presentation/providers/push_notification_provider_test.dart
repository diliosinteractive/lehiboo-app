import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/core/services/deep_link_service.dart';
import 'package:lehiboo/core/services/push_notification_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/data/models/auth_response_dto.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/notifications/data/datasources/device_token_datasource.dart';
import 'package:lehiboo/features/notifications/presentation/providers/push_notification_provider.dart';
import 'package:lehiboo/features/profile/data/datasources/profile_api_datasource.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  markOneSignalConfigured();

  test('requestPermission converts SDK exceptions into a stable failure state',
      () async {
    final router = _router();
    addTearDown(router.dispose);
    final service = _ThrowingPushNotificationService(router);
    final setup = _container(
      service: service,
      dataSource: _ControlledDeviceTokenDataSource(),
      initialUser: _accountA,
    );
    addTearDown(setup.container.dispose);

    // Let automatic account initialization fail once, then exercise the
    // explicit permission path independently.
    await _pumpAsync();
    final result = await setup.container
        .read(pushNotificationProvider.notifier)
        .requestPermission();
    final state = setup.container.read(pushNotificationProvider);

    expect(result, isFalse);
    expect(state.status, PushNotificationStatus.error);
    expect(state.failureReason, PushNotificationFailureReason.unexpected);
  });

  test('A to B serializes OneSignal identity and ignores the old callback',
      () async {
    final router = _router();
    addTearDown(router.dispose);
    final service = _ControlledPushNotificationService(router);
    final accountABind = Completer<void>();
    service.bindGates['external-a'] = accountABind;
    final dataSource = _ControlledDeviceTokenDataSource(autoComplete: true);
    final setup = _container(
      service: service,
      dataSource: dataSource,
      initialUser: _accountA,
    );
    addTearDown(setup.container.dispose);
    setup.container
        .listen(pushNotificationProvider, (_, __) {}, fireImmediately: true);

    await _pumpUntil(() => service.operations.contains('bind:external-a'));
    final accountACallback = service.onSubscriptionReceived;
    expect(accountACallback, isNotNull);

    setup.auth.setUser(_accountB);

    // User-visible state is cleared in the same auth notification, before the
    // in-flight account-A SDK call is allowed to finish.
    expect(
      setup.container.read(pushNotificationProvider).status,
      PushNotificationStatus.uninitialized,
    );

    accountABind.complete();
    await _pumpUntil(() => service.boundExternalId == 'external-b');
    await _pumpUntil(() => dataSource.requests.isNotEmpty);

    expect(service.boundExternalId, 'external-b');
    expect(
        service.operations,
        containsAllInOrder([
          'unbind',
          'bind:external-a',
          'unbind',
          'bind:external-b',
        ]));
    expect(
      dataSource.requests.map((request) => request.externalUserId),
      everyElement('external-b'),
    );

    final requestCount = dataSource.requests.length;
    await accountACallback!.call('stale-account-a-subscription');
    await _pumpAsync();
    expect(dataSource.requests, hasLength(requestCount));
  });

  test('A token cancellation settles before B binds and registers', () async {
    final router = _router();
    addTearDown(router.dispose);
    final service = _ControlledPushNotificationService(router);
    final cancellationGate = Completer<void>();
    final dataSource = _ControlledDeviceTokenDataSource(
      cancellationGate: cancellationGate,
    );
    final setup = _container(
      service: service,
      dataSource: dataSource,
      initialUser: _accountA,
    );
    addTearDown(setup.container.dispose);
    setup.container
        .listen(pushNotificationProvider, (_, __) {}, fireImmediately: true);

    await _pumpUntil(() => dataSource.requests.length == 1);
    final accountARequest = dataSource.requests.single;
    expect(accountARequest.externalUserId, 'external-a');

    setup.auth.setUser(_accountB);
    expect(accountARequest.cancelToken?.isCancelled, isTrue);
    expect(
      setup.container.read(pushNotificationProvider).status,
      PushNotificationStatus.uninitialized,
    );

    await _pumpUntil(() => accountARequest.cancellationObserved);
    expect(service.boundExternalId, isNull);
    expect(service.operations, isNot(contains('bind:external-b')));
    expect(dataSource.requests, hasLength(1));

    cancellationGate.complete();
    await _pumpUntil(() => accountARequest.settledByCancellation);
    await _pumpUntil(() => dataSource.requests.length == 2);
    final accountBRequest = dataSource.requests.last;
    expect(accountBRequest.externalUserId, 'external-b');
    accountBRequest.response.complete(_tokenResult('account-b-token'));
    await _pumpUntil(
      () =>
          setup.container.read(pushNotificationProvider).status ==
          PushNotificationStatus.initialized,
    );

    final state = setup.container.read(pushNotificationProvider);
    expect(state.status, PushNotificationStatus.initialized);
    expect(state.subscriptionId, 'subscription-1');
    expect(service.boundExternalId, 'external-b');
  });

  test('logout clears state and detaches callbacks synchronously', () async {
    final router = _router();
    addTearDown(router.dispose);
    final service = _ControlledPushNotificationService(router);
    final dataSource = _ControlledDeviceTokenDataSource(autoComplete: true);
    final setup = _container(
      service: service,
      dataSource: dataSource,
      initialUser: _accountA,
    );
    addTearDown(setup.container.dispose);
    setup.container
        .listen(pushNotificationProvider, (_, __) {}, fireImmediately: true);
    await _pumpUntil(
      () =>
          setup.container.read(pushNotificationProvider).status ==
          PushNotificationStatus.initialized,
    );

    setup.auth.setUser(null);

    expect(
      setup.container.read(pushNotificationProvider).status,
      PushNotificationStatus.uninitialized,
    );
    expect(service.onSubscriptionReceived, isNull);
    expect(service.onSubscriptionRemoved, isNull);
    await _pumpUntil(() => service.boundExternalId == null);
  });

  test('requestPermission prompts when registered but OS permission is missing',
      () async {
    final router = _router();
    addTearDown(router.dispose);
    // Android hands out a subscription id before the permission is granted,
    // so the account registers and reaches `initialized` without it.
    final service = _ControlledPushNotificationService(router)
      ..permissionGranted = false;
    final setup = _container(
      service: service,
      dataSource: _ControlledDeviceTokenDataSource(autoComplete: true),
      initialUser: _accountA,
    );
    addTearDown(setup.container.dispose);
    setup.container
        .listen(pushNotificationProvider, (_, __) {}, fireImmediately: true);
    await _pumpUntil(
      () =>
          setup.container.read(pushNotificationProvider).status ==
          PushNotificationStatus.initialized,
    );
    final notifier = setup.container.read(pushNotificationProvider.notifier);
    expect(notifier.isEnabled, isFalse);

    final result = await notifier.requestPermission();

    expect(result, isTrue);
    expect(service.operations, contains('prompt'));
    expect(notifier.isEnabled, isTrue);
  });

  test('requestPermission does not prompt when push is already enabled',
      () async {
    final router = _router();
    addTearDown(router.dispose);
    final service = _ControlledPushNotificationService(router);
    final setup = _container(
      service: service,
      dataSource: _ControlledDeviceTokenDataSource(autoComplete: true),
      initialUser: _accountA,
    );
    addTearDown(setup.container.dispose);
    setup.container
        .listen(pushNotificationProvider, (_, __) {}, fireImmediately: true);
    await _pumpUntil(
      () =>
          setup.container.read(pushNotificationProvider).status ==
          PushNotificationStatus.initialized,
    );

    final result = await setup.container
        .read(pushNotificationProvider.notifier)
        .requestPermission();

    expect(result, isTrue);
    expect(service.operations, isNot(contains('prompt')));
  });

  test('a permission revoked in the system settings disables push', () async {
    final router = _router();
    addTearDown(router.dispose);
    final service = _ControlledPushNotificationService(router);
    final setup = _container(
      service: service,
      dataSource: _ControlledDeviceTokenDataSource(autoComplete: true),
      initialUser: _accountA,
    );
    addTearDown(setup.container.dispose);
    setup.container
        .listen(pushNotificationProvider, (_, __) {}, fireImmediately: true);
    await _pumpUntil(
      () => setup.container.read(pushNotificationProvider).isEnabled,
    );
    expect(setup.container.read(isPushEnabledProvider), isTrue);

    // OneSignal's permission observer fires when the user switches
    // notifications off in the Android settings.
    service.permissionGranted = false;
    service.onPermissionChanged!(false);

    final state = setup.container.read(pushNotificationProvider);
    expect(state.status, PushNotificationStatus.initialized);
    expect(state.isEnabled, isFalse);
    expect(setup.container.read(isPushEnabledProvider), isFalse);
  });

  test('a refused prompt disables push until granted in the system settings',
      () async {
    final router = _router();
    addTearDown(router.dispose);
    final service = _ControlledPushNotificationService(router)
      ..permissionGranted = false
      ..promptResult = false;
    final setup = _container(
      service: service,
      dataSource: _ControlledDeviceTokenDataSource(autoComplete: true),
      initialUser: _accountA,
    );
    addTearDown(setup.container.dispose);
    setup.container
        .listen(pushNotificationProvider, (_, __) {}, fireImmediately: true);
    await _pumpUntil(
      () =>
          setup.container.read(pushNotificationProvider).status ==
          PushNotificationStatus.initialized,
    );

    final granted = await setup.container
        .read(pushNotificationProvider.notifier)
        .requestPermission();

    var state = setup.container.read(pushNotificationProvider);
    expect(granted, isFalse);
    expect(state.status, PushNotificationStatus.disabled);
    expect(state.failureReason, PushNotificationFailureReason.permissionDenied);
    expect(state.isEnabled, isFalse);

    // The user then enables notifications from the Android settings.
    service.permissionGranted = true;
    service.onPermissionChanged!(true);
    await _pumpUntil(
      () => setup.container.read(pushNotificationProvider).isEnabled,
    );

    state = setup.container.read(pushNotificationProvider);
    expect(state.status, PushNotificationStatus.initialized);
    expect(state.failureReason, isNull);
  });

  test('a session without external id fetches it from /auth/me and binds it',
      () async {
    final router = _router();
    addTearDown(router.dispose);
    final service = _ControlledPushNotificationService(router);
    final profileApi = _ProfileApiReturning(
      const UserDto(
        id: 7,
        email: 'legacy@example.test',
        displayName: 'Legacy Account',
        role: 'subscriber',
        onesignalId: 'external-legacy',
      ),
    );
    final setup = _container(
      service: service,
      dataSource: _ControlledDeviceTokenDataSource(autoComplete: true),
      initialUser: _legacyAccount,
      profileApi: profileApi,
    );
    addTearDown(setup.container.dispose);
    setup.container
        .listen(pushNotificationProvider, (_, __) {}, fireImmediately: true);

    await _pumpUntil(() => service.boundExternalId == 'external-legacy');

    expect(profileApi.calls, 1);
    expect(setup.auth.state.user?.onesignalId, 'external-legacy');
  });
}

GoRouter _router() => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );

Future<void> _pumpAsync() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

Future<void> _pumpUntil(bool Function() predicate) async {
  for (var attempt = 0; attempt < 100 && !predicate(); attempt++) {
    await _pumpAsync();
  }
  expect(predicate(), isTrue);
}

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

const _accountA = HbUser(
  id: 'account-a',
  email: 'a@example.test',
  displayName: 'Account A',
  onesignalId: 'external-a',
);

const _accountB = HbUser(
  id: 'account-b',
  email: 'b@example.test',
  displayName: 'Account B',
  onesignalId: 'external-b',
);

const _legacyAccount = HbUser(
  id: '7',
  email: 'legacy@example.test',
  displayName: 'Legacy Account',
);

({
  ProviderContainer container,
  _TestAuthNotifier auth,
}) _container({
  required PushNotificationService service,
  required DeviceTokenDataSource dataSource,
  required HbUser? initialUser,
  ProfileApiDataSource? profileApi,
}) {
  late _TestAuthNotifier auth;
  final container = ProviderContainer(
    overrides: [
      authProvider.overrideWith((ref) {
        auth = _TestAuthNotifier(ref, initialUser);
        return auth;
      }),
      analyticsServiceProvider.overrideWithValue(const NoopAnalyticsService()),
      pushNotificationServiceProvider.overrideWithValue(service),
      deviceTokenDataSourceProvider.overrideWithValue(dataSource),
      if (profileApi != null)
        profileApiDataSourceProvider.overrideWithValue(profileApi),
    ],
  );
  container.read(authProvider);
  return (container: container, auth: auth);
}

class _ThrowingPushNotificationService extends PushNotificationService {
  _ThrowingPushNotificationService(GoRouter router)
      : super(
          deepLinkService: DeepLinkService(router: router),
          analytics: const NoopAnalyticsService(),
        );

  @override
  bool get isInitialized => false;

  @override
  Future<void> initialize() =>
      Future<void>.error(StateError('technical SDK failure'));

  @override
  Future<void> bindUser(String externalId) async {}

  @override
  Future<void> unbindUser() async {}
}

class _ControlledPushNotificationService extends PushNotificationService {
  _ControlledPushNotificationService(GoRouter router)
      : super(
          deepLinkService: DeepLinkService(router: router),
          analytics: const NoopAnalyticsService(),
        );

  final List<String> operations = [];
  final Map<String, Completer<void>> bindGates = {};
  String? boundExternalId;
  bool initialized = false;
  bool permissionGranted = true;

  @override
  String? get subscriptionId => 'subscription-1';

  @override
  bool get hasPermission => permissionGranted;

  /// What the user answers to the OS permission prompt.
  bool promptResult = true;

  @override
  bool get permissionDenied => !permissionGranted;

  @override
  Future<bool> promptUserForPermission() async {
    operations.add('prompt');
    permissionGranted = promptResult;
    return promptResult;
  }

  @override
  bool get isInitialized => initialized;

  @override
  Future<void> initialize() async {
    initialized = true;
  }

  @override
  Future<void> bindUser(String externalId) async {
    operations.add('bind:$externalId');
    final gate = bindGates[externalId];
    if (gate != null) await gate.future;
    boundExternalId = externalId;
  }

  @override
  Future<void> unbindUser() async {
    operations.add('unbind');
    boundExternalId = null;
  }

  @override
  Future<String?> ensureSubscriptionId() async => subscriptionId;

  @override
  Future<String> getDeviceId() async => 'device-1';

  @override
  Future<String> getDeviceName() async => 'Test device';

  @override
  String getPlatform() => 'android';
}

class _TokenRequest {
  _TokenRequest({
    required this.externalUserId,
    required this.cancelToken,
  });

  final String? externalUserId;
  final CancelToken? cancelToken;
  final Completer<DeviceTokenResult> response = Completer();
  bool cancellationObserved = false;
  bool settledByCancellation = false;
}

class _ControlledDeviceTokenDataSource extends DeviceTokenDataSource {
  _ControlledDeviceTokenDataSource({
    this.autoComplete = false,
    this.cancellationGate,
  }) : super(Dio());

  final bool autoComplete;
  final Completer<void>? cancellationGate;
  final List<_TokenRequest> requests = [];

  @override
  Future<DeviceTokenResult> registerToken({
    required String token,
    required String platform,
    required String provider,
    String? subscriptionId,
    String? externalUserId,
    String? deviceId,
    String? deviceName,
    String? appVersion,
    CancelToken? cancelToken,
  }) {
    final request = _TokenRequest(
      externalUserId: externalUserId,
      cancelToken: cancelToken,
    );
    requests.add(request);
    final cancellation = cancelToken?.whenCancel;
    if (cancellation != null) {
      unawaited(cancellation.then((error) async {
        if (request.response.isCompleted) return;
        request.cancellationObserved = true;
        await cancellationGate?.future;
        if (request.response.isCompleted) return;
        request.settledByCancellation = true;
        request.response.completeError(error);
      }));
    }
    if (autoComplete) request.response.complete(_tokenResult('token'));
    return request.response.future;
  }

  @override
  Future<bool> unregisterToken(
    String token, {
    CancelToken? cancelToken,
  }) async =>
      true;
}

class _ProfileApiReturning extends ProfileApiDataSource {
  _ProfileApiReturning(this.user) : super(Dio());

  final UserDto user;
  int calls = 0;

  @override
  Future<UserDto> getProfile() async {
    calls++;
    return user;
  }
}

DeviceTokenResult _tokenResult(String uuid) => DeviceTokenResult(
      uuid: uuid,
      platform: 'android',
      isActive: true,
    );

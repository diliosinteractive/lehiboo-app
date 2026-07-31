import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/services/push_notification_service.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/device_token_datasource.dart';

/// State for push notification initialization
enum PushNotificationStatus {
  uninitialized,
  initializing,
  initialized,
  disabled,
  error,
}

/// Stable, presentation-safe reason for a failed push-notification setup.
///
/// Provider/SDK diagnostics stay in debug logs. Screens use this enum to show
/// localized guidance without exposing OneSignal or backend implementation
/// details to users.
enum PushNotificationFailureReason {
  serviceUnavailable,
  permissionDenied,
  subscriptionUnavailable,
  backendSyncFailed,
  unexpected,
}

class PushNotificationState {
  final PushNotificationStatus status;
  final String? subscriptionId;
  final PushNotificationFailureReason? failureReason;

  const PushNotificationState({
    this.status = PushNotificationStatus.uninitialized,
    this.subscriptionId,
    this.failureReason,
  });

  PushNotificationState copyWith({
    PushNotificationStatus? status,
    String? subscriptionId,
    PushNotificationFailureReason? failureReason,
  }) {
    return PushNotificationState(
      status: status ?? this.status,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      failureReason: failureReason,
    );
  }
}

const String _oneSignalProvider = 'onesignal';

/// Provider that manages push notification state
final pushNotificationProvider =
    StateNotifierProvider<PushNotificationNotifier, PushNotificationState>(
        (ref) {
  return PushNotificationNotifier(ref);
});

/// Notifier that handles push notification lifecycle
class PushNotificationNotifier extends StateNotifier<PushNotificationState> {
  final Ref _ref;
  int _generation = 0;
  bool _disposed = false;
  bool _hasObservedAuth = false;
  _PushAccount? _account;
  Future<void> _identityTail = Future<void>.value();
  final Set<CancelToken> _activeTokenRequests = {};
  final Set<Future<bool>> _activeRegistrationTasks = {};
  final Map<String, Future<bool>> _registrationTasks = {};
  String? _lastSuccessfulRegistration;

  PushNotificationNotifier(this._ref) : super(const PushNotificationState()) {
    final service = _ref.read(pushNotificationServiceProvider);
    _ref.onDispose(() {
      _disposed = true;
      _generation++;
      _cancelTokenRequests();
      service.onSubscriptionReceived = null;
      service.onSubscriptionRemoved = null;
    });
    _ref.listen<AuthState>(authProvider, (_, next) => _replaceAccount(next));
    _replaceAccount(_ref.read(authProvider));
  }

  void _replaceAccount(AuthState auth) {
    final next = _PushAccount.fromAuth(auth);
    final service = _ref.read(pushNotificationServiceProvider);
    service.updateActiveRecipient(next?.recipientIdentity);
    if (_hasObservedAuth && next == _account) return;
    _hasObservedAuth = true;

    final generation = ++_generation;
    _account = next;
    _lastSuccessfulRegistration = null;
    final supersededRegistrations = List<Future<bool>>.of(
      _activeRegistrationTasks,
    );
    _registrationTasks.clear();
    _cancelTokenRequests();
    state = const PushNotificationState();

    service.onSubscriptionReceived = null;
    service.onSubscriptionRemoved = null;

    final previousIdentityWork = _identityTail;
    Future<void> applyIdentity() async {
      // Every identity transition starts with logout. If an older login was
      // already in flight, this serialized logout runs after it and guarantees
      // that account A cannot remain bound when B becomes active.
      await service.unbindUser();
      await Future.wait<void>(
        supersededRegistrations.map(
          (task) => task.then<void>((_) {}, onError: (_) {}),
        ),
      );
      if (!_isCurrent(next, generation)) return;

      final externalId = next?.externalId;
      if (externalId != null) {
        await service.bindUser(externalId);
      } else if (next != null) {
        debugPrint(
          'PushNotification: user ${next.accountId} has no OneSignal external id',
        );
      }
    }

    final identityReady = previousIdentityWork.then<void>(
      (_) => applyIdentity(),
      onError: (_) => applyIdentity(),
    );
    _identityTail = identityReady;

    if (next == null) return;
    _configureCallbacks(service, next, generation, identityReady);
    unawaited(identityReady.then<void>(
      (_) async {
        if (_isCurrent(next, generation)) {
          await _initializeFor(next, generation);
        }
      },
      onError: (error) {
        if (_isCurrent(next, generation)) {
          debugPrint('PushNotification: identity binding failed - $error');
          state = const PushNotificationState(
            status: PushNotificationStatus.error,
            failureReason: PushNotificationFailureReason.unexpected,
          );
        }
      },
    ));
  }

  bool _isCurrent(_PushAccount? expected, int generation) {
    if (_disposed || generation != _generation || _account != expected) {
      return false;
    }
    return _PushAccount.fromAuth(_ref.read(authProvider)) == expected;
  }

  void _cancelTokenRequests() {
    for (final token in _activeTokenRequests) {
      if (!token.isCancelled) token.cancel('Authentication account changed');
    }
    _activeTokenRequests.clear();
  }

  void _configureCallbacks(
    PushNotificationService service,
    _PushAccount account,
    int generation,
    Future<void> identityReady,
  ) {
    service.onSubscriptionReceived = (subscriptionId) async {
      await identityReady;
      if (!_isCurrent(account, generation)) return;
      await _registerTokenWithBackend(
        subscriptionId,
        service,
        account,
        generation,
      );
    };

    service.onSubscriptionRemoved = (subscriptionId) async {
      await identityReady;
      if (!_isCurrent(account, generation)) return;
      final cancelToken = CancelToken();
      _activeTokenRequests.add(cancelToken);
      try {
        if (!_isCurrent(account, generation)) return;
        await _ref.read(deviceTokenDataSourceProvider).unregisterToken(
              subscriptionId,
              cancelToken: cancelToken,
            );
      } on DioException catch (error) {
        if (!CancelToken.isCancel(error)) {
          debugPrint('PushNotification: token unregister failed - $error');
        }
      } finally {
        _activeTokenRequests.remove(cancelToken);
      }
    };
  }

  /// Initialize push notifications for the exact account that requested it.
  Future<void> initialize() async {
    final account = _account;
    final generation = _generation;
    final identityReady = _identityTail;
    if (account == null || !_isCurrent(account, generation)) return;
    await identityReady;
    if (_isCurrent(account, generation)) {
      await _initializeFor(account, generation);
    }
  }

  Future<void> _initializeFor(
    _PushAccount account,
    int generation,
  ) async {
    if (!_isCurrent(account, generation)) return;
    if (!isOneSignalConfigured) {
      state = const PushNotificationState(
        status: PushNotificationStatus.disabled,
        failureReason: PushNotificationFailureReason.serviceUnavailable,
      );
      return;
    }
    if (state.status == PushNotificationStatus.initializing ||
        state.status == PushNotificationStatus.initialized) {
      return;
    }

    state = const PushNotificationState(
      status: PushNotificationStatus.initializing,
    );
    try {
      final service = _ref.read(pushNotificationServiceProvider);
      await service.initialize();
      if (!_isCurrent(account, generation)) return;

      final subscriptionId = service.subscriptionId;
      if (subscriptionId == null) {
        state = PushNotificationState(
          status: PushNotificationStatus.disabled,
          failureReason: service.permissionDenied
              ? PushNotificationFailureReason.permissionDenied
              : null,
        );
        return;
      }

      final registered = await _registerTokenWithBackend(
        subscriptionId,
        service,
        account,
        generation,
      );
      if (!_isCurrent(account, generation)) return;
      if (!registered) {
        state = const PushNotificationState(
          status: PushNotificationStatus.error,
          failureReason: PushNotificationFailureReason.backendSyncFailed,
        );
        return;
      }

      state = PushNotificationState(
        status: PushNotificationStatus.initialized,
        subscriptionId: subscriptionId,
      );
    } catch (error) {
      if (!_isCurrent(account, generation)) return;
      debugPrint('PushNotification: Failed to initialize - $error');
      state = const PushNotificationState(
        status: PushNotificationStatus.error,
        failureReason: PushNotificationFailureReason.unexpected,
      );
    }
  }

  /// Force a fresh backend registration for the current subscription.
  Future<bool> syncTokenWithBackend() async {
    final account = _account;
    final generation = _generation;
    final identityReady = _identityTail;
    if (account == null || !_isCurrent(account, generation)) return false;
    if (state.status == PushNotificationStatus.initializing) return false;
    if (!isOneSignalConfigured) {
      state = const PushNotificationState(
        status: PushNotificationStatus.disabled,
        failureReason: PushNotificationFailureReason.serviceUnavailable,
      );
      return false;
    }

    state = const PushNotificationState(
      status: PushNotificationStatus.initializing,
    );
    try {
      await identityReady;
      if (!_isCurrent(account, generation)) return false;
      final service = _ref.read(pushNotificationServiceProvider);
      if (!service.isInitialized) {
        await service.initialize();
      } else {
        await service.ensureSubscriptionId();
      }
      if (!_isCurrent(account, generation)) return false;

      final subscriptionId = service.subscriptionId;
      if (subscriptionId == null) {
        state = PushNotificationState(
          status: service.permissionDenied
              ? PushNotificationStatus.disabled
              : PushNotificationStatus.error,
          failureReason: service.permissionDenied
              ? PushNotificationFailureReason.permissionDenied
              : PushNotificationFailureReason.subscriptionUnavailable,
        );
        return false;
      }

      final registered = await _registerTokenWithBackend(
        subscriptionId,
        service,
        account,
        generation,
        force: true,
      );
      if (!_isCurrent(account, generation)) return false;
      state = registered
          ? PushNotificationState(
              status: PushNotificationStatus.initialized,
              subscriptionId: subscriptionId,
            )
          : const PushNotificationState(
              status: PushNotificationStatus.error,
              failureReason: PushNotificationFailureReason.backendSyncFailed,
            );
      return registered;
    } catch (error) {
      if (!_isCurrent(account, generation)) return false;
      debugPrint('PushNotification: Failed to sync subscription - $error');
      state = const PushNotificationState(
        status: PushNotificationStatus.error,
        failureReason: PushNotificationFailureReason.unexpected,
      );
      return false;
    }
  }

  Future<bool> _registerTokenWithBackend(
    String subscriptionId,
    PushNotificationService service,
    _PushAccount account,
    int generation, {
    bool force = false,
  }) {
    final registrationKey = '$generation:${account.accountId}:$subscriptionId';
    if (!force && _lastSuccessfulRegistration == registrationKey) {
      return Future<bool>.value(true);
    }
    final existing = _registrationTasks[registrationKey];
    if (!force && existing != null) return existing;

    final task = _performTokenRegistration(
      subscriptionId,
      service,
      account,
      generation,
    );
    _activeRegistrationTasks.add(task);
    if (!force) _registrationTasks[registrationKey] = task;
    void removeCompletedTask() {
      _activeRegistrationTasks.remove(task);
      if (_registrationTasks[registrationKey] == task) {
        _registrationTasks.remove(registrationKey);
      }
    }

    unawaited(task.then<void>(
      (_) => removeCompletedTask(),
      onError: (_) => removeCompletedTask(),
    ));
    return task;
  }

  Future<bool> _performTokenRegistration(
    String subscriptionId,
    PushNotificationService service,
    _PushAccount account,
    int generation,
  ) async {
    if (!_isCurrent(account, generation)) return false;
    String appVersion = '1.0.0';
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;
    } catch (_) {}
    if (!_isCurrent(account, generation)) return false;

    late final String deviceId;
    late final String deviceName;
    late final String platform;
    try {
      deviceId = await service.getDeviceId();
      if (!_isCurrent(account, generation)) return false;
      deviceName = await service.getDeviceName();
      if (!_isCurrent(account, generation)) return false;
      platform = service.getPlatform();
    } catch (error) {
      if (_isCurrent(account, generation)) {
        debugPrint('PushNotification: Failed to read device metadata - $error');
      }
      return false;
    }

    debugPrint('PushNotification → POST /auth/device-tokens payload: '
        'provider=$_oneSignalProvider, platform=$platform, '
        'subscription_id=$subscriptionId, '
        'external_user_id=${account.externalId ?? "<null>"}, '
        'user.id=${account.accountId}, device_id=$deviceId, '
        'device_name=$deviceName, app_version=$appVersion');

    const maxAttempts = 3;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      if (!_isCurrent(account, generation)) return false;
      final cancelToken = CancelToken();
      _activeTokenRequests.add(cancelToken);
      try {
        final result =
            await _ref.read(deviceTokenDataSourceProvider).registerToken(
                  token: subscriptionId,
                  provider: _oneSignalProvider,
                  platform: platform,
                  subscriptionId: subscriptionId,
                  externalUserId: account.externalId,
                  deviceId: deviceId,
                  deviceName: deviceName,
                  appVersion: appVersion,
                  cancelToken: cancelToken,
                );
        if (!_isCurrent(account, generation)) return false;
        _lastSuccessfulRegistration =
            '$generation:${account.accountId}:$subscriptionId';
        debugPrint(
          'PushNotification: Token registered '
          '(server uuid=${result.uuid}, active=${result.isActive})',
        );
        return true;
      } on DioException catch (error) {
        if (CancelToken.isCancel(error) || !_isCurrent(account, generation)) {
          return false;
        }
        final status = error.response?.statusCode ?? 0;
        final retryable = status >= 500 && status < 600;
        if (retryable && attempt < maxAttempts) {
          final delay = Duration(seconds: 1 << (attempt - 1));
          await Future<void>.delayed(delay);
          continue;
        }
        debugPrint(
          'PushNotification: Failed to register token with backend '
          '(status=$status, body=${error.response?.data}) - $error',
        );
        return false;
      } catch (error) {
        if (!_isCurrent(account, generation)) return false;
        debugPrint(
          'PushNotification: Failed to register token with backend - $error',
        );
        return false;
      } finally {
        _activeTokenRequests.remove(cancelToken);
      }
    }
    return false;
  }

  /// Immediately detaches callbacks/state, then serially logs out of OneSignal.
  Future<void> unregister() async {
    final generation = ++_generation;
    _account = null;
    _lastSuccessfulRegistration = null;
    final supersededRegistrations = List<Future<bool>>.of(
      _activeRegistrationTasks,
    );
    _registrationTasks.clear();
    _cancelTokenRequests();
    state = const PushNotificationState();
    final service = _ref.read(pushNotificationServiceProvider);
    service.onSubscriptionReceived = null;
    service.onSubscriptionRemoved = null;
    final previousIdentityWork = _identityTail;
    Future<void> detachIdentity() async {
      await service.unbindUser();
      await Future.wait<void>(
        supersededRegistrations.map(
          (task) => task.then<void>((_) {}, onError: (_) {}),
        ),
      );
    }

    _identityTail = previousIdentityWork.then<void>(
      (_) => detachIdentity(),
      onError: (_) => detachIdentity(),
    );
    await _identityTail;
    if (!_disposed && generation == _generation) {
      debugPrint('PushNotification: Unregistered');
    }
  }

  bool get isEnabled => state.status == PushNotificationStatus.initialized;

  /// Ask for OS permission and register only for the initiating account.
  Future<bool> requestPermission() async {
    final account = _account;
    final generation = _generation;
    final identityReady = _identityTail;
    if (account == null || !_isCurrent(account, generation)) return false;
    if (state.status == PushNotificationStatus.initialized) return true;
    if (state.status == PushNotificationStatus.initializing) return false;
    if (!isOneSignalConfigured) {
      state = const PushNotificationState(
        status: PushNotificationStatus.disabled,
        failureReason: PushNotificationFailureReason.serviceUnavailable,
      );
      return false;
    }

    state = const PushNotificationState(
      status: PushNotificationStatus.initializing,
    );
    try {
      await identityReady;
      if (!_isCurrent(account, generation)) return false;
      final service = _ref.read(pushNotificationServiceProvider);
      if (!service.isInitialized) await service.initialize();
      if (!_isCurrent(account, generation)) return false;

      final granted = await service.promptUserForPermission();
      if (!_isCurrent(account, generation)) return false;
      if (!granted) {
        state = PushNotificationState(
          status: PushNotificationStatus.disabled,
          failureReason: service.permissionDenied
              ? PushNotificationFailureReason.permissionDenied
              : PushNotificationFailureReason.unexpected,
        );
        return false;
      }

      final subscriptionId = service.subscriptionId;
      if (subscriptionId == null) {
        state = const PushNotificationState(
          status: PushNotificationStatus.disabled,
          failureReason: PushNotificationFailureReason.subscriptionUnavailable,
        );
        return false;
      }

      final registered = await _registerTokenWithBackend(
        subscriptionId,
        service,
        account,
        generation,
      );
      if (!_isCurrent(account, generation)) return false;
      state = registered
          ? PushNotificationState(
              status: PushNotificationStatus.initialized,
              subscriptionId: subscriptionId,
            )
          : const PushNotificationState(
              status: PushNotificationStatus.error,
              failureReason: PushNotificationFailureReason.backendSyncFailed,
            );
      return registered;
    } catch (error) {
      if (!_isCurrent(account, generation)) return false;
      debugPrint('PushNotification: Failed to request permission - $error');
      state = const PushNotificationState(
        status: PushNotificationStatus.error,
        failureReason: PushNotificationFailureReason.unexpected,
      );
      return false;
    }
  }
}

class _PushAccount {
  const _PushAccount(this.accountId, this.externalId);

  static _PushAccount? fromAuth(AuthState auth) {
    if (!auth.isAuthenticated) return null;
    final accountId = auth.user?.id.trim();
    if (accountId == null || accountId.isEmpty) return null;
    final externalId = auth.user?.onesignalId?.trim();
    return _PushAccount(
      accountId,
      externalId == null || externalId.isEmpty ? null : externalId,
    );
  }

  final String accountId;
  final String? externalId;

  PushRecipientIdentity get recipientIdentity => PushRecipientIdentity(
        accountId: accountId,
        externalId: externalId,
      );

  @override
  bool operator ==(Object other) =>
      other is _PushAccount &&
      other.accountId == accountId &&
      other.externalId == externalId;

  @override
  int get hashCode => Object.hash(accountId, externalId);
}

/// Provider to check if push notifications are enabled
final isPushEnabledProvider = Provider<bool>((ref) {
  final state = ref.watch(pushNotificationProvider);
  return state.status == PushNotificationStatus.initialized;
});

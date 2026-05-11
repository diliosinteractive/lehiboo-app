import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/services/push_notification_service.dart';
import '../../../../domain/entities/user.dart';
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

class PushNotificationState {
  final PushNotificationStatus status;
  final String? subscriptionId;
  final String? errorMessage;

  const PushNotificationState({
    this.status = PushNotificationStatus.uninitialized,
    this.subscriptionId,
    this.errorMessage,
  });

  PushNotificationState copyWith({
    PushNotificationStatus? status,
    String? subscriptionId,
    String? errorMessage,
  }) {
    return PushNotificationState(
      status: status ?? this.status,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      errorMessage: errorMessage,
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

  PushNotificationNotifier(this._ref) : super(const PushNotificationState()) {
    // Listen to auth state changes
    _ref.listen<AuthState>(authProvider, (previous, next) {
      _handleAuthStateChange(previous, next);
    });

    // Check initial auth state — covers the resume case where the app starts
    // with a session already loaded from storage.
    final authState = _ref.read(authProvider);
    if (authState.isAuthenticated) {
      _bindOneSignalIfPossible(authState.user);
      initialize();
    }
  }

  /// Handle auth state changes
  void _handleAuthStateChange(AuthState? previous, AuthState next) {
    // User just logged in
    if (previous?.status != AuthStatus.authenticated &&
        next.status == AuthStatus.authenticated) {
      debugPrint('PushNotification: User logged in, initializing');
      _bindOneSignalIfPossible(next.user);
      initialize();
    }

    // User just logged out
    if (previous?.status == AuthStatus.authenticated &&
        next.status != AuthStatus.authenticated) {
      debugPrint('PushNotification: User logged out, unregistering');
      unregister();
    }
  }

  /// Bind the device to the user's OneSignal external id, when available.
  ///
  /// The backend exposes `users.onesignal_id` (nullable). Legacy users may
  /// not have one yet — in that case we skip the binding and the device
  /// will only receive broadcasts, not user-targeted notifications.
  void _bindOneSignalIfPossible(HbUser? user) {
    final onesignalId = user?.onesignalId;
    if (user == null) {
      debugPrint('PushNotification: bind skipped — no user');
      return;
    }
    if (onesignalId == null || onesignalId.isEmpty) {
      debugPrint(
          'PushNotification: bind skipped — user.onesignal_id is null '
          '(user.id=${user.id}). User-targeted pushes will not route until '
          'the backend assigns one.');
      return;
    }
    debugPrint(
        'PushNotification: binding OneSignal external_id=$onesignalId '
        '(user.id=${user.id})');
    _ref.read(pushNotificationServiceProvider).bindUser(onesignalId);
  }

  /// Initialize push notifications
  Future<void> initialize() async {
    if (state.status == PushNotificationStatus.initializing ||
        state.status == PushNotificationStatus.initialized) {
      debugPrint('PushNotification: Already initialized or initializing');
      return;
    }

    state = state.copyWith(status: PushNotificationStatus.initializing);

    try {
      final pushService = _ref.read(pushNotificationServiceProvider);
      final tokenDataSource = _ref.read(deviceTokenDataSourceProvider);

      _configureCallbacks(pushService, tokenDataSource);

      // Initialize the push service
      await pushService.initialize();

      if (pushService.subscriptionId == null) {
        state = state.copyWith(
          status: pushService.permissionDenied
              ? PushNotificationStatus.disabled
              : PushNotificationStatus.error,
          errorMessage: pushService.permissionDenied
              ? 'Notification permission denied'
              : 'OneSignal subscription id unavailable',
        );
        return;
      }

      final registered = await _registerTokenWithBackend(
        pushService.subscriptionId!,
        pushService,
        tokenDataSource,
      );
      if (!registered) {
        state = state.copyWith(
          status: PushNotificationStatus.error,
          errorMessage: 'Backend token registration failed',
        );
        return;
      }

      state = state.copyWith(
        status: PushNotificationStatus.initialized,
        subscriptionId: pushService.subscriptionId,
      );

      debugPrint('PushNotification: Initialized successfully');
    } catch (e) {
      debugPrint('PushNotification: Failed to initialize - $e');
      state = state.copyWith(
        status: PushNotificationStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Force a fresh backend registration for the current subscription.
  ///
  /// Used after the user enables push in settings. Login normally initializes
  /// the service, but this closes the gap where permission/subscription id
  /// was not available during the earlier attempt.
  Future<bool> syncTokenWithBackend() async {
    if (state.status == PushNotificationStatus.initializing) {
      return false;
    }

    state = state.copyWith(status: PushNotificationStatus.initializing);

    try {
      final pushService = _ref.read(pushNotificationServiceProvider);
      final tokenDataSource = _ref.read(deviceTokenDataSourceProvider);
      _configureCallbacks(pushService, tokenDataSource);

      if (!pushService.isInitialized) {
        await pushService.initialize();
      } else {
        await pushService.ensureSubscriptionId();
      }

      if (pushService.subscriptionId == null) {
        state = state.copyWith(
          status: pushService.permissionDenied
              ? PushNotificationStatus.disabled
              : PushNotificationStatus.error,
          errorMessage: pushService.permissionDenied
              ? 'Notification permission denied'
              : 'OneSignal subscription id unavailable',
        );
        return false;
      }

      final registered = await _registerTokenWithBackend(
        pushService.subscriptionId!,
        pushService,
        tokenDataSource,
      );
      if (!registered) {
        state = state.copyWith(
          status: PushNotificationStatus.error,
          errorMessage: 'Backend token registration failed',
        );
        return false;
      }

      state = state.copyWith(
        status: PushNotificationStatus.initialized,
        subscriptionId: pushService.subscriptionId,
      );
      return true;
    } catch (e) {
      debugPrint('PushNotification: Failed to sync subscription - $e');
      state = state.copyWith(
        status: PushNotificationStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void _configureCallbacks(
    PushNotificationService pushService,
    DeviceTokenDataSource tokenDataSource,
  ) {
    pushService.onSubscriptionReceived = (subscriptionId) async {
      await _registerTokenWithBackend(subscriptionId, pushService, tokenDataSource);
    };

    pushService.onSubscriptionRemoved = (subscriptionId) async {
      await tokenDataSource.unregisterToken(subscriptionId);
    };
  }

  /// Register subscription id with backend, with exponential backoff on 5xx.
  Future<bool> _registerTokenWithBackend(
    String subscriptionId,
    PushNotificationService pushService,
    DeviceTokenDataSource tokenDataSource,
  ) async {
    String appVersion = '1.0.0';
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion = packageInfo.version;
    } catch (_) {}

    // `external_user_id` is the OneSignal external id assigned by the backend.
    // It can be null for legacy users — the field is then omitted from the
    // payload and the backend just won't be able to fan out by external id.
    final user = _ref.read(authProvider).user;
    final externalUserId = user?.onesignalId;
    final deviceId = await pushService.getDeviceId();
    final deviceName = await pushService.getDeviceName();
    final platform = pushService.getPlatform();

    debugPrint(
        'PushNotification → POST /auth/device-tokens payload: '
        'provider=$_oneSignalProvider, platform=$platform, '
        'subscription_id=$subscriptionId, '
        'external_user_id=${externalUserId ?? "<null>"}, '
        'user.id=${user?.id ?? "<null>"}, '
        'device_id=$deviceId, device_name=$deviceName, app_version=$appVersion');

    const maxAttempts = 3;
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final result = await tokenDataSource.registerToken(
          token: subscriptionId,
          provider: _oneSignalProvider,
          platform: platform,
          subscriptionId: subscriptionId,
          externalUserId: externalUserId,
          deviceId: deviceId,
          deviceName: deviceName,
          appVersion: appVersion,
        );
        debugPrint(
            'PushNotification: Token registered (server uuid=${result.uuid}, active=${result.isActive})');
        return true;
      } on DioException catch (e) {
        final status = e.response?.statusCode ?? 0;
        final retryable = status >= 500 && status < 600;
        if (retryable && attempt < maxAttempts) {
          final delay = Duration(seconds: 1 << (attempt - 1)); // 1s / 2s / 4s
          debugPrint(
              'PushNotification: 5xx on register (status=$status), retry $attempt/$maxAttempts after ${delay.inSeconds}s');
          await Future<void>.delayed(delay);
          continue;
        }
        debugPrint(
            'PushNotification: Failed to register token with backend (status=$status, body=${e.response?.data}) - $e');
        return false;
      } catch (e) {
        debugPrint(
            'PushNotification: Failed to register token with backend - $e');
        return false;
      }
    }
    return false;
  }

  /// Unregister push notifications (on logout).
  ///
  /// Order matters: the auth provider has already DELETEd /auth/device-tokens
  /// while the bearer was still valid. We just drop the local subscription
  /// state and call OneSignal.logout().
  Future<void> unregister() async {
    try {
      final pushService = _ref.read(pushNotificationServiceProvider);
      await pushService.unregister();
      await pushService.unbindUser();

      state = const PushNotificationState(
        status: PushNotificationStatus.uninitialized,
      );

      debugPrint('PushNotification: Unregistered');
    } catch (e) {
      debugPrint('PushNotification: Failed to unregister - $e');
    }
  }

  /// Check if push notifications are enabled
  bool get isEnabled => state.status == PushNotificationStatus.initialized;

  /// Request permission manually (if initially denied)
  Future<void> requestPermission() async {
    if (state.status != PushNotificationStatus.disabled) {
      return;
    }

    await initialize();
  }
}

/// Provider to check if push notifications are enabled
final isPushEnabledProvider = Provider<bool>((ref) {
  final state = ref.watch(pushNotificationProvider);
  return state.status == PushNotificationStatus.initialized;
});

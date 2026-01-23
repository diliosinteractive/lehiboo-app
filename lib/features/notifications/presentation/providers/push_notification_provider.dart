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

class PushNotificationState {
  final PushNotificationStatus status;
  final String? fcmToken;
  final String? errorMessage;

  const PushNotificationState({
    this.status = PushNotificationStatus.uninitialized,
    this.fcmToken,
    this.errorMessage,
  });

  PushNotificationState copyWith({
    PushNotificationStatus? status,
    String? fcmToken,
    String? errorMessage,
  }) {
    return PushNotificationState(
      status: status ?? this.status,
      fcmToken: fcmToken ?? this.fcmToken,
      errorMessage: errorMessage,
    );
  }
}

/// Provider that manages push notification state
final pushNotificationProvider =
    StateNotifierProvider<PushNotificationNotifier, PushNotificationState>((ref) {
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

    // Check initial auth state
    final authState = _ref.read(authProvider);
    if (authState.isAuthenticated) {
      initialize();
    }
  }

  /// Handle auth state changes
  void _handleAuthStateChange(AuthState? previous, AuthState next) {
    // User just logged in
    if (previous?.status != AuthStatus.authenticated &&
        next.status == AuthStatus.authenticated) {
      debugPrint('PushNotification: User logged in, initializing');
      initialize();
    }

    // User just logged out
    if (previous?.status == AuthStatus.authenticated &&
        next.status != AuthStatus.authenticated) {
      debugPrint('PushNotification: User logged out, unregistering');
      unregister();
    }
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

      // Set up callbacks for token management
      pushService.onTokenReceived = (token) async {
        await _registerTokenWithBackend(token, pushService, tokenDataSource);
      };

      pushService.onTokenRemoved = (token) async {
        await tokenDataSource.unregisterToken(token);
      };

      // Initialize the push service
      await pushService.initialize();

      state = state.copyWith(
        status: PushNotificationStatus.initialized,
        fcmToken: pushService.fcmToken,
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

  /// Register FCM token with backend
  Future<void> _registerTokenWithBackend(
    String token,
    PushNotificationService pushService,
    DeviceTokenDataSource tokenDataSource,
  ) async {
    try {
      // Get app version
      String appVersion = '1.0.0';
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        appVersion = packageInfo.version;
      } catch (_) {}

      // Register with backend
      await tokenDataSource.registerToken(
        token: token,
        platform: pushService.getPlatform(),
        deviceId: await pushService.getDeviceId(),
        deviceName: await pushService.getDeviceName(),
        appVersion: appVersion,
      );

      debugPrint('PushNotification: Token registered with backend');
    } catch (e) {
      debugPrint('PushNotification: Failed to register token with backend - $e');
    }
  }

  /// Unregister push notifications (on logout)
  Future<void> unregister() async {
    try {
      final pushService = _ref.read(pushNotificationServiceProvider);
      await pushService.unregister();

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

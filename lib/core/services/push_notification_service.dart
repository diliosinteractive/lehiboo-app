import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'deep_link_service.dart';

// Cold-start state captured by the click listener registered in main.dart
// before runApp(). The DeepLinkService isn't built yet at that point, so we
// stash the payload and replay it from initialize().
Map<String, dynamic>? _pendingClickData;
bool _pendingClickConsumed = false;

// Tracks whether `OneSignal.initialize(appId)` ran successfully in main.dart.
// When false (e.g. ONESIGNAL_APP_ID missing from .env), all OneSignal calls
// throw "Must call 'initWithContext' before use" — so every method on the
// service short-circuits to a safe no-op. Set via [markOneSignalConfigured].
bool _isOneSignalConfigured = false;

bool get isOneSignalConfigured => _isOneSignalConfigured;

/// Called from main.dart after a successful `OneSignal.initialize()` so the
/// rest of the app knows it's safe to call OneSignal APIs.
void markOneSignalConfigured() {
  _isOneSignalConfigured = true;
}

/// Click listener registered in `main.dart` BEFORE `runApp()` so the cold-start
/// payload (app launched by tapping a notification) is not lost.
void oneSignalColdStartClickListener(OSNotificationClickEvent event) {
  if (_pendingClickConsumed) return;
  final raw = event.notification.additionalData;
  if (raw == null) return;
  _pendingClickData = Map<String, dynamic>.from(raw);
  debugPrint(
      'OneSignal: cold-start click stashed (type=${_pendingClickData?['type']})');
}

final pushNotificationServiceProvider =
    Provider<PushNotificationService>((ref) {
  return PushNotificationService(
    deepLinkService: ref.watch(deepLinkServiceProvider),
  );
});

/// Push Notification Service backed by OneSignal.
///
/// Replaces the previous Firebase Cloud Messaging implementation. Notification
/// routing is delegated to [DeepLinkService] which keeps the
/// `data.type → mobile-route` table.
class PushNotificationService {
  final DeepLinkService _deepLinkService;

  String? _subscriptionId;
  bool _initialized = false;
  bool _permissionDenied = false;

  /// Fired whenever a (new) push subscription id is available, so the provider
  /// can sync it with the backend.
  Future<void> Function(String subscriptionId)? onSubscriptionReceived;

  /// Fired when the local subscription is dropped (logout).
  Future<void> Function(String subscriptionId)? onSubscriptionRemoved;

  PushNotificationService({required DeepLinkService deepLinkService})
      : _deepLinkService = deepLinkService;

  /// Current OneSignal push subscription id (UUID). Analogous to the legacy
  /// FCM token — opaque, used by the backend as the device handle.
  String? get subscriptionId => _subscriptionId;

  bool get isInitialized => _initialized;

  bool get permissionDenied => _permissionDenied;

  /// Wires OneSignal listeners and resolves the current subscription id.
  /// Idempotent.
  Future<void> initialize() async {
    if (!_isOneSignalConfigured) {
      debugPrint(
          'PushNotificationService: skipped (OneSignal SDK not configured)');
      return;
    }
    if (_initialized) {
      debugPrint('PushNotificationService already initialized');
      return;
    }

    try {
      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        debugPrint(
            'OneSignal: foreground notification ${event.notification.notificationId}');
        // Match the previous behaviour: surface the OS notification even when
        // the app is foregrounded. Without this OneSignal silently drops it.
        event.preventDefault();
        event.notification.display();
      });

      OneSignal.Notifications.addClickListener(_handleClick);

      OneSignal.Notifications.addPermissionObserver((permission) async {
        debugPrint('OneSignal: permission changed → $permission');
        _permissionDenied = !permission;
        if (permission) {
          await ensureSubscriptionId();
          final id = _subscriptionId;
          if (id != null) await onSubscriptionReceived?.call(id);
        }
      });

      OneSignal.User.pushSubscription.addObserver((state) async {
        final id = state.current.id;
        if (id == null || id.isEmpty) return;
        if (id == _subscriptionId) return;
        debugPrint('OneSignal: subscription id refreshed');
        _subscriptionId = id;
        await onSubscriptionReceived?.call(id);
      });

      // Permission is requested later via [promptUserForPermission], on the
      // post-signup notifications screen. Initialize must NOT trigger the OS
      // prompt — listeners above are enough to surface a subscription id if
      // the user has previously granted permission on this device.
      await ensureSubscriptionId();
      debugPrint(
          'OneSignal: subscriptionId=${_subscriptionId ?? "<null>"} after ensureSubscriptionId()');

      _replayPendingClick();

      _initialized = true;
      debugPrint('PushNotificationService initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize PushNotificationService: $e');
    }
  }

  /// Trigger the OS-level notification permission prompt and refresh the
  /// subscription state. Call this from the post-signup notifications screen
  /// or the Settings "enable push" toggle — never from [initialize].
  Future<bool> promptUserForPermission() async {
    if (!_isOneSignalConfigured) {
      debugPrint(
          'PushNotificationService.promptUserForPermission: skipped (SDK not configured)');
      return false;
    }
    try {
      final granted = await OneSignal.Notifications.requestPermission(true);
      _permissionDenied = !granted;
      debugPrint(
          'OneSignal: user prompt → ${granted ? "GRANTED" : "DENIED"}');
      if (granted) {
        await ensureSubscriptionId();
        final id = _subscriptionId;
        if (id != null) await onSubscriptionReceived?.call(id);
      }
      return granted;
    } catch (e) {
      debugPrint('OneSignal: promptUserForPermission failed: $e');
      return false;
    }
  }

  /// Bind this device to the OneSignal external id assigned by the backend
  /// (`users.onesignal_id`). Idempotent — safe to call on every app start
  /// when an authenticated session with an external id is present.
  Future<void> bindUser(String externalId) async {
    if (!_isOneSignalConfigured) return;
    try {
      await OneSignal.login(externalId);
      debugPrint('OneSignal.login(external_id=$externalId) → success');
    } catch (e) {
      debugPrint('OneSignal.login(external_id=$externalId) failed: $e');
    }
  }

  /// Detach the current external user id. Called on logout, AFTER the
  /// backend DELETE /auth/device-tokens has happened so the bearer is still
  /// valid for that call.
  Future<void> unbindUser() async {
    if (!_isOneSignalConfigured) return;
    try {
      await OneSignal.logout();
      debugPrint('OneSignal.logout → success');
    } catch (e) {
      debugPrint('OneSignal.logout failed: $e');
    }
  }

  /// Resolve and cache the current OneSignal push subscription id.
  ///
  /// On a fresh install / iOS-with-deferred-APNs the id can be null for a
  /// short while after init. Polls a few times before giving up — the
  /// subscription observer will pick the value up later anyway.
  Future<String?> ensureSubscriptionId() async {
    if (!_isOneSignalConfigured) return null;
    var id = OneSignal.User.pushSubscription.id;
    for (var attempt = 0;
        attempt < 5 && (id == null || id.isEmpty);
        attempt++) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      id = OneSignal.User.pushSubscription.id;
    }
    if (id != null && id.isNotEmpty) {
      _subscriptionId = id;
      debugPrint('OneSignal subscription id resolved: $id');
    } else {
      debugPrint('OneSignal subscription id still null after polling');
    }
    return _subscriptionId;
  }

  /// Stop tracking the current subscription. The backend DELETE is owned by
  /// the auth provider (via DeviceTokenDataSource.unregisterAllTokens),
  /// while OneSignal.logout() is invoked by [unbindUser].
  Future<void> unregister() async {
    final previousId = _subscriptionId;
    _subscriptionId = null;
    _initialized = false;
    if (previousId != null) {
      await onSubscriptionRemoved?.call(previousId);
    }
    debugPrint('PushNotificationService unregistered');
  }

  void _handleClick(OSNotificationClickEvent event) {
    final raw = event.notification.additionalData;
    if (raw == null) {
      debugPrint('OneSignal click: empty additionalData');
      _deepLinkService.navigate('/notifications');
      return;
    }
    final data = Map<String, dynamic>.from(raw);
    debugPrint('OneSignal click: type=${data['type']}');
    _deepLinkService.navigateFromType(data);
  }

  void _replayPendingClick() {
    if (_pendingClickConsumed) return;
    _pendingClickConsumed = true;
    final pending = _pendingClickData;
    _pendingClickData = null;
    if (pending == null) return;
    debugPrint('OneSignal: replaying cold-start click (type=${pending['type']})');
    _deepLinkService.navigateFromType(pending);
  }

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      return android.id;
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      return ios.identifierForVendor ?? 'unknown';
    }
    return 'unknown';
  }

  Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      return '${android.manufacturer} ${android.model}';
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      return ios.utsname.machine;
    }
    return 'Unknown Device';
  }

  String getPlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }
}

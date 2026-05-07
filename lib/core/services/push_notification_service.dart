import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'deep_link_service.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
  // Note: You cannot access providers here as this runs in a separate isolate
}

/// Provides the PushNotificationService
final pushNotificationServiceProvider = Provider<PushNotificationService>((ref) {
  return PushNotificationService(
    deepLinkService: ref.watch(deepLinkServiceProvider),
  );
});

/// Push Notification Service
///
/// Handles Firebase Cloud Messaging (FCM) setup and notifications.
/// - Requests permissions
/// - Gets and refreshes FCM tokens
/// - Handles foreground/background notifications
/// - Delegates navigation to DeepLinkService
class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final DeepLinkService _deepLinkService;

  String? _fcmToken;
  bool _initialized = false;

  /// Callback to register token with backend API
  Future<void> Function(String token)? onTokenReceived;

  /// Callback to unregister token with backend API
  Future<void> Function(String token)? onTokenRemoved;

  PushNotificationService({
    required DeepLinkService deepLinkService,
  }) : _deepLinkService = deepLinkService;

  /// Current FCM token
  String? get fcmToken => _fcmToken;

  /// Whether the service is initialized
  bool get isInitialized => _initialized;

  /// Initialize push notifications
  ///
  /// Call this after user login and Firebase initialization.
  Future<void> initialize() async {
    if (_initialized) {
      debugPrint('PushNotificationService already initialized');
      return;
    }

    try {
      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Request permissions
      final settings = await _requestPermissions();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('Push notifications denied by user');
        return;
      }

      // Initialize local notifications for foreground
      await _initializeLocalNotifications();

      // Get FCM token
      _fcmToken = await _messaging.getToken();
      if (_fcmToken != null) {
        debugPrint('FCM Token: ${_fcmToken!.substring(0, 20)}...');
        await onTokenReceived?.call(_fcmToken!);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) async {
        debugPrint('FCM Token refreshed');
        _fcmToken = newToken;
        await onTokenReceived?.call(newToken);
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification tap when app is in background/terminated
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Check if app was opened from a notification
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      _initialized = true;
      debugPrint('PushNotificationService initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize PushNotificationService: $e');
    }
  }

  /// Request notification permissions
  Future<NotificationSettings> _requestPermissions() async {
    return await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );
  }

  /// Initialize local notifications for foreground display
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  /// Create Android notification channels
  Future<void> _createNotificationChannels() async {
    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    // Channel set per spec PUSH_NOTIFICATIONS_MOBILE_SPEC.md §5.1.1.
    // Live channels (have at least one notification class targeting them):
    const liveChannels = <AndroidNotificationChannel>[
      AndroidNotificationChannel(
        'bookings',
        'Réservations',
        description: 'Notifications de réservation',
        importance: Importance.high,
      ),
      AndroidNotificationChannel(
        'alerts',
        'Alertes & nouveautés',
        description:
            'Recherches sauvegardées et nouveautés des organisateurs suivis',
        importance: Importance.high,
      ),
      AndroidNotificationChannel(
        'messages',
        'Messages',
        description: 'Nouveaux messages dans vos conversations',
        importance: Importance.high,
      ),
      AndroidNotificationChannel(
        'organizations',
        'Organisations',
        description: 'Invitations et appartenances aux organisations',
        importance: Importance.defaultImportance,
      ),
      AndroidNotificationChannel(
        'general',
        'Notifications générales',
        description: 'Avis, questions, rappels et autres notifications',
        importance: Importance.defaultImportance,
      ),
    ];
    // Reserved channels — backend has the factories but no notification
    // class wires them today (spec §6 "Defined PushPayload factories with
    // no current consumer"). Pre-created so the OS uses the right defaults
    // the moment they go live, without needing an app update.
    const reservedChannels = <AndroidNotificationChannel>[
      AndroidNotificationChannel(
        'check_ins',
        'Check-in',
        description: 'Notifications de check-in (à venir)',
        importance: Importance.high,
      ),
      AndroidNotificationChannel(
        'reminders',
        'Rappels',
        description: 'Rappels d\'événements (à venir)',
        importance: Importance.high,
      ),
      AndroidNotificationChannel(
        'collaborations',
        'Collaborations',
        description: 'Invitations de collaboration (à venir)',
        importance: Importance.defaultImportance,
      ),
    ];

    for (final channel in [...liveChannels, ...reservedChannels]) {
      await androidPlugin.createNotificationChannel(channel);
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message received: ${message.messageId}');

    final notification = message.notification;
    if (notification != null) {
      // FCM puts the channel id in `notification.android.channelId`. Some
      // payloads also stash it in the data block; read both.
      final channelId = notification.android?.channelId ??
          (message.data['channel_id'] as String?) ??
          'general';
      _showLocalNotification(
        title: notification.title ?? 'Le Hiboo',
        body: notification.body ?? '',
        payload: jsonEncode(message.data),
        channelId: channelId,
      );
    }
  }

  /// Show a local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = 'general',
  }) async {
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelId,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  /// Handle notification tap (from background/terminated state)
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.data}');
    _navigateFromData(message.data);
  }

  /// Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Local notification tapped: ${response.payload}');
    if (response.payload != null) {
      // Parse the payload string back to a map
      // This is a simplified version - in production, use proper serialization
      _deepLinkService.navigateToNotification(response.payload!);
    }
  }

  /// Navigate based on notification data.
  ///
  /// Per spec PUSH_NOTIFICATIONS_MOBILE_SPEC.md §5.2, mobile MUST route on
  /// `data.type` and never on `data.action` (which is a web URL). The
  /// type → mobile-route table lives in `DeepLinkService.routeForType`.
  void _navigateFromData(Map<String, dynamic> data) {
    _deepLinkService.navigateFromType(data);
  }

  /// Unregister push notifications
  ///
  /// Call this on user logout to stop receiving notifications.
  Future<void> unregister() async {
    if (_fcmToken != null) {
      await onTokenRemoved?.call(_fcmToken!);
    }

    // Delete the FCM token
    await _messaging.deleteToken();
    _fcmToken = null;
    _initialized = false;

    debugPrint('PushNotificationService unregistered');
  }

  /// Get unique device identifier
  ///
  /// Used to identify the device when registering the FCM token.
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

  /// Get device name for display
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

  /// Get the current platform string
  String getPlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'unknown';
  }
}

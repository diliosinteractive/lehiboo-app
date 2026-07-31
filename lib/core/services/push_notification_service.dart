import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../analytics/analytics_event.dart';
import '../analytics/analytics_provider.dart';
import '../analytics/analytics_service.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'deep_link_service.dart';

// Cold-start state captured by the click listener registered in main.dart
// before runApp(). The DeepLinkService isn't built yet at that point, so we
// stash the payload and replay it from initialize().
Map<String, dynamic>? _pendingClickData;
bool _serviceClickListenerReady = false;

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
  if (_serviceClickListenerReady) return;
  final raw = event.notification.additionalData;
  if (raw == null) return;
  _pendingClickData = Map<String, dynamic>.from(raw);
  debugPrint(
      'OneSignal: cold-start click stashed (type=${_pendingClickData?['type']})');
}

@visibleForTesting
void stashPendingPushClickForTesting(Map<String, dynamic> data) {
  _pendingClickData = Map<String, dynamic>.from(data);
}

@visibleForTesting
bool get hasPendingPushClickForTesting => _pendingClickData != null;

@visibleForTesting
void resetPushClickStateForTesting() {
  _pendingClickData = null;
  _serviceClickListenerReady = false;
}

@immutable
class PushRecipientIdentity {
  const PushRecipientIdentity({
    required this.accountId,
    this.externalId,
  });

  final String accountId;
  final String? externalId;

  @override
  bool operator ==(Object other) =>
      other is PushRecipientIdentity &&
      other.accountId == accountId &&
      other.externalId == externalId;

  @override
  int get hashCode => Object.hash(accountId, externalId);
}

PushRecipientIdentity? _recipientFromAuth(AuthState auth) {
  if (!auth.isAuthenticated) return null;
  final accountId = auth.user?.id.trim();
  if (accountId == null || accountId.isEmpty) return null;
  final externalId = auth.user?.onesignalId?.trim();
  return PushRecipientIdentity(
    accountId: accountId,
    externalId: externalId == null || externalId.isEmpty ? null : externalId,
  );
}

abstract interface class PushNotificationSdk {
  String? get subscriptionId;

  void addForegroundListener(OnNotificationWillDisplayListener listener);

  void removeForegroundListener(OnNotificationWillDisplayListener listener);

  void addClickListener(OnNotificationClickListener listener);

  void removeClickListener(OnNotificationClickListener listener);

  void addPermissionObserver(
    OnNotificationPermissionChangeObserver observer,
  );

  void removePermissionObserver(
    OnNotificationPermissionChangeObserver observer,
  );

  void addSubscriptionObserver(
    OnPushSubscriptionChangeObserver observer,
  );

  void removeSubscriptionObserver(
    OnPushSubscriptionChangeObserver observer,
  );

  Future<bool> requestPermission();

  Future<void> login(String externalId);

  Future<void> logout();
}

class OneSignalPushNotificationSdk implements PushNotificationSdk {
  const OneSignalPushNotificationSdk();

  @override
  String? get subscriptionId => OneSignal.User.pushSubscription.id;

  @override
  void addForegroundListener(OnNotificationWillDisplayListener listener) {
    OneSignal.Notifications.addForegroundWillDisplayListener(listener);
  }

  @override
  void removeForegroundListener(OnNotificationWillDisplayListener listener) {
    OneSignal.Notifications.removeForegroundWillDisplayListener(listener);
  }

  @override
  void addClickListener(OnNotificationClickListener listener) {
    OneSignal.Notifications.addClickListener(listener);
  }

  @override
  void removeClickListener(OnNotificationClickListener listener) {
    OneSignal.Notifications.removeClickListener(listener);
  }

  @override
  void addPermissionObserver(
    OnNotificationPermissionChangeObserver observer,
  ) {
    OneSignal.Notifications.addPermissionObserver(observer);
  }

  @override
  void removePermissionObserver(
    OnNotificationPermissionChangeObserver observer,
  ) {
    OneSignal.Notifications.removePermissionObserver(observer);
  }

  @override
  void addSubscriptionObserver(
    OnPushSubscriptionChangeObserver observer,
  ) {
    OneSignal.User.pushSubscription.addObserver(observer);
  }

  @override
  void removeSubscriptionObserver(
    OnPushSubscriptionChangeObserver observer,
  ) {
    OneSignal.User.pushSubscription.removeObserver(observer);
  }

  @override
  Future<bool> requestPermission() {
    return OneSignal.Notifications.requestPermission(true);
  }

  @override
  Future<void> login(String externalId) => OneSignal.login(externalId);

  @override
  Future<void> logout() => OneSignal.logout();
}

final pushNotificationServiceProvider =
    Provider<PushNotificationService>((ref) {
  PushRecipientIdentity? currentRecipient() {
    return _recipientFromAuth(ref.read(authProvider));
  }

  final service = PushNotificationService(
    deepLinkService: ref.read(deepLinkServiceProvider),
    deepLinkServiceResolver: () => ref.read(deepLinkServiceProvider),
    analytics: ref.read(analyticsServiceProvider),
    currentRecipient: currentRecipient,
  );
  service.updateActiveRecipient(currentRecipient());
  ref.listen<AuthState>(
    authProvider,
    (_, next) => service.updateActiveRecipient(_recipientFromAuth(next)),
  );
  ref.onDispose(service.dispose);
  return service;
});

/// Push Notification Service backed by OneSignal.
///
/// Replaces the previous Firebase Cloud Messaging implementation. Notification
/// routing is delegated to [DeepLinkService] which keeps the
/// `data.type → mobile-route` table.
class PushNotificationService {
  final DeepLinkService _deepLinkService;
  final DeepLinkService Function()? _deepLinkServiceResolver;
  final AnalyticsService _analytics;
  final PushRecipientIdentity? Function() _currentRecipient;
  final PushNotificationSdk _sdk;

  String? _subscriptionId;
  bool _initialized = false;
  bool _permissionDenied = false;
  bool _listenersRegistered = false;
  bool _disposed = false;
  bool _hasRecipientSnapshot = false;
  int _recipientGeneration = 0;
  PushRecipientIdentity? _recipientSnapshot;
  Future<void>? _initializationFuture;
  Future<String?>? _subscriptionResolutionFuture;

  late final OnNotificationWillDisplayListener _foregroundListener =
      _handleForegroundNotification;
  late final OnNotificationClickListener _clickListener = _handleClick;
  late final OnNotificationPermissionChangeObserver _permissionObserver =
      _handlePermissionChange;
  late final OnPushSubscriptionChangeObserver _subscriptionObserver =
      _handleSubscriptionChange;

  /// Fired whenever a (new) push subscription id is available, so the provider
  /// can sync it with the backend.
  Future<void> Function(String subscriptionId)? onSubscriptionReceived;

  /// Fired when the local subscription is dropped (logout).
  Future<void> Function(String subscriptionId)? onSubscriptionRemoved;

  PushNotificationService({
    required DeepLinkService deepLinkService,
    required AnalyticsService analytics,
    DeepLinkService Function()? deepLinkServiceResolver,
    PushRecipientIdentity? Function()? currentRecipient,
    PushNotificationSdk? sdk,
  })  : _deepLinkService = deepLinkService,
        _deepLinkServiceResolver = deepLinkServiceResolver,
        _analytics = analytics,
        _currentRecipient = currentRecipient ?? (() => null),
        _sdk = sdk ?? const OneSignalPushNotificationSdk();

  DeepLinkService get _activeDeepLinkService =>
      _deepLinkServiceResolver?.call() ?? _deepLinkService;

  /// Current OneSignal push subscription id (UUID). Analogous to the legacy
  /// FCM token — opaque, used by the backend as the device handle.
  String? get subscriptionId => _subscriptionId;

  bool get isInitialized => _initialized;

  bool get permissionDenied => _permissionDenied;

  /// Wires OneSignal listeners and resolves the current subscription id.
  /// Idempotent.
  Future<void> initialize() {
    if (_disposed) return Future<void>.value();
    if (!_isOneSignalConfigured) {
      debugPrint(
          'PushNotificationService: skipped (OneSignal SDK not configured)');
      return Future<void>.value();
    }
    if (_initialized) {
      debugPrint('PushNotificationService already initialized');
      return Future<void>.value();
    }
    final pending = _initializationFuture;
    if (pending != null) return pending;

    final task = _initializeOnce();
    _initializationFuture = task;
    return task.whenComplete(() {
      if (identical(_initializationFuture, task)) {
        _initializationFuture = null;
      }
    });
  }

  Future<void> _initializeOnce() async {
    try {
      _registerListeners();

      // Permission is requested later via [promptUserForPermission], on the
      // post-signup notifications screen. Initialize must NOT trigger the OS
      // prompt — listeners above are enough to surface a subscription id if
      // the user has previously granted permission on this device.
      await ensureSubscriptionId();
      if (_disposed) return;
      debugPrint(
          'OneSignal: subscriptionId=${_subscriptionId ?? "<null>"} after ensureSubscriptionId()');

      _replayPendingClick();

      _initialized = true;
      debugPrint('PushNotificationService initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize PushNotificationService: $e');
    }
  }

  void _registerListeners() {
    if (_disposed || _listenersRegistered) return;
    _sdk.addForegroundListener(_foregroundListener);
    _sdk.addClickListener(_clickListener);
    _sdk.addPermissionObserver(_permissionObserver);
    _sdk.addSubscriptionObserver(_subscriptionObserver);
    _listenersRegistered = true;
    _serviceClickListenerReady = true;
  }

  void _handleForegroundNotification(OSNotificationWillDisplayEvent event) {
    debugPrint(
      'OneSignal: foreground notification '
      '${event.notification.notificationId}',
    );
    // Match the previous behaviour: surface the OS notification even when the
    // app is foregrounded. Without this OneSignal silently drops it.
    event.preventDefault();
    event.notification.display();
  }

  void _handlePermissionChange(bool permission) {
    unawaited(_applyPermissionChange(permission));
  }

  Future<void> _applyPermissionChange(bool permission) async {
    if (_disposed) return;
    final recipient = _currentRecipient();
    final generation = _recipientGeneration;
    debugPrint('OneSignal: permission changed → $permission');
    _permissionDenied = !permission;
    if (!permission) return;
    await ensureSubscriptionId();
    if (!_ownsRecipient(recipient, generation)) return;
    final id = _subscriptionId;
    if (id != null) await onSubscriptionReceived?.call(id);
  }

  void _handleSubscriptionChange(OSPushSubscriptionChangedState state) {
    unawaited(_applySubscriptionChange(state));
  }

  Future<void> _applySubscriptionChange(
    OSPushSubscriptionChangedState state,
  ) async {
    if (_disposed) return;
    final id = state.current.id;
    if (id == null || id.isEmpty || id == _subscriptionId) return;
    debugPrint('OneSignal: subscription id refreshed');
    _subscriptionId = id;
    await onSubscriptionReceived?.call(id);
  }

  /// Trigger the OS-level notification permission prompt and refresh the
  /// subscription state. Call this from the post-signup notifications screen
  /// or the Settings "enable push" toggle — never from [initialize].
  Future<bool> promptUserForPermission() async {
    if (_disposed || !_isOneSignalConfigured) {
      debugPrint(
          'PushNotificationService.promptUserForPermission: skipped (SDK not configured)');
      return false;
    }
    final recipient = _currentRecipient();
    final generation = _recipientGeneration;
    if (recipient == null) return false;
    try {
      final granted = await _sdk.requestPermission();
      if (!_ownsRecipient(recipient, generation)) return false;
      _permissionDenied = !granted;
      debugPrint('OneSignal: user prompt → ${granted ? "GRANTED" : "DENIED"}');
      _analytics.logEvent(
        AnalyticsEvent.notificationPermissionResult,
        params: {AnalyticsParam.granted: granted},
      );
      _analytics.setUserProperty(
        AnalyticsUserProperty.pushEnabled,
        granted.toString(),
      );
      if (granted) {
        await ensureSubscriptionId();
        if (!_ownsRecipient(recipient, generation)) return false;
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
    if (_disposed || !_isOneSignalConfigured) return;
    try {
      await _sdk.login(externalId);
      debugPrint('OneSignal.login(external_id=$externalId) → success');
    } catch (e) {
      debugPrint('OneSignal.login(external_id=$externalId) failed: $e');
    }
  }

  /// Detach the current external user id. Called on logout, AFTER the
  /// backend DELETE /auth/device-tokens has happened so the bearer is still
  /// valid for that call.
  Future<void> unbindUser() async {
    if (_disposed || !_isOneSignalConfigured) return;
    try {
      await _sdk.logout();
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
  Future<String?> ensureSubscriptionId() {
    if (_disposed || !_isOneSignalConfigured) {
      return Future<String?>.value();
    }
    final pending = _subscriptionResolutionFuture;
    if (pending != null) return pending;

    final task = _resolveSubscriptionId();
    _subscriptionResolutionFuture = task;
    return task.whenComplete(() {
      if (identical(_subscriptionResolutionFuture, task)) {
        _subscriptionResolutionFuture = null;
      }
    });
  }

  Future<String?> _resolveSubscriptionId() async {
    var id = _sdk.subscriptionId;
    for (var attempt = 0;
        !_disposed && attempt < 5 && (id == null || id.isEmpty);
        attempt++) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      id = _sdk.subscriptionId;
    }
    if (!_disposed && id != null && id.isNotEmpty) {
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
    if (previousId != null) {
      await onSubscriptionRemoved?.call(previousId);
    }
    debugPrint('PushNotificationService unregistered');
  }

  /// Clears a cold-start payload whenever the exact account identity changes.
  /// This includes account -> guest, guest -> account, and A -> B -> A.
  void updateActiveRecipient(PushRecipientIdentity? recipient) {
    if (!_hasRecipientSnapshot) {
      _hasRecipientSnapshot = true;
      _recipientSnapshot = recipient;
      return;
    }
    if (recipient != _recipientSnapshot) {
      _recipientGeneration++;
      _pendingClickData = null;
      debugPrint('OneSignal: pending click cleared after identity change');
    }
    _recipientSnapshot = recipient;
  }

  bool _ownsRecipient(
    PushRecipientIdentity? recipient,
    int generation,
  ) {
    return !_disposed &&
        generation == _recipientGeneration &&
        _currentRecipient() == recipient;
  }

  void _handleClick(OSNotificationClickEvent event) {
    final raw = event.notification.additionalData;
    if (raw == null) {
      debugPrint('OneSignal click: empty additionalData');
      _routeClickData(const <String, dynamic>{});
      return;
    }
    _routeClickData(Map<String, dynamic>.from(raw));
  }

  void _replayPendingClick() {
    final pending = _pendingClickData;
    _pendingClickData = null;
    if (pending == null) return;
    debugPrint(
        'OneSignal: replaying cold-start click (type=${pending['type']})');
    _routeClickData(pending, coldStart: true);
  }

  void _routeClickData(
    Map<String, dynamic> data, {
    bool coldStart = false,
  }) {
    final deepLinks = _activeDeepLinkService;
    final type = data['type']?.toString();
    final resolvedRoute = type == null
        ? '/notifications'
        // DeepLinkService keeps this resolver annotated for its direct unit
        // tests, but push routing is also its intended production caller.
        // ignore: invalid_use_of_visible_for_testing_member
        : deepLinks.routeForType(type, data) ?? '/notifications';
    final recipient = _currentRecipient();
    final destination = authorizedPushDestination(
      resolvedRoute: resolvedRoute,
      data: data,
      activeRecipient: recipient,
    );

    if (destination == null) {
      debugPrint(
        'OneSignal click discarded: no authenticated recipient for private '
        'destination (type=${type ?? "unknown"})',
      );
      return;
    }
    if (destination != resolvedRoute) {
      debugPrint(
        'OneSignal click restricted to current account inbox '
        '(type=${type ?? "unknown"})',
      );
    }

    _analytics.logEvent(
      AnalyticsEvent.notificationOpened,
      params: {
        AnalyticsParam.type: type ?? 'unknown',
        if (coldStart) AnalyticsParam.source: AnalyticsSource.coldStart,
      },
    );
    deepLinks.navigate(destination);
  }

  @visibleForTesting
  void handleClickDataForTesting(
    Map<String, dynamic> data, {
    bool coldStart = false,
  }) {
    _routeClickData(data, coldStart: coldStart);
  }

  @visibleForTesting
  void replayPendingClickForTesting() {
    _replayPendingClick();
  }

  /// Removes the exact callbacks registered with the OneSignal singleton.
  /// A disposed/recreated provider therefore cannot accumulate listeners.
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    if (_listenersRegistered) {
      _sdk.removeForegroundListener(_foregroundListener);
      _sdk.removeClickListener(_clickListener);
      _sdk.removePermissionObserver(_permissionObserver);
      _sdk.removeSubscriptionObserver(_subscriptionObserver);
      _listenersRegistered = false;
    }
    _serviceClickListenerReady = false;
    _initialized = false;
    _initializationFuture = null;
    _subscriptionResolutionFuture = null;
    onSubscriptionReceived = null;
    onSubscriptionRemoved = null;
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

enum _RecipientFieldKind { accountId, externalId }

const Map<String, _RecipientFieldKind> _recipientFieldAliases = {
  'recipient_id': _RecipientFieldKind.accountId,
  'recipient_user_id': _RecipientFieldKind.accountId,
  'recipient_account_id': _RecipientFieldKind.accountId,
  'notifiable_id': _RecipientFieldKind.accountId,
  'target_user_id': _RecipientFieldKind.accountId,
  'recipient_uuid': _RecipientFieldKind.externalId,
  'recipient_user_uuid': _RecipientFieldKind.externalId,
  'notifiable_uuid': _RecipientFieldKind.externalId,
  'target_user_uuid': _RecipientFieldKind.externalId,
  'external_id': _RecipientFieldKind.externalId,
  'external_user_id': _RecipientFieldKind.externalId,
  'onesignal_id': _RecipientFieldKind.externalId,
  'recipient_external_id': _RecipientFieldKind.externalId,
  'recipient_external_user_id': _RecipientFieldKind.externalId,
  'recipient_onesignal_id': _RecipientFieldKind.externalId,
};

const Set<String> _publicObjectIdentityFields = {
  'event_id',
  'event_uuid',
  'event_slug',
  'organization_id',
  'organization_uuid',
  'organization_slug',
  'organizer_id',
  'organizer_uuid',
  'organizer_slug',
  'category_id',
  'category_uuid',
  'category_slug',
  'thematique_id',
  'thematique_uuid',
  'thematique_slug',
};

const List<String> _privateObjectPrefixes = [
  'alert',
  'booking',
  'broadcast',
  'checkin',
  'check_in',
  'conversation',
  'hibons',
  'history',
  'invitation',
  'membership',
  'message',
  'notification',
  'order',
  'payment',
  'petit_boo',
  'profile',
  'question',
  'review',
  'ticket',
  'user',
  'vendor',
  'wallet',
];

/// Chooses the only route a notification payload is allowed to open.
///
/// Private payload identifiers are accepted only with an explicit recipient
/// that exactly matches the active account. Legacy/mismatched payloads lose
/// all payload-specific ids and may open only that account's own inbox.
@visibleForTesting
String? authorizedPushDestination({
  required String resolvedRoute,
  required Map<String, dynamic> data,
  required PushRecipientIdentity? activeRecipient,
}) {
  if (_isSafePublicPushDestination(
    resolvedRoute,
    data,
    activeRecipient,
  )) {
    return resolvedRoute;
  }

  // `/notifications` contains no payload-selected private object: the server
  // scopes the inbox to the active bearer account.
  if (_normalizedRoutePath(resolvedRoute) == '/notifications') {
    return activeRecipient == null ? null : '/notifications';
  }

  if (_payloadRecipientMatches(data, activeRecipient)) {
    return resolvedRoute;
  }
  return activeRecipient == null ? null : '/notifications';
}

bool _payloadRecipientMatches(
  Map<String, dynamic> data,
  PushRecipientIdentity? activeRecipient,
) {
  if (activeRecipient == null) return false;
  var recognized = 0;

  for (final entry in data.entries) {
    final key = _normalizePayloadKey(entry.key);
    final kind = _recipientFieldAliases[key];
    if (kind == null) continue;
    recognized++;
    final actual = entry.value?.toString().trim() ?? '';
    final expected = switch (kind) {
      _RecipientFieldKind.accountId => activeRecipient.accountId,
      _RecipientFieldKind.externalId => activeRecipient.externalId,
    };
    if (actual.isEmpty || expected == null || actual != expected) {
      return false;
    }
  }

  return recognized > 0;
}

bool _isSafePublicPushDestination(
  String route,
  Map<String, dynamic> data,
  PushRecipientIdentity? activeRecipient,
) {
  final path = _normalizedRoutePath(route);
  final publicDestination = path == '/event' ||
      path.startsWith('/event/') ||
      path == '/organizers' ||
      path.startsWith('/organizers/') ||
      path == '/categories' ||
      path.startsWith('/categories/');
  if (!publicDestination || _containsPrivateObjectIdentity(data)) {
    return false;
  }

  // Public legacy payloads without recipient metadata are safe because only
  // public event/organizer/category ids are used. Once a recipient field is
  // present, a mismatch still fails closed instead of attributing A's click to
  // B merely because the destination itself happens to be public.
  return !_hasPayloadRecipient(data) ||
      _payloadRecipientMatches(data, activeRecipient);
}

bool _hasPayloadRecipient(Map<String, dynamic> data) {
  return data.keys.any(
    (key) => _recipientFieldAliases.containsKey(_normalizePayloadKey(key)),
  );
}

bool _containsPrivateObjectIdentity(Map<String, dynamic> data) {
  for (final entry in data.entries) {
    final value = entry.value;
    if (value == null || value.toString().trim().isEmpty) continue;
    final key = _normalizePayloadKey(entry.key);
    if (_recipientFieldAliases.containsKey(key) ||
        _publicObjectIdentityFields.contains(key) ||
        key == 'type' ||
        key == 'action' ||
        key == 'channel_id') {
      continue;
    }
    if (value is Map &&
        _containsPrivateObjectIdentity(Map<String, dynamic>.from(value))) {
      return true;
    }
    if (_privateObjectPrefixes.any(
          (prefix) => key == prefix || key.startsWith('${prefix}_'),
        ) ||
        key == 'id' ||
        key.endsWith('_id') ||
        key.endsWith('_uuid') ||
        key.endsWith('_token') ||
        key.endsWith('_reference')) {
      return true;
    }
  }
  return false;
}

String _normalizePayloadKey(String key) {
  return key
      .replaceAllMapped(
        RegExp(r'([a-z0-9])([A-Z])'),
        (match) => '${match.group(1)}_${match.group(2)}',
      )
      .replaceAll('-', '_')
      .toLowerCase();
}

String _normalizedRoutePath(String route) {
  return Uri.tryParse(route)?.path ?? route.split('?').first;
}

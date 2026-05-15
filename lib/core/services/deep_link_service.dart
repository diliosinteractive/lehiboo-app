import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/user.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../routes/app_router.dart';

/// Provides the DeepLinkService
final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  final router = ref.watch(routerProvider);
  final role = ref.watch(authProvider.select((state) => state.user?.role));
  return DeepLinkService(router: router, currentRole: role);
});

/// Deep Link Service
///
/// Routes push-notification taps to mobile screens. Per
/// `docs/PUSH_NOTIFICATIONS_MOBILE_SPEC.md` §5.2, mobile MUST route on
/// `data.type` and never navigate to `data.action` (which is a web URL).
class DeepLinkService {
  final GoRouter _router;
  final UserRole? _currentRole;

  DeepLinkService({
    required GoRouter router,
    UserRole? currentRole,
  })  : _router = router,
        _currentRole = currentRole;

  /// Navigate to a path directly. Used by tests and for the local-notification
  /// payload path that already carries a resolved mobile route.
  void navigate(String path) {
    debugPrint('DeepLinkService: Navigating to $path');
    try {
      if (path.startsWith('http://') || path.startsWith('https://')) {
        debugPrint('DeepLinkService: External URL, ignoring');
        return;
      }
      final normalizedPath = path.startsWith('/') ? path : '/$path';
      _router.go(normalizedPath);
    } catch (e) {
      debugPrint('DeepLinkService: Navigation failed - $e');
      _router.go('/');
    }
  }

  /// Push a path on top of the current stack. Used for in-app foreground
  /// navigation where the user expects the back button to return to where
  /// they were.
  void push(String path) {
    debugPrint('DeepLinkService: Pushing $path');
    try {
      if (path.startsWith('http://') || path.startsWith('https://')) {
        debugPrint('DeepLinkService: External URL, ignoring');
        return;
      }
      final normalizedPath = path.startsWith('/') ? path : '/$path';
      _router.push(normalizedPath);
    } catch (e) {
      debugPrint('DeepLinkService: Push failed - $e');
      navigate(path);
    }
  }

  /// Route a push notification by its `data.type` field.
  ///
  /// Falls back to `/notifications` for unknown or null types so the OS-level
  /// tap never crashes when the backend ships a new type before the mobile
  /// app knows about it (spec §5.3).
  void navigateFromType(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    final route = type == null ? null : routeForType(type, data);
    navigate(route ?? '/notifications');
  }

  /// Route an in-app notification. Unlike lock-screen push payloads, the
  /// in-app API explicitly exposes `action_url`; use it first when it can be
  /// normalized into an app route, then fall back to the type/data table.
  void navigateFromNotification({
    String? actionUrl,
    required String type,
    required Map<String, dynamic> data,
  }) {
    if (type.toLowerCase() == 'new_message') {
      push(routeForType(type, data) ?? _routeFromActionUrl(actionUrl) ?? '/messages');
      return;
    }

    final actionRoute = _routeFromActionUrl(actionUrl);
    push(actionRoute ?? routeForType(type, data) ?? '/notifications');
  }

  String? _routeFromActionUrl(String? actionUrl) {
    if (actionUrl == null || actionUrl.trim().isEmpty) return null;
    final trimmed = actionUrl.trim();
    if (trimmed.startsWith('/')) return trimmed;

    final uri = Uri.tryParse(trimmed);
    if (uri == null) return null;
    if (!uri.hasScheme) return trimmed.startsWith('/') ? trimmed : '/$trimmed';

    final host = uri.host.toLowerCase();
    if (!host.contains('lehiboo')) return null;
    final query = uri.hasQuery ? '?${uri.query}' : '';
    return '${uri.path.isEmpty ? '/' : uri.path}$query';
  }

  /// Route a payload string from a tapped local notification.
  ///
  /// Local notifications serialise the FCM `data` map via `toString()` (see
  /// `PushNotificationService._showLocalNotification`). We try JSON first
  /// (forward-compatible with future serializers), then the legacy
  /// `{key: value, ...}` Dart-map format.
  void navigateToNotification(String payload) {
    debugPrint('DeepLinkService: Processing payload: $payload');
    final data = _parsePayload(payload);
    if (data != null) {
      navigateFromType(data);
      return;
    }
    navigate('/notifications');
  }

  Map<String, dynamic>? _parsePayload(String payload) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    final typeMatch = RegExp(r'type:\s*(\w+)').firstMatch(payload);
    if (typeMatch == null) return null;
    final result = <String, dynamic>{'type': typeMatch.group(1)};
    final pairPattern = RegExp(r'(\w+):\s*([^,}]+?)(?=,|\}|$)');
    for (final match in pairPattern.allMatches(payload)) {
      final key = match.group(1);
      final value = match.group(2)?.trim();
      if (key != null && value != null) {
        result[key] = value;
      }
    }
    return result;
  }

  /// Maps a push `data.type` to a mobile route.
  ///
  /// Source of truth for spec §5.2 / §6 — switch is exhaustive over the 20
  /// notification classes that wire FCM today. New types should be added
  /// here; missing types fall back to `/notifications` via the caller.
  @visibleForTesting
  String? routeForType(String type, Map<String, dynamic> data) {
    String? str(String key) => data[key]?.toString();
    String? firstPresent(List<String> keys) {
      for (final key in keys) {
        final value = str(key);
        if (value != null && value.isNotEmpty) return value;
      }
      return null;
    }

    final normalized = type.toLowerCase();

    if (normalized == 'new_message') {
      final uuid = firstPresent(['conversation_uuid', 'conversation_id']);
      return _messageRoute(
        uuid,
        firstPresent(['conversation_type', 'conversationType']),
      );
    }

    if (normalized.startsWith('booking_')) {
      final id = firstPresent(['booking_uuid', 'booking_id']);
      return id != null ? '/booking-detail/$id' : '/my-bookings';
    }

    if (normalized == 'event_reminder') {
      final bookingId = firstPresent(['booking_uuid', 'booking_id']);
      if (bookingId != null) return '/booking-detail/$bookingId';
      final event = firstPresent(['event_slug', 'event_uuid', 'event_id']);
      return event != null ? '/event/$event' : '/my-bookings';
    }

    if (normalized == 'ticket_checked_in') {
      final ticketId = firstPresent(['ticket_uuid', 'ticket_id']);
      final bookingId = firstPresent(['booking_uuid', 'booking_id']);
      if (ticketId != null) return '/ticket/$ticketId';
      if (bookingId != null) return '/booking-detail/$bookingId';
      return '/vendor/scan';
    }

    if (normalized == 'tickets_ready' || normalized.startsWith('ticket_')) {
      final ticketId = firstPresent(['ticket_uuid', 'ticket_id']);
      final bookingId = firstPresent(['booking_uuid', 'booking_id']);
      if (ticketId != null) return '/ticket/$ticketId';
      return bookingId != null ? '/booking-detail/$bookingId' : '/my-bookings';
    }

    if (normalized.startsWith('event_') ||
        normalized.startsWith('new_event_') ||
        normalized.startsWith('new_slots_') ||
        normalized.startsWith('discovery_')) {
      final identifier = firstPresent(['event_slug', 'event_uuid', 'event_id']);
      return identifier != null ? '/event/$identifier' : '/notifications';
    }

    if (normalized.startsWith('question_')) {
      final event = firstPresent(['event_slug', 'event_uuid', 'event_id']);
      return event != null ? '/event/$event/questions' : '/my-questions';
    }

    if (normalized.startsWith('review_')) {
      final reviewUuid = firstPresent(['review_uuid', 'review_id']);
      final event = firstPresent(['event_slug', 'event_uuid', 'event_id']);
      if (reviewUuid != null) return '/my-reviews?reviewUuid=$reviewUuid';
      return event != null ? '/event/$event/reviews' : '/my-reviews';
    }

    if (normalized.startsWith('organization_')) {
      if (normalized.contains('invitation')) {
        return '/me/memberships?tab=invitations';
      }
      if (normalized.contains('approved')) return '/me/memberships?tab=active';
      if (normalized.contains('rejected')) {
        return '/me/memberships?tab=rejected';
      }
      final orgId = firstPresent(['organization_uuid', 'organization_id']);
      return orgId != null ? '/organizers/$orgId' : '/me/memberships';
    }

    if (normalized.startsWith('vendor_')) {
      return '/notifications';
    }

    if (normalized.startsWith('payment_') ||
        normalized.startsWith('payout_') ||
        normalized == 'refund') {
      final bookingId = firstPresent(['booking_uuid', 'booking_id']);
      return bookingId != null
          ? '/booking-detail/$bookingId'
          : '/notifications';
    }

    switch (type) {
      // -- Bookings --
      case 'booking_confirmed':
        final id = str('booking_id');
        return id != null ? '/booking-detail/$id' : '/my-bookings';

      // -- Reminders (J-7, J-1) — same destination as the booking detail. --
      case 'event_reminder':
        final id = str('booking_id');
        return id != null ? '/booking-detail/$id' : '/my-bookings';

      // -- Vendor: scan ticket / check-in --
      case 'ticket_checked_in':
        final eventId = str('event_id');
        return eventId != null
            ? '/vendor/events/$eventId/check-in'
            : '/notifications';

      // -- Collaboration invites --
      case 'collaboration_invite':
        final invitationId = str('invitation_id');
        return invitationId != null
            ? '/collaborations/invitations/$invitationId'
            : '/notifications';

      // -- Messages --
      case 'new_message':
        final uuid = str('conversation_uuid');
        return _messageRoute(
          uuid,
          str('conversation_type') ?? str('conversationType'),
        );

      // -- Saved-search alerts --
      case 'new_alert_events':
        final alertUuid = str('alert_uuid');
        return alertUuid != null
            ? '/search?alert=$alertUuid'
            : '/notifications';

      // -- Followed-organisation events --
      case 'new_event_from_followed_organization':
        final identifier = str('event_slug') ?? str('event_uuid');
        return identifier != null ? '/event/$identifier' : '/notifications';

      // -- Organisations --
      case 'organization_invitation_received':
        return '/me/memberships?tab=invitations';
      case 'organization_join_approved':
        final orgId = str('organization_uuid') ?? str('organization_id');
        final highlight =
            (orgId != null && orgId.isNotEmpty) ? '&highlight=$orgId' : '';
        return '/me/memberships?tab=active$highlight';
      case 'organization_join_rejected':
        return '/me/memberships?tab=rejected';

      // -- Vendor side: send to in-app notifications list (no dedicated screen) --
      case 'new_booking':
      case 'organization_join_requested':
        return '/notifications';

      // -- Generic-factory types (channel: general) --
      // Spec §6 lists 12 review/question/discovery/membership types that go
      // through PushPayload::generic and may not carry an `action`. They are
      // informational, so the in-app list is the right destination.
      case 'discovery_reminder':
      case 'organization_invitation_accepted':
      case 'organization_invitation_declined':
      case 'organization_member_left':
      case 'organizer_review_submitted':
      case 'organizer_review_approved':
      case 'review_submitted':
      case 'review_approved':
      case 'review_rejected':
      case 'question_answered':
      case 'question_approved':
      case 'question_rejected':
        return '/notifications';

      default:
        debugPrint('DeepLinkService: Unknown type "$type"');
        return null;
    }
  }

  String _messageRoute(String? uuid, String? conversationType) {
    if (uuid == null || uuid.isEmpty) return '/messages';

    return switch (_currentRole) {
      UserRole.partner => switch (conversationType) {
          'organization_organization' => '/messages/vendor-org/$uuid',
          _ => '/messages/vendor/$uuid',
        },
      UserRole.admin => '/messages/admin/$uuid',
      _ => switch (conversationType) {
          'user_support' => '/messages/support/$uuid',
          _ => '/messages/$uuid',
        },
    };
  }
}

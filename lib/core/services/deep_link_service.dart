import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_router.dart';

/// Provides the DeepLinkService
final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  final router = ref.watch(routerProvider);
  return DeepLinkService(router: router);
});

/// Deep Link Service
///
/// Routes push-notification taps to mobile screens. Per
/// `docs/PUSH_NOTIFICATIONS_MOBILE_SPEC.md` §5.2, mobile MUST route on
/// `data.type` and never navigate to `data.action` (which is a web URL).
class DeepLinkService {
  final GoRouter _router;

  DeepLinkService({required GoRouter router}) : _router = router;

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
        return uuid != null ? '/messages/$uuid' : '/messages';

      // -- Saved-search alerts --
      case 'new_alert_events':
        final alertUuid = str('alert_uuid');
        return alertUuid != null ? '/search?alert=$alertUuid' : '/notifications';

      // -- Followed-organisation events --
      case 'new_event_from_followed_organization':
        final identifier = str('event_slug') ?? str('event_uuid');
        return identifier != null ? '/event/$identifier' : '/notifications';

      // -- Organisations --
      case 'organization_invitation_received':
        return '/me/memberships?tab=invitations';
      case 'organization_join_approved':
        final orgId = str('organization_uuid') ?? str('organization_id');
        final highlight = (orgId != null && orgId.isNotEmpty)
            ? '&highlight=$orgId'
            : '';
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
}

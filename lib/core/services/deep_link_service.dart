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
/// Handles navigation from push notifications and external deep links.
/// Maps notification data to app routes and navigates accordingly.
class DeepLinkService {
  final GoRouter _router;

  DeepLinkService({required GoRouter router}) : _router = router;

  /// Navigate to a path directly
  ///
  /// [path] should be a valid app route like '/event/123' or '/my-bookings'
  void navigate(String path) {
    debugPrint('DeepLinkService: Navigating to $path');

    try {
      // Handle external URLs (http/https) - these should open in browser
      if (path.startsWith('http://') || path.startsWith('https://')) {
        debugPrint('DeepLinkService: External URL, ignoring');
        return;
      }

      // Ensure path starts with /
      final normalizedPath = path.startsWith('/') ? path : '/$path';

      _router.go(normalizedPath);
    } catch (e) {
      debugPrint('DeepLinkService: Navigation failed - $e');
      // Fallback to home
      _router.go('/');
    }
  }

  /// Navigate from notification data map
  ///
  /// Extracts 'type' and 'id' from the data to determine the route.
  void navigateFromData(Map<String, dynamic> data) {
    debugPrint('DeepLinkService: Processing notification data: $data');

    final type = data['type'] as String?;
    final action = data['action'] as String?;

    // If action is provided, use it directly
    if (action != null && action.isNotEmpty) {
      navigate(action);
      return;
    }

    // Otherwise, determine route from type
    if (type == null) {
      debugPrint('DeepLinkService: No type or action in data');
      return;
    }

    final route = _getRouteForType(type, data);
    if (route != null) {
      navigate(route);
    }
  }

  /// Navigate from a payload string (typically from local notifications)
  void navigateToNotification(String payload) {
    debugPrint('DeepLinkService: Processing payload: $payload');

    // Try to extract action from payload
    // Payload format could be: {action: /bookings/123, type: booking_confirmed, ...}
    try {
      // Simple extraction - look for action pattern
      final actionMatch = RegExp(r'action:\s*(/[^\s,}]+)').firstMatch(payload);
      if (actionMatch != null) {
        final action = actionMatch.group(1);
        if (action != null) {
          navigate(action);
          return;
        }
      }

      // Try type-based routing
      final typeMatch = RegExp(r'type:\s*(\w+)').firstMatch(payload);
      final idMatch = RegExp(r'(?:booking_id|event_id|id):\s*(\d+)').firstMatch(payload);

      if (typeMatch != null) {
        final type = typeMatch.group(1)!;
        final id = idMatch?.group(1);
        final route = _getRouteForType(type, {'id': id});
        if (route != null) {
          navigate(route);
          return;
        }
      }
    } catch (e) {
      debugPrint('DeepLinkService: Failed to parse payload - $e');
    }

    // Fallback to notifications screen
    navigate('/notifications');
  }

  /// Map notification type to app route
  String? _getRouteForType(String type, Map<String, dynamic> data) {
    // Booking notifications
    if (type.contains('booking')) {
      final bookingId = data['booking_id'] ?? data['id'];
      if (bookingId != null) {
        return '/my-bookings'; // Single booking detail not implemented, go to list
      }
      return '/my-bookings';
    }

    // Event notifications
    if (type.contains('event')) {
      final eventId = data['event_id'] ?? data['id'];
      if (eventId != null) {
        return '/event/$eventId';
      }
      return '/';
    }

    // Check-in notifications
    if (type.contains('check_in') || type.contains('checkin')) {
      final eventId = data['event_id'];
      if (eventId != null) {
        return '/event/$eventId';
      }
      return '/my-bookings';
    }

    // Collaboration/invitation notifications
    if (type.contains('collaboration') || type.contains('invitation')) {
      return '/notifications';
    }

    // Reminder notifications
    if (type.contains('reminder')) {
      final bookingId = data['booking_id'];
      if (bookingId != null) {
        return '/my-bookings';
      }
      return '/';
    }

    // Alert/saved search notifications
    if (type.contains('alert') || type.contains('saved_search')) {
      final alertUuid = data['alert_uuid'];
      if (alertUuid != null) {
        return '/search?alert=$alertUuid';
      }
      return '/notifications';
    }

    // Payout notifications (vendor)
    if (type.contains('payout')) {
      return '/profile'; // Or vendor dashboard when available
    }

    // Default to notifications screen
    debugPrint('DeepLinkService: Unknown type "$type", using default route');
    return '/notifications';
  }

  /// Check if a route is valid
  bool isValidRoute(String path) {
    // Basic validation - more specific if needed
    final validPrefixes = [
      '/event/',
      '/events/',
      '/my-bookings',
      '/bookings/',
      '/profile',
      '/settings',
      '/notifications',
      '/favorites',
      '/search',
      '/explore',
      '/partner/',
      '/ai-',
      '/hibons-',
      '/',
    ];

    return validPrefixes.any((prefix) => path.startsWith(prefix));
  }
}

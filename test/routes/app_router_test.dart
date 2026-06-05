import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/routes/app_router.dart';

void main() {
  group('protectedRouteRedirect', () {
    test('redirects unauthenticated messages deep links to login', () {
      final redirect = protectedRouteRedirect(
        authStatus: AuthStatus.unauthenticated,
        matchedLocation: '/messages/vendor/conversation-1',
        attemptedUri: Uri.parse('/messages/vendor/conversation-1?tab=unread'),
      );

      expect(Uri.parse(redirect!).path, '/login');
      expect(
        Uri.parse(redirect).queryParameters['redirect'],
        '/messages/vendor/conversation-1?tab=unread',
      );
    });

    test('redirects unauthenticated user-only routes to login', () {
      final redirect = protectedRouteRedirect(
        authStatus: AuthStatus.unauthenticated,
        matchedLocation: '/notifications',
        attemptedUri: Uri.parse('/notifications'),
      );

      expect(Uri.parse(redirect!).path, '/login');
      expect(Uri.parse(redirect).queryParameters['redirect'], '/notifications');
    });

    test('allows public routes while unauthenticated', () {
      final redirect = protectedRouteRedirect(
        authStatus: AuthStatus.unauthenticated,
        matchedLocation: '/event/event-1',
        attemptedUri: Uri.parse('/event/event-1'),
      );

      expect(redirect, isNull);
    });

    test('allows protected routes after authentication', () {
      final redirect = protectedRouteRedirect(
        authStatus: AuthStatus.authenticated,
        matchedLocation: '/messages',
        attemptedUri: Uri.parse('/messages'),
      );

      expect(redirect, isNull);
    });
  });
}

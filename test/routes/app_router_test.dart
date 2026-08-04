import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/routes/app_router.dart';

void main() {
  group('authenticated routing identity', () {
    test('fail-closes mounted state for logout, A to B, and role changes', () {
      const accountA = HbUser(
        id: 'account-a',
        email: 'a@example.test',
        displayName: 'Account A',
      );
      const accountB = HbUser(
        id: 'account-b',
        email: 'b@example.test',
        displayName: 'Account B',
      );

      const authenticatedA = AuthState(
        status: AuthStatus.authenticated,
        user: accountA,
      );
      const authenticatedB = AuthState(
        status: AuthStatus.authenticated,
        user: accountB,
      );
      final partnerA = AuthState(
        status: AuthStatus.authenticated,
        user: accountA.copyWith(role: UserRole.partner),
      );

      expect(
        didAuthenticatedRoutingIdentityChange(
          authenticatedA,
          const AuthState(status: AuthStatus.unauthenticated),
        ),
        isTrue,
      );
      expect(
        didAuthenticatedRoutingIdentityChange(authenticatedA, authenticatedB),
        isTrue,
      );
      expect(
        didAuthenticatedRoutingIdentityChange(authenticatedB, authenticatedA),
        isTrue,
      );
      expect(
        didAuthenticatedRoutingIdentityChange(authenticatedA, partnerA),
        isTrue,
      );
      expect(
        didAuthenticatedRoutingIdentityChange(
          authenticatedA,
          authenticatedA,
        ),
        isFalse,
      );
    });
  });

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

    test('protects booking and ticket data routes', () {
      for (final location in [
        '/my-bookings',
        '/booking/event-1/confirmation',
        '/booking-detail/booking-1',
        '/booking-confirmation/booking-1',
        '/order-confirmation/order-1',
        '/ticket/ticket-1',
        '/checkout',
        '/cart',
      ]) {
        final redirect = protectedRouteRedirect(
          authStatus: AuthStatus.unauthenticated,
          matchedLocation: location,
          attemptedUri: Uri.parse(location),
        );

        expect(Uri.parse(redirect!).path, '/login');
        expect(Uri.parse(redirect).queryParameters['redirect'], location);
      }
    });

    test('protects vendor check-in and account PII routes', () {
      for (final location in [
        '/me/followed-organizers',
        '/me/memberships',
        '/me/private-events',
        '/favorites',
        '/vendor/scan',
        '/vendor/scan/manual',
        '/participants',
        '/account',
        '/profile/edit',
        '/settings',
        '/post-signup/notifications',
        '/petit-boo/history',
      ]) {
        final redirect = protectedRouteRedirect(
          authStatus: AuthStatus.unauthenticated,
          matchedLocation: location,
          attemptedUri: Uri.parse('$location?source=deep-link'),
        );

        expect(Uri.parse(redirect!).path, '/login');
        expect(
          Uri.parse(redirect).queryParameters['redirect'],
          '$location?source=deep-link',
        );
      }
    });

    test('protects the Petit Boo memory route', () {
      const location = '/petit-boo/brain';
      final redirect = protectedRouteRedirect(
        authStatus: AuthStatus.unauthenticated,
        matchedLocation: location,
        attemptedUri: Uri.parse(location),
      );

      expect(Uri.parse(redirect!).path, '/login');
      expect(Uri.parse(redirect).queryParameters['redirect'], location);
    });

    test('protects personalized Hibons routes', () {
      for (final location in [
        '/hibons-shop',
        '/hibons/transactions',
        '/hibons/challenges',
        '/hibons-dashboard',
        '/hibons/how-to-earn',
        '/lucky-wheel',
        '/achievements',
      ]) {
        final redirect = protectedRouteRedirect(
          authStatus: AuthStatus.unauthenticated,
          matchedLocation: location,
          attemptedUri: Uri.parse(location),
        );

        expect(Uri.parse(redirect!).path, '/login');
        expect(Uri.parse(redirect).queryParameters['redirect'], location);
      }
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

    test('fails closed for non-authenticated transitional and error states',
        () {
      for (final status in [
        AuthStatus.unauthenticated,
        AuthStatus.loading,
        AuthStatus.error,
      ]) {
        final redirect = protectedRouteRedirect(
          authStatus: status,
          matchedLocation: '/settings',
          attemptedUri: Uri.parse('/settings'),
        );

        expect(Uri.parse(redirect!).path, '/login', reason: status.name);
      }
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';

void main() {
  const user = HbUser(
    id: 'user-1',
    email: 'user@example.test',
    displayName: 'Test User',
  );

  test('copyWith can explicitly clear nullable auth fields', () {
    const state = AuthState(
      status: AuthStatus.authenticated,
      user: user,
      errorMessage: 'old error',
      pendingUserId: 'pending-user',
      pendingEmail: 'pending@example.test',
    );

    final next = state.copyWith(
      user: null,
      errorMessage: null,
      pendingUserId: null,
      pendingEmail: null,
    );

    expect(next.user, isNull);
    expect(next.errorMessage, isNull);
    expect(next.pendingUserId, isNull);
    expect(next.pendingEmail, isNull);
  });

  test('copyWith preserves nullable auth fields when omitted', () {
    const state = AuthState(
      status: AuthStatus.authenticated,
      user: user,
      errorMessage: 'old error',
      pendingUserId: 'pending-user',
      pendingEmail: 'pending@example.test',
    );

    final next = state.copyWith(status: AuthStatus.loading);

    expect(next.status, AuthStatus.loading);
    expect(next.user, user);
    expect(next.errorMessage, 'old error');
    expect(next.pendingUserId, 'pending-user');
    expect(next.pendingEmail, 'pending@example.test');
  });

  test('didTransitionToUnauthenticated covers normal logout loading hop', () {
    expect(
      didTransitionToUnauthenticated(
        AuthStatus.authenticated,
        AuthStatus.unauthenticated,
      ),
      isTrue,
    );
    expect(
      didTransitionToUnauthenticated(
        AuthStatus.loading,
        AuthStatus.unauthenticated,
      ),
      isTrue,
    );
    expect(
      didTransitionToUnauthenticated(
        AuthStatus.initial,
        AuthStatus.unauthenticated,
      ),
      isFalse,
    );
    expect(
      didTransitionToUnauthenticated(
        AuthStatus.unauthenticated,
        AuthStatus.unauthenticated,
      ),
      isFalse,
    );
  });
}

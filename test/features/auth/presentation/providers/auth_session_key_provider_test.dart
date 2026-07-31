import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/core/network/auth_session_ownership.dart';
import 'package:lehiboo/features/auth/application/auth_session_transport_binding.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';

class _NeverCompletingAuthRepository implements AuthRepository {
  final _result = Completer<bool>();

  @override
  Future<bool> isAuthenticated() => _result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MutableAuthNotifier extends AuthNotifier {
  _MutableAuthNotifier(
    Ref ref, {
    HbUser? initialUser = _accountA,
  }) : super(_NeverCompletingAuthRepository(), ref) {
    if (initialUser == null) {
      publishGuest();
    } else {
      publish(initialUser);
    }
  }

  void publish(HbUser user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  void publishGuest() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

const _accountA = HbUser(
  id: 'account-a',
  email: 'a@example.test',
  displayName: 'Account A',
);

const _updatedAccountA = HbUser(
  id: 'account-a',
  email: 'updated-a@example.test',
  displayName: 'Updated Account A',
);

const _accountB = HbUser(
  id: 'account-b',
  email: 'b@example.test',
  displayName: 'Account B',
);

void main() {
  test('same-account publication keeps key; A to B to A replaces it', () {
    late _MutableAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _MutableAuthNotifier(ref);
          return auth;
        }),
      ],
    );
    addTearDown(container.dispose);

    final firstA = container.read(authSessionKeyProvider);
    auth.publish(_updatedAccountA);
    expect(identical(container.read(authSessionKeyProvider), firstA), isTrue);

    auth.publish(_accountB);
    auth.publish(_accountA);
    final secondA = container.read(authSessionKeyProvider);
    expect(secondA.accountId, 'account-a');
    expect(identical(secondA, firstA), isFalse);
  });

  test('transport attach forces a root epoch then rotates only by account', () {
    late _MutableAuthNotifier auth;
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith((ref) {
          auth = _MutableAuthNotifier(ref);
          return auth;
        }),
      ],
    );
    addTearDown(container.dispose);
    final registry = AuthSessionOwnershipRegistry.instance;
    registry.clearRetirement();
    registry.rotate(accountId: 'account-a');
    final priorRootA = registry.capture();

    final binding = AuthSessionTransportBinding.instance;
    binding.attach(container);
    addTearDown(binding.detach);
    final attachedA = registry.capture();
    expect(attachedA.accountId, 'account-a');
    expect(identical(attachedA, priorRootA), isFalse);

    auth.publish(_updatedAccountA);
    expect(identical(registry.capture(), attachedA), isTrue);

    auth.publish(_accountB);
    auth.publish(_accountA);
    expect(registry.capture().accountId, 'account-a');
    expect(identical(registry.capture(), attachedA), isFalse);
  });

  test('a newly attached guest root cannot inherit logout retirement', () {
    final container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(
          (ref) => _MutableAuthNotifier(ref, initialUser: null),
        ),
      ],
    );
    addTearDown(container.dispose);

    final registry = AuthSessionOwnershipRegistry.instance;
    registry.clearRetirement();
    registry.rotate(accountId: 'account-a');
    final retiredA = registry.capture();
    final retirement = registry.beginRetirement();
    registry.rotate(accountId: null);
    expect(
      identical(
        captureAuthSessionForPath(registry, '/auth/logout'),
        retiredA,
      ),
      isTrue,
    );

    final binding = AuthSessionTransportBinding.instance;
    binding.attach(container);
    addTearDown(binding.detach);
    addTearDown(retirement!.close);

    final attachedGuest = registry.capture();
    expect(attachedGuest.accountId, isNull);
    expect(
      identical(
        captureAuthSessionForPath(registry, '/auth/logout'),
        attachedGuest,
      ),
      isTrue,
    );
    expect(
      isAuthSessionAuthorizedForPath(registry, retiredA, '/auth/logout'),
      isFalse,
    );
  });
}

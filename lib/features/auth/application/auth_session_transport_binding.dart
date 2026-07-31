import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/auth_session_ownership.dart';
import '../presentation/providers/auth_provider.dart';

/// Keeps the transport's synchronous auth epoch aligned with Riverpod.
class AuthSessionTransportBinding {
  AuthSessionTransportBinding._();

  static final AuthSessionTransportBinding instance =
      AuthSessionTransportBinding._();

  ProviderSubscription<AuthState>? _subscription;

  void attach(ProviderContainer container) {
    _subscription?.close();
    // Retirement is scoped to the root that initiated logout. A replacement
    // root must never inherit permission to borrow that account's bearer,
    // even when the replacement root starts as a guest.
    AuthSessionOwnershipRegistry.instance.clearRetirement();
    // A new root container is a new session even if it restores the same
    // account id as the previously attached container.
    AuthSessionOwnershipRegistry.instance.rotate(
      accountId: _accountId(container.read(authProvider)),
    );
    _subscription = container.listen<AuthState>(
      authProvider,
      (_, next) => _rotate(next),
      fireImmediately: false,
    );
  }

  void detach() {
    _subscription?.close();
    _subscription = null;
    AuthSessionOwnershipRegistry.instance.clearRetirement();
    AuthSessionOwnershipRegistry.instance.rotate(accountId: null);
  }

  void _rotate(AuthState auth) {
    final accountId = _accountId(auth);
    // Same-account profile/error publications keep the epoch stable. Adjacent
    // A -> B -> A transitions still rotate twice and therefore cannot revive
    // work owned by the first A session.
    AuthSessionOwnershipRegistry.instance.rotateIfAccountChanged(
      accountId: accountId,
    );
  }

  String? _accountId(AuthState auth) {
    return auth.isAuthenticated ? auth.user?.id : null;
  }
}

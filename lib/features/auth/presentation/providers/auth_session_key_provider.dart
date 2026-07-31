import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

/// Opaque snapshot of the current authentication boundary.
///
/// Equality is intentionally identity-based. Direct [AuthState] listening
/// observes every adjacent account transition, so
/// an A -> B -> A cycle creates a distinct final key. Publications that keep
/// the same normalized account (profile/avatar/preferences/error metadata) do
/// not rotate it or cancel unrelated in-flight work.
/// `accountId == null` represents the current guest session.
@immutable
class AuthSessionKey {
  const AuthSessionKey._(this.accountId);

  final String? accountId;
}

class AuthSessionKeyController extends StateNotifier<AuthSessionKey> {
  AuthSessionKeyController(Ref ref) : super(const AuthSessionKey._(null)) {
    try {
      _replaceFromAuth(ref.read(authProvider));
      ref.listen<AuthState>(authProvider, (_, next) => _replaceFromAuth(next));
    } on UnimplementedError {
      // Small feature tests may override only the public account-id seam.
      _replace(ref.read(authSessionUserIdProvider));
      ref.listen<String?>(
        authSessionUserIdProvider,
        (_, next) => _replace(next),
      );
    }
  }

  void _replaceFromAuth(AuthState auth) {
    _replace(auth.isAuthenticated ? auth.user?.id : null);
  }

  void _replace(String? rawAccountId) {
    final trimmed = rawAccountId?.trim();
    final accountId = trimmed == null || trimmed.isEmpty ? null : trimmed;
    if (state.accountId == accountId) return;
    state = AuthSessionKey._(accountId);
  }
}

final authSessionKeyProvider =
    StateNotifierProvider<AuthSessionKeyController, AuthSessionKey>(
  AuthSessionKeyController.new,
);

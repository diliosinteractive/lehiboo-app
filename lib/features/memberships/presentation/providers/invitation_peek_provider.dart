import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../data/models/invitation_dto.dart';
import '../../domain/repositories/memberships_repository.dart';

/// Picks the right peek endpoint based on auth state — spec §7.
///
/// - Authenticated → `GET /me/invitations/{token}` (returns the same payload
///   shape as the public version, but identity-scoped).
/// - Unauthenticated → `GET /invitations/{token}` (public, no auth required;
///   includes `has_account` so the landing screen can decide whether to
///   show "Se connecter" vs "Créer un compte").
final invitationPeekProvider = StateNotifierProvider.autoDispose
    .family<InvitationPeekController, AsyncValue<InvitationPreviewDto>, String>(
  (ref, token) {
    final ownerSession = ref.watch(authSessionKeyProvider);
    final repo = ref.watch(membershipsRepositoryProvider);
    return InvitationPeekController(
      repo,
      ref,
      token: token,
      ownerSession: ownerSession,
    );
  },
);

class InvitationPeekController
    extends StateNotifier<AsyncValue<InvitationPreviewDto>> {
  InvitationPeekController(
    this._repository,
    this._ref, {
    required String token,
    required AuthSessionKey ownerSession,
  })  : _token = token,
        _ownerSession = ownerSession,
        super(const AsyncValue.loading()) {
    unawaited(_load());
  }

  final MembershipsRepository _repository;
  final Ref _ref;
  final String _token;
  final AuthSessionKey _ownerSession;
  int _requestGeneration = 0;

  bool get _ownsSessionContext {
    if (!mounted) return false;
    try {
      return identical(
        _ref.read(authSessionKeyProvider),
        _ownerSession,
      );
    } catch (_) {
      return false;
    }
  }

  Future<void> _load() async {
    final requestGeneration = ++_requestGeneration;
    if (!_ownsSessionContext) return;

    state = const AsyncValue.loading();
    try {
      final preview = _ownerSession.accountId == null
          ? await _repository.peekInvitationPublic(_token)
          : await _repository.peekInvitationAuthed(_token);
      if (!_ownsSessionContext || requestGeneration != _requestGeneration) {
        return;
      }
      state = AsyncValue.data(preview);
    } catch (error, stackTrace) {
      if (!_ownsSessionContext || requestGeneration != _requestGeneration) {
        return;
      }
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() => _load();
}

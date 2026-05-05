import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/invitation_dto.dart';
import '../../domain/repositories/memberships_repository.dart';

/// Picks the right peek endpoint based on auth state — spec §7.
///
/// - Authenticated → `GET /me/invitations/{token}` (returns the same payload
///   shape as the public version, but identity-scoped).
/// - Unauthenticated → `GET /invitations/{token}` (public, no auth required;
///   includes `has_account` so the landing screen can decide whether to
///   show "Se connecter" vs "Créer un compte").
final invitationPeekProvider =
    FutureProvider.family<InvitationPreviewDto, String>((ref, token) async {
  final isAuthenticated = ref.watch(
    authProvider.select((s) => s.isAuthenticated),
  );
  final repo = ref.watch(membershipsRepositoryProvider);
  return isAuthenticated
      ? repo.peekInvitationAuthed(token)
      : repo.peekInvitationPublic(token);
});

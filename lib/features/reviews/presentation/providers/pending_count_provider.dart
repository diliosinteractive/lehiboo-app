import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../domain/repositories/reviews_repository.dart';

/// Compteur d'avis en attente de modération pour l'utilisateur connecté.
/// Utilisé pour le badge de l'entrée "Mes Avis" dans le profil.
///
/// Renvoie 0 si l'utilisateur n'est pas connecté (pour éviter un appel inutile
/// qui retournerait 401).
final pendingReviewCountProvider =
    FutureProvider.autoDispose.family<int, AuthSessionKey>((ref, owner) async {
  var disposed = false;
  ref.onDispose(() => disposed = true);
  final activeSession = ref.watch(authSessionKeyProvider);
  if (owner.accountId == null || !identical(activeSession, owner)) return 0;

  final repo = ref.watch(reviewsRepositoryProvider);
  try {
    final count = await repo.getPendingCount();
    if (disposed || !identical(ref.read(authSessionKeyProvider), owner)) {
      return 0;
    }
    return count;
  } catch (e) {
    if (disposed || !identical(ref.read(authSessionKeyProvider), owner)) {
      return 0;
    }
    debugPrint('pendingReviewCountProvider error: $e');
    return 0;
  }
});

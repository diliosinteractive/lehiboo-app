import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/repositories/reviews_repository.dart';

/// Compteur d'avis en attente de modération pour l'utilisateur connecté.
/// Utilisé pour le badge de l'entrée "Mes Avis" dans le profil.
///
/// Renvoie 0 si l'utilisateur n'est pas connecté (pour éviter un appel inutile
/// qui retournerait 401).
final pendingReviewCountProvider = FutureProvider<int>((ref) async {
  final auth = ref.watch(authProvider);
  if (!auth.isAuthenticated) return 0;

  final repo = ref.watch(reviewsRepositoryProvider);
  try {
    return await repo.getPendingCount();
  } catch (e) {
    debugPrint('pendingReviewCountProvider error: $e');
    return 0;
  }
});

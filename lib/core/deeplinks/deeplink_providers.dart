import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'deeplink_service.dart';

/// Service de réception des deeplinks (cold + warm start).
final deeplinkServiceProvider = Provider<DeeplinkService>((ref) {
  return DeeplinkService();
});

/// Deeplink mis en attente pendant un redirect (typiquement quand
/// l'utilisateur doit s'authentifier avant d'accéder à la route cible).
/// Rejoué par le `redirect` du router une fois l'auth réussie.
final pendingDeeplinkProvider = StateProvider<String?>((ref) => null);

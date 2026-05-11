import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/providers/auth_provider.dart';
import '../presentation/providers/gamification_provider.dart';

/// Invalide les providers hibons/wallet utilisés sur la home dès que le statut
/// d'auth bascule. Cible les deux requêtes lancées par `HibonCounterWidget` :
/// `gamificationNotifierProvider` (`/me/wallet`) et `hibonsBalanceProvider`
/// (`/me/balance`).
///
/// Pourquoi : ces providers ne sont pas `autoDispose`, donc leur `AsyncValue`
/// survit à un logout. Sans invalidation, après un nouveau login le compteur
/// affiche la balance/le wallet du compte précédent jusqu'au prochain
/// pull-to-refresh.
///
/// Garder en vie : `ref.watch` dans `LeHibooApp.build` — le `ref.listen` ne
/// déclenche que tant que le provider est observé.
final hibonsAuthSyncProvider = Provider<void>((ref) {
  ref.listen<AuthStatus>(
    authProvider.select((s) => s.status),
    (previous, next) {
      final isLogin = next == AuthStatus.authenticated &&
          previous != AuthStatus.authenticated &&
          previous != AuthStatus.initial;
      final isLogout = next == AuthStatus.unauthenticated &&
          previous == AuthStatus.authenticated;

      if (!isLogin && !isLogout) return;

      if (kDebugMode) {
        debugPrint(
          '🪙 hibonsAuthSync: ${previous?.name ?? "null"} → ${next.name} '
          '→ invalidate wallet + balance',
        );
      }
      ref.invalidate(gamificationNotifierProvider);
      ref.invalidate(hibonsBalanceProvider);
    },
  );
});

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/providers/gamification_provider.dart';

/// Evicts the retired exact-session wallet/balance cache on auth changes.
/// Current consumers switch to a new family element synchronously, so an old
/// account's data is never used as `AsyncValue.previous` for the new account.
///
/// Garder en vie : `ref.watch` dans `LeHibooApp.build` — le `ref.listen` ne
/// déclenche que tant que le provider est observé.
final hibonsAuthSyncProvider = Provider<void>((ref) {
  ref.listen<GamificationSessionKey?>(
    gamificationSessionProvider,
    (previous, next) {
      if (identical(previous, next)) return;

      if (kDebugMode) {
        debugPrint(
          '🪙 hibonsAuthSync: exact session changed → evict retired wallet '
          '+ balance',
        );
      }
      if (previous != null) {
        ref.invalidate(gamificationNotifierProvider(previous));
        ref.invalidate(hibonsBalanceProvider(previous));
      }
    },
  );
});


import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lehiboo/features/gamification/data/models/hibons_wallet.dart';
import 'package:lehiboo/features/gamification/data/models/hibon_transaction.dart';
import 'package:lehiboo/features/gamification/data/models/daily_reward.dart';
import 'package:lehiboo/features/gamification/data/models/wheel_models.dart';
import 'package:lehiboo/features/gamification/data/models/gamification_items.dart';
import 'package:lehiboo/features/gamification/data/repositories/mock_gamification_repository.dart';
import 'package:lehiboo/features/gamification/domain/repositories/gamification_repository.dart';

final gamificationRepositoryProvider = Provider<GamificationRepository>((ref) {
  return MockGamificationRepository();
});

final gamificationNotifierProvider =
    AsyncNotifierProvider<GamificationNotifier, HibonsWallet>(() {
  return GamificationNotifier();
});

class GamificationNotifier extends AsyncNotifier<HibonsWallet> {
  late final GamificationRepository _repository;

  @override
  Future<HibonsWallet> build() async {
    _repository = ref.watch(gamificationRepositoryProvider);
    return _repository.getWallet();
  }

  // Not strictly used for earn/spend anymore if we use specific methods, but keeping generic update for now
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _repository.getWallet());
  }

  Future<void> earnHibons(int amount, String description) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.earnHibons(amount, description);
      return await _repository.getWallet();
    });
  }

  Future<void> spendHibons(int amount, String description) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.buyShopItem(description, amount);
      return await _repository.getWallet();
    });
  }
}

final dailyRewardProvider = AsyncNotifierProvider<DailyRewardNotifier, DailyRewardState>(() {
  return DailyRewardNotifier();
});

class DailyRewardNotifier extends AsyncNotifier<DailyRewardState> {
  @override
  Future<DailyRewardState> build() async {
    final repository = ref.watch(gamificationRepositoryProvider);
    return repository.getDailyRewardState();
  }

  Future<void> claim() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(gamificationRepositoryProvider);
      final newState = await repository.claimDailyReward();
      // Refresh wallet as balance changed
      ref.invalidate(gamificationNotifierProvider);
      return newState;
    });
  }
}

final achievementsProvider = FutureProvider<List<Achievement>>((ref) {
   final repository = ref.watch(gamificationRepositoryProvider);
   return repository.getAchievements();
});

final wheelConfigProvider = FutureProvider<WheelConfig>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getWheelConfig();
});

final hibonTransactionsProvider = FutureProvider<List<HibonTransaction>>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  // Watch the notifier to refresh transactions when profile changes (e.g. earn/spend)
  ref.watch(gamificationNotifierProvider);
  return repository.getTransactions();
});

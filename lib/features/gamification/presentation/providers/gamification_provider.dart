import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lehiboo/features/gamification/data/models/hibons_wallet.dart';
import 'package:lehiboo/features/gamification/data/models/hibon_transaction.dart';
import 'package:lehiboo/features/gamification/data/models/daily_reward.dart';
import 'package:lehiboo/features/gamification/data/models/wheel_models.dart';
import 'package:lehiboo/features/gamification/data/models/gamification_items.dart';
import 'package:lehiboo/features/gamification/data/datasources/gamification_api_datasource.dart';
import 'package:lehiboo/features/gamification/data/repositories/gamification_repository_impl.dart';
import 'package:lehiboo/features/gamification/domain/repositories/gamification_repository.dart';

// ==== Providers ====

final gamificationRepositoryProvider = Provider<GamificationRepository>((ref) {
  final dataSource = ref.read(gamificationApiDataSourceProvider);
  return GamificationRepositoryImpl(dataSource);
});

// ==== Wallet Provider ====

final gamificationNotifierProvider =
    AsyncNotifierProvider<GamificationNotifier, HibonsWallet>(() {
  return GamificationNotifier();
});

class GamificationNotifier extends AsyncNotifier<HibonsWallet> {
  @override
  Future<HibonsWallet> build() async {
    final repository = ref.watch(gamificationRepositoryProvider);
    return repository.getWallet();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repository = ref.read(gamificationRepositoryProvider);
    state = await AsyncValue.guard(() => repository.getWallet());
  }

  /// Rafraîchit le wallet après une action (claim, spin, etc.)
  Future<void> invalidateAndRefresh() async {
    ref.invalidateSelf();
  }
}

// ==== Daily Reward Provider ====

final dailyRewardProvider = AsyncNotifierProvider<DailyRewardNotifier, DailyRewardState>(() {
  return DailyRewardNotifier();
});

class DailyRewardNotifier extends AsyncNotifier<DailyRewardState> {
  @override
  Future<DailyRewardState> build() async {
    final repository = ref.watch(gamificationRepositoryProvider);
    return repository.getDailyRewardState();
  }

  Future<DailyClaimResult?> claim() async {
    final repository = ref.read(gamificationRepositoryProvider);

    try {
      final result = await repository.claimDailyReward();

      // Rafraîchir le state
      ref.invalidateSelf();
      // Rafraîchir le wallet aussi
      ref.invalidate(gamificationNotifierProvider);

      return result;
    } catch (e) {
      debugPrint('🎮 DailyRewardNotifier.claim error: $e');
      rethrow;
    }
  }
}

// ==== Wheel Providers ====

final wheelConfigProvider = FutureProvider<WheelConfig>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getWheelConfig();
});

final wheelSpinProvider = StateNotifierProvider<WheelSpinNotifier, AsyncValue<WheelSpinResult?>>((ref) {
  return WheelSpinNotifier(ref);
});

class WheelSpinNotifier extends StateNotifier<AsyncValue<WheelSpinResult?>> {
  final Ref _ref;

  WheelSpinNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<WheelSpinResult?> spin() async {
    state = const AsyncValue.loading();

    try {
      final repository = _ref.read(gamificationRepositoryProvider);
      final result = await repository.spinWheel();

      // Rafraîchir le wallet
      _ref.invalidate(gamificationNotifierProvider);

      state = AsyncValue.data(result);
      return result;
    } catch (e, st) {
      debugPrint('🎮 WheelSpinNotifier.spin error: $e');
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

// ==== Transactions Provider ====

final hibonTransactionsProvider = FutureProvider<List<HibonTransaction>>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  // Watch the wallet to refresh transactions when it changes
  ref.watch(gamificationNotifierProvider);
  return repository.getTransactions();
});

// ==== Achievements & Challenges Providers ====
// Note: Ces endpoints ne sont pas implémentés côté API

final achievementsProvider = FutureProvider<List<Achievement>>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getAchievements();
});

final challengesProvider = FutureProvider<List<Challenge>>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getChallenges();
});

// ==== Packages & Purchase Providers ====

final hibonPackagesProvider = FutureProvider<List<HibonPackage>>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getPackages();
});

final purchaseNotifierProvider = StateNotifierProvider<PurchaseNotifier, AsyncValue<PurchaseResult?>>((ref) {
  return PurchaseNotifier(ref);
});

class PurchaseNotifier extends StateNotifier<AsyncValue<PurchaseResult?>> {
  final Ref _ref;

  PurchaseNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<PurchaseResult?> createPurchase(String packageId) async {
    state = const AsyncValue.loading();

    try {
      final repository = _ref.read(gamificationRepositoryProvider);
      final result = await repository.createPurchase(packageId);
      state = AsyncValue.data(result);
      return result;
    } catch (e, st) {
      debugPrint('🎮 PurchaseNotifier.createPurchase error: $e');
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> confirmPurchase(String paymentIntentId) async {
    try {
      final repository = _ref.read(gamificationRepositoryProvider);
      await repository.confirmPurchase(paymentIntentId);

      // Rafraîchir le wallet
      _ref.invalidate(gamificationNotifierProvider);

      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      debugPrint('🎮 PurchaseNotifier.confirmPurchase error: $e');
      return false;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

// ==== Chat Unlock Provider ====

final chatUnlockProvider = StateNotifierProvider<ChatUnlockNotifier, AsyncValue<bool>>((ref) {
  return ChatUnlockNotifier(ref);
});

class ChatUnlockNotifier extends StateNotifier<AsyncValue<bool>> {
  final Ref _ref;

  ChatUnlockNotifier(this._ref) : super(const AsyncValue.data(false));

  Future<bool> unlock() async {
    state = const AsyncValue.loading();

    try {
      final repository = _ref.read(gamificationRepositoryProvider);
      await repository.unlockChatMessages();

      // Rafraîchir le wallet
      _ref.invalidate(gamificationNotifierProvider);

      state = const AsyncValue.data(true);
      return true;
    } catch (e, st) {
      debugPrint('🎮 ChatUnlockNotifier.unlock error: $e');
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  void reset() {
    state = const AsyncValue.data(false);
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lehiboo/features/gamification/data/models/earnings_by_pillar_entry.dart';
import 'package:lehiboo/features/gamification/data/models/hibon_badge.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_action_entry.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_balance.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_rank.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_update.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_wallet.dart';
import 'package:lehiboo/features/gamification/data/models/transactions_list_result.dart';
import 'package:lehiboo/features/gamification/data/models/daily_reward.dart';
import 'package:lehiboo/features/gamification/data/models/wheel_models.dart';
import 'package:lehiboo/features/gamification/data/models/gamification_items.dart';
import 'package:lehiboo/features/gamification/data/datasources/gamification_api_datasource.dart'
    show
        gamificationApiDataSourceProvider,
        HibonsPurchaseDisabledException;
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

  /// Met à jour le solde localement à partir d'une valeur autoritaire renvoyée
  /// par le backend (ex: `new_hibons_balance` lors d'un ajout en favori).
  ///
  /// Pas de round-trip réseau : l'UI se met à jour instantanément. Si le
  /// wallet n'a jamais été chargé, no-op (le prochain `build()` récupérera
  /// la valeur fraîche côté serveur de toute façon).
  void setBalance(int newBalance) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(balance: newBalance));
  }

  /// Applique l'enveloppe `hibons_update` reçue par l'intercepteur Dio.
  /// Met à jour balance, lifetime, et (si `rankChanged`) rank + rankLabel.
  void applyUpdate(HibonsUpdate update) {
    final current = state.valueOrNull;
    if (current == null) return;

    final nextRankEnum = update.rankChanged && update.newRank != null
        ? HibonsRank.fromString(update.newRank)
        : current.rankEnum;

    state = AsyncValue.data(current.copyWith(
      balance: update.newBalance,
      lifetimeEarned: update.newLifetime,
      rank: update.rankChanged ? (update.newRank ?? current.rank) : current.rank,
      rankEnum: nextRankEnum,
      rankLabel: update.rankChanged
          ? (update.newRankLabel ?? current.rankLabel)
          : current.rankLabel,
    ));
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

/// Liste des transactions + agrégats meta. Param `pillar` (nullable) filtre.
final hibonTransactionsProvider =
    FutureProvider.family<TransactionsListResult, String?>((ref, pillar) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  // Watch the wallet to refresh transactions when it changes
  ref.watch(gamificationNotifierProvider);
  return repository.getTransactions(pillar: pillar);
});

/// Breakdown des gains par pilier — dérivé du même appel `/transactions`,
/// pas de round-trip supplémentaire.
final earningsByPillarProvider = Provider<AsyncValue<List<EarningsByPillarEntry>>>((ref) {
  return ref
      .watch(hibonTransactionsProvider(null))
      .whenData((r) => r.earningsByPillar);
});

// ==== Transactions paginées (scroll infini) ====

/// Clé du family : combinaison des filtres `type` + `pillar`. Le record offre
/// une égalité structurelle, donc changer de filtre crée une nouvelle instance
/// de notifier qui charge automatiquement la page 1.
typedef TransactionsFilter = ({String? type, String? pillar});

const _transactionsPerPage = 20;

/// State de la liste paginée des transactions Hibons.
class HibonsTransactionsState {
  final AsyncValue<List<HibonTransaction>> transactions;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final int currentBalance;
  final int lifetimeEarned;

  const HibonsTransactionsState({
    this.transactions = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.currentBalance = 0,
    this.lifetimeEarned = 0,
  });

  HibonsTransactionsState copyWith({
    AsyncValue<List<HibonTransaction>>? transactions,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    int? currentBalance,
    int? lifetimeEarned,
  }) {
    return HibonsTransactionsState(
      transactions: transactions ?? this.transactions,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentBalance: currentBalance ?? this.currentBalance,
      lifetimeEarned: lifetimeEarned ?? this.lifetimeEarned,
    );
  }
}

class HibonsTransactionsNotifier extends StateNotifier<HibonsTransactionsState> {
  final GamificationRepository _repository;
  final TransactionsFilter _filter;

  HibonsTransactionsNotifier(this._repository, this._filter)
      : super(const HibonsTransactionsState()) {
    load();
  }

  /// Charge (ou recharge) la première page.
  Future<void> load() async {
    state = state.copyWith(
      transactions: const AsyncValue.loading(),
      currentPage: 1,
      hasMore: false,
    );
    try {
      final result = await _repository.getTransactions(
        type: _filter.type,
        pillar: _filter.pillar,
        page: 1,
        perPage: _transactionsPerPage,
      );
      state = state.copyWith(
        transactions: AsyncValue.data(result.items),
        currentPage: 1,
        hasMore: result.hasMore,
        currentBalance: result.currentBalance,
        lifetimeEarned: result.lifetimeEarned,
      );
    } catch (e, st) {
      debugPrint('🎮 HibonsTransactionsNotifier.load error: $e\n$st');
      state = state.copyWith(transactions: AsyncValue.error(e, st));
    }
  }

  /// Pull-to-refresh : identique à [load].
  Future<void> refresh() => load();

  /// Charge la page suivante et l'ajoute à la liste existante.
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    final current = state.transactions.valueOrNull;
    if (current == null) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.currentPage + 1;
      final result = await _repository.getTransactions(
        type: _filter.type,
        pillar: _filter.pillar,
        page: nextPage,
        perPage: _transactionsPerPage,
      );
      state = state.copyWith(
        transactions: AsyncValue.data([...current, ...result.items]),
        currentPage: nextPage,
        hasMore: result.hasMore,
        isLoadingMore: false,
        currentBalance: result.currentBalance,
        lifetimeEarned: result.lifetimeEarned,
      );
    } catch (_) {
      // Conserver la liste existante en cas d'échec d'une page suivante.
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

/// Liste paginée des transactions, filtrée par `type` + `pillar`.
final hibonsTransactionsListProvider = StateNotifierProvider.autoDispose
    .family<HibonsTransactionsNotifier, HibonsTransactionsState,
        TransactionsFilter>((ref, filter) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return HibonsTransactionsNotifier(repository, filter);
});

// ==== Balance & Actions Catalog (Plan 05) ====

/// Endpoint léger pour le badge header au cold start / pull-to-refresh.
final hibonsBalanceProvider = FutureProvider<HibonsBalance>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getBalance();
});

/// Catalogue dynamique des 15 actions Hibons (avec caps live).
final actionsCatalogProvider = FutureProvider<List<HibonsActionEntry>>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getActionsCatalog();
});

// ==== Achievements & Challenges Providers ====
// Note: Ces endpoints ne sont pas implémentés côté API

final achievementsProvider = FutureProvider<List<Achievement>>((ref) {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getAchievements();
});

/// 4 paliers de rang HIBONs (Curieux/Explorateur/Aventurier/Légende) avec
/// progression de l'utilisateur courant. Watch `gamificationNotifierProvider`
/// pour rafraîchir automatiquement quand le wallet change (lifetime_earned).
final hibonBadgesProvider = FutureProvider<HibonBadgesResult>((ref) {
  ref.watch(gamificationNotifierProvider);
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getBadges();
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
    } on HibonsPurchaseDisabledException {
      debugPrint('🎮 PurchaseNotifier: purchase disabled, ignoring');
      state = const AsyncValue.data(null);
      return null;
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
    } on HibonsPurchaseDisabledException {
      debugPrint('🎮 PurchaseNotifier: purchase disabled, ignoring');
      state = const AsyncValue.data(null);
      return false;
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

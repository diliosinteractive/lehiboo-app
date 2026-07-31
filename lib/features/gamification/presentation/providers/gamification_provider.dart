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
    show gamificationApiDataSourceProvider, HibonsPurchaseDisabledException;
import 'package:lehiboo/features/gamification/data/repositories/gamification_repository_impl.dart';
import 'package:lehiboo/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';

// ==== Providers ====

/// Backwards-compatible name for the app-wide exact authentication epoch.
///
/// Keeping one central identity prevents gamification from inventing a new
/// epoch on harmless same-account profile publications while still making an
/// A -> B -> A cycle distinct from the original A session.
typedef GamificationSessionKey = AuthSessionKey;

final gamificationSessionProvider = Provider<GamificationSessionKey?>((ref) {
  final session = ref.watch(authSessionKeyProvider);
  return session.accountId == null ? null : session;
});

final gamificationRepositoryProvider = Provider<GamificationRepository>((ref) {
  // Recreate the repository as well: it owns an in-memory wallet cache used by
  // wheel configuration and must never cross an account boundary.
  ref.watch(gamificationSessionProvider);
  final dataSource = ref.read(gamificationApiDataSourceProvider);
  return GamificationRepositoryImpl(dataSource);
});

// ==== Wallet Provider ====

final gamificationNotifierProvider = AsyncNotifierProvider.family<
    GamificationNotifier,
    HibonsWallet,
    GamificationSessionKey?>(GamificationNotifier.new);

class GamificationNotifier
    extends FamilyAsyncNotifier<HibonsWallet, GamificationSessionKey?> {
  int _requestGeneration = 0;
  Future<void>? _refreshInFlight;
  GamificationSessionKey? _refreshSession;
  GamificationSessionKey? _ownerSession;
  bool _disposed = false;

  void _registerBuildLifecycle() {
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      _requestGeneration++;
    });
  }

  @override
  Future<HibonsWallet> build(GamificationSessionKey? ownerSession) async {
    _registerBuildLifecycle();
    _ownerSession = ownerSession;
    final generation = ++_requestGeneration;
    final currentSession = ref.watch(gamificationSessionProvider);
    if (ownerSession == null || !identical(currentSession, ownerSession)) {
      return const HibonsWallet();
    }

    final repository = ref.watch(gamificationRepositoryProvider);
    try {
      final wallet = await repository.getWallet();
      if (!_isCurrent(ownerSession, generation)) {
        return _settleStaleBuild();
      }
      return wallet;
    } catch (error, stackTrace) {
      if (_isCurrent(ownerSession, generation)) {
        Error.throwWithStackTrace(error, stackTrace);
      }
      return _settleStaleBuild();
    }
  }

  Future<void> refresh({GamificationSessionKey? expectedSession}) {
    if (_disposed) return Future.value();
    final session = ref.read(gamificationSessionProvider);
    if (!identical(session, _ownerSession)) return Future.value();
    if (expectedSession != null && !identical(session, expectedSession)) {
      return Future.value();
    }
    if (session == null) {
      _requestGeneration++;
      state = const AsyncValue.data(HibonsWallet());
      return Future.value();
    }

    final inFlight = _refreshInFlight;
    if (inFlight != null && identical(_refreshSession, session)) {
      return inFlight;
    }

    final generation = ++_requestGeneration;
    _refreshSession = session;
    late final Future<void> refresh;
    refresh = _performRefresh(session, generation).whenComplete(() {
      if (identical(_refreshInFlight, refresh)) {
        _refreshInFlight = null;
        _refreshSession = null;
      }
    });
    _refreshInFlight = refresh;
    return refresh;
  }

  Future<void> _performRefresh(
    GamificationSessionKey session,
    int generation,
  ) async {
    final previous = state;
    state = const AsyncLoading<HibonsWallet>().copyWithPrevious(previous);
    final repository = ref.read(gamificationRepositoryProvider);
    try {
      final wallet = await repository.getWallet();
      if (_isCurrent(session, generation)) {
        state = AsyncValue.data(wallet);
      }
    } catch (error, stackTrace) {
      if (_isCurrent(session, generation)) {
        state = AsyncError<HibonsWallet>(
          error,
          stackTrace,
        ).copyWithPrevious(previous);
      }
      rethrow;
    }
  }

  Future<HibonsWallet> _settleStaleBuild() async {
    if (_disposed) return const HibonsWallet();
    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      try {
        await inFlight;
      } catch (_) {
        // Mirror the current refresh state below.
      }
    }

    final current = state;
    final currentError = current.asError;
    if (currentError != null) {
      Error.throwWithStackTrace(
        currentError.error,
        currentError.stackTrace,
      );
    }
    return current.valueOrNull ?? const HibonsWallet();
  }

  bool _isCurrent(GamificationSessionKey session, int generation) {
    return !_disposed &&
        generation == _requestGeneration &&
        identical(ref.read(gamificationSessionProvider), session);
  }

  /// Rafraîchit le wallet après une action (claim, spin, etc.)
  Future<void> invalidateAndRefresh({
    required GamificationSessionKey ownerSession,
  }) async {
    if (_disposed) return;
    if (!identical(ref.read(gamificationSessionProvider), ownerSession)) return;
    ref.invalidateSelf();
  }

  /// Met à jour le solde localement à partir d'une valeur autoritaire renvoyée
  /// par le backend (ex: `new_hibons_balance` lors d'un ajout en favori).
  ///
  /// Pas de round-trip réseau : l'UI se met à jour instantanément. Si le
  /// wallet n'a jamais été chargé, no-op (le prochain `build()` récupérera
  /// la valeur fraîche côté serveur de toute façon).
  void setBalance(
    int newBalance, {
    required GamificationSessionKey ownerSession,
  }) {
    if (_disposed) return;
    if (!identical(ref.read(gamificationSessionProvider), ownerSession)) return;
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(balance: newBalance));
  }

  /// Applique l'enveloppe `hibons_update` reçue par l'intercepteur Dio.
  /// Met à jour balance, lifetime, et (si `rankChanged`) rank + rankLabel.
  void applyUpdate(
    HibonsUpdate update, {
    required GamificationSessionKey ownerSession,
  }) {
    if (_disposed) return;
    if (!identical(ref.read(gamificationSessionProvider), ownerSession)) return;
    final current = state.valueOrNull;
    if (current == null) return;

    final nextRankEnum = update.rankChanged && update.newRank != null
        ? HibonsRank.fromString(update.newRank)
        : current.rankEnum;

    state = AsyncValue.data(current.copyWith(
      balance: update.newBalance,
      lifetimeEarned: update.newLifetime,
      rank:
          update.rankChanged ? (update.newRank ?? current.rank) : current.rank,
      rankEnum: nextRankEnum,
      rankLabel: update.rankChanged
          ? (update.newRankLabel ?? current.rankLabel)
          : current.rankLabel,
    ));
  }
}

// ==== Daily Reward Provider ====

final dailyRewardProvider = AsyncNotifierProvider.family<DailyRewardNotifier,
    DailyRewardState, GamificationSessionKey?>(DailyRewardNotifier.new);

class DailyRewardNotifier
    extends FamilyAsyncNotifier<DailyRewardState, GamificationSessionKey?> {
  GamificationSessionKey? _ownerSession;
  bool _disposed = false;

  void _registerBuildLifecycle() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);
  }

  @override
  Future<DailyRewardState> build(GamificationSessionKey? ownerSession) async {
    _registerBuildLifecycle();
    _ownerSession = ownerSession;
    final currentSession = ref.watch(gamificationSessionProvider);
    if (ownerSession == null || !identical(currentSession, ownerSession)) {
      return _emptyDailyRewardState();
    }

    final repository = ref.watch(gamificationRepositoryProvider);
    return repository.getDailyRewardState();
  }

  Future<DailyClaimResult?> claim({
    required GamificationSessionKey expectedSession,
  }) async {
    if (_disposed) return null;
    final session = ref.read(gamificationSessionProvider);
    if (session == null ||
        !identical(session, _ownerSession) ||
        !identical(session, expectedSession)) {
      return null;
    }

    final repository = ref.read(gamificationRepositoryProvider);

    try {
      final result = await repository.claimDailyReward();
      if (!_ownsSession(session)) return null;

      // Rafraîchir le state
      ref.invalidateSelf();
      // Rafraîchir le wallet aussi
      ref.invalidate(gamificationNotifierProvider(session));

      return result;
    } catch (e) {
      if (!_ownsSession(session)) return null;
      debugPrint('🎮 DailyRewardNotifier.claim error: $e');
      rethrow;
    }
  }

  bool _ownsSession(GamificationSessionKey session) {
    return !_disposed &&
        identical(ref.read(gamificationSessionProvider), session);
  }
}

// ==== Wheel Providers ====

final wheelConfigProvider =
    FutureProvider.family<WheelConfig, GamificationSessionKey?>((ref, session) {
  if (session == null ||
      !identical(ref.watch(gamificationSessionProvider), session)) {
    return Future.value(const WheelConfig(prizes: []));
  }

  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getWheelConfig();
});

final wheelSpinProvider =
    StateNotifierProvider<WheelSpinNotifier, AsyncValue<WheelSpinResult?>>(
        (ref) {
  final session = ref.watch(gamificationSessionProvider);
  return WheelSpinNotifier(ref, ownerSession: session);
});

class WheelSpinNotifier extends StateNotifier<AsyncValue<WheelSpinResult?>> {
  final Ref _ref;
  final GamificationSessionKey? _ownerSession;
  int _operationGeneration = 0;

  WheelSpinNotifier(
    this._ref, {
    required GamificationSessionKey? ownerSession,
  })  : _ownerSession = ownerSession,
        super(const AsyncValue.data(null));

  bool get _ownsSession {
    final owner = _ownerSession;
    return mounted &&
        owner != null &&
        identical(_ref.read(gamificationSessionProvider), owner);
  }

  Future<WheelSpinResult?> spin() async {
    if (!_ownsSession) return null;
    final generation = ++_operationGeneration;

    state = const AsyncValue.loading();

    try {
      final repository = _ref.read(gamificationRepositoryProvider);
      final result = await repository.spinWheel();
      if (!_ownsSession || generation != _operationGeneration) return null;

      // Rafraîchir le wallet
      _ref.invalidate(gamificationNotifierProvider(_ownerSession));

      state = AsyncValue.data(result);
      return result;
    } catch (e, st) {
      if (!_ownsSession || generation != _operationGeneration) return null;
      debugPrint('🎮 WheelSpinNotifier.spin error: $e');
      state = AsyncValue.error(e, st);
      Error.throwWithStackTrace(e, st);
    }
  }

  void reset() {
    if (!_ownsSession) return;
    _operationGeneration++;
    state = const AsyncValue.data(null);
  }
}

// ==== Transactions Provider ====

/// Exact-session query for the transactions summary endpoint.
typedef HibonTransactionsQuery = ({
  GamificationSessionKey? session,
  String? pillar,
});

/// Liste des transactions + agrégats meta. Param `pillar` (nullable) filtre.
final hibonTransactionsProvider =
    FutureProvider.family<TransactionsListResult, HibonTransactionsQuery>(
        (ref, query) async {
  final session = query.session;
  if (session == null ||
      !identical(ref.watch(gamificationSessionProvider), session)) {
    return TransactionsListResult.empty;
  }

  final repository = ref.watch(gamificationRepositoryProvider);
  // Watch the wallet to refresh transactions when it changes
  ref.watch(gamificationNotifierProvider(session));
  return repository.getTransactions(pillar: query.pillar);
});

/// Breakdown des gains par pilier — dérivé du même appel `/transactions`,
/// pas de round-trip supplémentaire.
final earningsByPillarProvider = Provider.family<
    AsyncValue<List<EarningsByPillarEntry>>,
    GamificationSessionKey?>((ref, session) {
  return ref
      .watch(hibonTransactionsProvider((session: session, pillar: null)))
      .whenData((r) => r.earningsByPillar);
});

// ==== Transactions paginées (scroll infini) ====

/// Clé du family : combinaison des filtres `type` + `pillar`. Le record offre
/// une égalité structurelle, donc changer de filtre crée une nouvelle instance
/// de notifier qui charge automatiquement la page 1.
typedef TransactionsFilter = ({String? type, String? pillar});

typedef SessionTransactionsFilter = ({
  GamificationSessionKey? session,
  TransactionsFilter filter,
});

const _transactionsPerPage = 20;

/// State de la liste paginée des transactions Hibons.
class HibonsTransactionsState {
  static const Object _loadMoreErrorUnset = Object();

  final AsyncValue<List<HibonTransaction>> transactions;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final Object? loadMoreError;
  final int currentBalance;
  final int lifetimeEarned;

  const HibonsTransactionsState({
    this.transactions = const AsyncValue.loading(),
    this.currentPage = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreError,
    this.currentBalance = 0,
    this.lifetimeEarned = 0,
  });

  HibonsTransactionsState copyWith({
    AsyncValue<List<HibonTransaction>>? transactions,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    Object? loadMoreError = _loadMoreErrorUnset,
    int? currentBalance,
    int? lifetimeEarned,
  }) {
    return HibonsTransactionsState(
      transactions: transactions ?? this.transactions,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: identical(loadMoreError, _loadMoreErrorUnset)
          ? this.loadMoreError
          : loadMoreError,
      currentBalance: currentBalance ?? this.currentBalance,
      lifetimeEarned: lifetimeEarned ?? this.lifetimeEarned,
    );
  }
}

class HibonsTransactionsNotifier
    extends StateNotifier<HibonsTransactionsState> {
  final GamificationRepository _repository;
  final TransactionsFilter _filter;
  final bool Function() _ownsSession;
  int _requestGeneration = 0;

  HibonsTransactionsNotifier(
    this._repository,
    this._filter, {
    bool hasActiveSession = true,
    bool Function()? ownsSession,
  })  : _ownsSession = ownsSession ?? (() => true),
        super(
          hasActiveSession
              ? const HibonsTransactionsState()
              : const HibonsTransactionsState(
                  transactions: AsyncValue.data([]),
                ),
        ) {
    if (hasActiveSession) load();
  }

  bool get _canPublish => mounted && _ownsSession();

  void _publish(HibonsTransactionsState next) {
    if (_canPublish) state = next;
  }

  /// Charge (ou recharge) la première page.
  Future<void> load() async {
    if (!_canPublish) return;
    final generation = ++_requestGeneration;
    _publish(state.copyWith(
      transactions: const AsyncValue.loading(),
      currentPage: 1,
      hasMore: false,
      isLoadingMore: false,
      loadMoreError: null,
    ));
    try {
      final result = await _repository.getTransactions(
        type: _filter.type,
        pillar: _filter.pillar,
        page: 1,
        perPage: _transactionsPerPage,
      );
      if (!_canPublish || generation != _requestGeneration) return;
      _publish(state.copyWith(
        transactions: AsyncValue.data(result.items),
        currentPage: 1,
        hasMore: result.hasMore,
        currentBalance: result.currentBalance,
        lifetimeEarned: result.lifetimeEarned,
      ));
    } catch (e, st) {
      debugPrint('🎮 HibonsTransactionsNotifier.load error: $e\n$st');
      if (!_canPublish || generation != _requestGeneration) return;
      _publish(state.copyWith(transactions: AsyncValue.error(e, st)));
    }
  }

  /// Pull-to-refresh : identique à [load].
  Future<void> refresh() => load();

  /// Charge la page suivante et l'ajoute à la liste existante.
  Future<void> loadMore() async {
    if (!_canPublish ||
        state.isLoadingMore ||
        !state.hasMore ||
        state.loadMoreError != null) {
      return;
    }
    final current = state.transactions.valueOrNull;
    if (current == null) return;

    final generation = ++_requestGeneration;
    final nextPage = state.currentPage + 1;
    _publish(state.copyWith(isLoadingMore: true, loadMoreError: null));
    try {
      final result = await _repository.getTransactions(
        type: _filter.type,
        pillar: _filter.pillar,
        page: nextPage,
        perPage: _transactionsPerPage,
      );
      if (!_canPublish || generation != _requestGeneration) return;
      _publish(state.copyWith(
        transactions: AsyncValue.data([...current, ...result.items]),
        currentPage: nextPage,
        hasMore: result.hasMore,
        isLoadingMore: false,
        loadMoreError: null,
        currentBalance: result.currentBalance,
        lifetimeEarned: result.lifetimeEarned,
      ));
    } catch (error) {
      if (!_canPublish || generation != _requestGeneration) return;
      _publish(state.copyWith(
        isLoadingMore: false,
        loadMoreError: error,
      ));
    }
  }

  Future<void> retryLoadMore() async {
    if (!_canPublish || state.loadMoreError == null) return;
    _publish(state.copyWith(loadMoreError: null));
    await loadMore();
  }
}

/// Liste paginée des transactions, filtrée par `type` + `pillar`.
final hibonsTransactionsListProvider = StateNotifierProvider.autoDispose.family<
    HibonsTransactionsNotifier,
    HibonsTransactionsState,
    SessionTransactionsFilter>((ref, query) {
  final session = query.session;
  final currentSession = ref.watch(gamificationSessionProvider);
  final repository = ref.watch(gamificationRepositoryProvider);
  return HibonsTransactionsNotifier(
    repository,
    query.filter,
    hasActiveSession: session != null && identical(currentSession, session),
    ownsSession: () =>
        session != null &&
        identical(ref.read(gamificationSessionProvider), session),
  );
});

// ==== Balance & Actions Catalog (Plan 05) ====

/// Endpoint léger pour le badge header au cold start / pull-to-refresh.
final hibonsBalanceProvider =
    FutureProvider.family<HibonsBalance, GamificationSessionKey?>(
        (ref, session) {
  if (session == null ||
      !identical(ref.watch(gamificationSessionProvider), session)) {
    return Future.value(_emptyHibonsBalance);
  }

  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getBalance();
});

const _emptyHibonsBalance = HibonsBalance(
  balance: 0,
  lifetimeEarned: 0,
  rank: 'curieux',
  rankLabel: 'Curieux',
  rankIcon: '🔍',
);

/// Catalogue dynamique des 15 actions Hibons (avec caps live).
final actionsCatalogProvider =
    FutureProvider.family<List<HibonsActionEntry>, GamificationSessionKey?>(
        (ref, session) {
  if (session == null ||
      !identical(ref.watch(gamificationSessionProvider), session)) {
    return Future.value(const []);
  }

  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getActionsCatalog();
});

// ==== Achievements & Challenges Providers ====
// Note: Ces endpoints ne sont pas implémentés côté API

final achievementsProvider =
    FutureProvider.family<List<Achievement>, GamificationSessionKey?>(
        (ref, session) {
  if (session == null ||
      !identical(ref.watch(gamificationSessionProvider), session)) {
    return Future.value(const []);
  }

  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getAchievements();
});

/// 4 paliers de rang HIBONs (Curieux/Explorateur/Aventurier/Légende) avec
/// progression de l'utilisateur courant. Watch `gamificationNotifierProvider`
/// pour rafraîchir automatiquement quand le wallet change (lifetime_earned).
final hibonBadgesProvider =
    FutureProvider.family<HibonBadgesResult, GamificationSessionKey?>(
        (ref, session) {
  if (session == null ||
      !identical(ref.watch(gamificationSessionProvider), session)) {
    return Future.value(HibonBadgesResult.empty);
  }

  ref.watch(gamificationNotifierProvider(session));
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getBadges();
});

final challengesProvider =
    FutureProvider.family<List<Challenge>, GamificationSessionKey?>(
        (ref, session) {
  if (session == null ||
      !identical(ref.watch(gamificationSessionProvider), session)) {
    return Future.value(const []);
  }

  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getChallenges();
});

// ==== Packages & Purchase Providers ====

final hibonPackagesProvider =
    FutureProvider.family<List<HibonPackage>, GamificationSessionKey?>(
        (ref, session) {
  if (session == null ||
      !identical(ref.watch(gamificationSessionProvider), session)) {
    return Future.value(const []);
  }

  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getPackages();
});

final purchaseNotifierProvider =
    StateNotifierProvider<PurchaseNotifier, AsyncValue<PurchaseResult?>>((ref) {
  final session = ref.watch(gamificationSessionProvider);
  return PurchaseNotifier(ref, ownerSession: session);
});

class PurchaseNotifier extends StateNotifier<AsyncValue<PurchaseResult?>> {
  final Ref _ref;
  final GamificationSessionKey? _ownerSession;
  int _operationGeneration = 0;

  PurchaseNotifier(
    this._ref, {
    required GamificationSessionKey? ownerSession,
  })  : _ownerSession = ownerSession,
        super(const AsyncValue.data(null));

  bool get _ownsSession {
    final owner = _ownerSession;
    return mounted &&
        owner != null &&
        identical(_ref.read(gamificationSessionProvider), owner);
  }

  Future<PurchaseResult?> createPurchase(String packageId) async {
    if (!_ownsSession) return null;
    final generation = ++_operationGeneration;

    state = const AsyncValue.loading();

    try {
      final repository = _ref.read(gamificationRepositoryProvider);
      final result = await repository.createPurchase(packageId);
      if (!_ownsSession || generation != _operationGeneration) return null;
      state = AsyncValue.data(result);
      return result;
    } on HibonsPurchaseDisabledException {
      if (!_ownsSession || generation != _operationGeneration) return null;
      debugPrint('🎮 PurchaseNotifier: purchase disabled, ignoring');
      state = const AsyncValue.data(null);
      return null;
    } catch (e, st) {
      if (!_ownsSession || generation != _operationGeneration) return null;
      debugPrint('🎮 PurchaseNotifier.createPurchase error: $e');
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<bool> confirmPurchase(String paymentIntentId) async {
    if (!_ownsSession) return false;
    final generation = ++_operationGeneration;

    try {
      final repository = _ref.read(gamificationRepositoryProvider);
      await repository.confirmPurchase(paymentIntentId);
      if (!_ownsSession || generation != _operationGeneration) return false;

      // Rafraîchir le wallet
      _ref.invalidate(gamificationNotifierProvider(_ownerSession));

      state = const AsyncValue.data(null);
      return true;
    } on HibonsPurchaseDisabledException {
      if (!_ownsSession || generation != _operationGeneration) return false;
      debugPrint('🎮 PurchaseNotifier: purchase disabled, ignoring');
      state = const AsyncValue.data(null);
      return false;
    } catch (e) {
      if (!_ownsSession || generation != _operationGeneration) return false;
      debugPrint('🎮 PurchaseNotifier.confirmPurchase error: $e');
      return false;
    }
  }

  void reset() {
    if (!_ownsSession) return;
    _operationGeneration++;
    state = const AsyncValue.data(null);
  }
}

// ==== Chat Unlock Provider ====

final chatUnlockProvider =
    StateNotifierProvider<ChatUnlockNotifier, AsyncValue<bool>>((ref) {
  final session = ref.watch(gamificationSessionProvider);
  return ChatUnlockNotifier(ref, ownerSession: session);
});

class ChatUnlockNotifier extends StateNotifier<AsyncValue<bool>> {
  final Ref _ref;
  final GamificationSessionKey? _ownerSession;
  int _operationGeneration = 0;

  ChatUnlockNotifier(
    this._ref, {
    required GamificationSessionKey? ownerSession,
  })  : _ownerSession = ownerSession,
        super(const AsyncValue.data(false));

  bool get _ownsSession {
    final owner = _ownerSession;
    return mounted &&
        owner != null &&
        identical(_ref.read(gamificationSessionProvider), owner);
  }

  Future<bool> unlock({GamificationSessionKey? expectedSession}) async {
    if (!_ownsSession ||
        (expectedSession != null &&
            !identical(_ownerSession, expectedSession))) {
      return false;
    }
    final generation = ++_operationGeneration;

    state = const AsyncValue.loading();

    try {
      final repository = _ref.read(gamificationRepositoryProvider);
      await repository.unlockChatMessages();
      if (!_ownsSession || generation != _operationGeneration) return false;

      // Rafraîchir le wallet
      _ref.invalidate(gamificationNotifierProvider(_ownerSession));

      state = const AsyncValue.data(true);
      return true;
    } catch (e, st) {
      if (!_ownsSession || generation != _operationGeneration) return false;
      debugPrint('🎮 ChatUnlockNotifier.unlock error: $e');
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  void reset() {
    if (!_ownsSession) return;
    _operationGeneration++;
    state = const AsyncValue.data(false);
  }
}

DailyRewardState _emptyDailyRewardState() {
  return DailyRewardState(
    currentDay: 1,
    isClaimedToday: false,
    lastClaimDate: DateTime.fromMillisecondsSinceEpoch(0),
    days: const [],
  );
}

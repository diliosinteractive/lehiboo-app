import 'dart:async';
import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/analytics/analytics_provider.dart';
import 'package:lehiboo/core/analytics/noop_analytics_service.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/gamification/data/models/gamification_items.dart';
import 'package:lehiboo/features/gamification/data/models/daily_reward.dart';
import 'package:lehiboo/features/gamification/data/models/hibon_badge.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_action_entry.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_balance.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_wallet.dart';
import 'package:lehiboo/features/gamification/data/models/transactions_list_result.dart';
import 'package:lehiboo/features/gamification/data/models/wheel_models.dart';
import 'package:lehiboo/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:lehiboo/features/gamification/presentation/providers/gamification_provider.dart';

class _AnonymousAuthRepository implements AuthRepository {
  @override
  Future<bool> isAuthenticated() async => false;

  @override
  Future<HbUser?> getCurrentUser() async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _ControlledGamificationRepository implements GamificationRepository {
  Completer<DailyClaimResult>? dailyClaim;
  Completer<WheelSpinResult>? wheelSpin;
  Completer<PurchaseResult>? purchase;
  Completer<void>? unlock;
  final Queue<Future<TransactionsListResult>> transactionResponses = Queue();
  final Queue<Future<HibonsWallet>> walletResponses = Queue();

  int dailyClaimCalls = 0;
  int wheelSpinCalls = 0;
  int purchaseCalls = 0;
  int unlockCalls = 0;
  int transactionCalls = 0;
  int walletCalls = 0;

  @override
  Future<HibonsWallet> getWallet() {
    walletCalls++;
    return walletResponses.removeFirst();
  }

  @override
  Future<DailyRewardState> getDailyRewardState() async => DailyRewardState(
        currentDay: 1,
        isClaimedToday: false,
        lastClaimDate: DateTime(2026),
        days: const [],
      );

  @override
  Future<DailyClaimResult> claimDailyReward() {
    dailyClaimCalls++;
    return dailyClaim!.future;
  }

  @override
  Future<WheelSpinResult> spinWheel() {
    wheelSpinCalls++;
    return wheelSpin!.future;
  }

  @override
  Future<PurchaseResult> createPurchase(String packageId) {
    purchaseCalls++;
    return purchase!.future;
  }

  @override
  Future<void> unlockChatMessages() {
    unlockCalls++;
    return unlock!.future;
  }

  @override
  Future<TransactionsListResult> getTransactions({
    String? type,
    String? pillar,
    int? page,
    int? perPage,
  }) {
    transactionCalls++;
    return transactionResponses.removeFirst();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SurfaceGamificationRepository extends _ControlledGamificationRepository {
  bool blockReads = false;

  Future<T> _result<T>(T value) => blockReads
      ? Future<T>.delayed(Duration.zero, () => value)
      : Future<T>.value(value);

  @override
  Future<HibonsWallet> getWallet() => _result(const HibonsWallet(balance: 101));

  @override
  Future<DailyRewardState> getDailyRewardState() => _result(
        DailyRewardState(
          currentDay: 7,
          isClaimedToday: false,
          lastClaimDate: DateTime(2026),
          days: const [],
        ),
      );

  @override
  Future<WheelConfig> getWheelConfig() =>
      _result(const WheelConfig(prizes: []));

  @override
  Future<TransactionsListResult> getTransactions({
    String? type,
    String? pillar,
    int? page,
    int? perPage,
  }) =>
      _result(_transactions('private-a'));

  @override
  Future<HibonsBalance> getBalance() => _result(const HibonsBalance(
        balance: 101,
        lifetimeEarned: 101,
        rank: 'curieux',
        rankLabel: 'Curieux',
        rankIcon: 'icon',
      ));

  @override
  Future<List<HibonsActionEntry>> getActionsCatalog() => _result(const []);

  @override
  Future<List<Achievement>> getAchievements() => _result(const []);

  @override
  Future<HibonBadgesResult> getBadges() => _result(HibonBadgesResult.empty);

  @override
  Future<List<Challenge>> getChallenges() => _result(const []);

  @override
  Future<List<HibonPackage>> getPackages() => _result(const []);
}

const _accountA = HbUser(
  id: 'account-a',
  email: 'a@example.test',
  displayName: 'Account A',
);

const _accountB = HbUser(
  id: 'account-b',
  email: 'b@example.test',
  displayName: 'Account B',
);

void main() {
  test('all private surfaces blank immediately on A to B', () async {
    final repository = _SurfaceGamificationRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    await _authenticate(container, _accountA);
    final accountA = container.read(gamificationSessionProvider)!;
    await _loadAllPrivateSurfaces(container, accountA);
    _expectAllPrivateSurfacesHaveData(container, accountA);
    final accountAWalletNotifier =
        container.read(gamificationNotifierProvider(accountA).notifier);
    final accountADailyNotifier =
        container.read(dailyRewardProvider(accountA).notifier);

    repository.blockReads = true;
    container.read(authProvider.notifier).setAuthenticatedUser(_accountB);
    final accountB = container.read(gamificationSessionProvider)!;
    expect(identical(accountB, accountA), isFalse);
    _expectAllPrivateSurfacesBlank(container, accountB);
    expect(
      identical(
        container.read(gamificationNotifierProvider(accountB).notifier),
        accountAWalletNotifier,
      ),
      isFalse,
    );
    expect(
      identical(
        container.read(dailyRewardProvider(accountB).notifier),
        accountADailyNotifier,
      ),
      isFalse,
    );
  });

  test('all private surfaces blank after no-yield A to B to A', () async {
    final repository = _SurfaceGamificationRepository();
    final container = _container(repository);
    addTearDown(container.dispose);

    await _authenticate(container, _accountA);
    final accountA = container.read(gamificationSessionProvider)!;
    await _loadAllPrivateSurfaces(container, accountA);

    repository.blockReads = true;
    container.read(authProvider.notifier).setAuthenticatedUser(_accountB);
    container.read(authProvider.notifier).setAuthenticatedUser(_accountA);
    final accountA2 = container.read(gamificationSessionProvider)!;
    expect(identical(accountA2, accountA), isFalse);
    _expectAllPrivateSurfacesBlank(container, accountA2);
  });

  test('stale A mutations are neutral after an A -> B -> A cycle', () async {
    final repository = _ControlledGamificationRepository()
      ..dailyClaim = Completer<DailyClaimResult>()
      ..wheelSpin = Completer<WheelSpinResult>()
      ..purchase = Completer<PurchaseResult>()
      ..unlock = Completer<void>();
    final container = _container(repository);
    addTearDown(container.dispose);

    await _authenticate(container, _accountA);
    final ownerSession = container.read(gamificationSessionProvider)!;

    final dailySubscription = container.listen(
      dailyRewardProvider(ownerSession),
      (_, __) {},
      fireImmediately: true,
    );
    final wheelSubscription = container.listen(
      wheelSpinProvider,
      (_, __) {},
      fireImmediately: true,
    );
    final purchaseSubscription = container.listen(
      purchaseNotifierProvider,
      (_, __) {},
      fireImmediately: true,
    );
    final unlockSubscription = container.listen(
      chatUnlockProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(dailySubscription.close);
    addTearDown(wheelSubscription.close);
    addTearDown(purchaseSubscription.close);
    addTearDown(unlockSubscription.close);
    await _settle();

    final oldWheelNotifier = container.read(wheelSpinProvider.notifier);
    final oldPurchaseNotifier =
        container.read(purchaseNotifierProvider.notifier);
    final oldUnlockNotifier = container.read(chatUnlockProvider.notifier);

    final dailyResult = container
        .read(dailyRewardProvider(ownerSession).notifier)
        .claim(expectedSession: ownerSession);
    final wheelResult = oldWheelNotifier.spin();
    final purchaseResult = oldPurchaseNotifier.createPurchase('pack-a');
    final unlockResult = oldUnlockNotifier.unlock(
      expectedSession: ownerSession,
    );

    expect(repository.dailyClaimCalls, 1);
    expect(repository.wheelSpinCalls, 1);
    expect(repository.purchaseCalls, 1);
    expect(repository.unlockCalls, 1);

    // Deliberately do not yield between B and A: the session identity must
    // still rotate even when both auth transitions happen in one event turn.
    container.read(authProvider.notifier).setAuthenticatedUser(_accountB);
    container.read(authProvider.notifier).setAuthenticatedUser(_accountA);
    await _settle();

    expect(
      identical(container.read(gamificationSessionProvider), ownerSession),
      isFalse,
    );

    repository.dailyClaim!.complete(DailyClaimResult(
      hibonsEarned: 10,
      newDay: 2,
      newStreak: 2,
      newBalance: 999,
      message: 'Private A reward',
    ));
    repository.wheelSpin!.complete(const WheelSpinResult(
      prize: 50,
      prizeIndex: 1,
      message: 'Private A spin',
      newBalance: 999,
    ));
    repository.purchase!.complete(PurchaseResult(
      clientSecret: 'secret-a',
      paymentIntentId: 'intent-a',
    ));
    repository.unlock!.complete();

    expect(await dailyResult, isNull);
    expect(await wheelResult, isNull);
    expect(await purchaseResult, isNull);
    expect(await unlockResult, isFalse);
    expect(container.read(wheelSpinProvider).valueOrNull, isNull);
    expect(container.read(purchaseNotifierProvider).valueOrNull, isNull);
    expect(container.read(chatUnlockProvider).valueOrNull, isFalse);

    // A retained notifier from the first A session cannot execute an action
    // against the second A session.
    expect(await oldWheelNotifier.spin(), isNull);
    expect(await oldPurchaseNotifier.createPurchase('pack-stale'), isNull);
    expect(await oldUnlockNotifier.unlock(), isFalse);
    expect(repository.wheelSpinCalls, 1);
    expect(repository.purchaseCalls, 1);
    expect(repository.unlockCalls, 1);
  });

  test('late paginated response cannot publish into a replacement session',
      () async {
    final repository = _ControlledGamificationRepository();
    final staleA = Completer<TransactionsListResult>();
    repository.transactionResponses
      ..add(staleA.future)
      ..add(Future.value(_transactions('b')))
      ..add(Future.value(_transactions('a-new')));
    final container = _container(repository);
    addTearDown(container.dispose);

    await _authenticate(container, _accountA);
    final ownerSession = container.read(gamificationSessionProvider)!;
    const filter = (type: null, pillar: null);
    final ownerQuery = (session: ownerSession, filter: filter);
    final subscription = container.listen(
      hibonsTransactionsListProvider(ownerQuery),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await _settle();
    final oldNotifier =
        container.read(hibonsTransactionsListProvider(ownerQuery).notifier);

    container.read(authProvider.notifier).setAuthenticatedUser(_accountB);
    final accountBSession = container.read(gamificationSessionProvider)!;
    final accountBQuery = (session: accountBSession, filter: filter);
    final accountBSubscription = container.listen(
      hibonsTransactionsListProvider(accountBQuery),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(accountBSubscription.close);
    await _settle();
    expect(
      container
          .read(hibonsTransactionsListProvider(accountBQuery))
          .transactions
          .valueOrNull
          ?.single
          .id,
      'b',
    );

    container.read(authProvider.notifier).setAuthenticatedUser(_accountA);
    final accountA2Session = container.read(gamificationSessionProvider)!;
    final accountA2Query = (session: accountA2Session, filter: filter);
    final accountA2Subscription = container.listen(
      hibonsTransactionsListProvider(accountA2Query),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(accountA2Subscription.close);
    await _settle();
    expect(
      container
          .read(hibonsTransactionsListProvider(accountA2Query))
          .transactions
          .valueOrNull
          ?.single
          .id,
      'a-new',
    );

    staleA.complete(_transactions('a-stale'));
    await _settle();

    expect(
      container
          .read(hibonsTransactionsListProvider(accountA2Query))
          .transactions
          .valueOrNull
          ?.single
          .id,
      'a-new',
    );
    await oldNotifier.load();
    expect(repository.transactionCalls, 3);
  });

  test('stale mutation failures are not surfaced to the next account',
      () async {
    final repository = _ControlledGamificationRepository()
      ..dailyClaim = Completer<DailyClaimResult>()
      ..wheelSpin = Completer<WheelSpinResult>();
    final container = _container(repository);
    addTearDown(container.dispose);

    await _authenticate(container, _accountA);
    final ownerSession = container.read(gamificationSessionProvider)!;
    final dailySubscription = container.listen(
      dailyRewardProvider(ownerSession),
      (_, __) {},
      fireImmediately: true,
    );
    final wheelSubscription = container.listen(
      wheelSpinProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(dailySubscription.close);
    addTearDown(wheelSubscription.close);
    await _settle();

    final staleClaim = container
        .read(dailyRewardProvider(ownerSession).notifier)
        .claim(expectedSession: ownerSession);
    final staleSpin = container.read(wheelSpinProvider.notifier).spin();

    container.read(authProvider.notifier).setAuthenticatedUser(_accountB);
    await _settle();
    repository.dailyClaim!.completeError(StateError('private A claim error'));
    repository.wheelSpin!.completeError(StateError('private A spin error'));

    expect(await staleClaim, isNull);
    expect(await staleSpin, isNull);
    expect(container.read(wheelSpinProvider).hasError, isFalse);
  });

  test('rapid A -> B -> A also invalidates an in-flight wallet build',
      () async {
    final repository = _ControlledGamificationRepository();
    final staleA = Completer<HibonsWallet>();
    repository.walletResponses
      ..add(staleA.future)
      ..add(Future.value(const HibonsWallet(balance: 30)));
    final container = _container(repository);
    addTearDown(container.dispose);

    await _authenticate(container, _accountA);
    final ownerSession = container.read(gamificationSessionProvider)!;
    final subscription = container.listen(
      gamificationNotifierProvider(ownerSession),
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await _settle();

    container.read(authProvider.notifier).setAuthenticatedUser(_accountB);
    container.read(authProvider.notifier).setAuthenticatedUser(_accountA);
    final accountA2Session = container.read(gamificationSessionProvider)!;
    await _settle();
    await container.read(gamificationNotifierProvider(accountA2Session).future);

    staleA.complete(const HibonsWallet(balance: 999));
    await _settle();

    expect(repository.walletCalls, 2);
    expect(
      container
          .read(gamificationNotifierProvider(accountA2Session))
          .valueOrNull
          ?.balance,
      30,
    );
  });

  test('disposed async notifier does not read or publish after completion',
      () async {
    final repository = _ControlledGamificationRepository()
      ..dailyClaim = Completer<DailyClaimResult>();
    final container = _container(repository);

    await _authenticate(container, _accountA);
    final ownerSession = container.read(gamificationSessionProvider)!;
    container.listen(
      dailyRewardProvider(ownerSession),
      (_, __) {},
      fireImmediately: true,
    );
    await _settle();
    final claim = container
        .read(dailyRewardProvider(ownerSession).notifier)
        .claim(expectedSession: ownerSession);

    container.dispose();
    repository.dailyClaim!.complete(DailyClaimResult(
      hibonsEarned: 10,
      newDay: 2,
      newStreak: 2,
      newBalance: 999,
      message: 'Disposed result',
    ));

    expect(await claim, isNull);
  });
}

ProviderContainer _container(GamificationRepository repository) {
  return ProviderContainer(
    overrides: [
      analyticsServiceProvider.overrideWithValue(const NoopAnalyticsService()),
      authRepositoryProvider.overrideWithValue(_AnonymousAuthRepository()),
      gamificationRepositoryProvider.overrideWithValue(repository),
    ],
  );
}

Future<void> _authenticate(ProviderContainer container, HbUser user) async {
  container.read(authProvider);
  await _settle();
  container.read(authProvider.notifier).setAuthenticatedUser(user);
  await _settle();
}

Future<void> _loadAllPrivateSurfaces(
  ProviderContainer container,
  GamificationSessionKey session,
) async {
  await container.read(gamificationNotifierProvider(session).future);
  await container.read(dailyRewardProvider(session).future);
  await container.read(wheelConfigProvider(session).future);
  await container.read(
    hibonTransactionsProvider((session: session, pillar: null)).future,
  );
  await container.read(hibonsBalanceProvider(session).future);
  await container.read(actionsCatalogProvider(session).future);
  await container.read(achievementsProvider(session).future);
  await container.read(hibonBadgesProvider(session).future);
  await container.read(challengesProvider(session).future);
  await container.read(hibonPackagesProvider(session).future);
}

void _expectAllPrivateSurfacesHaveData(
  ProviderContainer container,
  GamificationSessionKey session,
) {
  expect(container.read(gamificationNotifierProvider(session)).hasValue, true);
  expect(container.read(dailyRewardProvider(session)).hasValue, true);
  expect(container.read(wheelConfigProvider(session)).hasValue, true);
  expect(
    container
        .read(hibonTransactionsProvider((session: session, pillar: null)))
        .hasValue,
    true,
  );
  expect(container.read(hibonsBalanceProvider(session)).hasValue, true);
  expect(container.read(actionsCatalogProvider(session)).hasValue, true);
  expect(container.read(achievementsProvider(session)).hasValue, true);
  expect(container.read(hibonBadgesProvider(session)).hasValue, true);
  expect(container.read(challengesProvider(session)).hasValue, true);
  expect(container.read(hibonPackagesProvider(session)).hasValue, true);
}

void _expectAllPrivateSurfacesBlank(
  ProviderContainer container,
  GamificationSessionKey session,
) {
  expect(
    container.read(gamificationNotifierProvider(session)).valueOrNull,
    isNull,
  );
  expect(container.read(dailyRewardProvider(session)).valueOrNull, isNull);
  expect(container.read(wheelConfigProvider(session)).valueOrNull, isNull);
  expect(
    container
        .read(hibonTransactionsProvider((session: session, pillar: null)))
        .valueOrNull,
    isNull,
  );
  expect(container.read(hibonsBalanceProvider(session)).valueOrNull, isNull);
  expect(container.read(actionsCatalogProvider(session)).valueOrNull, isNull);
  expect(container.read(achievementsProvider(session)).valueOrNull, isNull);
  expect(container.read(hibonBadgesProvider(session)).valueOrNull, isNull);
  expect(container.read(challengesProvider(session)).valueOrNull, isNull);
  expect(container.read(hibonPackagesProvider(session)).valueOrNull, isNull);
}

TransactionsListResult _transactions(String id) {
  return TransactionsListResult(
    items: [
      HibonTransaction(
        id: id,
        type: TransactionType.earn,
        amount: 10,
        timestamp: DateTime(2026),
      ),
    ],
    currentBalance: 10,
    lifetimeEarned: 10,
    earningsByPillar: const [],
    currentPage: 1,
    lastPage: 1,
  );
}

Future<void> _settle() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/core/providers/shared_preferences_provider.dart';
import 'package:lehiboo/domain/entities/user.dart';
import 'package:lehiboo/features/alerts/data/repositories/alerts_repository_impl.dart';
import 'package:lehiboo/features/alerts/domain/entities/alert.dart';
import 'package:lehiboo/features/alerts/domain/repositories/alerts_repository.dart';
import 'package:lehiboo/features/alerts/presentation/providers/alerts_provider.dart';
import 'package:lehiboo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lehiboo/features/auth/domain/repositories/auth_repository.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/gamification/data/models/daily_reward.dart';
import 'package:lehiboo/features/gamification/data/models/hibon_badge.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_balance.dart';
import 'package:lehiboo/features/gamification/data/models/hibons_wallet.dart';
import 'package:lehiboo/features/gamification/data/models/transactions_list_result.dart';
import 'package:lehiboo/features/gamification/data/models/wheel_models.dart';
import 'package:lehiboo/features/gamification/domain/repositories/gamification_repository.dart';
import 'package:lehiboo/features/gamification/presentation/providers/gamification_provider.dart';
import 'package:lehiboo/features/memberships/data/models/personalized_feed_dto.dart';
import 'package:lehiboo/features/memberships/domain/repositories/memberships_repository.dart';
import 'package:lehiboo/features/memberships/presentation/providers/personalized_feed_provider.dart';
import 'package:lehiboo/features/search/domain/models/event_filter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeAuthRepository implements AuthRepository {
  int clearLocalCalls = 0;
  int logoutCalls = 0;

  @override
  Future<bool> isAuthenticated() async => false;

  @override
  Future<HbUser?> getCurrentUser() async => null;

  @override
  Future<void> clearLocalAuthData() async {
    clearLocalCalls++;
  }

  @override
  Future<void> logout() async {
    logoutCalls++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAlertsRepository implements AlertsRepository {
  int getCalls = 0;
  List<Alert> nextAlerts = const [];
  Completer<List<Alert>>? nextResponse;

  @override
  Future<List<Alert>> getAlerts() {
    getCalls++;
    final pendingResponse = nextResponse;
    if (pendingResponse != null) {
      nextResponse = null;
      return pendingResponse.future;
    }
    return Future.value(nextAlerts);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeGamificationRepository implements GamificationRepository {
  int walletCalls = 0;
  int balanceCalls = 0;
  int dailyCalls = 0;
  int transactionCalls = 0;
  int badgeCalls = 0;
  int accountValue = 0;
  Object? walletError;
  Completer<HibonsWallet>? nextWalletResponse;

  @override
  Future<HibonsWallet> getWallet() async {
    walletCalls++;
    final pendingResponse = nextWalletResponse;
    if (pendingResponse != null) {
      nextWalletResponse = null;
      return pendingResponse.future;
    }
    final error = walletError;
    if (error != null) throw error;
    return HibonsWallet(balance: accountValue);
  }

  @override
  Future<HibonsBalance> getBalance() async {
    balanceCalls++;
    return HibonsBalance(
      balance: accountValue,
      lifetimeEarned: accountValue,
      rank: 'curieux',
      rankLabel: 'Curieux',
      rankIcon: '🔍',
    );
  }

  @override
  Future<DailyRewardState> getDailyRewardState() async {
    dailyCalls++;
    return DailyRewardState(
      currentDay: accountValue,
      isClaimedToday: false,
      lastClaimDate: DateTime(2026),
      days: const [],
    );
  }

  @override
  Future<TransactionsListResult> getTransactions({
    String? type,
    String? pillar,
  }) async {
    transactionCalls++;
    return TransactionsListResult(
      items: const [],
      currentBalance: accountValue,
      lifetimeEarned: accountValue,
      earningsByPillar: const [],
    );
  }

  @override
  Future<HibonBadgesResult> getBadges() async {
    badgeCalls++;
    return HibonBadgesResult(
      items: const [],
      meta: HibonBadgesMeta(
        lifetimeEarned: accountValue,
        currentRank: 'curieux',
        currentRankLabel: 'Curieux',
        total: 0,
        unlocked: 0,
        locked: 0,
      ),
    );
  }

  @override
  Future<WheelSpinResult> spinWheel() async {
    return WheelSpinResult(
      prize: accountValue,
      prizeIndex: 0,
      message: 'ok',
      newBalance: accountValue,
    );
  }

  @override
  Future<PurchaseResult> createPurchase(String packageId) async {
    return PurchaseResult(
      clientSecret: 'secret-$accountValue',
      paymentIntentId: 'intent-$accountValue',
    );
  }

  @override
  Future<void> unlockChatMessages() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeMembershipsRepository implements MembershipsRepository {
  int personalizedFeedCalls = 0;

  @override
  Future<PersonalizedFeedDto> getPersonalizedFeed({int limit = 8}) async {
    personalizedFeedCalls++;
    return PersonalizedFeedDto.empty();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _userOne = HbUser(
  id: 'user-1',
  email: 'one@example.test',
  displayName: 'One',
);

const _userTwo = HbUser(
  id: 'user-2',
  email: 'two@example.test',
  displayName: 'Two',
);

Alert _alert(String id) {
  return Alert(
    id: id,
    name: 'Alert $id',
    filter: const EventFilter(),
    createdAt: DateTime(2026),
  );
}

Future<void> _flush() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

Future<void> _awaitGamificationReads(ProviderContainer container) async {
  await Future.wait<Object?>([
    container.read(gamificationNotifierProvider.future),
    container.read(hibonsBalanceProvider.future),
    container.read(dailyRewardProvider.future),
    container.read(hibonTransactionsProvider(null).future),
    container.read(hibonBadgesProvider.future),
    container.read(personalizedFeedProvider.future),
  ]);
  await _flush();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('alerts bootstrap and manual refresh share one request', () async {
    final authRepository = _FakeAuthRepository();
    final alertsRepository = _FakeAlertsRepository();
    final pendingAlerts = Completer<List<Alert>>();
    alertsRepository.nextResponse = pendingAlerts;
    final container = ProviderContainer(
      overrides: [
        authRepositoryImplProvider.overrideWithValue(authRepository),
        alertsRepositoryImplProvider.overrideWithValue(alertsRepository),
      ],
    );
    addTearDown(container.dispose);

    container.read(authProvider);
    await _flush();
    container.read(authProvider.notifier).setAuthenticatedUser(_userOne);
    final subscription = container.listen(
      alertsProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await _flush();

    expect(alertsRepository.getCalls, 1);
    final manualRefresh = container.read(alertsProvider.notifier).loadAlerts();
    expect(alertsRepository.getCalls, 1);

    pendingAlerts.complete([_alert('coalesced')]);
    await manualRefresh;

    expect(alertsRepository.getCalls, 1);
    expect(
      container.read(alertsProvider).valueOrNull?.single.id,
      'coalesced',
    );
  });

  test('wallet refresh cannot be overwritten by a late cold load', () async {
    final authRepository = _FakeAuthRepository();
    final gamificationRepository = _FakeGamificationRepository()
      ..accountValue = 20;
    final coldLoad = Completer<HibonsWallet>();
    gamificationRepository.nextWalletResponse = coldLoad;
    final container = ProviderContainer(
      overrides: [
        authRepositoryImplProvider.overrideWithValue(authRepository),
        gamificationRepositoryProvider.overrideWithValue(
          gamificationRepository,
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(authProvider);
    await _flush();
    container.read(authProvider.notifier).setAuthenticatedUser(_userOne);
    final subscription = container.listen(
      gamificationNotifierProvider,
      (_, __) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await _flush();

    expect(gamificationRepository.walletCalls, 1);
    await container.read(gamificationNotifierProvider.notifier).refresh();
    expect(gamificationRepository.walletCalls, 2);
    expect(
      container.read(gamificationNotifierProvider).valueOrNull?.balance,
      20,
    );

    coldLoad.complete(const HibonsWallet(balance: 999));
    await _flush();
    expect(
      container.read(gamificationNotifierProvider).valueOrNull?.balance,
      20,
    );
  });

  test(
    'account-scoped Home and gamification state resets and refetches per user',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final authRepository = _FakeAuthRepository();
      final alertsRepository = _FakeAlertsRepository();
      final gamificationRepository = _FakeGamificationRepository();
      final membershipsRepository = _FakeMembershipsRepository();
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(preferences),
          authRepositoryImplProvider.overrideWithValue(authRepository),
          alertsRepositoryImplProvider.overrideWithValue(alertsRepository),
          gamificationRepositoryProvider.overrideWithValue(
            gamificationRepository,
          ),
          membershipsRepositoryProvider.overrideWithValue(
            membershipsRepository,
          ),
        ],
      );
      addTearDown(container.dispose);

      final subscriptions = [
        container.listen(alertsProvider, (_, __) {}, fireImmediately: true),
        container.listen(
          gamificationNotifierProvider,
          (_, __) {},
          fireImmediately: true,
        ),
        container.listen(
          hibonsBalanceProvider,
          (_, __) {},
          fireImmediately: true,
        ),
        container.listen(
          dailyRewardProvider,
          (_, __) {},
          fireImmediately: true,
        ),
        container.listen(
          hibonTransactionsProvider(null),
          (_, __) {},
          fireImmediately: true,
        ),
        container.listen(
          hibonBadgesProvider,
          (_, __) {},
          fireImmediately: true,
        ),
        container.listen(wheelSpinProvider, (_, __) {}, fireImmediately: true),
        container.listen(
          purchaseNotifierProvider,
          (_, __) {},
          fireImmediately: true,
        ),
        container.listen(chatUnlockProvider, (_, __) {}, fireImmediately: true),
        container.listen(
          personalizedFeedProvider,
          (_, __) {},
          fireImmediately: true,
        ),
      ];
      addTearDown(() {
        for (final subscription in subscriptions) {
          subscription.close();
        }
      });

      await _flush();
      await _awaitGamificationReads(container);
      expect(alertsRepository.getCalls, 0);
      expect(gamificationRepository.walletCalls, 0);
      expect(gamificationRepository.balanceCalls, 0);
      expect(membershipsRepository.personalizedFeedCalls, 0);

      alertsRepository.nextAlerts = [_alert('one')];
      gamificationRepository.accountValue = 11;
      container.read(authProvider.notifier).setAuthenticatedUser(_userOne);
      await _awaitGamificationReads(container);

      expect(container.read(alertsProvider).valueOrNull?.single.id, 'one');
      expect(
        container.read(gamificationNotifierProvider).valueOrNull?.balance,
        11,
      );
      expect(container.read(hibonsBalanceProvider).valueOrNull?.balance, 11);
      expect(container.read(dailyRewardProvider).valueOrNull?.currentDay, 11);
      expect(
        container
            .read(hibonTransactionsProvider(null))
            .valueOrNull
            ?.currentBalance,
        11,
      );
      expect(
        container.read(hibonBadgesProvider).valueOrNull?.meta.lifetimeEarned,
        11,
      );

      await container.read(wheelSpinProvider.notifier).spin();
      await container
          .read(purchaseNotifierProvider.notifier)
          .createPurchase('package');
      await container.read(chatUnlockProvider.notifier).unlock();
      expect(container.read(wheelSpinProvider).valueOrNull?.prize, 11);
      expect(
        container.read(purchaseNotifierProvider).valueOrNull?.paymentIntentId,
        'intent-11',
      );
      expect(container.read(chatUnlockProvider).valueOrNull, isTrue);

      final callsBeforeLogout = (
        alerts: alertsRepository.getCalls,
        wallet: gamificationRepository.walletCalls,
        balance: gamificationRepository.balanceCalls,
        daily: gamificationRepository.dailyCalls,
        transactions: gamificationRepository.transactionCalls,
        badges: gamificationRepository.badgeCalls,
        personalized: membershipsRepository.personalizedFeedCalls,
      );

      await container.read(authProvider.notifier).forceLogout();
      await _awaitGamificationReads(container);

      final forcedState = container.read(authProvider);
      expect(forcedState.status, AuthStatus.unauthenticated);
      expect(forcedState.errorMessage, authSessionExpiredMessage);
      expect(authRepository.clearLocalCalls, 1);
      expect(container.read(alertsProvider).valueOrNull, isEmpty);
      expect(
        container.read(gamificationNotifierProvider).valueOrNull?.balance,
        0,
      );
      expect(container.read(hibonsBalanceProvider).valueOrNull?.balance, 0);
      expect(container.read(wheelSpinProvider).valueOrNull, isNull);
      expect(container.read(purchaseNotifierProvider).valueOrNull, isNull);
      expect(container.read(chatUnlockProvider).valueOrNull, isFalse);
      expect(alertsRepository.getCalls, callsBeforeLogout.alerts);
      expect(gamificationRepository.walletCalls, callsBeforeLogout.wallet);
      expect(gamificationRepository.balanceCalls, callsBeforeLogout.balance);
      expect(gamificationRepository.dailyCalls, callsBeforeLogout.daily);
      expect(
        gamificationRepository.transactionCalls,
        callsBeforeLogout.transactions,
      );
      expect(gamificationRepository.badgeCalls, callsBeforeLogout.badges);
      expect(
        membershipsRepository.personalizedFeedCalls,
        callsBeforeLogout.personalized,
      );

      alertsRepository.nextAlerts = [_alert('two')];
      gamificationRepository.accountValue = 22;
      container.read(authProvider.notifier).setAuthenticatedUser(_userTwo);
      await _awaitGamificationReads(container);

      expect(container.read(authProvider).errorMessage, isNull);
      expect(container.read(alertsProvider).valueOrNull?.single.id, 'two');
      expect(
        container.read(gamificationNotifierProvider).valueOrNull?.balance,
        22,
      );
      expect(container.read(hibonsBalanceProvider).valueOrNull?.balance, 22);
      expect(
        gamificationRepository.walletCalls,
        greaterThan(callsBeforeLogout.wallet),
      );
      expect(
        gamificationRepository.balanceCalls,
        greaterThan(callsBeforeLogout.balance),
      );
      expect(
        membershipsRepository.personalizedFeedCalls,
        greaterThan(callsBeforeLogout.personalized),
      );

      gamificationRepository.walletError = StateError('wallet unavailable');
      await expectLater(
        container.read(gamificationNotifierProvider.notifier).refresh(),
        throwsA(isA<StateError>()),
      );
      final failedRefresh = container.read(gamificationNotifierProvider);
      expect(failedRefresh.hasError, isTrue);
      expect(failedRefresh.valueOrNull?.balance, 22);
      gamificationRepository.walletError = null;

      final staleSuccess = Completer<HibonsWallet>();
      gamificationRepository.nextWalletResponse = staleSuccess;
      final staleSuccessRefresh =
          container.read(gamificationNotifierProvider.notifier).refresh();
      gamificationRepository.accountValue = 33;
      container.read(authProvider.notifier).setAuthenticatedUser(_userOne);
      await container.read(gamificationNotifierProvider.future);
      staleSuccess.complete(const HibonsWallet(balance: 999));
      await staleSuccessRefresh;
      expect(
        container.read(gamificationNotifierProvider).valueOrNull?.balance,
        33,
      );

      final staleError = Completer<HibonsWallet>();
      gamificationRepository.nextWalletResponse = staleError;
      final staleErrorRefresh =
          container.read(gamificationNotifierProvider.notifier).refresh();
      gamificationRepository.accountValue = 44;
      container.read(authProvider.notifier).setAuthenticatedUser(_userTwo);
      await container.read(gamificationNotifierProvider.future);
      staleError.completeError(StateError('stale user failure'));
      await expectLater(staleErrorRefresh, throwsA(isA<StateError>()));
      final stateAfterStaleError = container.read(gamificationNotifierProvider);
      expect(stateAfterStaleError.hasError, isFalse);
      expect(stateAfterStaleError.valueOrNull?.balance, 44);

      await container.read(authProvider.notifier).logout();
      await _flush();

      final manualLogoutState = container.read(authProvider);
      expect(manualLogoutState.status, AuthStatus.unauthenticated);
      expect(manualLogoutState.errorMessage, isNull);
      expect(authRepository.logoutCalls, 1);
      expect(container.read(alertsProvider).valueOrNull, isEmpty);
    },
  );
}

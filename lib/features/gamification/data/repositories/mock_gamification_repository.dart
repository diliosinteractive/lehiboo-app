import 'dart:math';

import 'package:lehiboo/features/gamification/data/models/hibons_wallet.dart';
import 'package:lehiboo/features/gamification/data/models/hibon_transaction.dart';
import 'package:lehiboo/features/gamification/data/models/daily_reward.dart';
import 'package:lehiboo/features/gamification/data/models/gamification_items.dart';
import 'package:lehiboo/features/gamification/data/models/wheel_models.dart';
import 'package:lehiboo/features/gamification/domain/repositories/gamification_repository.dart';

class MockGamificationRepository implements GamificationRepository {
  // --- Simulating Database State ---
  HibonsWallet _wallet = HibonsWallet(
    balance: 1530,
    xp: 350,
    level: 3,
    rank: 'explorateur',
    rankLabel: 'Petit Boo Aventurier',
    rankIcon: '🦉',
    currentStreak: 4,
    maxStreak: 7,
    progressToNextLevel: 50,
    canClaimDaily: true,
    canSpinWheel: true,
    chatQuota: ChatQuota(
      remaining: 3,
      limit: 5,
      used: 2,
      resetsAt: DateTime.now().add(const Duration(days: 1)),
      canUnlock: true,
      unlockCost: 30,
      unlockMessages: 10,
    ),
    dailyRewards: [
      const DailyRewardItem(day: 1, hibons: 10, claimed: true, current: false),
      const DailyRewardItem(day: 2, hibons: 15, claimed: true, current: false),
      const DailyRewardItem(day: 3, hibons: 20, claimed: true, current: false),
      const DailyRewardItem(day: 4, hibons: 25, claimed: true, current: false),
      const DailyRewardItem(day: 5, hibons: 30, claimed: false, current: true),
      const DailyRewardItem(day: 6, hibons: 40, claimed: false, current: false),
      const DailyRewardItem(day: 7, hibons: 50, claimed: false, current: false),
    ],
  );

  final List<HibonTransaction> _transactions = [
    HibonTransaction(
      id: 't1',
      type: TransactionType.earn,
      amount: 50,
      description: 'Bienvenue sur Lehiboo !',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
    HibonTransaction(
      id: 't2',
      type: TransactionType.earn,
      amount: 10,
      description: 'Série quotidienne - Jour 1',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
    ),
    HibonTransaction(
      id: 't3',
      type: TransactionType.earn,
      amount: 15,
      description: 'Série quotidienne - Jour 2',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
    HibonTransaction(
      id: 't4',
      type: TransactionType.spend,
      amount: 100,
      description: 'Achat Ticket de Tombola',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // Wheel Config
  final WheelConfig _wheelConfig = WheelConfig(
    costPerSpin: 0,
    isFreeSpinAvailable: true,
    nextFreeSpinDate: DateTime.now().add(const Duration(days: 1)),
    prizes: [
      const WheelPrize(index: 0, amount: 5, label: '5 Hibons', colorInt: 0xFFE0E0E0),
      const WheelPrize(index: 1, amount: 10, label: '10 Hibons', colorInt: 0xFFB3E5FC),
      const WheelPrize(index: 2, amount: 25, label: '25 Hibons', colorInt: 0xFF81C784),
      const WheelPrize(index: 3, amount: 50, label: '50 Hibons', colorInt: 0xFFFFF176),
      const WheelPrize(index: 4, amount: 100, label: '100 Hibons', colorInt: 0xFFFFCC80),
      const WheelPrize(index: 5, amount: 0, label: 'Pas de chance', colorInt: 0xFFFFAB91),
      const WheelPrize(index: 6, amount: 200, label: '200 Hibons', colorInt: 0xFFCE93D8),
      const WheelPrize(index: 7, amount: 500, label: 'JACKPOT!', colorInt: 0xFFFFD700),
    ],
  );

  @override
  Future<HibonsWallet> getWallet() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _wallet;
  }

  @override
  Future<List<HibonTransaction>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _transactions;
  }

  @override
  Future<DailyRewardState> getDailyRewardState() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final currentDayItem = _wallet.dailyRewards.firstWhere(
      (d) => d.current,
      orElse: () => _wallet.dailyRewards.first,
    );

    return DailyRewardState(
      currentDay: currentDayItem.day,
      isClaimedToday: currentDayItem.claimed,
      lastClaimDate: DateTime.now().subtract(const Duration(days: 1)),
      days: _wallet.dailyRewards
          .map((d) => DailyRewardDay(
                dayNumber: d.day,
                hibonsReward: d.hibons,
                xpReward: 0,
                isJackpot: d.day == 7,
              ))
          .toList(),
    );
  }

  @override
  Future<DailyClaimResult> claimDailyReward() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final currentDayItem = _wallet.dailyRewards.firstWhere(
      (d) => d.current,
      orElse: () => _wallet.dailyRewards.first,
    );

    final reward = currentDayItem.hibons;
    final newBalance = _wallet.balance + reward;

    _wallet = _wallet.copyWith(
      balance: newBalance,
      currentStreak: _wallet.currentStreak + 1,
      canClaimDaily: false,
    );

    _transactions.insert(
      0,
      HibonTransaction(
        id: Random().nextInt(100000).toString(),
        type: TransactionType.earn,
        amount: reward,
        description: 'Daily Reward - Jour ${currentDayItem.day}',
        timestamp: DateTime.now(),
      ),
    );

    return DailyClaimResult(
      hibonsEarned: reward,
      newDay: currentDayItem.day,
      newStreak: _wallet.currentStreak,
      newBalance: newBalance,
      message: 'Bravo ! Tu as gagné $reward Hibons !',
    );
  }

  @override
  Future<HibonsWallet> buyStreakShield() async {
    throw UnimplementedError('Streak shield is not available');
  }

  @override
  Future<List<Achievement>> getAchievements() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const Achievement(
        id: 'a1',
        title: 'Première Éclosion',
        description: 'Effectuer 1 recherche',
        iconUrl: 'assets/badges/search.png',
        category: 'Explorer',
        isUnlocked: true,
        progressCurrent: 1,
        progressTarget: 1,
      ),
      const Achievement(
        id: 'a2',
        title: 'Explorateur de l\'Extrême',
        description: 'Voir 10 événements',
        iconUrl: 'assets/badges/compass.png',
        category: 'Explorer',
        isUnlocked: false,
        progressCurrent: 4,
        progressTarget: 10,
      ),
    ];
  }

  @override
  Future<List<Challenge>> getChallenges() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const Challenge(
        id: 'c1',
        title: 'Explorateur du Dimanche',
        description: 'Consulter 3 événements aujourd\'hui',
        type: 'daily',
        rewardHibons: 30,
        rewardXp: 15,
        progressCurrent: 1,
        progressTarget: 3,
      ),
    ];
  }

  @override
  Future<WheelConfig> getWheelConfig() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _wheelConfig;
  }

  @override
  Future<WheelSpinResult> spinWheel() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    final rand = Random();
    final prizeIndex = rand.nextInt(_wheelConfig.prizes.length);
    final prize = _wheelConfig.prizes[prizeIndex];

    final earnedAmount = prize.amount;

    _wallet = _wallet.copyWith(
      balance: _wallet.balance + earnedAmount,
      canSpinWheel: false,
    );

    if (earnedAmount > 0) {
      _transactions.insert(
        0,
        HibonTransaction(
          id: Random().nextInt(100000).toString(),
          type: TransactionType.earn,
          amount: earnedAmount,
          description: 'Roue de la Fortune',
          timestamp: DateTime.now(),
        ),
      );
    }

    return WheelSpinResult(
      prize: earnedAmount,
      prizeIndex: prizeIndex,
      message: earnedAmount > 0
          ? 'Bravo ! Tu as gagné $earnedAmount Hibons !'
          : 'Pas de chance cette fois !',
      newBalance: _wallet.balance,
    );
  }

  @override
  Future<List<HibonPackage>> getPackages() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      HibonPackage(
        id: 'pack_100',
        name: 'Petit Nid',
        hibons: 100,
        priceInCents: 199,
      ),
      HibonPackage(
        id: 'pack_500',
        name: 'Nid Douillet',
        hibons: 500,
        priceInCents: 499,
        bonusPercent: 10,
        isPopular: true,
      ),
      HibonPackage(
        id: 'pack_1000',
        name: 'Grand Nid',
        hibons: 1000,
        priceInCents: 899,
        bonusPercent: 20,
      ),
    ];
  }

  @override
  Future<PurchaseResult> createPurchase(String packageId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return PurchaseResult(
      clientSecret: 'mock_client_secret_${DateTime.now().millisecondsSinceEpoch}',
      paymentIntentId: 'mock_pi_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<void> confirmPurchase(String paymentIntentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock: ajouter 500 hibons
    _wallet = _wallet.copyWith(balance: _wallet.balance + 500);
  }

  @override
  Future<void> unlockChatMessages() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock: débloquer les messages
    final currentQuota = _wallet.chatQuota;
    if (currentQuota != null) {
      _wallet = _wallet.copyWith(
        balance: _wallet.balance - currentQuota.unlockCost,
        chatQuota: ChatQuota(
          remaining: currentQuota.remaining + currentQuota.unlockMessages,
          limit: currentQuota.limit + currentQuota.unlockMessages,
          used: currentQuota.used,
          resetsAt: currentQuota.resetsAt,
          canUnlock: true,
          unlockCost: currentQuota.unlockCost,
          unlockMessages: currentQuota.unlockMessages,
        ),
      );
    }
  }

  @override
  Future<HibonsWallet> buyShopItem(String itemId, int cost) async {
    throw UnimplementedError('Use createPurchase() instead');
  }

  @override
  Future<HibonsWallet> earnHibons(int amount, String description) async {
    throw UnimplementedError('Hibons are earned through daily rewards, wheel spins, etc.');
  }
}

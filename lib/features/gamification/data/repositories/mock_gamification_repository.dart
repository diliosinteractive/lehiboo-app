
import 'dart:math';

import 'package:lehiboo/features/gamification/data/models/hibons_wallet.dart';
import 'package:lehiboo/features/gamification/data/models/hibon_transaction.dart';
import 'package:lehiboo/features/gamification/data/models/daily_reward.dart';
import 'package:lehiboo/features/gamification/data/models/gamification_items.dart'; // Achievements & Challenges
import 'package:lehiboo/features/gamification/data/models/wheel_models.dart';
import 'package:lehiboo/features/gamification/domain/repositories/gamification_repository.dart';

class MockGamificationRepository implements GamificationRepository {
  // --- Simulating Database State ---
  HibonsWallet _wallet = HibonsWallet(
    userId: 'mock_user_123',
    balance: 1530,
    xp: 350,
    level: 3,
    rank: 'Petit Boo Aventurier',
    currentStreak: 4,
    lastActionDate: DateTime.now().subtract(const Duration(hours: 4)),
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

  // Daily Rewards Config
  final List<DailyRewardDay> _dailyRewardConfig = [
    const DailyRewardDay(dayNumber: 1, hibonsReward: 10, xpReward: 5, isJackpot: false),
    const DailyRewardDay(dayNumber: 2, hibonsReward: 15, xpReward: 5, isJackpot: false),
    const DailyRewardDay(dayNumber: 3, hibonsReward: 25, xpReward: 10, isJackpot: false),
    const DailyRewardDay(dayNumber: 4, hibonsReward: 35, xpReward: 10, bonusDescription: "x1.2 XP (1h)", isJackpot: false),
    const DailyRewardDay(dayNumber: 5, hibonsReward: 50, xpReward: 15, isJackpot: false),
    const DailyRewardDay(dayNumber: 6, hibonsReward: 75, xpReward: 20, bonusDescription: "Tour Gratuit", isJackpot: false),
    const DailyRewardDay(dayNumber: 7, hibonsReward: 100, xpReward: 30, bonusDescription: "Coffre Mystère", isJackpot: true),
  ];
  
  // Wheel Config
  final WheelConfig _wheelConfig = WheelConfig(
    costPerSpin: 100,
    isFreeSpinAvailable: true, // Mock available for testing
    nextFreeSpinDate: DateTime.now().add(const Duration(days: 1)),
    segments: [
      const WheelSegment(id: 'w1', label: '10 H', type: 'hibons', value: 10, probability: 0.25, colorInt: 0xFFE0E0E0),
      const WheelSegment(id: 'w2', label: '25 H', type: 'hibons', value: 25, probability: 0.20, colorInt: 0xFFB3E5FC),
      const WheelSegment(id: 'w3', label: '50 H', type: 'hibons', value: 50, probability: 0.15, colorInt: 0xFF81C784),
      const WheelSegment(id: 'w4', label: '100 H', type: 'hibons', value: 100, probability: 0.08, colorInt: 0xFFFFF176),
      const WheelSegment(id: 'w5', label: 'x1.5', type: 'multiplier', value: 15, probability: 0.12, colorInt: 0xFFFFCC80),
      const WheelSegment(id: 'w6', label: 'x2.0', type: 'multiplier', value: 20, probability: 0.08, colorInt: 0xFFFFAB91),
      const WheelSegment(id: 'w7', label: 'Badge', type: 'badge', value: 1, probability: 0.05, colorInt: 0xFFCE93D8),
      const WheelSegment(id: 'w8', label: 'JACKPOT', type: 'jackpot', value: 500, probability: 0.02, colorInt: 0xFFFFD700), // Gold
    ]
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
    // Mock Logic: 
    // Current streak is 4, so next reward is day 5.
    // If last action was > 1 day ago, reset? 
    // For simplicity, let's say user is on Day 5 and hasn't claimed yet.
    return DailyRewardState(
      currentDay: (_wallet.currentStreak % 7) + 1, 
      isClaimedToday: false,
      lastClaimDate: DateTime.now().subtract(const Duration(days: 1)),
      days: _dailyRewardConfig,
    );
  }

  @override
  Future<DailyRewardState> claimDailyReward() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Update Wallet
    final currentDayIndex = (_wallet.currentStreak % 7);
    final reward = _dailyRewardConfig[currentDayIndex];
    
    _wallet = _wallet.copyWith(
      balance: _wallet.balance + reward.hibonsReward,
      xp: _wallet.xp + reward.xpReward,
      currentStreak: _wallet.currentStreak + 1,
      lastActionDate: DateTime.now(),
    );

    // Add Transaction
    _transactions.insert(0, HibonTransaction(
      id: Random().nextInt(100000).toString(),
      type: TransactionType.earn,
      amount: reward.hibonsReward,
      description: 'Daily Reward - Jour ${reward.dayNumber}',
      timestamp: DateTime.now(),
    ));

    return DailyRewardState(
      currentDay: (_wallet.currentStreak % 7) + 1,
      isClaimedToday: true,
      lastClaimDate: DateTime.now(),
      days: _dailyRewardConfig,
    );
  }

  @override
  Future<HibonsWallet> buyStreakShield() async {
    await Future.delayed(const Duration(milliseconds: 400));
    const cost = 150;
    if (_wallet.balance < cost) throw Exception('Solde insuffisant');
    
    _wallet = _wallet.copyWith(
      balance: _wallet.balance - cost,
      streakShieldActive: true,
    );
    
    _transactions.insert(0, HibonTransaction(
      id: Random().nextInt(100000).toString(),
      type: TransactionType.spend,
      amount: cost,
      description: 'Achat Streak Shield',
      timestamp: DateTime.now(),
    ));
    
    return _wallet;
  }

  @override
  Future<List<Achievement>> getAchievements() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const Achievement(id: 'a1', title: 'Première Éclosion', description: 'Effectuer 1 recherche', iconUrl: 'assets/badges/search.png', category: 'Explorer', isUnlocked: true, progressCurrent: 1, progressTarget: 1, unlockedAt: null),
      const Achievement(id: 'a2', title: 'Explorateur de l\'Extrême', description: 'Voir 10 événements', iconUrl: 'assets/badges/compass.png', category: 'Explorer', isUnlocked: false, progressCurrent: 4, progressTarget: 10),
      const Achievement(id: 'a3', title: 'Star de la Bande', description: 'Partager 5 événements', iconUrl: 'assets/badges/share.png', category: 'Social', isUnlocked: false, progressCurrent: 1, progressTarget: 5),
      const Achievement(id: 'a4', title: 'Globe-Trotter', description: 'Visiter 5 villes différentes', iconUrl: 'assets/badges/map.png', category: 'Explorer', isUnlocked: false, progressCurrent: 2, progressTarget: 5),
    ];
  }

  @override
  Future<List<Challenge>> getChallenges() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      const Challenge(id: 'c1', title: 'Explorateur du Dimanche', description: 'Consulter 3 événements aujourd\'hui', type: 'daily', rewardHibons: 30, rewardXp: 15, progressCurrent: 1, progressTarget: 3),
      const Challenge(id: 'c2', title: 'La Totale', description: 'Réserver 1 activité cette semaine', type: 'weekly', rewardHibons: 200, rewardXp: 100, progressCurrent: 0, progressTarget: 1),
    ];
  }

  @override
  Future<WheelConfig> getWheelConfig() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _wheelConfig;
  }

  @override
  Future<WheelSpinResult> spinWheel() async {
    await Future.delayed(const Duration(milliseconds: 2000)); // Suspense
    
    // Simulate probability
    final rand = Random().nextDouble();
    double cumulativeProbability = 0.0;
    WheelSegment? wonSegment;
    
    for (final segment in _wheelConfig.segments) {
      cumulativeProbability += segment.probability;
      if (rand <= cumulativeProbability) {
        wonSegment = segment;
        break;
      }
    }
    // Fallback
    wonSegment ??= _wheelConfig.segments.first;

    // Apply Reward
    int earnedAmount = 0;
    String message = '';
    
    if (wonSegment.type == 'hibons' || wonSegment.type == 'jackpot') {
      earnedAmount = wonSegment.value;
      message = 'Vous avez gagné ${wonSegment.value} Hibons !';
      _wallet = _wallet.copyWith(balance: _wallet.balance + earnedAmount);
    } else if (wonSegment.type == 'multiplier') {
       // Logic for multiplier (store in wallet temp effects)
       message = 'Multiplicateur x${wonSegment.value/10} activé !';
    } else {
       message = 'Vous avez gagné un Badge Rare !';
    }

    if (earnedAmount > 0) {
      _transactions.insert(0, HibonTransaction(
        id: Random().nextInt(100000).toString(),
        type: TransactionType.earn,
        amount: earnedAmount,
        description: 'Roue de la Fortune',
        timestamp: DateTime.now(),
      ));
    }
    
    return WheelSpinResult(segment: wonSegment, earnedHibons: earnedAmount, message: message);
  }

  @override
  Future<HibonsWallet> buyShopItem(String itemId, int cost) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_wallet.balance < cost) throw Exception('Solde insuffisant');
    
    _wallet = _wallet.copyWith(balance: _wallet.balance - cost);
    _transactions.insert(0, HibonTransaction(
      id: Random().nextInt(100000).toString(),
      type: TransactionType.spend,
      amount: cost,
      description: 'Achat Boutique: $itemId',
      timestamp: DateTime.now(),
    ));
    return _wallet;
  }


  @override
  Future<HibonsWallet> earnHibons(int amount, String description) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _wallet = _wallet.copyWith(balance: _wallet.balance + amount);
    _transactions.insert(0, HibonTransaction(
      id: Random().nextInt(100000).toString(),
      type: TransactionType.earn,
      amount: amount,
      description: description,
      timestamp: DateTime.now(),
    ));
    return _wallet;
  }
}

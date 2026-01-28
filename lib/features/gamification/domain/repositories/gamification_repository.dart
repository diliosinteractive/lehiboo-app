import 'package:lehiboo/features/gamification/data/models/hibons_wallet.dart';
import 'package:lehiboo/features/gamification/data/models/hibon_transaction.dart';
import 'package:lehiboo/features/gamification/data/models/daily_reward.dart';
import 'package:lehiboo/features/gamification/data/models/gamification_items.dart';
import 'package:lehiboo/features/gamification/data/models/wheel_models.dart';

/// Résultat du claim de la récompense quotidienne
class DailyClaimResult {
  final int hibonsEarned;
  final int newDay;
  final int newStreak;
  final int newBalance;
  final String message;

  DailyClaimResult({
    required this.hibonsEarned,
    required this.newDay,
    required this.newStreak,
    required this.newBalance,
    required this.message,
  });
}

/// Pack d'achat de hibons
class HibonPackage {
  final String id;
  final String name;
  final int hibons;
  final int priceInCents;
  final String? description;
  final int? bonusPercent;
  final bool isPopular;

  HibonPackage({
    required this.id,
    required this.name,
    required this.hibons,
    required this.priceInCents,
    this.description,
    this.bonusPercent,
    this.isPopular = false,
  });
}

/// Résultat de création d'achat
class PurchaseResult {
  final String clientSecret;
  final String paymentIntentId;

  PurchaseResult({
    required this.clientSecret,
    required this.paymentIntentId,
  });
}

abstract class GamificationRepository {
  // Wallet
  Future<HibonsWallet> getWallet();
  Future<List<HibonTransaction>> getTransactions();

  // Daily Rewards & Streaks
  Future<DailyRewardState> getDailyRewardState();
  Future<DailyClaimResult> claimDailyReward();
  Future<HibonsWallet> buyStreakShield(); // Legacy - non implémenté côté API

  // Gamification (Achievements, Challenges)
  Future<List<Achievement>> getAchievements();
  Future<List<Challenge>> getChallenges();

  // Lucky Wheel
  Future<WheelConfig> getWheelConfig();
  Future<WheelSpinResult> spinWheel();

  // Shop & Purchases
  Future<List<HibonPackage>> getPackages();
  Future<PurchaseResult> createPurchase(String packageId);
  Future<void> confirmPurchase(String paymentIntentId);

  // Chat (Petit Boo)
  Future<void> unlockChatMessages();

  // Actions génériques (legacy)
  Future<HibonsWallet> buyShopItem(String itemId, int cost);
  Future<HibonsWallet> earnHibons(int amount, String description);
}

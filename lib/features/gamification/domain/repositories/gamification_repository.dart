
import 'package:lehiboo/features/gamification/data/models/hibons_wallet.dart';
import 'package:lehiboo/features/gamification/data/models/hibon_transaction.dart';
import 'package:lehiboo/features/gamification/data/models/daily_reward.dart';
import 'package:lehiboo/features/gamification/data/models/gamification_items.dart'; // Achievements & Challenges
import 'package:lehiboo/features/gamification/data/models/wheel_models.dart';

abstract class GamificationRepository {
  // Wallet
  Future<HibonsWallet> getWallet();
  Future<List<HibonTransaction>> getTransactions();
  
  // Daily Rewards & Streaks
  Future<DailyRewardState> getDailyRewardState();
  Future<DailyRewardState> claimDailyReward();
  Future<HibonsWallet> buyStreakShield();

  // Gamification (Achievements, Challenges, Leaderboard)
  Future<List<Achievement>> getAchievements();
  Future<List<Challenge>> getChallenges();
  // Future<Leaderboard> getLeaderboard(); // TODO

  // Lucky Wheel
  Future<WheelConfig> getWheelConfig();
  Future<WheelSpinResult> spinWheel();

  // Actions
  Future<HibonsWallet> buyShopItem(String itemId, int cost); // Generic buy
  Future<HibonsWallet> earnHibons(int amount, String description); // Generic earn (e.g. Ads)
}

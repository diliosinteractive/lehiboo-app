import 'package:flutter/foundation.dart';

import '../../domain/repositories/gamification_repository.dart';
import '../datasources/gamification_api_datasource.dart';
import '../models/hibons_rank.dart';
import '../models/hibons_wallet.dart';
import '../models/hibon_transaction.dart';
import '../models/daily_reward.dart';
import '../models/gamification_items.dart';
import '../models/wheel_models.dart';

class GamificationRepositoryImpl implements GamificationRepository {
  final GamificationApiDataSource _dataSource;

  // Cache du wallet pour éviter les appels répétés
  HibonsWallet? _cachedWallet;

  GamificationRepositoryImpl(this._dataSource);

  @override
  Future<HibonsWallet> getWallet() async {
    debugPrint('🎮 GamificationRepo: getWallet()');
    final dto = await _dataSource.getWallet();

    // Mapper le DTO vers le modèle
    _cachedWallet = HibonsWallet(
      balance: dto.balance,
      lifetimeEarned: dto.lifetimeEarned,
      rank: dto.rank,
      rankEnum: HibonsRank.fromString(dto.rank),
      rankLabel: dto.rankLabel,
      rankIcon: dto.rankIcon,
      nextRank: dto.nextRank == null ? null : HibonsRank.fromString(dto.nextRank),
      nextRankLabel: dto.nextRankLabel,
      hibonsToNextRank: dto.hibonsToNextRank,
      progressToNextRank: dto.progressToNextRank,
      petitBooBonus: dto.petitBooBonus,
      currentStreak: dto.currentStreak,
      maxStreak: dto.maxStreak,
      canClaimDaily: dto.canClaimDaily,
      canSpinWheel: dto.canSpinWheel,
      chatQuota: ChatQuota(
        remaining: dto.chatQuota.remaining,
        limit: dto.chatQuota.limit,
        used: dto.chatQuota.used,
        resetsAt: DateTime.parse(dto.chatQuota.resetsAt),
        canUnlock: dto.chatQuota.canUnlock,
        unlockCost: dto.chatQuota.unlockCost,
        unlockMessages: dto.chatQuota.unlockMessages,
      ),
      dailyRewards: dto.dailyRewards
          .map((d) => DailyRewardItem(
                day: d.day,
                hibons: d.hibons,
                claimed: d.claimed,
                current: d.current,
              ))
          .toList(),
    );

    return _cachedWallet!;
  }

  @override
  Future<List<HibonTransaction>> getTransactions() async {
    debugPrint('🎮 GamificationRepo: getTransactions()');
    final dtos = await _dataSource.getTransactions();

    return dtos
        .map((dto) => HibonTransaction(
              id: dto.id,
              type: _parseTransactionType(dto.type),
              amount: dto.amount,
              description: dto.description,
              timestamp: DateTime.parse(dto.createdAt),
            ))
        .toList();
  }

  TransactionType _parseTransactionType(String type) {
    switch (type.toLowerCase()) {
      case 'earn':
        return TransactionType.earn;
      case 'spend':
        return TransactionType.spend;
      case 'buy':
      case 'purchase':
        return TransactionType.buy;
      default:
        return TransactionType.earn;
    }
  }

  @override
  Future<DailyRewardState> getDailyRewardState() async {
    debugPrint('🎮 GamificationRepo: getDailyRewardState()');
    // Les daily rewards sont inclus dans le wallet
    final wallet = await getWallet();

    // Trouver le jour actuel
    final currentDayItem = wallet.dailyRewards.firstWhere(
      (d) => d.current,
      orElse: () => wallet.dailyRewards.isNotEmpty
          ? wallet.dailyRewards.first
          : const DailyRewardItem(day: 1, hibons: 10, claimed: false, current: true),
    );

    // Vérifier si déjà réclamé aujourd'hui
    final isClaimedToday = currentDayItem.claimed;

    return DailyRewardState(
      currentDay: currentDayItem.day,
      isClaimedToday: isClaimedToday,
      lastClaimDate: isClaimedToday ? DateTime.now() : DateTime.now().subtract(const Duration(days: 1)),
      days: wallet.dailyRewards
          .map((d) => DailyRewardDay(
                dayNumber: d.day,
                hibonsReward: d.hibons,
                xpReward: 0, // Non fourni par l'API
                isJackpot: d.day == 7,
              ))
          .toList(),
    );
  }

  @override
  Future<DailyClaimResult> claimDailyReward() async {
    debugPrint('🎮 GamificationRepo: claimDailyReward()');
    final dto = await _dataSource.claimDailyReward();

    // Invalider le cache du wallet
    _cachedWallet = null;

    return DailyClaimResult(
      hibonsEarned: dto.hibons,
      newDay: dto.day,
      newStreak: dto.streak,
      newBalance: dto.newBalance,
      message: dto.message,
    );
  }

  @override
  Future<HibonsWallet> buyStreakShield() async {
    // Non implémenté côté API - lever une exception
    throw UnimplementedError('Streak shield is not available in the current API');
  }

  @override
  Future<List<Achievement>> getAchievements() async {
    debugPrint('🎮 GamificationRepo: getAchievements()');
    try {
      final dtos = await _dataSource.getAchievements();

      return dtos
          .map((dto) => Achievement(
                id: dto.id,
                title: dto.title,
                description: dto.description,
                iconUrl: dto.iconUrl ?? '',
                category: dto.category,
                isUnlocked: dto.isUnlocked,
                progressCurrent: dto.progressCurrent,
                progressTarget: dto.progressTarget,
                unlockedAt: dto.unlockedAt != null ? DateTime.tryParse(dto.unlockedAt!) : null,
              ))
          .toList();
    } catch (e) {
      debugPrint('🎮 GamificationRepo: getAchievements() error: $e');
      return [];
    }
  }

  @override
  Future<List<Challenge>> getChallenges() async {
    debugPrint('🎮 GamificationRepo: getChallenges()');
    try {
      final dtos = await _dataSource.getChallenges();

      return dtos
          .map((dto) => Challenge(
                id: dto.id,
                title: dto.title,
                description: dto.description,
                type: dto.type,
                rewardHibons: dto.rewardHibons,
                rewardXp: dto.rewardXp,
                progressCurrent: dto.progressCurrent,
                progressTarget: dto.progressTarget,
                isCompleted: dto.isCompleted,
                isClaimed: dto.isClaimed,
                expiresAt: dto.expiresAt != null ? DateTime.tryParse(dto.expiresAt!) : null,
              ))
          .toList();
    } catch (e) {
      debugPrint('🎮 GamificationRepo: getChallenges() error: $e');
      return [];
    }
  }

  @override
  Future<WheelConfig> getWheelConfig() async {
    debugPrint('🎮 GamificationRepo: getWheelConfig()');
    final dto = await _dataSource.getWheelConfig();

    return WheelConfig(
      prizes: dto.prizes
          .map((p) => WheelPrize(
                index: p.index,
                amount: p.amount,
                label: p.label,
                colorInt: _getColorForIndex(p.index),
              ))
          .toList(),
      // Récupérer depuis le wallet si disponible
      isFreeSpinAvailable: _cachedWallet?.canSpinWheel ?? true,
    );
  }

  int _getColorForIndex(int index) {
    const colors = [
      0xFFE0E0E0, // Gris clair
      0xFFB3E5FC, // Bleu clair
      0xFF81C784, // Vert
      0xFFFFF176, // Jaune
      0xFFFFCC80, // Orange clair
      0xFFFFAB91, // Orange
      0xFFCE93D8, // Violet
      0xFFFFD700, // Or
    ];
    return colors[index % colors.length];
  }

  @override
  Future<WheelSpinResult> spinWheel() async {
    debugPrint('🎮 GamificationRepo: spinWheel()');
    final dto = await _dataSource.spinWheel();

    // Invalider le cache du wallet
    _cachedWallet = null;

    return WheelSpinResult(
      prize: dto.prize,
      prizeIndex: dto.prizeIndex,
      message: dto.message,
      newBalance: dto.newBalance,
    );
  }

  @override
  Future<List<HibonPackage>> getPackages() async {
    debugPrint('🎮 GamificationRepo: getPackages()');
    final dtos = await _dataSource.getPackages();

    return dtos
        .map((dto) => HibonPackage(
              id: dto.id,
              name: dto.name,
              hibons: dto.hibons,
              priceInCents: dto.price,
              description: dto.description,
              bonusPercent: dto.bonusPercent,
              isPopular: dto.isPopular,
            ))
        .toList();
  }

  @override
  Future<PurchaseResult> createPurchase(String packageId) async {
    debugPrint('🎮 GamificationRepo: createPurchase($packageId)');
    final dto = await _dataSource.createPurchase(packageId: packageId);

    return PurchaseResult(
      clientSecret: dto.clientSecret,
      paymentIntentId: dto.paymentIntentId,
    );
  }

  @override
  Future<void> confirmPurchase(String paymentIntentId) async {
    debugPrint('🎮 GamificationRepo: confirmPurchase($paymentIntentId)');
    await _dataSource.confirmPurchase(paymentIntentId: paymentIntentId);

    // Invalider le cache du wallet
    _cachedWallet = null;
  }

  @override
  Future<void> unlockChatMessages() async {
    debugPrint('🎮 GamificationRepo: unlockChatMessages()');
    await _dataSource.unlockChatMessages();

    // Invalider le cache du wallet
    _cachedWallet = null;
  }

  @override
  Future<HibonsWallet> buyShopItem(String itemId, int cost) async {
    // Legacy - non utilisé avec l'API réelle
    // On pourrait mapper vers createPurchase si nécessaire
    throw UnimplementedError('Use createPurchase() instead');
  }

  @override
  Future<HibonsWallet> earnHibons(int amount, String description) async {
    // Legacy - les hibons sont gagnés via daily, wheel, etc.
    throw UnimplementedError('Hibons are earned through daily rewards, wheel spins, etc.');
  }
}

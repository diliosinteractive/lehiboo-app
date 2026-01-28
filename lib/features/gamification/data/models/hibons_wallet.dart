import 'package:freezed_annotation/freezed_annotation.dart';

part 'hibons_wallet.freezed.dart';
part 'hibons_wallet.g.dart';

@freezed
class HibonsWallet with _$HibonsWallet {
  const factory HibonsWallet({
    @Default(0) int balance,
    @Default(0) int xp,
    @Default(1) int level,
    @Default('explorateur') String rank,
    @Default('Explorateur') String rankLabel,
    @Default('🧭') String rankIcon,
    @Default(0) int currentStreak,
    @Default(7) int maxStreak,
    @Default(0) int progressToNextLevel,
    @Default(true) bool canClaimDaily,
    @Default(true) bool canSpinWheel,
    ChatQuota? chatQuota,
    @Default([]) List<DailyRewardItem> dailyRewards,
    // Champs legacy pour compatibilité (non utilisés par l'API)
    @Default(false) bool streakShieldActive,
    DateTime? lastActionDate,
  }) = _HibonsWallet;

  factory HibonsWallet.fromJson(Map<String, dynamic> json) =>
      _$HibonsWalletFromJson(json);
}

/// Quota de messages chat (Petit Boo)
@freezed
class ChatQuota with _$ChatQuota {
  const factory ChatQuota({
    required int remaining,
    required int limit,
    required int used,
    required DateTime resetsAt,
    required bool canUnlock,
    required int unlockCost,
    required int unlockMessages,
  }) = _ChatQuota;

  factory ChatQuota.fromJson(Map<String, dynamic> json) =>
      _$ChatQuotaFromJson(json);
}

/// Élément de récompense quotidienne (inclus dans le wallet)
@freezed
class DailyRewardItem with _$DailyRewardItem {
  const factory DailyRewardItem({
    required int day,
    required int hibons,
    required bool claimed,
    required bool current,
  }) = _DailyRewardItem;

  factory DailyRewardItem.fromJson(Map<String, dynamic> json) =>
      _$DailyRewardItemFromJson(json);
}

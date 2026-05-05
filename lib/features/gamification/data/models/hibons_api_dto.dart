import 'package:freezed_annotation/freezed_annotation.dart';

part 'hibons_api_dto.freezed.dart';
part 'hibons_api_dto.g.dart';

/// DTO pour GET /mobile/hibons/wallet
@freezed
class WalletResponseDto with _$WalletResponseDto {
  const factory WalletResponseDto({
    required int balance,
    @JsonKey(name: 'lifetime_earned') @Default(0) int lifetimeEarned,
    required String rank,
    @JsonKey(name: 'rank_label') required String rankLabel,
    @JsonKey(name: 'rank_icon') required String rankIcon,
    @JsonKey(name: 'next_rank') String? nextRank,
    @JsonKey(name: 'next_rank_label') String? nextRankLabel,
    @JsonKey(name: 'hibons_to_next_rank') int? hibonsToNextRank,
    @JsonKey(name: 'progress_to_next_rank') @Default(0) int progressToNextRank,
    @JsonKey(name: 'petit_boo_bonus') @Default(0) int petitBooBonus,
    @JsonKey(name: 'current_streak') required int currentStreak,
    @JsonKey(name: 'max_streak') required int maxStreak,
    @JsonKey(name: 'can_claim_daily') required bool canClaimDaily,
    @JsonKey(name: 'can_spin_wheel') required bool canSpinWheel,
    @JsonKey(name: 'chat_quota') required ChatQuotaDto chatQuota,
    @JsonKey(name: 'daily_rewards') required List<DailyRewardItemDto> dailyRewards,
    int? xp,
    int? level,
    @JsonKey(name: 'progress_to_next_level') int? progressToNextLevel,
  }) = _WalletResponseDto;

  factory WalletResponseDto.fromJson(Map<String, dynamic> json) =>
      _$WalletResponseDtoFromJson(json);
}

/// DTO pour le quota chat inclus dans le wallet
@freezed
class ChatQuotaDto with _$ChatQuotaDto {
  const factory ChatQuotaDto({
    @Default(0) int remaining,
    @Default(3) int limit,
    @Default(0) int used,
    @JsonKey(name: 'resets_at') String? resetsAt,
    @JsonKey(name: 'can_unlock') @Default(false) bool canUnlock,
    @JsonKey(name: 'unlock_cost') @Default(100) int unlockCost,
    @JsonKey(name: 'unlock_messages') @Default(2) int unlockMessages,
    @JsonKey(name: 'base_limit') @Default(3) int baseLimit,
    @JsonKey(name: 'rank_bonus') @Default(0) int rankBonus,
    @JsonKey(name: 'unlocked_today') @Default(0) int unlockedToday,
    @Default('curieux') String rank,
  }) = _ChatQuotaDto;

  factory ChatQuotaDto.fromJson(Map<String, dynamic> json) =>
      _$ChatQuotaDtoFromJson(json);
}

/// DTO pour un jour de récompense dans le wallet
@freezed
class DailyRewardItemDto with _$DailyRewardItemDto {
  const factory DailyRewardItemDto({
    required int day,
    required int hibons,
    required bool claimed,
    required bool current,
  }) = _DailyRewardItemDto;

  factory DailyRewardItemDto.fromJson(Map<String, dynamic> json) =>
      _$DailyRewardItemDtoFromJson(json);
}

/// DTO pour POST /mobile/hibons/daily
@freezed
class DailyClaimResponseDto with _$DailyClaimResponseDto {
  const factory DailyClaimResponseDto({
    required String message,
    required int hibons,
    required int day,
    required int streak,
    @JsonKey(name: 'next_rewards') required List<NextRewardDto> nextRewards,
    @JsonKey(name: 'new_balance') required int newBalance,
  }) = _DailyClaimResponseDto;

  factory DailyClaimResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DailyClaimResponseDtoFromJson(json);
}

@freezed
class NextRewardDto with _$NextRewardDto {
  const factory NextRewardDto({
    required int day,
    required int hibons,
  }) = _NextRewardDto;

  factory NextRewardDto.fromJson(Map<String, dynamic> json) =>
      _$NextRewardDtoFromJson(json);
}

/// DTO pour GET /mobile/hibons/wheel/config
@freezed
class WheelConfigResponseDto with _$WheelConfigResponseDto {
  const factory WheelConfigResponseDto({
    required List<WheelPrizeDto> prizes,
  }) = _WheelConfigResponseDto;

  factory WheelConfigResponseDto.fromJson(Map<String, dynamic> json) =>
      _$WheelConfigResponseDtoFromJson(json);
}

@freezed
class WheelPrizeDto with _$WheelPrizeDto {
  const factory WheelPrizeDto({
    required int index,
    required int amount,
    required String label,
  }) = _WheelPrizeDto;

  factory WheelPrizeDto.fromJson(Map<String, dynamic> json) =>
      _$WheelPrizeDtoFromJson(json);
}

/// DTO pour POST /mobile/hibons/wheel
@freezed
class WheelSpinResponseDto with _$WheelSpinResponseDto {
  const factory WheelSpinResponseDto({
    required int prize,
    @JsonKey(name: 'prize_index') required int prizeIndex,
    required String message,
    @JsonKey(name: 'new_balance') required int newBalance,
  }) = _WheelSpinResponseDto;

  factory WheelSpinResponseDto.fromJson(Map<String, dynamic> json) =>
      _$WheelSpinResponseDtoFromJson(json);
}

/// DTO générique pour les endpoints qui créditent des Hibons et retournent
/// `awarded` + `amount` (heartbeat, track-view, track-share).
@freezed
class HibonsRewardResponseDto with _$HibonsRewardResponseDto {
  const factory HibonsRewardResponseDto({
    @Default(false) bool awarded,
    @Default(0) int amount,
    String? reason,
    String? channel,
    @JsonKey(name: 'new_balance') int? newBalance,
    @JsonKey(name: 'lifetime_earned') int? lifetimeEarned,
  }) = _HibonsRewardResponseDto;

  factory HibonsRewardResponseDto.fromJson(Map<String, dynamic> json) =>
      _$HibonsRewardResponseDtoFromJson(json);
}

/// DTO pour GET /mobile/hibons/transactions
@freezed
class TransactionDto with _$TransactionDto {
  const factory TransactionDto({
    required String id,
    required String type, // earn, spend, purchase, refund
    required int amount,
    required String description,
    String? source,
    String? pillar,
    @JsonKey(name: 'balance_after') int? balanceAfter,
    Map<String, dynamic>? meta,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _TransactionDto;

  factory TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);
}

/// DTO pour GET /mobile/hibons/packages
@freezed
class HibonPackageDto with _$HibonPackageDto {
  const factory HibonPackageDto({
    required String id,
    required String name,
    required int hibons,
    required int price, // en centimes
    String? description,
    @JsonKey(name: 'bonus_percent') int? bonusPercent,
    @JsonKey(name: 'is_popular') @Default(false) bool isPopular,
  }) = _HibonPackageDto;

  factory HibonPackageDto.fromJson(Map<String, dynamic> json) =>
      _$HibonPackageDtoFromJson(json);
}

/// DTO pour POST /mobile/hibons/purchase
@freezed
class PurchaseResponseDto with _$PurchaseResponseDto {
  const factory PurchaseResponseDto({
    @JsonKey(name: 'client_secret') required String clientSecret,
    @JsonKey(name: 'payment_intent_id') required String paymentIntentId,
  }) = _PurchaseResponseDto;

  factory PurchaseResponseDto.fromJson(Map<String, dynamic> json) =>
      _$PurchaseResponseDtoFromJson(json);
}

/// DTO pour GET /mobile/hibons/achievements
@freezed
class AchievementDto with _$AchievementDto {
  const factory AchievementDto({
    required String id,
    required String title,
    required String description,
    @JsonKey(name: 'icon_url') String? iconUrl,
    required String category,
    @JsonKey(name: 'is_unlocked') @Default(false) bool isUnlocked,
    @JsonKey(name: 'progress_current') @Default(0) int progressCurrent,
    @JsonKey(name: 'progress_target') @Default(1) int progressTarget,
    @JsonKey(name: 'unlocked_at') String? unlockedAt,
  }) = _AchievementDto;

  factory AchievementDto.fromJson(Map<String, dynamic> json) =>
      _$AchievementDtoFromJson(json);
}

/// DTO pour GET /mobile/hibons/challenges
@freezed
class ChallengeDto with _$ChallengeDto {
  const factory ChallengeDto({
    required String id,
    required String title,
    required String description,
    required String type, // daily, weekly, sponsored
    @JsonKey(name: 'reward_hibons') @Default(0) int rewardHibons,
    @JsonKey(name: 'reward_xp') @Default(0) int rewardXp,
    @JsonKey(name: 'progress_current') @Default(0) int progressCurrent,
    @JsonKey(name: 'progress_target') @Default(1) int progressTarget,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'is_claimed') @Default(false) bool isClaimed,
    @JsonKey(name: 'expires_at') String? expiresAt,
  }) = _ChallengeDto;

  factory ChallengeDto.fromJson(Map<String, dynamic> json) =>
      _$ChallengeDtoFromJson(json);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hibons_api_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletResponseDtoImpl _$$WalletResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletResponseDtoImpl(
      balance: (json['balance'] as num).toInt(),
      xp: (json['xp'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      rank: json['rank'] as String,
      rankLabel: json['rank_label'] as String,
      rankIcon: json['rank_icon'] as String,
      currentStreak: (json['current_streak'] as num).toInt(),
      maxStreak: (json['max_streak'] as num).toInt(),
      progressToNextLevel: (json['progress_to_next_level'] as num).toInt(),
      canClaimDaily: json['can_claim_daily'] as bool,
      canSpinWheel: json['can_spin_wheel'] as bool,
      chatQuota:
          ChatQuotaDto.fromJson(json['chat_quota'] as Map<String, dynamic>),
      dailyRewards: (json['daily_rewards'] as List<dynamic>)
          .map((e) => DailyRewardItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WalletResponseDtoImplToJson(
        _$WalletResponseDtoImpl instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'xp': instance.xp,
      'level': instance.level,
      'rank': instance.rank,
      'rank_label': instance.rankLabel,
      'rank_icon': instance.rankIcon,
      'current_streak': instance.currentStreak,
      'max_streak': instance.maxStreak,
      'progress_to_next_level': instance.progressToNextLevel,
      'can_claim_daily': instance.canClaimDaily,
      'can_spin_wheel': instance.canSpinWheel,
      'chat_quota': instance.chatQuota,
      'daily_rewards': instance.dailyRewards,
    };

_$ChatQuotaDtoImpl _$$ChatQuotaDtoImplFromJson(Map<String, dynamic> json) =>
    _$ChatQuotaDtoImpl(
      remaining: (json['remaining'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      used: (json['used'] as num).toInt(),
      resetsAt: json['resets_at'] as String,
      canUnlock: json['can_unlock'] as bool,
      unlockCost: (json['unlock_cost'] as num).toInt(),
      unlockMessages: (json['unlock_messages'] as num).toInt(),
    );

Map<String, dynamic> _$$ChatQuotaDtoImplToJson(_$ChatQuotaDtoImpl instance) =>
    <String, dynamic>{
      'remaining': instance.remaining,
      'limit': instance.limit,
      'used': instance.used,
      'resets_at': instance.resetsAt,
      'can_unlock': instance.canUnlock,
      'unlock_cost': instance.unlockCost,
      'unlock_messages': instance.unlockMessages,
    };

_$DailyRewardItemDtoImpl _$$DailyRewardItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyRewardItemDtoImpl(
      day: (json['day'] as num).toInt(),
      hibons: (json['hibons'] as num).toInt(),
      claimed: json['claimed'] as bool,
      current: json['current'] as bool,
    );

Map<String, dynamic> _$$DailyRewardItemDtoImplToJson(
        _$DailyRewardItemDtoImpl instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hibons': instance.hibons,
      'claimed': instance.claimed,
      'current': instance.current,
    };

_$DailyClaimResponseDtoImpl _$$DailyClaimResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyClaimResponseDtoImpl(
      message: json['message'] as String,
      hibons: (json['hibons'] as num).toInt(),
      day: (json['day'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
      nextRewards: (json['next_rewards'] as List<dynamic>)
          .map((e) => NextRewardDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      newBalance: (json['new_balance'] as num).toInt(),
    );

Map<String, dynamic> _$$DailyClaimResponseDtoImplToJson(
        _$DailyClaimResponseDtoImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'hibons': instance.hibons,
      'day': instance.day,
      'streak': instance.streak,
      'next_rewards': instance.nextRewards,
      'new_balance': instance.newBalance,
    };

_$NextRewardDtoImpl _$$NextRewardDtoImplFromJson(Map<String, dynamic> json) =>
    _$NextRewardDtoImpl(
      day: (json['day'] as num).toInt(),
      hibons: (json['hibons'] as num).toInt(),
    );

Map<String, dynamic> _$$NextRewardDtoImplToJson(_$NextRewardDtoImpl instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hibons': instance.hibons,
    };

_$WheelConfigResponseDtoImpl _$$WheelConfigResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WheelConfigResponseDtoImpl(
      prizes: (json['prizes'] as List<dynamic>)
          .map((e) => WheelPrizeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WheelConfigResponseDtoImplToJson(
        _$WheelConfigResponseDtoImpl instance) =>
    <String, dynamic>{
      'prizes': instance.prizes,
    };

_$WheelPrizeDtoImpl _$$WheelPrizeDtoImplFromJson(Map<String, dynamic> json) =>
    _$WheelPrizeDtoImpl(
      index: (json['index'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      label: json['label'] as String,
    );

Map<String, dynamic> _$$WheelPrizeDtoImplToJson(_$WheelPrizeDtoImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'amount': instance.amount,
      'label': instance.label,
    };

_$WheelSpinResponseDtoImpl _$$WheelSpinResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WheelSpinResponseDtoImpl(
      prize: (json['prize'] as num).toInt(),
      prizeIndex: (json['prize_index'] as num).toInt(),
      message: json['message'] as String,
      newBalance: (json['new_balance'] as num).toInt(),
    );

Map<String, dynamic> _$$WheelSpinResponseDtoImplToJson(
        _$WheelSpinResponseDtoImpl instance) =>
    <String, dynamic>{
      'prize': instance.prize,
      'prize_index': instance.prizeIndex,
      'message': instance.message,
      'new_balance': instance.newBalance,
    };

_$TransactionDtoImpl _$$TransactionDtoImplFromJson(Map<String, dynamic> json) =>
    _$TransactionDtoImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toInt(),
      description: json['description'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$TransactionDtoImplToJson(
        _$TransactionDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'amount': instance.amount,
      'description': instance.description,
      'created_at': instance.createdAt,
    };

_$HibonPackageDtoImpl _$$HibonPackageDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$HibonPackageDtoImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      hibons: (json['hibons'] as num).toInt(),
      price: (json['price'] as num).toInt(),
      description: json['description'] as String?,
      bonusPercent: (json['bonus_percent'] as num?)?.toInt(),
      isPopular: json['is_popular'] as bool? ?? false,
    );

Map<String, dynamic> _$$HibonPackageDtoImplToJson(
        _$HibonPackageDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'hibons': instance.hibons,
      'price': instance.price,
      'description': instance.description,
      'bonus_percent': instance.bonusPercent,
      'is_popular': instance.isPopular,
    };

_$PurchaseResponseDtoImpl _$$PurchaseResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PurchaseResponseDtoImpl(
      clientSecret: json['client_secret'] as String,
      paymentIntentId: json['payment_intent_id'] as String,
    );

Map<String, dynamic> _$$PurchaseResponseDtoImplToJson(
        _$PurchaseResponseDtoImpl instance) =>
    <String, dynamic>{
      'client_secret': instance.clientSecret,
      'payment_intent_id': instance.paymentIntentId,
    };

_$AchievementDtoImpl _$$AchievementDtoImplFromJson(Map<String, dynamic> json) =>
    _$AchievementDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      iconUrl: json['icon_url'] as String?,
      category: json['category'] as String,
      isUnlocked: json['is_unlocked'] as bool? ?? false,
      progressCurrent: (json['progress_current'] as num?)?.toInt() ?? 0,
      progressTarget: (json['progress_target'] as num?)?.toInt() ?? 1,
      unlockedAt: json['unlocked_at'] as String?,
    );

Map<String, dynamic> _$$AchievementDtoImplToJson(
        _$AchievementDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'icon_url': instance.iconUrl,
      'category': instance.category,
      'is_unlocked': instance.isUnlocked,
      'progress_current': instance.progressCurrent,
      'progress_target': instance.progressTarget,
      'unlocked_at': instance.unlockedAt,
    };

_$ChallengeDtoImpl _$$ChallengeDtoImplFromJson(Map<String, dynamic> json) =>
    _$ChallengeDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      rewardHibons: (json['reward_hibons'] as num?)?.toInt() ?? 0,
      rewardXp: (json['reward_xp'] as num?)?.toInt() ?? 0,
      progressCurrent: (json['progress_current'] as num?)?.toInt() ?? 0,
      progressTarget: (json['progress_target'] as num?)?.toInt() ?? 1,
      isCompleted: json['is_completed'] as bool? ?? false,
      isClaimed: json['is_claimed'] as bool? ?? false,
      expiresAt: json['expires_at'] as String?,
    );

Map<String, dynamic> _$$ChallengeDtoImplToJson(_$ChallengeDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': instance.type,
      'reward_hibons': instance.rewardHibons,
      'reward_xp': instance.rewardXp,
      'progress_current': instance.progressCurrent,
      'progress_target': instance.progressTarget,
      'is_completed': instance.isCompleted,
      'is_claimed': instance.isClaimed,
      'expires_at': instance.expiresAt,
    };

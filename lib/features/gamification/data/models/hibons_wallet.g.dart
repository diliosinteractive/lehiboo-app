// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hibons_wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HibonsWalletImpl _$$HibonsWalletImplFromJson(Map<String, dynamic> json) =>
    _$HibonsWalletImpl(
      balance: (json['balance'] as num?)?.toInt() ?? 0,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      rank: json['rank'] as String? ?? 'explorateur',
      rankLabel: json['rankLabel'] as String? ?? 'Explorateur',
      rankIcon: json['rankIcon'] as String? ?? '🧭',
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      maxStreak: (json['maxStreak'] as num?)?.toInt() ?? 7,
      progressToNextLevel: (json['progressToNextLevel'] as num?)?.toInt() ?? 0,
      canClaimDaily: json['canClaimDaily'] as bool? ?? true,
      canSpinWheel: json['canSpinWheel'] as bool? ?? true,
      chatQuota: json['chatQuota'] == null
          ? null
          : ChatQuota.fromJson(json['chatQuota'] as Map<String, dynamic>),
      dailyRewards: (json['dailyRewards'] as List<dynamic>?)
              ?.map((e) => DailyRewardItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      streakShieldActive: json['streakShieldActive'] as bool? ?? false,
      lastActionDate: json['lastActionDate'] == null
          ? null
          : DateTime.parse(json['lastActionDate'] as String),
    );

Map<String, dynamic> _$$HibonsWalletImplToJson(_$HibonsWalletImpl instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'xp': instance.xp,
      'level': instance.level,
      'rank': instance.rank,
      'rankLabel': instance.rankLabel,
      'rankIcon': instance.rankIcon,
      'currentStreak': instance.currentStreak,
      'maxStreak': instance.maxStreak,
      'progressToNextLevel': instance.progressToNextLevel,
      'canClaimDaily': instance.canClaimDaily,
      'canSpinWheel': instance.canSpinWheel,
      'chatQuota': instance.chatQuota,
      'dailyRewards': instance.dailyRewards,
      'streakShieldActive': instance.streakShieldActive,
      'lastActionDate': instance.lastActionDate?.toIso8601String(),
    };

_$ChatQuotaImpl _$$ChatQuotaImplFromJson(Map<String, dynamic> json) =>
    _$ChatQuotaImpl(
      remaining: (json['remaining'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      used: (json['used'] as num).toInt(),
      resetsAt: DateTime.parse(json['resetsAt'] as String),
      canUnlock: json['canUnlock'] as bool,
      unlockCost: (json['unlockCost'] as num).toInt(),
      unlockMessages: (json['unlockMessages'] as num).toInt(),
    );

Map<String, dynamic> _$$ChatQuotaImplToJson(_$ChatQuotaImpl instance) =>
    <String, dynamic>{
      'remaining': instance.remaining,
      'limit': instance.limit,
      'used': instance.used,
      'resetsAt': instance.resetsAt.toIso8601String(),
      'canUnlock': instance.canUnlock,
      'unlockCost': instance.unlockCost,
      'unlockMessages': instance.unlockMessages,
    };

_$DailyRewardItemImpl _$$DailyRewardItemImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyRewardItemImpl(
      day: (json['day'] as num).toInt(),
      hibons: (json['hibons'] as num).toInt(),
      claimed: json['claimed'] as bool,
      current: json['current'] as bool,
    );

Map<String, dynamic> _$$DailyRewardItemImplToJson(
        _$DailyRewardItemImpl instance) =>
    <String, dynamic>{
      'day': instance.day,
      'hibons': instance.hibons,
      'claimed': instance.claimed,
      'current': instance.current,
    };

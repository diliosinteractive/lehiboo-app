// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hibons_wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HibonsWalletImpl _$$HibonsWalletImplFromJson(Map<String, dynamic> json) =>
    _$HibonsWalletImpl(
      balance: (json['balance'] as num?)?.toInt() ?? 0,
      lifetimeEarned: (json['lifetimeEarned'] as num?)?.toInt() ?? 0,
      rank: json['rank'] as String? ?? 'curieux',
      rankEnum: $enumDecodeNullable(_$HibonsRankEnumMap, json['rankEnum']) ??
          HibonsRank.curieux,
      rankLabel: json['rankLabel'] as String? ?? 'Curieux',
      rankIcon: json['rankIcon'] as String? ?? '🔍',
      nextRank: $enumDecodeNullable(_$HibonsRankEnumMap, json['nextRank']),
      nextRankLabel: json['nextRankLabel'] as String?,
      hibonsToNextRank: (json['hibonsToNextRank'] as num?)?.toInt(),
      progressToNextRank: (json['progressToNextRank'] as num?)?.toInt() ?? 0,
      petitBooBonus: (json['petitBooBonus'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      maxStreak: (json['maxStreak'] as num?)?.toInt() ?? 7,
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
      xp: (json['xp'] as num?)?.toInt(),
      level: (json['level'] as num?)?.toInt(),
      progressToNextLevel: (json['progressToNextLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$HibonsWalletImplToJson(_$HibonsWalletImpl instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'lifetimeEarned': instance.lifetimeEarned,
      'rank': instance.rank,
      'rankEnum': _$HibonsRankEnumMap[instance.rankEnum]!,
      'rankLabel': instance.rankLabel,
      'rankIcon': instance.rankIcon,
      'nextRank': _$HibonsRankEnumMap[instance.nextRank],
      'nextRankLabel': instance.nextRankLabel,
      'hibonsToNextRank': instance.hibonsToNextRank,
      'progressToNextRank': instance.progressToNextRank,
      'petitBooBonus': instance.petitBooBonus,
      'currentStreak': instance.currentStreak,
      'maxStreak': instance.maxStreak,
      'canClaimDaily': instance.canClaimDaily,
      'canSpinWheel': instance.canSpinWheel,
      'chatQuota': instance.chatQuota,
      'dailyRewards': instance.dailyRewards,
      'streakShieldActive': instance.streakShieldActive,
      'lastActionDate': instance.lastActionDate?.toIso8601String(),
      'xp': instance.xp,
      'level': instance.level,
      'progressToNextLevel': instance.progressToNextLevel,
    };

const _$HibonsRankEnumMap = {
  HibonsRank.curieux: 'curieux',
  HibonsRank.explorateur: 'explorateur',
  HibonsRank.aventurier: 'aventurier',
  HibonsRank.legende: 'legende',
};

_$ChatQuotaImpl _$$ChatQuotaImplFromJson(Map<String, dynamic> json) =>
    _$ChatQuotaImpl(
      remaining: (json['remaining'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 3,
      used: (json['used'] as num?)?.toInt() ?? 0,
      resetsAt: json['resetsAt'] == null
          ? null
          : DateTime.parse(json['resetsAt'] as String),
      canUnlock: json['canUnlock'] as bool? ?? false,
      unlockCost: (json['unlockCost'] as num?)?.toInt() ?? 100,
      unlockMessages: (json['unlockMessages'] as num?)?.toInt() ?? 2,
      baseLimit: (json['baseLimit'] as num?)?.toInt() ?? 3,
      rankBonus: (json['rankBonus'] as num?)?.toInt() ?? 0,
      unlockedToday: (json['unlockedToday'] as num?)?.toInt() ?? 0,
      rank: json['rank'] as String? ?? 'curieux',
    );

Map<String, dynamic> _$$ChatQuotaImplToJson(_$ChatQuotaImpl instance) =>
    <String, dynamic>{
      'remaining': instance.remaining,
      'limit': instance.limit,
      'used': instance.used,
      'resetsAt': instance.resetsAt?.toIso8601String(),
      'canUnlock': instance.canUnlock,
      'unlockCost': instance.unlockCost,
      'unlockMessages': instance.unlockMessages,
      'baseLimit': instance.baseLimit,
      'rankBonus': instance.rankBonus,
      'unlockedToday': instance.unlockedToday,
      'rank': instance.rank,
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

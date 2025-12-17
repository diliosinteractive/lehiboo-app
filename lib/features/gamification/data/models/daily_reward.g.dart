// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DailyRewardStateImpl _$$DailyRewardStateImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyRewardStateImpl(
      currentDay: (json['currentDay'] as num).toInt(),
      isClaimedToday: json['isClaimedToday'] as bool,
      lastClaimDate: DateTime.parse(json['lastClaimDate'] as String),
      days: (json['days'] as List<dynamic>)
          .map((e) => DailyRewardDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DailyRewardStateImplToJson(
        _$DailyRewardStateImpl instance) =>
    <String, dynamic>{
      'currentDay': instance.currentDay,
      'isClaimedToday': instance.isClaimedToday,
      'lastClaimDate': instance.lastClaimDate.toIso8601String(),
      'days': instance.days,
    };

_$DailyRewardDayImpl _$$DailyRewardDayImplFromJson(Map<String, dynamic> json) =>
    _$DailyRewardDayImpl(
      dayNumber: (json['dayNumber'] as num).toInt(),
      hibonsReward: (json['hibonsReward'] as num).toInt(),
      xpReward: (json['xpReward'] as num).toInt(),
      bonusDescription: json['bonusDescription'] as String?,
      isJackpot: json['isJackpot'] as bool? ?? false,
    );

Map<String, dynamic> _$$DailyRewardDayImplToJson(
        _$DailyRewardDayImpl instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'hibonsReward': instance.hibonsReward,
      'xpReward': instance.xpReward,
      'bonusDescription': instance.bonusDescription,
      'isJackpot': instance.isJackpot,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quota_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuotaDtoImpl _$$QuotaDtoImplFromJson(Map<String, dynamic> json) =>
    _$QuotaDtoImpl(
      used: (json['used'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 3,
      remaining: (json['remaining'] as num?)?.toInt() ?? 3,
      resetsAt: json['resets_at'] as String?,
      resetAt: json['reset_at'] as String?,
      period: json['period'] as String? ?? 'daily',
      baseLimit: (json['base_limit'] as num?)?.toInt() ?? 3,
      rankBonus: (json['rank_bonus'] as num?)?.toInt() ?? 0,
      unlockedToday: (json['unlocked_today'] as num?)?.toInt() ?? 0,
      canUnlock: json['can_unlock'] as bool? ?? false,
      unlockCost: (json['unlock_cost'] as num?)?.toInt() ?? 100,
      unlockMessages: (json['unlock_messages'] as num?)?.toInt() ?? 2,
      rank: json['rank'] as String? ?? 'curieux',
    );

Map<String, dynamic> _$$QuotaDtoImplToJson(_$QuotaDtoImpl instance) =>
    <String, dynamic>{
      'used': instance.used,
      'limit': instance.limit,
      'remaining': instance.remaining,
      'resets_at': instance.resetsAt,
      'reset_at': instance.resetAt,
      'period': instance.period,
      'base_limit': instance.baseLimit,
      'rank_bonus': instance.rankBonus,
      'unlocked_today': instance.unlockedToday,
      'can_unlock': instance.canUnlock,
      'unlock_cost': instance.unlockCost,
      'unlock_messages': instance.unlockMessages,
      'rank': instance.rank,
    };

_$QuotaResponseDtoImpl _$$QuotaResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$QuotaResponseDtoImpl(
      success: json['success'] as bool,
      data: QuotaDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$QuotaResponseDtoImplToJson(
        _$QuotaResponseDtoImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
    };

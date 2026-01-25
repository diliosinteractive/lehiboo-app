// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quota_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuotaDtoImpl _$$QuotaDtoImplFromJson(Map<String, dynamic> json) =>
    _$QuotaDtoImpl(
      used: (json['used'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      remaining: (json['remaining'] as num?)?.toInt() ?? 10,
      resetsAt: json['resets_at'] as String?,
      period: json['period'] as String? ?? 'daily',
    );

Map<String, dynamic> _$$QuotaDtoImplToJson(_$QuotaDtoImpl instance) =>
    <String, dynamic>{
      'used': instance.used,
      'limit': instance.limit,
      'remaining': instance.remaining,
      'resets_at': instance.resetsAt,
      'period': instance.period,
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

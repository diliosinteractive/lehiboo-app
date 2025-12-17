// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wheel_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WheelSegmentImpl _$$WheelSegmentImplFromJson(Map<String, dynamic> json) =>
    _$WheelSegmentImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      value: (json['value'] as num).toInt(),
      probability: (json['probability'] as num).toDouble(),
      colorInt: (json['colorInt'] as num?)?.toInt() ?? 0xFFFFFFFF,
    );

Map<String, dynamic> _$$WheelSegmentImplToJson(_$WheelSegmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'type': instance.type,
      'value': instance.value,
      'probability': instance.probability,
      'colorInt': instance.colorInt,
    };

_$WheelConfigImpl _$$WheelConfigImplFromJson(Map<String, dynamic> json) =>
    _$WheelConfigImpl(
      segments: (json['segments'] as List<dynamic>)
          .map((e) => WheelSegment.fromJson(e as Map<String, dynamic>))
          .toList(),
      costPerSpin: (json['costPerSpin'] as num).toInt(),
      isFreeSpinAvailable: json['isFreeSpinAvailable'] as bool,
      nextFreeSpinDate: json['nextFreeSpinDate'] == null
          ? null
          : DateTime.parse(json['nextFreeSpinDate'] as String),
    );

Map<String, dynamic> _$$WheelConfigImplToJson(_$WheelConfigImpl instance) =>
    <String, dynamic>{
      'segments': instance.segments,
      'costPerSpin': instance.costPerSpin,
      'isFreeSpinAvailable': instance.isFreeSpinAvailable,
      'nextFreeSpinDate': instance.nextFreeSpinDate?.toIso8601String(),
    };

_$WheelSpinResultImpl _$$WheelSpinResultImplFromJson(
        Map<String, dynamic> json) =>
    _$WheelSpinResultImpl(
      segment: WheelSegment.fromJson(json['segment'] as Map<String, dynamic>),
      earnedHibons: (json['earnedHibons'] as num).toInt(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$$WheelSpinResultImplToJson(
        _$WheelSpinResultImpl instance) =>
    <String, dynamic>{
      'segment': instance.segment,
      'earnedHibons': instance.earnedHibons,
      'message': instance.message,
    };

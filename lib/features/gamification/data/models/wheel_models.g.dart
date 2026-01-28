// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wheel_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WheelConfigImpl _$$WheelConfigImplFromJson(Map<String, dynamic> json) =>
    _$WheelConfigImpl(
      prizes: (json['prizes'] as List<dynamic>)
          .map((e) => WheelPrize.fromJson(e as Map<String, dynamic>))
          .toList(),
      costPerSpin: (json['costPerSpin'] as num?)?.toInt() ?? 0,
      isFreeSpinAvailable: json['isFreeSpinAvailable'] as bool? ?? true,
      nextFreeSpinDate: json['nextFreeSpinDate'] == null
          ? null
          : DateTime.parse(json['nextFreeSpinDate'] as String),
    );

Map<String, dynamic> _$$WheelConfigImplToJson(_$WheelConfigImpl instance) =>
    <String, dynamic>{
      'prizes': instance.prizes,
      'costPerSpin': instance.costPerSpin,
      'isFreeSpinAvailable': instance.isFreeSpinAvailable,
      'nextFreeSpinDate': instance.nextFreeSpinDate?.toIso8601String(),
    };

_$WheelPrizeImpl _$$WheelPrizeImplFromJson(Map<String, dynamic> json) =>
    _$WheelPrizeImpl(
      index: (json['index'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      label: json['label'] as String,
      colorInt: (json['colorInt'] as num?)?.toInt() ?? 0xFFFFFFFF,
    );

Map<String, dynamic> _$$WheelPrizeImplToJson(_$WheelPrizeImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'amount': instance.amount,
      'label': instance.label,
      'colorInt': instance.colorInt,
    };

_$WheelSpinResultImpl _$$WheelSpinResultImplFromJson(
        Map<String, dynamic> json) =>
    _$WheelSpinResultImpl(
      prize: (json['prize'] as num).toInt(),
      prizeIndex: (json['prizeIndex'] as num).toInt(),
      message: json['message'] as String,
      newBalance: (json['newBalance'] as num).toInt(),
    );

Map<String, dynamic> _$$WheelSpinResultImplToJson(
        _$WheelSpinResultImpl instance) =>
    <String, dynamic>{
      'prize': instance.prize,
      'prizeIndex': instance.prizeIndex,
      'message': instance.message,
      'newBalance': instance.newBalance,
    };

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

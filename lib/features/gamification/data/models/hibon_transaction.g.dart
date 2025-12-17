// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hibon_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HibonTransactionImpl _$$HibonTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$HibonTransactionImpl(
      id: json['id'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toInt(),
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$HibonTransactionImplToJson(
        _$HibonTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.earn: 'earn',
  TransactionType.spend: 'spend',
  TransactionType.buy: 'buy',
};

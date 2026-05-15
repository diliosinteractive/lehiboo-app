// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_completed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PayoutCompletedDataImpl _$$PayoutCompletedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PayoutCompletedDataImpl(
      organizationId: (json['organization_id'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      payoutReference: json['payout_reference'] as String?,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

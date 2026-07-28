// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_cancelled.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PayoutCancelledDataImpl _$$PayoutCancelledDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PayoutCancelledDataImpl(
      organizationId: (json['organization_id'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      payoutReference: json['payout_reference'] as String?,
      reason: json['reason'] as String?,
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
    );

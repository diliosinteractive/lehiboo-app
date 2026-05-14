// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout_requested.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PayoutRequestedDataImpl _$$PayoutRequestedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PayoutRequestedDataImpl(
      organizationId: (json['organization_id'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      payoutReference: json['payout_reference'] as String?,
      requestedAt: json['requested_at'] == null
          ? null
          : DateTime.parse(json['requested_at'] as String),
    );

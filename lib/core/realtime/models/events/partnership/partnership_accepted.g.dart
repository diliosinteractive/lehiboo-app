// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partnership_accepted.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PartnershipAcceptedDataImpl _$$PartnershipAcceptedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PartnershipAcceptedDataImpl(
      partnershipId: json['partnership_id'] as String,
      partnerName: json['partner_name'] as String?,
      acceptedAt: json['accepted_at'] == null
          ? null
          : DateTime.parse(json['accepted_at'] as String),
    );

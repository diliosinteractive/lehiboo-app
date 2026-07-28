// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partnership_invited.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PartnershipInvitedDataImpl _$$PartnershipInvitedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$PartnershipInvitedDataImpl(
      partnershipId: json['partnership_id'] as String,
      inviterName: json['inviter_name'] as String?,
      invitedAt: json['invited_at'] == null
          ? null
          : DateTime.parse(json['invited_at'] as String),
    );

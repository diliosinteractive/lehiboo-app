// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_rejected.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationRejectedDataImpl _$$OrganizationRejectedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationRejectedDataImpl(
      organizationId: (json['organization_id'] as num).toInt(),
      organizationUuid: json['organization_uuid'] as String?,
      organizationName: json['organization_name'] as String?,
      reason: json['reason'] as String?,
      rejectedAt: json['rejected_at'] == null
          ? null
          : DateTime.parse(json['rejected_at'] as String),
    );

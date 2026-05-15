// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_approved.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationApprovedDataImpl _$$OrganizationApprovedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationApprovedDataImpl(
      organizationId: (json['organization_id'] as num).toInt(),
      organizationUuid: json['organization_uuid'] as String?,
      organizationName: json['organization_name'] as String?,
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
    );

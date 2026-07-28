// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_verified.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationVerifiedDataImpl _$$OrganizationVerifiedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationVerifiedDataImpl(
      organizationId: (json['organization_id'] as num).toInt(),
      organizationName: json['organization_name'] as String?,
      verifiedAt: json['verified_at'] == null
          ? null
          : DateTime.parse(json['verified_at'] as String),
    );

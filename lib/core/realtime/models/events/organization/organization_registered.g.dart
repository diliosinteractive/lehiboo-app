// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_registered.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationRegisteredDataImpl _$$OrganizationRegisteredDataImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationRegisteredDataImpl(
      organizationId: (json['organization_id'] as num).toInt(),
      organizationName: json['organization_name'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      registeredAt: json['registered_at'] == null
          ? null
          : DateTime.parse(json['registered_at'] as String),
    );

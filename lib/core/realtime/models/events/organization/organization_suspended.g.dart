// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_suspended.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationSuspendedDataImpl _$$OrganizationSuspendedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationSuspendedDataImpl(
      organizationId: (json['organization_id'] as num).toInt(),
      reason: json['reason'] as String?,
      suspendedAt: json['suspended_at'] == null
          ? null
          : DateTime.parse(json['suspended_at'] as String),
    );

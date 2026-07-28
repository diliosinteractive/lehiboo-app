// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_reactivated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizationReactivatedDataImpl _$$OrganizationReactivatedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizationReactivatedDataImpl(
      organizationId: (json['organization_id'] as num).toInt(),
      reactivatedAt: json['reactivated_at'] == null
          ? null
          : DateTime.parse(json['reactivated_at'] as String),
    );

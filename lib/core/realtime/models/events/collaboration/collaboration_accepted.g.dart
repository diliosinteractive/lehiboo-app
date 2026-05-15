// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaboration_accepted.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollaborationAcceptedDataImpl _$$CollaborationAcceptedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$CollaborationAcceptedDataImpl(
      collaboratorId: (json['collaborator_id'] as num).toInt(),
      collaboratorUuid: json['collaborator_uuid'] as String,
      eventId: (json['event_id'] as num).toInt(),
      eventTitle: json['event_title'] as String?,
      organizationId: (json['organization_id'] as num?)?.toInt(),
      organizationName: json['organization_name'] as String?,
      role: json['role'] as String?,
      acceptedAt: json['accepted_at'] == null
          ? null
          : DateTime.parse(json['accepted_at'] as String),
    );

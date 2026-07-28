// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaboration_rejected.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollaborationRejectedDataImpl _$$CollaborationRejectedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$CollaborationRejectedDataImpl(
      collaboratorId: (json['collaborator_id'] as num).toInt(),
      collaboratorUuid: json['collaborator_uuid'] as String,
      eventId: (json['event_id'] as num).toInt(),
      eventTitle: json['event_title'] as String?,
      organizationId: (json['organization_id'] as num?)?.toInt(),
      organizationName: json['organization_name'] as String?,
      role: json['role'] as String?,
    );

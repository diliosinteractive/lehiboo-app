// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaboration_invited.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollaborationInvitedDataImpl _$$CollaborationInvitedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$CollaborationInvitedDataImpl(
      collaboratorId: (json['collaborator_id'] as num).toInt(),
      collaboratorUuid: json['collaborator_uuid'] as String,
      eventId: (json['event_id'] as num).toInt(),
      eventTitle: json['event_title'] as String?,
      role: json['role'] as String?,
      invitedBy: json['invited_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

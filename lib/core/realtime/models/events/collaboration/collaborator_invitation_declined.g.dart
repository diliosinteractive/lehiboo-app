// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaborator_invitation_declined.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollaboratorInvitationDeclinedDataImpl
    _$$CollaboratorInvitationDeclinedDataImplFromJson(
            Map<String, dynamic> json) =>
        _$CollaboratorInvitationDeclinedDataImpl(
          invitationId: (json['invitation_id'] as num).toInt(),
          invitationUuid: json['invitation_uuid'] as String,
          eventId: (json['event_id'] as num).toInt(),
          eventTitle: json['event_title'] as String?,
          email: json['email'] as String,
          role: json['role'] as String?,
        );

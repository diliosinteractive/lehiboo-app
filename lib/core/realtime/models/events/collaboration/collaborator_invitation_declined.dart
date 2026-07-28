import 'package:freezed_annotation/freezed_annotation.dart';

part 'collaborator_invitation_declined.freezed.dart';
part 'collaborator_invitation_declined.g.dart';

/// Payload of the `collaborator.invitation.declined` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §9
@Freezed(toJson: false)
class CollaboratorInvitationDeclinedData
    with _$CollaboratorInvitationDeclinedData {
  const factory CollaboratorInvitationDeclinedData({
    @JsonKey(name: 'invitation_id') required int invitationId,
    @JsonKey(name: 'invitation_uuid') required String invitationUuid,
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'event_title') String? eventTitle,
    required String email,
    String? role,
  }) = _CollaboratorInvitationDeclinedData;

  factory CollaboratorInvitationDeclinedData.fromJson(
          Map<String, dynamic> json) =>
      _$CollaboratorInvitationDeclinedDataFromJson(json);
}

@Freezed(toJson: false)
class CollaboratorInvitationDeclinedNotification
    with _$CollaboratorInvitationDeclinedNotification {
  const factory CollaboratorInvitationDeclinedNotification({
    required String event,
    String? channel,
    required CollaboratorInvitationDeclinedData data,
    DateTime? receivedAt,
  }) = _CollaboratorInvitationDeclinedNotification;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'collaboration_invited.freezed.dart';
part 'collaboration_invited.g.dart';

/// Payload of the `collaboration.invited` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §9
@Freezed(toJson: false)
class CollaborationInvitedData with _$CollaborationInvitedData {
  const factory CollaborationInvitedData({
    @JsonKey(name: 'collaborator_id') required int collaboratorId,
    @JsonKey(name: 'collaborator_uuid') required String collaboratorUuid,
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'event_title') String? eventTitle,
    String? role,
    @JsonKey(name: 'invited_by') String? invitedBy,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _CollaborationInvitedData;

  factory CollaborationInvitedData.fromJson(Map<String, dynamic> json) =>
      _$CollaborationInvitedDataFromJson(json);
}

@Freezed(toJson: false)
class CollaborationInvitedNotification with _$CollaborationInvitedNotification {
  const factory CollaborationInvitedNotification({
    required String event,
    String? channel,
    required CollaborationInvitedData data,
    DateTime? receivedAt,
  }) = _CollaborationInvitedNotification;
}

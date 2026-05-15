import 'package:freezed_annotation/freezed_annotation.dart';

part 'collaboration_accepted.freezed.dart';
part 'collaboration_accepted.g.dart';

/// Payload of the `collaboration.accepted` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §9
@Freezed(toJson: false)
class CollaborationAcceptedData with _$CollaborationAcceptedData {
  const factory CollaborationAcceptedData({
    @JsonKey(name: 'collaborator_id') required int collaboratorId,
    @JsonKey(name: 'collaborator_uuid') required String collaboratorUuid,
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'event_title') String? eventTitle,
    @JsonKey(name: 'organization_id') int? organizationId,
    @JsonKey(name: 'organization_name') String? organizationName,
    String? role,
    @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
  }) = _CollaborationAcceptedData;

  factory CollaborationAcceptedData.fromJson(Map<String, dynamic> json) =>
      _$CollaborationAcceptedDataFromJson(json);
}

@Freezed(toJson: false)
class CollaborationAcceptedNotification
    with _$CollaborationAcceptedNotification {
  const factory CollaborationAcceptedNotification({
    required String event,
    String? channel,
    required CollaborationAcceptedData data,
    DateTime? receivedAt,
  }) = _CollaborationAcceptedNotification;
}

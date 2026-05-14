import 'package:freezed_annotation/freezed_annotation.dart';

part 'collaboration_rejected.freezed.dart';
part 'collaboration_rejected.g.dart';

/// Payload of the `collaboration.rejected` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §9
@Freezed(toJson: false)
class CollaborationRejectedData with _$CollaborationRejectedData {
  const factory CollaborationRejectedData({
    @JsonKey(name: 'collaborator_id') required int collaboratorId,
    @JsonKey(name: 'collaborator_uuid') required String collaboratorUuid,
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'event_title') String? eventTitle,
    @JsonKey(name: 'organization_id') int? organizationId,
    @JsonKey(name: 'organization_name') String? organizationName,
    String? role,
  }) = _CollaborationRejectedData;

  factory CollaborationRejectedData.fromJson(Map<String, dynamic> json) =>
      _$CollaborationRejectedDataFromJson(json);
}

@Freezed(toJson: false)
class CollaborationRejectedNotification
    with _$CollaborationRejectedNotification {
  const factory CollaborationRejectedNotification({
    required String event,
    String? channel,
    required CollaborationRejectedData data,
    DateTime? receivedAt,
  }) = _CollaborationRejectedNotification;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'collaboration_removed.freezed.dart';
part 'collaboration_removed.g.dart';

/// Payload of the `collaboration.removed` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §9
@Freezed(toJson: false)
class CollaborationRemovedData with _$CollaborationRemovedData {
  const factory CollaborationRemovedData({
    @JsonKey(name: 'collaborator_id') required int collaboratorId,
    @JsonKey(name: 'collaborator_uuid') required String collaboratorUuid,
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'event_title') String? eventTitle,
  }) = _CollaborationRemovedData;

  factory CollaborationRemovedData.fromJson(Map<String, dynamic> json) =>
      _$CollaborationRemovedDataFromJson(json);
}

@Freezed(toJson: false)
class CollaborationRemovedNotification with _$CollaborationRemovedNotification {
  const factory CollaborationRemovedNotification({
    required String event,
    String? channel,
    required CollaborationRemovedData data,
    DateTime? receivedAt,
  }) = _CollaborationRemovedNotification;
}

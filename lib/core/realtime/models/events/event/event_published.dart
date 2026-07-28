import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_published.freezed.dart';
part 'event_published.g.dart';

/// Payload of the `event.published` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §6
@Freezed(toJson: false)
class EventPublishedData with _$EventPublishedData {
  const factory EventPublishedData({
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'event_uuid') required String eventUuid,
    required String title,
    required String slug,
    @JsonKey(name: 'organization_id') required int organizationId,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
  }) = _EventPublishedData;

  factory EventPublishedData.fromJson(Map<String, dynamic> json) =>
      _$EventPublishedDataFromJson(json);
}

@Freezed(toJson: false)
class EventPublishedNotification with _$EventPublishedNotification {
  const factory EventPublishedNotification({
    required String event,
    String? channel,
    required EventPublishedData data,
    DateTime? receivedAt,
  }) = _EventPublishedNotification;
}

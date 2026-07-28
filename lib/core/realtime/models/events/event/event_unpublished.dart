import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_unpublished.freezed.dart';
part 'event_unpublished.g.dart';

/// Payload of the `event.unpublished` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §6
@Freezed(toJson: false)
class EventUnpublishedData with _$EventUnpublishedData {
  const factory EventUnpublishedData({
    @JsonKey(name: 'event_id') required int eventId,
    required String title,
    required String slug,
    @JsonKey(name: 'vendor_id') required int vendorId,
    @JsonKey(name: 'unpublished_at') DateTime? unpublishedAt,
  }) = _EventUnpublishedData;

  factory EventUnpublishedData.fromJson(Map<String, dynamic> json) =>
      _$EventUnpublishedDataFromJson(json);
}

@Freezed(toJson: false)
class EventUnpublishedNotification with _$EventUnpublishedNotification {
  const factory EventUnpublishedNotification({
    required String event,
    String? channel,
    required EventUnpublishedData data,
    DateTime? receivedAt,
  }) = _EventUnpublishedNotification;
}

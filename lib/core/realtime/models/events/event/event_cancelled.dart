import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_cancelled.freezed.dart';
part 'event_cancelled.g.dart';

/// Payload of the `event.cancelled` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §6
@Freezed(toJson: false)
class EventCancelledData with _$EventCancelledData {
  const factory EventCancelledData({
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'event_uuid') required String eventUuid,
    required String title,
    String? reason,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
  }) = _EventCancelledData;

  factory EventCancelledData.fromJson(Map<String, dynamic> json) =>
      _$EventCancelledDataFromJson(json);
}

@Freezed(toJson: false)
class EventCancelledNotification with _$EventCancelledNotification {
  const factory EventCancelledNotification({
    required String event,
    String? channel,
    required EventCancelledData data,
    DateTime? receivedAt,
  }) = _EventCancelledNotification;
}

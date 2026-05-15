import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_cancelled.freezed.dart';
part 'booking_cancelled.g.dart';

/// Payload of the `booking.cancelled` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §4
@Freezed(toJson: false)
class BookingCancelledData with _$BookingCancelledData {
  const factory BookingCancelledData({
    @JsonKey(name: 'booking_id') required int bookingId,
    @JsonKey(name: 'booking_uuid') required String bookingUuid,
    @JsonKey(name: 'event_id') required int eventId,
    String? reason,
    @JsonKey(name: 'cancelled_at') DateTime? cancelledAt,
  }) = _BookingCancelledData;

  factory BookingCancelledData.fromJson(Map<String, dynamic> json) =>
      _$BookingCancelledDataFromJson(json);
}

@Freezed(toJson: false)
class BookingCancelledNotification with _$BookingCancelledNotification {
  const factory BookingCancelledNotification({
    required String event,
    String? channel,
    required BookingCancelledData data,
    DateTime? receivedAt,
  }) = _BookingCancelledNotification;
}

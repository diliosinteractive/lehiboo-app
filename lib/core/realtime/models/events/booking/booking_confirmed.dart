import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_confirmed.freezed.dart';
part 'booking_confirmed.g.dart';

/// Payload of the `booking.confirmed` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §4
@Freezed(toJson: false)
class BookingConfirmedData with _$BookingConfirmedData {
  const factory BookingConfirmedData({
    @JsonKey(name: 'booking_id') required int bookingId,
    @JsonKey(name: 'booking_uuid') required String bookingUuid,
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'total_amount') required int totalAmount,
    @JsonKey(name: 'confirmed_at') DateTime? confirmedAt,
  }) = _BookingConfirmedData;

  factory BookingConfirmedData.fromJson(Map<String, dynamic> json) =>
      _$BookingConfirmedDataFromJson(json);
}

@Freezed(toJson: false)
class BookingConfirmedNotification with _$BookingConfirmedNotification {
  const factory BookingConfirmedNotification({
    required String event,
    String? channel,
    required BookingConfirmedData data,
    DateTime? receivedAt,
  }) = _BookingConfirmedNotification;
}

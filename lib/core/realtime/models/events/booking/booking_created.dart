import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_created.freezed.dart';
part 'booking_created.g.dart';

/// Payload of the `booking.created` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §4
@Freezed(toJson: false)
class BookingCreatedData with _$BookingCreatedData {
  const factory BookingCreatedData({
    @JsonKey(name: 'booking_id') required int bookingId,
    @JsonKey(name: 'booking_uuid') required String bookingUuid,
    @JsonKey(name: 'event_id') required int eventId,
    @JsonKey(name: 'total_amount') required int totalAmount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _BookingCreatedData;

  factory BookingCreatedData.fromJson(Map<String, dynamic> json) =>
      _$BookingCreatedDataFromJson(json);
}

@Freezed(toJson: false)
class BookingCreatedNotification with _$BookingCreatedNotification {
  const factory BookingCreatedNotification({
    required String event,
    String? channel,
    required BookingCreatedData data,
    DateTime? receivedAt,
  }) = _BookingCreatedNotification;
}

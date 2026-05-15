import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_refunded.freezed.dart';
part 'booking_refunded.g.dart';

/// Payload of the `booking.refunded` event.
/// See: `docs/PUSHER_EVENTS_CATALOG.md` §4
@Freezed(toJson: false)
class BookingRefundedData with _$BookingRefundedData {
  const factory BookingRefundedData({
    @JsonKey(name: 'booking_id') required int bookingId,
    @JsonKey(name: 'booking_uuid') required String bookingUuid,
    @JsonKey(name: 'refund_amount') required int refundAmount,
    @JsonKey(name: 'is_partial') @Default(false) bool isPartial,
    @JsonKey(name: 'refunded_at') DateTime? refundedAt,
  }) = _BookingRefundedData;

  factory BookingRefundedData.fromJson(Map<String, dynamic> json) =>
      _$BookingRefundedDataFromJson(json);
}

@Freezed(toJson: false)
class BookingRefundedNotification with _$BookingRefundedNotification {
  const factory BookingRefundedNotification({
    required String event,
    String? channel,
    required BookingRefundedData data,
    DateTime? receivedAt,
  }) = _BookingRefundedNotification;
}

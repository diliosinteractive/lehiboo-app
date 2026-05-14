// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_refunded.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingRefundedDataImpl _$$BookingRefundedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingRefundedDataImpl(
      bookingId: (json['booking_id'] as num).toInt(),
      bookingUuid: json['booking_uuid'] as String,
      refundAmount: (json['refund_amount'] as num).toInt(),
      isPartial: json['is_partial'] as bool? ?? false,
      refundedAt: json['refunded_at'] == null
          ? null
          : DateTime.parse(json['refunded_at'] as String),
    );

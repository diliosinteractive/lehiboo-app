// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_cancelled.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingCancelledDataImpl _$$BookingCancelledDataImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingCancelledDataImpl(
      bookingId: (json['booking_id'] as num).toInt(),
      bookingUuid: json['booking_uuid'] as String,
      eventId: (json['event_id'] as num).toInt(),
      reason: json['reason'] as String?,
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
    );

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_confirmed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingConfirmedDataImpl _$$BookingConfirmedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingConfirmedDataImpl(
      bookingId: (json['booking_id'] as num).toInt(),
      bookingUuid: json['booking_uuid'] as String,
      eventId: (json['event_id'] as num).toInt(),
      totalAmount: (json['total_amount'] as num).toInt(),
      confirmedAt: json['confirmed_at'] == null
          ? null
          : DateTime.parse(json['confirmed_at'] as String),
    );

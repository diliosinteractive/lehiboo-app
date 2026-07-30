// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_created.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingCreatedDataImpl _$$BookingCreatedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingCreatedDataImpl(
      bookingId: (json['booking_id'] as num).toInt(),
      bookingUuid: json['booking_uuid'] as String,
      eventId: (json['event_id'] as num).toInt(),
      totalAmount: _parseTotalAmount(json['total_amount']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

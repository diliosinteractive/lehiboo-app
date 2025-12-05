// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingDtoImpl _$$BookingDtoImplFromJson(Map<String, dynamic> json) =>
    _$BookingDtoImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      slotId: (json['slot_id'] as num).toInt(),
      activityId: (json['activity_id'] as num).toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      status: json['status'] as String?,
      paymentProvider: json['payment_provider'] as String?,
      paymentReference: json['payment_reference'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      activity: json['activity'] == null
          ? null
          : ActivityDto.fromJson(json['activity'] as Map<String, dynamic>),
      slot: json['slot'] == null
          ? null
          : SlotDto.fromJson(json['slot'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BookingDtoImplToJson(_$BookingDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'slot_id': instance.slotId,
      'activity_id': instance.activityId,
      'quantity': instance.quantity,
      'total_price': instance.totalPrice,
      'currency': instance.currency,
      'status': instance.status,
      'payment_provider': instance.paymentProvider,
      'payment_reference': instance.paymentReference,
      'created_at': instance.createdAt?.toIso8601String(),
      'activity': instance.activity,
      'slot': instance.slot,
    };

_$TicketDtoImpl _$$TicketDtoImplFromJson(Map<String, dynamic> json) =>
    _$TicketDtoImpl(
      id: (json['id'] as num).toInt(),
      bookingId: (json['booking_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      slotId: (json['slot_id'] as num).toInt(),
      ticketType: json['ticket_type'] as String?,
      qrCodeData: json['qr_code_data'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$TicketDtoImplToJson(_$TicketDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_id': instance.bookingId,
      'user_id': instance.userId,
      'slot_id': instance.slotId,
      'ticket_type': instance.ticketType,
      'qr_code_data': instance.qrCodeData,
      'status': instance.status,
    };

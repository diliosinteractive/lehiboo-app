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
      tickets: (json['tickets'] as List<dynamic>?)
          ?.map((e) => TicketDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerEmail: json['customer_email'] as String?,
      customerFirstName: json['customer_first_name'] as String?,
      customerLastName: json['customer_last_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
      reference: json['reference'] as String?,
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
      'tickets': instance.tickets,
      'customer_email': instance.customerEmail,
      'customer_first_name': instance.customerFirstName,
      'customer_last_name': instance.customerLastName,
      'customer_phone': instance.customerPhone,
      'reference': instance.reference,
    };

_$TicketDtoImpl _$$TicketDtoImplFromJson(Map<String, dynamic> json) =>
    _$TicketDtoImpl(
      id: json['id'] as String,
      uuid: json['uuid'] as String?,
      bookingId: json['booking_id'] as String,
      eventId: json['event_id'] as String?,
      slotId: json['slot_id'] as String,
      ticketTypeId: json['ticket_type_id'] as String?,
      ticketType: json['ticket_type'] as String?,
      qrCode: json['qr_code'] as String?,
      qrCodeData: json['qr_code_data'] as String?,
      qrSecret: json['qr_secret'] as String?,
      status: json['status'] as String?,
      attendeeFirstName: json['attendee_first_name'] as String?,
      attendeeLastName: json['attendee_last_name'] as String?,
      attendeeEmail: json['attendee_email'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      usedAt: json['used_at'] == null
          ? null
          : DateTime.parse(json['used_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$TicketDtoImplToJson(_$TicketDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'booking_id': instance.bookingId,
      'event_id': instance.eventId,
      'slot_id': instance.slotId,
      'ticket_type_id': instance.ticketTypeId,
      'ticket_type': instance.ticketType,
      'qr_code': instance.qrCode,
      'qr_code_data': instance.qrCodeData,
      'qr_secret': instance.qrSecret,
      'status': instance.status,
      'attendee_first_name': instance.attendeeFirstName,
      'attendee_last_name': instance.attendeeLastName,
      'attendee_email': instance.attendeeEmail,
      'price': instance.price,
      'currency': instance.currency,
      'used_at': instance.usedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$BookingItemDtoImpl _$$BookingItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$BookingItemDtoImpl(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      ticketTypeId: json['ticket_type_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      ticketTypeName: json['ticket_type_name'] as String?,
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$$BookingItemDtoImplToJson(
        _$BookingItemDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_id': instance.bookingId,
      'ticket_type_id': instance.ticketTypeId,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'total_price': instance.totalPrice,
      'ticket_type_name': instance.ticketTypeName,
      'currency': instance.currency,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_api_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateBookingRequestDtoImpl _$$CreateBookingRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateBookingRequestDtoImpl(
      eventId: (json['event_id'] as num).toInt(),
      tickets: (json['tickets'] as List<dynamic>)
          .map((e) =>
              BookingTicketRequestDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      buyerInfo:
          BuyerInfoDto.fromJson(json['buyer_info'] as Map<String, dynamic>),
      couponCode: json['coupon_code'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$CreateBookingRequestDtoImplToJson(
        _$CreateBookingRequestDtoImpl instance) =>
    <String, dynamic>{
      'event_id': instance.eventId,
      'tickets': instance.tickets,
      'buyer_info': instance.buyerInfo,
      'coupon_code': instance.couponCode,
      'notes': instance.notes,
    };

_$BookingTicketRequestDtoImpl _$$BookingTicketRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingTicketRequestDtoImpl(
      ticketTypeId: json['ticket_type_id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      attendees: (json['attendees'] as List<dynamic>?)
          ?.map((e) => AttendeeInfoDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BookingTicketRequestDtoImplToJson(
        _$BookingTicketRequestDtoImpl instance) =>
    <String, dynamic>{
      'ticket_type_id': instance.ticketTypeId,
      'quantity': instance.quantity,
      'attendees': instance.attendees,
    };

_$BuyerInfoDtoImpl _$$BuyerInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$BuyerInfoDtoImpl(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$$BuyerInfoDtoImplToJson(_$BuyerInfoDtoImpl instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
    };

_$AttendeeInfoDtoImpl _$$AttendeeInfoDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AttendeeInfoDtoImpl(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      age: (json['age'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AttendeeInfoDtoImplToJson(
        _$AttendeeInfoDtoImpl instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'age': instance.age,
    };

_$CreateBookingResponseDtoImpl _$$CreateBookingResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateBookingResponseDtoImpl(
      booking: BookingInfoDto.fromJson(json['booking'] as Map<String, dynamic>),
      event:
          BookingEventInfoDto.fromJson(json['event'] as Map<String, dynamic>),
      ticketsSummary: (json['tickets_summary'] as List<dynamic>)
          .map((e) => TicketSummaryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      pricing:
          BookingPricingDto.fromJson(json['pricing'] as Map<String, dynamic>),
      payment: json['payment'] == null
          ? null
          : BookingPaymentDto.fromJson(json['payment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CreateBookingResponseDtoImplToJson(
        _$CreateBookingResponseDtoImpl instance) =>
    <String, dynamic>{
      'booking': instance.booking,
      'event': instance.event,
      'tickets_summary': instance.ticketsSummary,
      'pricing': instance.pricing,
      'payment': instance.payment,
    };

_$BookingInfoDtoImpl _$$BookingInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$BookingInfoDtoImpl(
      id: (json['id'] as num).toInt(),
      reference: json['reference'] as String,
      status: json['status'] as String,
      expiresAt: json['expires_at'] as String?,
    );

Map<String, dynamic> _$$BookingInfoDtoImplToJson(
        _$BookingInfoDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'status': instance.status,
      'expires_at': instance.expiresAt,
    };

_$BookingEventInfoDtoImpl _$$BookingEventInfoDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingEventInfoDtoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      date: json['date'] as String,
      time: json['time'] as String?,
      venue: json['venue'] as String?,
    );

Map<String, dynamic> _$$BookingEventInfoDtoImplToJson(
        _$BookingEventInfoDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date,
      'time': instance.time,
      'venue': instance.venue,
    };

_$TicketSummaryDtoImpl _$$TicketSummaryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TicketSummaryDtoImpl(
      type: json['type'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );

Map<String, dynamic> _$$TicketSummaryDtoImplToJson(
        _$TicketSummaryDtoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'subtotal': instance.subtotal,
    };

_$BookingPricingDtoImpl _$$BookingPricingDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingPricingDtoImpl(
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: json['discount'] == null
          ? null
          : DiscountDto.fromJson(json['discount'] as Map<String, dynamic>),
      fees: (json['fees'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
    );

Map<String, dynamic> _$$BookingPricingDtoImplToJson(
        _$BookingPricingDtoImpl instance) =>
    <String, dynamic>{
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'fees': instance.fees,
      'total': instance.total,
      'currency': instance.currency,
    };

_$DiscountDtoImpl _$$DiscountDtoImplFromJson(Map<String, dynamic> json) =>
    _$DiscountDtoImpl(
      code: json['code'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      value: (json['value'] as num).toInt(),
    );

Map<String, dynamic> _$$DiscountDtoImplToJson(_$DiscountDtoImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'amount': instance.amount,
      'type': instance.type,
      'value': instance.value,
    };

_$BookingPaymentDtoImpl _$$BookingPaymentDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingPaymentDtoImpl(
      required: json['required'] as bool,
      methodsAvailable: (json['methods_available'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      stripe: json['stripe'] == null
          ? null
          : StripePaymentDto.fromJson(json['stripe'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BookingPaymentDtoImplToJson(
        _$BookingPaymentDtoImpl instance) =>
    <String, dynamic>{
      'required': instance.required,
      'methods_available': instance.methodsAvailable,
      'stripe': instance.stripe,
    };

_$StripePaymentDtoImpl _$$StripePaymentDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$StripePaymentDtoImpl(
      paymentIntentId: json['payment_intent_id'] as String,
      clientSecret: json['client_secret'] as String,
      publishableKey: json['publishable_key'] as String,
    );

Map<String, dynamic> _$$StripePaymentDtoImplToJson(
        _$StripePaymentDtoImpl instance) =>
    <String, dynamic>{
      'payment_intent_id': instance.paymentIntentId,
      'client_secret': instance.clientSecret,
      'publishable_key': instance.publishableKey,
    };

_$BookingsListResponseDtoImpl _$$BookingsListResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingsListResponseDtoImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => BookingListItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : MetaInfoDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BookingsListResponseDtoImplToJson(
        _$BookingsListResponseDtoImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

_$MetaInfoDtoImpl _$$MetaInfoDtoImplFromJson(Map<String, dynamic> json) =>
    _$MetaInfoDtoImpl(
      total: (json['total'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      currentPage: (json['current_page'] as num).toInt(),
      lastPage: (json['last_page'] as num).toInt(),
    );

Map<String, dynamic> _$$MetaInfoDtoImplToJson(_$MetaInfoDtoImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'per_page': instance.perPage,
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
    };

_$BookingListItemDtoImpl _$$BookingListItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingListItemDtoImpl(
      id: (json['id'] as num).toInt(),
      uuid: json['uuid'] as String?,
      reference: json['reference'] as String?,
      status: json['status'] as String,
      eventId: (json['event_id'] as num?)?.toInt(),
      slotId: (json['slot_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      eventTitle: json['eventTitle'] as String?,
      eventSlug: json['eventSlug'] as String?,
      eventImage: json['eventImage'] as String?,
      slotDate: json['slotDate'] as String?,
      grandTotal: (json['grandTotal'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      ticketCount: (json['ticketCount'] as num?)?.toInt(),
      customerEmail: json['customer_email'] as String?,
      customerFirstName: json['customer_first_name'] as String?,
      customerLastName: json['customer_last_name'] as String?,
      canCancel: json['can_cancel'] as bool?,
      createdAt: json['created_at'] as String?,
      createdAt2: json['createdAt2'] as String?,
      event: json['event'] == null
          ? null
          : BookingEventDto.fromJson(json['event'] as Map<String, dynamic>),
      slot: json['slot'] == null
          ? null
          : BookingSlotDto.fromJson(json['slot'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BookingListItemDtoImplToJson(
        _$BookingListItemDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'reference': instance.reference,
      'status': instance.status,
      'event_id': instance.eventId,
      'slot_id': instance.slotId,
      'user_id': instance.userId,
      'eventTitle': instance.eventTitle,
      'eventSlug': instance.eventSlug,
      'eventImage': instance.eventImage,
      'slotDate': instance.slotDate,
      'grandTotal': instance.grandTotal,
      'totalAmount': instance.totalAmount,
      'ticketCount': instance.ticketCount,
      'customer_email': instance.customerEmail,
      'customer_first_name': instance.customerFirstName,
      'customer_last_name': instance.customerLastName,
      'can_cancel': instance.canCancel,
      'created_at': instance.createdAt,
      'createdAt2': instance.createdAt2,
      'event': instance.event,
      'slot': instance.slot,
    };

_$BookingEventDtoImpl _$$BookingEventDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingEventDtoImpl(
      id: json['id'] as String?,
      internalId: (json['internal_id'] as num?)?.toInt(),
      uuid: json['uuid'] as String?,
      title: json['title'] as String,
      slug: json['slug'] as String?,
      featuredImage: json['featured_image'] as String?,
      coverImage: json['cover_image'] as String?,
      venueName: json['venue_name'] as String?,
      city: json['city'] as String?,
    );

Map<String, dynamic> _$$BookingEventDtoImplToJson(
        _$BookingEventDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'internal_id': instance.internalId,
      'uuid': instance.uuid,
      'title': instance.title,
      'slug': instance.slug,
      'featured_image': instance.featuredImage,
      'cover_image': instance.coverImage,
      'venue_name': instance.venueName,
      'city': instance.city,
    };

_$BookingSlotDtoImpl _$$BookingSlotDtoImplFromJson(Map<String, dynamic> json) =>
    _$BookingSlotDtoImpl(
      id: json['id'] as String?,
      eventId: (json['event_id'] as num?)?.toInt(),
      slotDate: json['slot_date'] as String?,
      date: json['date'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      startDatetime: json['start_datetime'] as String?,
      startDate: json['startDate'] as String?,
      endDatetime: json['end_datetime'] as String?,
      endDate: json['endDate'] as String?,
    );

Map<String, dynamic> _$$BookingSlotDtoImplToJson(
        _$BookingSlotDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'event_id': instance.eventId,
      'slot_date': instance.slotDate,
      'date': instance.date,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'start_datetime': instance.startDatetime,
      'startDate': instance.startDate,
      'end_datetime': instance.endDatetime,
      'endDate': instance.endDate,
    };

_$TicketsListResponseDtoImpl _$$TicketsListResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TicketsListResponseDtoImpl(
      tickets: (json['tickets'] as List<dynamic>)
          .map((e) => TicketDetailDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$TicketsListResponseDtoImplToJson(
        _$TicketsListResponseDtoImpl instance) =>
    <String, dynamic>{
      'tickets': instance.tickets,
      'count': instance.count,
    };

_$TicketDetailDtoImpl _$$TicketDetailDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TicketDetailDtoImpl(
      id: (json['id'] as num).toInt(),
      ticketNumber: json['ticket_number'] as String,
      status: json['status'] as String,
      statusLabel: json['status_label'] as String,
      qrCode: json['qr_code'] as String,
      ticketType: json['ticket_type'] as String,
      bookingId: (json['booking_id'] as num?)?.toInt(),
      attendee: json['attendee'] == null
          ? null
          : TicketAttendeeDto.fromJson(
              json['attendee'] as Map<String, dynamic>),
      seatInfo: json['seat_info'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      usedAt: json['used_at'] as String?,
      createdAt: json['created_at'] as String?,
      event: TicketEventInfoDto.fromJson(json['event'] as Map<String, dynamic>),
      canDownloadPdf: json['can_download_pdf'] as bool? ?? true,
      instructions: json['instructions'] as String?,
      isUpcoming: json['is_upcoming'] as bool? ?? false,
    );

Map<String, dynamic> _$$TicketDetailDtoImplToJson(
        _$TicketDetailDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticket_number': instance.ticketNumber,
      'status': instance.status,
      'status_label': instance.statusLabel,
      'qr_code': instance.qrCode,
      'ticket_type': instance.ticketType,
      'booking_id': instance.bookingId,
      'attendee': instance.attendee,
      'seat_info': instance.seatInfo,
      'price': instance.price,
      'used_at': instance.usedAt,
      'created_at': instance.createdAt,
      'event': instance.event,
      'can_download_pdf': instance.canDownloadPdf,
      'instructions': instance.instructions,
      'is_upcoming': instance.isUpcoming,
    };

_$TicketAttendeeDtoImpl _$$TicketAttendeeDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TicketAttendeeDtoImpl(
      name: json['name'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$TicketAttendeeDtoImplToJson(
        _$TicketAttendeeDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
    };

_$TicketEventInfoDtoImpl _$$TicketEventInfoDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TicketEventInfoDtoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      date: json['date'] as String,
      time: json['time'] as String?,
      dateEnd: json['date_end'] as String?,
      timeEnd: json['time_end'] as String?,
      venue: json['venue'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      location: json['location'] == null
          ? null
          : TicketLocationDto.fromJson(
              json['location'] as Map<String, dynamic>),
      thumbnail: json['thumbnail'] as String?,
      thumbnailLarge: json['thumbnail_large'] as String?,
    );

Map<String, dynamic> _$$TicketEventInfoDtoImplToJson(
        _$TicketEventInfoDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date,
      'time': instance.time,
      'date_end': instance.dateEnd,
      'time_end': instance.timeEnd,
      'venue': instance.venue,
      'address': instance.address,
      'city': instance.city,
      'location': instance.location,
      'thumbnail': instance.thumbnail,
      'thumbnail_large': instance.thumbnailLarge,
    };

_$TicketLocationDtoImpl _$$TicketLocationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$TicketLocationDtoImpl(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TicketLocationDtoImplToJson(
        _$TicketLocationDtoImpl instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
    };

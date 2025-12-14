// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_availability_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventAvailabilityResponseDtoImpl _$$EventAvailabilityResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EventAvailabilityResponseDtoImpl(
      eventId: (json['event_id'] as num).toInt(),
      calendarType: json['calendar_type'] == null
          ? 'manual'
          : _parseString(json['calendar_type']),
      slots: (json['slots'] as List<dynamic>?)
              ?.map((e) =>
                  AvailabilitySlotDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tickets: (json['tickets'] as List<dynamic>?)
              ?.map((e) =>
                  AvailabilityTicketDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recurrence: json['recurrence'] == null
          ? null
          : RecurrenceDto.fromJson(json['recurrence'] as Map<String, dynamic>),
      bookingSettings: json['booking_settings'] == null
          ? null
          : BookingSettingsDto.fromJson(
              json['booking_settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EventAvailabilityResponseDtoImplToJson(
        _$EventAvailabilityResponseDtoImpl instance) =>
    <String, dynamic>{
      'event_id': instance.eventId,
      'calendar_type': instance.calendarType,
      'slots': instance.slots,
      'tickets': instance.tickets,
      'recurrence': instance.recurrence,
      'booking_settings': instance.bookingSettings,
    };

_$AvailabilitySlotDtoImpl _$$AvailabilitySlotDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AvailabilitySlotDtoImpl(
      id: json['id'] as String,
      date: _parseString(json['date']),
      startTime: _parseStringOrNull(json['start_time']),
      endTime: _parseStringOrNull(json['end_time']),
      spotsTotal: _parseIntOrNull(json['spots_total']),
      spotsRemaining: _parseIntOrNull(json['spots_remaining']),
      isAvailable: json['is_available'] == null
          ? true
          : _parseBool(json['is_available']),
    );

Map<String, dynamic> _$$AvailabilitySlotDtoImplToJson(
        _$AvailabilitySlotDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'spots_total': instance.spotsTotal,
      'spots_remaining': instance.spotsRemaining,
      'is_available': instance.isAvailable,
    };

_$AvailabilityTicketDtoImpl _$$AvailabilityTicketDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AvailabilityTicketDtoImpl(
      id: json['id'] as String,
      name: json['name'] == null ? '' : _parseString(json['name']),
      price: json['price'] == null ? 0 : _parseDouble(json['price']),
      currency: json['currency'] as String? ?? 'EUR',
      description: _parseStringOrNull(json['description']),
      minPerBooking: json['min_per_booking'] == null
          ? 1
          : _parseInt(json['min_per_booking']),
      maxPerBooking: json['max_per_booking'] == null
          ? 10
          : _parseInt(json['max_per_booking']),
      quantityTotal: _parseIntOrNull(json['quantity_total']),
      quantityRemaining: _parseIntOrNull(json['quantity_remaining']),
      available:
          json['available'] == null ? true : _parseBool(json['available']),
      personTypes: (json['person_types'] as List<dynamic>?)
              ?.map((e) => PersonTypeDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$AvailabilityTicketDtoImplToJson(
        _$AvailabilityTicketDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'currency': instance.currency,
      'description': instance.description,
      'min_per_booking': instance.minPerBooking,
      'max_per_booking': instance.maxPerBooking,
      'quantity_total': instance.quantityTotal,
      'quantity_remaining': instance.quantityRemaining,
      'available': instance.available,
      'person_types': instance.personTypes,
    };

_$PersonTypeDtoImpl _$$PersonTypeDtoImplFromJson(Map<String, dynamic> json) =>
    _$PersonTypeDtoImpl(
      id: json['id'] as String,
      name: json['name'] == null ? '' : _parseString(json['name']),
      price: json['price'] == null ? 0 : _parseDouble(json['price']),
      min: json['min'] == null ? 0 : _parseInt(json['min']),
      max: json['max'] == null ? 10 : _parseInt(json['max']),
    );

Map<String, dynamic> _$$PersonTypeDtoImplToJson(_$PersonTypeDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'min': instance.min,
      'max': instance.max,
    };

_$RecurrenceDtoImpl _$$RecurrenceDtoImplFromJson(Map<String, dynamic> json) =>
    _$RecurrenceDtoImpl(
      frequency: json['frequency'] == null
          ? 'weekly'
          : _parseString(json['frequency']),
      days:
          (json['days'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      startDate: _parseStringOrNull(json['start_date']),
      endDate: _parseStringOrNull(json['end_date']),
      defaultStartTime: _parseStringOrNull(json['default_start_time']),
      defaultEndTime: _parseStringOrNull(json['default_end_time']),
    );

Map<String, dynamic> _$$RecurrenceDtoImplToJson(_$RecurrenceDtoImpl instance) =>
    <String, dynamic>{
      'frequency': instance.frequency,
      'days': instance.days,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'default_start_time': instance.defaultStartTime,
      'default_end_time': instance.defaultEndTime,
    };

_$BookingSettingsDtoImpl _$$BookingSettingsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingSettingsDtoImpl(
      bookBeforeMinutes: json['book_before_minutes'] == null
          ? 0
          : _parseInt(json['book_before_minutes']),
      maxTicketsPerBooking: json['max_tickets_per_booking'] == null
          ? 10
          : _parseInt(json['max_tickets_per_booking']),
      requiresApproval: json['requires_approval'] == null
          ? false
          : _parseBool(json['requires_approval']),
    );

Map<String, dynamic> _$$BookingSettingsDtoImplToJson(
        _$BookingSettingsDtoImpl instance) =>
    <String, dynamic>{
      'book_before_minutes': instance.bookBeforeMinutes,
      'max_tickets_per_booking': instance.maxTicketsPerBooking,
      'requires_approval': instance.requiresApproval,
    };

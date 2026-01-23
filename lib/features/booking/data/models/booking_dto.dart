import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lehiboo/data/models/activity_dto.dart';

part 'booking_dto.freezed.dart';
part 'booking_dto.g.dart';

@freezed
class BookingDto with _$BookingDto {
  const factory BookingDto({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'slot_id') required int slotId,
    @JsonKey(name: 'activity_id') required int activityId,
    int? quantity,
    @JsonKey(name: 'total_price') double? totalPrice,
    String? currency,
    String? status,
    @JsonKey(name: 'payment_provider') String? paymentProvider,
    @JsonKey(name: 'payment_reference') String? paymentReference,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Nested objects
    ActivityDto? activity,
    SlotDto? slot,
    List<TicketDto>? tickets,
    // Customer info
    @JsonKey(name: 'customer_email') String? customerEmail,
    @JsonKey(name: 'customer_first_name') String? customerFirstName,
    @JsonKey(name: 'customer_last_name') String? customerLastName,
    @JsonKey(name: 'customer_phone') String? customerPhone,
    // Reference
    String? reference,
  }) = _BookingDto;

  factory BookingDto.fromJson(Map<String, dynamic> json) => _$BookingDtoFromJson(json);
}

@freezed
class TicketDto with _$TicketDto {
  const factory TicketDto({
    required String id,
    String? uuid,
    @JsonKey(name: 'booking_id') required String bookingId,
    @JsonKey(name: 'event_id') String? eventId,
    @JsonKey(name: 'slot_id') required String slotId,
    @JsonKey(name: 'ticket_type_id') String? ticketTypeId,
    @JsonKey(name: 'ticket_type') String? ticketType,
    @JsonKey(name: 'qr_code') String? qrCode,
    @JsonKey(name: 'qr_code_data') String? qrCodeData,
    @JsonKey(name: 'qr_secret') String? qrSecret,
    String? status,
    // Attendee info
    @JsonKey(name: 'attendee_first_name') String? attendeeFirstName,
    @JsonKey(name: 'attendee_last_name') String? attendeeLastName,
    @JsonKey(name: 'attendee_email') String? attendeeEmail,
    // Pricing
    double? price,
    String? currency,
    // Timestamps
    @JsonKey(name: 'used_at') DateTime? usedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _TicketDto;

  factory TicketDto.fromJson(Map<String, dynamic> json) => _$TicketDtoFromJson(json);
}

@freezed
class BookingItemDto with _$BookingItemDto {
  const factory BookingItemDto({
    required String id,
    @JsonKey(name: 'booking_id') required String bookingId,
    @JsonKey(name: 'ticket_type_id') required String ticketTypeId,
    required int quantity,
    @JsonKey(name: 'unit_price') required double unitPrice,
    @JsonKey(name: 'total_price') required double totalPrice,
    @JsonKey(name: 'ticket_type_name') String? ticketTypeName,
    String? currency,
  }) = _BookingItemDto;

  factory BookingItemDto.fromJson(Map<String, dynamic> json) => _$BookingItemDtoFromJson(json);
}

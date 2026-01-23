import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_api_dto.freezed.dart';
part 'booking_api_dto.g.dart';

// Request DTOs
@freezed
class CreateBookingRequestDto with _$CreateBookingRequestDto {
  const factory CreateBookingRequestDto({
    @JsonKey(name: 'event_id') required int eventId,
    required List<BookingTicketRequestDto> tickets,
    @JsonKey(name: 'buyer_info') required BuyerInfoDto buyerInfo,
    @JsonKey(name: 'coupon_code') String? couponCode,
    String? notes,
  }) = _CreateBookingRequestDto;

  factory CreateBookingRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingRequestDtoFromJson(json);
}

@freezed
class BookingTicketRequestDto with _$BookingTicketRequestDto {
  const factory BookingTicketRequestDto({
    @JsonKey(name: 'ticket_type_id') required String ticketTypeId,
    required int quantity,
    List<AttendeeInfoDto>? attendees,
  }) = _BookingTicketRequestDto;

  factory BookingTicketRequestDto.fromJson(Map<String, dynamic> json) =>
      _$BookingTicketRequestDtoFromJson(json);
}

@freezed
class BuyerInfoDto with _$BuyerInfoDto {
  const factory BuyerInfoDto({
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    required String email,
    String? phone,
  }) = _BuyerInfoDto;

  factory BuyerInfoDto.fromJson(Map<String, dynamic> json) =>
      _$BuyerInfoDtoFromJson(json);
}

@freezed
class AttendeeInfoDto with _$AttendeeInfoDto {
  const factory AttendeeInfoDto({
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    int? age,
  }) = _AttendeeInfoDto;

  factory AttendeeInfoDto.fromJson(Map<String, dynamic> json) =>
      _$AttendeeInfoDtoFromJson(json);
}

// Response DTOs
@freezed
class CreateBookingResponseDto with _$CreateBookingResponseDto {
  const factory CreateBookingResponseDto({
    required BookingInfoDto booking,
    required BookingEventInfoDto event,
    @JsonKey(name: 'tickets_summary') required List<TicketSummaryDto> ticketsSummary,
    required BookingPricingDto pricing,
    BookingPaymentDto? payment,
  }) = _CreateBookingResponseDto;

  factory CreateBookingResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingResponseDtoFromJson(json);
}

@freezed
class BookingInfoDto with _$BookingInfoDto {
  const factory BookingInfoDto({
    required int id,
    required String reference,
    required String status,
    @JsonKey(name: 'expires_at') String? expiresAt,
  }) = _BookingInfoDto;

  factory BookingInfoDto.fromJson(Map<String, dynamic> json) =>
      _$BookingInfoDtoFromJson(json);
}

@freezed
class BookingEventInfoDto with _$BookingEventInfoDto {
  const factory BookingEventInfoDto({
    required int id,
    required String title,
    required String date,
    String? time,
    String? venue,
  }) = _BookingEventInfoDto;

  factory BookingEventInfoDto.fromJson(Map<String, dynamic> json) =>
      _$BookingEventInfoDtoFromJson(json);
}

@freezed
class TicketSummaryDto with _$TicketSummaryDto {
  const factory TicketSummaryDto({
    required String type,
    required int quantity,
    @JsonKey(name: 'unit_price') required double unitPrice,
    required double subtotal,
  }) = _TicketSummaryDto;

  factory TicketSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$TicketSummaryDtoFromJson(json);
}

@freezed
class BookingPricingDto with _$BookingPricingDto {
  const factory BookingPricingDto({
    required double subtotal,
    DiscountDto? discount,
    @Default(0.0) double fees,
    required double total,
    @Default('EUR') String currency,
  }) = _BookingPricingDto;

  factory BookingPricingDto.fromJson(Map<String, dynamic> json) =>
      _$BookingPricingDtoFromJson(json);
}

@freezed
class DiscountDto with _$DiscountDto {
  const factory DiscountDto({
    required String code,
    required double amount,
    required String type,
    required int value,
  }) = _DiscountDto;

  factory DiscountDto.fromJson(Map<String, dynamic> json) =>
      _$DiscountDtoFromJson(json);
}

@freezed
class BookingPaymentDto with _$BookingPaymentDto {
  const factory BookingPaymentDto({
    required bool required,
    @JsonKey(name: 'methods_available') required List<String> methodsAvailable,
    StripePaymentDto? stripe,
  }) = _BookingPaymentDto;

  factory BookingPaymentDto.fromJson(Map<String, dynamic> json) =>
      _$BookingPaymentDtoFromJson(json);
}

@freezed
class StripePaymentDto with _$StripePaymentDto {
  const factory StripePaymentDto({
    @JsonKey(name: 'payment_intent_id') required String paymentIntentId,
    @JsonKey(name: 'client_secret') required String clientSecret,
    @JsonKey(name: 'publishable_key') required String publishableKey,
  }) = _StripePaymentDto;

  factory StripePaymentDto.fromJson(Map<String, dynamic> json) =>
      _$StripePaymentDtoFromJson(json);
}

// List Bookings Response - Structure réelle de l'API Laravel
@freezed
class BookingsListResponseDto with _$BookingsListResponseDto {
  const factory BookingsListResponseDto({
    required List<BookingListItemDto> data,
    MetaInfoDto? meta,
  }) = _BookingsListResponseDto;

  factory BookingsListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$BookingsListResponseDtoFromJson(json);
}

@freezed
class MetaInfoDto with _$MetaInfoDto {
  const factory MetaInfoDto({
    required int total,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'last_page') required int lastPage,
  }) = _MetaInfoDto;

  factory MetaInfoDto.fromJson(Map<String, dynamic> json) =>
      _$MetaInfoDtoFromJson(json);
}

@freezed
class BookingListItemDto with _$BookingListItemDto {
  const factory BookingListItemDto({
    required int id,
    String? uuid,
    String? reference,
    required String status,
    @JsonKey(name: 'event_id') int? eventId,
    @JsonKey(name: 'slot_id') int? slotId,
    @JsonKey(name: 'user_id') int? userId,
    // Convenience fields (camelCase from API)
    String? eventTitle,
    String? eventSlug,
    String? eventImage,
    String? slotDate,
    double? grandTotal,
    double? totalAmount,
    int? ticketCount,
    @JsonKey(name: 'customer_email') String? customerEmail,
    @JsonKey(name: 'customer_first_name') String? customerFirstName,
    @JsonKey(name: 'customer_last_name') String? customerLastName,
    @JsonKey(name: 'can_cancel') bool? canCancel,
    @JsonKey(name: 'created_at') String? createdAt,
    String? createdAt2,
    // Relations loaded by API
    BookingEventDto? event,
    BookingSlotDto? slot,
  }) = _BookingListItemDto;

  factory BookingListItemDto.fromJson(Map<String, dynamic> json) =>
      _$BookingListItemDtoFromJson(json);
}

@freezed
class BookingEventDto with _$BookingEventDto {
  const factory BookingEventDto({
    String? id, // UUID string
    @JsonKey(name: 'internal_id') int? internalId,
    String? uuid,
    required String title,
    String? slug,
    @JsonKey(name: 'featured_image') String? featuredImage,
    @JsonKey(name: 'cover_image') String? coverImage,
    @JsonKey(name: 'venue_name') String? venueName,
    String? city,
  }) = _BookingEventDto;

  factory BookingEventDto.fromJson(Map<String, dynamic> json) =>
      _$BookingEventDtoFromJson(json);
}

@freezed
class BookingSlotDto with _$BookingSlotDto {
  const factory BookingSlotDto({
    String? id, // UUID string
    @JsonKey(name: 'event_id') int? eventId,
    @JsonKey(name: 'slot_date') String? slotDate,
    String? date,
    @JsonKey(name: 'start_time') String? startTime,
    @JsonKey(name: 'end_time') String? endTime,
    @JsonKey(name: 'start_datetime') String? startDatetime,
    String? startDate,
    @JsonKey(name: 'end_datetime') String? endDatetime,
    String? endDate,
  }) = _BookingSlotDto;

  factory BookingSlotDto.fromJson(Map<String, dynamic> json) =>
      _$BookingSlotDtoFromJson(json);
}

// Tickets Response
@freezed
class TicketsListResponseDto with _$TicketsListResponseDto {
  const factory TicketsListResponseDto({
    required List<TicketDetailDto> tickets,
    required int count,
  }) = _TicketsListResponseDto;

  factory TicketsListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TicketsListResponseDtoFromJson(json);
}

@freezed
class TicketDetailDto with _$TicketDetailDto {
  const factory TicketDetailDto({
    required int id,
    @JsonKey(name: 'ticket_number') required String ticketNumber,
    required String status,
    @JsonKey(name: 'status_label') required String statusLabel,
    @JsonKey(name: 'qr_code') required String qrCode,
    @JsonKey(name: 'ticket_type') required String ticketType,
    @JsonKey(name: 'booking_id') int? bookingId,
    TicketAttendeeDto? attendee,
    @JsonKey(name: 'seat_info') String? seatInfo,
    double? price,
    @JsonKey(name: 'used_at') String? usedAt,
    @JsonKey(name: 'created_at') String? createdAt,
    required TicketEventInfoDto event,
    @JsonKey(name: 'can_download_pdf') @Default(true) bool canDownloadPdf,
    String? instructions,
    @JsonKey(name: 'is_upcoming') @Default(false) bool isUpcoming,
  }) = _TicketDetailDto;

  factory TicketDetailDto.fromJson(Map<String, dynamic> json) =>
      _$TicketDetailDtoFromJson(json);
}

@freezed
class TicketAttendeeDto with _$TicketAttendeeDto {
  const factory TicketAttendeeDto({
    required String name,
    String? email,
  }) = _TicketAttendeeDto;

  factory TicketAttendeeDto.fromJson(Map<String, dynamic> json) =>
      _$TicketAttendeeDtoFromJson(json);
}

@freezed
class TicketEventInfoDto with _$TicketEventInfoDto {
  const factory TicketEventInfoDto({
    required int id,
    required String title,
    required String date,
    String? time,
    @JsonKey(name: 'date_end') String? dateEnd,
    @JsonKey(name: 'time_end') String? timeEnd,
    String? venue,
    String? address,
    String? city,
    TicketLocationDto? location,
    String? thumbnail,
    @JsonKey(name: 'thumbnail_large') String? thumbnailLarge,
  }) = _TicketEventInfoDto;

  factory TicketEventInfoDto.fromJson(Map<String, dynamic> json) =>
      _$TicketEventInfoDtoFromJson(json);
}

@freezed
class TicketLocationDto with _$TicketLocationDto {
  const factory TicketLocationDto({
    double? lat,
    double? lng,
  }) = _TicketLocationDto;

  factory TicketLocationDto.fromJson(Map<String, dynamic> json) =>
      _$TicketLocationDtoFromJson(json);
}

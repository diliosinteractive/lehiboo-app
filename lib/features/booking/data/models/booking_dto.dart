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
  }) = _BookingDto;

  factory BookingDto.fromJson(Map<String, dynamic> json) => _$BookingDtoFromJson(json);
}

@freezed
class TicketDto with _$TicketDto {
  const factory TicketDto({
    required int id,
    @JsonKey(name: 'booking_id') required int bookingId,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'slot_id') required int slotId,
    @JsonKey(name: 'ticket_type') String? ticketType,
    @JsonKey(name: 'qr_code_data') String? qrCodeData,
    String? status,
  }) = _TicketDto;

  factory TicketDto.fromJson(Map<String, dynamic> json) => _$TicketDtoFromJson(json);
}

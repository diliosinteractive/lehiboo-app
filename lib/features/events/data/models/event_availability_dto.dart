import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_availability_dto.freezed.dart';
part 'event_availability_dto.g.dart';

@freezed
class EventAvailabilityResponseDto with _$EventAvailabilityResponseDto {
  const factory EventAvailabilityResponseDto({
    @JsonKey(name: 'event_id', fromJson: _parseInt) @Default(0) int eventId,
    @JsonKey(name: 'calendar_type', fromJson: _parseString) @Default('manual') String calendarType,
    @Default([]) List<AvailabilitySlotDto> slots,
    @Default([]) List<AvailabilityTicketDto> tickets,
    RecurrenceDto? recurrence,
    @JsonKey(name: 'booking_settings') BookingSettingsDto? bookingSettings,
  }) = _EventAvailabilityResponseDto;

  factory EventAvailabilityResponseDto.fromJson(Map<String, dynamic> json) =>
      _$EventAvailabilityResponseDtoFromJson(json);
}

@freezed
class AvailabilitySlotDto with _$AvailabilitySlotDto {
  const factory AvailabilitySlotDto({
    required String id,
    @JsonKey(fromJson: _parseString) required String date,
    @JsonKey(name: 'start_time', fromJson: _parseStringOrNull) String? startTime,
    @JsonKey(name: 'end_time', fromJson: _parseStringOrNull) String? endTime,
    @JsonKey(name: 'spots_total', fromJson: _parseIntOrNull) int? spotsTotal,
    @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull) int? spotsRemaining,
    @JsonKey(name: 'is_available', fromJson: _parseBool) @Default(true) bool isAvailable,
  }) = _AvailabilitySlotDto;

  factory AvailabilitySlotDto.fromJson(Map<String, dynamic> json) =>
      _$AvailabilitySlotDtoFromJson(json);
}

@freezed
class AvailabilityTicketDto with _$AvailabilityTicketDto {
  const factory AvailabilityTicketDto({
    required String id,
    @JsonKey(fromJson: _parseString) @Default('') String name,
    @JsonKey(fromJson: _parseDouble) @Default(0) double price,
    @Default('EUR') String currency,
    @JsonKey(fromJson: _parseStringOrNull) String? description,
    @JsonKey(name: 'min_per_booking', fromJson: _parseInt) @Default(1) int minPerBooking,
    @JsonKey(name: 'max_per_booking', fromJson: _parseInt) @Default(10) int maxPerBooking,
    @JsonKey(name: 'quantity_total', fromJson: _parseIntOrNull) int? quantityTotal,
    @JsonKey(name: 'quantity_remaining', fromJson: _parseIntOrNull) int? quantityRemaining,
    @JsonKey(fromJson: _parseBool) @Default(true) bool available,
    @JsonKey(name: 'person_types') @Default([]) List<PersonTypeDto> personTypes,
  }) = _AvailabilityTicketDto;

  factory AvailabilityTicketDto.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityTicketDtoFromJson(json);
}

@freezed
class PersonTypeDto with _$PersonTypeDto {
  const factory PersonTypeDto({
    required String id,
    @JsonKey(fromJson: _parseString) @Default('') String name,
    @JsonKey(fromJson: _parseDouble) @Default(0) double price,
    @JsonKey(fromJson: _parseInt) @Default(0) int min,
    @JsonKey(fromJson: _parseInt) @Default(10) int max,
  }) = _PersonTypeDto;

  factory PersonTypeDto.fromJson(Map<String, dynamic> json) =>
      _$PersonTypeDtoFromJson(json);
}

@freezed
class RecurrenceDto with _$RecurrenceDto {
  const factory RecurrenceDto({
    @JsonKey(fromJson: _parseString) @Default('weekly') String frequency,
    @Default([]) List<String> days,
    @JsonKey(name: 'start_date', fromJson: _parseStringOrNull) String? startDate,
    @JsonKey(name: 'end_date', fromJson: _parseStringOrNull) String? endDate,
    @JsonKey(name: 'default_start_time', fromJson: _parseStringOrNull) String? defaultStartTime,
    @JsonKey(name: 'default_end_time', fromJson: _parseStringOrNull) String? defaultEndTime,
  }) = _RecurrenceDto;

  factory RecurrenceDto.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceDtoFromJson(json);
}

@freezed
class BookingSettingsDto with _$BookingSettingsDto {
  const factory BookingSettingsDto({
    @JsonKey(name: 'book_before_minutes', fromJson: _parseInt) @Default(0) int bookBeforeMinutes,
    @JsonKey(name: 'max_tickets_per_booking', fromJson: _parseInt) @Default(10) int maxTicketsPerBooking,
    @JsonKey(name: 'requires_approval', fromJson: _parseBool) @Default(false) bool requiresApproval,
  }) = _BookingSettingsDto;

  factory BookingSettingsDto.fromJson(Map<String, dynamic> json) =>
      _$BookingSettingsDtoFromJson(json);
}

// Parsing helpers
String _parseString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

String? _parseStringOrNull(dynamic value) {
  if (value == null) return null;
  if (value is bool) return null;
  if (value is String) return value.isEmpty ? null : value;
  return value.toString();
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

int? _parseIntOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}

double _parseDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

bool _parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) return value.toLowerCase() == 'true' || value == '1';
  return false;
}

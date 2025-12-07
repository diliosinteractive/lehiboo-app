import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_dto.freezed.dart';
part 'event_dto.g.dart';

@freezed
class EventDto with _$EventDto {
  const factory EventDto({
    required int id,
    required String title,
    required String slug,
    String? excerpt,
    @JsonKey(name: 'featured_image', fromJson: _parseImage) EventImageDto? featuredImage,
    EventCategoryDto? category,
    EventDatesDto? dates,
    EventLocationDto? location,
    EventPricingDto? pricing,
    EventAvailabilityDto? availability,
    dynamic ratings,
    EventOrganizerDto? organizer,
    List<String>? tags,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
  }) = _EventDto;

  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);
}

/// Parse featured_image which can be either a String URL or an object with sizes
EventImageDto? _parseImage(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    // If it's a direct URL string, use it for all sizes
    return EventImageDto(
      thumbnail: value,
      medium: value,
      large: value,
      full: value,
    );
  }
  if (value is Map<String, dynamic>) {
    return EventImageDto.fromJson(value);
  }
  return null;
}

@freezed
class EventImageDto with _$EventImageDto {
  const factory EventImageDto({
    String? thumbnail,
    String? medium,
    String? large,
    String? full,
  }) = _EventImageDto;

  factory EventImageDto.fromJson(Map<String, dynamic> json) =>
      _$EventImageDtoFromJson(json);
}

@freezed
class EventDatesDto with _$EventDatesDto {
  const factory EventDatesDto({
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'end_date') String? endDate,
    @JsonKey(name: 'start_time') String? startTime,
    @JsonKey(name: 'end_time') String? endTime,
    String? display,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'is_recurring') @Default(false) bool isRecurring,
  }) = _EventDatesDto;

  factory EventDatesDto.fromJson(Map<String, dynamic> json) =>
      _$EventDatesDtoFromJson(json);
}

@freezed
class EventPricingDto with _$EventPricingDto {
  const factory EventPricingDto({
    @JsonKey(name: 'is_free') @Default(false) bool isFree,
    @Default(0) double min,
    @Default(0) double max,
    @Default('EUR') String currency,
    String? display,
  }) = _EventPricingDto;

  factory EventPricingDto.fromJson(Map<String, dynamic> json) =>
      _$EventPricingDtoFromJson(json);
}

@freezed
class EventAvailabilityDto with _$EventAvailabilityDto {
  const factory EventAvailabilityDto({
    String? status,
    @JsonKey(name: 'total_capacity') int? totalCapacity,
    @JsonKey(name: 'spots_remaining') int? spotsRemaining,
    @JsonKey(name: 'percentage_filled') int? percentageFilled,
  }) = _EventAvailabilityDto;

  factory EventAvailabilityDto.fromJson(Map<String, dynamic> json) =>
      _$EventAvailabilityDtoFromJson(json);
}

@freezed
class EventCategoryDto with _$EventCategoryDto {
  const factory EventCategoryDto({
    required int id,
    required String name,
    required String slug,
    String? description,
    String? icon,
    @JsonKey(name: 'event_count') int? eventCount,
  }) = _EventCategoryDto;

  factory EventCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$EventCategoryDtoFromJson(json);
}

@freezed
class EventPriceDto with _$EventPriceDto {
  const factory EventPriceDto({
    @JsonKey(name: 'is_free') @Default(false) bool isFree,
    double? min,
    double? max,
    @Default('EUR') String currency,
  }) = _EventPriceDto;

  factory EventPriceDto.fromJson(Map<String, dynamic> json) =>
      _$EventPriceDtoFromJson(json);
}

@freezed
class EventLocationDto with _$EventLocationDto {
  const factory EventLocationDto({
    @JsonKey(name: 'venue_name', fromJson: _parseStringOrNull) String? venueName,
    @JsonKey(fromJson: _parseStringOrNull) String? address,
    @JsonKey(fromJson: _parseStringOrNull) String? city,
    @JsonKey(fromJson: _parseDoubleOrNull) double? lat,
    @JsonKey(fromJson: _parseDoubleOrNull) double? lng,
  }) = _EventLocationDto;

  factory EventLocationDto.fromJson(Map<String, dynamic> json) =>
      _$EventLocationDtoFromJson(json);
}

/// Parse a value that might be String, Map, or null to String?
String? _parseStringOrNull(dynamic value) {
  if (value == null) return null;
  if (value is String) return value.isEmpty ? null : value;
  if (value is Map) {
    // If it's an object with a 'name' field, extract it
    return value['name']?.toString();
  }
  return value.toString();
}

/// Parse a value that might be double, int, or null to double?
double? _parseDoubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

@freezed
class EventOrganizerDto with _$EventOrganizerDto {
  const factory EventOrganizerDto({
    required int id,
    required String name,
    String? avatar,
  }) = _EventOrganizerDto;

  factory EventOrganizerDto.fromJson(Map<String, dynamic> json) =>
      _$EventOrganizerDtoFromJson(json);
}

@freezed
class EventCapacityDto with _$EventCapacityDto {
  const factory EventCapacityDto({
    int? total,
    int? available,
  }) = _EventCapacityDto;

  factory EventCapacityDto.fromJson(Map<String, dynamic> json) =>
      _$EventCapacityDtoFromJson(json);
}

@freezed
class EventsResponseDto with _$EventsResponseDto {
  const factory EventsResponseDto({
    required List<EventDto> events,
    required PaginationDto pagination,
    @JsonKey(name: 'filters_applied', fromJson: _parseFiltersApplied) dynamic filtersApplied,
  }) = _EventsResponseDto;

  factory EventsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$EventsResponseDtoFromJson(json);
}

// Handle filters_applied being either [] or {} from API
Map<String, dynamic>? _parseFiltersApplied(dynamic value) {
  if (value == null || value is List) return null;
  if (value is Map<String, dynamic>) return value;
  return null;
}

@freezed
class PaginationDto with _$PaginationDto {
  const factory PaginationDto({
    @JsonKey(name: 'current_page') required int currentPage,
    @JsonKey(name: 'per_page') required int perPage,
    @JsonKey(name: 'total_items') required int totalItems,
    @JsonKey(name: 'total_pages') required int totalPages,
    @JsonKey(name: 'has_next') @Default(false) bool hasNext,
    @JsonKey(name: 'has_prev') @Default(false) bool hasPrev,
  }) = _PaginationDto;

  factory PaginationDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationDtoFromJson(json);
}

@freezed
class FiltersResponseDto with _$FiltersResponseDto {
  const factory FiltersResponseDto({
    required List<EventCategoryDto> categories,
    required List<ThematiqueDto> thematiques,
    required List<String> cities,
    @JsonKey(name: 'price_range') required PriceRangeDto priceRange,
    @JsonKey(name: 'sort_options') required List<SortOptionDto> sortOptions,
    @JsonKey(name: 'additional_filters') List<AdditionalFilterDto>? additionalFilters,
  }) = _FiltersResponseDto;

  factory FiltersResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FiltersResponseDtoFromJson(json);
}

@freezed
class ThematiqueDto with _$ThematiqueDto {
  const factory ThematiqueDto({
    required int id,
    required String name,
    required String slug,
    @JsonKey(name: 'event_count') int? eventCount,
  }) = _ThematiqueDto;

  factory ThematiqueDto.fromJson(Map<String, dynamic> json) =>
      _$ThematiqueDtoFromJson(json);
}

@freezed
class PriceRangeDto with _$PriceRangeDto {
  const factory PriceRangeDto({
    required double min,
    required double max,
  }) = _PriceRangeDto;

  factory PriceRangeDto.fromJson(Map<String, dynamic> json) =>
      _$PriceRangeDtoFromJson(json);
}

@freezed
class SortOptionDto with _$SortOptionDto {
  const factory SortOptionDto({
    required String value,
    required String label,
  }) = _SortOptionDto;

  factory SortOptionDto.fromJson(Map<String, dynamic> json) =>
      _$SortOptionDtoFromJson(json);
}

@freezed
class AdditionalFilterDto with _$AdditionalFilterDto {
  const factory AdditionalFilterDto({
    required String key,
    required String label,
    required String type,
  }) = _AdditionalFilterDto;

  factory AdditionalFilterDto.fromJson(Map<String, dynamic> json) =>
      _$AdditionalFilterDtoFromJson(json);
}

@freezed
class CityDto with _$CityDto {
  const factory CityDto({
    required int id,
    required String name,
    required String slug,
    @JsonKey(name: 'parent_id') int? parentId,
    @JsonKey(name: 'event_count') int? eventCount,
  }) = _CityDto;

  factory CityDto.fromJson(Map<String, dynamic> json) =>
      _$CityDtoFromJson(json);
}

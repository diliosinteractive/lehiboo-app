import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_dto.freezed.dart';
part 'event_dto.g.dart';

@freezed
class EventDto with _$EventDto {
  const factory EventDto({
    required int id,
    @JsonKey(fromJson: _parseHtmlString) required String title,
    @JsonKey(fromJson: _parseHtmlString) required String slug,
    @JsonKey(fromJson: _parseHtmlString) String? excerpt,
    @JsonKey(fromJson: _parseHtmlString) String? content, // Full HTML description
    @JsonKey(name: 'featured_image', fromJson: _parseImage) EventImageDto? featuredImage,
    @JsonKey(fromJson: _parseStringOrNull) String? thumbnail, // Alternative image field from organizer events API
    @JsonKey(fromJson: _parseGallery) List<String>? gallery, // Image gallery URLs
    EventCategoryDto? category,
    ThematiqueDto? thematique, // Main thematique
    EventDatesDto? dates,
    EventLocationDto? location,
    EventPricingDto? pricing,
    EventAvailabilityDto? availability,
    dynamic ratings,
    EventOrganizerDto? organizer,
    @JsonKey(fromJson: _parseStringList) List<String>? tags,
    // New fields for V2 API
    @JsonKey(name: 'ticket_types') List<dynamic>? ticketTypes,
    List<dynamic>? tickets,
    @JsonKey(name: 'time_slots', fromJson: _parseMapOrNull) Map<String, dynamic>? timeSlots,
    @JsonKey(fromJson: _parseMapOrNull) Map<String, dynamic>? calendar,
    @JsonKey(fromJson: _parseMapOrNull) Map<String, dynamic>? recurrence,
    @JsonKey(name: 'extra_services') List<dynamic>? extraServices,
    List<dynamic>? coupons,
    @JsonKey(name: 'seat_config', fromJson: _parseMapOrNull) Map<String, dynamic>? seatConfig,
    @JsonKey(name: 'external_booking', fromJson: _parseMapOrNull) Map<String, dynamic>? externalBooking,
    @JsonKey(name: 'event_type', fromJson: _parseMapOrNull) Map<String, dynamic>? eventType,
    @JsonKey(name: 'target_audience') List<dynamic>? targetAudience,
    
    // Rich Content V2
    @JsonKey(name: 'location_details', fromJson: _parseMapOrNull) Map<String, dynamic>? locationDetails,
    @JsonKey(name: 'coorganizers') List<CoOrganizerDto>? coOrganizers,
    @JsonKey(name: 'social_media', fromJson: _parseMapOrNull) Map<String, dynamic>? socialMedia,

    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
  }) = _EventDto;

  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);
}

/// Parse gallery which can be a list of strings or list of objects
List<String>? _parseGallery(dynamic value) {
  if (value == null) return null;
  if (value is List) {
    return value.map((item) {
      if (item is String) return item;
      if (item is Map) return item['url']?.toString() ?? item['full']?.toString() ?? '';
      return '';
    }).where((s) => s.isNotEmpty).toList();
  }
  return null;
}

EventImageDto? _parseImage(dynamic value) {
  if (value == null) return null;
  if (value is String) {
    if (value.isEmpty) return null;
    // If it's a direct URL string, use it for all sizes
    return EventImageDto(
      thumbnail: value,
      medium: value,
      large: value,
      full: value,
    );
  }
  if (value is Map) {
    // Sanitize the map to ensure we don't pass booleans to fromJson
    // which would cause "type 'bool' is not a subtype of type 'String?'"
    final safeMap = <String, dynamic>{};
    
    // Helper to safely get string
    String? getSafeString(dynamic v) {
      if (v is String && v.isNotEmpty) return v;
      if (v is int) return null;
      if (v is bool) return null;
      return null;
    }

    safeMap['thumbnail'] = getSafeString(value['thumbnail']);
    safeMap['medium'] = getSafeString(value['medium']);
    safeMap['large'] = getSafeString(value['large']);
    safeMap['full'] = getSafeString(value['full']);

    // Remove null keys to let Freezed handle them (though we put nulls above, handled by fromJson?)
    // Actually EventImageDto.fromJson handles explicit nulls fine for nullable fields.
    // The issue was non-nulls being WRONG types.
    
    return EventImageDto.fromJson(safeMap);
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
    @JsonKey(name: 'start_date', fromJson: _parseStringOrNull) String? startDate,
    @JsonKey(name: 'end_date', fromJson: _parseStringOrNull) String? endDate,
    @JsonKey(name: 'start_time', fromJson: _parseStringOrNull) String? startTime,
    @JsonKey(name: 'end_time', fromJson: _parseStringOrNull) String? endTime,
    @JsonKey(fromJson: _parseStringOrNull) String? display,
    @JsonKey(name: 'duration_minutes', fromJson: _parseIntOrNull) int? durationMinutes,
    @JsonKey(name: 'is_recurring', fromJson: _parseBool) @Default(false) bool isRecurring,
  }) = _EventDatesDto;

  factory EventDatesDto.fromJson(Map<String, dynamic> json) =>
      _$EventDatesDtoFromJson(json);
}

@freezed
class EventPricingDto with _$EventPricingDto {
  const factory EventPricingDto({
    @JsonKey(name: 'is_free', fromJson: _parseBool) @Default(false) bool isFree,
    @JsonKey(fromJson: _parseDouble) @Default(0) double min,
    @JsonKey(fromJson: _parseDouble) @Default(0) double max,
    @Default('EUR') String currency,
    @JsonKey(fromJson: _parseStringOrNull) String? display,
  }) = _EventPricingDto;

  factory EventPricingDto.fromJson(Map<String, dynamic> json) =>
      _$EventPricingDtoFromJson(json);
}

@freezed
class EventAvailabilityDto with _$EventAvailabilityDto {
  const factory EventAvailabilityDto({
    @JsonKey(fromJson: _parseStringOrNull) String? status,
    @JsonKey(name: 'total_capacity', fromJson: _parseIntOrNull) int? totalCapacity,
    @JsonKey(name: 'spots_remaining', fromJson: _parseIntOrNull) int? spotsRemaining,
    @JsonKey(name: 'percentage_filled', fromJson: _parseIntOrNull) int? percentageFilled,
  }) = _EventAvailabilityDto;

  factory EventAvailabilityDto.fromJson(Map<String, dynamic> json) =>
      _$EventAvailabilityDtoFromJson(json);
}

@freezed
class EventCategoryDto with _$EventCategoryDto {
  const factory EventCategoryDto({
    @JsonKey(fromJson: _parseInt) @Default(0) int id,
    @JsonKey(fromJson: _parseHtmlString) @Default('') String name,
    @JsonKey(fromJson: _parseHtmlString) @Default('') String slug,
    @JsonKey(fromJson: _parseHtmlString) String? description,
    @JsonKey(fromJson: _parseStringOrNull) String? icon,
    @JsonKey(name: 'event_count', fromJson: _parseIntOrNull) int? eventCount,
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
    @JsonKey(name: 'distance_km', fromJson: _parseDoubleOrNull) double? distanceKm,
  }) = _EventLocationDto;

  factory EventLocationDto.fromJson(Map<String, dynamic> json) =>
      _$EventLocationDtoFromJson(json);
}

/// Parse a value that might be String, Map, List, bool, or null to String?
String? _parseStringOrNull(dynamic value) {
  if (value == null) return null;
  if (value is bool) return null; // API sometimes sends false instead of null
  if (value is List) return null; // Fix for "[]" appearing in UI
  if (value is String) return value.isEmpty ? null : value;
  if (value is Map) {
    // Try known keys first
    final result = value['url']?.toString() ??
           value['full']?.toString() ??
           value['large']?.toString() ??
           value['name']?.toString() ??
           value['rendered']?.toString();
    if (result != null) return result;
    
    // If no known keys, extract the first value (handles {1: "Villa Apartments"})
    if (value.isNotEmpty) {
      final firstValue = value.values.first;
      if (firstValue is String && firstValue.isNotEmpty) return firstValue;
      if (firstValue != null) return firstValue.toString();
    }
    return null;
  }
  return value.toString();
}

/// Parse boolean that might be int (0/1), string ("true"/"false"), or bool
bool _parseBool(dynamic value) {
  if (value == null) return false;
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) return value.toLowerCase() == 'true' || value == '1';
  return false;
}

/// Parse int that might be String or null
int? _parseIntOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}

/// Helper to safely parse Map<String, dynamic>, handling empty Lists []
Map<String, dynamic>? _parseMapOrNull(dynamic value) {
  if (value == null) return null;
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value); // Cast if generic Map
  return null; // Ignore Lists, Strings, etc.
}

List<String>? _parseStringList(dynamic value) {
  if (value == null) return null;
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  return [];
}

/// Parsing helper for HTML content that might be { "rendered": "..." } or string
String _parseHtmlString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map) {
    return value['rendered']?.toString() ?? value['content']?.toString() ?? '';
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

/// Parse a value to double with default 0 (for non-nullable fields)
double _parseDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

@freezed
class EventOrganizerDto with _$EventOrganizerDto {
  const factory EventOrganizerDto({
    @JsonKey(fromJson: _parseInt) @Default(0) int id,
    @JsonKey(fromJson: _parseHtmlString) @Default('') String name,
    @JsonKey(fromJson: _parseStringOrNull) String? avatar,
    @JsonKey(fromJson: _parseHtmlString) String? description,
    @JsonKey(fromJson: _parseStringOrNull) String? logo,
    @JsonKey(name: 'logo_sizes', fromJson: _parseMapOrNull) Map<String, dynamic>? logoSizes,
    @JsonKey(fromJson: _parseStringOrNull) String? website,
    @JsonKey(fromJson: _parseStringOrNull) String? phone,
    @JsonKey(fromJson: _parseStringOrNull) String? email,
    @JsonKey(name: 'cover_image', fromJson: _parseStringOrNull) String? coverImage,
    OrganizerContactDto? contact,
    OrganizerLocationDto? location,
    @JsonKey(name: 'practical_info') OrganizerPracticalInfoDto? practicalInfo,
    @JsonKey(name: 'social_links') List<OrganizerSocialLinkDto>? socialLinks,
    @JsonKey(name: 'stats') OrganizerStatsDto? stats,
    @JsonKey(name: 'categories') List<EventCategoryDto>? categories,
    @JsonKey(name: 'partnerships') List<CoOrganizerDto>? partnerships,
    @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull) String? profileUrl,
    @JsonKey(name: 'member_since', fromJson: _parseStringOrNull) String? memberSince,
    @JsonKey(fromJson: _parseBool) @Default(false) bool verified,
  }) = _EventOrganizerDto;

  factory EventOrganizerDto.fromJson(Map<String, dynamic> json) =>
      _$EventOrganizerDtoFromJson(json);
}

@freezed
class OrganizerSocialLinkDto with _$OrganizerSocialLinkDto {
  const factory OrganizerSocialLinkDto({
    @JsonKey(fromJson: _parseStringOrNull) String? type,
    @JsonKey(fromJson: _parseStringOrNull) String? url,
    @JsonKey(fromJson: _parseStringOrNull) String? icon,
  }) = _OrganizerSocialLinkDto;

  factory OrganizerSocialLinkDto.fromJson(Map<String, dynamic> json) =>
      _$OrganizerSocialLinkDtoFromJson(json);
}

@freezed
class OrganizerStatsDto with _$OrganizerStatsDto {
  const factory OrganizerStatsDto({
    @JsonKey(name: 'total_events', fromJson: _parseIntOrNull) int? totalEvents,
  }) = _OrganizerStatsDto;

  factory OrganizerStatsDto.fromJson(Map<String, dynamic> json) =>
      _$OrganizerStatsDtoFromJson(json);
}

@freezed
class OrganizerContactDto with _$OrganizerContactDto {
  const factory OrganizerContactDto({
    @JsonKey(fromJson: _parseStringOrNull) String? phone,
    @JsonKey(fromJson: _parseStringOrNull) String? email,
    @JsonKey(fromJson: _parseStringOrNull) String? website,
  }) = _OrganizerContactDto;

  factory OrganizerContactDto.fromJson(Map<String, dynamic> json) =>
      _$OrganizerContactDtoFromJson(json);
}

@freezed
class OrganizerLocationDto with _$OrganizerLocationDto {
  const factory OrganizerLocationDto({
    @JsonKey(fromJson: _parseStringOrNull) String? city,
    @JsonKey(fromJson: _parseStringOrNull) String? country,
    @JsonKey(fromJson: _parseStringOrNull) String? postcode,
    @JsonKey(fromJson: _parseStringOrNull) String? address,
  }) = _OrganizerLocationDto;

  factory OrganizerLocationDto.fromJson(Map<String, dynamic> json) =>
      _$OrganizerLocationDtoFromJson(json);
}

@freezed
class OrganizerPracticalInfoDto with _$OrganizerPracticalInfoDto {
  const factory OrganizerPracticalInfoDto({
    // PMR
    @Default(false) bool pmr,
    @JsonKey(name: 'pmr_infos', fromJson: _parseStringOrNull) String? pmrInfos,
    
    // Restauration
    @Default(false) bool restauration,
    @JsonKey(name: 'restauration_infos', fromJson: _parseStringOrNull) String? restaurationInfos,
    
    // Boisson
    @Default(false) bool boisson,
    @JsonKey(name: 'boisson_infos', fromJson: _parseStringOrNull) String? boissonInfos,
    
    // Stationnement
    @JsonKey(fromJson: _parseStringOrNull) String? stationnement,
    
    // Event Type
    @JsonKey(name: 'event_type', fromJson: _parseStringOrNull) String? eventType,
  }) = _OrganizerPracticalInfoDto;

  factory OrganizerPracticalInfoDto.fromJson(Map<String, dynamic> json) =>
      _$OrganizerPracticalInfoDtoFromJson(json);
}

@freezed
class CoOrganizerDto with _$CoOrganizerDto {
  const factory CoOrganizerDto({
    @JsonKey(fromJson: _parseInt) @Default(0) int id,
    @JsonKey(fromJson: _parseHtmlString) @Default('') String name,
    @JsonKey(fromJson: _parseStringOrNull) String? logo,
    @JsonKey(fromJson: _parseStringOrNull) String? role,
    @JsonKey(name: 'role_label', fromJson: _parseStringOrNull) String? roleLabel,
    @JsonKey(fromJson: _parseStringOrNull) String? city,
    @JsonKey(name: 'profile_url', fromJson: _parseStringOrNull) String? profileUrl,
  }) = _CoOrganizerDto;

  factory CoOrganizerDto.fromJson(Map<String, dynamic> json) =>
      _$CoOrganizerDtoFromJson(json);
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
  return _parseMapOrNull(value);
}

@freezed
class PaginationDto with _$PaginationDto {
  const factory PaginationDto({
    @JsonKey(name: 'current_page', fromJson: _parseInt) @Default(1) int currentPage,
    @JsonKey(name: 'per_page', fromJson: _parseInt) @Default(10) int perPage,
    @JsonKey(name: 'total_items', fromJson: _parseInt) @Default(0) int totalItems,
    @JsonKey(name: 'total_pages', fromJson: _parseInt) @Default(0) int totalPages,
    @JsonKey(name: 'has_next', fromJson: _parseBool) @Default(false) bool hasNext,
    @JsonKey(name: 'has_prev', fromJson: _parseBool) @Default(false) bool hasPrev,
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
    @JsonKey(fromJson: _parseInt) @Default(0) int id,
    @JsonKey(fromJson: _parseHtmlString) @Default('') String name,
    @JsonKey(fromJson: _parseHtmlString) @Default('') String slug,
    @JsonKey(name: 'event_count', fromJson: _parseIntOrNull) int? eventCount,
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

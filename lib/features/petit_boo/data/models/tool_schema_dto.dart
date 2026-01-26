import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool_schema_dto.freezed.dart';
part 'tool_schema_dto.g.dart';

/// Schema for a Petit Boo MCP tool
@freezed
class ToolSchemaDto with _$ToolSchemaDto {
  const factory ToolSchemaDto({
    /// Tool name (e.g., 'getMyFavorites', 'searchEvents')
    required String name,

    /// Human-readable description
    @Default('') String description,

    /// Display type for the UI (event_list, booking_list, profile, stats, detail, brain_memory, trip_plan, action_confirmation)
    @JsonKey(name: 'display_type') @Default('list') String displayType,

    /// Material icon name (e.g., 'favorite', 'search', 'person')
    @Default('extension') String icon,

    /// Accent color as hex (e.g., '#FF5252')
    String? color,

    /// Title shown in the card header
    String? title,

    /// Empty state message when no data
    @JsonKey(name: 'empty_message') String? emptyMessage,

    /// Schema for parsing the response
    @JsonKey(name: 'response_schema') ToolResponseSchemaDto? responseSchema,

    /// Brain memory section schemas (for brain_memory display type)
    @JsonKey(name: 'section_schemas') List<BrainSectionSchemaDto>? sectionSchemas,

    /// Trip planner schema (for trip_plan display type)
    @JsonKey(name: 'trip_schema') TripSchemaDto? tripSchema,

    /// Action type for confirmations (favorite_add, favorite_remove, brain_update, list_create, move_to_list)
    @JsonKey(name: 'action_type') String? actionType,

    /// Whether to show a toast notification (for action_confirmation)
    @JsonKey(name: 'show_toast') @Default(true) bool showToast,
  }) = _ToolSchemaDto;

  factory ToolSchemaDto.fromJson(Map<String, dynamic> json) =>
      _$ToolSchemaDtoFromJson(json);
}

/// Schema for parsing tool response data
@freezed
class ToolResponseSchemaDto with _$ToolResponseSchemaDto {
  const factory ToolResponseSchemaDto({
    /// Key for the items list in response (e.g., 'favorites', 'events', 'bookings')
    @JsonKey(name: 'items_key') String? itemsKey,

    /// Key for total count
    @JsonKey(name: 'total_key') String? totalKey,

    /// Key for a single item (for detail views)
    @JsonKey(name: 'item_key') String? itemKey,

    /// Schema for list items
    @JsonKey(name: 'item_schema') ToolItemSchemaDto? itemSchema,

    /// Stats to display (for profile/stats views)
    List<ToolStatSchemaDto>? stats,
  }) = _ToolResponseSchemaDto;

  factory ToolResponseSchemaDto.fromJson(Map<String, dynamic> json) =>
      _$ToolResponseSchemaDtoFromJson(json);
}

/// Schema for parsing individual items in a list
@freezed
class ToolItemSchemaDto with _$ToolItemSchemaDto {
  const factory ToolItemSchemaDto({
    /// Field name for item title
    @JsonKey(name: 'title_field') String? titleField,

    /// Field name for subtitle
    @JsonKey(name: 'subtitle_field') String? subtitleField,

    /// Field name for image URL
    @JsonKey(name: 'image_field') String? imageField,

    /// Field name for date display
    @JsonKey(name: 'date_field') String? dateField,

    /// Field name for time display
    @JsonKey(name: 'time_field') String? timeField,

    /// Field name for price display
    @JsonKey(name: 'price_field') String? priceField,

    /// Field name for status (for bookings, tickets)
    @JsonKey(name: 'status_field') String? statusField,

    /// Field name for badge text (e.g., 'Gratuit')
    @JsonKey(name: 'badge_field') String? badgeField,

    /// Field name for badge condition (e.g., 'is_free')
    @JsonKey(name: 'badge_condition_field') String? badgeConditionField,

    /// Badge text to show when condition is true
    @JsonKey(name: 'badge_text') String? badgeText,

    /// Navigation configuration
    ToolNavigationDto? navigation,
  }) = _ToolItemSchemaDto;

  factory ToolItemSchemaDto.fromJson(Map<String, dynamic> json) =>
      _$ToolItemSchemaDtoFromJson(json);
}

/// Navigation configuration for clickable items
@freezed
class ToolNavigationDto with _$ToolNavigationDto {
  const factory ToolNavigationDto({
    /// Route template with placeholders (e.g., '/event/{slug}', '/booking/{uuid}')
    required String route,

    /// Field name for the route parameter (e.g., 'slug', 'uuid')
    @JsonKey(name: 'id_field') required String idField,

    /// Whether to use go() instead of push() (for shell routes)
    @JsonKey(name: 'use_go') @Default(false) bool useGo,
  }) = _ToolNavigationDto;

  factory ToolNavigationDto.fromJson(Map<String, dynamic> json) =>
      _$ToolNavigationDtoFromJson(json);
}

/// Schema for stat items in profile/stats views
@freezed
class ToolStatSchemaDto with _$ToolStatSchemaDto {
  const factory ToolStatSchemaDto({
    /// Material icon name
    required String icon,

    /// Label text
    required String label,

    /// Field name in the data
    required String field,
  }) = _ToolStatSchemaDto;

  factory ToolStatSchemaDto.fromJson(Map<String, dynamic> json) =>
      _$ToolStatSchemaDtoFromJson(json);
}

/// Response wrapper for GET /api/v1/tools
@freezed
class ToolsResponseDto with _$ToolsResponseDto {
  const factory ToolsResponseDto({
    @Default(true) bool success,
    @Default([]) List<ToolSchemaDto> tools,
  }) = _ToolsResponseDto;

  factory ToolsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ToolsResponseDtoFromJson(json);
}

/// Schema for brain memory sections (family, location, preferences, constraints)
@freezed
class BrainSectionSchemaDto with _$BrainSectionSchemaDto {
  const factory BrainSectionSchemaDto({
    /// Section key (e.g., 'family', 'location', 'preferences', 'constraints')
    required String key,

    /// Human-readable title (e.g., 'Famille')
    required String title,

    /// Material icon name (e.g., 'family_restroom')
    required String icon,

    /// Whether the section can be collapsed
    @Default(true) bool collapsible,
  }) = _BrainSectionSchemaDto;

  factory BrainSectionSchemaDto.fromJson(Map<String, dynamic> json) =>
      _$BrainSectionSchemaDtoFromJson(json);
}

/// Schema for trip planner configuration
@freezed
class TripSchemaDto with _$TripSchemaDto {
  const factory TripSchemaDto({
    /// Whether to show the map
    @JsonKey(name: 'show_map') @Default(true) bool showMap,

    /// Whether to enable drag & drop reordering
    @JsonKey(name: 'enable_reorder') @Default(true) bool enableReorder,
  }) = _TripSchemaDto;

  factory TripSchemaDto.fromJson(Map<String, dynamic> json) =>
      _$TripSchemaDtoFromJson(json);
}

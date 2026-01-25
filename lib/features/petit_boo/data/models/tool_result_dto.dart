import 'package:freezed_annotation/freezed_annotation.dart';

part 'tool_result_dto.freezed.dart';
part 'tool_result_dto.g.dart';

/// Tool result types from Petit Boo
enum ToolResultType {
  @JsonValue('my_bookings')
  myBookings,
  @JsonValue('my_tickets')
  myTickets,
  @JsonValue('event_search')
  eventSearch,
  @JsonValue('event_details')
  eventDetails,
  @JsonValue('my_favorites')
  myFavorites,
  @JsonValue('my_alerts')
  myAlerts,
  @JsonValue('my_profile')
  myProfile,
  @JsonValue('notifications')
  notifications,
}

/// DTO for tool execution result
@freezed
class ToolResultDto with _$ToolResultDto {
  const ToolResultDto._();

  const factory ToolResultDto({
    /// Tool name
    required String tool,

    /// Tool-specific result data
    required Map<String, dynamic> data,

    /// Timestamp of tool execution
    @JsonKey(name: 'executed_at') String? executedAt,
  }) = _ToolResultDto;

  factory ToolResultDto.fromJson(Map<String, dynamic> json) =>
      _$ToolResultDtoFromJson(json);

  /// Get typed result based on tool name
  ToolResultType? get type {
    switch (tool) {
      case 'getMyBookings':
        return ToolResultType.myBookings;
      case 'getMyTickets':
        return ToolResultType.myTickets;
      case 'searchEvents':
        return ToolResultType.eventSearch;
      case 'getEventDetails':
        return ToolResultType.eventDetails;
      case 'getMyFavorites':
        return ToolResultType.myFavorites;
      case 'getMyAlerts':
        return ToolResultType.myAlerts;
      case 'getMyProfile':
        return ToolResultType.myProfile;
      case 'getNotifications':
        return ToolResultType.notifications;
      default:
        return null;
    }
  }
}

// ============ Typed Tool Results ============

/// Result for getMyBookings tool
@freezed
class BookingsToolResult with _$BookingsToolResult {
  const factory BookingsToolResult({
    required List<BookingResultItem> bookings,
    required int total,
    @JsonKey(name: 'pending_count') @Default(0) int pendingCount,
    @JsonKey(name: 'upcoming_count') @Default(0) int upcomingCount,
  }) = _BookingsToolResult;

  factory BookingsToolResult.fromJson(Map<String, dynamic> json) =>
      _$BookingsToolResultFromJson(json);
}

@freezed
class BookingResultItem with _$BookingResultItem {
  const factory BookingResultItem({
    required String uuid,
    String? reference,
    required String status,
    @JsonKey(name: 'event_title') required String eventTitle,
    @JsonKey(name: 'event_slug') String? eventSlug,
    @JsonKey(name: 'event_image') String? eventImage,
    @JsonKey(name: 'slot_date') String? slotDate,
    @JsonKey(name: 'slot_time') String? slotTime,
    @JsonKey(name: 'tickets_count') @Default(0) int ticketsCount,
    @JsonKey(name: 'total_price') double? totalPrice,
    String? currency,
  }) = _BookingResultItem;

  factory BookingResultItem.fromJson(Map<String, dynamic> json) =>
      _$BookingResultItemFromJson(json);
}

/// Result for getMyTickets tool
@freezed
class TicketsToolResult with _$TicketsToolResult {
  const factory TicketsToolResult({
    required List<TicketResultItem> tickets,
    required int total,
    @JsonKey(name: 'active_count') @Default(0) int activeCount,
  }) = _TicketsToolResult;

  factory TicketsToolResult.fromJson(Map<String, dynamic> json) =>
      _$TicketsToolResultFromJson(json);
}

@freezed
class TicketResultItem with _$TicketResultItem {
  const factory TicketResultItem({
    required String uuid,
    @JsonKey(name: 'qr_code') String? qrCode,
    required String status,
    @JsonKey(name: 'event_title') required String eventTitle,
    @JsonKey(name: 'event_slug') String? eventSlug,
    @JsonKey(name: 'ticket_type') String? ticketType,
    @JsonKey(name: 'slot_date') String? slotDate,
    @JsonKey(name: 'slot_time') String? slotTime,
    @JsonKey(name: 'attendee_name') String? attendeeName,
  }) = _TicketResultItem;

  factory TicketResultItem.fromJson(Map<String, dynamic> json) =>
      _$TicketResultItemFromJson(json);
}

/// Result for searchEvents tool
@freezed
class EventSearchToolResult with _$EventSearchToolResult {
  const factory EventSearchToolResult({
    required List<EventResultItem> events,
    required int total,
    @JsonKey(name: 'filters_applied') Map<String, dynamic>? filtersApplied,
  }) = _EventSearchToolResult;

  factory EventSearchToolResult.fromJson(Map<String, dynamic> json) =>
      _$EventSearchToolResultFromJson(json);
}

@freezed
class EventResultItem with _$EventResultItem {
  const factory EventResultItem({
    required String uuid,
    required String slug,
    required String title,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'venue_name') String? venueName,
    @JsonKey(name: 'city_name') String? cityName,
    @JsonKey(name: 'next_slot_date') String? nextSlotDate,
    @JsonKey(name: 'next_slot_time') String? nextSlotTime,
    @JsonKey(name: 'price_display') String? priceDisplay,
    @JsonKey(name: 'is_free') @Default(false) bool isFree,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
  }) = _EventResultItem;

  factory EventResultItem.fromJson(Map<String, dynamic> json) =>
      _$EventResultItemFromJson(json);
}

/// Result for getEventDetails tool
@freezed
class EventDetailsToolResult with _$EventDetailsToolResult {
  const factory EventDetailsToolResult({
    required String uuid,
    required String slug,
    required String title,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    EventVenueResult? venue,
    @JsonKey(name: 'next_slot') EventSlotResult? nextSlot,
    @JsonKey(name: 'ticket_types') List<TicketTypeResult>? ticketTypes,
    @JsonKey(name: 'is_favorite') @Default(false) bool isFavorite,
    @JsonKey(name: 'can_book') @Default(true) bool canBook,
    String? category,
    List<String>? tags,
  }) = _EventDetailsToolResult;

  factory EventDetailsToolResult.fromJson(Map<String, dynamic> json) =>
      _$EventDetailsToolResultFromJson(json);
}

@freezed
class EventVenueResult with _$EventVenueResult {
  const factory EventVenueResult({
    required String name,
    String? address,
    String? city,
    double? latitude,
    double? longitude,
  }) = _EventVenueResult;

  factory EventVenueResult.fromJson(Map<String, dynamic> json) =>
      _$EventVenueResultFromJson(json);
}

@freezed
class EventSlotResult with _$EventSlotResult {
  const factory EventSlotResult({
    required String uuid,
    @JsonKey(name: 'slot_date') required String slotDate,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') String? endTime,
    @JsonKey(name: 'available_capacity') int? availableCapacity,
  }) = _EventSlotResult;

  factory EventSlotResult.fromJson(Map<String, dynamic> json) =>
      _$EventSlotResultFromJson(json);
}

@freezed
class TicketTypeResult with _$TicketTypeResult {
  const factory TicketTypeResult({
    required String uuid,
    required String name,
    required double price,
    String? description,
    @JsonKey(name: 'available_quantity') int? availableQuantity,
  }) = _TicketTypeResult;

  factory TicketTypeResult.fromJson(Map<String, dynamic> json) =>
      _$TicketTypeResultFromJson(json);
}

/// Result for getMyFavorites tool
@freezed
class FavoritesToolResult with _$FavoritesToolResult {
  const factory FavoritesToolResult({
    required List<EventResultItem> favorites,
    required int total,
    List<FavoriteListResult>? lists,
  }) = _FavoritesToolResult;

  factory FavoritesToolResult.fromJson(Map<String, dynamic> json) =>
      _$FavoritesToolResultFromJson(json);
}

@freezed
class FavoriteListResult with _$FavoriteListResult {
  const factory FavoriteListResult({
    required String uuid,
    required String name,
    @JsonKey(name: 'events_count') @Default(0) int eventsCount,
  }) = _FavoriteListResult;

  factory FavoriteListResult.fromJson(Map<String, dynamic> json) =>
      _$FavoriteListResultFromJson(json);
}

/// Result for getMyAlerts tool
@freezed
class AlertsToolResult with _$AlertsToolResult {
  const factory AlertsToolResult({
    required List<AlertResultItem> alerts,
    required int total,
    @JsonKey(name: 'active_count') @Default(0) int activeCount,
  }) = _AlertsToolResult;

  factory AlertsToolResult.fromJson(Map<String, dynamic> json) =>
      _$AlertsToolResultFromJson(json);
}

@freezed
class AlertResultItem with _$AlertResultItem {
  const factory AlertResultItem({
    required String uuid,
    required String name,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'last_triggered_at') String? lastTriggeredAt,
    @JsonKey(name: 'new_events_count') @Default(0) int newEventsCount,
    @JsonKey(name: 'search_criteria_summary') String? searchCriteriaSummary,
  }) = _AlertResultItem;

  factory AlertResultItem.fromJson(Map<String, dynamic> json) =>
      _$AlertResultItemFromJson(json);
}

/// Result for getMyProfile tool
@freezed
class ProfileToolResult with _$ProfileToolResult {
  const factory ProfileToolResult({
    required UserProfileResult user,
    ProfileStatsResult? stats,
    @JsonKey(name: 'hiboos_balance') @Default(0) int hiboosBalance,
  }) = _ProfileToolResult;

  factory ProfileToolResult.fromJson(Map<String, dynamic> json) =>
      _$ProfileToolResultFromJson(json);
}

@freezed
class UserProfileResult with _$UserProfileResult {
  const factory UserProfileResult({
    required String uuid,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    required String email,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _UserProfileResult;

  factory UserProfileResult.fromJson(Map<String, dynamic> json) =>
      _$UserProfileResultFromJson(json);
}

@freezed
class ProfileStatsResult with _$ProfileStatsResult {
  const factory ProfileStatsResult({
    @JsonKey(name: 'total_bookings') @Default(0) int totalBookings,
    @JsonKey(name: 'total_events_attended') @Default(0) int totalEventsAttended,
    @JsonKey(name: 'total_favorites') @Default(0) int totalFavorites,
    @JsonKey(name: 'total_alerts') @Default(0) int totalAlerts,
  }) = _ProfileStatsResult;

  factory ProfileStatsResult.fromJson(Map<String, dynamic> json) =>
      _$ProfileStatsResultFromJson(json);
}

/// Result for getNotifications tool
@freezed
class NotificationsToolResult with _$NotificationsToolResult {
  const factory NotificationsToolResult({
    required List<NotificationResultItem> notifications,
    required int total,
    @JsonKey(name: 'unread_count') @Default(0) int unreadCount,
  }) = _NotificationsToolResult;

  factory NotificationsToolResult.fromJson(Map<String, dynamic> json) =>
      _$NotificationsToolResultFromJson(json);
}

@freezed
class NotificationResultItem with _$NotificationResultItem {
  const factory NotificationResultItem({
    required String id,
    required String type,
    required String title,
    String? body,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'created_at') required String createdAt,
    Map<String, dynamic>? data,
  }) = _NotificationResultItem;

  factory NotificationResultItem.fromJson(Map<String, dynamic> json) =>
      _$NotificationResultItemFromJson(json);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tool_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ToolResultDtoImpl _$$ToolResultDtoImplFromJson(Map<String, dynamic> json) =>
    _$ToolResultDtoImpl(
      tool: json['tool'] as String,
      data: json['data'] as Map<String, dynamic>,
      executedAt: json['executed_at'] as String?,
    );

Map<String, dynamic> _$$ToolResultDtoImplToJson(_$ToolResultDtoImpl instance) =>
    <String, dynamic>{
      'tool': instance.tool,
      'data': instance.data,
      'executed_at': instance.executedAt,
    };

_$BookingsToolResultImpl _$$BookingsToolResultImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingsToolResultImpl(
      bookings: (json['bookings'] as List<dynamic>?)
              ?.map(
                  (e) => BookingResultItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      pendingCount: (json['pending_count'] as num?)?.toInt() ?? 0,
      upcomingCount: (json['upcoming_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$BookingsToolResultImplToJson(
        _$BookingsToolResultImpl instance) =>
    <String, dynamic>{
      'bookings': instance.bookings,
      'total': instance.total,
      'pending_count': instance.pendingCount,
      'upcoming_count': instance.upcomingCount,
    };

_$BookingResultItemImpl _$$BookingResultItemImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingResultItemImpl(
      uuid: json['uuid'] as String,
      reference: json['reference'] as String?,
      status: json['status'] as String,
      eventTitle: json['event_title'] as String,
      eventSlug: json['event_slug'] as String?,
      eventImage: json['event_image'] as String?,
      slotDate: json['slot_date'] as String?,
      slotTime: json['slot_time'] as String?,
      ticketsCount: (json['tickets_count'] as num?)?.toInt() ?? 0,
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$$BookingResultItemImplToJson(
        _$BookingResultItemImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'reference': instance.reference,
      'status': instance.status,
      'event_title': instance.eventTitle,
      'event_slug': instance.eventSlug,
      'event_image': instance.eventImage,
      'slot_date': instance.slotDate,
      'slot_time': instance.slotTime,
      'tickets_count': instance.ticketsCount,
      'total_price': instance.totalPrice,
      'currency': instance.currency,
    };

_$TicketsToolResultImpl _$$TicketsToolResultImplFromJson(
        Map<String, dynamic> json) =>
    _$TicketsToolResultImpl(
      tickets: (json['tickets'] as List<dynamic>?)
              ?.map((e) => TicketResultItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      activeCount: (json['active_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TicketsToolResultImplToJson(
        _$TicketsToolResultImpl instance) =>
    <String, dynamic>{
      'tickets': instance.tickets,
      'total': instance.total,
      'active_count': instance.activeCount,
    };

_$TicketResultItemImpl _$$TicketResultItemImplFromJson(
        Map<String, dynamic> json) =>
    _$TicketResultItemImpl(
      uuid: json['uuid'] as String,
      qrCode: json['qr_code'] as String?,
      status: json['status'] as String,
      eventTitle: json['event_title'] as String,
      eventSlug: json['event_slug'] as String?,
      ticketType: json['ticket_type'] as String?,
      slotDate: json['slot_date'] as String?,
      slotTime: json['slot_time'] as String?,
      attendeeName: json['attendee_name'] as String?,
    );

Map<String, dynamic> _$$TicketResultItemImplToJson(
        _$TicketResultItemImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'qr_code': instance.qrCode,
      'status': instance.status,
      'event_title': instance.eventTitle,
      'event_slug': instance.eventSlug,
      'ticket_type': instance.ticketType,
      'slot_date': instance.slotDate,
      'slot_time': instance.slotTime,
      'attendee_name': instance.attendeeName,
    };

_$EventSearchToolResultImpl _$$EventSearchToolResultImplFromJson(
        Map<String, dynamic> json) =>
    _$EventSearchToolResultImpl(
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => EventResultItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      filtersApplied: json['filters_applied'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$EventSearchToolResultImplToJson(
        _$EventSearchToolResultImpl instance) =>
    <String, dynamic>{
      'events': instance.events,
      'total': instance.total,
      'filters_applied': instance.filtersApplied,
    };

_$EventResultItemImpl _$$EventResultItemImplFromJson(
        Map<String, dynamic> json) =>
    _$EventResultItemImpl(
      uuid: json['uuid'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      venueName: json['venue_name'] as String?,
      cityName: json['city_name'] as String?,
      nextSlotDate: json['next_slot_date'] as String?,
      nextSlotTime: json['next_slot_time'] as String?,
      priceDisplay: json['price_display'] as String?,
      isFree: json['is_free'] as bool? ?? false,
      isFavorite: json['is_favorite'] as bool? ?? false,
    );

Map<String, dynamic> _$$EventResultItemImplToJson(
        _$EventResultItemImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'slug': instance.slug,
      'title': instance.title,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'venue_name': instance.venueName,
      'city_name': instance.cityName,
      'next_slot_date': instance.nextSlotDate,
      'next_slot_time': instance.nextSlotTime,
      'price_display': instance.priceDisplay,
      'is_free': instance.isFree,
      'is_favorite': instance.isFavorite,
    };

_$EventDetailsToolResultImpl _$$EventDetailsToolResultImplFromJson(
        Map<String, dynamic> json) =>
    _$EventDetailsToolResultImpl(
      uuid: json['uuid'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      venue: json['venue'] == null
          ? null
          : EventVenueResult.fromJson(json['venue'] as Map<String, dynamic>),
      nextSlot: json['next_slot'] == null
          ? null
          : EventSlotResult.fromJson(json['next_slot'] as Map<String, dynamic>),
      ticketTypes: (json['ticket_types'] as List<dynamic>?)
          ?.map((e) => TicketTypeResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      isFavorite: json['is_favorite'] as bool? ?? false,
      canBook: json['can_book'] as bool? ?? true,
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$EventDetailsToolResultImplToJson(
        _$EventDetailsToolResultImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'slug': instance.slug,
      'title': instance.title,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'venue': instance.venue,
      'next_slot': instance.nextSlot,
      'ticket_types': instance.ticketTypes,
      'is_favorite': instance.isFavorite,
      'can_book': instance.canBook,
      'category': instance.category,
      'tags': instance.tags,
    };

_$EventVenueResultImpl _$$EventVenueResultImplFromJson(
        Map<String, dynamic> json) =>
    _$EventVenueResultImpl(
      name: json['name'] as String,
      address: json['address'] as String?,
      city: json['city'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$EventVenueResultImplToJson(
        _$EventVenueResultImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_$EventSlotResultImpl _$$EventSlotResultImplFromJson(
        Map<String, dynamic> json) =>
    _$EventSlotResultImpl(
      uuid: json['uuid'] as String,
      slotDate: json['slot_date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String?,
      availableCapacity: (json['available_capacity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$EventSlotResultImplToJson(
        _$EventSlotResultImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'slot_date': instance.slotDate,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'available_capacity': instance.availableCapacity,
    };

_$TicketTypeResultImpl _$$TicketTypeResultImplFromJson(
        Map<String, dynamic> json) =>
    _$TicketTypeResultImpl(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String?,
      availableQuantity: (json['available_quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TicketTypeResultImplToJson(
        _$TicketTypeResultImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'available_quantity': instance.availableQuantity,
    };

_$FavoritesToolResultImpl _$$FavoritesToolResultImplFromJson(
        Map<String, dynamic> json) =>
    _$FavoritesToolResultImpl(
      favorites: (json['favorites'] as List<dynamic>?)
              ?.map((e) => EventResultItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      lists: (json['lists'] as List<dynamic>?)
          ?.map((e) => FavoriteListResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$FavoritesToolResultImplToJson(
        _$FavoritesToolResultImpl instance) =>
    <String, dynamic>{
      'favorites': instance.favorites,
      'total': instance.total,
      'lists': instance.lists,
    };

_$FavoriteListResultImpl _$$FavoriteListResultImplFromJson(
        Map<String, dynamic> json) =>
    _$FavoriteListResultImpl(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      eventsCount: (json['events_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$FavoriteListResultImplToJson(
        _$FavoriteListResultImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'events_count': instance.eventsCount,
    };

_$AlertsToolResultImpl _$$AlertsToolResultImplFromJson(
        Map<String, dynamic> json) =>
    _$AlertsToolResultImpl(
      alerts: (json['alerts'] as List<dynamic>?)
              ?.map((e) => AlertResultItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      activeCount: (json['active_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$AlertsToolResultImplToJson(
        _$AlertsToolResultImpl instance) =>
    <String, dynamic>{
      'alerts': instance.alerts,
      'total': instance.total,
      'active_count': instance.activeCount,
    };

_$AlertResultItemImpl _$$AlertResultItemImplFromJson(
        Map<String, dynamic> json) =>
    _$AlertResultItemImpl(
      uuid: json['uuid'] as String,
      name: json['name'] as String,
      isActive: json['is_active'] as bool? ?? true,
      lastTriggeredAt: json['last_triggered_at'] as String?,
      newEventsCount: (json['new_events_count'] as num?)?.toInt() ?? 0,
      searchCriteriaSummary: json['search_criteria_summary'] as String?,
    );

Map<String, dynamic> _$$AlertResultItemImplToJson(
        _$AlertResultItemImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'is_active': instance.isActive,
      'last_triggered_at': instance.lastTriggeredAt,
      'new_events_count': instance.newEventsCount,
      'search_criteria_summary': instance.searchCriteriaSummary,
    };

_$ProfileToolResultImpl _$$ProfileToolResultImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileToolResultImpl(
      user: UserProfileResult.fromJson(json['user'] as Map<String, dynamic>),
      stats: json['stats'] == null
          ? null
          : ProfileStatsResult.fromJson(json['stats'] as Map<String, dynamic>),
      hiboosBalance: (json['hiboos_balance'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ProfileToolResultImplToJson(
        _$ProfileToolResultImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'stats': instance.stats,
      'hiboos_balance': instance.hiboosBalance,
    };

_$UserProfileResultImpl _$$UserProfileResultImplFromJson(
        Map<String, dynamic> json) =>
    _$UserProfileResultImpl(
      uuid: json['uuid'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$UserProfileResultImplToJson(
        _$UserProfileResultImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
      'phone_number': instance.phoneNumber,
      'created_at': instance.createdAt,
    };

_$ProfileStatsResultImpl _$$ProfileStatsResultImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileStatsResultImpl(
      totalBookings: (json['total_bookings'] as num?)?.toInt() ?? 0,
      totalEventsAttended:
          (json['total_events_attended'] as num?)?.toInt() ?? 0,
      totalFavorites: (json['total_favorites'] as num?)?.toInt() ?? 0,
      totalAlerts: (json['total_alerts'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ProfileStatsResultImplToJson(
        _$ProfileStatsResultImpl instance) =>
    <String, dynamic>{
      'total_bookings': instance.totalBookings,
      'total_events_attended': instance.totalEventsAttended,
      'total_favorites': instance.totalFavorites,
      'total_alerts': instance.totalAlerts,
    };

_$NotificationsToolResultImpl _$$NotificationsToolResultImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationsToolResultImpl(
      notifications: (json['notifications'] as List<dynamic>?)
              ?.map((e) =>
                  NotificationResultItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$NotificationsToolResultImplToJson(
        _$NotificationsToolResultImpl instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
      'total': instance.total,
      'unread_count': instance.unreadCount,
    };

_$NotificationResultItemImpl _$$NotificationResultItemImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationResultItemImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$NotificationResultItemImplToJson(
        _$NotificationResultItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'body': instance.body,
      'is_read': instance.isRead,
      'created_at': instance.createdAt,
      'data': instance.data,
    };

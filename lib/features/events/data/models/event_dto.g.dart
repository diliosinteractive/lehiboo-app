// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventDtoImpl _$$EventDtoImplFromJson(Map<String, dynamic> json) =>
    _$EventDtoImpl(
      id: (json['id'] as num).toInt(),
      title: _parseHtmlString(json['title']),
      slug: _parseHtmlString(json['slug']),
      excerpt: _parseHtmlString(json['excerpt']),
      content: _parseHtmlString(json['content']),
      featuredImage: _parseImage(json['featured_image']),
      thumbnail: _parseStringOrNull(json['thumbnail']),
      gallery: _parseGallery(json['gallery']),
      category: json['category'] == null
          ? null
          : EventCategoryDto.fromJson(json['category'] as Map<String, dynamic>),
      thematique: json['thematique'] == null
          ? null
          : ThematiqueDto.fromJson(json['thematique'] as Map<String, dynamic>),
      dates: json['dates'] == null
          ? null
          : EventDatesDto.fromJson(json['dates'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : EventLocationDto.fromJson(json['location'] as Map<String, dynamic>),
      pricing: json['pricing'] == null
          ? null
          : EventPricingDto.fromJson(json['pricing'] as Map<String, dynamic>),
      availability: json['availability'] == null
          ? null
          : EventAvailabilityDto.fromJson(
              json['availability'] as Map<String, dynamic>),
      ratings: json['ratings'],
      organizer: json['organizer'] == null
          ? null
          : EventOrganizerDto.fromJson(
              json['organizer'] as Map<String, dynamic>),
      tags: _parseStringList(json['tags']),
      ticketTypes: json['ticket_types'] as List<dynamic>?,
      tickets: json['tickets'] as List<dynamic>?,
      timeSlots: _parseMapOrNull(json['time_slots']),
      calendar: _parseMapOrNull(json['calendar']),
      recurrence: _parseMapOrNull(json['recurrence']),
      extraServices: json['extra_services'] as List<dynamic>?,
      coupons: json['coupons'] as List<dynamic>?,
      seatConfig: _parseMapOrNull(json['seat_config']),
      externalBooking: _parseMapOrNull(json['external_booking']),
      eventType: _parseMapOrNull(json['event_type']),
      targetAudience: json['target_audience'] as List<dynamic>?,
      locationDetails: _parseMapOrNull(json['location_details']),
      coOrganizers: (json['coorganizers'] as List<dynamic>?)
          ?.map((e) => CoOrganizerDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      socialMedia: _parseMapOrNull(json['social_media']),
      isFavorite: json['is_favorite'] as bool? ?? false,
    );

Map<String, dynamic> _$$EventDtoImplToJson(_$EventDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'excerpt': instance.excerpt,
      'content': instance.content,
      'featured_image': instance.featuredImage,
      'thumbnail': instance.thumbnail,
      'gallery': instance.gallery,
      'category': instance.category,
      'thematique': instance.thematique,
      'dates': instance.dates,
      'location': instance.location,
      'pricing': instance.pricing,
      'availability': instance.availability,
      'ratings': instance.ratings,
      'organizer': instance.organizer,
      'tags': instance.tags,
      'ticket_types': instance.ticketTypes,
      'tickets': instance.tickets,
      'time_slots': instance.timeSlots,
      'calendar': instance.calendar,
      'recurrence': instance.recurrence,
      'extra_services': instance.extraServices,
      'coupons': instance.coupons,
      'seat_config': instance.seatConfig,
      'external_booking': instance.externalBooking,
      'event_type': instance.eventType,
      'target_audience': instance.targetAudience,
      'location_details': instance.locationDetails,
      'coorganizers': instance.coOrganizers,
      'social_media': instance.socialMedia,
      'is_favorite': instance.isFavorite,
    };

_$EventImageDtoImpl _$$EventImageDtoImplFromJson(Map<String, dynamic> json) =>
    _$EventImageDtoImpl(
      thumbnail: json['thumbnail'] as String?,
      medium: json['medium'] as String?,
      large: json['large'] as String?,
      full: json['full'] as String?,
    );

Map<String, dynamic> _$$EventImageDtoImplToJson(_$EventImageDtoImpl instance) =>
    <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'medium': instance.medium,
      'large': instance.large,
      'full': instance.full,
    };

_$EventDatesDtoImpl _$$EventDatesDtoImplFromJson(Map<String, dynamic> json) =>
    _$EventDatesDtoImpl(
      startDate: _parseStringOrNull(json['start_date']),
      endDate: _parseStringOrNull(json['end_date']),
      startTime: _parseStringOrNull(json['start_time']),
      endTime: _parseStringOrNull(json['end_time']),
      display: _parseStringOrNull(json['display']),
      durationMinutes: _parseIntOrNull(json['duration_minutes']),
      isRecurring: json['is_recurring'] == null
          ? false
          : _parseBool(json['is_recurring']),
    );

Map<String, dynamic> _$$EventDatesDtoImplToJson(_$EventDatesDtoImpl instance) =>
    <String, dynamic>{
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'display': instance.display,
      'duration_minutes': instance.durationMinutes,
      'is_recurring': instance.isRecurring,
    };

_$EventPricingDtoImpl _$$EventPricingDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EventPricingDtoImpl(
      isFree: json['is_free'] == null ? false : _parseBool(json['is_free']),
      min: json['min'] == null ? 0 : _parseDouble(json['min']),
      max: json['max'] == null ? 0 : _parseDouble(json['max']),
      currency: json['currency'] as String? ?? 'EUR',
      display: _parseStringOrNull(json['display']),
    );

Map<String, dynamic> _$$EventPricingDtoImplToJson(
        _$EventPricingDtoImpl instance) =>
    <String, dynamic>{
      'is_free': instance.isFree,
      'min': instance.min,
      'max': instance.max,
      'currency': instance.currency,
      'display': instance.display,
    };

_$EventAvailabilityDtoImpl _$$EventAvailabilityDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EventAvailabilityDtoImpl(
      status: _parseStringOrNull(json['status']),
      totalCapacity: _parseIntOrNull(json['total_capacity']),
      spotsRemaining: _parseIntOrNull(json['spots_remaining']),
      percentageFilled: _parseIntOrNull(json['percentage_filled']),
    );

Map<String, dynamic> _$$EventAvailabilityDtoImplToJson(
        _$EventAvailabilityDtoImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'total_capacity': instance.totalCapacity,
      'spots_remaining': instance.spotsRemaining,
      'percentage_filled': instance.percentageFilled,
    };

_$EventCategoryDtoImpl _$$EventCategoryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EventCategoryDtoImpl(
      id: json['id'] == null ? 0 : _parseInt(json['id']),
      name: json['name'] == null ? '' : _parseHtmlString(json['name']),
      slug: json['slug'] == null ? '' : _parseHtmlString(json['slug']),
      description: _parseHtmlString(json['description']),
      icon: _parseStringOrNull(json['icon']),
      eventCount: _parseIntOrNull(json['event_count']),
    );

Map<String, dynamic> _$$EventCategoryDtoImplToJson(
        _$EventCategoryDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'icon': instance.icon,
      'event_count': instance.eventCount,
    };

_$EventPriceDtoImpl _$$EventPriceDtoImplFromJson(Map<String, dynamic> json) =>
    _$EventPriceDtoImpl(
      isFree: json['is_free'] as bool? ?? false,
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
    );

Map<String, dynamic> _$$EventPriceDtoImplToJson(_$EventPriceDtoImpl instance) =>
    <String, dynamic>{
      'is_free': instance.isFree,
      'min': instance.min,
      'max': instance.max,
      'currency': instance.currency,
    };

_$EventLocationDtoImpl _$$EventLocationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EventLocationDtoImpl(
      venueName: _parseStringOrNull(json['venue_name']),
      address: _parseStringOrNull(json['address']),
      city: _parseStringOrNull(json['city']),
      lat: _parseDoubleOrNull(json['lat']),
      lng: _parseDoubleOrNull(json['lng']),
    );

Map<String, dynamic> _$$EventLocationDtoImplToJson(
        _$EventLocationDtoImpl instance) =>
    <String, dynamic>{
      'venue_name': instance.venueName,
      'address': instance.address,
      'city': instance.city,
      'lat': instance.lat,
      'lng': instance.lng,
    };

_$EventOrganizerDtoImpl _$$EventOrganizerDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EventOrganizerDtoImpl(
      id: json['id'] == null ? 0 : _parseInt(json['id']),
      name: json['name'] == null ? '' : _parseHtmlString(json['name']),
      avatar: _parseStringOrNull(json['avatar']),
      description: _parseHtmlString(json['description']),
      logo: _parseStringOrNull(json['logo']),
      logoSizes: _parseMapOrNull(json['logo_sizes']),
      website: _parseStringOrNull(json['website']),
      phone: _parseStringOrNull(json['phone']),
      email: _parseStringOrNull(json['email']),
      coverImage: _parseStringOrNull(json['cover_image']),
      contact: json['contact'] == null
          ? null
          : OrganizerContactDto.fromJson(
              json['contact'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : OrganizerLocationDto.fromJson(
              json['location'] as Map<String, dynamic>),
      practicalInfo: json['practical_info'] == null
          ? null
          : OrganizerPracticalInfoDto.fromJson(
              json['practical_info'] as Map<String, dynamic>),
      socialLinks: (json['social_links'] as List<dynamic>?)
          ?.map(
              (e) => OrganizerSocialLinkDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: json['stats'] == null
          ? null
          : OrganizerStatsDto.fromJson(json['stats'] as Map<String, dynamic>),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => EventCategoryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      partnerships: (json['partnerships'] as List<dynamic>?)
          ?.map((e) => CoOrganizerDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      profileUrl: _parseStringOrNull(json['profile_url']),
      memberSince: _parseStringOrNull(json['member_since']),
      verified: json['verified'] == null ? false : _parseBool(json['verified']),
    );

Map<String, dynamic> _$$EventOrganizerDtoImplToJson(
        _$EventOrganizerDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'description': instance.description,
      'logo': instance.logo,
      'logo_sizes': instance.logoSizes,
      'website': instance.website,
      'phone': instance.phone,
      'email': instance.email,
      'cover_image': instance.coverImage,
      'contact': instance.contact,
      'location': instance.location,
      'practical_info': instance.practicalInfo,
      'social_links': instance.socialLinks,
      'stats': instance.stats,
      'categories': instance.categories,
      'partnerships': instance.partnerships,
      'profile_url': instance.profileUrl,
      'member_since': instance.memberSince,
      'verified': instance.verified,
    };

_$OrganizerSocialLinkDtoImpl _$$OrganizerSocialLinkDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizerSocialLinkDtoImpl(
      type: _parseStringOrNull(json['type']),
      url: _parseStringOrNull(json['url']),
      icon: _parseStringOrNull(json['icon']),
    );

Map<String, dynamic> _$$OrganizerSocialLinkDtoImplToJson(
        _$OrganizerSocialLinkDtoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'url': instance.url,
      'icon': instance.icon,
    };

_$OrganizerStatsDtoImpl _$$OrganizerStatsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizerStatsDtoImpl(
      totalEvents: _parseIntOrNull(json['total_events']),
    );

Map<String, dynamic> _$$OrganizerStatsDtoImplToJson(
        _$OrganizerStatsDtoImpl instance) =>
    <String, dynamic>{
      'total_events': instance.totalEvents,
    };

_$OrganizerContactDtoImpl _$$OrganizerContactDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizerContactDtoImpl(
      phone: _parseStringOrNull(json['phone']),
      email: _parseStringOrNull(json['email']),
      website: _parseStringOrNull(json['website']),
    );

Map<String, dynamic> _$$OrganizerContactDtoImplToJson(
        _$OrganizerContactDtoImpl instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'email': instance.email,
      'website': instance.website,
    };

_$OrganizerLocationDtoImpl _$$OrganizerLocationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizerLocationDtoImpl(
      city: _parseStringOrNull(json['city']),
      country: _parseStringOrNull(json['country']),
      postcode: _parseStringOrNull(json['postcode']),
      address: _parseStringOrNull(json['address']),
    );

Map<String, dynamic> _$$OrganizerLocationDtoImplToJson(
        _$OrganizerLocationDtoImpl instance) =>
    <String, dynamic>{
      'city': instance.city,
      'country': instance.country,
      'postcode': instance.postcode,
      'address': instance.address,
    };

_$OrganizerPracticalInfoDtoImpl _$$OrganizerPracticalInfoDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizerPracticalInfoDtoImpl(
      pmr: json['pmr'] as bool? ?? false,
      pmrInfos: _parseStringOrNull(json['pmr_infos']),
      restauration: json['restauration'] as bool? ?? false,
      restaurationInfos: _parseStringOrNull(json['restauration_infos']),
      boisson: json['boisson'] as bool? ?? false,
      boissonInfos: _parseStringOrNull(json['boisson_infos']),
      stationnement: _parseStringOrNull(json['stationnement']),
      eventType: _parseStringOrNull(json['event_type']),
    );

Map<String, dynamic> _$$OrganizerPracticalInfoDtoImplToJson(
        _$OrganizerPracticalInfoDtoImpl instance) =>
    <String, dynamic>{
      'pmr': instance.pmr,
      'pmr_infos': instance.pmrInfos,
      'restauration': instance.restauration,
      'restauration_infos': instance.restaurationInfos,
      'boisson': instance.boisson,
      'boisson_infos': instance.boissonInfos,
      'stationnement': instance.stationnement,
      'event_type': instance.eventType,
    };

_$CoOrganizerDtoImpl _$$CoOrganizerDtoImplFromJson(Map<String, dynamic> json) =>
    _$CoOrganizerDtoImpl(
      id: json['id'] == null ? 0 : _parseInt(json['id']),
      name: json['name'] == null ? '' : _parseHtmlString(json['name']),
      logo: _parseStringOrNull(json['logo']),
      role: _parseStringOrNull(json['role']),
      roleLabel: _parseStringOrNull(json['role_label']),
      city: _parseStringOrNull(json['city']),
      profileUrl: _parseStringOrNull(json['profile_url']),
    );

Map<String, dynamic> _$$CoOrganizerDtoImplToJson(
        _$CoOrganizerDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'role': instance.role,
      'role_label': instance.roleLabel,
      'city': instance.city,
      'profile_url': instance.profileUrl,
    };

_$EventCapacityDtoImpl _$$EventCapacityDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EventCapacityDtoImpl(
      total: (json['total'] as num?)?.toInt(),
      available: (json['available'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$EventCapacityDtoImplToJson(
        _$EventCapacityDtoImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'available': instance.available,
    };

_$EventsResponseDtoImpl _$$EventsResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EventsResponseDtoImpl(
      events: (json['events'] as List<dynamic>)
          .map((e) => EventDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          PaginationDto.fromJson(json['pagination'] as Map<String, dynamic>),
      filtersApplied: _parseFiltersApplied(json['filters_applied']),
    );

Map<String, dynamic> _$$EventsResponseDtoImplToJson(
        _$EventsResponseDtoImpl instance) =>
    <String, dynamic>{
      'events': instance.events,
      'pagination': instance.pagination,
      'filters_applied': instance.filtersApplied,
    };

_$PaginationDtoImpl _$$PaginationDtoImplFromJson(Map<String, dynamic> json) =>
    _$PaginationDtoImpl(
      currentPage:
          json['current_page'] == null ? 1 : _parseInt(json['current_page']),
      perPage: json['per_page'] == null ? 10 : _parseInt(json['per_page']),
      totalItems:
          json['total_items'] == null ? 0 : _parseInt(json['total_items']),
      totalPages:
          json['total_pages'] == null ? 0 : _parseInt(json['total_pages']),
      hasNext: json['has_next'] == null ? false : _parseBool(json['has_next']),
      hasPrev: json['has_prev'] == null ? false : _parseBool(json['has_prev']),
    );

Map<String, dynamic> _$$PaginationDtoImplToJson(_$PaginationDtoImpl instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'per_page': instance.perPage,
      'total_items': instance.totalItems,
      'total_pages': instance.totalPages,
      'has_next': instance.hasNext,
      'has_prev': instance.hasPrev,
    };

_$FiltersResponseDtoImpl _$$FiltersResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$FiltersResponseDtoImpl(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => EventCategoryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      thematiques: (json['thematiques'] as List<dynamic>)
          .map((e) => ThematiqueDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      cities:
          (json['cities'] as List<dynamic>).map((e) => e as String).toList(),
      priceRange:
          PriceRangeDto.fromJson(json['price_range'] as Map<String, dynamic>),
      sortOptions: (json['sort_options'] as List<dynamic>)
          .map((e) => SortOptionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      additionalFilters: (json['additional_filters'] as List<dynamic>?)
          ?.map((e) => AdditionalFilterDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$FiltersResponseDtoImplToJson(
        _$FiltersResponseDtoImpl instance) =>
    <String, dynamic>{
      'categories': instance.categories,
      'thematiques': instance.thematiques,
      'cities': instance.cities,
      'price_range': instance.priceRange,
      'sort_options': instance.sortOptions,
      'additional_filters': instance.additionalFilters,
    };

_$ThematiqueDtoImpl _$$ThematiqueDtoImplFromJson(Map<String, dynamic> json) =>
    _$ThematiqueDtoImpl(
      id: json['id'] == null ? 0 : _parseInt(json['id']),
      name: json['name'] == null ? '' : _parseHtmlString(json['name']),
      slug: json['slug'] == null ? '' : _parseHtmlString(json['slug']),
      eventCount: _parseIntOrNull(json['event_count']),
    );

Map<String, dynamic> _$$ThematiqueDtoImplToJson(_$ThematiqueDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'event_count': instance.eventCount,
    };

_$PriceRangeDtoImpl _$$PriceRangeDtoImplFromJson(Map<String, dynamic> json) =>
    _$PriceRangeDtoImpl(
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
    );

Map<String, dynamic> _$$PriceRangeDtoImplToJson(_$PriceRangeDtoImpl instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
    };

_$SortOptionDtoImpl _$$SortOptionDtoImplFromJson(Map<String, dynamic> json) =>
    _$SortOptionDtoImpl(
      value: json['value'] as String,
      label: json['label'] as String,
    );

Map<String, dynamic> _$$SortOptionDtoImplToJson(_$SortOptionDtoImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
    };

_$AdditionalFilterDtoImpl _$$AdditionalFilterDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AdditionalFilterDtoImpl(
      key: json['key'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$AdditionalFilterDtoImplToJson(
        _$AdditionalFilterDtoImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'type': instance.type,
    };

_$CityDtoImpl _$$CityDtoImplFromJson(Map<String, dynamic> json) =>
    _$CityDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      parentId: (json['parent_id'] as num?)?.toInt(),
      eventCount: (json['event_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CityDtoImplToJson(_$CityDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'parent_id': instance.parentId,
      'event_count': instance.eventCount,
    };

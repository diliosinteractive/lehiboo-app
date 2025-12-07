// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventDtoImpl _$$EventDtoImplFromJson(Map<String, dynamic> json) =>
    _$EventDtoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      slug: json['slug'] as String,
      excerpt: json['excerpt'] as String?,
      featuredImage: _parseImage(json['featured_image']),
      category: json['category'] == null
          ? null
          : EventCategoryDto.fromJson(json['category'] as Map<String, dynamic>),
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
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isFavorite: json['is_favorite'] as bool? ?? false,
    );

Map<String, dynamic> _$$EventDtoImplToJson(_$EventDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'excerpt': instance.excerpt,
      'featured_image': instance.featuredImage,
      'category': instance.category,
      'dates': instance.dates,
      'location': instance.location,
      'pricing': instance.pricing,
      'availability': instance.availability,
      'ratings': instance.ratings,
      'organizer': instance.organizer,
      'tags': instance.tags,
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
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      display: json['display'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      isRecurring: json['is_recurring'] as bool? ?? false,
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
      isFree: json['is_free'] as bool? ?? false,
      min: (json['min'] as num?)?.toDouble() ?? 0,
      max: (json['max'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'EUR',
      display: json['display'] as String?,
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
      status: json['status'] as String?,
      totalCapacity: (json['total_capacity'] as num?)?.toInt(),
      spotsRemaining: (json['spots_remaining'] as num?)?.toInt(),
      percentageFilled: (json['percentage_filled'] as num?)?.toInt(),
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
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      eventCount: (json['event_count'] as num?)?.toInt(),
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
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$$EventOrganizerDtoImplToJson(
        _$EventOrganizerDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
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
      currentPage: (json['current_page'] as num).toInt(),
      perPage: (json['per_page'] as num).toInt(),
      totalItems: (json['total_items'] as num).toInt(),
      totalPages: (json['total_pages'] as num).toInt(),
      hasNext: json['has_next'] as bool? ?? false,
      hasPrev: json['has_prev'] as bool? ?? false,
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
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      eventCount: (json['event_count'] as num?)?.toInt(),
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

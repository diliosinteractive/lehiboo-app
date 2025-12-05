// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActivityDtoImpl _$$ActivityDtoImplFromJson(Map<String, dynamic> json) =>
    _$ActivityDtoImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      slug: json['slug'] as String,
      excerpt: json['excerpt'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      category: json['category'] == null
          ? null
          : ActivityCategoryDto.fromJson(
              json['category'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => TagDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      ageRange: json['ageRange'] == null
          ? null
          : AgeRangeDto.fromJson(json['ageRange'] as Map<String, dynamic>),
      audience: json['audience'] == null
          ? null
          : AudienceDto.fromJson(json['audience'] as Map<String, dynamic>),
      isFree: json['is_free'] as bool?,
      price: json['price'] == null
          ? null
          : PriceDto.fromJson(json['price'] as Map<String, dynamic>),
      indoorOutdoor: json['indoor_outdoor'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      city: json['city'] == null
          ? null
          : CityDto.fromJson(json['city'] as Map<String, dynamic>),
      partner: json['partner'] == null
          ? null
          : PartnerDto.fromJson(json['partner'] as Map<String, dynamic>),
      reservationMode: json['reservation_mode'] as String?,
      externalBookingUrl: json['external_booking_url'] as String?,
      bookingPhone: json['booking_phone'] as String?,
      bookingEmail: json['booking_email'] as String?,
      nextSlot: json['next_slot'] == null
          ? null
          : SlotDto.fromJson(json['next_slot'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ActivityDtoImplToJson(_$ActivityDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'excerpt': instance.excerpt,
      'description': instance.description,
      'image_url': instance.imageUrl,
      'category': instance.category,
      'tags': instance.tags,
      'ageRange': instance.ageRange,
      'audience': instance.audience,
      'is_free': instance.isFree,
      'price': instance.price,
      'indoor_outdoor': instance.indoorOutdoor,
      'duration_minutes': instance.durationMinutes,
      'city': instance.city,
      'partner': instance.partner,
      'reservation_mode': instance.reservationMode,
      'external_booking_url': instance.externalBookingUrl,
      'booking_phone': instance.bookingPhone,
      'booking_email': instance.bookingEmail,
      'next_slot': instance.nextSlot,
    };

_$PriceDtoImpl _$$PriceDtoImplFromJson(Map<String, dynamic> json) =>
    _$PriceDtoImpl(
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$$PriceDtoImplToJson(_$PriceDtoImpl instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
      'currency': instance.currency,
    };

_$SlotDtoImpl _$$SlotDtoImplFromJson(Map<String, dynamic> json) =>
    _$SlotDtoImpl(
      id: (json['id'] as num).toInt(),
      activityId: (json['activity_id'] as num).toInt(),
      startDateTime: DateTime.parse(json['start_date_time'] as String),
      endDateTime: DateTime.parse(json['end_date_time'] as String),
      capacityTotal: (json['capacity_total'] as num?)?.toInt(),
      capacityRemaining: (json['capacity_remaining'] as num?)?.toInt(),
      price: json['price'] == null
          ? null
          : PriceDto.fromJson(json['price'] as Map<String, dynamic>),
      indoorOutdoor: json['indoor_outdoor'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$SlotDtoImplToJson(_$SlotDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'activity_id': instance.activityId,
      'start_date_time': instance.startDateTime.toIso8601String(),
      'end_date_time': instance.endDateTime.toIso8601String(),
      'capacity_total': instance.capacityTotal,
      'capacity_remaining': instance.capacityRemaining,
      'price': instance.price,
      'indoor_outdoor': instance.indoorOutdoor,
      'status': instance.status,
    };

_$ActivityCategoryDtoImpl _$$ActivityCategoryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ActivityCategoryDtoImpl(
      id: (json['id'] as num).toInt(),
      slug: json['slug'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$ActivityCategoryDtoImplToJson(
        _$ActivityCategoryDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
    };

_$TagDtoImpl _$$TagDtoImplFromJson(Map<String, dynamic> json) => _$TagDtoImpl(
      id: (json['id'] as num).toInt(),
      slug: json['slug'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$TagDtoImplToJson(_$TagDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
    };

_$AgeRangeDtoImpl _$$AgeRangeDtoImplFromJson(Map<String, dynamic> json) =>
    _$AgeRangeDtoImpl(
      id: (json['id'] as num).toInt(),
      label: json['label'] as String,
      minAge: (json['min_age'] as num?)?.toInt(),
      maxAge: (json['max_age'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AgeRangeDtoImplToJson(_$AgeRangeDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'min_age': instance.minAge,
      'max_age': instance.maxAge,
    };

_$AudienceDtoImpl _$$AudienceDtoImplFromJson(Map<String, dynamic> json) =>
    _$AudienceDtoImpl(
      id: (json['id'] as num).toInt(),
      slug: json['slug'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$AudienceDtoImplToJson(_$AudienceDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
    };

_$CityDtoImpl _$$CityDtoImplFromJson(Map<String, dynamic> json) =>
    _$CityDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      region: json['region'] as String?,
    );

Map<String, dynamic> _$$CityDtoImplToJson(_$CityDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'lat': instance.lat,
      'lng': instance.lng,
      'region': instance.region,
    };

_$PartnerDtoImpl _$$PartnerDtoImplFromJson(Map<String, dynamic> json) =>
    _$PartnerDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      cityId: (json['city_id'] as num?)?.toInt(),
      website: json['website'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      verified: json['verified'] as bool?,
    );

Map<String, dynamic> _$$PartnerDtoImplToJson(_$PartnerDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'logo_url': instance.logoUrl,
      'city_id': instance.cityId,
      'website': instance.website,
      'email': instance.email,
      'phone': instance.phone,
      'verified': instance.verified,
    };

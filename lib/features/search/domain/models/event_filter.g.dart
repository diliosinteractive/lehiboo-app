// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FilterOptionImpl _$$FilterOptionImplFromJson(Map<String, dynamic> json) =>
    _$FilterOptionImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      slug: json['slug'] as String?,
      count: (json['count'] as num?)?.toInt(),
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$$FilterOptionImplToJson(_$FilterOptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'slug': instance.slug,
      'count': instance.count,
      'icon': instance.icon,
    };

_$EventFilterImpl _$$EventFilterImplFromJson(Map<String, dynamic> json) =>
    _$EventFilterImpl(
      searchQuery: json['searchQuery'] as String? ?? '',
      dateFilterType:
          $enumDecodeNullable(_$DateFilterTypeEnumMap, json['dateFilterType']),
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      priceFilterType: $enumDecodeNullable(
          _$PriceFilterTypeEnumMap, json['priceFilterType']),
      priceMin: (json['priceMin'] as num?)?.toDouble() ?? 0,
      priceMax: (json['priceMax'] as num?)?.toDouble() ?? 500,
      onlyFree: json['onlyFree'] as bool? ?? false,
      citySlug: json['citySlug'] as String?,
      cityName: json['cityName'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      radiusKm: (json['radiusKm'] as num?)?.toDouble() ?? 50,
      northEastLat: (json['northEastLat'] as num?)?.toDouble(),
      northEastLng: (json['northEastLng'] as num?)?.toDouble(),
      southWestLat: (json['southWestLat'] as num?)?.toDouble(),
      southWestLng: (json['southWestLng'] as num?)?.toDouble(),
      thematiquesSlugs: (json['thematiquesSlugs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      categoriesSlugs: (json['categoriesSlugs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      organizerSlug: json['organizerSlug'] as String?,
      organizerName: json['organizerName'] as String?,
      tagsSlugs: (json['tagsSlugs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      familyFriendly: json['familyFriendly'] as bool? ?? false,
      accessiblePMR: json['accessiblePMR'] as bool? ?? false,
      onlineOnly: json['onlineOnly'] as bool? ?? false,
      inPersonOnly: json['inPersonOnly'] as bool? ?? false,
      sortBy: $enumDecodeNullable(_$SortOptionEnumMap, json['sortBy']) ??
          SortOption.relevance,
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['perPage'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$$EventFilterImplToJson(_$EventFilterImpl instance) =>
    <String, dynamic>{
      'searchQuery': instance.searchQuery,
      'dateFilterType': _$DateFilterTypeEnumMap[instance.dateFilterType],
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'priceFilterType': _$PriceFilterTypeEnumMap[instance.priceFilterType],
      'priceMin': instance.priceMin,
      'priceMax': instance.priceMax,
      'onlyFree': instance.onlyFree,
      'citySlug': instance.citySlug,
      'cityName': instance.cityName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radiusKm': instance.radiusKm,
      'northEastLat': instance.northEastLat,
      'northEastLng': instance.northEastLng,
      'southWestLat': instance.southWestLat,
      'southWestLng': instance.southWestLng,
      'thematiquesSlugs': instance.thematiquesSlugs,
      'categoriesSlugs': instance.categoriesSlugs,
      'organizerSlug': instance.organizerSlug,
      'organizerName': instance.organizerName,
      'tagsSlugs': instance.tagsSlugs,
      'familyFriendly': instance.familyFriendly,
      'accessiblePMR': instance.accessiblePMR,
      'onlineOnly': instance.onlineOnly,
      'inPersonOnly': instance.inPersonOnly,
      'sortBy': _$SortOptionEnumMap[instance.sortBy]!,
      'page': instance.page,
      'perPage': instance.perPage,
    };

const _$DateFilterTypeEnumMap = {
  DateFilterType.today: 'today',
  DateFilterType.tomorrow: 'tomorrow',
  DateFilterType.thisWeek: 'thisWeek',
  DateFilterType.thisWeekend: 'thisWeekend',
  DateFilterType.thisMonth: 'thisMonth',
  DateFilterType.custom: 'custom',
};

const _$PriceFilterTypeEnumMap = {
  PriceFilterType.free: 'free',
  PriceFilterType.paid: 'paid',
  PriceFilterType.range: 'range',
};

const _$SortOptionEnumMap = {
  SortOption.relevance: 'relevance',
  SortOption.dateAsc: 'dateAsc',
  SortOption.dateDesc: 'dateDesc',
  SortOption.priceAsc: 'priceAsc',
  SortOption.priceDesc: 'priceDesc',
  SortOption.popularity: 'popularity',
  SortOption.distance: 'distance',
};

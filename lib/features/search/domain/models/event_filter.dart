import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_filter.freezed.dart';
part 'event_filter.g.dart';

const publicAudienceFilterKeys = <String>{
  'family',
  'pmr',
  'group',
  'school',
  'professional',
};

bool isPublicAudienceFilterKey(String value) =>
    publicAudienceFilterKeys.contains(value);

List<String> selectedPublicAudienceFilters(Iterable<String> values) {
  return values.where(isPublicAudienceFilterKey).toList(growable: false);
}

List<String> selectedTargetAudienceSlugs(Iterable<String> values) {
  return values
      .where((value) => !isPublicAudienceFilterKey(value))
      .toList(growable: false);
}

/// Represents a single filter option (city, thematique, etc.)
@freezed
class FilterOption with _$FilterOption {
  const factory FilterOption({
    required String id,
    required String label,
    String? slug,
    int? count,
    String? icon,
  }) = _FilterOption;

  factory FilterOption.fromJson(Map<String, dynamic> json) =>
      _$FilterOptionFromJson(json);
}

/// Date filter type
enum DateFilterType {
  today,
  tomorrow,
  thisWeek,
  thisWeekend,
  thisMonth,
  custom,
}

/// Price filter type
enum PriceFilterType {
  free,
  paid,
  range,
}

/// Sort options
enum SortOption {
  relevance,
  newest,
  dateAsc,
  dateDesc,
  priceAsc,
  priceDesc,
  popularity,
  distance,
}

/// Event venue/location type filter.
enum LocationTypeFilter {
  physical,
  offline,
  online,
  hybrid,
}

/// Main filter model - easily extensible
@freezed
class EventFilter with _$EventFilter {
  const EventFilter._();

  const factory EventFilter({
    // Text search
    @Default('') String searchQuery,

    // Date filters
    DateFilterType? dateFilterType,
    DateTime? startDate,
    DateTime? endDate,

    // Price filters
    PriceFilterType? priceFilterType,
    @Default(0) double priceMin,
    @Default(500) double priceMax,
    @Default(false) bool onlyFree,

    // Location filters
    String? citySlug,
    String? cityName,
    @Default(10) double cityRadiusKm,
    double? latitude,
    double? longitude,
    @Default(10) double radiusKm,

    // Bounding Box (Search this area)
    double? northEastLat,
    double? northEastLng,
    double? southWestLat,
    double? southWestLng,

    // Category filters (multi-select)
    @Default([]) List<String> thematiquesSlugs,
    @Default([]) List<String> categoriesSlugs,

    // Organizer filter
    String? organizerSlug,
    String? organizerName,

    // Tags filter (multi-select)
    @Default([]) List<String> tagsSlugs,

    // Web /events reference-data filters
    @Default([]) List<String> targetAudienceSlugs,
    String? eventTagSlug,
    @Default([]) List<String> specialEventSlugs,
    @Default([]) List<String> emotionSlugs,
    @Default(false) bool availableOnly,
    LocationTypeFilter? locationType,

    // Audience filter
    @Default(false) bool familyFriendly,
    @Default(false) bool accessiblePMR,

    // Online/In-person
    @Default(false) bool onlineOnly,
    @Default(false) bool inPersonOnly,

    // Sorting
    @Default(SortOption.dateAsc) SortOption sortBy,
    @Default(false) bool hasExplicitSort,

    // Pagination
    @Default(1) int page,
    @Default(20) int perPage,
  }) = _EventFilter;

  factory EventFilter.fromJson(Map<String, dynamic> json) =>
      _$EventFilterFromJson(json);

  /// Check if any filter is active
  bool get hasActiveFilters {
    return searchQuery.isNotEmpty ||
        dateFilterType != null ||
        priceFilterType != null ||
        onlyFree ||
        citySlug != null ||
        latitude != null ||
        northEastLat != null ||
        thematiquesSlugs.isNotEmpty ||
        categoriesSlugs.isNotEmpty ||
        organizerSlug != null ||
        tagsSlugs.isNotEmpty ||
        targetAudienceSlugs.isNotEmpty ||
        eventTagSlug != null ||
        specialEventSlugs.isNotEmpty ||
        emotionSlugs.isNotEmpty ||
        availableOnly ||
        locationType != null ||
        familyFriendly ||
        accessiblePMR ||
        onlineOnly ||
        inPersonOnly ||
        hasExplicitSort;
  }

  /// Count active filters
  int get activeFilterCount {
    final publicFilters = selectedPublicAudienceFilters(targetAudienceSlugs);
    int count = 0;
    if (searchQuery.isNotEmpty) count++;
    if (dateFilterType != null) count++;
    if (priceFilterType != null || onlyFree) count++;
    if (citySlug != null) count++;
    if (latitude != null) count++;
    if (thematiquesSlugs.isNotEmpty) count += thematiquesSlugs.length;
    if (categoriesSlugs.isNotEmpty) count += categoriesSlugs.length;
    if (organizerSlug != null) count++;
    if (tagsSlugs.isNotEmpty) count += tagsSlugs.length;
    if (targetAudienceSlugs.isNotEmpty) count += targetAudienceSlugs.length;
    if (eventTagSlug != null) count++;
    if (specialEventSlugs.isNotEmpty) count += specialEventSlugs.length;
    if (emotionSlugs.isNotEmpty) count += emotionSlugs.length;
    if (availableOnly) count++;
    if (locationType != null) count++;
    if (familyFriendly && !publicFilters.contains('family')) count++;
    if (accessiblePMR && !publicFilters.contains('pmr')) count++;
    if (onlineOnly || inPersonOnly) count++;
    if (hasExplicitSort) count++;
    return count;
  }

  SortOption get effectiveSortBy {
    if (hasExplicitSort) return sortBy;
    if (latitude != null && longitude != null) return SortOption.distance;
    return SortOption.dateAsc;
  }

  int get effectiveCityRadiusKm {
    final radius = cityRadiusKm.round();
    return const [5, 10, 20, 50].contains(radius) ? radius : 10;
  }

  DateTime? get effectiveStartDate {
    if (startDate != null) return startDate;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (dateFilterType) {
      case DateFilterType.today:
      case DateFilterType.thisWeek:
      case DateFilterType.thisMonth:
        return today;
      case DateFilterType.tomorrow:
        return today.add(const Duration(days: 1));
      case DateFilterType.thisWeekend:
        final daysUntilSaturday = (DateTime.saturday - today.weekday) % 7;
        return today.add(Duration(days: daysUntilSaturday));
      case DateFilterType.custom:
      case null:
        return null;
    }
  }

  DateTime? get effectiveEndDate {
    if (endDate != null) return endDate;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (dateFilterType) {
      case DateFilterType.today:
        return today;
      case DateFilterType.tomorrow:
        return today.add(const Duration(days: 1));
      case DateFilterType.thisWeek:
        return today.add(const Duration(days: 7));
      case DateFilterType.thisWeekend:
        final daysUntilSaturday = (DateTime.saturday - today.weekday) % 7;
        return today.add(Duration(days: daysUntilSaturday + 1));
      case DateFilterType.thisMonth:
        return DateTime(now.year, now.month + 1, 0);
      case DateFilterType.custom:
      case null:
        return null;
    }
  }

  /// Convert to API query parameters
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};

    if (searchQuery.isNotEmpty) {
      params['search'] = searchQuery;
    }

    // Date params
    final resolvedStartDate = effectiveStartDate;
    final resolvedEndDate = effectiveEndDate;
    if (resolvedStartDate != null) {
      params['date_from'] = resolvedStartDate.toIso8601String().split('T')[0];
    }
    if (resolvedEndDate != null) {
      params['date_to'] = resolvedEndDate.toIso8601String().split('T')[0];
    }

    // Price params
    if (onlyFree) {
      params['free_only'] = 1;
    } else if (priceFilterType == PriceFilterType.paid) {
      params['price_min'] = 0.01;
    } else if (priceFilterType == PriceFilterType.range ||
        priceMin > 0 ||
        priceMax < 500) {
      params['price_min'] = priceMin.toString();
      params['price_max'] = priceMax.toString();
    }

    // Location
    if (latitude != null && longitude != null) {
      params['lat'] = latitude.toString();
      params['lng'] = longitude.toString();
      params['radius'] = radiusKm.toString();
    } else if (citySlug != null) {
      params['location'] = citySlug;
      params['radius_km'] = effectiveCityRadiusKm.toString();
    }

    // Bounding Box
    if (northEastLat != null &&
        northEastLng != null &&
        southWestLat != null &&
        southWestLng != null) {
      params['north_east_lat'] = northEastLat.toString();
      params['north_east_lng'] = northEastLng.toString();
      params['south_west_lat'] = southWestLat.toString();
      params['south_west_lng'] = southWestLng.toString();
    }

    // Categories
    if (thematiquesSlugs.isNotEmpty) {
      params['thematique'] = thematiquesSlugs.join(',');
    }
    if (categoriesSlugs.isNotEmpty) {
      params['category'] = categoriesSlugs.join(',');
    }

    // Organizer
    if (organizerSlug != null) {
      params['organizer'] = organizerSlug;
    }

    // Tags
    if (tagsSlugs.isNotEmpty) {
      params['event_tag'] = tagsSlugs.join(',');
    }

    final publicFilters = selectedPublicAudienceFilters(targetAudienceSlugs);
    final targetAudiences = selectedTargetAudienceSlugs(targetAudienceSlugs);
    if (publicFilters.isNotEmpty) {
      params['public_filters'] = publicFilters.join(',');
    }
    if (targetAudiences.isNotEmpty) {
      params['target_audiences'] = targetAudiences.join(',');
    }
    if (eventTagSlug != null) {
      params['event_tag'] = eventTagSlug;
    }
    if (specialEventSlugs.isNotEmpty) {
      params['special_events'] = specialEventSlugs.join(',');
    }
    if (emotionSlugs.isNotEmpty) {
      params['emotions'] = emotionSlugs.join(',');
    }
    if (availableOnly) {
      params['available_only'] = 1;
    }
    if (locationType != null) {
      final venueType = venueTypeToApiValue(locationType!);
      if (venueType != null) {
        params['venue_type'] = venueType;
      } else {
        params['location_type'] = locationTypeToApiValue(locationType!);
      }
    }

    // Audience
    if (familyFriendly && !publicFilters.contains('family')) {
      params['family_friendly'] = 1;
    }
    if (accessiblePMR && !publicFilters.contains('pmr')) {
      params['accessible_pmr'] = 1;
    }

    // Online/In-person
    if (onlineOnly) {
      params['online'] = 1;
    }
    if (inPersonOnly) {
      params['in_person'] = 1;
    }

    // Sort
    params['sort'] = sortOptionToApiValue(effectiveSortBy);

    // Pagination
    params['page'] = page.toString();
    params['per_page'] = perPage.toString();

    return params;
  }
}

EventFilter eventFilterFromQueryParams(Map<String, String> query) {
  final dateFrom = _parseDate(query['date_from']);
  final dateTo = _parseDate(query['date_to']);
  final dateFilterType = _dateFilterFromQuery(query, dateFrom, dateTo);
  final lat = _parseDouble(query['lat']);
  final lng = _parseDouble(query['lng']);
  final location = query['city'] ?? query['location'];
  final cityRadiusKm = _cityRadiusFromQuery(query['radius_km']);
  final radiusKm = _parseDouble(query['radius']) ?? 10;
  final sort = _sortOptionFromApiValue(query['sort']);
  final priceMin = _parseDouble(query['price_min']) ?? 0;
  final priceMax = _parseDouble(query['price_max']) ?? 500;
  final onlyFree =
      _parseBool(query['is_free']) || _parseBool(query['free_only']);
  final hasPriceRange = priceMin > 0 || priceMax < 500;

  return EventFilter(
    searchQuery: query['search'] ?? '',
    dateFilterType: dateFilterType,
    startDate: dateFrom,
    endDate: dateTo,
    priceFilterType: onlyFree
        ? PriceFilterType.free
        : hasPriceRange
            ? PriceFilterType.range
            : null,
    priceMin: priceMin,
    priceMax: priceMax,
    onlyFree: onlyFree,
    citySlug: lat == null && lng == null ? location : null,
    cityName: lat == null && lng == null ? _cityLabel(location) : null,
    cityRadiusKm: cityRadiusKm,
    latitude: lat,
    longitude: lng,
    radiusKm: radiusKm,
    thematiquesSlugs: _csv(query['themes'] ?? query['thematique']),
    categoriesSlugs: _csv(query['category'] ?? query['categorySlug']),
    targetAudienceSlugs: [
      ..._csv(query['target_audiences']),
      ..._csv(query['public_filters']),
    ],
    eventTagSlug: _emptyToNull(query['event_tag']),
    specialEventSlugs: _csv(query['special_events']),
    emotionSlugs: _csv(query['emotions']),
    availableOnly: _parseBool(query['available_only']),
    locationType: _venueTypeFromApiValue(query['venue_type']) ??
        _locationTypeFromApiValue(query['location_type']),
    familyFriendly: _parseBool(query['family_friendly']),
    accessiblePMR: _parseBool(query['accessible_pmr']),
    onlineOnly: _parseBool(query['online']),
    inPersonOnly: _parseBool(query['in_person']),
    sortBy: sort ?? SortOption.dateAsc,
    hasExplicitSort: sort != null,
    page: _parseInt(query['page']) ?? 1,
    perPage: _parseInt(query['per_page']) ?? 20,
  );
}

String sortOptionToApiValue(SortOption option) {
  switch (option) {
    case SortOption.relevance:
      return 'relevance';
    case SortOption.newest:
      return 'published_at';
    case SortOption.dateAsc:
      return 'date_asc';
    case SortOption.dateDesc:
      return 'date_desc';
    case SortOption.priceAsc:
      return 'price_asc';
    case SortOption.priceDesc:
      return 'price_desc';
    case SortOption.popularity:
      return 'popularity';
    case SortOption.distance:
      return 'distance';
  }
}

String locationTypeToApiValue(LocationTypeFilter option) {
  switch (option) {
    case LocationTypeFilter.physical:
      return 'physical';
    case LocationTypeFilter.offline:
      return 'offline';
    case LocationTypeFilter.online:
      return 'online';
    case LocationTypeFilter.hybrid:
      return 'hybrid';
  }
}

String? venueTypeToApiValue(LocationTypeFilter option) {
  switch (option) {
    case LocationTypeFilter.physical:
      return 'indoor';
    case LocationTypeFilter.offline:
      return 'outdoor';
    case LocationTypeFilter.hybrid:
      return 'both';
    case LocationTypeFilter.online:
      return null;
  }
}

SortOption? _sortOptionFromApiValue(String? value) {
  switch (value) {
    case 'relevance':
      return SortOption.relevance;
    case 'published_at':
    case 'created_at':
      return SortOption.newest;
    case 'date_asc':
      return SortOption.dateAsc;
    case 'date_desc':
      return SortOption.dateDesc;
    case 'price_asc':
      return SortOption.priceAsc;
    case 'price_desc':
      return SortOption.priceDesc;
    case 'popularity':
      return SortOption.popularity;
    case 'distance':
      return SortOption.distance;
  }
  return null;
}

LocationTypeFilter? _venueTypeFromApiValue(String? value) {
  switch (value) {
    case 'indoor':
      return LocationTypeFilter.physical;
    case 'outdoor':
      return LocationTypeFilter.offline;
    case 'both':
      return LocationTypeFilter.hybrid;
  }
  return null;
}

LocationTypeFilter? _locationTypeFromApiValue(String? value) {
  switch (value) {
    case 'physical':
      return LocationTypeFilter.physical;
    case 'offline':
      return LocationTypeFilter.offline;
    case 'online':
      return LocationTypeFilter.online;
    case 'hybrid':
      return LocationTypeFilter.hybrid;
  }
  return null;
}

DateFilterType? _dateFilterFromQuery(
  Map<String, String> query,
  DateTime? dateFrom,
  DateTime? dateTo,
) {
  switch (query['date']) {
    case 'today':
      return DateFilterType.today;
    case 'tomorrow':
      return DateFilterType.tomorrow;
    case 'week':
      return DateFilterType.thisWeek;
    case 'weekend':
      return DateFilterType.thisWeekend;
    case 'month':
      return DateFilterType.thisMonth;
  }

  if (dateFrom != null || dateTo != null) return DateFilterType.custom;
  return null;
}

List<String> _csv(String? value) {
  if (value == null || value.trim().isEmpty) return const [];
  return value
      .split(',')
      .map((item) => item.trim())
      .where((item) => item.isNotEmpty)
      .toList();
}

DateTime? _parseDate(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}

double? _parseDouble(String? value) {
  if (value == null || value.isEmpty) return null;
  return double.tryParse(value);
}

double _cityRadiusFromQuery(String? value) {
  final parsed = _parseInt(value);
  if (parsed != null && const [5, 10, 20, 50].contains(parsed)) {
    return parsed.toDouble();
  }
  return 10;
}

int? _parseInt(String? value) {
  if (value == null || value.isEmpty) return null;
  return int.tryParse(value);
}

bool _parseBool(String? value) {
  if (value == null) return false;
  return value == '1' || value.toLowerCase() == 'true';
}

String? _emptyToNull(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return value;
}

String? _cityLabel(String? value) {
  if (value == null || value.isEmpty) return null;
  return value
      .split(RegExp(r'[-_\s]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}

/// Active filter chip model for UI display
@freezed
class ActiveFilterChip with _$ActiveFilterChip {
  const factory ActiveFilterChip({
    required String id,
    required String label,
    required FilterChipType type,
    String? value,
  }) = _ActiveFilterChip;
}

enum FilterChipType {
  search,
  date,
  price,
  city,
  location,
  thematique,
  category,
  organizer,
  tag,
  audience,
  format,
  eventTag,
  targetAudience,
  specialEvent,
  emotion,
  availability,
  locationType,
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_filter.freezed.dart';
part 'event_filter.g.dart';

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
  dateAsc,
  dateDesc,
  priceAsc,
  priceDesc,
  popularity,
  distance,
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
    double? latitude,
    double? longitude,
    @Default(50) double radiusKm,
    
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

    // Audience filter
    @Default(false) bool familyFriendly,
    @Default(false) bool accessiblePMR,

    // Online/In-person
    @Default(false) bool onlineOnly,
    @Default(false) bool inPersonOnly,

    // Sorting
    @Default(SortOption.relevance) SortOption sortBy,

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
        familyFriendly ||
        accessiblePMR ||
        onlineOnly ||
        inPersonOnly;
  }

  /// Count active filters
  int get activeFilterCount {
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
    if (familyFriendly) count++;
    if (accessiblePMR) count++;
    if (onlineOnly || inPersonOnly) count++;
    return count;
  }

  /// Get date filter label
  String? get dateFilterLabel {
    switch (dateFilterType) {
      case DateFilterType.today:
        return "Aujourd'hui";
      case DateFilterType.tomorrow:
        return 'Demain';
      case DateFilterType.thisWeek:
        return 'Cette semaine';
      case DateFilterType.thisWeekend:
        return 'Ce week-end';
      case DateFilterType.thisMonth:
        return 'Ce mois';
      case DateFilterType.custom:
        return 'Dates personnalisées';
      default:
        return null;
    }
  }

  /// Get price filter label
  String? get priceFilterLabel {
    if (onlyFree) return 'Gratuit';
    switch (priceFilterType) {
      case PriceFilterType.free:
        return 'Gratuit';
      case PriceFilterType.paid:
        return 'Payant';
      case PriceFilterType.range:
        return '${priceMin.toInt()}€ - ${priceMax.toInt()}€';
      default:
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
    if (startDate != null) {
      params['start_date'] = startDate!.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      params['end_date'] = endDate!.toIso8601String().split('T')[0];
    }

    // Price params
    if (onlyFree) {
      params['free'] = 'true';
    } else if (priceFilterType == PriceFilterType.range) {
      params['price_min'] = priceMin.toString();
      params['price_max'] = priceMax.toString();
    }

    // Location
    if (citySlug != null) {
      params['location'] = citySlug;
    }
    if (latitude != null && longitude != null) {
      params['lat'] = latitude.toString();
      params['lng'] = longitude.toString();
      params['radius'] = radiusKm.toString();
    }
    
    // Bounding Box
    if (northEastLat != null && northEastLng != null && southWestLat != null && southWestLng != null) {
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
      params['tags'] = tagsSlugs.join(',');
    }

    // Audience
    if (familyFriendly) {
      params['family_friendly'] = 'true';
    }
    if (accessiblePMR) {
      params['accessible_pmr'] = 'true';
    }

    // Online/In-person
    if (onlineOnly) {
      params['online'] = 'true';
    }
    if (inPersonOnly) {
      params['in_person'] = 'true';
    }

    // Sort
    params['sort'] = _sortOptionToString(sortBy);

    // Pagination
    params['page'] = page.toString();
    params['per_page'] = perPage.toString();

    return params;
  }

  String _sortOptionToString(SortOption option) {
    switch (option) {
      case SortOption.relevance:
        return 'relevance';
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
}

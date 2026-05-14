import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/events/data/models/event_reference_data_dto.dart';
import 'package:lehiboo/features/events/data/models/search_suggestions_dto.dart';
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import 'package:lehiboo/features/search/domain/models/event_filter.dart';
import 'package:lehiboo/features/thematiques/presentation/providers/thematiques_provider.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';

const _filterPersistenceKey = 'event_filter_state';
const _defaultPriceMax = 500.0;
const searchAutocompleteMinQueryLength = 3;

class SearchSuggestionsRequest {
  final String query;
  final String types;
  final int limit;

  const SearchSuggestionsRequest({
    required this.query,
    required this.types,
    this.limit = 5,
  });

  List<String> get typeList => types
      .split(',')
      .map((type) => type.trim())
      .where((type) => type.isNotEmpty)
      .toList();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SearchSuggestionsRequest &&
            other.query == query &&
            other.types == types &&
            other.limit == limit;
  }

  @override
  int get hashCode => Object.hash(query, types, limit);
}

T? _enumByName<T extends Enum>(List<T> values, Object? name) {
  if (name is! String) return null;

  for (final value in values) {
    if (value.name == name) return value;
  }

  return null;
}

String? _dateParam(DateTime? date) {
  if (date == null) return null;
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

double? _priceMinParam(EventFilter filter) {
  if (filter.onlyFree) return null;
  if (filter.priceFilterType == PriceFilterType.paid) return 0.01;
  if (_hasPriceRangeFilter(filter)) return filter.priceMin;
  return null;
}

double? _priceMaxParam(EventFilter filter) {
  if (filter.onlyFree || filter.priceFilterType == PriceFilterType.paid) {
    return null;
  }
  if (_hasPriceRangeFilter(filter)) return filter.priceMax;
  return null;
}

bool _hasPriceRangeFilter(EventFilter filter) {
  return filter.priceFilterType == PriceFilterType.range ||
      filter.priceMin > 0 ||
      filter.priceMax < _defaultPriceMax;
}

/// Main filter state provider
final eventFilterProvider =
    StateNotifierProvider<EventFilterNotifier, EventFilter>((ref) {
  return EventFilterNotifier();
});

/// Filter state notifier with all update methods and persistence
class EventFilterNotifier extends StateNotifier<EventFilter> {
  EventFilterNotifier() : super(const EventFilter()) {
    _loadPersistedFilters();
  }

  /// Load persisted filters from SharedPreferences
  Future<void> _loadPersistedFilters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filterJson = prefs.getString(_filterPersistenceKey);
      if (filterJson != null) {
        final filterMap = json.decode(filterJson) as Map<String, dynamic>;
        state = _fromJson(filterMap);
      }
    } catch (e) {
      // Ignore errors, use default filter
    }
  }

  /// Persist current filter state to SharedPreferences
  Future<void> _persistFilters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filterJson = json.encode(_toJson(state));
      await prefs.setString(_filterPersistenceKey, filterJson);
    } catch (e) {
      // Ignore persistence errors
    }
  }

  /// Convert filter to JSON for persistence (only persistent fields)
  Map<String, dynamic> _toJson(EventFilter filter) {
    return {
      'citySlug': filter.citySlug,
      'cityName': filter.cityName,
      'cityRadiusKm': filter.cityRadiusKm,
      'thematiquesSlugs': filter.thematiquesSlugs,
      'categoriesSlugs': filter.categoriesSlugs,
      'targetAudienceSlugs': filter.targetAudienceSlugs,
      'tagsSlugs': filter.tagsSlugs,
      'eventTagSlug': filter.eventTagSlug,
      'specialEventSlugs': filter.specialEventSlugs,
      'emotionSlugs': filter.emotionSlugs,
      'availableOnly': filter.availableOnly,
      'locationType': filter.locationType?.name,
      'onlyFree': filter.onlyFree,
      'priceMin': filter.priceMin,
      'priceMax': filter.priceMax,
      'priceFilterType': filter.priceFilterType?.name,
      'familyFriendly': filter.familyFriendly,
      'accessiblePMR': filter.accessiblePMR,
      'onlineOnly': filter.onlineOnly,
      'inPersonOnly': filter.inPersonOnly,
      'sortBy': filter.sortBy.name,
      'hasExplicitSort': filter.hasExplicitSort,
      // Don't persist: search query, dates, location (temporary filters)
    };
  }

  /// Create filter from JSON
  EventFilter _fromJson(Map<String, dynamic> json) {
    return EventFilter(
      citySlug: json['citySlug'] as String?,
      cityName: json['cityName'] as String?,
      cityRadiusKm: (json['cityRadiusKm'] as num?)?.toDouble() ?? 10,
      thematiquesSlugs:
          (json['thematiquesSlugs'] as List<dynamic>?)?.cast<String>() ?? [],
      categoriesSlugs:
          (json['categoriesSlugs'] as List<dynamic>?)?.cast<String>() ?? [],
      targetAudienceSlugs:
          (json['targetAudienceSlugs'] as List<dynamic>?)?.cast<String>() ?? [],
      tagsSlugs: (json['tagsSlugs'] as List<dynamic>?)?.cast<String>() ?? [],
      eventTagSlug: json['eventTagSlug'] as String?,
      specialEventSlugs:
          (json['specialEventSlugs'] as List<dynamic>?)?.cast<String>() ?? [],
      emotionSlugs:
          (json['emotionSlugs'] as List<dynamic>?)?.cast<String>() ?? [],
      availableOnly: json['availableOnly'] as bool? ?? false,
      locationType: _enumByName(
        LocationTypeFilter.values,
        json['locationType'],
      ),
      onlyFree: json['onlyFree'] as bool? ?? false,
      priceMin: (json['priceMin'] as num?)?.toDouble() ?? 0,
      priceMax: (json['priceMax'] as num?)?.toDouble() ?? _defaultPriceMax,
      priceFilterType: _enumByName(
        PriceFilterType.values,
        json['priceFilterType'],
      ),
      familyFriendly: json['familyFriendly'] as bool? ?? false,
      accessiblePMR: json['accessiblePMR'] as bool? ?? false,
      onlineOnly: json['onlineOnly'] as bool? ?? false,
      inPersonOnly: json['inPersonOnly'] as bool? ?? false,
      sortBy:
          _enumByName(SortOption.values, json['sortBy']) ?? SortOption.dateAsc,
      hasExplicitSort: json['hasExplicitSort'] as bool? ?? false,
    );
  }

  // Reset all filters
  void resetAll() {
    state = const EventFilter();
    _persistFilters();
  }

  // Search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearSearchQuery() {
    state = state.copyWith(searchQuery: '');
  }

  // Date filters
  void setDateFilter(DateFilterType type) {
    final now = DateTime.now();
    DateTime? start;
    DateTime? end;

    switch (type) {
      case DateFilterType.today:
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case DateFilterType.tomorrow:
        final tomorrow = now.add(const Duration(days: 1));
        start = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
        end = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 59, 59);
        break;
      case DateFilterType.thisWeek:
        start = DateTime(now.year, now.month, now.day);
        end = start.add(const Duration(days: 7));
        break;
      case DateFilterType.thisWeekend:
        // Find next Saturday
        int daysUntilSaturday = (DateTime.saturday - now.weekday) % 7;
        if (daysUntilSaturday == 0 && now.hour >= 18) daysUntilSaturday = 7;
        start = DateTime(now.year, now.month, now.day)
            .add(Duration(days: daysUntilSaturday));
        end = start.add(const Duration(days: 2));
        break;
      case DateFilterType.thisMonth:
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month + 1, 0);
        break;
      case DateFilterType.custom:
        // Custom dates will be set separately
        break;
    }

    state = state.copyWith(
      dateFilterType: type,
      startDate: start,
      endDate: end,
    );
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    state = state.copyWith(
      dateFilterType: DateFilterType.custom,
      startDate: start,
      endDate: end,
    );
  }

  void clearDateFilter() {
    state = state.copyWith(
      dateFilterType: null,
      startDate: null,
      endDate: null,
    );
  }

  // Price filters
  void setPriceFilter(PriceFilterType type, {double? min, double? max}) {
    state = state.copyWith(
      priceFilterType: type,
      priceMin: min ?? 0,
      priceMax: max ?? _defaultPriceMax,
      onlyFree: type == PriceFilterType.free,
    );
  }

  void setOnlyFree(bool value) {
    state = state.copyWith(
      onlyFree: value,
      priceFilterType: value ? PriceFilterType.free : null,
    );
    _persistFilters();
  }

  void setPriceRange(double min, double max) {
    state = state.copyWith(
      priceFilterType: PriceFilterType.range,
      priceMin: min,
      priceMax: max,
      onlyFree: false,
    );
    _persistFilters();
  }

  void clearPriceFilter() {
    state = state.copyWith(
      priceFilterType: null,
      priceMin: 0,
      priceMax: _defaultPriceMax,
      onlyFree: false,
    );
    _persistFilters();
  }

  // City filter
  void setCity(String slug, String name, {double radiusKm = 10}) {
    state = state.copyWith(
      citySlug: slug,
      cityName: name,
      cityRadiusKm: radiusKm,
      latitude: null,
      longitude: null,
    );
    _persistFilters();
  }

  void clearCity() {
    state = state.copyWith(
      citySlug: null,
      cityName: null,
    );
    _persistFilters();
  }

  // Location filter (GPS)
  void setLocation(double lat, double lng, double radius) {
    state = state.copyWith(
      latitude: lat,
      longitude: lng,
      radiusKm: radius,
      citySlug: null,
      cityName: null,
    );
  }

  void setBoundingBox(double neLat, double neLng, double swLat, double swLng) {
    state = state.copyWith(
      northEastLat: neLat,
      northEastLng: neLng,
      southWestLat: swLat,
      southWestLng: swLng,
      latitude: null, // Clear point search if using bounds
      longitude: null,
    );
  }

  void clearBoundingBox() {
    state = state.copyWith(
      northEastLat: null,
      northEastLng: null,
      southWestLat: null,
      southWestLng: null,
    );
  }

  void clearLocation() {
    state = state.copyWith(
      latitude: null,
      longitude: null,
      radiusKm: 10,
    );
  }

  // Thematiques (multi-select)
  void addThematique(String slug) {
    if (!state.thematiquesSlugs.contains(slug)) {
      state = state.copyWith(
        thematiquesSlugs: [...state.thematiquesSlugs, slug],
      );
      _persistFilters();
    }
  }

  void removeThematique(String slug) {
    state = state.copyWith(
      thematiquesSlugs: state.thematiquesSlugs.where((s) => s != slug).toList(),
    );
    _persistFilters();
  }

  void toggleThematique(String slug) {
    if (state.thematiquesSlugs.contains(slug)) {
      removeThematique(slug);
    } else {
      addThematique(slug);
    }
  }

  void clearThematiques() {
    state = state.copyWith(thematiquesSlugs: []);
    _persistFilters();
  }

  void setThematiques(List<String> slugs) {
    state = state.copyWith(thematiquesSlugs: slugs);
    _persistFilters();
  }

  // Categories (multi-select)
  void addCategory(String slug) {
    if (!state.categoriesSlugs.contains(slug)) {
      state = state.copyWith(
        categoriesSlugs: [...state.categoriesSlugs, slug],
      );
      _persistFilters();
    }
  }

  void removeCategory(String slug) {
    state = state.copyWith(
      categoriesSlugs: state.categoriesSlugs.where((s) => s != slug).toList(),
    );
    _persistFilters();
  }

  void toggleCategory(String slug) {
    if (state.categoriesSlugs.contains(slug)) {
      removeCategory(slug);
    } else {
      addCategory(slug);
    }
  }

  void clearCategories() {
    state = state.copyWith(categoriesSlugs: []);
    _persistFilters();
  }

  // Organizer
  void setOrganizer(String slug, String name) {
    state = state.copyWith(
      organizerSlug: slug,
      organizerName: name,
    );
  }

  void clearOrganizer() {
    state = state.copyWith(
      organizerSlug: null,
      organizerName: null,
    );
  }

  // Tags (multi-select)
  void addTag(String slug) {
    if (!state.tagsSlugs.contains(slug)) {
      state = state.copyWith(
        tagsSlugs: [...state.tagsSlugs, slug],
      );
      _persistFilters();
    }
  }

  void removeTag(String slug) {
    state = state.copyWith(
      tagsSlugs: state.tagsSlugs.where((s) => s != slug).toList(),
    );
    _persistFilters();
  }

  void toggleTag(String slug) {
    if (state.tagsSlugs.contains(slug)) {
      removeTag(slug);
    } else {
      addTag(slug);
    }
  }

  void clearTags() {
    state = state.copyWith(tagsSlugs: []);
    _persistFilters();
  }

  void setTags(List<String> slugs) {
    state = state.copyWith(tagsSlugs: slugs);
    _persistFilters();
  }

  void setTargetAudiences(List<String> slugs) {
    state = state.copyWith(targetAudienceSlugs: slugs);
    _persistFilters();
  }

  void setEventTag(String? slug) {
    state = state.copyWith(eventTagSlug: slug);
    _persistFilters();
  }

  void setSpecialEvents(List<String> slugs) {
    state = state.copyWith(specialEventSlugs: slugs);
    _persistFilters();
  }

  void setEmotions(List<String> slugs) {
    state = state.copyWith(emotionSlugs: slugs);
    _persistFilters();
  }

  void setAvailableOnly(bool value) {
    state = state.copyWith(availableOnly: value);
    _persistFilters();
  }

  void setLocationType(LocationTypeFilter? type) {
    state = state.copyWith(locationType: type);
    _persistFilters();
  }

  // Audience filters
  void setFamilyFriendly(bool value) {
    state = state.copyWith(familyFriendly: value);
    _persistFilters();
  }

  void setAccessiblePMR(bool value) {
    state = state.copyWith(accessiblePMR: value);
    _persistFilters();
  }

  // Format filters
  void setOnlineOnly(bool value) {
    state = state.copyWith(
      onlineOnly: value,
      inPersonOnly: value ? false : state.inPersonOnly,
    );
    _persistFilters();
  }

  void setInPersonOnly(bool value) {
    state = state.copyWith(
      inPersonOnly: value,
      onlineOnly: value ? false : state.onlineOnly,
    );
    _persistFilters();
  }

  // Sort
  void setSortOption(SortOption option) {
    state = state.copyWith(sortBy: option, hasExplicitSort: true);
    _persistFilters();
  }

  // Pagination
  void setPage(int page) {
    state = state.copyWith(page: page);
  }

  void nextPage() {
    state = state.copyWith(page: state.page + 1);
  }

  void resetPagination() {
    state = state.copyWith(page: 1);
  }

  // Apply multiple filters at once
  void applyFilters(EventFilter newFilter) {
    state = newFilter.copyWith(page: 1);
    _persistFilters();
  }

  // Remove a specific filter by type
  void removeFilterByType(FilterChipType type, {String? value}) {
    switch (type) {
      case FilterChipType.search:
        clearSearchQuery();
        break;
      case FilterChipType.date:
        clearDateFilter();
        break;
      case FilterChipType.price:
        clearPriceFilter();
        break;
      case FilterChipType.city:
        clearCity();
        break;
      case FilterChipType.location:
        clearLocation();
        break;
      case FilterChipType.thematique:
        if (value != null) {
          removeThematique(value);
        } else {
          clearThematiques();
        }
        break;
      case FilterChipType.category:
        if (value != null) {
          removeCategory(value);
        } else {
          clearCategories();
        }
        break;
      case FilterChipType.organizer:
        clearOrganizer();
        break;
      case FilterChipType.tag:
        if (value != null) {
          removeTag(value);
        } else {
          clearTags();
        }
        break;
      case FilterChipType.eventTag:
        setEventTag(null);
        break;
      case FilterChipType.targetAudience:
        if (value != null) {
          setTargetAudiences(
            state.targetAudienceSlugs.where((slug) => slug != value).toList(),
          );
        } else {
          setTargetAudiences(
            selectedPublicAudienceFilters(state.targetAudienceSlugs),
          );
        }
        break;
      case FilterChipType.specialEvent:
        if (value != null) {
          setSpecialEvents(
            state.specialEventSlugs.where((slug) => slug != value).toList(),
          );
        } else {
          setSpecialEvents(const []);
        }
        break;
      case FilterChipType.emotion:
        if (value != null) {
          setEmotions(
            state.emotionSlugs.where((slug) => slug != value).toList(),
          );
        } else {
          setEmotions(const []);
        }
        break;
      case FilterChipType.availability:
        setAvailableOnly(false);
        break;
      case FilterChipType.locationType:
        setLocationType(null);
        break;
      case FilterChipType.audience:
        setFamilyFriendly(false);
        setAccessiblePMR(false);
        break;
      case FilterChipType.format:
        setOnlineOnly(false);
        setInPersonOnly(false);
        break;
    }
  }
}

/// State class for paginated results
class PaginatedActivities {
  final List<Activity> activities;
  final bool hasMore;
  final bool isLoadingMore;
  final int totalItems;

  const PaginatedActivities({
    required this.activities,
    required this.hasMore,
    this.isLoadingMore = false,
    this.totalItems = 0,
  });

  PaginatedActivities copyWith({
    List<Activity>? activities,
    bool? hasMore,
    bool? isLoadingMore,
    int? totalItems,
  }) {
    return PaginatedActivities(
      activities: activities ?? this.activities,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalItems: totalItems ?? this.totalItems,
    );
  }
}

Future<EventsResult> _fetchEventsForFilter(
  EventRepository eventRepository,
  EventFilter filter, {
  int? page,
  int? perPage,
}) async {
  final dateFromStr = _dateParam(filter.effectiveStartDate);
  final dateToStr = _dateParam(filter.effectiveEndDate);
  final publicFilters =
      selectedPublicAudienceFilters(filter.targetAudienceSlugs);
  final targetAudiences =
      selectedTargetAudienceSlugs(filter.targetAudienceSlugs);
  final venueType = filter.locationType == null
      ? null
      : venueTypeToApiValue(filter.locationType!);

  return eventRepository.getEvents(
    search: filter.searchQuery.isNotEmpty ? filter.searchQuery : null,
    thematique: filter.thematiquesSlugs.isNotEmpty
        ? filter.thematiquesSlugs.join(',')
        : null,
    categorySlug: filter.categoriesSlugs.isNotEmpty
        ? filter.categoriesSlugs.join(',')
        : null,
    location: filter.citySlug,
    cityRadiusKm: filter.citySlug != null ? filter.effectiveCityRadiusKm : null,
    dateFrom: dateFromStr,
    dateTo: dateToStr,
    priceMin: _priceMinParam(filter),
    priceMax: _priceMaxParam(filter),
    freeOnly: filter.onlyFree ? true : null,
    familyFriendly: filter.familyFriendly && !publicFilters.contains('family')
        ? true
        : null,
    accessiblePmr:
        filter.accessiblePMR && !publicFilters.contains('pmr') ? true : null,
    onlineOnly: filter.onlineOnly ? true : null,
    inPersonOnly: filter.inPersonOnly ? true : null,
    publicFilters: publicFilters.isNotEmpty ? publicFilters.join(',') : null,
    targetAudiences:
        targetAudiences.isNotEmpty ? targetAudiences.join(',') : null,
    eventTag: filter.tagsSlugs.isNotEmpty
        ? filter.tagsSlugs.join(',')
        : filter.eventTagSlug,
    specialEvents: filter.specialEventSlugs.isNotEmpty
        ? filter.specialEventSlugs.join(',')
        : null,
    emotions:
        filter.emotionSlugs.isNotEmpty ? filter.emotionSlugs.join(',') : null,
    availableOnly: filter.availableOnly ? true : null,
    locationType: venueType == null && filter.locationType != null
        ? locationTypeToApiValue(filter.locationType!)
        : null,
    venueType: venueType,
    lat: filter.latitude,
    lng: filter.longitude,
    radius: filter.latitude != null ? filter.radiusKm.toInt() : null,
    northEastLat: filter.northEastLat,
    northEastLng: filter.northEastLng,
    southWestLat: filter.southWestLat,
    southWestLng: filter.southWestLng,
    sort: sortOptionToApiValue(filter.effectiveSortBy),
    perPage: perPage ?? filter.perPage,
    page: page ?? filter.page,
  );
}

/// Notifier for filtered events results with pagination support
final filteredEventsProvider =
    AsyncNotifierProvider<FilteredEventsNotifier, PaginatedActivities>(() {
  return FilteredEventsNotifier();
});

class FilteredEventsNotifier extends AsyncNotifier<PaginatedActivities> {
  @override
  Future<PaginatedActivities> build() async {
    final filter = ref.watch(eventFilterProvider);
    final eventRepository = ref.watch(eventRepositoryProvider);

    // If it's a new search, or if we are verifying valid initial build
    // But wait, if page > 1, it means we triggered loadMore.
    // BUT ref.watch(filter) will trigger rebuild every time page increments in filter.
    // So we need to handle that.

    // Actually, `EventFilterNotifier` updates state.page which triggers this build.
    // If page == 1, it's a fresh search.
    // If page > 1, it's a load more.

    // HOWEVER, we need to access the *previous* state data to append if page > 1.
    final previousActivities = state.valueOrNull?.activities ?? [];

    try {
      final result = await _fetchEventsForFilter(eventRepository, filter);

      final newActivities = EventToActivityMapper.toActivities(result.events);
      final hasMore = result.hasNext;

      if (filter.page == 1) {
        // New search: Replace everything
        return PaginatedActivities(
          activities: newActivities,
          hasMore: hasMore,
          totalItems: result.totalItems,
        );
      } else {
        // Load more: Append
        return PaginatedActivities(
          activities: [...previousActivities, ...newActivities],
          hasMore: hasMore,
          totalItems: result.totalItems,
        );
      }
    } catch (e) {
      if (filter.page > 1) {
        // If error during load more, keep existing list but maybe show error?
        // For now return existing valid state but stop loading
        return PaginatedActivities(
          activities: previousActivities,
          hasMore: false, // Prevent infinite error loops
          totalItems:
              state.valueOrNull?.totalItems ?? previousActivities.length,
        );
      }
      rethrow;
    }
  }
}

final eventReferenceDataProvider =
    FutureProvider.autoDispose<EventReferenceDataDto>((ref) async {
  final eventRepository = ref.watch(eventRepositoryProvider);
  final result = await eventRepository.getEventReferenceData(onlyOnline: true);
  ref.keepAlive();
  return result;
});

final searchSuggestionsProvider = FutureProvider.autoDispose
    .family<SearchSuggestionsDto, SearchSuggestionsRequest>(
        (ref, request) async {
  final query = request.query.trim();
  if (query.length < searchAutocompleteMinQueryLength) {
    return const SearchSuggestionsDto.empty();
  }

  await Future<void>.delayed(const Duration(milliseconds: 250));

  final eventRepository = ref.watch(eventRepositoryProvider);
  return eventRepository.getSearchSuggestions(
    query: query,
    types: request.typeList,
    limit: request.limit,
  );
});

final filterPreviewCountProvider =
    FutureProvider.autoDispose.family<int, EventFilter>((ref, filter) async {
  final eventRepository = ref.watch(eventRepositoryProvider);

  await Future<void>.delayed(const Duration(milliseconds: 350));

  final result = await _fetchEventsForFilter(
    eventRepository,
    filter,
    page: 1,
    perPage: 1,
  );
  return result.totalItems;
});

/// Provider for active filter chips (for UI display)
final activeFilterChipsProvider = Provider<List<ActiveFilterChip>>((ref) {
  final filter = ref.watch(eventFilterProvider);
  final chips = <ActiveFilterChip>[];
  final needsReferenceLabels = filter.thematiquesSlugs.isNotEmpty ||
      filter.categoriesSlugs.isNotEmpty ||
      filter.tagsSlugs.isNotEmpty ||
      filter.eventTagSlug != null ||
      filter.targetAudienceSlugs.isNotEmpty ||
      filter.specialEventSlugs.isNotEmpty ||
      filter.emotionSlugs.isNotEmpty;
  final referenceData = needsReferenceLabels
      ? ref.watch(eventReferenceDataProvider).valueOrNull
      : null;
  final categoryLabels = referenceData == null
      ? const <String, String>{}
      : _categoryLabelMap(referenceData.categories);
  final themeLabels = referenceData == null
      ? const <String, String>{}
      : _optionLabelMap(referenceData.themes);
  final eventTagLabels = referenceData == null
      ? const <String, String>{}
      : _optionLabelMap(referenceData.eventTags);
  final targetAudienceLabels = referenceData == null
      ? const <String, String>{}
      : _audienceLabelMap(referenceData.audienceGroups);
  final publicFilterLabels = referenceData == null
      ? _fallbackPublicFilterLabelMap()
      : _publicFilterLabelMap(referenceData.publicFilters);
  final selectedPublicFilters =
      selectedPublicAudienceFilters(filter.targetAudienceSlugs);
  final specialEventLabels = referenceData == null
      ? const <String, String>{}
      : _optionLabelMap(referenceData.specialEvents);
  final emotionLabels = referenceData == null
      ? const <String, String>{}
      : _optionLabelMap(referenceData.emotions);

  // Search stays in the search bar, like web /events; it is not duplicated here.

  // Date filter: quick date chips are already visible, so only custom ranges
  // get an active-filter chip.
  final showDateRangeChip = filter.dateFilterType == DateFilterType.custom ||
      (filter.dateFilterType == null &&
          (filter.startDate != null || filter.endDate != null));
  if (showDateRangeChip) {
    final from = _dateParam(filter.effectiveStartDate) ?? '...';
    final to = _dateParam(filter.effectiveEndDate) ?? '...';
    chips.add(ActiveFilterChip(
      id: 'date',
      label: '$from → $to',
      type: FilterChipType.date,
    ));
  }

  // Price filter
  if (filter.priceFilterLabel != null) {
    chips.add(ActiveFilterChip(
      id: 'price',
      label: filter.priceFilterLabel!,
      type: FilterChipType.price,
    ));
  }

  // City
  if (filter.cityName != null) {
    chips.add(ActiveFilterChip(
      id: 'city',
      label: filter.cityName!,
      type: FilterChipType.city,
      value: filter.effectiveCityRadiusKm.toString(),
    ));
  }

  // Location (geolocation)
  if (filter.latitude != null && filter.longitude != null) {
    chips.add(ActiveFilterChip(
      id: 'location',
      label: 'location',
      type: FilterChipType.location,
      value: filter.radiusKm.toInt().toString(),
    ));
  }

  // Thematiques
  if (filter.thematiquesSlugs.isNotEmpty) {
    chips.add(ActiveFilterChip(
      id: 'thematique',
      label: _joinedLabels(filter.thematiquesSlugs, themeLabels),
      type: FilterChipType.thematique,
    ));
  }

  // Categories
  if (filter.categoriesSlugs.isNotEmpty) {
    chips.add(ActiveFilterChip(
      id: 'category',
      label: _joinedLabels(filter.categoriesSlugs, categoryLabels),
      type: FilterChipType.category,
    ));
  }

  // Organizer
  if (filter.organizerName != null) {
    chips.add(ActiveFilterChip(
      id: 'organizer',
      label: filter.organizerName!,
      type: FilterChipType.organizer,
    ));
  }

  // Tags
  if (filter.tagsSlugs.isNotEmpty) {
    chips.add(ActiveFilterChip(
      id: 'tag',
      label: _joinedLabels(filter.tagsSlugs, eventTagLabels),
      type: FilterChipType.tag,
    ));
  }

  if (filter.eventTagSlug != null) {
    chips.add(ActiveFilterChip(
      id: 'event_tag',
      label: eventTagLabels[filter.eventTagSlug!] ??
          _slugToDisplayName(filter.eventTagSlug!),
      type: FilterChipType.eventTag,
      value: filter.eventTagSlug,
    ));
  }

  if (filter.targetAudienceSlugs.isNotEmpty) {
    final targetAudiences =
        selectedTargetAudienceSlugs(filter.targetAudienceSlugs);

    for (final publicFilter in selectedPublicFilters) {
      chips.add(ActiveFilterChip(
        id: 'public_filter_$publicFilter',
        label: publicFilterLabels[publicFilter] ??
            _slugToDisplayName(publicFilter),
        type: FilterChipType.targetAudience,
        value: publicFilter,
      ));
    }

    if (targetAudiences.isNotEmpty) {
      chips.add(ActiveFilterChip(
        id: 'target_audience',
        label: _joinedLabels(targetAudiences, targetAudienceLabels),
        type: FilterChipType.targetAudience,
      ));
    }
  }

  if (filter.specialEventSlugs.isNotEmpty) {
    chips.add(ActiveFilterChip(
      id: 'special_event',
      label: _joinedLabels(filter.specialEventSlugs, specialEventLabels),
      type: FilterChipType.specialEvent,
    ));
  }

  if (filter.emotionSlugs.isNotEmpty) {
    chips.add(ActiveFilterChip(
      id: 'emotion',
      label: _joinedLabels(filter.emotionSlugs, emotionLabels),
      type: FilterChipType.emotion,
    ));
  }

  if (filter.availableOnly) {
    chips.add(const ActiveFilterChip(
      id: 'available_only',
      label: 'available_only',
      type: FilterChipType.availability,
    ));
  }

  if (filter.locationType != null) {
    chips.add(ActiveFilterChip(
      id: 'location_type',
      label: _locationTypeLabel(filter.locationType!),
      type: FilterChipType.locationType,
      value: filter.locationType!.name,
    ));
  }

  // Audience
  if (filter.familyFriendly && !selectedPublicFilters.contains('family')) {
    chips.add(const ActiveFilterChip(
      id: 'family',
      label: 'En famille',
      type: FilterChipType.audience,
    ));
  }
  if (filter.accessiblePMR && !selectedPublicFilters.contains('pmr')) {
    chips.add(const ActiveFilterChip(
      id: 'pmr',
      label: 'Accessible PMR',
      type: FilterChipType.audience,
    ));
  }

  // Format
  if (filter.onlineOnly) {
    chips.add(const ActiveFilterChip(
      id: 'online',
      label: 'online',
      type: FilterChipType.format,
    ));
  }
  if (filter.inPersonOnly) {
    chips.add(const ActiveFilterChip(
      id: 'in_person',
      label: 'in_person',
      type: FilterChipType.format,
    ));
  }

  return chips;
});

Map<String, String> _categoryLabelMap(
  List<EventReferenceCategoryDto> categories,
) {
  final labels = <String, String>{};

  void collect(EventReferenceCategoryDto category) {
    labels[category.slug] = category.name;
    for (final child in category.children) {
      collect(child);
    }
  }

  for (final category in categories) {
    collect(category);
  }

  return labels;
}

Map<String, String> _optionLabelMap(List<EventReferenceOptionDto> options) {
  return {
    for (final option in options)
      if (option.slug.isNotEmpty) option.slug: option.name,
  };
}

Map<String, String> _audienceLabelMap(
  List<EventReferenceAudienceGroupDto> groups,
) {
  return {
    for (final group in groups)
      for (final audience in group.audiences)
        if (audience.slug.isNotEmpty) audience.slug: audience.name,
  };
}

Map<String, String> _publicFilterLabelMap(
  List<EventReferencePublicFilterDto> filters,
) {
  final labels = Map<String, String>.of(_fallbackPublicFilterLabelMap());
  for (final filter in filters) {
    final value = filter.value.isNotEmpty ? filter.value : filter.key;
    if (value.isNotEmpty && filter.label.isNotEmpty) {
      labels[value] = filter.label;
    }
  }
  return labels;
}

Map<String, String> _fallbackPublicFilterLabelMap() {
  return const {
    'family': 'En famille',
    'pmr': 'Accessible PMR',
    'group': 'En groupe',
    'school': 'Groupe scolaire',
    'professional': 'Professionnel',
  };
}

String _joinedLabels(List<String> slugs, Map<String, String> labels) {
  return slugs
      .map((slug) => labels[slug] ?? _slugToDisplayName(slug))
      .join(', ');
}

String _slugToDisplayName(String slug) {
  return slug
      .split(RegExp(r'[-_\s]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}

String _locationTypeLabel(LocationTypeFilter type) {
  switch (type) {
    case LocationTypeFilter.physical:
      return 'En intérieur';
    case LocationTypeFilter.offline:
      return 'En extérieur';
    case LocationTypeFilter.online:
      return 'En ligne';
    case LocationTypeFilter.hybrid:
      return 'Mixte (intérieur/extérieur)';
  }
}

/// Provider for available filter options
final filterOptionsProvider = Provider<FilterOptionsData>((ref) {
  final thematiques = ref.watch(thematiquesProvider);
  final categories = ref.watch(categoriesProvider);
  final cities = ref.watch(homeCitiesProvider);

  return FilterOptionsData(
    thematiques: thematiques.valueOrNull ?? [],
    categories: categories.valueOrNull ?? [],
    cities: cities.valueOrNull ?? [],
  );
});

class FilterOptionsData {
  final List<dynamic> thematiques;
  final List<EventCategoryInfo> categories;
  final List<dynamic> cities;

  FilterOptionsData({
    required this.thematiques,
    required this.categories,
    required this.cities,
  });
}

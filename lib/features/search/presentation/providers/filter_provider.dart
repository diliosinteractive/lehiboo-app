import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import 'package:lehiboo/features/search/domain/models/event_filter.dart';
import 'package:lehiboo/features/thematiques/presentation/providers/thematiques_provider.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';

const _filterPersistenceKey = 'event_filter_state';

/// Main filter state provider
final eventFilterProvider = StateNotifierProvider<EventFilterNotifier, EventFilter>((ref) {
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
      'thematiquesSlugs': filter.thematiquesSlugs,
      'categoriesSlugs': filter.categoriesSlugs,
      'onlyFree': filter.onlyFree,
      'priceMin': filter.priceMin,
      'priceMax': filter.priceMax,
      'familyFriendly': filter.familyFriendly,
      'accessiblePMR': filter.accessiblePMR,
      // Don't persist: search query, dates, location (temporary filters)
    };
  }

  /// Create filter from JSON
  EventFilter _fromJson(Map<String, dynamic> json) {
    return EventFilter(
      citySlug: json['citySlug'] as String?,
      cityName: json['cityName'] as String?,
      thematiquesSlugs: (json['thematiquesSlugs'] as List<dynamic>?)?.cast<String>() ?? [],
      categoriesSlugs: (json['categoriesSlugs'] as List<dynamic>?)?.cast<String>() ?? [],
      onlyFree: json['onlyFree'] as bool? ?? false,
      priceMin: (json['priceMin'] as num?)?.toDouble() ?? 0,
      priceMax: (json['priceMax'] as num?)?.toDouble() ?? 1000,
      familyFriendly: json['familyFriendly'] as bool? ?? false,
      accessiblePMR: json['accessiblePMR'] as bool? ?? false,
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
        start = DateTime(now.year, now.month, now.day).add(Duration(days: daysUntilSaturday));
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
      priceMax: max ?? 1000,
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
      priceMax: 1000,
      onlyFree: false,
    );
    _persistFilters();
  }

  // City filter
  void setCity(String slug, String name) {
    state = state.copyWith(
      citySlug: slug,
      cityName: name,
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

  void clearLocation() {
    state = state.copyWith(
      latitude: null,
      longitude: null,
      radiusKm: 50,
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
    }
  }

  void removeTag(String slug) {
    state = state.copyWith(
      tagsSlugs: state.tagsSlugs.where((s) => s != slug).toList(),
    );
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
  }

  void setInPersonOnly(bool value) {
    state = state.copyWith(
      inPersonOnly: value,
      onlineOnly: value ? false : state.onlineOnly,
    );
  }

  // Sort
  void setSortOption(SortOption option) {
    state = state.copyWith(sortBy: option);
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
    state = newFilter;
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
        if (value != null) removeThematique(value);
        break;
      case FilterChipType.category:
        if (value != null) removeCategory(value);
        break;
      case FilterChipType.organizer:
        clearOrganizer();
        break;
      case FilterChipType.tag:
        if (value != null) removeTag(value);
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

  const PaginatedActivities({
    required this.activities,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  PaginatedActivities copyWith({
    List<Activity>? activities,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PaginatedActivities(
      activities: activities ?? this.activities,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Notifier for filtered events results with pagination support
final filteredEventsProvider = AsyncNotifierProvider<FilteredEventsNotifier, PaginatedActivities>(() {
  return FilteredEventsNotifier();
});

class FilteredEventsNotifier extends AsyncNotifier<PaginatedActivities> {
  // Keep track of the *current* filter hash/signature to detect changes
  // We can't rely just on ref.watch in build() because we manipulate state
  // differently for page changes vs filter changes.
  EventFilter? _lastFilter;

  @override
  Future<PaginatedActivities> build() async {
    final filter = ref.watch(eventFilterProvider);
    final eventRepository = ref.watch(eventRepositoryProvider);
    
    // Check if keys changed (excluding page)
    final isNewSearch = _isDifferentSearch(filter);
    _lastFilter = filter;

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
      // Prepare query params
      String? dateFromStr;
      String? dateToStr;
      if (filter.startDate != null) {
        dateFromStr = '${filter.startDate!.year}-${filter.startDate!.month.toString().padLeft(2, '0')}-${filter.startDate!.day.toString().padLeft(2, '0')}';
      }
      if (filter.endDate != null) {
        dateToStr = '${filter.endDate!.year}-${filter.endDate!.month.toString().padLeft(2, '0')}-${filter.endDate!.day.toString().padLeft(2, '0')}';
      }

      final result = await eventRepository.getEvents(
        search: filter.searchQuery.isNotEmpty ? filter.searchQuery : null,
        thematique: filter.thematiquesSlugs.isNotEmpty ? filter.thematiquesSlugs.first : null,
        categorySlug: filter.categoriesSlugs.isNotEmpty ? filter.categoriesSlugs.first : null,
        location: filter.citySlug,
        dateFrom: dateFromStr,
        dateTo: dateToStr,
        lat: filter.latitude,
        lng: filter.longitude,
        radius: filter.latitude != null ? filter.radiusKm.toInt() : null,
        perPage: filter.perPage,
        page: filter.page,
      );

      final newActivities = EventToActivityMapper.toActivities(result.events);
      final hasMore = result.hasNext; 

      if (filter.page == 1) {
        // New search: Replace everything
        return PaginatedActivities(
          activities: newActivities,
          hasMore: hasMore,
        );
      } else {
        // Load more: Append
        return PaginatedActivities(
          activities: [...previousActivities, ...newActivities],
          hasMore: hasMore,
        );
      }
    } catch (e) {
      if (filter.page > 1) {
         // If error during load more, keep existing list but maybe show error?
         // For now return existing valid state but stop loading
         return PaginatedActivities(
           activities: previousActivities,
           hasMore: false, // Prevent infinite error loops
         );
      }
      rethrow;
    }
  }

  bool _isDifferentSearch(EventFilter current) {
    if (_lastFilter == null) return true;
    final last = _lastFilter!;
    // If page changed but nothing else, it is NOT a "new search" in the sense of reset
    if (current.page != last.page) return false;
    
    // Otherwise check for equality of everything else (simplified check works if copyWith works well)
    // Actually, if reference changed and it's not page, it's likely a filter change.
    // But since `EventFilter` is immutable and we use Freezed-like pattern manually,
    // simplistic check is:
    return current.searchQuery != last.searchQuery ||
           current.citySlug != last.citySlug ||
           current.thematiquesSlugs.toString() != last.thematiquesSlugs.toString(); 
           // ... others. 
           // In practice, since build() is re-triggered, we mainly care about `current.page`
  }
}

/// Provider for active filter chips (for UI display)
final activeFilterChipsProvider = Provider<List<ActiveFilterChip>>((ref) {
  final filter = ref.watch(eventFilterProvider);
  final chips = <ActiveFilterChip>[];

  // Search query
  if (filter.searchQuery.isNotEmpty) {
    chips.add(ActiveFilterChip(
      id: 'search',
      label: '"${filter.searchQuery}"',
      type: FilterChipType.search,
    ));
  }

  // Date filter
  if (filter.dateFilterLabel != null) {
    chips.add(ActiveFilterChip(
      id: 'date',
      label: filter.dateFilterLabel!,
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
    ));
  }

  // Location (geolocation)
  if (filter.latitude != null && filter.longitude != null) {
    chips.add(ActiveFilterChip(
      id: 'location',
      label: 'Autour de moi (${filter.radiusKm.toInt()} km)',
      type: FilterChipType.location,
    ));
  }

  // Thematiques
  for (final slug in filter.thematiquesSlugs) {
    chips.add(ActiveFilterChip(
      id: 'thematique_$slug',
      label: slug, // Will be replaced with actual name in UI
      type: FilterChipType.thematique,
      value: slug,
    ));
  }

  // Categories
  for (final slug in filter.categoriesSlugs) {
    chips.add(ActiveFilterChip(
      id: 'category_$slug',
      label: slug,
      type: FilterChipType.category,
      value: slug,
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
  for (final slug in filter.tagsSlugs) {
    chips.add(ActiveFilterChip(
      id: 'tag_$slug',
      label: slug,
      type: FilterChipType.tag,
      value: slug,
    ));
  }

  // Audience
  if (filter.familyFriendly) {
    chips.add(const ActiveFilterChip(
      id: 'family',
      label: 'Famille',
      type: FilterChipType.audience,
    ));
  }
  if (filter.accessiblePMR) {
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
      label: 'En ligne',
      type: FilterChipType.format,
    ));
  }
  if (filter.inPersonOnly) {
    chips.add(const ActiveFilterChip(
      id: 'in_person',
      label: 'En présentiel',
      type: FilterChipType.format,
    ));
  }

  return chips;
});

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

import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/repositories/event_repository.dart';
import 'package:lehiboo/features/events/data/models/event_reference_data_dto.dart';
import 'package:lehiboo/features/events/data/models/search_suggestions_dto.dart';
import 'package:lehiboo/features/events/data/mappers/event_to_activity_mapper.dart';
import 'package:lehiboo/features/search/domain/models/event_filter.dart';
import 'package:lehiboo/features/thematiques/presentation/providers/thematiques_provider.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_provider.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';

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

final _searchSessionBoundaryProvider =
    NotifierProvider<_SearchSessionBoundaryNotifier, Object>(
  _SearchSessionBoundaryNotifier.new,
);

/// Opaque boundary that rotates for every exact account-id transition.
///
/// Unlike a derived `String?` provider, this cannot collapse an A -> B -> A
/// sequence back to the original value before dependants rebuild. Profile
/// updates for the same account do not discard the user's active search.
class _SearchSessionBoundaryNotifier extends Notifier<Object> {
  String? _accountId;

  @override
  Object build() {
    _accountId = _authenticatedAccountId(ref.read(authProvider));
    ref.listen<AuthState>(authProvider, (_, next) {
      final nextAccountId = _authenticatedAccountId(next);
      if (nextAccountId == _accountId) return;
      _accountId = nextAccountId;
      state = Object();
    });
    return Object();
  }

  String? _authenticatedAccountId(AuthState auth) {
    if (!auth.isAuthenticated) return null;
    final accountId = auth.user?.id.trim();
    return accountId == null || accountId.isEmpty ? null : accountId;
  }
}

/// Main filter state provider
final eventFilterProvider =
    StateNotifierProvider<EventFilterNotifier, EventFilter>((ref) {
  // Recreate the draft on every exact session transition (including A → B
  // without an unauthenticated frame). Persistent, non-sensitive preferences
  // are rehydrated below; query, dates, GPS/bounds, selected event and other
  // ephemeral fields start clean.
  ref.watch(_searchSessionBoundaryProvider);
  return EventFilterNotifier(ref);
});

class SelectedSearchEvent {
  final String id;
  final String slug;
  final String title;

  const SelectedSearchEvent({
    required this.id,
    required this.slug,
    required this.title,
  });

  factory SelectedSearchEvent.fromSuggestion(
    SearchSuggestionItemDto suggestion,
  ) {
    return SelectedSearchEvent(
      id: suggestion.id,
      slug: suggestion.slug,
      title: suggestion.label,
    );
  }

  String get identifier => slug.isNotEmpty ? slug : id;
}

final selectedSearchEventProvider = StateProvider<SelectedSearchEvent?>((ref) {
  ref.watch(_searchSessionBoundaryProvider);
  return null;
});

/// Filter state notifier with all update methods and persistence
class EventFilterNotifier extends StateNotifier<EventFilter> {
  EventFilterNotifier([this._ref]) : super(const EventFilter()) {
    _loadPersistedFilters();
  }

  final Ref? _ref;

  /// Load persisted filters from SharedPreferences
  Future<void> _loadPersistedFilters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filterJson = prefs.getString(_filterPersistenceKey);
      if (filterJson != null) {
        final filterMap = json.decode(filterJson) as Map<String, dynamic>;
        if (!mounted) return;
        state = _fromJson(filterMap);
      }
    } catch (e) {
      // Ignore errors, use default filter
    }
  }

  /// Persist current filter state to SharedPreferences
  Future<void> _persistFilters() async {
    final snapshot = state;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      final filterJson = json.encode(_toJson(snapshot));
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
      // Don't persist: search query, dates, location, sort (temporary filters)
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
    );
  }

  /// Applique un changement de critère de recherche.
  ///
  /// Toute modification des critères invalide le curseur de pagination :
  /// [FilteredEventsNotifier] **concatène** les résultats quand `page > 1`.
  /// Garder une page obsolète laisserait les résultats du filtre précédent en
  /// tête de liste, ce qui donne l'impression que le nouveau filtre (ville,
  /// position, catégorie...) est ignoré ou mis en cache.
  void _applyFilterChange(EventFilter next, {bool persist = false}) {
    state = next.page == 1 ? next : next.copyWith(page: 1);
    if (persist) _persistFilters();
  }

  // Reset all filters
  void resetAll() {
    _clearSelectedSearchEvent();
    state = const EventFilter();
    _persistFilters();
  }

  // Search query
  void setSearchQuery(String query) {
    final selectedEvent = _ref?.read(selectedSearchEventProvider);
    if (selectedEvent != null && selectedEvent.title.trim() != query.trim()) {
      _clearSelectedSearchEvent();
    }
    _applyFilterChange(state.copyWith(searchQuery: query));
  }

  void selectSearchEvent(SelectedSearchEvent event) {
    _ref?.read(selectedSearchEventProvider.notifier).state = event;
    _applyFilterChange(state.copyWith(searchQuery: event.title));
  }

  void clearSearchQuery() {
    _clearSelectedSearchEvent();
    _applyFilterChange(state.copyWith(searchQuery: ''));
  }

  void _clearSelectedSearchEvent() {
    _ref?.read(selectedSearchEventProvider.notifier).state = null;
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

    _applyFilterChange(state.copyWith(
      dateFilterType: type,
      startDate: start,
      endDate: end,
    ));
  }

  void setCustomDateRange(DateTime start, DateTime end) {
    _applyFilterChange(state.copyWith(
      dateFilterType: DateFilterType.custom,
      startDate: start,
      endDate: end,
    ));
  }

  void clearDateFilter() {
    _applyFilterChange(state.copyWith(
      dateFilterType: null,
      startDate: null,
      endDate: null,
    ));
  }

  // Price filters
  void setPriceFilter(PriceFilterType type, {double? min, double? max}) {
    _applyFilterChange(state.copyWith(
      priceFilterType: type,
      priceMin: min ?? 0,
      priceMax: max ?? _defaultPriceMax,
      onlyFree: type == PriceFilterType.free,
    ));
  }

  void setOnlyFree(bool value) {
    _applyFilterChange(
      state.copyWith(
        onlyFree: value,
        priceFilterType: value ? PriceFilterType.free : null,
      ),
      persist: true,
    );
  }

  void setPriceRange(double min, double max) {
    _applyFilterChange(
      state.copyWith(
        priceFilterType: PriceFilterType.range,
        priceMin: min,
        priceMax: max,
        onlyFree: false,
      ),
      persist: true,
    );
  }

  void clearPriceFilter() {
    _applyFilterChange(
      state.copyWith(
        priceFilterType: null,
        priceMin: 0,
        priceMax: _defaultPriceMax,
        onlyFree: false,
      ),
      persist: true,
    );
  }

  // City filter
  void setCity(String slug, String name, {double radiusKm = 10}) {
    // Choisir une ville remplace toute autre intention de localisation :
    // le point GPS et la zone de carte ("rechercher dans cette zone") sont
    // envoyés en plus à l'API et écraseraient le filtre ville.
    _applyFilterChange(
      state.copyWith(
        citySlug: slug,
        cityName: name,
        cityRadiusKm: radiusKm,
        latitude: null,
        longitude: null,
        northEastLat: null,
        northEastLng: null,
        southWestLat: null,
        southWestLng: null,
      ),
      persist: true,
    );
  }

  void clearCity() {
    _applyFilterChange(
      state.copyWith(
        citySlug: null,
        cityName: null,
      ),
      persist: true,
    );
  }

  // Location filter (GPS)
  void setLocation(double lat, double lng, double radius) {
    // Même règle que [setCity] : une recherche autour d'un point annule la
    // ville et la zone de carte précédentes.
    _applyFilterChange(state.copyWith(
      latitude: lat,
      longitude: lng,
      radiusKm: radius,
      citySlug: null,
      cityName: null,
      northEastLat: null,
      northEastLng: null,
      southWestLat: null,
      southWestLng: null,
    ));
  }

  void setBoundingBox(double neLat, double neLng, double swLat, double swLng) {
    _applyFilterChange(state.copyWith(
      northEastLat: neLat,
      northEastLng: neLng,
      southWestLat: swLat,
      southWestLng: swLng,
      latitude: null, // Clear point search if using bounds
      longitude: null,
    ));
  }

  void clearBoundingBox() {
    _applyFilterChange(state.copyWith(
      northEastLat: null,
      northEastLng: null,
      southWestLat: null,
      southWestLng: null,
    ));
  }

  void clearLocation() {
    _applyFilterChange(state.copyWith(
      latitude: null,
      longitude: null,
      radiusKm: 10,
    ));
  }

  // Thematiques (multi-select)
  void addThematique(String slug) {
    if (!state.thematiquesSlugs.contains(slug)) {
      _applyFilterChange(
        state.copyWith(
          thematiquesSlugs: [...state.thematiquesSlugs, slug],
        ),
        persist: true,
      );
    }
  }

  void removeThematique(String slug) {
    _applyFilterChange(
      state.copyWith(
        thematiquesSlugs:
            state.thematiquesSlugs.where((s) => s != slug).toList(),
      ),
      persist: true,
    );
  }

  void toggleThematique(String slug) {
    if (state.thematiquesSlugs.contains(slug)) {
      removeThematique(slug);
    } else {
      addThematique(slug);
    }
  }

  void clearThematiques() {
    _applyFilterChange(state.copyWith(thematiquesSlugs: []), persist: true);
  }

  void setThematiques(List<String> slugs) {
    _applyFilterChange(state.copyWith(thematiquesSlugs: slugs), persist: true);
  }

  // Categories (multi-select)
  void addCategory(String slug) {
    if (!state.categoriesSlugs.contains(slug)) {
      _applyFilterChange(
        state.copyWith(
          categoriesSlugs: [...state.categoriesSlugs, slug],
        ),
        persist: true,
      );
    }
  }

  void removeCategory(String slug) {
    _applyFilterChange(
      state.copyWith(
        categoriesSlugs: state.categoriesSlugs.where((s) => s != slug).toList(),
      ),
      persist: true,
    );
  }

  void toggleCategory(String slug) {
    if (state.categoriesSlugs.contains(slug)) {
      removeCategory(slug);
    } else {
      addCategory(slug);
    }
  }

  void clearCategories() {
    _applyFilterChange(state.copyWith(categoriesSlugs: []), persist: true);
  }

  // Organizer
  void setOrganizer(String slug, String name) {
    _applyFilterChange(state.copyWith(
      organizerSlug: slug,
      organizerName: name,
    ));
  }

  void clearOrganizer() {
    _applyFilterChange(state.copyWith(
      organizerSlug: null,
      organizerName: null,
    ));
  }

  // Tags (multi-select)
  void addTag(String slug) {
    if (!state.tagsSlugs.contains(slug)) {
      _applyFilterChange(
        state.copyWith(
          tagsSlugs: [...state.tagsSlugs, slug],
        ),
        persist: true,
      );
    }
  }

  void removeTag(String slug) {
    _applyFilterChange(
      state.copyWith(
        tagsSlugs: state.tagsSlugs.where((s) => s != slug).toList(),
      ),
      persist: true,
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
    _applyFilterChange(state.copyWith(tagsSlugs: []), persist: true);
  }

  void setTags(List<String> slugs) {
    _applyFilterChange(state.copyWith(tagsSlugs: slugs), persist: true);
  }

  void setTargetAudiences(List<String> slugs) {
    _applyFilterChange(
      state.copyWith(targetAudienceSlugs: slugs),
      persist: true,
    );
  }

  void setEventTag(String? slug) {
    _applyFilterChange(state.copyWith(eventTagSlug: slug), persist: true);
  }

  void setSpecialEvents(List<String> slugs) {
    _applyFilterChange(state.copyWith(specialEventSlugs: slugs), persist: true);
  }

  void setEmotions(List<String> slugs) {
    _applyFilterChange(state.copyWith(emotionSlugs: slugs), persist: true);
  }

  void setAvailableOnly(bool value) {
    _applyFilterChange(state.copyWith(availableOnly: value), persist: true);
  }

  void setLocationType(LocationTypeFilter? type) {
    _applyFilterChange(state.copyWith(locationType: type), persist: true);
  }

  // Audience filters
  void setFamilyFriendly(bool value) {
    _applyFilterChange(state.copyWith(familyFriendly: value), persist: true);
  }

  void setAccessiblePMR(bool value) {
    _applyFilterChange(state.copyWith(accessiblePMR: value), persist: true);
  }

  // Format filters
  void setOnlineOnly(bool value) {
    _applyFilterChange(
      state.copyWith(
        onlineOnly: value,
        inPersonOnly: value ? false : state.inPersonOnly,
      ),
      persist: true,
    );
  }

  void setInPersonOnly(bool value) {
    _applyFilterChange(
      state.copyWith(
        inPersonOnly: value,
        onlineOnly: value ? false : state.onlineOnly,
      ),
      persist: true,
    );
  }

  // Sort
  void setSortOption(SortOption option) {
    _applyFilterChange(
      state.copyWith(sortBy: option, hasExplicitSort: true),
      persist: true,
    );
  }

  void resetSortToDefault({bool persist = true}) {
    _applyFilterChange(
      state.copyWith(
        sortBy: SortOption.dateAsc,
        hasExplicitSort: false,
      ),
      persist: persist,
    );
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
  void applyFilters(
    EventFilter newFilter, {
    SelectedSearchEvent? selectedSearchEvent,
  }) {
    final nextSearchQuery = newFilter.searchQuery.trim();
    final currentSelectedEvent = _ref?.read(selectedSearchEventProvider);
    if (selectedSearchEvent != null &&
        selectedSearchEvent.title.trim() == nextSearchQuery) {
      _ref?.read(selectedSearchEventProvider.notifier).state =
          selectedSearchEvent;
    } else if (currentSelectedEvent != null &&
        currentSelectedEvent.title.trim() == nextSearchQuery) {
      _ref?.read(selectedSearchEventProvider.notifier).state =
          currentSelectedEvent;
    } else {
      _clearSelectedSearchEvent();
    }
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
const _paginatedActivitiesNotProvided = Object();

class PaginatedActivities {
  final List<Activity> activities;
  final bool hasMore;
  final bool isLoadingMore;
  final int totalItems;
  final Object? loadMoreError;

  const PaginatedActivities({
    required this.activities,
    required this.hasMore,
    this.isLoadingMore = false,
    this.totalItems = 0,
    this.loadMoreError,
  });

  PaginatedActivities copyWith({
    List<Activity>? activities,
    bool? hasMore,
    bool? isLoadingMore,
    int? totalItems,
    Object? loadMoreError = _paginatedActivitiesNotProvided,
  }) {
    return PaginatedActivities(
      activities: activities ?? this.activities,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalItems: totalItems ?? this.totalItems,
      loadMoreError: identical(
        loadMoreError,
        _paginatedActivitiesNotProvided,
      )
          ? this.loadMoreError
          : loadMoreError,
    );
  }
}

const _emptyPaginatedActivities = PaginatedActivities(
  activities: [],
  hasMore: false,
);

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
final filteredEventsProvider = StateNotifierProvider<FilteredEventsNotifier,
    AsyncValue<PaginatedActivities>>((ref) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  final eventRepository = ref.watch(eventRepositoryProvider);
  final notifier = FilteredEventsNotifier(
    eventRepository,
    ownerSession: ownerSession,
    initialFilter: ref.read(eventFilterProvider),
    initialSelectedSearchEvent: ref.read(selectedSearchEventProvider),
  );

  void scheduleCurrentRequest() {
    notifier.scheduleLoad(
      filter: ref.read(eventFilterProvider),
      selectedSearchEvent: ref.read(selectedSearchEventProvider),
    );
  }

  ref.listen<EventFilter>(eventFilterProvider, (_, __) {
    scheduleCurrentRequest();
  });
  ref.listen<SelectedSearchEvent?>(selectedSearchEventProvider, (_, __) {
    scheduleCurrentRequest();
  });
  return notifier;
});

class FilteredEventsNotifier
    extends StateNotifier<AsyncValue<PaginatedActivities>> {
  FilteredEventsNotifier(
    this._eventRepository, {
    required this.ownerSession,
    required EventFilter initialFilter,
    required SelectedSearchEvent? initialSelectedSearchEvent,
  }) : super(const AsyncValue.loading()) {
    _currentLoad = _load(
      initialFilter,
      initialSelectedSearchEvent,
    );
    unawaited(_currentLoad);
  }

  final EventRepository _eventRepository;
  final AuthSessionKey ownerSession;
  int _requestGeneration = 0;
  int _scheduledLoadGeneration = 0;
  late Future<void> _currentLoad;

  Future<void> waitForCurrentLoad() => _currentLoad;

  void scheduleLoad({
    required EventFilter filter,
    required SelectedSearchEvent? selectedSearchEvent,
  }) {
    final scheduledGeneration = ++_scheduledLoadGeneration;
    _currentLoad = Future<void>.microtask(() async {
      if (!mounted || scheduledGeneration != _scheduledLoadGeneration) return;
      await _load(filter, selectedSearchEvent);
    });
  }

  Future<void> _load(
    EventFilter filter,
    SelectedSearchEvent? selectedSearchEvent,
  ) async {
    if (!mounted) return;
    final requestGeneration = ++_requestGeneration;
    final previous = state.valueOrNull;
    final previousActivities = previous?.activities ?? const <Activity>[];
    if (filter.page == 1 || previous == null) {
      state = const AsyncValue.loading();
    } else {
      state = const AsyncLoading<PaginatedActivities>().copyWithPrevious(
        AsyncData(previous),
      );
    }

    if (_isSelectedSearchEventActive(selectedSearchEvent, filter)) {
      try {
        final selectedResult = await _fetchSelectedSearchEvent(
          _eventRepository,
          filter,
          selectedSearchEvent!,
          requestGeneration,
        );
        if (!_ownsRequest(requestGeneration)) return;
        state = AsyncData(selectedResult);
      } catch (error, stackTrace) {
        if (!_ownsRequest(requestGeneration)) return;
        state = AsyncError(error, stackTrace);
      }
      return;
    }

    try {
      final result = await _fetchEventsForFilter(_eventRepository, filter);
      if (!_ownsRequest(requestGeneration)) return;

      final newActivities = EventToActivityMapper.toActivities(result.events);
      final hasMore = result.hasNext;

      if (filter.page == 1) {
        // New search: Replace everything
        state = AsyncData(
          PaginatedActivities(
            activities: newActivities,
            hasMore: hasMore,
            totalItems: result.totalItems,
          ),
        );
      } else {
        // Load more: Append
        state = AsyncData(
          PaginatedActivities(
            activities: [...previousActivities, ...newActivities],
            hasMore: hasMore,
            totalItems: result.totalItems,
          ),
        );
      }
    } catch (error, stackTrace) {
      if (!_ownsRequest(requestGeneration)) return;
      if (filter.page > 1) {
        // Keep the existing page visible and expose a retryable footer. Do not
        // claim that there are no more results or advance to the next page.
        state = AsyncData(
          PaginatedActivities(
            activities: previousActivities,
            hasMore: previous?.hasMore ?? true,
            totalItems: previous?.totalItems ?? previousActivities.length,
            loadMoreError: error,
          ),
        );
      } else {
        state = AsyncError(error, stackTrace);
      }
    }
  }

  bool _ownsRequest(int requestGeneration) =>
      mounted && requestGeneration == _requestGeneration;

  bool _isSelectedSearchEventActive(
    SelectedSearchEvent? selectedSearchEvent,
    EventFilter filter,
  ) {
    return selectedSearchEvent != null &&
        selectedSearchEvent.identifier.isNotEmpty &&
        selectedSearchEvent.title.trim() == filter.searchQuery.trim();
  }

  Future<PaginatedActivities> _fetchSelectedSearchEvent(
    EventRepository eventRepository,
    EventFilter filter,
    SelectedSearchEvent selectedSearchEvent,
    int requestGeneration,
  ) async {
    try {
      final event = await eventRepository.getEvent(
        selectedSearchEvent.identifier,
      );
      if (!_ownsRequest(requestGeneration)) {
        return _emptyPaginatedActivities;
      }
      return _singlePageActivities([event]);
    } catch (_) {
      if (!_ownsRequest(requestGeneration)) {
        return _emptyPaginatedActivities;
      }
      final result = await _fetchEventsForFilter(
        eventRepository,
        filter.copyWith(page: 1, perPage: 100),
        page: 1,
        perPage: 100,
      );
      if (!_ownsRequest(requestGeneration)) {
        return _emptyPaginatedActivities;
      }
      final exactEvents = result.events.where((event) {
        return event.slug == selectedSearchEvent.slug ||
            event.id == selectedSearchEvent.id ||
            _normalizeSearchText(event.title) ==
                _normalizeSearchText(selectedSearchEvent.title);
      }).toList();
      return _singlePageActivities(exactEvents);
    }
  }

  PaginatedActivities _singlePageActivities(List<Event> events) {
    final activities = EventToActivityMapper.toActivities(events);
    return PaginatedActivities(
      activities: activities,
      hasMore: false,
      totalItems: activities.length,
    );
  }

  String _normalizeSearchText(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }
}

final eventReferenceDataProvider =
    FutureProvider.autoDispose<EventReferenceDataDto>((ref) async {
  final eventRepository = ref.watch(eventRepositoryProvider);
  final result = await eventRepository.getEventReferenceData(onlyOnline: true);
  ref.keepAlive();
  return result;
});

typedef _SearchSuggestionsSessionQuery = ({
  AuthSessionKey ownerSession,
  SearchSuggestionsRequest request,
});

final _searchSuggestionsForSessionProvider = FutureProvider.autoDispose
    .family<SearchSuggestionsDto, _SearchSuggestionsSessionQuery>(
        (ref, query) async {
  final ownerSession = query.ownerSession;
  final request = query.request;
  if (!identical(ref.read(authSessionKeyProvider), ownerSession)) {
    return const SearchSuggestionsDto.empty();
  }
  var requestActive = true;
  ref.onDispose(() => requestActive = false);
  final eventRepository = ref.watch(eventRepositoryProvider);
  final searchText = request.query.trim();
  if (searchText.length < searchAutocompleteMinQueryLength) {
    return const SearchSuggestionsDto.empty();
  }

  await Future<void>.delayed(const Duration(milliseconds: 250));
  if (!requestActive ||
      !identical(ref.read(authSessionKeyProvider), ownerSession)) {
    return const SearchSuggestionsDto.empty();
  }

  final suggestions = await eventRepository.getSearchSuggestions(
    query: searchText,
    types: request.typeList,
    limit: request.limit,
  );
  if (!requestActive ||
      !identical(ref.read(authSessionKeyProvider), ownerSession)) {
    return const SearchSuggestionsDto.empty();
  }
  return suggestions;
});

/// Synchronous exact-session wrapper.
///
/// Watching the session from inside one [FutureProvider] instance would let
/// Riverpod retain that instance's previous value while it reloads. Selecting
/// a new session-keyed instance instead starts with a genuinely empty loading
/// state, including after a rapid A -> B -> A transition.
final searchSuggestionsProvider = Provider.autoDispose
    .family<AsyncValue<SearchSuggestionsDto>, SearchSuggestionsRequest>(
        (ref, request) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  return ref.watch(
    _searchSuggestionsForSessionProvider(
      (ownerSession: ownerSession, request: request),
    ),
  );
});

typedef _FilterPreviewSessionQuery = ({
  AuthSessionKey ownerSession,
  EventFilter filter,
});

final _filterPreviewCountForSessionProvider = FutureProvider.autoDispose
    .family<int, _FilterPreviewSessionQuery>((ref, query) async {
  final ownerSession = query.ownerSession;
  if (!identical(ref.read(authSessionKeyProvider), ownerSession)) return 0;
  var requestActive = true;
  ref.onDispose(() => requestActive = false);
  final eventRepository = ref.watch(eventRepositoryProvider);

  await Future<void>.delayed(const Duration(milliseconds: 350));
  if (!requestActive ||
      !identical(ref.read(authSessionKeyProvider), ownerSession)) {
    return 0;
  }

  final result = await _fetchEventsForFilter(
    eventRepository,
    query.filter,
    page: 1,
    perPage: 1,
  );
  if (!requestActive ||
      !identical(ref.read(authSessionKeyProvider), ownerSession)) {
    return 0;
  }
  return result.totalItems;
});

/// Synchronous exact-session wrapper; see [searchSuggestionsProvider].
final filterPreviewCountProvider =
    Provider.autoDispose.family<AsyncValue<int>, EventFilter>((ref, filter) {
  final ownerSession = ref.watch(authSessionKeyProvider);
  return ref.watch(
    _filterPreviewCountForSessionProvider(
      (ownerSession: ownerSession, filter: filter),
    ),
  );
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
  final priceChip = _priceChipValue(filter);
  if (priceChip != null) {
    chips.add(ActiveFilterChip(
      id: 'price',
      label: priceChip,
      type: FilterChipType.price,
      value: priceChip,
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
      label: filter.locationType!.name,
      type: FilterChipType.locationType,
      value: filter.locationType!.name,
    ));
  }

  // Audience
  if (filter.familyFriendly && !selectedPublicFilters.contains('family')) {
    chips.add(const ActiveFilterChip(
      id: 'family',
      label: 'family',
      type: FilterChipType.audience,
    ));
  }
  if (filter.accessiblePMR && !selectedPublicFilters.contains('pmr')) {
    chips.add(const ActiveFilterChip(
      id: 'pmr',
      label: 'pmr',
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
    'family': 'family',
    'pmr': 'pmr',
    'group': 'group',
    'school': 'school',
    'professional': 'professional',
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

String? _priceChipValue(EventFilter filter) {
  if (filter.onlyFree) return 'free';

  return switch (filter.priceFilterType) {
    PriceFilterType.free => 'free',
    PriceFilterType.paid => 'paid',
    PriceFilterType.range =>
      'range:${apiAmountText(filter.priceMin)}:${apiAmountText(filter.priceMax)}',
    null => null,
  };
}

/// Provider for available filter options
final filterOptionsProvider = Provider<FilterOptionsData>((ref) {
  final thematiques = ref.watch(thematiquesProvider);
  final categories = ref.watch(categoriesProvider);
  final popularCities = ref.watch(popularCitiesProvider);

  return FilterOptionsData(
    thematiques: thematiques.valueOrNull ?? [],
    categories: categories.valueOrNull ?? [],
    cities: popularCities.valueOrNull?.cities ?? [],
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

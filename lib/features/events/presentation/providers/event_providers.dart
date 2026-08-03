import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../domain/repositories/event_repository.dart';
import '../../../search/presentation/providers/filter_provider.dart';
import '../../../search/domain/models/event_filter.dart';

const _defaultPriceMax = 500.0;

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

final eventsProvider = StateNotifierProvider.autoDispose<_MapEventsController,
    AsyncValue<EventsResult>>((ref) {
  // Map results can contain member-only events. Recreate synchronously with a
  // blank loading state whenever the opaque auth session changes.
  ref.watch(authSessionKeyProvider);
  final repository = ref.watch(eventRepositoryProvider);
  final filter = ref.watch(eventFilterProvider);
  return _MapEventsController(repository, filter);
});

class _MapEventsController extends StateNotifier<AsyncValue<EventsResult>> {
  _MapEventsController(this._repository, this._filter)
      : super(const AsyncValue.loading()) {
    unawaited(_load());
  }

  final EventRepository _repository;
  final EventFilter _filter;
  int _requestGeneration = 0;

  Future<void> _load() async {
    if (!mounted) return;
    final requestGeneration = ++_requestGeneration;
    state = const AsyncValue.loading();

    // Use filter values to fetch events
    // Note: We might need to handle pagination here or just fetch the first page for the map
    // Ideally, the map might need a specific provider if we want to fetch HUGE amounts of data or clustering.
    // For now, let's reuse the filter provider but maybe force a larger perPage for the map coverage.
    final publicFilters =
        selectedPublicAudienceFilters(_filter.targetAudienceSlugs);
    final targetAudiences =
        selectedTargetAudienceSlugs(_filter.targetAudienceSlugs);
    final venueType = _filter.locationType == null
        ? null
        : venueTypeToApiValue(_filter.locationType!);

    try {
      final result = await _repository.getEvents(
        page: 1,
        perPage: 50, // Fetch more events for the map
        search: _filter.searchQuery,
        // categoryId: filter.categoryId, // EventFilter uses slugs list, ignoring ID for now or using first slug
        thematique: _filter.thematiquesSlugs.isNotEmpty
            ? _filter.thematiquesSlugs.join(',')
            : null,
        categorySlug: _filter.categoriesSlugs.isNotEmpty
            ? _filter.categoriesSlugs.join(',')
            : null,
        location: _filter.citySlug,
        cityRadiusKm:
            _filter.citySlug != null ? _filter.effectiveCityRadiusKm : null,
        dateFrom: _dateParam(_filter.effectiveStartDate),
        dateTo: _dateParam(_filter.effectiveEndDate),
        priceMin: _priceMinParam(_filter),
        priceMax: _priceMaxParam(_filter),
        freeOnly: _filter.onlyFree ? true : null,
        familyFriendly:
            _filter.familyFriendly && !publicFilters.contains('family')
                ? true
                : null,
        accessiblePmr: _filter.accessiblePMR && !publicFilters.contains('pmr')
            ? true
            : null,
        onlineOnly: _filter.onlineOnly ? true : null,
        inPersonOnly: _filter.inPersonOnly ? true : null,
        publicFilters:
            publicFilters.isNotEmpty ? publicFilters.join(',') : null,
        targetAudiences:
            targetAudiences.isNotEmpty ? targetAudiences.join(',') : null,
        locationType: venueType == null && _filter.locationType != null
            ? locationTypeToApiValue(_filter.locationType!)
            : null,
        venueType: venueType,
        lat: _filter.latitude,
        lng: _filter.longitude,
        radius: _filter.latitude != null ? _filter.radiusKm.toInt() : null,
        northEastLat: _filter.northEastLat,
        northEastLng: _filter.northEastLng,
        southWestLat: _filter.southWestLat,
        southWestLng: _filter.southWestLng,
        lightweight: true,
        sort: sortOptionToApiValue(_filter.effectiveSortBy),
      );
      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncValue.data(result);
    } catch (error, stackTrace) {
      if (!mounted || requestGeneration != _requestGeneration) return;
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

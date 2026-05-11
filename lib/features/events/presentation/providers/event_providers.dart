import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final eventsProvider = FutureProvider.autoDispose<EventsResult>((ref) async {
  final repository = ref.watch(eventRepositoryProvider);
  final filter = ref.watch(eventFilterProvider);

  // Use filter values to fetch events
  // Note: We might need to handle pagination here or just fetch the first page for the map
  // Ideally, the map might need a specific provider if we want to fetch HUGE amounts of data or clustering.
  // For now, let's reuse the filter provider but maybe force a larger perPage for the map coverage.

  return repository.getEvents(
    page: 1,
    perPage: 50, // Fetch more events for the map
    search: filter.searchQuery,
    // categoryId: filter.categoryId, // EventFilter uses slugs list, ignoring ID for now or using first slug
    thematique: filter.thematiquesSlugs.isNotEmpty
        ? filter.thematiquesSlugs.join(',')
        : null,
    categorySlug: filter.categoriesSlugs.isNotEmpty
        ? filter.categoriesSlugs.join(',')
        : null,
    location: filter.citySlug,
    dateFrom: _dateParam(filter.effectiveStartDate),
    dateTo: _dateParam(filter.effectiveEndDate),
    priceMin: _priceMinParam(filter),
    priceMax: _priceMaxParam(filter),
    freeOnly: filter.onlyFree ? true : null,
    familyFriendly: filter.familyFriendly ? true : null,
    accessiblePmr: filter.accessiblePMR ? true : null,
    onlineOnly: filter.onlineOnly ? true : null,
    inPersonOnly: filter.inPersonOnly ? true : null,
    lat: filter.latitude,
    lng: filter.longitude,
    radius: filter.latitude != null ? filter.radiusKm.toInt() : null,
    northEastLat: filter.northEastLat,
    northEastLng: filter.northEastLng,
    southWestLat: filter.southWestLat,
    southWestLng: filter.southWestLng,
    lightweight: true,
    sort: sortOptionToApiValue(filter.sortBy),
  );
});

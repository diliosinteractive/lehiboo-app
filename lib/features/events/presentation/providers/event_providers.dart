import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/event_repository.dart';
import '../../../search/presentation/providers/filter_provider.dart';
import '../../../search/domain/models/event_filter.dart';

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
    categorySlug: filter.categoriesSlugs.isNotEmpty ? filter.categoriesSlugs.first : null,
    city: filter.citySlug,
    dateFrom: filter.startDate?.toIso8601String(),
    dateTo: filter.endDate?.toIso8601String(),
    priceMin: filter.priceFilterType == PriceFilterType.range ? filter.priceMin : null,
    priceMax: filter.priceFilterType == PriceFilterType.range ? filter.priceMax : null,
    freeOnly: filter.onlyFree,
    familyFriendly: filter.familyFriendly,
    lat: filter.latitude,
    lng: filter.longitude,
    radius: filter.radiusKm.toInt(),
    northEastLat: filter.northEastLat,
    northEastLng: filter.northEastLng,
    southWestLat: filter.southWestLat,
    southWestLng: filter.southWestLng,
    lightweight: true,
    // ... other filters
  );
});

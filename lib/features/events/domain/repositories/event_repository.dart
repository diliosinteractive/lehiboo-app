import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/event.dart';
import '../entities/popular_city.dart';
import '../../data/models/event_dto.dart';
import '../../data/models/event_reference_data_dto.dart';
import '../../data/models/home_feed_response_dto.dart' show HomeFeedDataDto;
import '../../data/models/search_suggestions_dto.dart';

import '../../../../domain/entities/city.dart';

abstract class EventRepository {
  Future<List<City>> getCities();

  /// Curated cities for the home "Villes populaires" section.
  /// Pass `fallback: true` for the spec §5 fallback query (no `featured_only`).
  Future<List<PopularCity>> getFeaturedCities({bool fallback = false});
  Future<EventsResult> getEvents({
    int page = 1,
    int perPage = 20,
    String? search,
    int? categoryId,
    String? categorySlug,
    String? thematique,
    String? city,
    String? location, // Mobile alias for city
    String? dateFrom,
    String? dateTo,
    double? priceMin,
    double? priceMax,
    bool? freeOnly,
    int? cityRadiusKm,
    bool? familyFriendly,
    bool? accessiblePmr,
    bool? onlineOnly,
    bool? inPersonOnly,
    String? publicFilters,
    String? targetAudiences,
    String? eventTag,
    String? specialEvents,
    String? emotions,
    bool? availableOnly,
    String? locationType,
    String? venueType,
    bool? indoor,
    bool? outdoor,
    int? ageMin,
    double? lat,
    double? lng,
    int? radius,
    double? northEastLat,
    double? northEastLng,
    double? southWestLat,
    double? southWestLng,
    bool? lightweight,
    String? sort,
    String? orderBy,
    String? order,
    bool includePast = true,
  });

  Future<Event> getEvent(String identifier);

  Future<Event> verifyEventPassword(String identifier, String password);

  Future<List<EventCategoryDto>> getCategories();

  Future<List<ThematiqueDto>> getThematiques();

  Future<HomeFeedDataDto> getHomeFeed({
    double? lat,
    double? lng,
    int? radius,
    int? limit,
  });

  Future<FiltersResponseDto> getFilters();

  Future<EventReferenceDataDto> getEventReferenceData({
    bool onlyOnline = true,
  });

  Future<SearchSuggestionsDto> getSearchSuggestions({
    required String query,
    required List<String> types,
    int limit = 5,
  });
}

class EventsResult {
  final List<Event> events;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNext;
  final bool hasPrev;

  EventsResult({
    required this.events,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNext,
    required this.hasPrev,
  });
}

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  throw UnimplementedError('eventRepositoryProvider not initialized');
});

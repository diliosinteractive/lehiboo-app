import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/events_api_datasource.dart';
import '../mappers/event_mapper.dart';
import '../models/event_dto.dart';
import '../models/home_feed_response_dto.dart';
import '../../../../domain/entities/city.dart';

final eventRepositoryImplProvider = Provider<EventRepository>((ref) {
  final apiDataSource = ref.read(eventsApiDataSourceProvider);
  return EventRepositoryImpl(apiDataSource);
});

class EventRepositoryImpl implements EventRepository {
  final EventsApiDataSource _apiDataSource;

  EventRepositoryImpl(this._apiDataSource);

  @override
  Future<EventsResult> getEvents({
    int page = 1,
    int perPage = 20,
    String? search,
    int? categoryId,
    String? categorySlug,
    String? thematique,
    String? city,
    String? location,
    String? dateFrom,
    String? dateTo,
    double? priceMin,
    double? priceMax,
    bool? freeOnly,
    bool? familyFriendly,
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
    String? orderBy,
    String? order,
    bool includePast = true,
  }) async {
    final response = await _apiDataSource.getEvents(
      page: page,
      perPage: perPage,
      search: search,
      categoryId: categoryId,
      categorySlug: categorySlug,
      thematique: thematique,
      city: city,
      location: location,
      dateFrom: dateFrom,
      dateTo: dateTo,
      priceMin: priceMin,
      priceMax: priceMax,
      freeOnly: freeOnly,
      familyFriendly: familyFriendly,
      indoor: indoor,
      outdoor: outdoor,
      ageMin: ageMin,
      lat: lat,
      lng: lng,
      radius: radius,
      northEastLat: northEastLat,
      northEastLng: northEastLng,
      southWestLat: southWestLat,
      southWestLng: southWestLng,
      lightweight: lightweight,
      orderBy: orderBy,
      order: order,
      includePast: includePast,
    );

    final events = response.events.map(EventMapper.toEvent).toList();

    // Debug: log transformed event coordinates
    if (kDebugMode) {
      debugPrint('🗺️ Repository: Transformed ${events.length} events');
      for (var i = 0; i < events.length && i < 5; i++) {
        final e = events[i];
        debugPrint('🗺️ Event[$i] "${e.title}": lat=${e.latitude}, lng=${e.longitude}');
      }
    }

    return EventsResult(
      events: events,
      currentPage: response.pagination.currentPage,
      totalPages: response.pagination.totalPages,
      totalItems: response.pagination.totalItems,
      hasNext: response.pagination.hasNext,
      hasPrev: response.pagination.hasPrev,
    );
  }

  @override
  Future<Event> getEvent(String identifier) async {
    final dto = await _apiDataSource.getEvent(identifier);
    try {
      return EventMapper.toEvent(dto);
    } catch (e, stack) {
      print('EventRepositoryImpl: Error mapping DTO to Event for $identifier: $e');
      print(stack);
      rethrow;
    }
  }

  @override
  Future<List<EventCategoryDto>> getCategories() async {
    return await _apiDataSource.getCategories();
  }

  @override
  Future<List<ThematiqueDto>> getThematiques() async {
    return await _apiDataSource.getThematiques();
  }

  @override
  Future<List<City>> getCities() async {
    return await _apiDataSource.getCities();
  }

  @override
  Future<FiltersResponseDto> getFilters() async {
    return await _apiDataSource.getFilters();
  }
  @override
  Future<HomeFeedResponseDto> getHomeFeed({
    double? lat,
    double? lng,
    int? radius,
    int? limit,
  }) async {
    try {
      if (kDebugMode) {
        print('EventRepositoryImpl: Fetching Home Feed');
      }
      return await _apiDataSource.getHomeFeed(
        lat: lat,
        lng: lng,
        radius: radius,
        limit: limit,
      );
    } catch (e, stack) {
      if (kDebugMode) {
        print('EventRepositoryImpl: Error fetching home feed: $e');
        print(stack);
      }
      rethrow;
    }
  }
}

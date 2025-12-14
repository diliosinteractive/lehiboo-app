import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/events_api_datasource.dart';
import '../mappers/event_mapper.dart';
import '../models/event_dto.dart';

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
      orderBy: orderBy,
      order: order,
      includePast: includePast,
    );

    final events = response.events.map(EventMapper.toEvent).toList();

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
  Future<Event> getEventById(int id) async {
    final dto = await _apiDataSource.getEventById(id);
    try {
      return EventMapper.toEvent(dto);
    } catch (e, stack) {
      print('EventRepositoryImpl: Error mapping DTO to Event for id $id: $e');
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
  Future<List<CityDto>> getCities() async {
    return await _apiDataSource.getCities();
  }

  @override
  Future<FiltersResponseDto> getFilters() async {
    return await _apiDataSource.getFilters();
  }
}

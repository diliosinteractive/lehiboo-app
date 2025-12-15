import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/event.dart';
import '../../data/models/event_dto.dart';

import '../../../../domain/entities/city.dart';

abstract class EventRepository {
  Future<List<City>> getCities();
  Future<EventsResult> getEvents({
    int page = 1,
    int perPage = 20,
    String? search,
    int? categoryId,
    String? categorySlug,
    String? thematique,
    String? city,
    String? location, // event_loc taxonomy slug
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
  });

  Future<Event> getEventById(int id);

  Future<List<EventCategoryDto>> getCategories();

  Future<List<ThematiqueDto>> getThematiques();



  Future<FiltersResponseDto> getFilters();
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

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../models/event_dto.dart';
import '../models/event_availability_dto.dart';

final eventsApiDataSourceProvider = Provider<EventsApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return EventsApiDataSource(dio);
});

class EventsApiDataSource {
  final Dio _dio;

  EventsApiDataSource(this._dio);

  Future<EventsResponseDto> getEvents({
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
    String? orderBy,
    String? order,
    bool includePast = true, // Include past events (preprod has incomplete date data)
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'include_past': includePast,
    };

    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (categoryId != null) queryParams['category'] = categoryId;
    if (categorySlug != null) queryParams['category'] = categorySlug;
    if (thematique != null) queryParams['thematique'] = thematique;
    if (city != null) queryParams['city'] = city;
    if (location != null) queryParams['location'] = location;
    if (dateFrom != null) queryParams['date_from'] = dateFrom;
    if (dateTo != null) queryParams['date_to'] = dateTo;
    if (priceMin != null) queryParams['price_min'] = priceMin;
    if (priceMax != null) queryParams['price_max'] = priceMax;
    if (freeOnly == true) queryParams['free_only'] = true;
    if (familyFriendly == true) queryParams['family_friendly'] = true;
    if (indoor == true) queryParams['indoor'] = true;
    if (outdoor == true) queryParams['outdoor'] = true;
    if (ageMin != null) queryParams['age_min'] = ageMin;
    if (lat != null && lng != null) {
      queryParams['lat'] = lat;
      queryParams['lng'] = lng;
      if (radius != null) queryParams['radius'] = radius;
    }
    if (orderBy != null) queryParams['orderby'] = orderBy;
    if (order != null) queryParams['order'] = order;

    debugPrint('=== EventsApiDataSource.getEvents ===');
    debugPrint('Query params: $queryParams');

    final response = await _dio.get('/events', queryParameters: queryParams);
    final data = response.data;

    debugPrint('API Response success: ${data['success']}');
    debugPrint('API Response has data: ${data['data'] != null}');

    if (data['success'] == true && data['data'] != null) {
      final eventsData = data['data'];
      debugPrint('Events count in response: ${(eventsData['events'] as List?)?.length ?? 0}');

      if ((eventsData['events'] as List?)?.isNotEmpty == true) {
        debugPrint('First event raw: ${eventsData['events'][0]}');
      }

      try {
        final result = EventsResponseDto.fromJson(data['data']);
        debugPrint('Successfully parsed EventsResponseDto with ${result.events.length} events');
        return result;
      } catch (parseError, parseStack) {
        debugPrint('Error parsing EventsResponseDto: $parseError');
        debugPrint('Parse stack: $parseStack');
        rethrow;
      }
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load events');
  }

  Future<EventDto> getEventById(int id) async {
    final response = await _dio.get('/events/$id');
    final data = response.data;

    if (data['success'] == true && data['data'] != null) {
      debugPrint('getEventById: Raw data received for $id');
      try {
        return EventDto.fromJson(data['data']);
      } catch (e, stack) {
        debugPrint('getEventById Error parsing DTO: $e');
        debugPrint(stack.toString());
        rethrow;
      }
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load event');
  }

  /// Fetch availability (slots & tickets) for an event
  Future<EventAvailabilityResponseDto> getEventAvailability(int eventId, {String? date}) async {
    final queryParams = <String, dynamic>{};
    if (date != null && date.isNotEmpty) queryParams['date'] = date;

    final response = await _dio.get(
      '/events/$eventId/availability',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
    final data = response.data;

    if (data['success'] == true && data['data'] != null) {
      debugPrint('getEventAvailability: Data received for $eventId');
      try {
        return EventAvailabilityResponseDto.fromJson(data['data']);
      } catch (e, stack) {
        debugPrint('getEventAvailability Error parsing DTO: $e');
        debugPrint(stack.toString());
        rethrow;
      }
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load availability');
  }

  Future<List<EventCategoryDto>> getCategories({
    bool includeCount = true,
    bool parentOnly = false,
  }) async {
    final queryParams = <String, dynamic>{
      'include_count': includeCount,
    };
    if (parentOnly) queryParams['parent_only'] = true;

    final response = await _dio.get('/categories', queryParameters: queryParams);
    final data = response.data;

    if (data['success'] == true && data['data'] != null) {
      final categoriesJson = data['data']['categories'] as List;
      return categoriesJson.map((c) => EventCategoryDto.fromJson(c)).toList();
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load categories');
  }

  Future<List<ThematiqueDto>> getThematiques() async {
    final response = await _dio.get('/thematiques');
    final data = response.data;

    if (data['success'] == true && data['data'] != null) {
      final thematiquesJson = data['data']['thematiques'] as List;
      return thematiquesJson.map((t) => ThematiqueDto.fromJson(t)).toList();
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load thematiques');
  }

  Future<List<CityDto>> getCities() async {
    final response = await _dio.get('/cities');
    final data = response.data;

    if (data['success'] == true && data['data'] != null) {
      final citiesJson = data['data']['cities'] as List;
      return citiesJson.map((c) => CityDto.fromJson(c)).toList();
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load cities');
  }

  Future<FiltersResponseDto> getFilters() async {
    final response = await _dio.get('/filters');
    final data = response.data;

    if (data['success'] == true && data['data'] != null) {
      return FiltersResponseDto.fromJson(data['data']);
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load filters');
  }
}

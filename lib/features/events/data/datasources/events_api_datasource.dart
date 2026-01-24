import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../models/event_dto.dart';
import '../models/event_availability_dto.dart';
import '../models/home_feed_response_dto.dart';
import '../../../../domain/entities/city.dart';
import '../models/city_with_coordinates_dto.dart';

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
    double? northEastLat,
    double? northEastLng,
    double? southWestLat,
    double? southWestLng,
    bool? lightweight,
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
    
    if (northEastLat != null && northEastLng != null && southWestLat != null && southWestLng != null) {
      queryParams['north_east_lat'] = northEastLat;
      queryParams['north_east_lng'] = northEastLng;
      queryParams['south_west_lat'] = southWestLat;
      queryParams['south_west_lng'] = southWestLng;
    }
    
    if (lightweight == true) queryParams['lightweight'] = true;

    if (orderBy != null) queryParams['orderby'] = orderBy;
    if (order != null) queryParams['order'] = order;

    debugPrint('=== EventsApiDataSource.getEvents ===');
    debugPrint('Query params: $queryParams');

    final response = await _dio.get('/events', queryParameters: queryParams);
    final data = response.data;

    debugPrint('API Response success: ${data['success']}');
    debugPrint('API Response has data: ${data['data'] != null}');

    // Handle both old format { success: true, data: {...} } and new Laravel paginated format
    Map<String, dynamic> eventsData;

    if (data['success'] == true && data['data'] != null) {
      // Old format: { success: true, data: { events: [...], pagination: {...} } }
      eventsData = data['data'];
    } else if (data is Map<String, dynamic> && data['data'] != null) {
      // New Laravel paginated format: { data: [...], meta: {...}, links: {...} }
      final dataList = data['data'];
      if (dataList is List) {
        // Convert Laravel pagination format to our expected format
        eventsData = {
          'events': dataList,
          'pagination': {
            'current_page': data['meta']?['current_page'] ?? 1,
            'per_page': data['meta']?['per_page'] ?? perPage,
            'total_items': data['meta']?['total'] ?? dataList.length,
            'total_pages': data['meta']?['last_page'] ?? 1,
            'has_next': data['links']?['next'] != null,
            'has_prev': data['links']?['prev'] != null,
          },
        };
      } else {
        eventsData = data['data'];
      }
    } else {
      throw Exception(data['message'] ?? 'Failed to load events');
    }

    // Handle "lightweight" response structure (pins vs events)
    if (eventsData['pins'] != null) {
      debugPrint('Handling lightweight response with ${eventsData['pins'].length} pins');

      // Map pins to EventDto structure
      final pins = eventsData['pins'] as List;
      final mappedEvents = pins.map<Map<String, dynamic>>((pin) {
        return <String, dynamic>{
          'id': pin['id'],
          'title': pin['title'] ?? '',
          'slug': '',
          'featured_image': <String, dynamic>{
            'thumbnail': pin['thumbnail'] ?? pin['image'],
            'medium': pin['thumbnail'] ?? pin['image'],
            'large': pin['thumbnail'] ?? pin['image'],
            'full': pin['thumbnail'] ?? pin['image'],
          },
          'location': <String, dynamic>{
            'lat': pin['lat'],
            'lng': pin['lng'],
          },
          'pricing': <String, dynamic>{
            'min': (pin['price_min'] ?? pin['price'] ?? 0).toDouble(),
            'max': (pin['price_max'] ?? pin['price'] ?? 0).toDouble(),
            'is_free': (pin['price'] == 0 || pin['price_min'] == 0),
          },
          'dates': <String, dynamic>{},
        };
      }).toList();

      eventsData['events'] = mappedEvents;

      if (eventsData['pagination'] == null) {
        eventsData['pagination'] = <String, dynamic>{
          'current_page': 1,
          'per_page': pins.isNotEmpty ? pins.length : 50,
          'total_items': eventsData['total_count'] ?? pins.length,
          'total_pages': 1,
          'has_next': false,
          'has_prev': false,
        };
      }
    }

    debugPrint('Events count in response: ${(eventsData['events'] as List?)?.length ?? 0}');

    try {
      final result = EventsResponseDto.fromJson(eventsData);
      debugPrint('Successfully parsed EventsResponseDto with ${result.events.length} events');
      return result;
    } catch (parseError, parseStack) {
      debugPrint('Error parsing EventsResponseDto: $parseError');
      debugPrint('Parse stack: $parseStack');
      rethrow;
    }
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

  Future<HomeFeedResponseDto> getHomeFeed({
    double? lat,
    double? lng,
    int? radius,
    int? limit,
  }) async {
    final queryParams = <String, dynamic>{};
    if (lat != null) queryParams['lat'] = lat;
    if (lng != null) queryParams['lng'] = lng;
    if (radius != null) queryParams['radius'] = radius;
    if (limit != null) queryParams['limit'] = limit;

    final response = await _dio.get('/home-feed', queryParameters: queryParams);
    final data = response.data;

    if (data['success'] == true && data['data'] != null) {
      debugPrint('getHomeFeed: Data received');
      try {
        return HomeFeedResponseDto.fromJson(data);
      } catch (e, stack) {
        debugPrint('getHomeFeed Error parsing DTO: $e');
        debugPrint(stack.toString());
        rethrow;
      }
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load home feed');
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

  Future<List<City>> getCities() async {
    try {
      final response = await _dio.get('/cities');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final data = response.data['data'];
        final citiesList = data['cities'] as List<dynamic>;
        
        return citiesList.map((json) {
           final dto = CityWithCoordinatesDto.fromJson(json);
           return City(
             id: dto.name, 
             name: dto.name,
             slug: dto.name.toLowerCase().replaceAll(' ', '-'),
             lat: dto.lat,
             lng: dto.lng,
             region: dto.region,
             eventCount: dto.eventCount,
             imageUrl: dto.imageUrl,
           );
        }).toList();
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      debugPrint('Error fetching cities: $e');
      return [];
    }
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

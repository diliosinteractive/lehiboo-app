import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../memberships/data/models/membership_dto.dart';
import '../../../memberships/domain/exceptions/members_only_exception.dart';
import '../../domain/exceptions/event_password_exceptions.dart';
import '../models/event_dto.dart';
import '../models/event_availability_dto.dart';
import '../models/event_reference_data_dto.dart';
import '../models/home_feed_response_dto.dart' show HomeFeedDataDto;
import '../models/locked_event_shell_dto.dart';
import '../../../../domain/entities/city.dart';
import '../models/city_with_coordinates_dto.dart';
import '../models/popular_city_dto.dart';

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
    String? targetAudiences,
    String? eventTag,
    String? specialEvents,
    String? emotions,
    bool? availableOnly,
    String? locationType,
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
    bool includePast =
        true, // Include past events (preprod has incomplete date data)
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
    if (lat == null || lng == null) {
      final cityAlias = location ?? city;
      if (cityAlias != null) queryParams['location'] = cityAlias;
      if (cityAlias != null && cityRadiusKm != null) {
        queryParams['radius_km'] = cityRadiusKm;
      }
    }
    if (dateFrom != null) queryParams['date_from'] = dateFrom;
    if (dateTo != null) queryParams['date_to'] = dateTo;
    if (priceMin != null) queryParams['price_min'] = priceMin;
    if (priceMax != null) queryParams['price_max'] = priceMax;
    if (freeOnly == true) queryParams['free_only'] = 1;
    if (familyFriendly == true) queryParams['family_friendly'] = 1;
    if (accessiblePmr == true) queryParams['accessible_pmr'] = 1;
    if (onlineOnly == true) queryParams['online'] = 1;
    if (inPersonOnly == true) queryParams['in_person'] = 1;
    if (targetAudiences != null && targetAudiences.isNotEmpty) {
      queryParams['target_audiences'] = targetAudiences;
    }
    if (eventTag != null && eventTag.isNotEmpty) {
      queryParams['event_tag'] = eventTag;
    }
    if (specialEvents != null && specialEvents.isNotEmpty) {
      queryParams['special_events'] = specialEvents;
    }
    if (emotions != null && emotions.isNotEmpty) {
      queryParams['emotions'] = emotions;
    }
    if (availableOnly == true) queryParams['available_only'] = 1;
    if (locationType != null && locationType.isNotEmpty) {
      queryParams['location_type'] = locationType;
    }
    if (indoor == true) queryParams['indoor'] = true;
    if (outdoor == true) queryParams['outdoor'] = true;
    if (ageMin != null) queryParams['age_min'] = ageMin;
    if (lat != null && lng != null) {
      queryParams['lat'] = lat;
      queryParams['lng'] = lng;
      if (radius != null) queryParams['radius'] = radius;
    }

    if (northEastLat != null &&
        northEastLng != null &&
        southWestLat != null &&
        southWestLng != null) {
      queryParams['north_east_lat'] = northEastLat;
      queryParams['north_east_lng'] = northEastLng;
      queryParams['south_west_lat'] = southWestLat;
      queryParams['south_west_lng'] = southWestLng;
    }

    if (lightweight == true) queryParams['lightweight'] = true;

    if (sort != null && sort.isNotEmpty) queryParams['sort'] = sort;
    if (orderBy != null) queryParams['sort_by'] = orderBy;
    if (order != null) queryParams['sort_order'] = order;

    debugPrint('=== EventsApiDataSource.getEvents ===');
    debugPrint('Query params: $queryParams');

    final response = await _dio.get('/events', queryParameters: queryParams);
    final data = response.data;

    debugPrint('API Response success: ${data['success']}');
    debugPrint('API Response has data: ${data['data'] != null}');

    // Handle API response formats (old and new Laravel)
    Map<String, dynamic> eventsData;

    if (data['success'] == true && data['data'] != null) {
      final innerData = data['data'];

      if (innerData is List) {
        // New Laravel format: { success: true, data: [...], meta: {...} }
        eventsData = {
          'events': innerData,
          'pagination': {
            'current_page':
                data['meta']?['page'] ?? data['meta']?['current_page'] ?? 1,
            'per_page': data['meta']?['per_page'] ?? perPage,
            'total_items': data['meta']?['total'] ?? innerData.length,
            'total_pages': data['meta']?['last_page'] ?? 1,
            'has_next': (data['meta']?['page'] ?? 1) <
                (data['meta']?['last_page'] ?? 1),
            'has_prev': (data['meta']?['page'] ?? 1) > 1,
          },
        };
      } else if (innerData is Map<String, dynamic>) {
        // Old format: { success: true, data: { events: [...], pagination: {...} } }
        eventsData = innerData;
      } else {
        throw Exception('Unexpected data format in events response');
      }
    } else if (data is Map<String, dynamic> && data['data'] != null) {
      // Format without 'success' key (standard Laravel pagination)
      final dataList = data['data'];
      if (dataList is List) {
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
      final pins = eventsData['pins'] as List;
      debugPrint('📍 Handling lightweight response with ${pins.length} pins');

      // Debug: log pin coordinates
      for (var i = 0; i < pins.length && i < 5; i++) {
        final pin = pins[i];
        debugPrint(
            '📍 Pin[$i] id=${pin['id']}, lat=${pin['lat']}, lng=${pin['lng']}');
      }

      // Map pins to EventDto structure
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

    debugPrint(
        'Events count in response: ${(eventsData['events'] as List?)?.length ?? 0}');

    try {
      final result = EventsResponseDto.fromJson(eventsData);
      debugPrint(
          'Successfully parsed EventsResponseDto with ${result.events.length} events');
      return result;
    } catch (parseError, parseStack) {
      debugPrint('Error parsing EventsResponseDto: $parseError');
      debugPrint('Parse stack: $parseStack');
      rethrow;
    }
  }

  /// Fetch event by identifier (UUID or slug).
  ///
  /// On `403` with `error: members_only`, throws [MembersOnlyException]
  /// (the spec-defined gate response from §20). The screen catches this
  /// to render the "Rejoindre {Organization}" gate instead of an error.
  Future<EventDto> getEvent(String identifier) async {
    try {
      final response = await _dio.get('/events/$identifier');
      final payload = ApiResponseHandler.extractObject(response.data);
      return EventDto.fromJson(payload);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        final body = e.response?.data;
        if (body is Map<String, dynamic>) {
          if (body['error'] == 'password_required') {
            final shell = body['data'];
            if (shell is Map<String, dynamic>) {
              throw EventPasswordRequiredException(
                LockedEventShellDto.fromJson(shell).toEntity(),
              );
            }
          }
          if (body['error'] == 'members_only') {
            final org = body['organization'];
            if (org is Map<String, dynamic>) {
              throw MembersOnlyException(OrganizationSummaryDto.fromJson(org));
            }
          }
        }
      }
      rethrow;
    }
  }

  /// Unlock a password-protected event in a single round-trip.
  ///
  /// On `200` the API returns the full `MobileEventResource` — callers
  /// don't need a follow-up `GET /events/{id}`. Status codes map to the
  /// typed exceptions in `event_password_exceptions.dart` (and reuse
  /// [MembersOnlyException] for `403 + members_only`). Spec §5.
  Future<EventDto> verifyEventPassword(
    String identifier,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/events/$identifier/verify-password',
        data: {'password': password},
        options: Options(headers: {'Accept-Language': 'fr'}),
      );
      final payload = ApiResponseHandler.extractObject(response.data);
      return EventDto.fromJson(payload);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;
      switch (status) {
        case 400:
          throw const EventNotProtectedException();
        case 403:
          if (body is Map<String, dynamic>) {
            if (body['error'] == 'members_only') {
              final org = body['organization'];
              if (org is Map<String, dynamic>) {
                throw MembersOnlyException(
                  OrganizationSummaryDto.fromJson(org),
                );
              }
            }
            if (body['error'] == 'invalid_password') {
              throw const InvalidEventPasswordException();
            }
          }
          throw const InvalidEventPasswordException();
        case 404:
          throw const EventNotFoundException();
        case 422:
          throw const EventValidationException();
        case 429:
          final retry =
              int.tryParse(e.response?.headers.value('retry-after') ?? '') ??
                  60;
          throw EventPasswordRateLimitedException(Duration(seconds: retry));
        default:
          rethrow;
      }
    }
  }

  Future<HomeFeedDataDto> getHomeFeed({
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

    // ApiResponseHandler handles all response shapes:
    // { success: true, data: {...} }, { data: {...} }, or raw {...}
    final payload = ApiResponseHandler.extractObject(
      response.data,
      unwrapRoot: true,
    );

    final result = HomeFeedDataDto.fromJson(payload);
    debugPrint('getHomeFeed: today=${result.today.length}, '
        'tomorrow=${result.tomorrow.length}, '
        'recommended=${result.recommended.length}');
    return result;
  }

  /// Fetch availability (slots & tickets) for an event
  Future<EventAvailabilityResponseDto> getEventAvailability(String eventId,
      {String? date}) async {
    final queryParams = <String, dynamic>{};
    if (date != null && date.isNotEmpty) queryParams['date'] = date;

    final response = await _dio.get(
      '/events/$eventId/availability',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    // Try list format first: { "data": [ slots... ] }
    try {
      final rawSlots = ApiResponseHandler.extractList(response.data);
      debugPrint('getEventAvailability: ${rawSlots.length} slots for $eventId');

      final transformedSlots = rawSlots
          .map((slot) => {
                'id': slot['id']?.toString() ?? '',
                'date': slot['slot_date'] ?? slot['date'] ?? '',
                'start_time': slot['start_time'],
                'end_time': slot['end_time'],
                'spots_total': slot['total_capacity'] ?? slot['spots_total'],
                'spots_remaining':
                    slot['available_count'] ?? slot['spots_remaining'],
                'is_available': slot['is_available'] ?? true,
              })
          .toList();

      return EventAvailabilityResponseDto.fromJson({
        'event_id': 0,
        'slots': transformedSlots,
        'tickets': [],
      });
    } on ApiFormatException {
      // Not a list — try object format: { "data": { "slots": [...] } }
    }

    final payload = ApiResponseHandler.extractObject(response.data);
    return EventAvailabilityResponseDto.fromJson(payload);
  }

  Future<List<EventCategoryDto>> getCategories({
    bool includeCount = true,
    bool parentOnly = false,
  }) async {
    final queryParams = <String, dynamic>{
      'include_count': includeCount,
    };
    if (parentOnly) queryParams['parent_only'] = true;

    final response =
        await _dio.get('/categories', queryParameters: queryParams);

    final categoriesJson = _extractCategoriesList(response.data);
    return categoriesJson
        .cast<Map<String, dynamic>>()
        .map(EventCategoryDto.fromJson)
        .toList();
  }

  List<dynamic> _extractCategoriesList(dynamic responseData) {
    try {
      return ApiResponseHandler.extractList(responseData, key: 'categories');
    } on ApiFormatException {
      return ApiResponseHandler.extractList(responseData);
    }
  }

  Future<List<ThematiqueDto>> getThematiques() async {
    final response = await _dio.get('/thematiques');

    final thematiquesJson = ApiResponseHandler.extractList(
      response.data,
      key: 'thematiques',
    );
    return thematiquesJson
        .cast<Map<String, dynamic>>()
        .map(ThematiqueDto.fromJson)
        .toList();
  }

  Future<List<City>> getCities() async {
    final response = await _dio.get(
      '/cities',
      queryParameters: const {
        'only_with_upcoming_slots': '1',
      },
    );

    final citiesJson = ApiResponseHandler.extractList(
      response.data,
      key: 'cities',
    );

    return citiesJson.cast<Map<String, dynamic>>().map((json) {
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
  }

  /// Curated cities for the "Villes populaires" home section.
  ///
  /// When [fallback] is false (default), queries the admin-curated set
  /// (`featured_only=1`). When the curated set is empty, callers should
  /// retry with `fallback: true` per spec §5 to display "where it's
  /// happening" instead of an empty section.
  Future<List<PopularCityDto>> getFeaturedCities(
      {bool fallback = false}) async {
    final response = await _dio.get(
      '/cities',
      queryParameters: {
        if (!fallback) 'featured_only': '1',
        'only_with_upcoming_slots': '1',
      },
    );

    final citiesJson = ApiResponseHandler.extractList(
      response.data,
      key: 'cities',
    );

    return citiesJson
        .cast<Map<String, dynamic>>()
        .map(PopularCityDto.fromJson)
        .toList();
  }

  Future<FiltersResponseDto> getFilters() async {
    final response = await _dio.get('/filters');

    final payload = ApiResponseHandler.extractObject(response.data);
    return FiltersResponseDto.fromJson(payload);
  }

  Future<EventReferenceDataDto> getEventReferenceData({
    bool onlyOnline = true,
  }) async {
    final response = await _dio.get(
      '/events/reference-data',
      queryParameters: {
        if (onlyOnline) 'only_online': '1',
      },
    );

    final payload = ApiResponseHandler.extractObject(response.data);
    return EventReferenceDataDto.fromJson(payload);
  }
}

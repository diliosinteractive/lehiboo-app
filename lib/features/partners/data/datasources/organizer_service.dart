import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';

final organizerServiceProvider = Provider<OrganizerService>((ref) {
  final dio = ref.read(dioProvider);
  return OrganizerService(dio);
});

class OrganizerService {
  final Dio _dio;

  OrganizerService(this._dio);

  /// Récupère le profil d'un organisateur
  Future<EventOrganizerDto> getOrganizer(String identifier) async {
    final response = await _dio.get('/organizers/$identifier');
    final data = response.data;

    if (data['success'] == true && data['data'] != null) {
      try {
        return EventOrganizerDto.fromJson(data['data']);
      } catch (e, stack) {
        debugPrint('getOrganizer Error parsing DTO for $identifier: $e');
        debugPrint(stack.toString());
        rethrow;
      }
    }
    if (data['data'] != null) {
      return EventOrganizerDto.fromJson(data['data'] as Map<String, dynamic>);
    }
    if (data is Map<String, dynamic>) {
      return EventOrganizerDto.fromJson(data);
    }
    throw Exception(
        data['data']?['message'] ?? 'Failed to load organizer profile');
  }

  /// Récupère les événements d'un organisateur
  Future<EventsResponseDto> getOrganizerEvents(
    String identifier, {
    String status = 'upcoming',
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/organizers/$identifier/events',
        queryParameters: {
          'status': status,
          'page': page,
          'per_page': perPage,
        },
      );
      final data = response.data;

      if (data['success'] == true && data['data'] != null) {
        final eventsData = data['data']['events'] as List?;
        if (eventsData != null && eventsData.isNotEmpty) {
          final firstEvent = eventsData[0];
          debugPrint('=== RAW EVENT DATA ===');
          debugPrint('Title: ${firstEvent['title']}');
          debugPrint('featured_image: ${firstEvent['featured_image']}');
          debugPrint('Available keys: ${(firstEvent as Map).keys.toList()}');
          debugPrint('======================');
        }

        final result = EventsResponseDto.fromJson(data['data']);
        for (final event in result.events.take(2)) {
          debugPrint(
              'Parsed "${event.title}": featuredImage=${event.featuredImage?.large ?? event.featuredImage?.full ?? "NULL"}');
        }
        return result;
      }

      if (data['data'] != null && data['data'] is Map<String, dynamic>) {
        return EventsResponseDto.fromJson(data['data'] as Map<String, dynamic>);
      }

      throw Exception(
          data['data']?['message'] ?? 'Failed to load organizer events');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const EventsResponseDto(
          events: [],
          pagination: PaginationDto(),
        );
      }
      rethrow;
    }
  }
}

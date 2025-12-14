import 'package:dio/dio.dart';
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
  Future<EventOrganizerDto> getOrganizer(int id) async {
    final response = await _dio.get('/organizers/$id');
    final data = response.data;
    
    if (data['success'] == true && data['data'] != null) {
      try {
        return EventOrganizerDto.fromJson(data['data']);
      } catch (e, stack) {
        print('getOrganizer Error parsing DTO for id $id: $e');
        print(stack);
        rethrow;
      }
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load organizer profile');
  }

  /// Récupère les événements d'un organisateur
  Future<EventsResponseDto> getOrganizerEvents(
    int id, {
    String status = 'upcoming',
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _dio.get(
      '/organizers/$id/events',
      queryParameters: {
        'status': status,
        'page': page,
        'per_page': perPage,
      },
    );
    final data = response.data;
    
    if (data['success'] == true && data['data'] != null) {
      // Debug: Print raw event data to see featured_image structure
      final eventsData = data['data']['events'] as List?;
      if (eventsData != null && eventsData.isNotEmpty) {
        final firstEvent = eventsData[0];
        print('=== RAW EVENT DATA ===');
        print('Title: ${firstEvent['title']}');
        print('featured_image: ${firstEvent['featured_image']}');
        print('Available keys: ${(firstEvent as Map).keys.toList()}');
        print('======================');
      }
      
      final result = EventsResponseDto.fromJson(data['data']);
      // Debug: Check if images are present after parsing
      for (final event in result.events.take(2)) {
        print('Parsed "${event.title}": featuredImage=${event.featuredImage?.large ?? event.featuredImage?.full ?? "NULL"}');
      }
      return result;
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load organizer events');
  }
}

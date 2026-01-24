import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../../../events/data/models/event_dto.dart';

final favoritesApiDataSourceProvider = Provider<FavoritesApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return FavoritesApiDataSource(dio);
});

class FavoritesApiDataSource {
  final Dio _dio;

  FavoritesApiDataSource(this._dio);

  Future<List<FavoriteEventDto>> getFavorites() async {
    final response = await _dio.get('/me/favorites');

    final data = response.data;

    // Handle paginated response from Laravel Resource Collection
    // Format: { "data": [...], "links": {...}, "meta": {...} }
    if (data is Map<String, dynamic> && data['data'] != null) {
      final favoritesData = data['data'];
      if (favoritesData is List) {
        return favoritesData.map((f) => FavoriteEventDto.fromJson(f as Map<String, dynamic>)).toList();
      }
    }

    // Legacy format: { "success": true, "data": [...] }
    if (data['success'] == true && data['data'] != null) {
      final favoritesJson = data['data'] as List;
      return favoritesJson.map((f) => FavoriteEventDto.fromJson(f as Map<String, dynamic>)).toList();
    }

    throw Exception(data['message'] ?? 'Failed to load favorites');
  }

  Future<void> addToFavorites(int eventId) async {
    final response = await _dio.post(
      '/me/favorites',
      data: {'event_id': eventId},
    );

    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['data']?['message'] ?? 'Failed to add to favorites');
    }
  }

  Future<void> removeFromFavorites(int eventId) async {
    final response = await _dio.delete('/me/favorites/$eventId');

    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['data']?['message'] ?? 'Failed to remove from favorites');
    }
  }

  Future<bool> isFavorite(int eventId) async {
    final response = await _dio.get('/me/favorites/$eventId');

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return data['data']['is_favorite'] == true;
    }
    return false;
  }

  Future<bool> toggleFavorite(int eventId) async {
    final response = await _dio.post('/me/favorites/$eventId/toggle');

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return data['data']['is_favorite'] == true;
    }
    throw Exception(data['data']?['message'] ?? 'Failed to toggle favorite');
  }
}

class FavoriteEventDto {
  final int id;           // Numeric ID for API calls (toggle, remove)
  final String? uuid;     // UUID for display/comparison with other entities
  final String title;
  final String slug;
  final String? thumbnail;
  final String date;
  final String? time;
  final String? venue;
  final String? city;
  final EventPriceDto? price;
  final bool isUpcoming;
  final String? favoritedAt;
  final String? organizerName;
  final String? organizerLogo;

  FavoriteEventDto({
    required this.id,
    this.uuid,
    required this.title,
    required this.slug,
    this.thumbnail,
    required this.date,
    this.time,
    this.venue,
    this.city,
    this.price,
    required this.isUpcoming,
    this.favoritedAt,
    this.organizerName,
    this.organizerLogo,
  });

  /// Returns the string ID to use for comparisons with Activity/Event entities
  /// Prefers UUID if available, falls back to numeric ID as string
  String get stringId => uuid ?? id.toString();

  factory FavoriteEventDto.fromJson(Map<String, dynamic> json) {
    // Extract organization/vendor name if available
    String? orgName;
    String? orgLogo;
    if (json['organization'] != null) {
      orgName = _parseString(json['organization']['company_name']);
      orgLogo = _parseString(json['organization']['logo_url']);
    } else if (json['vendor'] != null) {
      orgName = _parseString(json['vendor']['company_name']);
      orgLogo = _parseString(json['vendor']['logo_url']);
    }

    return FavoriteEventDto(
      id: _parseInt(json['id']),
      uuid: _parseString(json['uuid']),
      title: _parseString(json['title']) ?? '',
      slug: _parseString(json['slug']) ?? '',
      thumbnail: _parseString(json['thumbnail']) ?? _parseString(json['cover_image']),
      date: _parseString(json['date']) ?? _parseString(json['start_date']) ?? '',
      time: _parseString(json['time']),
      venue: _parseString(json['venue']),
      city: _parseString(json['city']),
      price: json['price'] != null ? EventPriceDto.fromJson(json['price']) : null,
      isUpcoming: json['is_upcoming'] as bool? ?? true,
      favoritedAt: _parseString(json['favorited_at']),
      organizerName: orgName,
      organizerLogo: orgLogo,
    );
  }
}

String? _parseString(dynamic value) {
  if (value == null) return null;
  if (value is bool) return null;
  if (value is String) return value.isEmpty ? null : value;
  return value.toString();
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

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
    if (data['success'] == true && data['data'] != null) {
      final favoritesJson = data['data']['favorites'] as List;
      return favoritesJson.map((f) => FavoriteEventDto.fromJson(f)).toList();
    }
    throw Exception(data['data']?['message'] ?? 'Failed to load favorites');
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
  final int id;
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

  FavoriteEventDto({
    required this.id,
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
  });

  factory FavoriteEventDto.fromJson(Map<String, dynamic> json) {
    return FavoriteEventDto(
      id: _parseInt(json['id']),
      title: _parseString(json['title']) ?? '',
      slug: _parseString(json['slug']) ?? '',
      thumbnail: _parseString(json['thumbnail']),
      date: _parseString(json['date']) ?? '',
      time: _parseString(json['time']),
      venue: _parseString(json['venue']),
      city: _parseString(json['city']),
      price: json['price'] != null ? EventPriceDto.fromJson(json['price']) : null,
      isUpcoming: json['is_upcoming'] as bool? ?? true,
      favoritedAt: _parseString(json['favorited_at']),
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

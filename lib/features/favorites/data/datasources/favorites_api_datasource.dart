import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../../../events/data/models/event_dto.dart';
import '../models/favorite_list_dto.dart';

final favoritesApiDataSourceProvider = Provider<FavoritesApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return FavoritesApiDataSource(dio);
});

class FavoritesApiDataSource {
  final Dio _dio;

  FavoritesApiDataSource(this._dio);

  // ==================== FAVORIS ====================

  Future<List<FavoriteEventDto>> getFavorites({String? listId}) async {
    final queryParams = <String, dynamic>{};
    if (listId != null) {
      queryParams['list_id'] = listId;
    }

    final response = await _dio.get(
      '/me/favorites',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

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

  /// Ajouter un événement aux favoris (utilise toggle)
  /// [eventUuid] - UUID de l'événement (pas l'ID numérique)
  /// [listId] - UUID de la liste (optionnel)
  Future<void> addToFavorites(String eventUuid, {String? listId}) async {
    final response = await _dio.post(
      '/me/favorites/$eventUuid/toggle',
      data: listId != null ? {'list_id': listId} : null,
    );

    final data = response.data;
    if (data['success'] != true && data['data']?['is_favorite'] != true) {
      throw Exception(data['message'] ?? data['data']?['message'] ?? 'Failed to add to favorites');
    }
  }

  /// Retirer un événement des favoris
  /// [eventUuid] - UUID de l'événement (pas l'ID numérique)
  Future<void> removeFromFavorites(String eventUuid) async {
    final response = await _dio.delete('/me/favorites/$eventUuid');

    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? data['data']?['message'] ?? 'Failed to remove from favorites');
    }
  }

  /// Vérifier si un événement est dans les favoris
  /// [eventUuid] - UUID de l'événement (pas l'ID numérique)
  Future<bool> isFavorite(String eventUuid) async {
    final response = await _dio.get('/me/favorites/$eventUuid/check');

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return data['data']['is_favorite'] == true;
    }
    if (data['data'] != null) {
      return data['data']['is_favorite'] == true;
    }
    return false;
  }

  /// Toggle le statut favori d'un événement
  /// [eventUuid] - UUID de l'événement (pas l'ID numérique)
  /// [listId] - UUID de la liste (optionnel)
  Future<bool> toggleFavorite(String eventUuid, {String? listId}) async {
    final response = await _dio.post(
      '/me/favorites/$eventUuid/toggle',
      data: listId != null ? {'list_id': listId} : null,
    );

    final data = response.data;
    if (data['success'] == true && data['data'] != null) {
      return data['data']['is_favorite'] == true;
    }
    if (data['data'] != null && data['data']['is_favorite'] != null) {
      return data['data']['is_favorite'] == true;
    }
    throw Exception(data['message'] ?? data['data']?['message'] ?? 'Failed to toggle favorite');
  }

  /// Déplacer un favori vers une autre liste
  /// [eventUuid] - UUID de l'événement (pas l'ID numérique)
  /// [listId] - UUID de la nouvelle liste (null pour "non classé")
  Future<void> moveFavoriteToList(String eventUuid, String? listId) async {
    final response = await _dio.post(
      '/favorites/$eventUuid/move',
      data: {'list_id': listId},
    );

    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to move favorite');
    }
  }

  // ==================== LISTES ====================

  Future<List<FavoriteListDto>> getLists() async {
    final response = await _dio.get('/favorites/lists');

    final data = response.data;

    // Handle standard API response
    if (data is Map<String, dynamic> && data['data'] != null) {
      final listsData = data['data'];
      if (listsData is List) {
        return listsData
            .map((l) => FavoriteListDto.fromJson(l as Map<String, dynamic>))
            .toList();
      }
    }

    // Handle success format
    if (data['success'] == true && data['data'] != null) {
      final listsJson = data['data'] as List;
      return listsJson
          .map((l) => FavoriteListDto.fromJson(l as Map<String, dynamic>))
          .toList();
    }

    throw Exception(data['message'] ?? 'Failed to load favorite lists');
  }

  Future<FavoriteListDto> createList({
    required String name,
    String? description,
    String? color,
    String? icon,
  }) async {
    final response = await _dio.post(
      '/favorites/lists',
      data: FavoriteListRequest(
        name: name,
        description: description,
        color: color,
        icon: icon,
      ).toJson(),
    );

    final data = response.data;

    if (data['success'] == true && data['data'] != null) {
      return FavoriteListDto.fromJson(data['data'] as Map<String, dynamic>);
    }

    if (data is Map<String, dynamic> && data['data'] != null) {
      return FavoriteListDto.fromJson(data['data'] as Map<String, dynamic>);
    }

    throw Exception(data['message'] ?? 'Failed to create list');
  }

  Future<FavoriteListDto> getListDetails(String uuid) async {
    final response = await _dio.get('/favorites/lists/$uuid');

    final data = response.data;

    if (data['success'] == true && data['data'] != null) {
      return FavoriteListDto.fromJson(data['data'] as Map<String, dynamic>);
    }

    if (data is Map<String, dynamic> && data['data'] != null) {
      return FavoriteListDto.fromJson(data['data'] as Map<String, dynamic>);
    }

    throw Exception(data['message'] ?? 'Failed to load list details');
  }

  Future<FavoriteListDto> updateList(
    String uuid, {
    String? name,
    String? description,
    String? color,
    String? icon,
  }) async {
    final updateData = <String, dynamic>{};
    if (name != null) updateData['name'] = name;
    if (description != null) updateData['description'] = description;
    if (color != null) updateData['color'] = color;
    if (icon != null) updateData['icon'] = icon;

    final response = await _dio.put(
      '/favorites/lists/$uuid',
      data: updateData,
    );

    final data = response.data;

    if (data['success'] == true && data['data'] != null) {
      return FavoriteListDto.fromJson(data['data'] as Map<String, dynamic>);
    }

    if (data is Map<String, dynamic> && data['data'] != null) {
      return FavoriteListDto.fromJson(data['data'] as Map<String, dynamic>);
    }

    throw Exception(data['message'] ?? 'Failed to update list');
  }

  Future<void> deleteList(String uuid) async {
    final response = await _dio.delete('/favorites/lists/$uuid');

    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to delete list');
    }
  }

  Future<void> reorderLists(List<String> orderedUuids) async {
    final response = await _dio.post(
      '/favorites/lists/reorder',
      data: {'ordered_ids': orderedUuids},
    );

    final data = response.data;
    if (data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to reorder lists');
    }
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
  // Liste informations
  final String? listId;
  final String? listName;
  final String? listColor;
  final String? listIcon;

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
    this.listId,
    this.listName,
    this.listColor,
    this.listIcon,
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

    // Extract list info if available
    String? listId;
    String? listName;
    String? listColor;
    String? listIcon;
    if (json['list'] != null) {
      listId = _parseString(json['list']['uuid'] ?? json['list']['id']);
      listName = _parseString(json['list']['name']);
      listColor = _parseString(json['list']['color']);
      listIcon = _parseString(json['list']['icon']);
    } else {
      listId = _parseString(json['list_id'] ?? json['listId']);
      listName = _parseString(json['list_name'] ?? json['listName']);
      listColor = _parseString(json['list_color'] ?? json['listColor']);
      listIcon = _parseString(json['list_icon'] ?? json['listIcon']);
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
      listId: listId,
      listName: listName,
      listColor: listColor,
      listIcon: listIcon,
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

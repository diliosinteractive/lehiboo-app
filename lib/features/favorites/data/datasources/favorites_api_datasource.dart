import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../../../events/data/models/event_dto.dart';
import '../models/favorite_list_dto.dart';
import '../models/toggle_favorite_result.dart';

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

    final list = ApiResponseHandler.extractList(response.data);
    return list.map((f) => FavoriteEventDto.fromJson(f as Map<String, dynamic>)).toList();
  }

  /// Ajouter un événement aux favoris (utilise toggle)
  /// [eventUuid] - UUID de l'événement (pas l'ID numérique)
  /// [listId] - UUID de la liste (optionnel)
  ///
  /// Retourne le [ToggleFavoriteResult] qui peut contenir `hibonsAwarded` /
  /// `newHibonsBalance` si le backend a crédité une récompense (voir
  /// `HibonsService::awardFavoriteReward()` côté Laravel).
  Future<ToggleFavoriteResult> addToFavorites(String eventUuid, {String? listId}) async {
    final response = await _dio.post(
      '/me/favorites/$eventUuid/toggle',
      data: listId != null ? {'list_id': listId} : null,
    );

    return _parseToggleResponse(response.data);
  }

  /// Retirer un événement des favoris
  /// [eventUuid] - UUID de l'événement (pas l'ID numérique)
  Future<void> removeFromFavorites(String eventUuid) async {
    await _dio.delete('/me/favorites/$eventUuid');
  }

  /// Vérifier si un événement est dans les favoris
  /// [eventUuid] - UUID de l'événement (pas l'ID numérique)
  Future<bool> isFavorite(String eventUuid) async {
    final response = await _dio.get('/me/favorites/$eventUuid/check');
    final payload = ApiResponseHandler.extractObject(response.data, unwrapRoot: true);
    return payload['is_favorite'] == true;
  }

  /// Toggle le statut favori d'un événement
  /// [eventUuid] - UUID de l'événement (pas l'ID numérique)
  /// [listId] - UUID de la liste (optionnel)
  ///
  /// Retourne le [ToggleFavoriteResult] qui inclut `hibonsAwarded` /
  /// `newHibonsBalance` si le backend a crédité une récompense.
  Future<ToggleFavoriteResult> toggleFavorite(String eventUuid, {String? listId}) async {
    final response = await _dio.post(
      '/me/favorites/$eventUuid/toggle',
      data: listId != null ? {'list_id': listId} : null,
    );

    return _parseToggleResponse(response.data);
  }

  ToggleFavoriteResult _parseToggleResponse(dynamic data) {
    final payload = ApiResponseHandler.extractObject(data);
    return ToggleFavoriteResult.fromJson(payload);
  }

  /// Déplacer un favori vers une autre liste
  /// [eventUuid] - UUID de l'événement (pas l'ID numérique)
  /// [listId] - UUID de la nouvelle liste (null pour "non classé")
  Future<void> moveFavoriteToList(String eventUuid, String? listId) async {
    await _dio.post(
      '/favorites/$eventUuid/move',
      data: {'list_id': listId},
    );
  }

  // ==================== LISTES ====================

  Future<List<FavoriteListDto>> getLists() async {
    final response = await _dio.get('/favorites/lists');
    final list = ApiResponseHandler.extractList(response.data);
    return list.map((l) => FavoriteListDto.fromJson(l as Map<String, dynamic>)).toList();
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

    final payload = ApiResponseHandler.extractObject(response.data);
    return FavoriteListDto.fromJson(payload);
  }

  Future<FavoriteListDto> getListDetails(String uuid) async {
    final response = await _dio.get('/favorites/lists/$uuid');
    final payload = ApiResponseHandler.extractObject(response.data);
    return FavoriteListDto.fromJson(payload);
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

    final response = await _dio.put('/favorites/lists/$uuid', data: updateData);
    final payload = ApiResponseHandler.extractObject(response.data);
    return FavoriteListDto.fromJson(payload);
  }

  Future<void> deleteList(String uuid) async {
    await _dio.delete('/favorites/lists/$uuid');
  }

  Future<void> reorderLists(List<String> orderedUuids) async {
    await _dio.post(
      '/favorites/lists/reorder',
      data: {'ordered_ids': orderedUuids},
    );
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

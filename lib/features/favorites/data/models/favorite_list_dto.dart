import '../../domain/entities/favorite_list.dart';
import '../datasources/favorites_api_datasource.dart';

/// DTO pour les listes de favoris depuis l'API
class FavoriteListDto {
  final int id;
  final String uuid;
  final String name;
  final String? description;
  final String? color;
  final String? icon;
  final bool isDefault;
  final int sortOrder;
  final int favoritesCount;
  final List<FavoriteEventDto>? favorites;

  FavoriteListDto({
    required this.id,
    required this.uuid,
    required this.name,
    this.description,
    this.color,
    this.icon,
    this.isDefault = false,
    this.sortOrder = 0,
    this.favoritesCount = 0,
    this.favorites,
  });

  factory FavoriteListDto.fromJson(Map<String, dynamic> json) {
    List<FavoriteEventDto>? favoritesList;

    if (json['favorites'] != null && json['favorites'] is List) {
      favoritesList = (json['favorites'] as List)
          .map((f) => FavoriteEventDto.fromJson(f as Map<String, dynamic>))
          .toList();
    }

    return FavoriteListDto(
      id: _parseInt(json['id']),
      uuid: _parseString(json['uuid']) ?? '',
      name: _parseString(json['name']) ?? '',
      description: _parseString(json['description']),
      color: _parseString(json['color']),
      icon: _parseString(json['icon']),
      isDefault: json['is_default'] == true || json['isDefault'] == true,
      sortOrder: _parseInt(json['sort_order'] ?? json['sortOrder']),
      favoritesCount: _parseInt(json['favorites_count'] ?? json['favoritesCount']),
      favorites: favoritesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'name': name,
      'description': description,
      'color': color,
      'icon': icon,
      'is_default': isDefault,
      'sort_order': sortOrder,
      'favorites_count': favoritesCount,
    };
  }

  FavoriteList toEntity() {
    return FavoriteList(
      id: uuid,
      name: name,
      description: description,
      color: FavoriteListColors.fromString(color),
      icon: FavoriteListIcons.fromString(icon),
      isDefault: isDefault,
      sortOrder: sortOrder,
      favoritesCount: favoritesCount,
      favorites: null, // Les favoris sont chargés séparément si nécessaire
    );
  }
}

/// Requête pour créer/mettre à jour une liste
class FavoriteListRequest {
  final String name;
  final String? description;
  final String? color;
  final String? icon;

  FavoriteListRequest({
    required this.name,
    this.description,
    this.color,
    this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
    };
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

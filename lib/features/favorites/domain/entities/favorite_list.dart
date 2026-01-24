import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../events/domain/entities/event.dart';

/// Entité représentant une liste de favoris personnalisée
class FavoriteList extends Equatable {
  final String id;
  final String name;
  final String? description;
  final Color color;
  final IconData icon;
  final bool isDefault;
  final int sortOrder;
  final int favoritesCount;
  final List<Event>? favorites;

  const FavoriteList({
    required this.id,
    required this.name,
    this.description,
    this.color = const Color(0xFFFF601F),
    this.icon = Icons.favorite,
    this.isDefault = false,
    this.sortOrder = 0,
    this.favoritesCount = 0,
    this.favorites,
  });

  FavoriteList copyWith({
    String? id,
    String? name,
    String? description,
    Color? color,
    IconData? icon,
    bool? isDefault,
    int? sortOrder,
    int? favoritesCount,
    List<Event>? favorites,
  }) {
    return FavoriteList(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
      sortOrder: sortOrder ?? this.sortOrder,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        color,
        icon,
        isDefault,
        sortOrder,
        favoritesCount,
        favorites,
      ];
}

/// Couleurs prédéfinies pour les listes
class FavoriteListColors {
  static const Map<String, Color> values = {
    'orange': Color(0xFFFF601F),
    'red': Color(0xFFE53E3E),
    'blue': Color(0xFF3182CE),
    'green': Color(0xFF38A169),
    'purple': Color(0xFF805AD5),
    'yellow': Color(0xFFD69E2E),
    'pink': Color(0xFFED64A6),
    'gray': Color(0xFF718096),
  };

  static Color fromString(String? colorName) {
    return values[colorName] ?? values['orange']!;
  }

  static String toColorKey(Color color) {
    return values.entries
        .firstWhere(
          (e) => e.value.value == color.value,
          orElse: () => const MapEntry('orange', Color(0xFFFF601F)),
        )
        .key;
  }
}

/// Icônes prédéfinies pour les listes
class FavoriteListIcons {
  static const Map<String, IconData> values = {
    'heart': Icons.favorite,
    'star': Icons.star,
    'bookmark': Icons.bookmark,
    'folder': Icons.folder,
    'music': Icons.music_note,
    'sports': Icons.sports,
    'family': Icons.family_restroom,
    'calendar': Icons.calendar_today,
    'celebration': Icons.celebration,
    'local_activity': Icons.local_activity,
    'theater': Icons.theater_comedy,
    'nightlife': Icons.nightlife,
  };

  static IconData fromString(String? iconName) {
    return values[iconName] ?? values['heart']!;
  }

  static String toIconKey(IconData icon) {
    return values.entries
        .firstWhere(
          (e) => e.value.codePoint == icon.codePoint,
          orElse: () => const MapEntry('heart', Icons.favorite),
        )
        .key;
  }
}

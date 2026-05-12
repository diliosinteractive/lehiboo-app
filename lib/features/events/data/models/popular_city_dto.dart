import '../../domain/entities/popular_city.dart';

/// Wire format for `GET /v1/cities?featured_only=1[&only_with_upcoming_slots=1]`.
///
/// The endpoint emits both snake_case and camelCase keys (legacy dual-format
/// resource). Per the spec, we read only snake_case and stick with it.
/// `latitude` / `longitude` are emitted as strings (Eloquent decimal cast).
class PopularCityDto {
  final String uuid;
  final String name;
  final String slug;
  final String? region;
  final String? department;
  final String? imageUrl;
  final String? thumbnailUrl;
  final double? latitude;
  final double? longitude;
  final int eventsCount;
  final bool isFeatured;

  const PopularCityDto({
    required this.uuid,
    required this.name,
    required this.slug,
    required this.eventsCount,
    required this.isFeatured,
    this.region,
    this.department,
    this.imageUrl,
    this.thumbnailUrl,
    this.latitude,
    this.longitude,
  });

  factory PopularCityDto.fromJson(Map<String, dynamic> json) => PopularCityDto(
        uuid: json['uuid'] as String,
        name: json['name'] as String,
        slug: json['slug'] as String,
        region: json['region'] as String?,
        department: json['department'] as String?,
        imageUrl: json['image_url'] as String?,
        thumbnailUrl: json['thumbnail_url'] as String?,
        latitude: _parseDecimal(json['latitude']),
        longitude: _parseDecimal(json['longitude']),
        eventsCount: (json['events_count'] as num?)?.toInt() ?? 0,
        isFeatured: (json['is_featured'] as bool?) ?? false,
      );

  PopularCity toEntity() => PopularCity(
        uuid: uuid,
        name: name,
        slug: slug,
        region: region,
        department: department,
        imageUrl: imageUrl,
        thumbnailUrl: thumbnailUrl,
        latitude: latitude,
        longitude: longitude,
        eventsCount: eventsCount,
        isFeatured: isFeatured,
      );

  static double? _parseDecimal(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

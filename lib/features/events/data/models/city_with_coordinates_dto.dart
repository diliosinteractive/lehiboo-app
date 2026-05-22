import 'package:flutter/foundation.dart';

class CityWithCoordinatesDto {
  final String name;
  final String slug;
  final String? department;
  final String? region;
  final int eventCount;
  final double lat;
  final double lng;
  final String? imageUrl;
  final String? thumbnailUrl;

  CityWithCoordinatesDto({
    required this.name,
    required this.slug,
    this.department,
    this.region,
    required this.eventCount,
    required this.lat,
    required this.lng,
    this.imageUrl,
    this.thumbnailUrl,
  });

  factory CityWithCoordinatesDto.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as Map<String, dynamic>?;

    final lat = _readDouble(
      coords?['lat'] ?? coords?['latitude'] ?? json['lat'] ?? json['latitude'],
    );
    final lng = _readDouble(
      coords?['lng'] ??
          coords?['lon'] ??
          coords?['longitude'] ??
          json['lng'] ??
          json['lon'] ??
          json['longitude'],
    );

    if (kDebugMode && (lat == 0.0 || lng == 0.0)) {
      debugPrint(
        '⚠️ CityWithCoordinatesDto: lat/lng manquants pour "${json['name']}" '
        '— payload: $json',
      );
    }

    final name = json['name'] as String? ?? 'Inconnue';
    final slug = json['slug'] as String?;

    return CityWithCoordinatesDto(
      name: name,
      slug: slug?.isNotEmpty == true ? slug! : _fallbackSlug(name),
      department: json['department'] as String?,
      region: json['region'] as String?,
      eventCount: (json['events_count'] as num?)?.toInt() ?? 0,
      lat: lat,
      lng: lng,
      imageUrl: _readNullableString(json['image_url'] ?? json['imageUrl']),
      thumbnailUrl:
          _readNullableString(json['thumbnail_url'] ?? json['thumbnailUrl']),
    );
  }

  static double _readDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static String _fallbackSlug(String name) => name.toLowerCase().replaceAll(
        RegExp(r'\s+'),
        '-',
      );

  static String? _readNullableString(dynamic value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}

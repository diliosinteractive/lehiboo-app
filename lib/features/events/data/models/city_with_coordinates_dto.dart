import 'package:flutter/foundation.dart';

class CityWithCoordinatesDto {
  final String name;
  final String? department;
  final String? region;
  final int eventCount;
  final double lat;
  final double lng;
  final String? imageUrl;

  CityWithCoordinatesDto({
    required this.name,
    this.department,
    this.region,
    required this.eventCount,
    required this.lat,
    required this.lng,
    this.imageUrl,
  });

  factory CityWithCoordinatesDto.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as Map<String, dynamic>?;

    final lat = _readDouble(
      coords?['lat'] ??
          coords?['latitude'] ??
          json['lat'] ??
          json['latitude'],
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

    return CityWithCoordinatesDto(
      name: json['name'] as String? ?? 'Inconnue',
      department: json['department'] as String?,
      region: json['region'] as String?,
      eventCount: (json['event_count'] as num?)?.toInt() ?? 0,
      lat: lat,
      lng: lng,
      imageUrl: json['image_url'] as String?,
    );
  }

  static double _readDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

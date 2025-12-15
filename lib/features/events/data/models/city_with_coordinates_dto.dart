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
    final coords = json['coordinates'] as Map<String, dynamic>? ?? {};
    return CityWithCoordinatesDto(
      name: json['name'] as String? ?? 'Inconnue',
      department: json['department'] as String?,
      region: json['region'] as String?,
      eventCount: json['event_count'] as int? ?? 0,
      lat: (coords['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (coords['lng'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String?,
    );
  }
}

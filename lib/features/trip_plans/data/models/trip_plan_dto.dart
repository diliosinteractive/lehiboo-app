import '../../domain/entities/trip_plan.dart';

class TripPlanDto {
  final String uuid;
  final String title;
  final String? plannedDate;
  final String? startTime;
  final String? endTime;
  final int? totalDurationMinutes;
  final double? totalDistanceKm;
  final double? score;
  final int stopsCount;
  final List<TripStopDto> stops;
  final List<String> recommendations;
  final String createdAt;

  TripPlanDto({
    required this.uuid,
    required this.title,
    this.plannedDate,
    this.startTime,
    this.endTime,
    this.totalDurationMinutes,
    this.totalDistanceKm,
    this.score,
    required this.stopsCount,
    required this.stops,
    this.recommendations = const [],
    required this.createdAt,
  });

  factory TripPlanDto.fromJson(Map<String, dynamic> json) {
    // Parse stops
    final stopsData = json['stops'] as List<dynamic>? ?? [];
    final stops = stopsData
        .map((s) => TripStopDto.fromJson(s as Map<String, dynamic>))
        .toList();

    // Parse recommendations
    final recsData = json['recommendations'] as List<dynamic>? ?? [];
    final recommendations = recsData.map((r) => r.toString()).toList();

    return TripPlanDto(
      uuid: json['uuid'] as String? ?? '',
      title: json['title'] as String? ?? 'Plan sans titre',
      plannedDate: json['planned_date'] as String? ?? json['plannedDate'] as String?,
      startTime: json['start_time'] as String? ?? json['startTime'] as String?,
      endTime: json['end_time'] as String? ?? json['endTime'] as String?,
      totalDurationMinutes: _parseIntOrNull(json['total_duration_minutes'] ?? json['duration_minutes'] ?? json['durationMinutes']),
      totalDistanceKm: _parseDoubleOrNull(json['total_distance_km'] ?? json['totalDistanceKm']),
      score: _parseDoubleOrNull(json['score']),
      stopsCount: _parseIntOrNull(json['stops_count'] ?? json['stopsCount']) ?? stops.length,
      stops: stops,
      recommendations: recommendations,
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  /// Parse a value that could be int, double, or String to int
  static int? _parseIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Parse a value that could be int, double, or String to double
  static double? _parseDoubleOrNull(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'title': title,
      'planned_date': plannedDate,
      'start_time': startTime,
      'end_time': endTime,
      'total_duration_minutes': totalDurationMinutes,
      'total_distance_km': totalDistanceKm,
      'score': score,
      'stops_count': stopsCount,
      'stops': stops.map((s) => s.toJson()).toList(),
      'recommendations': recommendations,
      'created_at': createdAt,
    };
  }

  TripPlan toEntity() {
    return TripPlan(
      uuid: uuid,
      title: title,
      plannedDate: plannedDate != null ? DateTime.tryParse(plannedDate!) : null,
      startTime: startTime,
      endTime: endTime,
      totalDurationMinutes: totalDurationMinutes,
      totalDistanceKm: totalDistanceKm,
      score: score,
      stopsCount: stopsCount,
      stops: stops.map((s) => s.toEntity()).toList(),
      recommendations: recommendations,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
    );
  }
}

class TripStopDto {
  final int order;
  final String? eventUuid;
  final String? eventSlug;
  final String eventTitle;
  final String? venueName;
  final String? address;
  final String? city;
  final String? imageUrl;
  final String? arrivalTime;
  final String? departureTime;
  final int? durationMinutes;
  final double? travelFromPreviousKm;
  final int? travelFromPreviousMinutes;
  final double? latitude;
  final double? longitude;

  TripStopDto({
    required this.order,
    this.eventUuid,
    this.eventSlug,
    required this.eventTitle,
    this.venueName,
    this.address,
    this.city,
    this.imageUrl,
    this.arrivalTime,
    this.departureTime,
    this.durationMinutes,
    this.travelFromPreviousKm,
    this.travelFromPreviousMinutes,
    this.latitude,
    this.longitude,
  });

  factory TripStopDto.fromJson(Map<String, dynamic> json) {
    // Extract coordinates from nested or flat structure
    double? lat, lng;
    if (json['coordinates'] is Map<String, dynamic>) {
      final coords = json['coordinates'] as Map<String, dynamic>;
      lat = (coords['lat'] as num?)?.toDouble();
      lng = (coords['lng'] as num?)?.toDouble();
    } else {
      lat = (json['latitude'] as num?)?.toDouble();
      lng = (json['longitude'] as num?)?.toDouble();
    }

    // Extract from nested event object if present
    final eventObj = json['event'] as Map<String, dynamic>?;

    String? eventUuid = json['event_uuid'] as String?;
    String? eventSlug;
    String eventTitle = 'Étape';
    String? venueName = json['venue_name'] as String?;
    String? city = json['city'] as String?;
    String? imageUrl;

    if (eventObj != null) {
      eventUuid ??= eventObj['uuid'] as String?;
      eventSlug = eventObj['slug'] as String?;
      eventTitle = eventObj['title'] as String? ??
                   json['event_title'] as String? ??
                   'Étape';
      venueName ??= eventObj['venue_name'] as String?;
      city ??= eventObj['city'] as String?;
      imageUrl = eventObj['image'] as String? ?? eventObj['image_url'] as String?;
    } else {
      eventTitle = json['event_title'] as String? ??
                   json['title'] as String? ??
                   'Étape';
    }

    return TripStopDto(
      order: (json['order'] as num?)?.toInt() ?? 0,
      eventUuid: eventUuid,
      eventSlug: eventSlug,
      eventTitle: eventTitle,
      venueName: venueName,
      address: json['address'] as String?,
      city: city,
      imageUrl: imageUrl,
      arrivalTime: json['arrival_time'] as String?,
      departureTime: json['departure_time'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      travelFromPreviousKm: (json['travel_from_previous_km'] as num?)?.toDouble(),
      travelFromPreviousMinutes: (json['travel_from_previous_minutes'] as num?)?.toInt(),
      latitude: lat,
      longitude: lng,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'event_uuid': eventUuid,
      'event_slug': eventSlug,
      'event_title': eventTitle,
      'venue_name': venueName,
      'address': address,
      'city': city,
      'image_url': imageUrl,
      'arrival_time': arrivalTime,
      'departure_time': departureTime,
      'duration_minutes': durationMinutes,
      'travel_from_previous_km': travelFromPreviousKm,
      'travel_from_previous_minutes': travelFromPreviousMinutes,
      'coordinates': {
        'lat': latitude,
        'lng': longitude,
      },
    };
  }

  TripStop toEntity() {
    return TripStop(
      order: order,
      eventUuid: eventUuid,
      eventSlug: eventSlug,
      eventTitle: eventTitle,
      venueName: venueName,
      address: address,
      city: city,
      imageUrl: imageUrl,
      arrivalTime: arrivalTime,
      departureTime: departureTime,
      durationMinutes: durationMinutes,
      travelFromPreviousKm: travelFromPreviousKm,
      travelFromPreviousMinutes: travelFromPreviousMinutes,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

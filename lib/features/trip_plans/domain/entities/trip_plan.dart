class TripPlan {
  final String uuid;
  final String title;
  final DateTime? plannedDate;
  final String? startTime;
  final String? endTime;
  final int? totalDurationMinutes;
  final double? totalDistanceKm;
  final double? score;
  final int stopsCount;
  final List<TripStop> stops;
  final List<String> recommendations;
  final DateTime createdAt;

  const TripPlan({
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

  /// Returns a human-readable duration string
  String get formattedDuration {
    if (totalDurationMinutes == null) return '';
    final hours = totalDurationMinutes! ~/ 60;
    final mins = totalDurationMinutes! % 60;
    if (hours == 0) return '${mins}min';
    if (mins == 0) return '${hours}h';
    return '${hours}h${mins.toString().padLeft(2, '0')}';
  }

  /// Returns the time range as "HH:mm - HH:mm"
  String? get timeRange {
    if (startTime == null || endTime == null) return null;
    return '$startTime - $endTime';
  }

  /// Copy with method for updates
  TripPlan copyWith({
    String? uuid,
    String? title,
    DateTime? plannedDate,
    String? startTime,
    String? endTime,
    int? totalDurationMinutes,
    double? totalDistanceKm,
    double? score,
    int? stopsCount,
    List<TripStop>? stops,
    List<String>? recommendations,
    DateTime? createdAt,
  }) {
    return TripPlan(
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      plannedDate: plannedDate ?? this.plannedDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      score: score ?? this.score,
      stopsCount: stopsCount ?? this.stopsCount,
      stops: stops ?? this.stops,
      recommendations: recommendations ?? this.recommendations,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TripStop {
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

  const TripStop({
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

  /// Returns the best identifier for navigation (slug preferred, then uuid)
  String? get eventIdentifier => eventSlug ?? eventUuid;

  /// Check if this stop has valid coordinates
  bool get hasCoordinates =>
      latitude != null &&
      longitude != null &&
      latitude != 0.0 &&
      longitude != 0.0;

  /// Returns venue + city as a location string
  String get locationString {
    final parts = <String>[];
    if (venueName != null && venueName!.isNotEmpty) parts.add(venueName!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    return parts.join(', ');
  }

  /// Returns formatted duration
  String get formattedDuration {
    if (durationMinutes == null) return '';
    if (durationMinutes! < 60) return '${durationMinutes}min';
    final hours = durationMinutes! ~/ 60;
    final mins = durationMinutes! % 60;
    if (mins == 0) return '${hours}h';
    return '${hours}h${mins.toString().padLeft(2, '0')}';
  }

  /// Copy with method for updates
  TripStop copyWith({
    int? order,
    String? eventUuid,
    String? eventSlug,
    String? eventTitle,
    String? venueName,
    String? address,
    String? city,
    String? imageUrl,
    String? arrivalTime,
    String? departureTime,
    int? durationMinutes,
    double? travelFromPreviousKm,
    int? travelFromPreviousMinutes,
    double? latitude,
    double? longitude,
  }) {
    return TripStop(
      order: order ?? this.order,
      eventUuid: eventUuid ?? this.eventUuid,
      eventSlug: eventSlug ?? this.eventSlug,
      eventTitle: eventTitle ?? this.eventTitle,
      venueName: venueName ?? this.venueName,
      address: address ?? this.address,
      city: city ?? this.city,
      imageUrl: imageUrl ?? this.imageUrl,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureTime: departureTime ?? this.departureTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      travelFromPreviousKm: travelFromPreviousKm ?? this.travelFromPreviousKm,
      travelFromPreviousMinutes: travelFromPreviousMinutes ?? this.travelFromPreviousMinutes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

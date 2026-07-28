import 'package:equatable/equatable.dart';

enum StoryMediaType { image, video }

class Story extends Equatable {
  final String uuid;
  final String title;
  final String mediaUrl;
  final StoryMediaType mediaType;
  final String? posterUrl;
  final String type; // "reserved" or "optional"
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? eventStartDate;
  final int slotPosition;
  final int impressionsCount;
  final DateTime? updatedAt;

  // Flattened from nested event object
  final String eventUuid;
  final String eventSlug;
  final String eventTitle;
  final String? eventFeaturedImage;
  final String? eventCity;
  final String? eventBookingMode;
  final String? eventTagName;

  // Flattened from nested organization object
  final String? organizationName;

  // Flattened from nested category object
  final String? categoryName;

  const Story({
    required this.uuid,
    required this.title,
    required this.mediaUrl,
    required this.mediaType,
    this.posterUrl,
    required this.type,
    required this.startDate,
    required this.endDate,
    this.eventStartDate,
    required this.slotPosition,
    required this.impressionsCount,
    this.updatedAt,
    required this.eventUuid,
    required this.eventSlug,
    required this.eventTitle,
    this.eventFeaturedImage,
    this.eventCity,
    this.eventBookingMode,
    this.eventTagName,
    this.organizationName,
    this.categoryName,
  });

  String get viewedStateKey {
    final version = updatedAt?.toUtc().toIso8601String();
    return version == null ? uuid : '$uuid:$version';
  }

  @override
  List<Object?> get props => [uuid, updatedAt];
}

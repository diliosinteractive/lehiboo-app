class StoryCategoryDto {
  final int id;
  final String name;

  StoryCategoryDto({required this.id, required this.name});

  factory StoryCategoryDto.fromJson(Map<String, dynamic> json) {
    return StoryCategoryDto(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class StoryOrganizationDto {
  final String uuid;
  final String? organizationName;
  final String? displayName;

  StoryOrganizationDto({
    required this.uuid,
    this.organizationName,
    this.displayName,
  });

  factory StoryOrganizationDto.fromJson(Map<String, dynamic> json) {
    return StoryOrganizationDto(
      uuid: json['uuid'] as String? ?? '',
      organizationName: json['organization_name'] as String?
          ?? json['organizationName'] as String?,
      displayName: json['display_name'] as String?
          ?? json['displayName'] as String?,
    );
  }
}

class StoryEventTagDto {
  final int id;
  final String name;

  StoryEventTagDto({required this.id, required this.name});

  factory StoryEventTagDto.fromJson(Map<String, dynamic> json) {
    return StoryEventTagDto(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class StoryEventDto {
  final String uuid;
  final String slug;
  final String title;
  final String? featuredImage;
  final String? city;
  final String? bookingMode;
  final StoryCategoryDto? primaryCategory;
  final StoryEventTagDto? eventTag;

  StoryEventDto({
    required this.uuid,
    required this.slug,
    required this.title,
    this.featuredImage,
    this.city,
    this.bookingMode,
    this.primaryCategory,
    this.eventTag,
  });

  /// Parses both camelCase (old format) and snake_case (MobileEventResource).
  factory StoryEventDto.fromJson(Map<String, dynamic> json) {
    // featured_image may be a string URL or an object with size variants
    String? image = json['featured_image'] as String?
        ?? json['featuredImage'] as String?;
    if (image == null && json['featured_image'] is Map) {
      final map = json['featured_image'] as Map;
      image = map['large'] as String? ?? map['full'] as String?
          ?? map['medium'] as String? ?? map['thumbnail'] as String?;
    }

    final categoryRaw = json['primary_category'] ?? json['primaryCategory'];
    final tagRaw = json['event_tag'] ?? json['eventTag'];

    return StoryEventDto(
      uuid: json['uuid'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      featuredImage: image,
      city: json['city'] as String?,
      bookingMode: json['booking_mode'] as String?
          ?? json['bookingMode'] as String?,
      primaryCategory: categoryRaw is Map<String, dynamic>
          ? StoryCategoryDto.fromJson(categoryRaw)
          : null,
      eventTag: tagRaw is Map<String, dynamic>
          ? StoryEventTagDto.fromJson(tagRaw)
          : null,
    );
  }
}

class StoryDto {
  final String uuid;
  final String type;
  final String status;
  final String title;
  final String mediaUrl;
  final String mediaType;
  final String? posterUrl;
  final String startDate;
  final String endDate;
  final int slotPosition;
  final int impressionsCount;
  final StoryOrganizationDto? organization;
  final StoryEventDto? event;

  StoryDto({
    required this.uuid,
    required this.type,
    required this.status,
    required this.title,
    required this.mediaUrl,
    required this.mediaType,
    this.posterUrl,
    required this.startDate,
    required this.endDate,
    required this.slotPosition,
    required this.impressionsCount,
    this.organization,
    this.event,
  });

  /// Parses both camelCase (old format) and snake_case (mobile format).
  factory StoryDto.fromJson(Map<String, dynamic> json) {
    final orgRaw = json['organization'] ?? json['organizer'];
    final eventRaw = json['event'];

    return StoryDto(
      uuid: json['uuid'] as String? ?? '',
      type: json['type'] as String? ?? 'optional',
      status: json['status'] as String? ?? 'active',
      title: json['title'] as String? ?? '',
      mediaUrl: json['media_url'] as String?
          ?? json['mediaUrl'] as String? ?? '',
      mediaType: json['media_type'] as String?
          ?? json['mediaType'] as String? ?? 'image',
      posterUrl: json['poster_url'] as String?
          ?? json['posterUrl'] as String?,
      startDate: json['start_date'] as String?
          ?? json['startDate'] as String? ?? '',
      endDate: json['end_date'] as String?
          ?? json['endDate'] as String? ?? '',
      slotPosition: json['slot_position'] as int?
          ?? json['slotPosition'] as int? ?? 0,
      impressionsCount: json['impressions_count'] as int?
          ?? json['impressionsCount'] as int? ?? 0,
      organization: orgRaw is Map<String, dynamic>
          ? StoryOrganizationDto.fromJson(orgRaw)
          : null,
      event: eventRaw is Map<String, dynamic>
          ? StoryEventDto.fromJson(eventRaw)
          : null,
    );
  }
}

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
      organizationName: json['organizationName'] as String?,
      displayName: json['displayName'] as String?,
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

  StoryEventDto({
    required this.uuid,
    required this.slug,
    required this.title,
    this.featuredImage,
    this.city,
    this.bookingMode,
    this.primaryCategory,
  });

  factory StoryEventDto.fromJson(Map<String, dynamic> json) {
    return StoryEventDto(
      uuid: json['uuid'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      featuredImage: json['featuredImage'] as String?,
      city: json['city'] as String?,
      bookingMode: json['bookingMode'] as String?,
      primaryCategory: json['primaryCategory'] != null
          ? StoryCategoryDto.fromJson(json['primaryCategory'] as Map<String, dynamic>)
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
    required this.startDate,
    required this.endDate,
    required this.slotPosition,
    required this.impressionsCount,
    this.organization,
    this.event,
  });

  factory StoryDto.fromJson(Map<String, dynamic> json) {
    return StoryDto(
      uuid: json['uuid'] as String? ?? '',
      type: json['type'] as String? ?? 'optional',
      status: json['status'] as String? ?? 'active',
      title: json['title'] as String? ?? '',
      mediaUrl: json['mediaUrl'] as String? ?? '',
      mediaType: json['mediaType'] as String? ?? 'image',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      slotPosition: json['slotPosition'] as int? ?? 0,
      impressionsCount: json['impressionsCount'] as int? ?? 0,
      organization: json['organization'] != null
          ? StoryOrganizationDto.fromJson(json['organization'] as Map<String, dynamic>)
          : null,
      event: json['event'] != null
          ? StoryEventDto.fromJson(json['event'] as Map<String, dynamic>)
          : null,
    );
  }
}

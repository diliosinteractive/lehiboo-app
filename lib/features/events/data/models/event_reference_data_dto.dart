class EventReferenceDataDto {
  final List<EventReferenceCategoryDto> categories;
  final List<EventReferenceOptionDto> eventTags;
  final List<EventReferenceAudienceGroupDto> audienceGroups;
  final List<EventReferenceOptionDto> themes;
  final List<EventReferenceOptionDto> specialEvents;
  final List<EventReferenceOptionDto> emotions;

  const EventReferenceDataDto({
    required this.categories,
    required this.eventTags,
    required this.audienceGroups,
    required this.themes,
    required this.specialEvents,
    required this.emotions,
  });

  factory EventReferenceDataDto.fromJson(Map<String, dynamic> json) {
    return EventReferenceDataDto(
      categories: _asList(json['categories'])
          .map(EventReferenceCategoryDto.fromJson)
          .toList(),
      eventTags: _asList(json['event_tags'])
          .map(EventReferenceOptionDto.fromJson)
          .toList(),
      audienceGroups: _asList(json['audience_groups'])
          .map(EventReferenceAudienceGroupDto.fromJson)
          .toList(),
      themes: _asList(json['themes'])
          .map(EventReferenceOptionDto.fromJson)
          .toList(),
      specialEvents: _asList(json['special_events'])
          .map(EventReferenceOptionDto.fromJson)
          .toList(),
      emotions: _asList(json['emotions'])
          .map(EventReferenceOptionDto.fromJson)
          .toList(),
    );
  }
}

class EventReferenceOptionDto {
  final int id;
  final String name;
  final String slug;
  final String? icon;
  final String? color;
  final String? group;
  final int? eventCount;

  const EventReferenceOptionDto({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    this.color,
    this.group,
    this.eventCount,
  });

  factory EventReferenceOptionDto.fromJson(Map<String, dynamic> json) {
    return EventReferenceOptionDto(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      slug: _asString(json['slug']),
      icon: _asNullableString(json['icon']),
      color: _asNullableString(json['color']),
      group: _asNullableString(json['group']),
      eventCount: _asNullableInt(
        json['eventsCount'] ?? json['event_count'] ?? json['count'],
      ),
    );
  }
}

class EventReferenceCategoryDto extends EventReferenceOptionDto {
  final int? parentId;
  final List<EventReferenceCategoryDto> children;

  const EventReferenceCategoryDto({
    required super.id,
    required super.name,
    required super.slug,
    super.icon,
    super.color,
    super.group,
    super.eventCount,
    this.parentId,
    this.children = const [],
  });

  factory EventReferenceCategoryDto.fromJson(Map<String, dynamic> json) {
    return EventReferenceCategoryDto(
      id: _asInt(json['id']),
      parentId: _asNullableInt(json['parent_id']),
      name: _asString(json['name']),
      slug: _asString(json['slug']),
      icon: _asNullableString(json['icon']),
      color: _asNullableString(json['color']),
      eventCount: _asNullableInt(
        json['eventsCount'] ?? json['event_count'] ?? json['count'],
      ),
      children: _asList(json['children'])
          .map(EventReferenceCategoryDto.fromJson)
          .toList(),
    );
  }
}

class EventReferenceAudienceGroupDto {
  final int id;
  final String name;
  final String slug;
  final List<EventReferenceOptionDto> audiences;

  const EventReferenceAudienceGroupDto({
    required this.id,
    required this.name,
    required this.slug,
    required this.audiences,
  });

  factory EventReferenceAudienceGroupDto.fromJson(Map<String, dynamic> json) {
    return EventReferenceAudienceGroupDto(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      slug: _asString(json['slug']),
      audiences: _asList(json['audiences'])
          .map(EventReferenceOptionDto.fromJson)
          .toList(),
    );
  }
}

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is List) {
    return value.whereType<Map<String, dynamic>>().toList();
  }

  if (value is Map<String, dynamic> && value['data'] is List) {
    return (value['data'] as List).whereType<Map<String, dynamic>>().toList();
  }

  return const [];
}

String _asString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map) {
    final translated = value['fr'] ?? value['en'] ?? value['rendered'];
    if (translated != null) return translated.toString();
  }
  return value.toString();
}

String? _asNullableString(dynamic value) {
  final parsed = _asString(value);
  return parsed.isEmpty ? null : parsed;
}

int _asInt(dynamic value) => _asNullableInt(value) ?? 0;

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

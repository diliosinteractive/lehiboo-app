class SearchSuggestionsDto {
  final List<SearchSuggestionItemDto> events;
  final List<SearchSuggestionItemDto> organizations;
  final List<SearchSuggestionItemDto> cities;
  final List<SearchSuggestionItemDto> categories;

  const SearchSuggestionsDto({
    this.events = const [],
    this.organizations = const [],
    this.cities = const [],
    this.categories = const [],
  });

  const SearchSuggestionsDto.empty() : this();

  factory SearchSuggestionsDto.fromJson(Map<String, dynamic> json) {
    return SearchSuggestionsDto(
      events: _asList(json['events'] ?? json['activities'])
          .map((item) => SearchSuggestionItemDto.fromJson(item, 'event'))
          .toList(),
      organizations: _asList(json['organizations'] ?? json['organizers'])
          .map((item) => SearchSuggestionItemDto.fromJson(item, 'organization'))
          .toList(),
      cities: _asList(json['cities'])
          .map((item) => SearchSuggestionItemDto.fromJson(item, 'city'))
          .toList(),
      categories: _asList(json['categories'])
          .map((item) => SearchSuggestionItemDto.fromJson(item, 'category'))
          .toList(),
    );
  }
}

class SearchSuggestionItemDto {
  final String type;
  final String id;
  final String slug;
  final String label;
  final String? subtitle;
  final int? eventsCount;
  final String? imageUrl;
  final String? logoUrl;
  final String? city;

  const SearchSuggestionItemDto({
    required this.type,
    required this.id,
    required this.slug,
    required this.label,
    this.subtitle,
    this.eventsCount,
    this.imageUrl,
    this.logoUrl,
    this.city,
  });

  factory SearchSuggestionItemDto.fromJson(
    Map<String, dynamic> json,
    String fallbackType,
  ) {
    final label = _firstString(
      json['label'],
      json['displayLabel'],
      json['display_label'],
      json['title'],
      json['name'],
    );

    return SearchSuggestionItemDto(
      type: _asString(json['type']).isEmpty
          ? fallbackType
          : _asString(json['type']),
      id: _asString(json['id']),
      slug: _asString(json['slug']),
      label: label,
      subtitle: _firstNullableString(
        json['subtitle'],
        json['organizer_name'],
        json['organizerName'],
        json['city'],
      ),
      eventsCount: _asNullableInt(
        json['eventsCount'] ?? json['event_count'] ?? json['count'],
      ),
      imageUrl: _firstNullableString(json['imageUrl'], json['image_url']),
      logoUrl: _firstNullableString(json['logoUrl'], json['logo_url']),
      city: _firstNullableString(json['city']),
    );
  }
}

List<Map<String, dynamic>> _asList(dynamic value) {
  if (value is List) {
    return value.whereType<Map<String, dynamic>>().toList();
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

String _firstString(Object? first,
    [Object? second, Object? third, Object? fourth, Object? fifth]) {
  return _firstNullableString(first, second, third, fourth, fifth) ?? '';
}

String? _firstNullableString(
  Object? first, [
  Object? second,
  Object? third,
  Object? fourth,
  Object? fifth,
]) {
  for (final value in [first, second, third, fourth, fifth]) {
    final parsed = _asString(value).trim();
    if (parsed.isNotEmpty) return parsed;
  }
  return null;
}

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

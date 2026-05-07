import '../../../events/data/models/event_dto.dart';

/// Grouped "Pour vous" feed payload — spec
/// `docs/PERSONALIZED_FEED_MOBILE_SPEC.md` §3.1 (rev 2026-05).
///
/// Replaces the legacy flat list shape `{success, data: [...]}` with a
/// keyed bag of seven sections. Cross-section overlap is intentional:
/// the same event may appear in `favorites` *and* `booked`, etc. (§3.2).
/// The per-event payload does **not** carry reliable `is_favorite` /
/// `is_members_only` markers for "is this in section X" purposes
/// (§3.3, §4.3) — section attribution is the source of truth, surfaced
/// to the UI via [EventWithSections.sections].
///
/// All seven keys default to `const []` when missing so the rest of the
/// pipeline can read fields without null-checks.
class PersonalizedFeedDto {
  final List<EventDto> favorites;
  final List<EventDto> reminders;
  // `private` is a reserved word in Dart — we expose the JSON key as
  // [privateEvents] in code while [PersonalizedFeedDto.fromJson] reads
  // the `private` map entry.
  final List<EventDto> privateEvents;
  final List<EventDto> booked;
  final List<EventDto> upcoming;
  final List<EventDto> ongoing;
  final List<EventDto> followed;

  const PersonalizedFeedDto({
    this.favorites = const [],
    this.reminders = const [],
    this.privateEvents = const [],
    this.booked = const [],
    this.upcoming = const [],
    this.ongoing = const [],
    this.followed = const [],
  });

  factory PersonalizedFeedDto.fromJson(Map<String, dynamic> data) {
    return PersonalizedFeedDto(
      favorites: _parseEventList(data['favorites']),
      reminders: _parseEventList(data['reminders']),
      privateEvents: _parseEventList(data['private']),
      booked: _parseEventList(data['booked']),
      upcoming: _parseEventList(data['upcoming']),
      ongoing: _parseEventList(data['ongoing']),
      followed: _parseEventList(data['followed']),
    );
  }

  factory PersonalizedFeedDto.empty() => const PersonalizedFeedDto();

  bool get isCompletelyEmpty =>
      favorites.isEmpty &&
      reminders.isEmpty &&
      privateEvents.isEmpty &&
      booked.isEmpty &&
      upcoming.isEmpty &&
      ongoing.isEmpty &&
      followed.isEmpty;
}

/// Source-of-truth marker for "this event came from section X" — see
/// spec §3.3 / §4.3. The flat per-event payload's booleans (e.g.
/// `is_favorite`, `is_members_only`) are unreliable for the carousel's
/// badging needs, so we lean on section attribution instead.
enum PersonalizedSection {
  ongoing,
  upcoming,
  private,
  favorites,
  reminders,
  followed,
  booked,
}

/// Priority order from spec §4.1 — when an event appears in multiple
/// sections we slot it at the *highest-priority* section's position and
/// merge the section markers. The order below MUST match the spec.
const List<PersonalizedSection> _priorityOrder = <PersonalizedSection>[
  PersonalizedSection.ongoing,
  PersonalizedSection.upcoming,
  PersonalizedSection.private,
  PersonalizedSection.favorites,
  PersonalizedSection.reminders,
  PersonalizedSection.followed,
  PersonalizedSection.booked,
];

/// Single carousel entry: an event plus the set of sections it belongs
/// to. Lets the UI render section-specific badges (e.g. "Privé 🔒",
/// "Favori") without re-deriving from per-event flags. The set is
/// defensively copied at construction.
class EventWithSections {
  final EventDto event;
  final Set<PersonalizedSection> sections;

  EventWithSections(this.event, Set<PersonalizedSection> sections)
      : sections = {...sections};
}

/// What the provider hands to the UI: the raw grouped DTO (kept for
/// section-specific consumers that may want the original lists) plus
/// the deduped, priority-ordered carousel projection.
class PersonalizedFeedView {
  final PersonalizedFeedDto raw;
  final List<EventWithSections> ordered;

  const PersonalizedFeedView({required this.raw, required this.ordered});

  factory PersonalizedFeedView.empty() => PersonalizedFeedView(
        raw: PersonalizedFeedDto.empty(),
        ordered: const [],
      );

  bool get isEmpty => ordered.isEmpty;
}

/// Build the deduped, priority-ordered carousel list from a grouped
/// feed DTO — spec §4.1.
///
/// Algorithm: walk sections in priority order; for each event, key by
/// `uuid` (preferred) or `id.toString()` fallback. First sighting
/// records the event at its position; later sightings only merge their
/// section marker into the existing entry. Result preserves the order
/// in which events are first seen across the priority walk.
List<EventWithSections> buildOrdered(PersonalizedFeedDto dto) {
  final ordered = <EventWithSections>[];
  final seen = <String, EventWithSections>{};

  for (final section in _priorityOrder) {
    final list = _listForSection(dto, section);
    for (final event in list) {
      final key = _keyFor(event);
      final existing = seen[key];
      if (existing == null) {
        final entry = EventWithSections(event, {section});
        seen[key] = entry;
        ordered.add(entry);
      } else {
        existing.sections.add(section);
      }
    }
  }

  return ordered;
}

List<EventDto> _listForSection(
  PersonalizedFeedDto dto,
  PersonalizedSection section,
) {
  switch (section) {
    case PersonalizedSection.ongoing:
      return dto.ongoing;
    case PersonalizedSection.upcoming:
      return dto.upcoming;
    case PersonalizedSection.private:
      return dto.privateEvents;
    case PersonalizedSection.favorites:
      return dto.favorites;
    case PersonalizedSection.reminders:
      return dto.reminders;
    case PersonalizedSection.followed:
      return dto.followed;
    case PersonalizedSection.booked:
      return dto.booked;
  }
}

/// Stable key for dedup. Prefer [EventDto.uuid] (the API's actual route
/// key — see CLAUDE.md "UUID vs ID numérique"); fall back to the
/// numeric `id` hash only if uuid is missing/empty so we don't collapse
/// distinct UUID-less events together via the default `id == 0`.
String _keyFor(EventDto event) {
  final uuid = event.uuid;
  if (uuid != null && uuid.isNotEmpty) return uuid;
  return event.id.toString();
}

List<EventDto> _parseEventList(dynamic value) {
  if (value is! List) return const [];
  return value
      .whereType<Map<String, dynamic>>()
      .map(EventDto.fromJson)
      .toList();
}

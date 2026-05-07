import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/memberships/data/models/personalized_feed_dto.dart';

/// Minimal EventDto fixture — dedup only reads `uuid` (preferred) and
/// `id` (fallback), so we keep the rest at defaults. `title` and `slug`
/// are required by the DTO constructor.
EventDto _event(String? uuid, {int id = 0}) => EventDto(
      id: id,
      uuid: uuid,
      title: uuid ?? id.toString(),
      slug: uuid ?? id.toString(),
    );

void main() {
  group('buildOrdered (personalized feed dedup)', () {
    test('empty DTO produces empty ordered list', () {
      final dto = PersonalizedFeedDto.empty();
      final ordered = buildOrdered(dto);
      expect(ordered, isEmpty);
    });

    test(
        'same uuid in favorites and booked collapses to one entry with both '
        'section markers', () {
      final shared = _event('shared-uuid');
      final dto = PersonalizedFeedDto(
        favorites: [shared],
        booked: [shared],
      );

      final ordered = buildOrdered(dto);

      expect(ordered, hasLength(1));
      expect(ordered.first.event.uuid, 'shared-uuid');
      expect(
        ordered.first.sections,
        equals({PersonalizedSection.favorites, PersonalizedSection.booked}),
      );
    });

    test(
        'event in both ongoing and favorites lands at ongoing position '
        '(highest priority) with both sections', () {
      final shared = _event('shared-uuid');
      // Add a distinct event to favorites so we can confirm `shared`
      // surfaces from ongoing's slot rather than favorites'.
      final favOnly = _event('fav-only');

      final dto = PersonalizedFeedDto(
        ongoing: [shared],
        favorites: [favOnly, shared],
      );

      final ordered = buildOrdered(dto);

      // ongoing is walked before favorites in the priority order, so
      // `shared` is recorded first; then `favOnly` is appended from the
      // favorites walk. Total of 2 deduped entries.
      expect(ordered, hasLength(2));
      expect(ordered[0].event.uuid, 'shared-uuid');
      expect(
        ordered[0].sections,
        equals({PersonalizedSection.ongoing, PersonalizedSection.favorites}),
      );
      expect(ordered[1].event.uuid, 'fav-only');
      expect(ordered[1].sections, equals({PersonalizedSection.favorites}));
    });

    test(
        'three sections with no overlap produce three entries in '
        'priority-order positions', () {
      final ongoingEvent = _event('ongoing-uuid');
      final privateEvent = _event('private-uuid');
      final bookedEvent = _event('booked-uuid');

      final dto = PersonalizedFeedDto(
        ongoing: [ongoingEvent],
        privateEvents: [privateEvent],
        booked: [bookedEvent],
      );

      final ordered = buildOrdered(dto);

      // Priority order: ongoing (0), upcoming, private (2), favorites,
      // reminders, followed, booked (6). With only ongoing/private/booked
      // populated, the positions collapse to indices 0/1/2 in that order.
      expect(ordered, hasLength(3));
      expect(ordered[0].event.uuid, 'ongoing-uuid');
      expect(ordered[0].sections, equals({PersonalizedSection.ongoing}));
      expect(ordered[1].event.uuid, 'private-uuid');
      expect(ordered[1].sections, equals({PersonalizedSection.private}));
      expect(ordered[2].event.uuid, 'booked-uuid');
      expect(ordered[2].sections, equals({PersonalizedSection.booked}));
    });
  });
}

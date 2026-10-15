import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/features/partners/presentation/utils/event_timing_bucket.dart';

void main() {
  group('displayDateFor', () {
    final now = DateTime(2026, 9, 29, 10);

    test('advertises the next slot still to come, not the first one', () {
      final event = _eventWithSlots([
        _slot('past', DateTime(2026, 9, 25),
            startTime: '20:00:00', endTime: '23:00:00'),
        _slot('next', DateTime(2026, 10, 2),
            startTime: '20:00:00', endTime: '23:00:00'),
        _slot('later', DateTime(2026, 10, 9),
            startTime: '20:00:00', endTime: '23:00:00'),
      ]);

      expect(displayDateFor(event, now), DateTime(2026, 10, 2, 20));
    });

    test('picks the earliest upcoming slot even when slots are unordered', () {
      final event = _eventWithSlots([
        _slot('later', DateTime(2026, 10, 9), startTime: '20:00:00'),
        _slot('next', DateTime(2026, 10, 2), startTime: '20:00:00'),
        _slot('past', DateTime(2026, 9, 25), startTime: '20:00:00'),
      ]);

      expect(displayDateFor(event, now), DateTime(2026, 10, 2, 20));
    });

    test('keeps a slot running right now instead of jumping to the next', () {
      final event = _eventWithSlots([
        _slot('running', DateTime(2026, 9, 29),
            startTime: '09:00:00', endTime: '18:00:00'),
        _slot('next', DateTime(2026, 10, 2), startTime: '20:00:00'),
      ]);

      expect(displayDateFor(event, now), DateTime(2026, 9, 29, 9));
    });

    test('falls back to the latest slot once every slot has ended', () {
      final event = _eventWithSlots([
        _slot('first', DateTime(2026, 6, 7),
            startTime: '10:00:00', endTime: '12:00:00'),
        _slot('last', DateTime(2026, 7, 5),
            startTime: '10:00:00', endTime: '12:00:00'),
      ]);

      expect(displayDateFor(event, now), DateTime(2026, 7, 5, 10));
    });

    test('falls back to the event start date without slots', () {
      final event = Event.minimal(id: 'e', slug: 'e', title: 'E')
          .copyWith(startDate: DateTime(2026, 11, 3, 18));

      expect(displayDateFor(event, now), DateTime(2026, 11, 3, 18));
      expect(
        displayDateFor(
          _eventWithSlots(const []).copyWith(startDate: DateTime(2026, 11, 3)),
          now,
        ),
        DateTime(2026, 11, 3),
      );
    });

    test('keeps a malformed slot visible rather than hiding the event', () {
      final event = _eventWithSlots([
        _slot('malformed', DateTime(2026, 10, 2), startTime: 'not-a-time'),
      ]);

      expect(displayDateFor(event, now), DateTime(2026, 10, 2));
    });
  });

  _sortSuite();
}

Event _eventWithSlots(List<CalendarDateSlot> slots) {
  return Event.minimal(
    id: 'event',
    slug: 'event',
    title: 'Event',
  ).copyWith(
    calendar: CalendarConfig(type: 'manual', dateSlots: slots),
  );
}

CalendarDateSlot _slot(
  String id,
  DateTime date, {
  String? startTime,
  String? endTime,
}) {
  return CalendarDateSlot(
    id: id,
    date: date,
    startTime: startTime,
    endTime: endTime,
  );
}

void _sortSuite() {
  group('sortedByNextOccurrence', () {
    final now = DateTime(2026, 9, 29, 10);

    test('orders current events by their next occurrence, soonest first', () {
      final soon = _eventWithSlots([
        _slot('a1', DateTime(2026, 9, 25), startTime: '20:00:00'),
        _slot('a2', DateTime(2026, 10, 2), startTime: '20:00:00'),
      ]).copyWith(id: 'soiree', title: 'Soirée');
      final later = _eventWithSlots([
        _slot('b1', DateTime(2026, 10, 4), startTime: '14:00:00'),
      ]).copyWith(id: 'apres-midi', title: 'Après-midi');

      final sorted = sortedByNextOccurrence([later, soon], now);

      expect(sorted.map((o) => o.event.id), ['soiree', 'apres-midi']);
      expect(sorted.map((o) => o.date), [
        DateTime(2026, 10, 2, 20),
        DateTime(2026, 10, 4, 14),
      ]);
    });

    test('keeps API order for events sharing the same occurrence', () {
      final first = _eventWithSlots([
        _slot('c1', DateTime(2026, 10, 2), startTime: '20:00:00'),
      ]).copyWith(id: 'first');
      final second = _eventWithSlots([
        _slot('c2', DateTime(2026, 10, 2), startTime: '20:00:00'),
      ]).copyWith(id: 'second');
      final third = _eventWithSlots([
        _slot('c3', DateTime(2026, 10, 2), startTime: '20:00:00'),
      ]).copyWith(id: 'third');

      expect(
        sortedByNextOccurrence([first, second, third], now)
            .map((o) => o.event.id),
        ['first', 'second', 'third'],
      );
    });

    test('places slotless events by their start date', () {
      final slotless = Event.minimal(id: 'slotless', slug: 's', title: 'S')
          .copyWith(startDate: DateTime(2026, 10, 1, 9));
      final withSlot = _eventWithSlots([
        _slot('d1', DateTime(2026, 10, 3), startTime: '20:00:00'),
      ]).copyWith(id: 'with-slot');

      expect(
        sortedByNextOccurrence([withSlot, slotless], now)
            .map((o) => o.event.id),
        ['slotless', 'with-slot'],
      );
    });

    test('does not mutate the source list', () {
      final a = _eventWithSlots([_slot('e1', DateTime(2026, 10, 9))])
          .copyWith(id: 'a');
      final b = _eventWithSlots([_slot('e2', DateTime(2026, 10, 2))])
          .copyWith(id: 'b');
      final source = [a, b];

      sortedByNextOccurrence(source, now);

      expect(source.map((e) => e.id), ['a', 'b']);
    });
  });
}

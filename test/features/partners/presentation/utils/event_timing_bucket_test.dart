import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/data/mappers/event_mapper.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/features/partners/presentation/utils/event_timing_bucket.dart';

void main() {
  group('bucketFor', () {
    final now = DateTime(2026, 9, 2, 15);

    test('classifies a production-shaped organizer event as past', () {
      final event = EventMapper.toEvent(
        EventDto.fromJson({
          'id': 1,
          'uuid': 'past-event',
          'slug': 'past-event',
          'title': 'Past event',
          'dates': {
            'start_date': '2026-06-07',
            'end_date': '2026-06-07',
            'start_time': '10:00:00',
            'end_time': '12:00:00',
          },
          'slots': [
            {
              'uuid': 'slot-1',
              'date': '2026-06-07',
              'start_time': '10:00:00',
              'end_time': '12:00:00',
            },
          ],
        }),
      );

      expect(bucketFor(event, now), EventTimingBucket.past);
    });

    test('keeps an event current when any slot has not ended', () {
      final event = _eventWithSlots([
        _slot('past', DateTime(2026, 9, 1), endTime: '12:00:00'),
        _slot('future', DateTime(2026, 9, 3), endTime: '12:00:00'),
      ]);

      expect(bucketFor(event, now), EventTimingBucket.currentUpcoming);
    });

    test('keeps an event current at the exact slot-end boundary', () {
      final event = _eventWithSlots([
        _slot('boundary', DateTime(2026, 9, 2), endTime: '15:00:00'),
      ]);

      expect(bucketFor(event, now), EventTimingBucket.currentUpcoming);
    });

    test('keeps events without slots visible in the current segment', () {
      final event = Event.minimal(
        id: 'no-slots',
        slug: 'no-slots',
        title: 'No slots',
      );

      expect(bucketFor(event, now), EventTimingBucket.currentUpcoming);
      expect(
        bucketFor(_eventWithSlots(const []), now),
        EventTimingBucket.currentUpcoming,
      );
    });

    test('keeps malformed slot timing visible in the current segment', () {
      final event = _eventWithSlots([
        _slot('malformed', DateTime(2026, 6, 7), endTime: 'not-a-time'),
      ]);

      expect(bucketFor(event, now), EventTimingBucket.currentUpcoming);
    });

    test('supports slots that end after midnight', () {
      final event = _eventWithSlots([
        _slot(
          'overnight',
          DateTime(2026, 9, 2),
          startTime: '23:00:00',
          endTime: '01:00:00',
        ),
      ]);

      expect(
        bucketFor(event, DateTime(2026, 9, 3)),
        EventTimingBucket.currentUpcoming,
      );
      expect(
        bucketFor(event, DateTime(2026, 9, 3, 2)),
        EventTimingBucket.past,
      );
    });
  });
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

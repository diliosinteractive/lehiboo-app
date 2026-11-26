import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/data/mappers/event_mapper.dart';
import 'package:lehiboo/features/events/data/models/event_dto.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/features/home/presentation/utils/happening_now.dart';

import 'venue_time_fixture.dart';

void main() {
  final now = DateTime(2026, 11, 24, 10);

  test(
    'keeps slots in progress or starting within twelve hours, drops the rest',
    () {
      final events = [
        _event('live', [_slot('live', 24, '09:30', '11:30')]),
        _event('eleven-hours', [_slot('eleven-hours', 24, '21:00', '23:00')]),
        _event('twelve-hours', [_slot('twelve-hours', 24, '22:00', '23:00')]),
        _event('too-late', [_slot('too-late', 24, '22:01', '23:00')]),
        _event('ended', [_slot('ended', 24, '08:00', '09:59')]),
      ];

      final selected = selectHappeningNow(events, now);

      expect(
        selected.map((item) => item.event.id),
        ['live', 'eleven-hours', 'twelve-hours'],
      );
    },
  );

  test(
    'orders live events by soonest end, then upcoming ones by soonest start',
    () {
      final events = [
        _event('upcoming-20', [_slot('upcoming-20', 24, '20:00', '21:00')]),
        _event('period', [
          _slot(
            'period',
            20,
            '10:00',
            '17:00',
            endDate: DateTime(2026, 11, 29),
          ),
        ]),
        _event('live-18', [_slot('live-18', 24, '09:00', '18:00')]),
        _event('upcoming-12', [_slot('upcoming-12', 24, '12:00', '13:00')]),
        _event('start-only', [
          _slot(
            'start-only',
            24,
            '08:00',
            null,
            timeKind: SlotTimeKind.startOnly,
          ),
        ]),
        _event('mixed', [
          _slot('mixed-live', 24, '09:30', '11:30'),
          _slot('mixed-later', 24, '15:00', '16:00'),
        ]),
      ];

      final selected = selectHappeningNow(events, now);

      expect(
        selected.map((item) => item.event.id),
        [
          'mixed',
          'live-18',
          'start-only',
          'period',
          'upcoming-12',
          'upcoming-20',
        ],
      );
    },
  );

  test('shows the live slot of an event that also has a later one', () {
    final event = _event('mixed', [
      _slot('live', 24, '09:30', '11:30'),
      _slot('later', 24, '15:00', '16:00'),
    ]);

    final selected = selectHappeningNow([event], now);

    expect(selected, hasLength(1));
    expect(selected.single.start, DateTime(2026, 11, 24, 9, 30));
    expect(selected.single.end, DateTime(2026, 11, 24, 11, 30));
    expect(selected.single.isLive, isTrue);
  });

  test('keeps a started start-only slot live until midnight, with no end time',
      () {
    final event = _event('start-only', [
      _slot(
        'start-only',
        24,
        '14:00',
        null,
        timeKind: SlotTimeKind.startOnly,
      ),
    ]);

    final beforeMidnight = selectHappeningNow(
      [event],
      DateTime(2026, 11, 24, 22),
    );
    final atMidnight = selectHappeningNow(
      [event],
      DateTime(2026, 11, 25),
    );

    expect(beforeMidnight.single.isLive, isTrue);
    expect(beforeMidnight.single.end, isNull);
    expect(atMidnight, isEmpty);
  });

  test('keeps a period begun before today live until its last day', () {
    final event = _event('period', [
      _slot(
        'period',
        20,
        '10:00',
        '17:00',
        endDate: DateTime(2026, 11, 29),
      ),
    ]);

    final selected = selectHappeningNow([event], now);

    expect(selected.single.isLive, isTrue);
    expect(selected.single.end, DateTime(2026, 11, 29, 17));
  });

  test('caps the list at max and keeps input order for ties', () {
    final events = List.generate(
      7,
      (index) => _event('event-$index', [
        _slot('slot-$index', 24, '12:00', '13:00'),
      ]),
    );

    final selected = selectHappeningNow(events, now);

    expect(selected, hasLength(6));
    expect(
      selected.map((item) => item.event.id),
      ['event-0', 'event-1', 'event-2', 'event-3', 'event-4', 'event-5'],
    );
  });

  group('a venue in another timezone than the phone', () {
    final venue = Venue();

    test('is live while in progress at the venue, shown in venue time', () {
      final item = selectHappeningNow(
        [
          _event('paris', [venue.slot('paris', 24, '10:00', '12:00')])
        ],
        venue.at(24, 10, 30),
      ).single;

      expect(item.isLive, isTrue);
      expect(item.startsAt, venue.at(24, 10));
      expect(item.start, DateTime(2026, 11, 24, 10));
      expect(item.end, DateTime(2026, 11, 24, 12));
    });

    test('is live by venue time once mapped from the API payload', () {
      final event = EventMapper.toEvent(
        EventDto.fromJson({
          'id': 1,
          'title': 'Paris',
          'slug': 'paris',
          'slots': [venue.slotJson('paris', 24, '10:00', '12:00')],
        }),
      );

      final item = selectHappeningNow([event], venue.at(24, 10, 30)).single;

      expect(item.isLive, isTrue);
      expect(item.startsAt, venue.at(24, 10));
    });

    test('drops a slot that has ended at the venue', () {
      final selected = selectHappeningNow(
        [
          _event('over', [venue.slot('over', 24, '08:00', '10:00')])
        ],
        venue.at(24, 10, 30),
      );

      expect(selected, isEmpty);
    });

    test('counts the twelve hours from the venue time', () {
      final selected = selectHappeningNow(
        [
          _event('twelve-hours', [
            venue.slot('twelve-hours', 24, '22:30', '23:00'),
          ]),
          _event('too-late', [venue.slot('too-late', 24, '22:31', '23:00')]),
        ],
        venue.at(24, 10, 30),
      );

      expect(selected.map((item) => item.event.id), ['twelve-hours']);
    });

    test('keeps a start-only slot live until midnight at the venue', () {
      final events = [
        _event('start-only', [
          venue.slot(
            'start-only',
            24,
            '14:00',
            null,
            timeKind: SlotTimeKind.startOnly,
          ),
        ]),
      ];

      expect(selectHappeningNow(events, venue.at(24, 23, 30)).single.isLive,
          isTrue);
      expect(selectHappeningNow(events, venue.at(25, 0, 30)), isEmpty);
    });

    test('ends today by the venue calendar, not the phone one', () {
      // Late evening at a venue behind the phone is already tomorrow on the
      // phone; early morning at a venue ahead of it is still yesterday there.
      final (start, end, hour) =
          venue.isBehindPhone ? ('22:00', '23:30', 22) : ('01:00', '03:00', 2);
      final now = venue.at(24, hour, 30);

      final tonight = selectHappeningNow(
        [
          _event('tonight', [venue.slot('tonight', 24, start, end)])
        ],
        now,
      ).single;
      final period = selectHappeningNow(
        [
          _event('period', [
            venue.slot('period', 20, '00:00', '23:59', endDay: 29),
          ]),
        ],
        now,
      ).single;

      expect(tonight.endsToday, isTrue);
      expect(period.endsToday, isFalse);
    });
  });
}

Event _event(String id, List<CalendarDateSlot> slots) {
  return Event.minimal(id: id, slug: id, title: id).copyWith(
    calendar: CalendarConfig(type: 'manual', dateSlots: slots),
  );
}

CalendarDateSlot _slot(
  String id,
  int day,
  String startTime,
  String? endTime, {
  DateTime? endDate,
  SlotTimeKind timeKind = SlotTimeKind.exact,
}) {
  return CalendarDateSlot(
    id: id,
    date: DateTime(2026, 11, day),
    endDate: endDate,
    startTime: startTime,
    endTime: endTime,
    timeKind: timeKind,
  );
}

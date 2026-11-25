import '../../../events/domain/entities/event.dart';
import '../../../events/domain/entities/event_submodels.dart';

class HappeningNowItem {
  final Event event;

  /// The venue's wall-clock start and end, for display.
  final DateTime start;
  final DateTime? end;

  /// When the occurrence starts, as an exact instant: what a countdown
  /// measures, whatever the phone's timezone.
  final DateTime startsAt;
  final bool isLive;

  /// Whether [end] falls on the venue's current day.
  final bool endsToday;

  const HappeningNowItem({
    required this.event,
    required this.start,
    required this.end,
    required this.startsAt,
    required this.isLive,
    required this.endsToday,
  });
}

/// Selects the occurrence each event should advertise on the urgency rail.
///
/// Live occurrences lead, ordered by their effective end. Upcoming
/// occurrences follow, ordered by start. Original event order breaks ties.
///
/// Timing uses the slots' exact instants, so a Paris event is live at the
/// right moment on a phone set to another timezone; the times shown stay the
/// venue's.
List<HappeningNowItem> selectHappeningNow(
  List<Event> events,
  DateTime now, {
  Duration window = const Duration(hours: 12),
  int max = 6,
}) {
  if (max <= 0) return const [];

  final cutoff = now.add(window);
  final selected = <_IndexedCandidate>[];

  for (var eventIndex = 0; eventIndex < events.length; eventIndex++) {
    final event = events[eventIndex];
    final candidate = _pickEventCandidate(event, now, cutoff);
    if (candidate == null) continue;

    selected.add(
      _IndexedCandidate(
        candidate: candidate,
        eventIndex: eventIndex,
      ),
    );
  }

  selected.sort((a, b) {
    final aCandidate = a.candidate;
    final bCandidate = b.candidate;

    if (aCandidate.isLive != bCandidate.isLive) {
      return aCandidate.isLive ? -1 : 1;
    }

    final comparison = aCandidate.isLive
        ? aCandidate.effectiveEnd.compareTo(bCandidate.effectiveEnd)
        : aCandidate.startsAt.compareTo(bCandidate.startsAt);
    if (comparison != 0) return comparison;

    return a.eventIndex.compareTo(b.eventIndex);
  });

  return selected
      .take(max)
      .map(
        (entry) => HappeningNowItem(
          event: entry.candidate.event,
          start: entry.candidate.start,
          end: entry.candidate.end,
          startsAt: entry.candidate.startsAt,
          isLive: entry.candidate.isLive,
          endsToday: entry.candidate.endsToday,
        ),
      )
      .toList();
}

_SlotCandidate? _pickEventCandidate(
  Event event,
  DateTime now,
  DateTime cutoff,
) {
  final slots = event.calendar?.dateSlots ?? const <CalendarDateSlot>[];
  if (slots.isEmpty) {
    return _fallbackCandidate(event, now, cutoff);
  }

  _SlotCandidate? live;
  _SlotCandidate? upcoming;

  for (final slot in slots) {
    final candidate = _calendarCandidate(event, slot, now, cutoff);
    if (candidate == null) continue;

    if (candidate.isLive) {
      if (live == null || candidate.effectiveEnd.isBefore(live.effectiveEnd)) {
        live = candidate;
      }
    } else if (upcoming == null ||
        candidate.startsAt.isBefore(upcoming.startsAt)) {
      upcoming = candidate;
    }
  }

  return live ?? upcoming;
}

_SlotCandidate? _calendarCandidate(
  Event event,
  CalendarDateSlot slot,
  DateTime now,
  DateTime cutoff,
) {
  final startTime = _parseClockTime(slot.startTime, orMidnight: true);
  if (startTime == null) return null;

  final start = _combine(slot.date, startTime);
  final venue = _VenueClock.of(slot, start);
  final startsAt = venue.instant(start);
  if (startsAt.isAfter(cutoff)) return null;

  if (slot.timeKind == SlotTimeKind.startOnly) {
    final runsUntil = venue.instant(_nextDayStart(slot.endDate ?? slot.date));
    if (!now.isBefore(runsUntil)) return null;

    return _SlotCandidate(
      event: event,
      start: start,
      end: null,
      startsAt: startsAt,
      effectiveEnd: runsUntil,
      isLive: !startsAt.isAfter(now),
      endsToday: false,
    );
  }

  final endTime = _parseClockTime(slot.endTime);
  if (endTime == null) return null;

  final end = _combine(slot.endDate ?? slot.date, endTime);
  final endsAt = slot.endsAt ?? venue.instant(end);
  if (endsAt.isBefore(now)) return null;

  return _SlotCandidate(
    event: event,
    start: start,
    end: end,
    startsAt: startsAt,
    effectiveEnd: endsAt,
    isLive: !startsAt.isAfter(now),
    endsToday: venue.isToday(end, now),
  );
}

_SlotCandidate? _fallbackCandidate(
  Event event,
  DateTime now,
  DateTime cutoff,
) {
  if (event.startDate.isAfter(cutoff) || event.endDate.isBefore(now)) {
    return null;
  }

  return _SlotCandidate(
    event: event,
    start: event.startDate,
    end: event.endDate,
    startsAt: event.startDate,
    effectiveEnd: event.endDate,
    isLive: !event.startDate.isAfter(now),
    endsToday: const _VenueClock(null).isToday(event.endDate, now),
  );
}

/// The venue's clock. A slot's date and times are the venue's wall clock;
/// read as phone time they would be hours off on a phone set to another
/// timezone. The API sends the start with the venue's UTC offset, which turns
/// them into exact instants. Without it, the phone's clock stands in.
class _VenueClock {
  const _VenueClock(this._offset);

  factory _VenueClock.of(CalendarDateSlot slot, DateTime wallClockStart) {
    final startsAt = slot.startsAt;
    if (startsAt == null) return const _VenueClock(null);
    return _VenueClock(_utcFields(wallClockStart).difference(startsAt));
  }

  final Duration? _offset;

  /// The instant a venue wall-clock time stands for.
  DateTime instant(DateTime wallClock) {
    final offset = _offset;
    if (offset == null) return wallClock;
    return _utcFields(wallClock).subtract(offset);
  }

  /// Whether a venue wall-clock time falls on the venue's current day.
  bool isToday(DateTime wallClock, DateTime now) {
    final offset = _offset;
    final venueNow = offset == null ? now : now.toUtc().add(offset);
    return wallClock.year == venueNow.year &&
        wallClock.month == venueNow.month &&
        wallClock.day == venueNow.day;
  }

  static DateTime _utcFields(DateTime time) => DateTime.utc(
        time.year,
        time.month,
        time.day,
        time.hour,
        time.minute,
        time.second,
      );
}

typedef _ClockTime = ({int hour, int minute, int second});

_ClockTime? _parseClockTime(String? value, {bool orMidnight = false}) {
  final raw = value?.trim();
  if (raw == null || raw.isEmpty) {
    return orMidnight ? (hour: 0, minute: 0, second: 0) : null;
  }

  final parts = raw.split(':');
  if (parts.length < 2 || parts.length > 3) return null;

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  final second =
      parts.length == 3 ? int.tryParse(parts[2].split('.').first) : 0;
  if (hour == null ||
      minute == null ||
      second == null ||
      hour < 0 ||
      hour > 23 ||
      minute < 0 ||
      minute > 59 ||
      second < 0 ||
      second > 59) {
    return null;
  }

  return (hour: hour, minute: minute, second: second);
}

DateTime _combine(DateTime date, _ClockTime time) {
  if (date.isUtc) {
    return DateTime.utc(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
    );
  }

  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
    time.second,
  );
}

DateTime _nextDayStart(DateTime date) {
  if (date.isUtc) {
    return DateTime.utc(date.year, date.month, date.day + 1);
  }
  return DateTime(date.year, date.month, date.day + 1);
}

class _SlotCandidate {
  final Event event;
  final DateTime start;
  final DateTime? end;
  final DateTime startsAt;
  final DateTime effectiveEnd;
  final bool isLive;
  final bool endsToday;

  const _SlotCandidate({
    required this.event,
    required this.start,
    required this.end,
    required this.startsAt,
    required this.effectiveEnd,
    required this.isLive,
    required this.endsToday,
  });
}

class _IndexedCandidate {
  final _SlotCandidate candidate;
  final int eventIndex;

  const _IndexedCandidate({
    required this.candidate,
    required this.eventIndex,
  });
}

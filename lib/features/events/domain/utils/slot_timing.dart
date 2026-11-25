import '../entities/event_submodels.dart';

/// When a calendar slot starts and ends, following the backend's
/// `Slot::scopeNotEnded()`: an exact slot runs until
/// `(endDate ?? date) + endTime`, inclusive; a start-only slot has no known
/// end and runs through its last calendar day.
///
/// A slot's date and times are the venue's wall clock, kept for display
/// ([start], [end]). Read as phone time they would be hours off on a phone
/// set to another timezone, so timing uses exact instants ([startsAt],
/// [runsUntil]), built from the venue's UTC offset that the API sends with
/// the start. Without it, the phone's clock stands in.
class CalendarSlotTiming {
  /// The venue's wall-clock start, for display.
  final DateTime start;

  /// The venue's wall-clock end, or null for a start-only slot.
  final DateTime? end;

  /// When the slot starts, as an exact instant.
  final DateTime startsAt;

  /// When the slot stops running, as an exact instant: its end, or midnight
  /// at the venue after the last day for a start-only slot.
  final DateTime runsUntil;

  final _VenueClock _venue;

  const CalendarSlotTiming._({
    required this.start,
    required this.end,
    required this.startsAt,
    required this.runsUntil,
    required _VenueClock venue,
  }) : _venue = venue;

  bool hasEnded(DateTime now) =>
      end != null ? runsUntil.isBefore(now) : !now.isBefore(runsUntil);

  /// Whether [end] falls on the venue's current day.
  bool endsToday(DateTime now) {
    final end = this.end;
    return end != null && _venue.isToday(end, now);
  }
}

/// The timing of [slot], or null when its start time, or an exact slot's end
/// time, cannot be read. A missing start time means midnight.
CalendarSlotTiming? calendarSlotTiming(CalendarDateSlot slot) {
  final startTime = _parseClockTime(slot.startTime, orMidnight: true);
  if (startTime == null) return null;
  final start = _combine(slot.date, startTime);
  final venue = _VenueClock.of(slot, start);
  final startsAt = venue.instant(start);
  final lastDay = slot.endDate ?? slot.date;

  if (slot.timeKind == SlotTimeKind.startOnly) {
    return CalendarSlotTiming._(
      start: start,
      end: null,
      startsAt: startsAt,
      runsUntil: venue.instant(_nextDayStart(lastDay)),
      venue: venue,
    );
  }

  final endTime = _parseClockTime(slot.endTime);
  if (endTime == null) return null;
  final end = _combine(lastDay, endTime);
  return CalendarSlotTiming._(
    start: start,
    end: end,
    startsAt: startsAt,
    runsUntil: slot.endsAt ?? venue.instant(end),
    venue: venue,
  );
}

/// The venue's clock: turns its wall-clock times into instants and tells its
/// current day, from the UTC offset the API sends with the slot's start.
/// Without that offset, the phone's clock stands in.
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

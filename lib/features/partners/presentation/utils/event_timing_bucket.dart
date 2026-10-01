import '../../../events/domain/entities/event.dart';
import '../../../events/domain/entities/event_submodels.dart';

/// Whether an organizer event belongs in the "Current & upcoming" or
/// "Past" segment of the activities tab.
///
/// Spec: docs/ORGANIZER_PROFILE_MOBILE_SPEC.md §4.4
enum EventTimingBucket { currentUpcoming, past }

/// Decide which segment an event belongs to **at the moment [now]**.
///
/// An event is past only when every slot has a trustworthy end time strictly
/// before [now]. Missing slots or malformed timing stay current/upcoming so a
/// partial API payload cannot silently hide an event from end users.
EventTimingBucket bucketFor(Event event, DateTime now) {
  final slots = event.calendar?.dateSlots ?? const <CalendarDateSlot>[];

  if (slots.isEmpty) {
    return EventTimingBucket.currentUpcoming;
  }

  for (final slot in slots) {
    final end = _slotEndDateTime(slot);
    if (end == null || !end.isBefore(now)) {
      return EventTimingBucket.currentUpcoming;
    }
  }

  return EventTimingBucket.past;
}

typedef _ClockTime = ({int hour, int minute, int second});

DateTime? _slotEndDateTime(CalendarDateSlot slot) {
  final rawEndTime = slot.endTime?.trim();
  final rawStartTime = slot.startTime?.trim();
  final hasEndTime = rawEndTime != null && rawEndTime.isNotEmpty;
  final hasStartTime = rawStartTime != null && rawStartTime.isNotEmpty;

  final endTime = hasEndTime
      ? _parseClockTime(rawEndTime)
      : hasStartTime
          ? _parseClockTime(rawStartTime)
          : (hour: 23, minute: 59, second: 59);

  if (endTime == null) {
    return null;
  }

  var end = _combineDateAndTime(slot.date, endTime);

  // A slot ending after midnight may have an end clock earlier than its start
  // clock while both values share the same calendar date in the API.
  final startTime = _parseClockTime(rawStartTime);
  if (hasEndTime && startTime != null) {
    final start = _combineDateAndTime(slot.date, startTime);
    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));
    }
  }

  return end;
}

_ClockTime? _parseClockTime(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }

  final parts = value.split(':');
  if (parts.length < 2 || parts.length > 3) {
    return null;
  }

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

DateTime _combineDateAndTime(DateTime date, _ClockTime time) {
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

/// The occurrence an organizer activity tile should advertise at [now].
///
/// A recurring event keeps its original `start_date` forever, so showing it
/// makes a still-running event look stale ("25 sept." while we are the 29th).
/// We advertise the first slot that has not ended yet; once every slot is over
/// (Past segment) the most recent one is shown. Events without slots fall back
/// to [Event.startDate].
DateTime displayDateFor(Event event, DateTime now) {
  final slots = event.calendar?.dateSlots ?? const <CalendarDateSlot>[];

  if (slots.isEmpty) {
    return event.startDate;
  }

  CalendarDateSlot? upcoming;
  DateTime? upcomingEnd;
  CalendarDateSlot? latest;
  DateTime? latestEnd;

  for (final slot in slots) {
    // Malformed timing stays visible — same leniency as [bucketFor].
    final end = _slotEndDateTime(slot) ??
        _combineDateAndTime(slot.date, (hour: 23, minute: 59, second: 59));

    if (!end.isBefore(now) &&
        (upcomingEnd == null || end.isBefore(upcomingEnd))) {
      upcoming = slot;
      upcomingEnd = end;
    }

    if (latestEnd == null || end.isAfter(latestEnd)) {
      latest = slot;
      latestEnd = end;
    }
  }

  final slot = upcoming ?? latest;
  return slot == null ? event.startDate : _slotStartDateTime(slot);
}

DateTime _slotStartDateTime(CalendarDateSlot slot) {
  final start = _parseClockTime(slot.startTime?.trim());
  return _combineDateAndTime(
    slot.date,
    start ?? (hour: 0, minute: 0, second: 0),
  );
}

/// An organizer event paired with the occurrence its tile advertises.
typedef OrganizerEventOccurrence = ({Event event, DateTime date});

/// Order current/upcoming events by the occurrence they advertise, soonest
/// first, so the list reads chronologically even when the API returns events
/// in another order (a weekly event started months ago still sits next to the
/// other events happening that week).
///
/// Ties keep the API order: `List.sort` is not stable, so the original index
/// is the tie-breaker. Sorting the whole loaded list (not just the new page)
/// keeps pagination appends in place.
List<OrganizerEventOccurrence> sortedByNextOccurrence(
  List<Event> events,
  DateTime now,
) {
  final indexed = <({int index, Event event, DateTime date})>[
    for (var i = 0; i < events.length; i++)
      (index: i, event: events[i], date: displayDateFor(events[i], now)),
  ];

  indexed.sort((a, b) {
    final byDate = a.date.compareTo(b.date);
    return byDate != 0 ? byDate : a.index.compareTo(b.index);
  });

  return [
    for (final entry in indexed) (event: entry.event, date: entry.date),
  ];
}

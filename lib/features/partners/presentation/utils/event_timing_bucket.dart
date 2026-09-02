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

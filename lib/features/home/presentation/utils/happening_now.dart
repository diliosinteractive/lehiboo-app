import '../../../events/domain/entities/event.dart';
import '../../../events/domain/entities/event_submodels.dart';
import '../../../events/domain/utils/slot_timing.dart';

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
  final timing = calendarSlotTiming(slot);
  if (timing == null ||
      timing.startsAt.isAfter(cutoff) ||
      timing.hasEnded(now)) {
    return null;
  }

  return _SlotCandidate(
    event: event,
    start: timing.start,
    end: timing.end,
    startsAt: timing.startsAt,
    effectiveEnd: timing.runsUntil,
    isLive: !timing.startsAt.isAfter(now),
    endsToday: timing.endsToday(now),
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
    endsToday: _isSameDay(event.endDate, now),
  );
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

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

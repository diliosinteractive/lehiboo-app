import '../../../events/domain/entities/event.dart';

/// Whether an organizer event belongs in the "Current & upcoming" or
/// "Past" segment of the activities tab.
///
/// Spec: docs/ORGANIZER_PROFILE_MOBILE_SPEC.md §4.4
enum EventTimingBucket { currentUpcoming, past }

/// Decide which segment an event belongs to **at the moment [now]**.
///
/// **Learning-mode TODO**: implement this function.
///
/// The spec says: "current/upcoming if any slot's end time is `>= now`,
/// else past". The codebase models slot collapse via [Event.endDate] —
/// the latest slot's end — so a single comparison is enough for most cases.
///
/// Things to think about:
///   1. **Empty / missing dates.** [EventMapper] falls back to
///      `endDate = startDate` when the API didn't send an end. What's the
///      right bucket for an event with no temporal info? The spec says
///      "Empty slot list → currentUpcoming" — silence shouldn't hide events.
///   2. **Boundary moment.** Strictly `<` vs `<=`. An event ending right now
///      — past, or still current? (Web uses `<`.)
///   3. **Timezone.** [DateTime] from the API is parsed in local time
///      (see [EventMapper] line ~14). [now] should be in the same zone —
///      pass `DateTime.now()` (local) at the call site, not `.toUtc()`.
///
/// Suggested skeleton:
///
/// ```dart
/// EventTimingBucket bucketFor(Event event, DateTime now) {
///   // 1. Decide what "no slots" / "no end date" means.
///   // 2. Return EventTimingBucket.past iff the event's end is strictly
///   //    before [now], else EventTimingBucket.currentUpcoming.
/// }
/// ```
EventTimingBucket bucketFor(Event event, DateTime now) {
  // TODO(you): implement per spec §4.4 and the notes above.
  throw UnimplementedError('bucketFor');
}

import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';

/// A venue whose UTC offset is six hours away from this machine's, so venue
/// time and phone time differ wherever the tests run. The API sends each slot
/// with its venue offset (`start_datetime`, `end_datetime`).
class Venue {
  Venue() : offset = _awayFromPhone(DateTime(2026, 11, 24).timeZoneOffset);

  final Duration offset;

  static Duration _awayFromPhone(Duration phone) =>
      phone.isNegative ? phone + _sixHours : phone - _sixHours;
  static const _sixHours = Duration(hours: 6);

  /// Whether the venue clock is behind the phone's.
  bool get isBehindPhone => offset < DateTime(2026, 11, 24).timeZoneOffset;

  /// The instant a venue wall-clock time in November 2026 stands for.
  DateTime at(int day, int hour, [int minute = 0]) =>
      DateTime.utc(2026, 11, day, hour, minute).subtract(offset);

  /// A slot as the mobile API sends it, `HH:mm` times at the venue.
  CalendarDateSlot slot(
    String id,
    int day,
    String start,
    String? end, {
    int? endDay,
    SlotTimeKind timeKind = SlotTimeKind.exact,
  }) {
    return CalendarDateSlot.fromJson({
      'id': id,
      'date': _date(day),
      'end_date': _date(endDay ?? day),
      'start_time': '$start:00',
      'end_time': end == null ? null : '$end:00',
      'time_kind': timeKind == SlotTimeKind.startOnly ? 'start_only' : 'exact',
      'start_datetime': _iso(day, start),
      'end_datetime': end == null ? null : _iso(endDay ?? day, end),
    });
  }

  String _date(int day) => '2026-11-${day.toString().padLeft(2, '0')}';

  String _iso(int day, String time) {
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.abs().inHours.toString().padLeft(2, '0');
    final minutes = (offset.abs().inMinutes % 60).toString().padLeft(2, '0');
    return '${_date(day)}T$time:00$sign$hours:$minutes';
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/petit_boo/data/models/tool_result_dto.dart';
import 'package:lehiboo/features/petit_boo/presentation/utils/tool_result_visibility.dart';

ToolResultDto _result(
  String tool,
  Map<String, dynamic> data, {
  String? executedAt,
}) {
  return ToolResultDto(
    tool: tool,
    data: data,
    executedAt: executedAt,
  );
}

ToolResultDto _eventSearch({
  required String marker,
  required List<Map<String, dynamic>> events,
  String tool = 'searchEvents',
}) {
  return _result(
    tool,
    {
      'success': true,
      'data': {
        'events': events,
        'total': events.length,
        'marker': marker,
      },
    },
    executedAt: marker,
  );
}

void main() {
  group('visiblePetitBooToolResults', () {
    test('hides empty searches when a later search finds events', () {
      final firstEmpty = _eventSearch(marker: 'first', events: []);
      final secondEmpty = _eventSearch(marker: 'second', events: []);
      final found = _eventSearch(
        marker: 'found',
        events: [
          {'uuid': 'event-1', 'title': 'Concert'},
        ],
      );

      final visible = visiblePetitBooToolResults([
        firstEmpty,
        secondEmpty,
        found,
      ]);

      expect(visible, [found]);
    });

    test('keeps one empty state when every search is empty', () {
      final firstEmpty = _eventSearch(marker: 'first', events: []);
      final lastEmpty = _eventSearch(marker: 'last', events: []);

      final visible = visiblePetitBooToolResults([
        firstEmpty,
        lastEmpty,
      ]);

      expect(visible, [lastEmpty]);
    });

    test('preserves other tools and successful searches in order', () {
      final booking = _result('getMyBookings', {
        'data': {
          'bookings': [],
          'total': 0,
        },
      });
      final firstFound = _eventSearch(
        marker: 'first-found',
        events: [
          {'uuid': 'event-1'},
        ],
      );
      final empty = _eventSearch(marker: 'empty', events: []);
      final secondFound = _eventSearch(
        marker: 'second-found',
        events: [
          {'uuid': 'event-2'},
        ],
      );

      final visible = visiblePetitBooToolResults([
        booking,
        firstFound,
        empty,
        secondFound,
      ]);

      expect(visible, [booking, firstFound, secondFound]);
    });

    test('supports snake-case history and string totals', () {
      final empty = ToolResultDto.fromJson({
        'tool': 'search_events',
        'result': {
          'success': true,
          'data': {
            'events': const [],
            'total': '0',
          },
        },
      });

      expect(visiblePetitBooToolResults([empty]), [empty]);
    });

    test('does not treat failed payloads as successful searches', () {
      final empty = _eventSearch(marker: 'empty', events: []);
      final error = _result('searchEvents', {
        'success': false,
        'error': 'search unavailable',
        'data': {
          'events': const [],
          'total': 0,
        },
      });

      expect(visiblePetitBooToolResults([empty, error]), [empty, error]);
    });

    test('keeps malformed search payloads visible', () {
      final malformed = _result('searchEvents', {
        'success': true,
        'total': 2,
      });

      expect(visiblePetitBooToolResults([malformed]), [malformed]);
    });
  });
}

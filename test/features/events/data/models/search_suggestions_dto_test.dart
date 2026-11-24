import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/events/data/models/search_suggestions_dto.dart';

void main() {
  test('reads whether an event suggestion has ended', () {
    final suggestions = SearchSuggestionsDto.fromJson({
      'events': [
        {'type': 'event', 'slug': 'expo', 'label': 'Expo', 'is_past': true},
        {
          'type': 'event',
          'slug': 'concert',
          'label': 'Concert',
          'is_past': false
        },
        {'type': 'event', 'slug': 'older-api', 'label': 'Older API'},
      ],
    });

    expect(
      suggestions.events.map((event) => event.isPast),
      [true, false, false],
    );
  });
}

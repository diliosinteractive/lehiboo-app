import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/stories/data/mappers/story_mapper.dart';
import 'package:lehiboo/features/stories/data/models/story_dto.dart';

void main() {
  group('StoryMapper', () {
    test('uses nested event start date when provided', () {
      final dto = StoryDto.fromJson({
        'uuid': 'story-1',
        'title': 'Story title',
        'mediaUrl': 'https://example.com/story.jpg',
        'mediaType': 'image',
        'startDate': '2026-06-15',
        'endDate': '2026-06-20',
        'event': {
          'uuid': 'event-1',
          'slug': 'event-slug',
          'title': 'Event title',
          'startDate': '2026-07-01',
        },
      });

      final story = StoryMapper.toStory(dto);

      expect(story.startDate, DateTime(2026, 6, 15));
      expect(story.eventStartDate, DateTime(2026, 7, 1));
    });

    test('falls back to nested next slot date for older backend payloads', () {
      final dto = StoryDto.fromJson({
        'uuid': 'story-1',
        'title': 'Story title',
        'mediaUrl': 'https://example.com/story.jpg',
        'mediaType': 'image',
        'startDate': '2026-06-15',
        'endDate': '2026-06-20',
        'event': {
          'uuid': 'event-1',
          'slug': 'event-slug',
          'title': 'Event title',
          'nextSlot': {
            'date': '2026-07-02',
          },
        },
      });

      final story = StoryMapper.toStory(dto);

      expect(story.eventStartDate, DateTime(2026, 7, 2));
    });
  });
}

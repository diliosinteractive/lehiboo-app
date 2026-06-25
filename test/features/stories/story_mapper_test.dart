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

    test('maps updated_at into the story viewed state key', () {
      final dto = StoryDto.fromJson({
        'uuid': 'story-1',
        'title': 'Story title',
        'media_url': 'https://example.com/story.jpg',
        'media_type': 'image',
        'start_date': '2026-06-15',
        'end_date': '2026-06-20',
        'updated_at': '2026-06-23T08:30:00Z',
      });

      final story = StoryMapper.toStory(dto);

      expect(story.updatedAt, DateTime.utc(2026, 6, 23, 8, 30));
      expect(
        story.viewedStateKey,
        'story-1:2026-06-23T08:30:00.000Z',
      );
    });
  });
}

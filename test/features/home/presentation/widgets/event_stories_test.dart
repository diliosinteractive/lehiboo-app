import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/home/presentation/widgets/event_stories.dart';
import 'package:lehiboo/features/stories/domain/entities/story.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('viewed story state is scoped to the story updated timestamp', () async {
    final notifier = ViewedStoriesNotifier();
    final firstVersion = _story(updatedAt: DateTime.utc(2026, 6, 23, 8, 30));
    final sameVersion = _story(updatedAt: DateTime.utc(2026, 6, 23, 8, 30));
    final updatedVersion = _story(updatedAt: DateTime.utc(2026, 6, 23, 9));

    await notifier.markAsViewed(firstVersion);

    expect(notifier.isViewed(sameVersion), isTrue);
    expect(notifier.isViewed(updatedVersion), isFalse);

    final prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getStringList('viewed_stories'),
      contains('story-1:2026-06-23T08:30:00.000Z'),
    );
  });
}

Story _story({DateTime? updatedAt}) {
  return Story(
    uuid: 'story-1',
    title: 'Story 1',
    mediaUrl: 'https://example.test/story.jpg',
    mediaType: StoryMediaType.image,
    type: 'optional',
    startDate: DateTime(2026, 6, 23),
    endDate: DateTime(2026, 6, 24),
    slotPosition: 1,
    impressionsCount: 0,
    updatedAt: updatedAt,
    eventUuid: 'event-1',
    eventSlug: 'event-1',
    eventTitle: 'Event 1',
  );
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lehiboo/features/stories/domain/entities/story.dart';
import 'package:lehiboo/features/stories/domain/repositories/stories_repository.dart';
import 'package:lehiboo/features/stories/presentation/providers/stories_provider.dart';

class FakeStoriesRepository implements StoriesRepository {
  int loadCount = 0;
  final recordedImpressions = <String>[];

  @override
  Future<List<Story>> getActiveStories() async {
    loadCount++;
    return [
      Story(
        uuid: 'story-1',
        title: 'Story 1',
        mediaUrl: 'https://example.test/story.jpg',
        mediaType: StoryMediaType.image,
        type: 'optional',
        startDate: DateTime(2026),
        endDate: DateTime(2026, 1, 2),
        slotPosition: 1,
        impressionsCount: 0,
        eventUuid: 'event-1',
        eventSlug: 'event-1',
        eventTitle: 'Event 1',
      ),
    ];
  }

  @override
  void recordImpression(String storyUuid) {
    recordedImpressions.add(storyUuid);
  }
}

void main() {
  test('activeStoriesProvider uses the abstract repository override', () async {
    final repository = FakeStoriesRepository();
    final container = ProviderContainer(
      overrides: [
        storiesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final stories = await container.read(activeStoriesProvider.future);

    expect(stories.single.uuid, 'story-1');
    expect(repository.loadCount, 1);

    container.read(activeStoriesProvider.notifier).recordImpression('story-1');

    expect(repository.recordedImpressions, ['story-1']);
  });
}

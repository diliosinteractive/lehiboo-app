import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/stories_repository.dart';

final activeStoriesProvider =
    AutoDisposeAsyncNotifierProvider<ActiveStoriesNotifier, List<Story>>(
  ActiveStoriesNotifier.new,
);

class ActiveStoriesNotifier extends AutoDisposeAsyncNotifier<List<Story>> {
  @override
  Future<List<Story>> build() async {
    final repository = ref.watch(storiesRepositoryProvider);

    final stories = await repository.getActiveStories();
    ref.keepAlive();
    return stories;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build());
  }

  /// Fire-and-forget impression recording.
  void recordImpression(String storyUuid) {
    final repository = ref.read(storiesRepositoryProvider);
    repository.recordImpression(storyUuid);
  }
}

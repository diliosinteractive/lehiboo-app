import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/stories_repository_impl.dart';
import '../../domain/entities/story.dart';

final activeStoriesProvider =
    AutoDisposeAsyncNotifierProvider<ActiveStoriesNotifier, List<Story>>(
  ActiveStoriesNotifier.new,
);

class ActiveStoriesNotifier extends AutoDisposeAsyncNotifier<List<Story>> {
  @override
  Future<List<Story>> build() async {
    final repository = ref.watch(storiesRepositoryImplProvider);

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
    final repository = ref.read(storiesRepositoryImplProvider);
    repository.recordImpression(storyUuid);
  }
}

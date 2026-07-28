import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/stories_repository_impl.dart';
import '../../domain/entities/story.dart';

const _storiesFreshness = Duration(minutes: 15);

final activeStoriesProvider =
    AutoDisposeAsyncNotifierProvider<ActiveStoriesNotifier, List<Story>>(
  ActiveStoriesNotifier.new,
);

class ActiveStoriesNotifier extends AutoDisposeAsyncNotifier<List<Story>> {
  Future<void>? _refreshInFlight;
  Timer? _freshnessTimer;
  KeepAliveLink? _cacheLink;

  @override
  Future<List<Story>> build() async {
    final repository = ref.watch(storiesRepositoryImplProvider);
    _cacheLink?.close();
    _cacheLink = ref.keepAlive();
    _freshnessTimer?.cancel();
    _freshnessTimer = Timer(_storiesFreshness, () {
      _cacheLink?.close();
      _cacheLink = null;
      ref.invalidateSelf();
    });
    ref.onDispose(() {
      _freshnessTimer?.cancel();
      _freshnessTimer = null;
      _cacheLink?.close();
      _cacheLink = null;
    });

    return repository.getActiveStories();
  }

  Future<void> refresh() {
    return _refreshInFlight ??= _reload().whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<void> _reload() async {
    ref.invalidateSelf();
    await future;
  }

  /// Fire-and-forget impression recording.
  void recordImpression(String storyUuid) {
    final repository = ref.read(storiesRepositoryImplProvider);
    repository.recordImpression(storyUuid);
  }
}

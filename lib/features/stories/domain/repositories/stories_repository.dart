import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/story.dart';

final storiesRepositoryProvider = Provider<StoriesRepository>((ref) {
  throw UnimplementedError('storiesRepositoryProvider not initialized');
});

abstract class StoriesRepository {
  Future<List<Story>> getActiveStories();
  void recordImpression(String storyUuid);
}

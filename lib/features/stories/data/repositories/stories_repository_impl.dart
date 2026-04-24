import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/story.dart';
import '../../domain/repositories/stories_repository.dart';
import '../datasources/stories_api_datasource.dart';
import '../mappers/story_mapper.dart';

final storiesRepositoryImplProvider = Provider<StoriesRepository>((ref) {
  final dataSource = ref.read(storiesApiDataSourceProvider);
  return StoriesRepositoryImpl(dataSource);
});

class StoriesRepositoryImpl implements StoriesRepository {
  final StoriesApiDataSource _dataSource;

  StoriesRepositoryImpl(this._dataSource);

  @override
  Future<List<Story>> getActiveStories() async {
    final dtos = await _dataSource.getActiveStories();
    return StoryMapper.toStories(dtos);
  }

  @override
  void recordImpression(String storyUuid) {
    _dataSource.recordImpression(storyUuid);
  }
}

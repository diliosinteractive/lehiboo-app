import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
import '../models/story_dto.dart';

final storiesApiDataSourceProvider = Provider<StoriesApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return StoriesApiDataSource(dio);
});

class StoriesApiDataSource {
  final Dio _dio;

  StoriesApiDataSource(this._dio);

  /// Fetch active stories for today.
  /// Returns up to 8 stories ordered by: reserved first, then optional by slot_position.
  Future<List<StoryDto>> getActiveStories() async {
    final response = await _dio.get('/stories/active');

    final list = ApiResponseHandler.extractList(response.data);
    return list
        .map((e) => StoryDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Record an impression for a story. Fire-and-forget: no await needed by caller,
  /// errors are silently logged.
  void recordImpression(String storyUuid) {
    _dio.post('/stories/$storyUuid/impression').catchError((e) {
      if (kDebugMode) {
        debugPrint('Stories: impression failed for $storyUuid: $e');
      }
      return Response(requestOptions: RequestOptions(path: ''));
    });
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
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

    if (response.statusCode == 200) {
      final data = response.data;

      // Standard API response: { "success": true, "data": [...] }
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final dataContent = data['data'];
        if (dataContent is List) {
          return dataContent
              .map((e) => StoryDto.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }

      // Fallback: direct list at root
      if (data is List) {
        return data
            .map((e) => StoryDto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    throw Exception('Failed to fetch active stories');
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

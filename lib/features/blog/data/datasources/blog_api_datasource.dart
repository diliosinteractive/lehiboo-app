import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../models/blog_post_dto.dart';

final blogApiDataSourceProvider = Provider<BlogApiDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return BlogApiDataSource(dio);
});

class BlogApiDataSource {
  final Dio _dio;

  BlogApiDataSource(this._dio);

  /// Get list of blog posts
  Future<BlogPostsResponseDto> getPosts({
    int page = 1,
    int perPage = 3,
    String? category,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }

    debugPrint('=== BlogApiDataSource.getPosts ===');
    debugPrint('Query params: $queryParams');

    final response = await _dio.get('/posts', queryParameters: queryParams);
    final data = response.data;

    debugPrint('API Response success: ${data['success']}');

    if (data['success'] == true && data['data'] != null) {
      final postsData = data['data'];
      debugPrint('Posts count in response: ${(postsData['posts'] as List?)?.length ?? 0}');

      try {
        final result = BlogPostsResponseDto.fromJson(data['data']);
        debugPrint('Successfully parsed BlogPostsResponseDto with ${result.posts.length} posts');
        return result;
      } catch (parseError, parseStack) {
        debugPrint('Error parsing BlogPostsResponseDto: $parseError');
        debugPrint('Parse stack: $parseStack');
        rethrow;
      }
    }
    throw Exception(data['error']?['message'] ?? 'Failed to load posts');
  }

  /// Get single blog post by ID
  Future<BlogPostDto> getPostById(int id) async {
    debugPrint('=== BlogApiDataSource.getPostById ===');
    debugPrint('Post ID: $id');

    final response = await _dio.get('/posts/$id');
    final data = response.data;

    if (data['success'] == true && data['data'] != null) {
      return BlogPostDto.fromJson(data['data']['post']);
    }
    throw Exception(data['error']?['message'] ?? 'Post not found');
  }
}

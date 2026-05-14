import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/dio_client.dart';
import '../../../../core/utils/api_response_handler.dart';
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
    int perPage = 5,
    String? category,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }

    final response = await _dio.get(
      '/posts',
      queryParameters: queryParams,
    );
    final postList = ApiResponseHandler.extractList(response.data)
        .whereType<Map<String, dynamic>>()
        .map(BlogPostDto.fromJson)
        .toList(growable: false);
    final meta = ApiResponseHandler.extractMeta(response.data);
    final currentPage = meta?.currentPage ?? page;
    final totalPages = meta?.lastPage ?? 1;

    return BlogPostsResponseDto(
      posts: postList,
      pagination: BlogPaginationDto(
        currentPage: currentPage,
        perPage: meta?.perPage ?? perPage,
        totalItems: meta?.total ?? postList.length,
        totalPages: totalPages,
        hasNext: currentPage < totalPages,
        hasPrev: currentPage > 1,
      ),
    );
  }

  /// Get single blog post by ID
  Future<BlogPostDto> getPostById(int id) async {
    final response = await _dio.get(
      '/posts/$id',
    );
    final payload = ApiResponseHandler.extractObject(response.data);
    final postData = payload['post'];
    if (postData is Map<String, dynamic>) {
      return BlogPostDto.fromJson(postData);
    }
    return BlogPostDto.fromJson(payload);
  }
}

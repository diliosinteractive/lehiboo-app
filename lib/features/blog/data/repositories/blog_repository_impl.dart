import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/blog_repository.dart';
import '../datasources/blog_api_datasource.dart';
import '../models/blog_post_dto.dart';

final blogRepositoryImplProvider = Provider<BlogRepositoryImpl>((ref) {
  final apiDataSource = ref.read(blogApiDataSourceProvider);
  return BlogRepositoryImpl(apiDataSource);
});

class BlogRepositoryImpl implements BlogRepository {
  final BlogApiDataSource _apiDataSource;

  BlogRepositoryImpl(this._apiDataSource);

  @override
  Future<BlogPostsResult> getPosts({
    int page = 1,
    int perPage = 3,
    String? category,
  }) async {
    final response = await _apiDataSource.getPosts(
      page: page,
      perPage: perPage,
      category: category,
    );

    return BlogPostsResult(
      posts: response.posts,
      currentPage: response.pagination.currentPage,
      totalPages: response.pagination.totalPages,
      totalItems: response.pagination.totalItems,
      hasNext: response.pagination.hasNext,
      hasPrev: response.pagination.hasPrev,
    );
  }

  @override
  Future<BlogPostDto> getPostById(int id) async {
    return await _apiDataSource.getPostById(id);
  }
}

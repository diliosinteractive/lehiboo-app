import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/blog_post_dto.dart';

abstract class BlogRepository {
  Future<BlogPostsResult> getPosts({
    int page = 1,
    int perPage = 3,
    String? category,
  });

  Future<BlogPostDto> getPostById(int id);
}

class BlogPostsResult {
  final List<BlogPostDto> posts;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNext;
  final bool hasPrev;

  BlogPostsResult({
    required this.posts,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNext,
    required this.hasPrev,
  });
}

final blogRepositoryProvider = Provider<BlogRepository>((ref) {
  throw UnimplementedError('blogRepositoryProvider not initialized');
});

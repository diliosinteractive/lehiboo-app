import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/blog_repository.dart';
import '../../data/models/blog_post_dto.dart';

/// Provider for latest blog posts (default: 3 posts for home screen)
final latestBlogPostsProvider = FutureProvider<List<BlogPostDto>>((ref) async {
  final repository = ref.watch(blogRepositoryProvider);

  final result = await repository.getPosts(
    page: 1,
    perPage: 3,
  );

  return result.posts;
});

/// Provider for blog posts with pagination
final blogPostsProvider = FutureProvider.family<BlogPostsResult, BlogPostsParams>((ref, params) async {
  final repository = ref.watch(blogRepositoryProvider);

  return await repository.getPosts(
    page: params.page,
    perPage: params.perPage,
    category: params.category,
  );
});

/// Provider for single blog post
final blogPostDetailProvider = FutureProvider.family<BlogPostDto, int>((ref, postId) async {
  final repository = ref.watch(blogRepositoryProvider);
  return await repository.getPostById(postId);
});

/// Parameters for blog posts query
class BlogPostsParams {
  final int page;
  final int perPage;
  final String? category;

  const BlogPostsParams({
    this.page = 1,
    this.perPage = 10,
    this.category,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BlogPostsParams &&
        other.page == page &&
        other.perPage == perPage &&
        other.category == category;
  }

  @override
  int get hashCode => Object.hash(page, perPage, category);
}

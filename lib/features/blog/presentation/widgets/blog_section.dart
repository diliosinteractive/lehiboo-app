import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/blog_providers.dart';
import 'blog_post_card.dart';

class BlogSection extends ConsumerWidget {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(latestBlogPostsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Derniers articles',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to blog list
                },
                child: const Text(
                  'Voir tout',
                  style: TextStyle(
                    color: Color(0xFFFF601F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        postsAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Aucun article disponible',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return SizedBox(
              height: 240,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: posts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 280,
                    child: BlogPostCard(
                      post: posts[index],
                      isCompact: true,
                    ),
                  );
                },
              ),
            );
          },
          loading: () => SizedBox(
            height: 240,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 280,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF601F),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Erreur: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => ref.refresh(latestBlogPostsProvider),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

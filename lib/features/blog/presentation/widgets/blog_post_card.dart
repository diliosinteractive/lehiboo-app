import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/blog_post_dto.dart';

class BlogPostCard extends StatelessWidget {
  final BlogPostDto post;
  final bool isCompact;

  const BlogPostCard({
    super.key,
    required this.post,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPost(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: isCompact ? _buildCompactCard() : _buildFullCard(),
      ),
    );
  }

  Widget _buildCompactCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        AspectRatio(
          aspectRatio: 16 / 9,
          child: _buildImage(),
        ),
        // Content
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Meta
              Row(
                children: [
                  if (post.readingTime != null) ...[
                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      '${post.readingTime} min',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFullCard() {
    return Row(
      children: [
        // Image on left
        SizedBox(
          width: 120,
          height: 120,
          child: _buildImage(),
        ),
        // Content on right
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Category
                if (post.categories != null && post.categories!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF601F).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      post.categories!.first.name,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF601F),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                // Title
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Meta row
                Row(
                  children: [
                    if (post.author != null) ...[
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: post.author!.avatar != null
                            ? CachedNetworkImageProvider(post.author!.avatar!)
                            : null,
                        child: post.author!.avatar == null
                            ? const Icon(Icons.person, size: 12)
                            : null,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        post.author!.name,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const Spacer(),
                    if (post.readingTime != null) ...[
                      Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        '${post.readingTime} min',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    final imageUrl = post.featuredImage?.large ??
        post.featuredImage?.medium ??
        post.featuredImage?.thumbnail;

    if (imageUrl == null) {
      return Container(
        color: const Color(0xFFFF601F).withOpacity(0.1),
        child: const Center(
          child: Icon(
            Icons.article,
            size: 40,
            color: Color(0xFFFF601F),
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF601F),
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: const Color(0xFFFF601F).withOpacity(0.1),
        child: const Center(
          child: Icon(
            Icons.article,
            size: 40,
            color: Color(0xFFFF601F),
          ),
        ),
      ),
    );
  }

  Future<void> _openPost(BuildContext context) async {
    if (post.link != null) {
      final uri = Uri.parse(post.link!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }
}

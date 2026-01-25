import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/themes/colors.dart';
import '../../../data/models/tool_result_dto.dart';

/// Card displaying favorites from getMyFavorites tool
class FavoritesResultCard extends StatelessWidget {
  final FavoritesToolResult result;

  const FavoritesResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    if (result.favorites.isEmpty) {
      return _buildEmptyState(context);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: HbColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: HbColors.error,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Favorites',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: HbColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${result.total} saved event${result.total != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 13,
                          color: HbColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Horizontal scroll of favorites
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: result.favorites.take(5).length,
              itemBuilder: (context, index) {
                final event = result.favorites[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < result.favorites.length - 1 ? 12 : 0,
                  ),
                  child: _FavoriteEventCard(event: event),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Lists preview (if any)
          if (result.lists != null && result.lists!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: result.lists!.take(3).map((list) {
                  return ActionChip(
                    label: Text(
                      '${list.name} (${list.eventsCount})',
                      style: const TextStyle(fontSize: 12),
                    ),
                    onPressed: () => context.push('/favorites/${list.uuid}'),
                    backgroundColor: HbColors.orangePastel,
                    side: BorderSide.none,
                  );
                }).toList(),
              ),
            ),

          // Show more button
          InkWell(
            onTap: () => context.push('/favorites'),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View all favorites',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: HbColors.brandPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: HbColors.brandPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HbColors.orangePastel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.favorite_border,
            color: HbColors.error.withOpacity(0.5),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'No favorites yet',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: HbColors.textPrimary,
                  ),
                ),
                Text(
                  'Save events to find them easily later',
                  style: TextStyle(
                    fontSize: 12,
                    color: HbColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push('/explore'),
            child: const Text('Explore'),
          ),
        ],
      ),
    );
  }
}

class _FavoriteEventCard extends StatelessWidget {
  final EventResultItem event;

  const _FavoriteEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/event/${event.slug}'),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with heart
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 80,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    event.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: event.imageUrl!,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: HbColors.orangePastel,
                            child: const Icon(Icons.event, color: HbColors.brandPrimary),
                          ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: HbColors.error,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                event.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: HbColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

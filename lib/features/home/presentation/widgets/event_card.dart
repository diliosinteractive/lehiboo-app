import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:intl/intl.dart';

class EventCard extends ConsumerWidget {
  final Activity activity;

  const EventCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(activity.id);
    return GestureDetector(
      onTap: () {
        debugPrint('Tapped activity: ${activity.id} - ${activity.title}');
        context.push('/event/${activity.id}', extra: activity);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            // Image avec badge catégorie
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: activity.imageUrl ?? 'https://via.placeholder.com/400x300',
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 140,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 140,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                // Badge catégorie
                if (activity.category != null)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(activity.category!.slug),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      activity.category!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Bouton favori
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        ref.read(favoritesProvider.notifier).toggleFavorite(activity.id);
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Contenu
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Text(
                    activity.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Date et heure (Mocked/Formatted for now if activity doesn't have explicit date fields)
                  // Using first slot if available
                  if (activity.nextSlot != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM').format(activity.nextSlot!.startDateTime),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('HH:mm').format(activity.nextSlot!.startDateTime),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Lieu et distance
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                           activity.city?.name ?? 'Lieu inconnu',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Tags
                  if (activity.tags != null && activity.tags!.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: activity.tags!.take(3).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag.name,
                            style: const TextStyle(
                              color: Color(0xFFFF6B35),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 12),
                  // Prix et bouton réserver
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                           activity.priceMin == 0 ? 'Gratuit' : '${activity.priceMin}€',
                          style: const TextStyle(
                             color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Direct booking link
                          context.push('/booking/${activity.id}', extra: activity);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          'Réserver',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String slug) {
    switch (slug.toLowerCase()) {
      case 'atelier':
        return Colors.purple;
      case 'concert':
        return Colors.blue;
      case 'spectacle':
        return Colors.red;
      case 'sport':
        return Colors.green;
      case 'marche':
        return Colors.orange;
      case 'culture':
        return Colors.indigo;
      default:
        return const Color(0xFFFF6B35);
    }
  }
}
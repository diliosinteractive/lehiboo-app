import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/core/utils/guest_guard.dart';

class EventCard extends ConsumerWidget {
  final Activity activity;
  final bool isCompact;

  const EventCard({super.key, required this.activity, this.isCompact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);
    final isFavorite = favoritesState.value?.any((e) => e.id == activity.id) ?? false;

    return GestureDetector(
      onTap: () {
        debugPrint('Tapped activity: ${activity.id} - ${activity.title}');
        context.push('/event/${activity.id}', extra: activity);
      },
      child: Container( // Removed margin bottom as grid handles spacing
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
        clipBehavior: Clip.hardEdge,
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
                    height: isCompact ? 220 : 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: isCompact ? 220 : 140,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFF601F),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: isCompact ? 220 : 140,
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
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(activity.category!.slug),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      activity.category!.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Bouton favori
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 30,
                    height: 30,
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
                      onPressed: () async {
                        final canProceed = await GuestGuard.check(
                          context: context,
                          ref: ref,
                          featureName: 'ajouter aux favoris',
                        );
                        if (canProceed) {
                          // Simple mapping to Event for favoriting
                          final event = Event(
                            id: activity.id,
                            title: activity.title,
                            description: '',
                            shortDescription: '',
                            category: EventCategory.other,
                            targetAudiences: [],
                            startDate: activity.nextSlot?.startDateTime ?? DateTime.now(),
                            endDate: activity.nextSlot?.endDateTime ?? DateTime.now(),
                            venue: activity.city?.name ?? '',
                            address: '',
                            city: activity.city?.name ?? '',
                            postalCode: '',
                            latitude: 0,
                            longitude: 0,
                            images: activity.imageUrl != null ? [activity.imageUrl!] : [],
                            coverImage: activity.imageUrl,
                            priceType: activity.priceMin == 0 ? PriceType.free : PriceType.paid,
                            minPrice: activity.priceMin,
                            maxPrice: activity.priceMax,
                            isIndoor: false,
                            isOutdoor: false,
                            tags: [],
                            organizerId: '',
                            organizerName: '',
                            isFavorite: isFavorite, // Use current state
                            isFeatured: false,
                            isRecommended: false,
                            status: EventStatus.upcoming,
                            hasDirectBooking: false,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            views: 0
                          );
                          ref.read(favoritesProvider.notifier).toggleFavorite(event);
                        }
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Contenu
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isCompact ? 10 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top section: Title and date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Titre
                        Text(
                          activity.title,
                          style: TextStyle(
                            fontSize: isCompact ? 14 : 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3748),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!isCompact) const SizedBox(height: 8),
                        // Date et heure
                        if (activity.nextSlot != null)
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('dd MMM').format(activity.nextSlot!.startDateTime),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              if (!isCompact) ...[
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('HH:mm').format(activity.nextSlot!.startDateTime),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        // Location
                        if (!isCompact) ...[
                          const SizedBox(height: 8),
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
                        ],
                        // Tags - Hidden in compact mode
                        if (!isCompact && activity.tags != null && activity.tags!.isNotEmpty) ...[
                          const SizedBox(height: 12),
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
                                  color: const Color(0xFFFF601F).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag.name,
                                  style: const TextStyle(
                                    color: Color(0xFFFF601F),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                    // Bottom section: Prix et bouton réserver
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isCompact ? 8 : 12,
                            vertical: isCompact ? 4 : 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            activity.priceMin == 0 ? 'Gratuit' : '${activity.priceMin}€',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: isCompact ? 12 : 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isCompact)
                          InkWell(
                            onTap: () => context.push('/event/${activity.id}', extra: activity),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF601F),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: () {
                              context.push('/event/${activity.id}', extra: activity);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF601F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                            ),
                            child: const Text(
                              'Voir',
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
        return const Color(0xFFFF601F);
    }
  }
}
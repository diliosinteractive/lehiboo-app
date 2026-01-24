import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart' show Event, EventCategory, EventStatus, PriceType;

class MapEventCard extends ConsumerWidget {
  final Activity activity;

  const MapEventCard({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if favorite - Protected access
    final favoritesState = ref.watch(favoritesProvider);
    bool isFavorite = false;
    if (favoritesState is AsyncData<List<Event>>) {
      isFavorite = favoritesState.value.any((e) => e.id == activity.id);
    }

    return GestureDetector(
      onTap: () => context.push('/event/${activity.id}', extra: activity),
      child: Container(
        // remove fixed width, parent controls it via PageView
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image Background - Fills the card
            if (activity.imageUrl != null)
              CachedNetworkImage(
                imageUrl: activity.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[800]),
                errorWidget: (context, url, error) {
                  // Fallback 1: Theme Image
                  if (activity.category != null) {
                    return Image.asset(
                      'assets/images/thematiques/${activity.category!.slug.toLowerCase()}.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback 2: Logo
                        return Container(
                          color: const Color(0xFFFF601F), // HbColors.brandPrimary
                          padding: const EdgeInsets.all(24),
                          child: Image.asset(
                            'assets/images/logo_picto_lehiboo.png',
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    );
                  }
                  // Fallback 2: Logo
                  return Container(
                    color: const Color(0xFFFF601F), // HbColors.brandPrimary
                    padding: const EdgeInsets.all(24),
                    child: Image.asset(
                      'assets/images/logo_picto_lehiboo.png',
                      fit: BoxFit.contain,
                    ),
                  );
                },
              )
            else if (activity.category != null)
              Image.asset(
                'assets/images/thematiques/${activity.category!.slug.toLowerCase()}.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFFF601F), // HbColors.brandPrimary
                  padding: const EdgeInsets.all(24),
                  child: Image.asset(
                    'assets/images/logo_picto_lehiboo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              )
            else
              Container(
                color: const Color(0xFFFF601F), // HbColors.brandPrimary
                padding: const EdgeInsets.all(24),
                child: Image.asset(
                  'assets/images/logo_picto_lehiboo.png',
                  fit: BoxFit.contain,
                ),
              ),
            
            // Gradient Overlay for Text Visibility
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black87,
                      Colors.black54,
                      Colors.transparent
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Content (Text)
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (activity.nextSlot != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF601F),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Builder(
                        builder: (context) {
                          String dateText;
                          try {
                            dateText = DateFormat('d MMM', 'fr_FR').format(activity.nextSlot!.startDateTime);
                          } catch (e) {
                            final dt = activity.nextSlot!.startDateTime;
                            dateText = '${dt.day}/${dt.month}';
                          }
                          return Text(
                            dateText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                            ),
                          );
                        },
                      ),
                    ),
                  Text(
                    activity.title,
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 14, 
                      fontWeight: FontWeight.bold,
                      height: 1.2
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.priceMin == 0 ? 'Gratuit' : '${(activity.priceMin ?? 0).toStringAsFixed(0)}€',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Favorite Button - Standard Style
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                   final event = Event(
                            id: activity.id,
                            slug: activity.slug,
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
                            isFavorite: isFavorite,
                            isFeatured: false,
                            isRecommended: false,
                            status: EventStatus.upcoming,
                            hasDirectBooking: false,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            views: 0
                          );
                          ref.read(favoritesProvider.notifier).toggleFavorite(event);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: isFavorite ? const Color(0xFFFF601F) : Colors.grey[400], // Using brand Orange for fav or Red? EventCard uses Red. Let's check.
                    // EventCard used Colors.red for favorite, Colors.grey for border.
                    // I'll stick to what EventCard had: color: isFavorite ? Colors.red : Colors.grey
                    // But wait, the standard usually is brand color.
                    // Let's re-read EventCard code... 
                    // line 167: color: isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

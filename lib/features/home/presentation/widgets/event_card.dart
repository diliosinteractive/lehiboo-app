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
  final bool showTimeBadge;
  final String? heroTagPrefix; // Added prefix

  const EventCard({
    super.key, 
    required this.activity, 
    this.isCompact = false, 
    this.showTimeBadge = false,
    this.heroTagPrefix,
  });

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '${hours}h';
    }
    return '${hours}h${remainingMinutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);
    final isFavorite = favoritesState.value?.any((e) => e.id == activity.id) ?? false;

    return GestureDetector(
      onTap: () {
        debugPrint('Tapped activity: ${activity.id} - ${activity.title}');
        context.push('/event/${activity.id}', extra: activity);
      },
      child: Container(
        // Remove fixed height to let content size naturally (removing white space)
        width: isCompact ? 180 : double.infinity, // Fixed width for compact mode if needed
        // Remove decoration (white background & shadow) as requested
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Wrap content tightly
          children: [
            // 1. IMAGE SECTION
            Stack(
              children: [
                // Image - Taller (Portrait/9:16 approx) & Fully Rounded
                Hero(
                  tag: 'event_image_${heroTagPrefix ?? 'card'}_${activity.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16), // Rounded all corners like TripAdvisor
                    child: SizedBox(
                      height: isCompact ? 240 : 260, // Much taller (approx 3:4 or 9:16 feel)
                      width: double.infinity,
                      child: activity.imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: activity.imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[100],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFFF601F),
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => _buildFallbackImage(),
                            )
                          : _buildFallbackImage(),
                    ),
                  ),
                ),
                
                // Time Badge (Airbnb Style) OR Category Badge
                if (showTimeBadge && activity.nextSlot != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8F5), // Matches Scaffold Background
                        borderRadius: BorderRadius.circular(20), // Pill shape
                        boxShadow: [
                           BoxShadow(
                             color: Colors.black.withOpacity(0.1),
                             blurRadius: 4,
                             offset: const Offset(0, 2),
                           )
                        ],
                      ),
                      child: Text(
                        DateFormat('HH:mm').format(activity.nextSlot!.startDateTime),
                        style: const TextStyle(
                          color: Colors.black, // Dark text
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                else if (activity.category != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(activity.category!.slug).withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
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

                // Favorite Button
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () async {
                      final canProceed = await GuestGuard.check(
                        context: context,
                        ref: ref,
                        featureName: 'ajouter aux favoris',
                      );
                      if (canProceed) {
                        _toggleFavorite(ref, isFavorite);
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey[800],
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 2. CONTENT SECTION
            // Removed Expanded to eliminate the whitespace gap
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 4, right: 4, bottom: 4), // Reduced padding, added top offset
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    activity.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600, // Slightly less bold for modern look
                      color: Color(0xFF1A1A1A),
                      height: 1.1, // Compact
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2), // Tighter spacing

                  // Organizer
                  if (activity.partner != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'Par ${activity.partner!.name}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13, // Slightly larger for readability
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  // Mock Rating + Count
                  Row(
                    children: [
                       const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFF601F)), // Smaller icon
                       const SizedBox(width: 4),
                       Text(
                         '4.8',
                         style: TextStyle(
                           fontSize: 13,
                           fontWeight: FontWeight.w600,
                           color: Colors.grey[900],
                           height: 1.1,
                         ),
                       ),
                       Text(
                         ' (124)',
                         style: TextStyle(
                           fontSize: 13,
                           color: Colors.grey[600],
                           height: 1.1,
                         ),
                       ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  
                  // Location + Duration
                  Row(
                    children: [
                       Expanded(
                         child: Text.rich(
                           TextSpan(
                             children: [
                               TextSpan(
                                 text: activity.city?.name ?? activity.city?.region ?? 'France',
                                 style: TextStyle(
                                   color: Colors.grey[600],
                                   fontSize: 13,
                                   height: 1.1,
                                 ),
                               ),
                               if (activity.durationMinutes != null && activity.durationMinutes! > 0) ...[
                                  const TextSpan(text: ' • '),
                                  TextSpan(
                                    text: _formatDuration(activity.durationMinutes!),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                      height: 1.1,
                                    ),
                                  ),
                               ],
                             ]
                           ),
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                         ),
                       ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),

                  // Price line (Bottom)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      if (activity.priceMin == -1)
                        const SizedBox.shrink()
                      else
                        Text.rich(
                          TextSpan(
                            children: [
                              if (activity.priceMin == 0)
                                const TextSpan(
                                  text: 'Gratuit',
                                  style: TextStyle(
                                    color: Color(0xFFFF601F), // Keep orange for Free
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    height: 1.1,
                                  ),
                                )
                              else ...[
                                TextSpan(
                                  text: 'À partir de ',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 13,
                                    height: 1.1,
                                  ),
                                ),
                                TextSpan(
                                  text: '${(activity.priceMin ?? 0).toStringAsFixed(0)}€',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ],
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

  Widget _buildFallbackImage() {
    if (activity.category != null) {
      return Image.asset(
        'assets/images/thematiques/${activity.category!.slug.toLowerCase()}.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildLogoFallback(),
      );
    }
    return _buildLogoFallback();
  }

  Widget _buildLogoFallback() {
    return Container(
      color: const Color(0xFFFF601F),
      padding: const EdgeInsets.all(32),
      child: Image.asset(
        'assets/images/logo_picto_lehiboo.png',
        fit: BoxFit.contain,
      ),
    );
  }

  void _toggleFavorite(WidgetRef ref, bool isFavorite) {
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
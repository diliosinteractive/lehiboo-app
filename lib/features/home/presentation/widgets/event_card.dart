import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:intl/intl.dart';

class EventCard extends ConsumerWidget {
  final Activity activity;
  final bool isCompact;
  final bool showTimeBadge;
  final String? heroTagPrefix;

  /// Si true, la carte remplit son container parent (pour GridView avec childAspectRatio)
  final bool fillContainer;

  /// Hauteur d'image personnalisée (override le comportement par défaut)
  final double? imageHeight;

  const EventCard({
    super.key,
    required this.activity,
    this.isCompact = false,
    this.showTimeBadge = false,
    this.heroTagPrefix,
    this.fillContainer = false,
    this.imageHeight,
  });

  String _formatSlotDateTime(DateTime dt) {
    const days = ['lun.', 'mar.', 'mer.', 'jeu.', 'ven.', 'sam.', 'dim.'];
    const months = [
      'jan.', 'fév.', 'mars', 'avr.', 'mai', 'juin',
      'juil.', 'août', 'sep.', 'oct.', 'nov.', 'déc.',
    ];
    final dayName = days[dt.weekday - 1];
    final monthName = months[dt.month - 1];
    final time = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$dayName ${dt.day} $monthName à $time';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        debugPrint('Tapped activity: ${activity.id} - ${activity.title}');
        context.push('/event/${activity.id}', extra: activity);
      },
      child: Container(
        width: isCompact ? 180 : double.infinity,
        child: fillContainer
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image portrait fixe (même hauteur pour toutes les cards)
                  AspectRatio(
                    aspectRatio: 4 / 5,
                    child: _buildImageStack(),
                  ),
                  // Contenu complet, Expanded pour éviter overflow
                  Expanded(
                    child: _buildContentSection(compact: false, ctx: context),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildImageStack(),
                  _buildContentSection(compact: false, ctx: context),
                ],
              ),
      ),
    );
  }

  Widget _buildImageStack() {
    final double? height = imageHeight ?? (fillContainer ? null : (isCompact ? 240 : 260));

    return Stack(
      // Quand fillContainer, expand pour remplir l'Expanded parent
      fit: fillContainer ? StackFit.expand : StackFit.loose,
      children: [
        // Image
        Hero(
          tag: 'event_image_${heroTagPrefix ?? 'card'}_${activity.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: height,
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

        // Time Badge OR Category Badge
        if (showTimeBadge && activity.nextSlot != null)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F5),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Builder(
                builder: (context) {
                  String timeText;
                  try {
                    timeText = DateFormat('HH:mm').format(activity.nextSlot!.startDateTime);
                  } catch (e) {
                    final dt = activity.nextSlot!.startDateTime;
                    timeText = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                  }
                  return Text(
                    timeText,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
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
                color: _getCategoryColor(activity.category!.slug).withValues(alpha: 0.9),
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
          child: FavoriteButton(
            event: _activityToEvent(),
            iconSize: 18,
            containerSize: 32,
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection({required bool compact, BuildContext? ctx}) {
    return Padding(
      padding: EdgeInsets.only(
        top: compact ? 8 : 12,
        left: 4,
        right: 4,
        bottom: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title + Category chip
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  activity.title,
                  style: TextStyle(
                    fontSize: compact ? 13 : 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (activity.category != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: ctx != null ? () => ctx.push('/search?categorySlug=${activity.category!.slug}') : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(activity.category!.slug).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      activity.category!.name,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getCategoryColor(activity.category!.slug),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          if (!compact) ...[
            const SizedBox(height: 2),

            // Organizer
            if (activity.partner != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  'Par ${activity.partner!.name}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Rating (only if real data exists)
            if (activity.rating != null && activity.rating! > 0 && activity.reviewsCount != null && activity.reviewsCount! > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFF601F)),
                    const SizedBox(width: 4),
                    Text(
                      activity.rating!.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                        height: 1.1,
                      ),
                    ),
                    Text(
                      ' (${activity.reviewsCount})',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),

            // Location + Date/Time
            Text.rich(
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
                  if (activity.nextSlot != null) ...[
                    const TextSpan(text: ' • '),
                    TextSpan(
                      text: _formatSlotDateTime(activity.nextSlot!.startDateTime),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                        height: 1.1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 4),
          ] else ...[
            // Compact mode: just location
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 12, color: Colors.grey[500]),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    activity.city?.name ?? 'France',
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],

          // Price
          if (activity.priceMin != null && activity.priceMin != -1)
            Builder(builder: (context) {
              final isTrulyFree = activity.priceMin == 0 &&
                  (activity.priceMax == null || activity.priceMax == 0);
              if (isTrulyFree) {
                return Text(
                  'Gratuit',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                    fontSize: compact ? 12 : 14,
                    height: 1.1,
                  ),
                );
              }
              final price = (activity.priceMin! > 0)
                  ? activity.priceMin!
                  : activity.priceMax!;
              return Text(
                compact
                    ? 'Dès ${price.toStringAsFixed(0)}€'
                    : 'À partir de ${price.toStringAsFixed(0)}€',
                style: const TextStyle(
                  color: Color(0xFFFF601F),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.1,
                ),
              );
            }),
        ],
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

  Event _activityToEvent() {
    return Event(
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
      organizerId: activity.partner?.id ?? '',
      organizerName: activity.partner?.name ?? '',
      organizerLogo: activity.partner?.logoUrl,
      isFavorite: false,
      isFeatured: false,
      isRecommended: false,
      status: EventStatus.upcoming,
      hasDirectBooking: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      views: 0,
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

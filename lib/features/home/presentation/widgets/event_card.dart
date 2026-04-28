import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/favorites/presentation/widgets/favorite_button.dart';

class EventCard extends ConsumerWidget {
  final Activity activity;
  final bool isCompact;
  final bool isToday;
  final bool isTomorrow;
  final String? heroTagPrefix;

  /// Si true, la carte remplit son container parent (pour GridView avec childAspectRatio)
  final bool fillContainer;

  /// Hauteur d'image personnalisée (override le comportement par défaut)
  final double? imageHeight;

  const EventCard({
    super.key,
    required this.activity,
    this.isCompact = false,
    this.isToday = false,
    this.isTomorrow = false,
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
    final year = (dt.year % 100).toString().padLeft(2, '0');
    return '$dayName ${dt.day} $monthName $year à $time';
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
                    child: _buildImageStack(context),
                  ),
                  // Contenu complet, Expanded pour éviter overflow
                  Expanded(
                    child: _buildContentSection(compact: false),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildImageStack(context),
                  _buildContentSection(compact: false),
                ],
              ),
      ),
    );
  }

  Widget _buildImageStack(BuildContext context) {
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

        // Top row: Date/Time Badge + Favorite Button
        Positioned(
          top: 12,
          left: 12,
          right: 12,
          child: Row(
            children: [
              if (activity.nextSlot != null)
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _formatDateBadge(activity.nextSlot!.startDateTime),
                      style: TextStyle(
                        color: (isToday || isTomorrow)
                            ? const Color(0xFFFF601F)
                            : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                const Expanded(flex: 4, child: SizedBox.shrink()),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FavoriteButton(
                    event: _activityToEvent(),
                    iconSize: 18,
                    containerSize: 32,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom-left: Category Badge
        if (activity.category != null)
          Positioned(
            bottom: 12,
            left: 12,
            child: GestureDetector(
              onTap: () => context.push('/search?categorySlug=${activity.category!.slug}'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  activity.category!.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContentSection({required bool compact}) {
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
          // Title
          Text(
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

            // Location
            Text(
              activity.city?.name ?? activity.city?.region ?? 'France',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                height: 1.1,
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

  String _formatDateBadge(DateTime dt) {
    final time =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    if (isToday) {
      return 'Aujourd\'hui à $time';
    }
    if (isTomorrow) {
      return 'Demain à $time';
    }
    return _formatSlotDateTime(dt);
  }

}

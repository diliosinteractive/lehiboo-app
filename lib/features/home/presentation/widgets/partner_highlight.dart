import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lehiboo/domain/entities/activity.dart';
import 'package:lehiboo/features/home/presentation/providers/home_providers.dart';

/// Configuration d'un partenaire premium
class PartnerConfig {
  final String id;
  final String name;
  final String logoUrl;
  final String? tagline;
  final Color brandColor;
  final String? backgroundImageUrl;

  const PartnerConfig({
    required this.id,
    required this.name,
    required this.logoUrl,
    this.tagline,
    this.brandColor = const Color(0xFFFF601F),
    this.backgroundImageUrl,
  });

  /// Mock partner for testing
  static PartnerConfig mock() => const PartnerConfig(
        id: 'fnac_1',
        name: 'FNAC Spectacles',
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/FNAC_Logo.svg/320px-FNAC_Logo.svg.png',
        tagline: 'La sélection FNAC',
        brandColor: Color(0xFFE1A100), // FNAC yellow
        backgroundImageUrl: 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800',
      );
}

/// Section de mise en avant d'un partenaire premium
class PartnerHighlight extends ConsumerWidget {
  final PartnerConfig config;

  const PartnerHighlight({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In real app, fetch partner events from API
    // For now, use featured activities as mock
    final activitiesAsync = ref.watch(featuredActivitiesProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            config.brandColor.withValues(alpha:0.15),
            config.brandColor.withValues(alpha:0.05),
          ],
        ),
        border: Border.all(
          color: config.brandColor.withValues(alpha:0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with partner info
          _buildHeader(),

          // Partner events carousel
          activitiesAsync.when(
            data: (activities) {
              if (activities.isEmpty) return const SizedBox.shrink();

              // Take first 5 for partner section
              final partnerEvents = activities.take(5).toList();

              return SizedBox(
                height: 280,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: partnerEvents.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final activity = partnerEvents[index];
                    return SizedBox(
                      width: 180,
                      child: _PartnerEventCard(
                        activity: activity,
                        brandColor: config.brandColor,
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const SizedBox(
              height: 280,
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFFF601F)),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // "Voir toute la sélection" button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Center(
              child: TextButton(
                onPressed: () => context.push('/events?partner=${config.id}'),
                style: TextButton.styleFrom(
                  foregroundColor: config.brandColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                    side: BorderSide(color: config.brandColor.withValues(alpha:0.3)),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Voir toute la sélection',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: config.brandColor,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16, color: config.brandColor),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Partner logo
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CachedNetworkImage(
              imageUrl: config.logoUrl,
              fit: BoxFit.contain,
              placeholder: (context, url) => const CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFFF601F),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.business,
                color: config.brandColor,
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Partner name and tagline
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (config.tagline != null)
                  Text(
                    config.tagline!,
                    style: TextStyle(
                      color: config.brandColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                const SizedBox(height: 2),
                Text(
                  config.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
          ),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: config.brandColor.withValues(alpha:0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified,
                  color: config.brandColor,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Partenaire',
                  style: TextStyle(
                    color: config.brandColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Carte événement stylisée pour la section partenaire
class _PartnerEventCard extends StatelessWidget {
  final Activity activity;
  final Color brandColor;

  const _PartnerEventCard({
    required this.activity,
    required this.brandColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/event/${activity.id}', extra: activity),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: activity.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: activity.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                            ),
                            errorWidget: (context, url, error) => _buildFallback(),
                          )
                        : _buildFallback(),
                  ),
                ),

                // Brand accent line at top
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: brandColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      activity.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            activity.city?.name ?? 'France',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Price
                    if (activity.priceMin != null && activity.priceMin != -1)
                      Text(
                        activity.priceMin == 0
                            ? 'Gratuit'
                            : 'Dès ${activity.priceMin!.toStringAsFixed(0)}€',
                        style: TextStyle(
                          color: activity.priceMin == 0 ? Colors.green[700] : brandColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildFallback() {
    return Container(
      color: brandColor.withValues(alpha:0.2),
      child: Center(
        child: Icon(
          Icons.event,
          color: brandColor,
          size: 32,
        ),
      ),
    );
  }
}

/// Section partenaire dans la home (avec mock data)
class PartnerHighlightSection extends StatelessWidget {
  const PartnerHighlightSection({super.key});

  @override
  Widget build(BuildContext context) {
    // In real app, fetch partner config from mobileAppConfigProvider
    // For now, show mock partner
    return PartnerHighlight(config: PartnerConfig.mock());
  }
}

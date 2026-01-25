import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

/// Configuration d'une pub native
class NativeAdConfig {
  final String id;
  final String imageUrl;
  final String title;
  final String? subtitle;
  final String sponsorName;
  final String? sponsorLogo;
  final String ctaText;
  final String targetUrl;
  final String? trackingPixelUrl;

  const NativeAdConfig({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    required this.sponsorName,
    this.sponsorLogo,
    this.ctaText = 'En savoir plus',
    required this.targetUrl,
    this.trackingPixelUrl,
  });

  /// Mock ad for testing
  static NativeAdConfig mock() => const NativeAdConfig(
        id: 'mock_ad_1',
        imageUrl: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600',
        title: 'Festival d\'été 2026',
        subtitle: 'Les meilleurs concerts de la saison',
        sponsorName: 'FNAC Spectacles',
        ctaText: 'Réserver',
        targetUrl: 'https://www.fnacspectacles.com',
      );
}

/// Carte publicitaire native intégrée au feed
/// Design similaire aux EventCard mais avec badge "Sponsorisé"
class NativeAdCard extends ConsumerStatefulWidget {
  final NativeAdConfig config;
  final bool fullWidth;

  const NativeAdCard({
    super.key,
    required this.config,
    this.fullWidth = true,
  });

  @override
  ConsumerState<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends ConsumerState<NativeAdCard> {
  bool _impressionTracked = false;

  @override
  void initState() {
    super.initState();
    // Track impression on first render
    _trackImpression();
  }

  void _trackImpression() {
    if (_impressionTracked) return;
    _impressionTracked = true;

    // Track impression (in real app, send to analytics)
    debugPrint('[NativeAd] Impression tracked: ${widget.config.id}');

    // Fire tracking pixel if available
    if (widget.config.trackingPixelUrl != null) {
      // In real app: http request to tracking URL
    }
  }

  void _trackClick() {
    debugPrint('[NativeAd] Click tracked: ${widget.config.id}');
    // In real app: send click event to analytics
  }

  Future<void> _openTargetUrl() async {
    _trackClick();

    final uri = Uri.parse(widget.config.targetUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openTargetUrl,
      child: Container(
        width: widget.fullWidth ? double.infinity : 280,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image with badges
            Stack(
              children: [
                // Main image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: widget.config.imageUrl,
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
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                ),

                // "Sponsorisé" badge (top right)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          color: Colors.white.withOpacity(0.9),
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Sponsorisé',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sponsor logo (bottom left)
                if (widget.config.sponsorLogo != null)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: widget.config.sponsorLogo!,
                        width: 40,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sponsor name
                  Text(
                    widget.config.sponsorName,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Title
                  Text(
                    widget.config.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (widget.config.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.config.subtitle!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 12),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _openTargetUrl,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF601F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.config.ctaText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section de pub native dans le feed
class NativeAdSection extends StatelessWidget {
  const NativeAdSection({super.key});

  @override
  Widget build(BuildContext context) {
    // In real app, fetch ad config from mobileAppConfigProvider
    // For now, show mock if ads are enabled

    return Column(
      children: [
        const SizedBox(height: 8),
        NativeAdCard(config: NativeAdConfig.mock()),
        const SizedBox(height: 8),
      ],
    );
  }
}

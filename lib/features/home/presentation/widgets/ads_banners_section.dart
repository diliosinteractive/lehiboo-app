import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/models/mobile_app_config.dart';
import '../providers/home_providers.dart';

/// Section displaying advertising banners from WordPress admin config
class AdsBannersSection extends ConsumerWidget {
  const AdsBannersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configAsyncValue = ref.watch(mobileAppConfigProvider);

    return configAsyncValue.when(
      data: (config) {
        // Don't show if ads are disabled or no banners
        if (!config.ads.enabled || config.ads.banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Offres et bons plans',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Horizontal scroll for multiple banners
            if (config.ads.banners.length > 1)
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: config.ads.banners.length,
                  itemBuilder: (context, index) {
                    final banner = config.ads.banners[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < config.ads.banners.length - 1 ? 12 : 0,
                      ),
                      child: _BannerCard(banner: banner),
                    );
                  },
                ),
              )
            else
              // Single banner - full width
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _BannerCard(
                  banner: config.ads.banners.first,
                  fullWidth: true,
                ),
              ),
            const SizedBox(height: 24),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final AdBanner banner;
  final bool fullWidth;

  const _BannerCard({
    required this.banner,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchUrl(banner.url),
      child: Container(
        width: fullWidth ? double.infinity : 280,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: banner.image.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: banner.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF6B35),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => _buildPlaceholder(),
                )
              : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFF6B35),
            const Color(0xFFFF6B35).withOpacity(0.7),
          ],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(height: 8),
            Text(
              'Offre spéciale',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;

    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

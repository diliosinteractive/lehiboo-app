import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/themes/colors.dart';

/// Galerie d'images style Airbnb avec format 9/16
///
/// Layout:
/// ┌──────────┬─────┬─────┐
/// │          │  2  │  3  │
/// │    1     ├─────┼─────┤
/// │  (main)  │  4  │ +X  │
/// └──────────┴─────┴─────┘
class EventGalleryGrid extends StatelessWidget {
  final List<String> images;
  final VoidCallback? onViewAll;
  final Function(int index)? onImageTap;
  final double? height;

  /// Aspect ratio 9:16 pour format portrait
  static const double aspectRatio = 9 / 16;

  const EventGalleryGrid({
    super.key,
    required this.images,
    this.onViewAll,
    this.onImageTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return _buildPlaceholder(context);
    }

    // Hauteur calculée pour maintenir le ratio 9/16 sur l'image principale
    final screenWidth = MediaQuery.of(context).size.width;
    final mainImageWidth = screenWidth * 0.6;
    final calculatedHeight = height ?? mainImageWidth / aspectRatio;

    return Column(
      children: [
        SizedBox(
          height: calculatedHeight.clamp(200.0, 400.0),
          child: Row(
            children: [
              // Image principale (60% de la largeur)
              Expanded(
                flex: 6,
                child: _buildMainImage(context),
              ),
              const SizedBox(width: 2),
              // Grille de thumbnails (40% de la largeur)
              if (images.length > 1)
                Expanded(
                  flex: 4,
                  child: _buildThumbnailGrid(context),
                ),
            ],
          ),
        ),
        // Bouton "Voir toutes les photos"
        if (images.length > 5 && onViewAll != null)
          _buildViewAllButton(context),
      ],
    );
  }

  Widget _buildMainImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onImageTap?.call(0);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          bottomLeft: Radius.circular(0),
        ),
        child: _buildCachedImage(images.first),
      ),
    );
  }

  Widget _buildThumbnailGrid(BuildContext context) {
    final thumbnails = images.skip(1).take(4).toList();
    final remainingCount = images.length - 5;

    return Column(
      children: [
        // Ligne du haut (images 2 et 3)
        Expanded(
          child: Row(
            children: [
              if (thumbnails.isNotEmpty)
                Expanded(child: _buildThumbnail(context, thumbnails[0], 1)),
              if (thumbnails.length > 1) ...[
                const SizedBox(width: 2),
                Expanded(child: _buildThumbnail(context, thumbnails[1], 2)),
              ],
            ],
          ),
        ),
        const SizedBox(height: 2),
        // Ligne du bas (images 4 et 5 avec badge)
        Expanded(
          child: Row(
            children: [
              if (thumbnails.length > 2)
                Expanded(child: _buildThumbnail(context, thumbnails[2], 3)),
              if (thumbnails.length > 3) ...[
                const SizedBox(width: 2),
                Expanded(
                  child: _buildThumbnailWithBadge(
                    context,
                    thumbnails[3],
                    4,
                    remainingCount,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(BuildContext context, String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onImageTap?.call(index);
      },
      child: _buildCachedImage(imageUrl),
    );
  }

  Widget _buildThumbnailWithBadge(
    BuildContext context,
    String imageUrl,
    int index,
    int remainingCount,
  ) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        if (remainingCount > 0) {
          onViewAll?.call();
        } else {
          onImageTap?.call(index);
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildCachedImage(imageUrl),
          // Badge "+X photos" si plus de 5 images
          if (remainingCount > 0)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.photo_library_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+$remainingCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: OutlinedButton.icon(
        onPressed: () {
          HapticFeedback.lightImpact();
          onViewAll?.call();
        },
        icon: const Icon(Icons.photo_library_outlined, size: 18),
        label: Text('Voir toutes les photos (${images.length})'),
        style: OutlinedButton.styleFrom(
          foregroundColor: HbColors.textPrimary,
          side: BorderSide(color: Colors.grey.shade300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildCachedImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey.shade200,
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: HbColors.brandPrimary,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade200,
        child: const Icon(
          Icons.broken_image_outlined,
          color: Colors.grey,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      height: 250,
      color: Colors.grey.shade200,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_outlined,
              color: Colors.grey,
              size: 48,
            ),
            SizedBox(height: 8),
            Text(
              'Aucune image',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/// Version simplifiée avec une seule image (fallback)
class EventGallerySingle extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const EventGallerySingle({
    super.key,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: CircularProgressIndicator(
                color: HbColors.brandPrimary,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image_outlined, size: 48),
          ),
        ),
      ),
    );
  }
}

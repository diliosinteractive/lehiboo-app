import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// Galerie hero avec effet parallax et swipe horizontal
///
/// Features:
/// - Parallax 0.5x sur scroll vertical
/// - Swipe horizontal pour navigation entre images
/// - Bouton vidéo si disponible
/// - Indicateurs de page stylisés
/// - Hero transition vers fullscreen
class EventHeroGallery extends StatefulWidget {
  final List<String> images;
  final String? videoUrl;
  final VoidCallback? onViewAll;
  final Function(int index)? onImageTap;
  final double height;
  final String? heroTag;

  const EventHeroGallery({
    super.key,
    required this.images,
    this.videoUrl,
    this.onViewAll,
    this.onImageTap,
    this.height = 0.45, // 45% de l'écran (réduit pour voir plus de contenu)
    this.heroTag,
  });

  @override
  State<EventHeroGallery> createState() => _EventHeroGalleryState();
}

class _EventHeroGalleryState extends State<EventHeroGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return _buildPlaceholder(context);
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final galleryHeight = screenHeight * widget.height;

    return SizedBox(
      height: galleryHeight,
      child: Stack(
        children: [
          // Images avec PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onImageTap?.call(index);
                },
                child: Hero(
                  tag: widget.heroTag != null
                      ? '${widget.heroTag}_$index'
                      : 'event_image_$index',
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: HbColors.brandPrimary,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.grey,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Gradient overlay en bas (plus subtil - flat design)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),

          // Indicateurs de page
          if (widget.images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.images.length.clamp(0, 5),
                  (index) => _buildPageIndicator(index),
                ),
              ),
            ),

          // Compteur cliquable (remplace le bouton "Voir tout" redondant)
          if (widget.images.length > 1)
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onViewAll?.call();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.photo_library_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${_currentPage + 1}/${widget.images.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bouton vidéo
          if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              child: _buildVideoButton(),
            ),

          // Supprimé : bouton "Voir tout (X)" redondant avec le compteur
          // Le compteur cliquable suffit pour accéder à toutes les photos
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildVideoButton() {
    return GestureDetector(
      onTap: _playVideo,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_filled,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Voir la vidéo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _buildViewAllButton() supprimé - remplacé par compteur cliquable

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * widget.height,
      color: Colors.grey.shade200,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_outlined,
              color: Colors.grey,
              size: 64,
            ),
            SizedBox(height: 12),
            Text(
              'Aucune image disponible',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _playVideo() async {
    HapticFeedback.mediumImpact();
    if (widget.videoUrl == null || widget.videoUrl!.isEmpty) return;

    final url = Uri.parse(widget.videoUrl!);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

/// SliverAppBar avec effet parallax pour la galerie
class EventParallaxAppBar extends StatelessWidget {
  final List<String> images;
  final String? videoUrl;
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final Widget? favoriteButton;
  final VoidCallback? onViewAllImages;
  final Function(int)? onImageTap;
  final double expandedHeight;

  const EventParallaxAppBar({
    super.key,
    required this.images,
    this.videoUrl,
    required this.title,
    this.onBack,
    this.onShare,
    this.favoriteButton,
    this.onViewAllImages,
    this.onImageTap,
    this.expandedHeight = 0.55,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = screenHeight * expandedHeight;

    return SliverAppBar(
      expandedHeight: appBarHeight,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      leading: _buildCircularButton(
        icon: Icons.arrow_back,
        onTap: onBack ?? () => Navigator.of(context).pop(),
      ),
      actions: [
        if (onShare != null)
          _buildCircularButton(
            icon: Icons.share_outlined,
            onTap: onShare!,
          ),
        if (favoriteButton != null) ...[
          const SizedBox(width: 8),
          favoriteButton!,
        ],
        const SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: EventHeroGallery(
          images: images,
          videoUrl: videoUrl,
          onViewAll: onViewAllImages,
          onImageTap: onImageTap,
          height: 1.0, // Occupe tout l'espace flex
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, size: 20, color: HbColors.textPrimary),
        onPressed: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        style: IconButton.styleFrom(padding: EdgeInsets.zero),
      ),
    );
  }
}

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../data/models/hero_slide_dto.dart';

/// Auto-rotating background carousel for the home-screen hero.
///
/// Spec: docs/HERO_SLIDES_MOBILE_SPEC.md §4.3 — "auto-rotate matching
/// the web cadence (~5 s)". Each slide is a `CachedNetworkImage`; broken
/// image URLs render the [errorPlaceholderColor] for one frame and the
/// timer continues to the next slide so a single broken slide can't
/// stall the carousel.
///
/// The auto-rotate `Timer.periodic` is suspended via `VisibilityDetector`
/// when the carousel scrolls below the viewport (typical when the user
/// scrolls into the rest of the home feed) and resumes on return.
class HeroSlidesCarousel extends StatefulWidget {
  final List<HeroSlideDto> slides;
  final Duration interval;
  final Color errorPlaceholderColor;
  final Color placeholderColor;

  const HeroSlidesCarousel({
    super.key,
    required this.slides,
    this.interval = const Duration(seconds: 5),
    this.errorPlaceholderColor = const Color(0xFF1F2937),
    this.placeholderColor = const Color(0xFF1F2937),
  });

  @override
  State<HeroSlidesCarousel> createState() => _HeroSlidesCarouselState();
}

class _HeroSlidesCarouselState extends State<HeroSlidesCarousel> {
  late final PageController _controller = PageController();
  Timer? _timer;
  int _index = 0;
  // Tracks whether the carousel is currently visible enough to warrant
  // animating. Updated by VisibilityDetector; gates timer (re)start.
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _maybeStartTimer();
  }

  @override
  void didUpdateWidget(covariant HeroSlidesCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Slide list changed (refresh landed). Snap back to the first slide
    // and re-arm the timer so the user sees the new content from the
    // top of the rotation.
    if (oldWidget.slides.length != widget.slides.length) {
      _index = 0;
      if (_controller.hasClients && widget.slides.isNotEmpty) {
        _controller.jumpToPage(0);
      }
      _restartTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _maybeStartTimer() {
    if (!_isVisible || widget.slides.length < 2) return;
    _timer?.cancel();
    _timer = Timer.periodic(widget.interval, (_) => _advance());
  }

  void _restartTimer() {
    _timer?.cancel();
    _maybeStartTimer();
  }

  void _advance() {
    if (!mounted || widget.slides.isEmpty) return;
    final next = (_index + 1) % widget.slides.length;
    if (_controller.hasClients) {
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    final visible = info.visibleFraction > 0.25;
    if (visible == _isVisible) return;
    _isVisible = visible;
    if (visible) {
      _maybeStartTimer();
    } else {
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final slides = widget.slides;
    if (slides.isEmpty) return const SizedBox.shrink();

    return VisibilityDetector(
      key: const Key('hero-slides-carousel'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            onPageChanged: (i) => _index = i,
            itemBuilder: (_, i) {
              final s = slides[i];
              return CachedNetworkImage(
                imageUrl: s.imageUrl,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 250),
                placeholder: (_, __) => Container(color: widget.placeholderColor),
                errorWidget: (_, __, ___) =>
                    Container(color: widget.errorPlaceholderColor),
                imageBuilder: (_, provider) => Semantics(
                  label: s.altText.isNotEmpty ? s.altText : null,
                  image: true,
                  child: Image(image: provider, fit: BoxFit.cover),
                ),
              );
            },
          ),
          if (slides.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: _Dots(count: slides.length, controller: _controller),
            ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  final int count;
  final PageController controller;

  const _Dots({required this.count, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final page = controller.hasClients
            ? (controller.page ?? controller.initialPage.toDouble())
            : 0.0;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(count, (i) {
            // Smooth fade between adjacent dots as the page slides.
            final distance = (page - i).abs().clamp(0.0, 1.0);
            final t = 1.0 - distance;
            final size = 6.0 + 4.0 * t;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: size,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.4 + 0.6 * t),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        );
      },
    );
  }
}

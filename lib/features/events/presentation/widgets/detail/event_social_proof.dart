import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/shared/widgets/animations/pulse_animation.dart';

/// Widget "X personnes regardent cet événement" avec animation
///
/// Features:
/// - Animation pulse sur l'icône
/// - Nombre animé qui change
/// - Style discret mais engageant
class EventSocialProof extends StatefulWidget {
  final int viewersCount;
  final bool animate;
  final bool showIcon;

  const EventSocialProof({
    super.key,
    required this.viewersCount,
    this.animate = true,
    this.showIcon = true,
  });

  @override
  State<EventSocialProof> createState() => _EventSocialProofState();
}

class _EventSocialProofState extends State<EventSocialProof>
    with SingleTickerProviderStateMixin {
  late int _displayCount;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Ajouter une variation aléatoire pour paraître plus réel
    _displayCount = _getRealisticCount();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    if (widget.animate) {
      _controller.repeat();
      _controller.addListener(_updateCount);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateCount);
    _controller.dispose();
    super.dispose();
  }

  void _updateCount() {
    // Changer le compte occasionnellement pour l'effet "live"
    if (_controller.value > 0.5 && _controller.value < 0.52) {
      setState(() {
        _displayCount = _getRealisticCount();
      });
    }
  }

  int _getRealisticCount() {
    final base = widget.viewersCount;
    if (base <= 0) return math.Random().nextInt(5) + 2;
    // Variation de ±20%
    final variation = (base * 0.2).toInt();
    return base + math.Random().nextInt(variation * 2 + 1) - variation;
  }

  @override
  Widget build(BuildContext context) {
    if (_displayCount <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: HbColors.brandPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: HbColors.brandPrimary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showIcon) ...[
            PulseAnimation(
              duration: const Duration(milliseconds: 1500),
              minScale: 0.9,
              maxScale: 1.1,
              child: Icon(
                Icons.remove_red_eye_outlined,
                color: HbColors.brandPrimary,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            '$_displayCount personnes regardent',
            style: const TextStyle(
              color: HbColors.brandPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget badges Featured/Recommended avec animation shine
class EventBadges extends StatelessWidget {
  final bool isFeatured;
  final bool isRecommended;
  final bool isNew;

  const EventBadges({
    super.key,
    this.isFeatured = false,
    this.isRecommended = false,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isFeatured && !isRecommended && !isNew) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (isFeatured)
          _AnimatedBadge(
            label: 'En vedette',
            icon: Icons.star,
            color: const Color(0xFFFFB800),
            backgroundColor: const Color(0xFFFFF8E1),
          ),
        if (isRecommended)
          _AnimatedBadge(
            label: 'Recommandé',
            icon: Icons.thumb_up,
            color: const Color(0xFF4CAF50),
            backgroundColor: const Color(0xFFE8F5E9),
          ),
        if (isNew)
          _AnimatedBadge(
            label: 'Nouveau',
            icon: Icons.fiber_new,
            color: const Color(0xFF2196F3),
            backgroundColor: const Color(0xFFE3F2FD),
          ),
      ],
    );
  }
}

class _AnimatedBadge extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const _AnimatedBadge({
    required this.label,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  @override
  State<_AnimatedBadge> createState() => _AnimatedBadgeState();
}

class _AnimatedBadgeState extends State<_AnimatedBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _shineAnimation = Tween<double>(
      begin: -0.5,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _shineController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shineAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.color.withValues(alpha: 0.3),
            ),
          ),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  (_shineAnimation.value - 0.3).clamp(0.0, 1.0),
                  _shineAnimation.value.clamp(0.0, 1.0),
                  (_shineAnimation.value + 0.3).clamp(0.0, 1.0),
                ],
                colors: [
                  widget.color,
                  widget.color.withValues(alpha: 0.4),
                  widget.color,
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcIn,
            child: child,
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 14, color: widget.color),
          const SizedBox(width: 4),
          Text(
            widget.label,
            style: TextStyle(
              color: widget.color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget pour afficher le prix de manière prominente
///
/// Flat design : prix très lisible en gris800, format "À partir de X€"
class EventPriceDisplay extends StatelessWidget {
  final double? minPrice;
  final double? maxPrice;
  final bool isFree;
  final bool large;

  const EventPriceDisplay({
    super.key,
    this.minPrice,
    this.maxPrice,
    this.isFree = false,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isFree) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.green.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: const Text(
          'Gratuit',
          style: TextStyle(
            color: Colors.green,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    // Flat design : texte lisible sans background trop saturé
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'À partir de ',
            style: TextStyle(
              fontSize: large ? 14 : 12,
              color: HbColors.grey500,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: _formatMainPrice(),
            style: TextStyle(
              fontSize: large ? 28 : 22,
              fontWeight: FontWeight.w700,
              color: HbColors.grey800,
            ),
          ),
        ],
      ),
    );
  }

  String _formatMainPrice() {
    final price = minPrice ?? maxPrice ?? 0;
    if (price == price.roundToDouble()) {
      return '${price.toInt()}€';
    }
    return '${price.toStringAsFixed(2)}€';
  }
}

/// Widget pour afficher la durée avec icône
class EventDurationChip extends StatelessWidget {
  final Duration? duration;
  final bool compact;

  const EventDurationChip({
    super.key,
    this.duration,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (duration == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: Colors.purple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(compact ? 6 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            size: compact ? 12 : 14,
            color: Colors.purple,
          ),
          const SizedBox(width: 4),
          Text(
            _formatDuration(),
            style: TextStyle(
              color: Colors.purple,
              fontSize: compact ? 11 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration() {
    if (duration == null) return '';
    final hours = duration!.inHours;
    final minutes = duration!.inMinutes.remainder(60);

    if (hours > 0 && minutes > 0) {
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    } else if (hours > 0) {
      return '${hours}h';
    }
    return '${minutes}min';
  }
}

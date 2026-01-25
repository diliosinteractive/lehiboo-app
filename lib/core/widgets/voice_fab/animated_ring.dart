import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Anneau gradient tournant pour le VoiceFab pendant l'écoute
/// Style inspiré des stories Instagram
class AnimatedGradientRing extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final double gap;
  final bool isAnimating;
  final Widget child;

  const AnimatedGradientRing({
    super.key,
    required this.size,
    this.strokeWidth = 4,
    this.gap = 6,
    required this.isAnimating,
    required this.child,
  });

  @override
  State<AnimatedGradientRing> createState() => _AnimatedGradientRingState();
}

class _AnimatedGradientRingState extends State<AnimatedGradientRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedGradientRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _controller.repeat();
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Anneau gradient animé
          if (widget.isAnimating)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _GradientRingPainter(
                    rotation: _controller.value * 2 * math.pi,
                    strokeWidth: widget.strokeWidth,
                    gap: widget.gap,
                  ),
                );
              },
            ),
          // Contenu central
          widget.child,
        ],
      ),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  final double rotation;
  final double strokeWidth;
  final double gap;

  _GradientRingPainter({
    required this.rotation,
    required this.strokeWidth,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth / 2);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: rotation,
        colors: const [
          Color(0xFFFF601F), // Orange Le Hiboo
          Color(0xFFFF8B5A), // Orange clair
          Color(0xFFFFB347), // Orange pastel
          Color(0xFFFF8B5A), // Orange clair
          Color(0xFFFF601F), // Orange Le Hiboo
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_GradientRingPainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}

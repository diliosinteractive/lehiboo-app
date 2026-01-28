import 'package:flutter/material.dart';

/// Widget réutilisable pour créer un effet de pulsation
///
/// Utilisation:
/// ```dart
/// PulseAnimation(
///   child: Icon(Icons.favorite, color: Colors.red),
/// )
/// ```
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool repeat;
  final bool autoStart;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.minScale = 1.0,
    this.maxScale = 1.1,
    this.repeat = true,
    this.autoStart = true,
  });

  @override
  State<PulseAnimation> createState() => PulseAnimationState();
}

class PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.autoStart) {
      if (widget.repeat) {
        _controller.repeat(reverse: true);
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void start() {
    if (widget.repeat) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
  }

  void stop() {
    _controller.stop();
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Widget pour un effet de pulsation d'opacité (fade in/out)
class OpacityPulse extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;
  final bool repeat;

  const OpacityPulse({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minOpacity = 0.5,
    this.maxOpacity = 1.0,
    this.repeat = true,
  });

  @override
  State<OpacityPulse> createState() => _OpacityPulseState();
}

class _OpacityPulseState extends State<OpacityPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _opacityAnimation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.repeat) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: widget.child,
    );
  }
}

/// Widget pour un effet de pulsation avec glow
class GlowPulse extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final Duration duration;
  final double maxBlur;
  final double minBlur;

  const GlowPulse({
    super.key,
    required this.child,
    required this.glowColor,
    this.duration = const Duration(milliseconds: 2000),
    this.maxBlur = 20.0,
    this.minBlur = 5.0,
  });

  @override
  State<GlowPulse> createState() => _GlowPulseState();
}

class _GlowPulseState extends State<GlowPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _blurAnimation = Tween<double>(
      begin: widget.minBlur,
      end: widget.maxBlur,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _blurAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: 0.5),
                blurRadius: _blurAnimation.value,
                spreadRadius: 2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

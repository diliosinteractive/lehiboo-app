import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bouton avec animation spring bounce au tap
///
/// Utilisation:
/// ```dart
/// SpringButton(
///   onTap: () => print('Tapped!'),
///   child: Container(
///     padding: EdgeInsets.all(16),
///     decoration: BoxDecoration(
///       color: Colors.orange,
///       borderRadius: BorderRadius.circular(12),
///     ),
///     child: Text('Press me'),
///   ),
/// )
/// ```
class SpringButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleDown;
  final Duration duration;
  final Curve curve;
  final bool enableHaptic;
  final bool enabled;

  const SpringButton({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleDown = 0.95,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.easeOutBack,
    this.enableHaptic = true,
    this.enabled = true,
  });

  @override
  State<SpringButton> createState() => _SpringButtonState();
}

class _SpringButtonState extends State<SpringButton>
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
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.enabled) return;
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.enabled) return;
    _controller.reverse();
  }

  void _onTapCancel() {
    if (!widget.enabled) return;
    _controller.reverse();
  }

  void _onTap() {
    if (!widget.enabled) return;
    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      onLongPress: widget.enabled ? widget.onLongPress : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Bouton avec animation bounce plus prononcée (style Material Expressive)
class BounceButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double bounceScale;
  final Duration duration;
  final bool enableHaptic;
  final bool enabled;

  const BounceButton({
    super.key,
    required this.child,
    this.onTap,
    this.bounceScale = 1.08,
    this.duration = const Duration(milliseconds: 200),
    this.enableHaptic = true,
    this.enabled = true,
  });

  @override
  State<BounceButton> createState() => _BounceButtonState();
}

class _BounceButtonState extends State<BounceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: widget.bounceScale)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.bounceScale, end: 1.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (!widget.enabled) return;
    if (widget.enableHaptic) {
      HapticFeedback.mediumImpact();
    }
    _controller.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Widget pour un effet shake (erreur/attention)
class ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double shakeOffset;
  final int shakeCount;

  const ShakeWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.shakeOffset = 10.0,
    this.shakeCount = 3,
  });

  @override
  State<ShakeWidget> createState() => ShakeWidgetState();
}

class ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void shake() {
    HapticFeedback.heavyImpact();
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final sineValue = _shakeAnimation.value * widget.shakeCount * 2 * 3.14159;
        final offset = widget.shakeOffset *
            (1 - _shakeAnimation.value) *
            (sineValue == 0 ? 0 : (sineValue.isNaN ? 0 : _sin(sineValue)));
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  double _sin(double x) {
    // Simple sine approximation
    x = x % (2 * 3.14159);
    if (x > 3.14159) x -= 2 * 3.14159;
    return x - (x * x * x / 6) + (x * x * x * x * x / 120);
  }
}

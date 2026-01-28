import 'package:flutter/material.dart';

/// Widget pour créer des animations staggered (décalées) sur une liste d'éléments
///
/// Utilisation:
/// ```dart
/// StaggeredList(
///   children: [
///     Text('Item 1'),
///     Text('Item 2'),
///     Text('Item 3'),
///   ],
/// )
/// ```
class StaggeredList extends StatefulWidget {
  final List<Widget> children;
  final Duration itemDelay;
  final Duration itemDuration;
  final Curve curve;
  final Axis direction;
  final double slideOffset;
  final bool fadeIn;

  const StaggeredList({
    super.key,
    required this.children,
    this.itemDelay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutBack,
    this.direction = Axis.horizontal,
    this.slideOffset = 20.0,
    this.fadeIn = true,
  });

  @override
  State<StaggeredList> createState() => _StaggeredListState();
}

class _StaggeredListState extends State<StaggeredList>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        vsync: this,
        duration: widget.itemDuration,
      ),
    );

    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ));
    }).toList();

    _slideAnimations = _controllers.map((controller) {
      final offset = widget.direction == Axis.horizontal
          ? Offset(widget.slideOffset, 0)
          : Offset(0, widget.slideOffset);
      return Tween<Offset>(
        begin: offset,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ));
    }).toList();

    // Start staggered animations
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(widget.itemDelay);
      if (mounted) {
        _controllers[i].forward();
      }
    }
  }

  @override
  void didUpdateWidget(StaggeredList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      for (final controller in _controllers) {
        controller.dispose();
      }
      _initAnimations();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(widget.children.length, (index) {
        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return Transform.translate(
              offset: _slideAnimations[index].value,
              child: widget.fadeIn
                  ? Opacity(
                      opacity: _fadeAnimations[index].value,
                      child: child,
                    )
                  : child,
            );
          },
          child: widget.children[index],
        );
      }),
    );
  }
}

/// Widget individuel avec animation staggered (contrôlée manuellement)
class StaggeredItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double slideOffset;
  final Axis slideDirection;
  final bool fadeIn;
  final bool autoStart;

  const StaggeredItem({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 50),
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutBack,
    this.slideOffset = 20.0,
    this.slideDirection = Axis.vertical,
    this.fadeIn = true,
    this.autoStart = true,
  });

  @override
  State<StaggeredItem> createState() => _StaggeredItemState();
}

class _StaggeredItemState extends State<StaggeredItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<double>(
      begin: widget.slideOffset,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.autoStart) {
      _startWithDelay();
    }
  }

  Future<void> _startWithDelay() async {
    await Future.delayed(widget.delay * widget.index);
    if (mounted) {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = widget.slideDirection == Axis.horizontal
            ? Offset(_slideAnimation.value, 0)
            : Offset(0, _slideAnimation.value);

        Widget result = Transform.translate(
          offset: offset,
          child: child,
        );

        if (widget.fadeIn) {
          result = Opacity(
            opacity: _fadeAnimation.value,
            child: result,
          );
        }

        return result;
      },
      child: widget.child,
    );
  }
}

/// Helper pour créer une colonne avec animation staggered
class StaggeredColumn extends StatelessWidget {
  final List<Widget> children;
  final Duration itemDelay;
  final Duration itemDuration;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const StaggeredColumn({
    super.key,
    required this.children,
    this.itemDelay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 300),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: List.generate(children.length, (index) {
        return StaggeredItem(
          index: index,
          delay: itemDelay,
          duration: itemDuration,
          slideDirection: Axis.vertical,
          child: children[index],
        );
      }),
    );
  }
}

/// Animation de badge avec shine effect
class ShineAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color shineColor;
  final double shineWidth;

  const ShineAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.shineColor = Colors.white,
    this.shineWidth = 50.0,
  });

  @override
  State<ShineAnimation> createState() => _ShineAnimationState();
}

class _ShineAnimationState extends State<ShineAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _shineAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
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
      animation: _shineAnimation,
      builder: (context, child) {
        return ShaderMask(
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
                Colors.transparent,
                widget.shineColor.withValues(alpha: 0.5),
                Colors.transparent,
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

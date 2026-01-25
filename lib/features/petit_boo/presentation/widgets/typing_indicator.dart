import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';

/// Animated typing indicator (three bouncing dots)
class TypingIndicator extends StatefulWidget {
  final Color? dotColor;
  final double dotSize;
  final Duration animationDuration;

  const TypingIndicator({
    super.key,
    this.dotColor,
    this.dotSize = 8,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (index) => AnimationController(
        vsync: this,
        duration: widget.animationDuration,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: -8).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start animations with staggered delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
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
    final color = widget.dotColor ?? HbColors.brandPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animations[index].value),
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  margin: EdgeInsets.only(
                    right: index < 2 ? 4 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

/// Typing indicator with Petit Boo avatar
class PetitBooTypingIndicator extends StatelessWidget {
  const PetitBooTypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: HbColors.brandPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: Text('🦉', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 8),
          // Typing dots
          const TypingIndicator(),
        ],
      ),
    );
  }
}

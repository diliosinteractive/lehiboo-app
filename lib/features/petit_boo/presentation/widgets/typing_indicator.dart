import 'package:flutter/material.dart';

import '../../../../core/themes/petit_boo_theme.dart';

/// Animated typing indicator (three bouncing dots)
class TypingIndicator extends StatefulWidget {
  final Color? dotColor;
  final double dotSize;
  final Duration animationDuration;

  const TypingIndicator({
    super.key,
    this.dotColor,
    this.dotSize = 10,
    this.animationDuration = const Duration(milliseconds: 400),
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
      return Tween<double>(begin: 0, end: -6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start animations with staggered delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
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
    final color = widget.dotColor ?? PetitBooTheme.grey400;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: PetitBooTheme.spacing20,
        vertical: PetitBooTheme.spacing16,
      ),
      decoration: PetitBooTheme.typingDecoration,
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
                    right: index < 2 ? PetitBooTheme.spacing6 : 0,
                  ),
                  decoration: BoxDecoration(
                    color: color,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Avatar
        Container(
          width: PetitBooTheme.avatarMd,
          height: PetitBooTheme.avatarMd,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PetitBooTheme.primaryLight,
          ),
          child: ClipOval(
            child: Image.asset(
              PetitBooTheme.owlLogoPath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.smart_toy_outlined,
                color: PetitBooTheme.primary,
                size: PetitBooTheme.iconMd,
              ),
            ),
          ),
        ),
        SizedBox(width: PetitBooTheme.spacing12),
        // Typing dots
        const TypingIndicator(),
      ],
    );
  }
}

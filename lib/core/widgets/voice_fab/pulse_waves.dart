import 'package:flutter/material.dart';

/// Ondes concentriques pulsantes pour le VoiceFab pendant l'écoute
/// 3 cercles qui pulsent avec un décalage de 500ms
class PulseWaves extends StatefulWidget {
  final double size;
  final bool isAnimating;
  final Color color;

  const PulseWaves({
    super.key,
    required this.size,
    required this.isAnimating,
    this.color = const Color(0xFFFF601F),
  });

  @override
  State<PulseWaves> createState() => _PulseWavesState();
}

class _PulseWavesState extends State<PulseWaves> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _opacityAnimations;

  static const int waveCount = 3;
  static const Duration waveDuration = Duration(milliseconds: 1500);
  static const Duration waveDelay = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _initAnimations();
    if (widget.isAnimating) {
      _startAnimations();
    }
  }

  void _initAnimations() {
    _controllers = List.generate(
      waveCount,
      (index) => AnimationController(
        vsync: this,
        duration: waveDuration,
      ),
    );

    _scaleAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 1.8).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();

    _opacityAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.4, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();
  }

  void _startAnimations() {
    for (int i = 0; i < waveCount; i++) {
      Future.delayed(waveDelay * i, () {
        if (mounted && widget.isAnimating) {
          _controllers[i].repeat();
        }
      });
    }
  }

  void _stopAnimations() {
    for (final controller in _controllers) {
      controller.stop();
      controller.reset();
    }
  }

  @override
  void didUpdateWidget(PulseWaves oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _startAnimations();
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _stopAnimations();
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
    if (!widget.isAnimating) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: widget.size * 1.8,
      height: widget.size * 1.8,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(waveCount, (index) {
          return AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimations[index].value,
                child: Opacity(
                  opacity: _opacityAnimations[index].value,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.color,
                        width: 2,
                      ),
                    ),
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

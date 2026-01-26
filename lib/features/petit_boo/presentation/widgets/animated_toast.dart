import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/themes/petit_boo_theme.dart';

/// Animated toast notification for Petit Boo actions
/// Shows a slide-in toast with icon bounce animation and auto-dismiss
class PetitBooToast extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color color;
  final Duration duration;
  final VoidCallback onDismiss;

  const PetitBooToast({
    super.key,
    required this.message,
    required this.icon,
    required this.color,
    this.duration = const Duration(seconds: 3),
    required this.onDismiss,
  });

  /// Show a toast notification
  static void show(
    BuildContext context, {
    required String message,
    required IconData icon,
    Color? color,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).padding.bottom + 100,
        left: PetitBooTheme.spacing16,
        right: PetitBooTheme.spacing16,
        child: PetitBooToast(
          message: message,
          icon: icon,
          color: color ?? PetitBooTheme.primary,
          duration: duration,
          onDismiss: () => entry.remove(),
        ),
      ),
    );

    overlay.insert(entry);
  }

  /// Toast de succès (vert avec check)
  static void success(BuildContext context, String message) {
    show(
      context,
      message: message,
      icon: Icons.check_circle,
      color: PetitBooTheme.success,
    );
  }

  /// Toast d'erreur (rouge)
  static void error(BuildContext context, String message) {
    show(
      context,
      message: message,
      icon: Icons.error,
      color: PetitBooTheme.error,
    );
  }

  /// Toast d'info (bleu)
  static void info(BuildContext context, String message) {
    show(
      context,
      message: message,
      icon: Icons.info,
      color: const Color(0xFF3498DB),
    );
  }

  /// Toast d'avertissement (orange)
  static void warning(BuildContext context, String message) {
    show(
      context,
      message: message,
      icon: Icons.warning,
      color: PetitBooTheme.warning,
    );
  }

  /// Toast favori ajouté (coeur rouge)
  static void favoriteAdded(BuildContext context, {String? eventTitle}) {
    show(
      context,
      message: eventTitle != null
          ? '"$eventTitle" ajouté aux favoris'
          : 'Ajouté aux favoris',
      icon: Icons.favorite,
      color: PetitBooTheme.error,
    );
  }

  /// Toast favori retiré (coeur gris)
  static void favoriteRemoved(BuildContext context) {
    show(
      context,
      message: 'Retiré des favoris',
      icon: Icons.favorite_border,
      color: PetitBooTheme.grey500,
    );
  }

  @override
  State<PetitBooToast> createState() => _PetitBooToastState();
}

class _PetitBooToastState extends State<PetitBooToast>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final AnimationController _iconController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _iconScaleAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();

    // Slide animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    // Icon bounce animation
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _iconScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.3),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 0.9),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.9, end: 1.0),
        weight: 40,
      ),
    ]).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _slideController.forward().then((_) {
      _iconController.forward();
    });

    // Auto-dismiss timer
    _dismissTimer = Timer(widget.duration, _dismiss);
  }

  void _dismiss() {
    _slideController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _slideController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: _dismiss,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: PetitBooTheme.spacing16,
              vertical: PetitBooTheme.spacing14,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: PetitBooTheme.borderRadiusXl,
              boxShadow: PetitBooTheme.shadowLg,
              border: Border.all(
                color: widget.color.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated icon in colored circle
                AnimatedBuilder(
                  animation: _iconScaleAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _iconScaleAnimation.value,
                    child: child,
                  ),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.color,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: PetitBooTheme.spacing12),

                // Message
                Flexible(
                  child: Text(
                    widget.message,
                    style: PetitBooTheme.bodySm.copyWith(
                      color: PetitBooTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(width: PetitBooTheme.spacing8),

                // Dismiss button
                GestureDetector(
                  onTap: _dismiss,
                  child: Icon(
                    Icons.close,
                    color: PetitBooTheme.textTertiary,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

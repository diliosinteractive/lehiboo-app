import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:lehiboo/core/utils/guest_guard.dart';
import 'favorite_list_picker_sheet.dart';

/// A reusable animated favorite button widget
///
/// Features:
/// - Scale animation on tap (0.8 → 1.2 → 1.0)
/// - Haptic feedback (light impact)
/// - Smooth color transition
/// - Guest guard check before toggling
/// - Snackbar feedback on success/error
/// - Long-press to select a favorite list
class FavoriteButton extends ConsumerStatefulWidget {
  /// The event to favorite/unfavorite
  final Event event;

  /// Optional numeric ID for API (if not in event.additionalInfo)
  final int? internalId;

  /// Size of the icon (default: 20)
  final double iconSize;

  /// Size of the container (default: 36)
  final double containerSize;

  /// Whether to show a circular white background
  final bool showBackground;

  /// Background color when showBackground is true
  final Color? backgroundColor;

  /// Callback when favorite state changes
  final void Function(bool isFavorite)? onChanged;

  /// Whether to enable long-press to select a list
  final bool enableLongPress;

  const FavoriteButton({
    super.key,
    required this.event,
    this.internalId,
    this.iconSize = 20,
    this.containerSize = 36,
    this.showBackground = true,
    this.backgroundColor,
    this.onChanged,
    this.enableLongPress = true,
  });

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Scale animation: 1.0 → 0.8 → 1.2 → 1.0 (bounce effect)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.8), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.2), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isFavorite {
    return ref.read(favoritesProvider.notifier).isFavorite(widget.event.id);
  }

  Future<void> _toggleFavorite({String? listId}) async {
    // Check guest guard
    final canProceed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'ajouter aux favoris',
    );

    if (!canProceed) return;

    if (_isLoading) return;

    setState(() => _isLoading = true);

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Start animation
    _controller.forward(from: 0);

    final wasAdding = !_isFavorite;

    try {
      final success = await ref.read(favoritesProvider.notifier).toggleFavorite(
        widget.event,
        internalId: widget.internalId,
        listId: listId,
      );

      if (mounted) {
        if (success) {
          widget.onChanged?.call(wasAdding);

          // Show success snackbar
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                wasAdding ? 'Ajouté aux favoris' : 'Retiré des favoris',
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Annuler',
                textColor: const Color(0xFFFF601F),
                onPressed: () {
                  // Toggle back
                  ref.read(favoritesProvider.notifier).toggleFavorite(
                    widget.event,
                    internalId: widget.internalId,
                  );
                },
              ),
            ),
          );
        } else {
          // Error feedback
          HapticFeedback.heavyImpact();

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                wasAdding
                    ? 'Impossible d\'ajouter aux favoris'
                    : 'Impossible de retirer des favoris',
              ),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red[700],
              action: SnackBarAction(
                label: 'Réessayer',
                textColor: Colors.white,
                onPressed: _toggleFavorite,
              ),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showListPicker() async {
    // Check guest guard
    final canProceed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'gérer les favoris',
    );

    if (!canProceed || !mounted) return;

    HapticFeedback.mediumImpact();

    // Obtenir l'ID de liste actuel de l'événement
    final currentListId = widget.event.additionalInfo?['list_id'] as String?;

    if (!mounted) return;

    final result = await FavoriteListPickerSheet.show(
      context,
      currentListId: currentListId,
      isAlreadyFavorite: _isFavorite,
    );

    if (result == null || !mounted) return;

    setState(() => _isLoading = true);

    try {
      bool success;

      if (result.removeFromFavorites) {
        // Retirer des favoris
        success = await ref.read(favoritesProvider.notifier).toggleFavorite(
          widget.event,
          internalId: widget.internalId,
        );

        if (success && mounted) {
          widget.onChanged?.call(false);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Retiré des favoris'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
              action: SnackBarAction(
                label: 'Annuler',
                textColor: const Color(0xFFFF601F),
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(
                    widget.event,
                    internalId: widget.internalId,
                  );
                },
              ),
            ),
          );
        }
      } else if (_isFavorite) {
        // Déjà favori: déplacer vers une autre liste
        success = await ref.read(favoritesProvider.notifier).moveToList(
          widget.event,
          result.listId,
          internalId: widget.internalId,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.listId != null
                    ? 'Déplacé vers la liste'
                    : 'Déplacé vers "Non classés"',
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
            ),
          );
        }
      } else {
        // Pas encore favori: ajouter avec la liste sélectionnée
        success = await ref.read(favoritesProvider.notifier).addToList(
          widget.event,
          result.listId ?? '',
          internalId: widget.internalId,
        );

        if (success && mounted) {
          widget.onChanged?.call(true);

          // Animation
          _controller.forward(from: 0);

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.listId != null
                    ? 'Ajouté à la liste'
                    : 'Ajouté aux favoris',
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              showCloseIcon: true,
              action: SnackBarAction(
                label: 'Annuler',
                textColor: const Color(0xFFFF601F),
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(
                    widget.event,
                    internalId: widget.internalId,
                  );
                },
              ),
            ),
          );
        }
      }

      if (!success && mounted) {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Une erreur est survenue'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch favorites to rebuild when state changes
    final favoritesState = ref.watch(favoritesProvider);

    bool isFavorite = false;
    if (favoritesState is AsyncData<List<Event>>) {
      isFavorite = ref.read(favoritesProvider.notifier).isFavorite(widget.event.id);
    }

    return GestureDetector(
      onTap: () => _toggleFavorite(),
      onLongPress: widget.enableLongPress ? _showListPicker : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: widget.containerSize,
          height: widget.containerSize,
          decoration: widget.showBackground
              ? BoxDecoration(
                  color: widget.backgroundColor ?? Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                )
              : null,
          child: Center(
            child: _isLoading
                ? SizedBox(
                    width: widget.iconSize,
                    height: widget.iconSize,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFFF601F),
                    ),
                  )
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey(isFavorite),
                      color: isFavorite ? Colors.red : Colors.grey[800],
                      size: widget.iconSize,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/favorites/data/models/toggle_favorite_result.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:lehiboo/features/petit_boo/presentation/widgets/animated_toast.dart';
import 'package:lehiboo/core/utils/guest_guard.dart';
import 'favorite_list_picker_sheet.dart';

/// A reusable animated favorite button widget
///
/// Features:
/// - Tap: if not favorite → open folder picker; if favorite → remove
/// - Long press on favorite: open picker to move to another folder
/// - Scale animation on add/remove (0.8 → 1.2 → 1.0)
/// - Haptic feedback (light impact)
/// - Smooth color transition
/// - Guest guard check before toggling
/// - Snackbar feedback on success/error
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

  /// Force the heart to render filled regardless of the favourites
  /// provider state. Used by section-attribution-driven surfaces (e.g.
  /// the "Pour vous" carousel) where membership in the `favorites`
  /// section is the source of truth — see
  /// `docs/PERSONALIZED_FEED_MOBILE_SPEC.md` §3.3 / §4.3. Tap behaviour
  /// is unchanged: tapping still calls
  /// `favoritesProvider.notifier.toggleFavorite(...)`.
  final bool forceFilled;

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
    this.forceFilled = false,
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

  /// Handle tap: if already favorite, remove it. Otherwise open picker.
  Future<void> _onTap() async {
    if (_isFavorite) {
      // Already favorite: remove directly
      await _removeFavorite();
    } else {
      // Not favorite: open picker to choose folder
      await _showListPicker();
    }
  }

  /// Remove from favorites directly
  Future<void> _removeFavorite() async {
    final canProceed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'gérer les favoris',
    );

    if (!canProceed || !mounted) return;
    if (_isLoading) return;

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();
    _controller.forward(from: 0);

    try {
      final result = await ref.read(favoritesProvider.notifier).toggleFavorite(
        widget.event,
        internalId: widget.internalId,
      );

      if (result != null && mounted) {
        widget.onChanged?.call(false);
        PetitBooToast.favoriteRemoved(context);
        // Un retrait ne déclenche jamais de reward côté backend, mais on
        // reste défensif au cas où le contrat évoluerait.
        _showRewardToastIfAny(result);
      } else if (result == null && mounted) {
        HapticFeedback.heavyImpact();
        PetitBooToast.error(context, 'Impossible de retirer des favoris');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Plan 05 : le toast `+X Hibons` est désormais déclenché globalement par
  /// `HibonsAnimationCoordinator` via l'enveloppe `hibons_update`. Ce hook
  /// reste pour rétro-compat de la signature mais n'émet plus de toast.
  void _showRewardToastIfAny(ToggleFavoriteResult? result) {}

  Future<void> _showListPicker() async {
    // Check guest guard
    final canProceed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: 'gérer les favoris',
    );

    if (!canProceed || !mounted) return;

    HapticFeedback.mediumImpact();

    // Obtenir l'ID de liste actuel via le notifier (autoritaire). Lire depuis
    // `widget.event.additionalInfo` ne marche que quand l'event vient de
    // l'endpoint `/me/favorites` ; depuis la home ou le détail, ce champ est
    // absent → la liste actuelle ne serait pas highlight dans le picker.
    final currentListId =
        ref.read(favoritesProvider.notifier).getEventListId(widget.event.id);

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
      ToggleFavoriteResult? rewardSource;

      if (result.removeFromFavorites) {
        // Retirer des favoris
        final toggleResult = await ref.read(favoritesProvider.notifier).toggleFavorite(
          widget.event,
          internalId: widget.internalId,
        );
        success = toggleResult != null;

        if (success && mounted) {
          widget.onChanged?.call(false);
          PetitBooToast.favoriteRemoved(context);
        }
      } else if (_isFavorite) {
        // Déjà favori: déplacer vers une autre liste (jamais de reward)
        success = await ref.read(favoritesProvider.notifier).moveToList(
          widget.event,
          result.listId,
          internalId: widget.internalId,
        );

        if (success && mounted) {
          PetitBooToast.success(
            context,
            result.listId != null ? 'Déplacé vers la liste' : 'Déplacé vers "Non classés"',
          );
        }
      } else {
        // Pas encore favori: ajouter avec la liste sélectionnée (reward possible)
        final addResult = await ref.read(favoritesProvider.notifier).addToList(
          widget.event,
          result.listId ?? '',
          internalId: widget.internalId,
        );
        success = addResult != null;
        rewardSource = addResult;

        if (success && mounted) {
          widget.onChanged?.call(true);

          // Animation
          _controller.forward(from: 0);

          if (result.listId != null) {
            PetitBooToast.success(context, 'Ajouté à la liste');
          } else {
            PetitBooToast.favoriteAdded(context);
          }
        }
      }

      if (!success && mounted) {
        HapticFeedback.heavyImpact();
        PetitBooToast.error(context, 'Une erreur est survenue');
      } else if (success && rewardSource != null) {
        _showRewardToastIfAny(rewardSource);
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

    // Start from the caller-supplied override (used by the personalized
    // feed where section attribution is authoritative — see
    // docs/PERSONALIZED_FEED_MOBILE_SPEC.md §3.3 / §4.3). The provider
    // state is then OR-ed in so locally-known favourites still light up
    // the heart even when the override is false.
    bool isFavorite = widget.forceFilled;
    if (favoritesState is AsyncData<List<Event>>) {
      isFavorite = isFavorite ||
          ref.read(favoritesProvider.notifier).isFavorite(widget.event.id);
    }

    return GestureDetector(
      onTap: _onTap,
      onLongPress: _isFavorite ? _showListPicker : null, // Long press to move to another folder
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

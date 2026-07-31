import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/utils/api_response_handler.dart';
import 'package:lehiboo/features/auth/presentation/providers/auth_session_key_provider.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/features/favorites/data/models/toggle_favorite_result.dart';
import 'package:lehiboo/features/favorites/presentation/providers/favorites_provider.dart';
import 'package:lehiboo/features/petit_boo/presentation/widgets/animated_toast.dart';
import 'package:lehiboo/core/utils/guest_guard.dart';
import 'favorite_list_picker_sheet.dart';

typedef _FavoriteInteraction = ({
  AuthSessionKey ownerSession,
  FavoritesNotifier notifier,
  int generation,
});

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

  /// Exact authentication session that owns the rendered event.
  ///
  /// Identity equality is intentional: an A -> B -> A replacement must not
  /// revive an action started by the first A session.
  final AuthSessionKey ownerSession;

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

  /// Whether a normal add tap opens the list picker. Compact surfaces such as
  /// map cards can keep their historical one-tap add behavior by disabling it.
  final bool chooseListOnAdd;

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
    required this.ownerSession,
    this.internalId,
    this.iconSize = 20,
    this.containerSize = 36,
    this.showBackground = true,
    this.backgroundColor,
    this.onChanged,
    this.enableLongPress = true,
    this.chooseListOnAdd = true,
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
  int _interactionGeneration = 0;
  int? _pendingGuestGeneration;
  AuthSessionKey? _pendingGuestAdoptionSession;

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

  @override
  void didUpdateWidget(covariant FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event.id != widget.event.id) {
      _invalidateInteraction();
      return;
    }
    if (identical(oldWidget.ownerSession, widget.ownerSession)) return;

    // A public event rendered as a guest may legitimately survive the single
    // guest -> authenticated transition completed by GuestGuard. Any other
    // owner replacement invalidates the action.
    final adoptsPendingGuest =
        _pendingGuestGeneration == _interactionGeneration &&
            oldWidget.ownerSession.accountId == null &&
            identical(
              widget.ownerSession,
              _pendingGuestAdoptionSession,
            );
    if (!adoptsPendingGuest) _invalidateInteraction();
  }

  bool get _isFavorite {
    return ref.read(favoritesProvider.notifier).isFavorite(widget.event.id);
  }

  bool _ownsRenderedSession() {
    return mounted &&
        identical(ref.read(authSessionKeyProvider), widget.ownerSession);
  }

  Future<_FavoriteInteraction?> _authorizeInteraction() async {
    // Capture every ownership component before the first async boundary. A
    // stale rendered button must not even open the guest/auth flow.
    if (!_ownsRenderedSession()) return null;
    final interaction = (
      ownerSession: widget.ownerSession,
      notifier: ref.read(favoritesProvider.notifier),
      generation: ++_interactionGeneration,
    );
    if (!_ownsInteraction(interaction)) return null;
    final startedAsGuest = interaction.ownerSession.accountId == null;
    if (startedAsGuest) {
      _pendingGuestGeneration = interaction.generation;
      _pendingGuestAdoptionSession = null;
    } else {
      _pendingGuestGeneration = null;
      _pendingGuestAdoptionSession = null;
    }

    final canProceed = await GuestGuard.check(
      context: context,
      ref: ref,
      featureName: context.l10n.guestFeatureManageFavorites,
    );
    if (!canProceed || !mounted) {
      _clearPendingGuestAdoption(interaction.generation);
      return null;
    }

    if (!startedAsGuest) {
      if (!_ownsInteraction(interaction)) return null;
      return interaction;
    }

    final adoptedSession = ref.read(authSessionKeyProvider);
    if (_pendingGuestGeneration != interaction.generation ||
        adoptedSession.accountId == null ||
        !identical(adoptedSession, _pendingGuestAdoptionSession)) {
      _clearPendingGuestAdoption(interaction.generation);
      return null;
    }
    final adopted = (
      ownerSession: adoptedSession,
      notifier: ref.read(favoritesProvider.notifier),
      generation: interaction.generation,
    );
    _clearPendingGuestAdoption(interaction.generation);
    return _ownsInteraction(adopted) ? adopted : null;
  }

  bool _ownsInteraction(_FavoriteInteraction interaction) {
    return mounted &&
        interaction.generation == _interactionGeneration &&
        identical(
          ref.read(authSessionKeyProvider),
          interaction.ownerSession,
        ) &&
        identical(ref.read(favoritesProvider.notifier), interaction.notifier);
  }

  void _handleSessionChange(
    AuthSessionKey? previous,
    AuthSessionKey next,
  ) {
    if (identical(previous, next)) return;
    final mayAdoptGuest = _pendingGuestGeneration == _interactionGeneration &&
        previous?.accountId == null &&
        next.accountId != null &&
        _pendingGuestAdoptionSession == null;
    if (mayAdoptGuest) {
      _pendingGuestAdoptionSession = next;
      return;
    }
    _invalidateInteraction();
  }

  void _invalidateInteraction() {
    _interactionGeneration++;
    _pendingGuestGeneration = null;
    _pendingGuestAdoptionSession = null;
    if (mounted && _isLoading) setState(() => _isLoading = false);
  }

  void _clearPendingGuestAdoption(int generation) {
    if (_pendingGuestGeneration != generation) return;
    _pendingGuestGeneration = null;
    _pendingGuestAdoptionSession = null;
  }

  /// Handle tap: if already favorite, remove it. Otherwise open picker.
  Future<void> _onTap() async {
    if (!_ownsRenderedSession()) return;
    if (_isFavorite) {
      // Already favorite: remove directly
      await _removeFavorite();
    } else if (!widget.chooseListOnAdd) {
      await _addFavoriteDirectly();
    } else {
      // Not favorite: open picker to choose folder
      await _showListPicker();
    }
  }

  Future<void> _addFavoriteDirectly() async {
    final interaction = await _authorizeInteraction();
    if (interaction == null ||
        !mounted ||
        !_ownsInteraction(interaction) ||
        _isLoading) {
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();
    try {
      final result = await interaction.notifier.toggleFavorite(
        widget.event,
        internalId: widget.internalId,
      );
      if (!mounted || !_ownsInteraction(interaction)) return;
      widget.onChanged?.call(result.isFavorite);
      if (result.isFavorite) {
        _controller.forward(from: 0);
        PetitBooToast.favoriteAdded(context, eventTitle: widget.event.title);
      } else {
        PetitBooToast.favoriteRemoved(context);
      }
      _showRewardToastIfAny(result);
    } catch (error) {
      if (!mounted || !_ownsInteraction(interaction)) return;
      HapticFeedback.heavyImpact();
      PetitBooToast.error(
        context,
        ApiResponseHandler.extractError(
          error,
          fallback: context.l10n.favoriteAddError,
        ),
      );
    } finally {
      if (mounted && _ownsInteraction(interaction)) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Remove from favorites directly
  Future<void> _removeFavorite() async {
    final interaction = await _authorizeInteraction();
    if (interaction == null ||
        !mounted ||
        !_ownsInteraction(interaction) ||
        _isLoading) {
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();
    _controller.forward(from: 0);

    try {
      final result = await interaction.notifier.toggleFavorite(
        widget.event,
        internalId: widget.internalId,
      );

      if (!mounted || !_ownsInteraction(interaction)) return;
      widget.onChanged?.call(result.isFavorite);
      if (result.isFavorite) {
        PetitBooToast.favoriteAdded(context, eventTitle: widget.event.title);
      } else {
        PetitBooToast.favoriteRemoved(context);
      }
      // Un retrait ne déclenche jamais de reward côté backend, mais on
      // reste défensif au cas où le contrat évoluerait.
      _showRewardToastIfAny(result);
    } catch (error) {
      if (!mounted || !_ownsInteraction(interaction)) return;
      HapticFeedback.heavyImpact();
      PetitBooToast.error(
        context,
        ApiResponseHandler.extractError(
          error,
          fallback: context.l10n.favoriteRemoveError,
        ),
      );
    } finally {
      if (mounted && _ownsInteraction(interaction)) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Plan 05 : le toast `+X Hibons` est désormais déclenché globalement par
  /// `HibonsAnimationCoordinator` via l'enveloppe `hibons_update`. Ce hook
  /// reste pour rétro-compat de la signature mais n'émet plus de toast.
  void _showRewardToastIfAny(ToggleFavoriteResult? result) {}

  Future<void> _showListPicker() async {
    final interaction = await _authorizeInteraction();
    if (interaction == null || !mounted || !_ownsInteraction(interaction)) {
      return;
    }

    HapticFeedback.mediumImpact();

    // Obtenir l'ID de liste actuel via le notifier (autoritaire). Lire depuis
    // `widget.event.additionalInfo` ne marche que quand l'event vient de
    // l'endpoint `/me/favorites` ; depuis la home ou le détail, ce champ est
    // absent → la liste actuelle ne serait pas highlight dans le picker.
    final currentListId = interaction.notifier.getEventListId(widget.event.id);

    // Check immediately before creating the route: the picker must never be
    // opened by a button rendered for an obsolete exact session.
    if (!mounted || !_ownsInteraction(interaction)) return;

    final result = await FavoriteListPickerSheet.show(
      context,
      ownerSession: interaction.ownerSession,
      currentListId: currentListId,
      isAlreadyFavorite: interaction.notifier.isFavorite(widget.event.id),
    );

    if (!mounted || !_ownsInteraction(interaction) || result == null) return;

    setState(() => _isLoading = true);

    var failureMessage = context.l10n.favoriteUpdateError;
    try {
      bool success;
      ToggleFavoriteResult? rewardSource;

      if (result.removeFromFavorites) {
        failureMessage = context.l10n.favoriteRemoveError;
        // Retirer des favoris
        final toggleResult = await interaction.notifier.toggleFavorite(
          widget.event,
          internalId: widget.internalId,
        );
        if (!mounted || !_ownsInteraction(interaction)) return;
        success = true;

        if (success) {
          widget.onChanged?.call(toggleResult.isFavorite);
          if (toggleResult.isFavorite) {
            PetitBooToast.favoriteAdded(
              context,
              eventTitle: widget.event.title,
            );
          } else {
            PetitBooToast.favoriteRemoved(context);
          }
        }
      } else if (interaction.notifier.isFavorite(widget.event.id)) {
        failureMessage = context.l10n.favoriteUpdateError;
        // Déjà favori: déplacer vers une autre liste (jamais de reward)
        success = await interaction.notifier.moveToList(
          widget.event,
          result.listId,
          internalId: widget.internalId,
        );
        if (!mounted || !_ownsInteraction(interaction)) return;

        if (success) {
          PetitBooToast.success(
            context,
            result.listId != null
                ? context.l10n.favoriteMovedToList
                : context.l10n.favoriteMovedToUncategorized,
          );
        }
      } else {
        failureMessage = context.l10n.favoriteAddError;
        // Pas encore favori: ajouter avec la liste sélectionnée (reward possible)
        final addResult = await interaction.notifier.addToList(
          widget.event,
          result.listId ?? '',
          internalId: widget.internalId,
        );
        if (!mounted || !_ownsInteraction(interaction)) return;
        success = true;
        rewardSource = addResult;

        if (success) {
          widget.onChanged?.call(true);

          // Animation
          _controller.forward(from: 0);

          if (result.listId != null) {
            PetitBooToast.success(context, context.l10n.favoriteAddedToList);
          } else {
            PetitBooToast.favoriteAdded(context);
          }
        }
      }

      if (_ownsInteraction(interaction) && success && rewardSource != null) {
        _showRewardToastIfAny(rewardSource);
      }
    } catch (error) {
      if (!mounted || !_ownsInteraction(interaction)) return;
      HapticFeedback.heavyImpact();
      PetitBooToast.error(
        context,
        ApiResponseHandler.extractError(error, fallback: failureMessage),
      );
    } finally {
      if (mounted && _ownsInteraction(interaction)) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthSessionKey>(authSessionKeyProvider, (previous, next) {
      _handleSessionChange(previous, next);
    });
    final activeSession = ref.watch(authSessionKeyProvider);
    final ownsRenderedSession = identical(activeSession, widget.ownerSession);
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
      onTap: ownsRenderedSession ? _onTap : null,
      onLongPress: ownsRenderedSession && _isFavorite
          ? _showListPicker
          : null, // Long press to move to another folder
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
                      color: Colors.black.withValues(alpha: 0.1),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';
import 'package:lehiboo/shared/widgets/animations/spring_button.dart';

/// Barre de réservation sticky en bas de l'écran
///
/// États:
/// 1. Aucune date: "À partir de X€" + "Choisir une date"
/// 2. Date sélectionnée sans billet: "Date + Heure" + "Choisir"
/// 3. Billets sélectionnés: "Total X€" + "X billets • Date" + "Réserver"
/// 4. External booking: "Voir le site"
/// 5. Complet: Bouton désactivé + shake on tap
///
/// Animations Material Expressive:
/// - Spring bounce sur bouton CTA
/// - AnimatedSwitcher pour transitions prix/texte
/// - Shake animation si tap sur "Complet"
class EventStickyBookingBar extends StatefulWidget {
  final Event event;
  final Map<String, int> ticketQuantities;
  final double totalPrice;
  final VoidCallback? onBookPressed;
  final VoidCallback? onViewDatesPressed;
  final bool isLoading;
  /// ID du slot/date sélectionné
  final String? selectedSlotId;
  /// Label formaté de la date sélectionnée (ex: "Sam 15 Mars à 14:00")
  final String? selectedDateLabel;

  const EventStickyBookingBar({
    super.key,
    required this.event,
    required this.ticketQuantities,
    required this.totalPrice,
    this.onBookPressed,
    this.onViewDatesPressed,
    this.isLoading = false,
    this.selectedSlotId,
    this.selectedDateLabel,
  });

  @override
  State<EventStickyBookingBar> createState() => _EventStickyBookingBarState();
}

class _EventStickyBookingBarState extends State<EventStickyBookingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  int get _totalTickets {
    return widget.ticketQuantities.values.fold(0, (sum, qty) => sum + qty);
  }

  bool get _hasTicketSelection => _totalTickets > 0;

  bool get _hasDateSelection => widget.selectedSlotId != null;

  bool get _hasExternalBooking =>
      widget.event.externalBooking != null &&
      widget.event.externalBooking!.url.isNotEmpty;

  bool get _isSoldOut {
    if (widget.event.availableSeats != null &&
        widget.event.availableSeats! <= 0) {
      return true;
    }
    return false;
  }

  bool get _isFreeEvent {
    return widget.event.priceType == PriceType.free ||
        (widget.event.minPrice == 0 && widget.event.maxPrice == 0);
  }

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    HapticFeedback.heavyImpact();
    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // Ombre flat vers le haut (plus subtile)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Partie gauche: Prix/Info avec animations
              Expanded(
                child: _buildPriceSection(),
              ),
              const SizedBox(width: 16),
              // Partie droite: Bouton avec animations
              _buildActionButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    // AnimatedSwitcher pour transition smooth entre états
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: _buildPriceContent(),
    );
  }

  Widget _buildPriceContent() {
    if (_isSoldOut) {
      return Column(
        key: const ValueKey('sold_out'),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.event_busy,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    'Plus de places disponibles',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    if (_hasTicketSelection) {
      // Affichage avec billets sélectionnés (+ date si disponible)
      return Column(
        key: ValueKey('selection_$_totalTickets'),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // Prix animé
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: widget.totalPrice),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Text(
                    _formatPrice(value),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: HbColors.textPrimary,
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
              const Text(
                'total',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // Info billets + date
          Text(
            _hasDateSelection && widget.selectedDateLabel != null
                ? '$_totalTickets billet${_totalTickets > 1 ? 's' : ''} • ${widget.selectedDateLabel}'
                : '$_totalTickets billet${_totalTickets > 1 ? 's' : ''} sélectionné${_totalTickets > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      );
    }

    // Date sélectionnée mais pas de billets encore
    if (_hasDateSelection && widget.selectedDateLabel != null) {
      return Column(
        key: ValueKey('date_selected_${widget.selectedSlotId}'),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (_isFreeEvent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Gratuit',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                )
              else ...[
                const Text(
                  'À partir de ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  _formatPrice(widget.event.minPrice ?? widget.event.price ?? 0),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: HbColors.textPrimary,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          // Badge date sélectionnée
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 14,
                color: Colors.green.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                widget.selectedDateLabel!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Affichage sans sélection
    return Column(
      key: const ValueKey('no_selection'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (_isFreeEvent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Gratuit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              )
            else ...[
              const Text(
                'À partir de ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                _formatPrice(widget.event.minPrice ?? widget.event.price ?? 0),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: HbColors.textPrimary,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        // Chip "Voir les dates" au lieu d'un lien souligné
        GestureDetector(
          onTap: widget.onViewDatesPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: HbColors.brandPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: HbColors.brandPrimary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Voir les dates',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: HbColors.brandPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (_isSoldOut) {
      return AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0),
            child: child,
          );
        },
        child: ElevatedButton(
          onPressed: _triggerShake,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade400,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.block, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                'Complet',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_hasExternalBooking) {
      return SpringButton(
        enabled: !widget.isLoading,
        onTap: () {
          HapticFeedback.mediumImpact();
          widget.onBookPressed?.call();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: HbColors.brandPrimary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: HbColors.brandPrimary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                const Icon(Icons.open_in_new, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                'Voir le site',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Bouton standard avec spring bounce
    // CTA toujours visible et coloré (orange) - Flat design
    // Le texte dépend de l'état : date non sélectionnée, date sélectionnée, billets sélectionnés
    String buttonText;
    IconData? buttonIcon;

    if (!_hasDateSelection) {
      // Pas de date sélectionnée -> guider vers la sélection de date
      buttonText = 'Choisir une date';
      buttonIcon = Icons.calendar_today;
    } else if (_hasTicketSelection) {
      // Billets sélectionnés -> prêt pour réserver
      buttonText = 'Réserver';
      buttonIcon = Icons.shopping_cart_checkout;
    } else {
      // Date sélectionnée mais pas de billets
      buttonText = _isFreeEvent ? "S'inscrire" : 'Choisir';
      buttonIcon = null;
    }

    return SpringButton(
      enabled: !widget.isLoading,
      onTap: () {
        HapticFeedback.mediumImpact();
        // Si pas de date, on scroll vers les dates plutôt que d'appeler onBookPressed
        if (!_hasDateSelection) {
          widget.onViewDatesPressed?.call();
        } else {
          widget.onBookPressed?.call();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        decoration: BoxDecoration(
          // Toujours orange pour être visible (plus d'état gris discret)
          color: HbColors.brandPrimary,
          borderRadius: BorderRadius.circular(12),
          // Ombre subtile flat
          boxShadow: [
            BoxShadow(
              color: HbColors.brandPrimary.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: widget.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (buttonIcon != null) ...[
                    Icon(buttonIcon, size: 18, color: Colors.white),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    buttonText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _formatPrice(double price) {
    if (price == price.roundToDouble()) {
      return '${price.toInt()}€';
    }
    return '${price.toStringAsFixed(2)}€';
  }
}

/// Version simplifiée pour les événements externes uniquement
class EventExternalBookingBar extends StatelessWidget {
  final String buttonText;
  final String? price;
  final VoidCallback onPressed;
  final bool isLoading;

  const EventExternalBookingBar({
    super.key,
    required this.buttonText,
    this.price,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (price != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        price!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: HbColors.textPrimary,
                        ),
                      ),
                      const Text(
                        'Prix indicatif',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              if (price == null) const Spacer(),
              const SizedBox(width: 16),
              SpringButton(
                enabled: !isLoading,
                onTap: onPressed,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: HbColors.brandPrimary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: HbColors.brandPrimary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLoading)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      else
                        const Icon(Icons.open_in_new,
                            size: 18, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        buttonText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

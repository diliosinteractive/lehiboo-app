import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';

/// Barre de réservation sticky en bas de l'écran
///
/// États:
/// 1. Aucun billet: "À partir de X€" + "Choisir"
/// 2. Billets sélectionnés: "Total X€" + "X billets" + "Réserver"
/// 3. External booking: "Voir le site"
/// 4. Complet: Bouton désactivé
class EventStickyBookingBar extends StatelessWidget {
  final Event event;
  final Map<String, int> ticketQuantities;
  final double totalPrice;
  final VoidCallback? onBookPressed;
  final VoidCallback? onViewDatesPressed;
  final bool isLoading;

  const EventStickyBookingBar({
    super.key,
    required this.event,
    required this.ticketQuantities,
    required this.totalPrice,
    this.onBookPressed,
    this.onViewDatesPressed,
    this.isLoading = false,
  });

  int get _totalTickets {
    return ticketQuantities.values.fold(0, (sum, qty) => sum + qty);
  }

  bool get _hasSelection => _totalTickets > 0;

  bool get _hasExternalBooking =>
      event.externalBooking != null && event.externalBooking!.url.isNotEmpty;

  bool get _isSoldOut {
    if (event.availableSeats != null && event.availableSeats! <= 0) {
      return true;
    }
    return false;
  }

  bool get _isFreeEvent {
    return event.priceType == PriceType.free ||
        (event.minPrice == 0 && event.maxPrice == 0);
  }

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
              // Partie gauche: Prix/Info
              Expanded(
                child: _buildPriceSection(),
              ),
              const SizedBox(width: 16),
              // Partie droite: Bouton
              _buildActionButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    if (_isSoldOut) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
      );
    }

    if (_hasSelection) {
      // Affichage avec sélection
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formatPrice(totalPrice),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: HbColors.textPrimary,
                ),
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
          Text(
            '$_totalTickets billet${_totalTickets > 1 ? 's' : ''} sélectionné${_totalTickets > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 12,
              color: HbColors.brandPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    // Affichage sans sélection
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (_isFreeEvent)
              const Text(
                'Gratuit',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
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
                _formatPrice(event.minPrice ?? event.price ?? 0),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: HbColors.textPrimary,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        GestureDetector(
          onTap: onViewDatesPressed,
          child: Row(
            children: [
              Text(
                'Voir les dates disponibles',
                style: TextStyle(
                  fontSize: 12,
                  color: HbColors.brandPrimary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                  decorationColor: HbColors.brandPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: HbColors.brandPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    if (_isSoldOut) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          disabledBackgroundColor: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Complet',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      );
    }

    if (_hasExternalBooking) {
      return ElevatedButton.icon(
        onPressed: isLoading
            ? null
            : () {
                HapticFeedback.mediumImpact();
                onBookPressed?.call();
              },
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.open_in_new, size: 18),
        label: const Text(
          'Voir le site',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: HbColors.brandPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    // Bouton standard
    final isEnabled = _hasSelection || _isFreeEvent;
    final buttonText = _hasSelection
        ? 'Réserver'
        : (_isFreeEvent ? "S'inscrire" : 'Choisir');

    return ElevatedButton(
      onPressed: isEnabled && !isLoading
          ? () {
              HapticFeedback.mediumImpact();
              onBookPressed?.call();
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: HbColors.brandPrimary,
        disabledBackgroundColor: Colors.grey.shade300,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              buttonText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
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
              ElevatedButton.icon(
                onPressed: isLoading ? null : onPressed,
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.open_in_new, size: 18),
                label: Text(
                  buttonText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HbColors.brandPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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

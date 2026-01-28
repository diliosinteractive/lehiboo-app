import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';
import 'package:lehiboo/shared/widgets/animations/pulse_animation.dart';

/// Tier de billet pour le styling visuel
enum TicketTier {
  vip,
  premium,
  standard,
  reduced,
}

extension TicketTierExtension on TicketTier {
  // Flat design : couleur unique pour tous les tiers (uniformité visuelle)
  Color get color => HbColors.brandPrimary;

  // Icône unique pour tous
  IconData get icon => Icons.confirmation_number_outlined;

  String get label {
    switch (this) {
      case TicketTier.vip:
        return 'VIP';
      case TicketTier.premium:
        return 'Premium';
      case TicketTier.standard:
        return 'Standard';
      case TicketTier.reduced:
        return 'Réduit';
    }
  }
}

/// Card pour un type de billet avec animations Material Expressive
///
/// Features:
/// - Sélecteur de quantité avec haptic feedback
/// - Badge de stock coloré avec animation pulse pour urgence
/// - Spring bounce highlight quand sélectionné
/// - Tier visuel (VIP, Premium, etc.) avec gradient shine
class EventTicketCard extends StatefulWidget {
  final Ticket ticket;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final bool isExpanded;
  final VoidCallback? onToggleExpand;

  const EventTicketCard({
    super.key,
    required this.ticket,
    required this.quantity,
    required this.onQuantityChanged,
    this.isExpanded = false,
    this.onToggleExpand,
  });

  @override
  State<EventTicketCard> createState() => _EventTicketCardState();
}

class _EventTicketCardState extends State<EventTicketCard> {
  bool get _isSelected => widget.quantity > 0;
  bool get _isSoldOut => widget.ticket.remainingPlaces != null && widget.ticket.remainingPlaces! <= 0;
  bool get _isLowStock => widget.ticket.remainingPlaces != null && widget.ticket.remainingPlaces! <= 5;
  bool get _isFree => widget.ticket.price == 0;

  TicketTier get _tier {
    final nameLower = widget.ticket.name.toLowerCase();
    if (nameLower.contains('vip')) return TicketTier.vip;
    if (nameLower.contains('premium') || nameLower.contains('gold')) {
      return TicketTier.premium;
    }
    if (nameLower.contains('réduit') ||
        nameLower.contains('etudiant') ||
        nameLower.contains('enfant') ||
        nameLower.contains('senior')) {
      return TicketTier.reduced;
    }
    return TicketTier.standard;
  }

  int get _maxQuantity {
    if (widget.ticket.maxPerBooking != null) {
      return widget.ticket.maxPerBooking!;
    }
    if (widget.ticket.remainingPlaces != null) {
      return widget.ticket.remainingPlaces!.clamp(0, 10);
    }
    return 10;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isSelected ? HbColors.brandPrimary : HbColors.grey200,
          width: _isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Première ligne: Nom + Prix
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icône flat (gris neutre, orange si sélectionné)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isSelected
                              ? HbColors.brandPrimary.withValues(alpha: 0.1)
                              : HbColors.grey200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _tier.icon,
                          color: _isSelected ? HbColors.brandPrimary : HbColors.grey500,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Nom et description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.ticket.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: HbColors.textPrimary,
                                    ),
                                  ),
                                ),
                                // Prix
                                _buildPrice(),
                              ],
                            ),
                            if (widget.ticket.description != null &&
                                widget.ticket.description!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.ticket.description!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  height: 1.3,
                                ),
                                maxLines: widget.isExpanded ? null : 2,
                                overflow:
                                    widget.isExpanded ? null : TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Deuxième ligne: Stock + Sélecteur quantité
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Badge stock
                      _buildStockBadge(),

                      // Sélecteur quantité
                      _buildQuantitySelector(),
                    ],
                  ),
                ],
              ),
            ),

            // Expand pour plus de détails (optionnel)
            if (widget.ticket.description != null &&
                widget.ticket.description!.length > 80 &&
                widget.onToggleExpand != null)
              GestureDetector(
                onTap: widget.onToggleExpand,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.isExpanded ? 'Voir moins' : 'Voir plus',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        widget.isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.grey.shade600,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
    );
  }

  Widget _buildPrice() {
    if (_isFree) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Gratuit',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      );
    }

    return Text(
      '${widget.ticket.price.toStringAsFixed(widget.ticket.price == widget.ticket.price.roundToDouble() ? 0 : 2)}€',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: HbColors.textPrimary,
      ),
    );
  }

  Widget _buildStockBadge() {
    if (_isSoldOut) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.block, color: Colors.red, size: 14),
            SizedBox(width: 4),
            Text(
              'Épuisé',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    if (widget.ticket.remainingPlaces != null) {
      final Color color;
      final IconData icon;
      final String text;

      if (_isLowStock) {
        color = Colors.orange;
        icon = Icons.local_fire_department;
        text = 'Plus que ${widget.ticket.remainingPlaces}!';
      } else {
        color = Colors.green;
        icon = Icons.check_circle_outline;
        text = '${widget.ticket.remainingPlaces} disponible${widget.ticket.remainingPlaces! > 1 ? 's' : ''}';
      }

      final badge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );

      // Pulse animation for low stock
      if (_isLowStock) {
        return OpacityPulse(
          duration: const Duration(milliseconds: 1000),
          minOpacity: 0.7,
          maxOpacity: 1.0,
          child: badge,
        );
      }

      return badge;
    }

    return const SizedBox.shrink();
  }

  Widget _buildQuantitySelector() {
    if (_isSoldOut) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _isSelected
            ? HbColors.brandPrimary.withValues(alpha: 0.1)
            : HbColors.grey200.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: _isSelected
            ? Border.all(color: HbColors.brandPrimary.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bouton moins
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed: widget.quantity > 0
                ? () {
                    HapticFeedback.selectionClick();
                    widget.onQuantityChanged(widget.quantity - 1);
                  }
                : null,
          ),

          // Quantité avec animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            constraints: const BoxConstraints(minWidth: 44),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: widget.quantity > 0 ? 18 : 16,
                fontWeight: FontWeight.bold,
                color: widget.quantity > 0 ? HbColors.brandPrimary : HbColors.textPrimary,
              ),
              child: Text(
                widget.quantity.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Bouton plus
          _buildQuantityButton(
            icon: Icons.add,
            onPressed: widget.quantity < _maxQuantity
                ? () {
                    HapticFeedback.mediumImpact();
                    widget.onQuantityChanged(widget.quantity + 1);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        // Flat design : sélecteur plus compact
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: onPressed != null ? HbColors.textPrimary : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}

/// Section complète des billets
class EventTicketsSection extends StatelessWidget {
  final List<Ticket> tickets;
  final Map<String, int> quantities;
  final ValueChanged<MapEntry<String, int>> onQuantityChanged;

  const EventTicketsSection({
    super.key,
    required this.tickets,
    required this.quantities,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (tickets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Billets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Liste des billets
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: tickets.map((ticket) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: EventTicketCard(
                  ticket: ticket,
                  quantity: quantities[ticket.id] ?? 0,
                  onQuantityChanged: (qty) {
                    onQuantityChanged(MapEntry(ticket.id, qty));
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

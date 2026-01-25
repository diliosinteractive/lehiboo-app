import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';

/// Tier de billet pour le styling visuel
enum TicketTier {
  vip,
  premium,
  standard,
  reduced,
}

extension TicketTierExtension on TicketTier {
  Color get color {
    switch (this) {
      case TicketTier.vip:
        return const Color(0xFFD4AF37); // Or
      case TicketTier.premium:
        return const Color(0xFF9B59B6); // Violet
      case TicketTier.standard:
        return HbColors.brandPrimary;
      case TicketTier.reduced:
        return const Color(0xFF27AE60); // Vert
    }
  }

  IconData get icon {
    switch (this) {
      case TicketTier.vip:
        return Icons.star;
      case TicketTier.premium:
        return Icons.workspace_premium;
      case TicketTier.standard:
        return Icons.confirmation_number_outlined;
      case TicketTier.reduced:
        return Icons.local_offer_outlined;
    }
  }

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

/// Card pour un type de billet
///
/// Features:
/// - Sélecteur de quantité
/// - Badge de stock coloré
/// - Highlight quand sélectionné
/// - Tier visuel (VIP, Premium, etc.)
class EventTicketCard extends StatelessWidget {
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

  bool get _isSelected => quantity > 0;
  bool get _isSoldOut => ticket.remainingPlaces != null && ticket.remainingPlaces! <= 0;
  bool get _isLowStock => ticket.remainingPlaces != null && ticket.remainingPlaces! <= 5;
  bool get _isFree => ticket.price == 0;

  TicketTier get _tier {
    final nameLower = ticket.name.toLowerCase();
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
    if (ticket.maxPerBooking != null) {
      return ticket.maxPerBooking!;
    }
    if (ticket.remainingPlaces != null) {
      return ticket.remainingPlaces!.clamp(0, 10);
    }
    return 10;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _isSelected
            ? _tier.color.withValues(alpha: 0.05)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isSelected ? _tier.color : Colors.grey.shade200,
          width: _isSelected ? 2 : 1,
        ),
        boxShadow: _isSelected
            ? [
                BoxShadow(
                  color: _tier.color.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
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
                    // Icône tier
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _tier.color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _tier.icon,
                        color: _tier.color,
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
                                  ticket.name,
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
                          if (ticket.description != null &&
                              ticket.description!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              ticket.description!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                height: 1.3,
                              ),
                              maxLines: isExpanded ? null : 2,
                              overflow:
                                  isExpanded ? null : TextOverflow.ellipsis,
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
          if (ticket.description != null &&
              ticket.description!.length > 80 &&
              onToggleExpand != null)
            GestureDetector(
              onTap: onToggleExpand,
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
                      isExpanded ? 'Voir moins' : 'Voir plus',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isExpanded
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
      '${ticket.price.toStringAsFixed(ticket.price == ticket.price.roundToDouble() ? 0 : 2)}€',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _tier.color,
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

    if (ticket.remainingPlaces != null) {
      final Color color;
      final IconData icon;

      if (_isLowStock) {
        color = Colors.orange;
        icon = Icons.warning_amber_rounded;
      } else {
        color = Colors.green;
        icon = Icons.check_circle_outline;
      }

      return Container(
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
              '${ticket.remainingPlaces} disponible${ticket.remainingPlaces! > 1 ? 's' : ''}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildQuantitySelector() {
    if (_isSoldOut) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bouton moins
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed: quantity > 0
                ? () {
                    HapticFeedback.selectionClick();
                    onQuantityChanged(quantity - 1);
                  }
                : null,
          ),

          // Quantité
          Container(
            constraints: const BoxConstraints(minWidth: 40),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              quantity.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: quantity > 0 ? _tier.color : HbColors.textPrimary,
              ),
            ),
          ),

          // Bouton plus
          _buildQuantityButton(
            icon: Icons.add,
            onPressed: quantity < _maxQuantity
                ? () {
                    HapticFeedback.selectionClick();
                    onQuantityChanged(quantity + 1);
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
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 20,
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

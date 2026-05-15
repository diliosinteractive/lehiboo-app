import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
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

  /// When false, both quantity buttons are inert. Used by the event
  /// detail screen to lock the ticket selectors when no future slot is
  /// available — there's nothing to book against.
  final bool enabled;

  const EventTicketCard({
    super.key,
    required this.ticket,
    required this.quantity,
    required this.onQuantityChanged,
    this.isExpanded = false,
    this.onToggleExpand,
    this.enabled = true,
  });

  @override
  State<EventTicketCard> createState() => _EventTicketCardState();
}

class _EventTicketCardState extends State<EventTicketCard> {
  bool get _isSelected => widget.quantity > 0;
  bool get _isSoldOut =>
      widget.ticket.remainingPlaces != null &&
      widget.ticket.remainingPlaces! <= 0;
  bool get _isLowStock =>
      widget.ticket.remainingPlaces != null &&
      widget.ticket.remainingPlaces! <= 5;
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
                // Row 1: Icon + Name + Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        color: _isSelected
                            ? HbColors.brandPrimary
                            : HbColors.grey500,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
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
                          _buildPrice(context),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Row 2: Description + Quantity selector
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Description + stock badge
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.ticket.description != null &&
                              widget.ticket.description!.isNotEmpty)
                            Text(
                              widget.ticket.description!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                height: 1.3,
                              ),
                              maxLines: widget.isExpanded ? null : 2,
                              overflow: widget.isExpanded
                                  ? null
                                  : TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 6),
                          _buildStockBadge(context),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Quantity selector
                    Flexible(
                      flex: 2,
                      child: _buildQuantitySelector(),
                    ),
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
                      widget.isExpanded
                          ? context.l10n.eventShowLess
                          : context.l10n.eventShowMore,
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

  Widget _buildPrice(BuildContext context) {
    if (_isFree) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          context.l10n.commonFree,
          style: const TextStyle(
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

  Widget _buildStockBadge(BuildContext context) {
    if (_isSoldOut) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.block, color: Colors.red, size: 14),
            const SizedBox(width: 4),
            Text(
              context.l10n.eventSoldOut,
              style: const TextStyle(
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
        text = context.l10n.eventTicketLowStock(widget.ticket.remainingPlaces!);
      } else {
        color = Colors.green;
        icon = Icons.check_circle_outline;
        text =
            context.l10n.eventTicketsAvailable(widget.ticket.remainingPlaces!);
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
            onPressed: widget.enabled && widget.quantity > 0
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
                color: widget.quantity > 0
                    ? HbColors.brandPrimary
                    : HbColors.textPrimary,
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
            onPressed: widget.enabled && widget.quantity < _maxQuantity
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
            color:
                onPressed != null ? HbColors.textPrimary : Colors.grey.shade400,
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

  /// Forwarded to each [EventTicketCard]. When false, no ticket can be
  /// added or removed — used when the event has no future slot to book
  /// against, so the customer can't reach a coherent booking state.
  final bool enabled;

  const EventTicketsSection({
    super.key,
    required this.tickets,
    required this.quantities,
    required this.onQuantityChanged,
    this.enabled = true,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.l10n.eventTicketsTitle,
            style: const TextStyle(
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
                  enabled: enabled,
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

import 'package:flutter/material.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/booking/domain/models/order_cart_item.dart';
import 'package:lehiboo/features/booking/presentation/utils/booking_l10n.dart';

/// Récapitulatif du panier groupé par événement, avec compteurs +/− et total.
/// Aligné sur le récap sticky du panier desktop (Next.js).
class CartSummarySection extends StatelessWidget {
  final List<OrderCartItem> items;
  final double? totalAmountOverride;
  final void Function(String itemId, int quantity)? onUpdateQuantity;
  final void Function(String itemId)? onRemove;

  const CartSummarySection({
    super.key,
    required this.items,
    this.totalAmountOverride,
    this.onUpdateQuantity,
    this.onRemove,
  });

  String _formatPrice(BuildContext context, double value) {
    return '${context.appCalculatedAmount(value)} €';
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    // Group by event id to mirror the desktop "L'Olympia Paris ▸ Concert" hierarchy.
    final grouped = <String, List<OrderCartItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.event.id, () => []).add(item);
    }

    final totalQuantity =
        items.fold<int>(0, (sum, item) => sum + item.quantity);
    final calculatedTotalAmount =
        items.fold<double>(0, (sum, item) => sum + item.lineTotal);
    final totalAmount = totalAmountOverride ?? calculatedTotalAmount;
    final organizerTotal =
        items.fold<double>(0, (sum, item) => sum + item.organizerLineTotal);
    final calculatedFeeTotal =
        items.fold<double>(0, (sum, item) => sum + item.feeLineTotal);
    final feeTotal = totalAmountOverride == null
        ? calculatedFeeTotal
        : totalAmount - organizerTotal;
    final hasServiceFees = feeTotal > 0.000001;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                size: 20,
                color: HbColors.brandPrimary,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.bookingRecapTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: HbColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final entry in grouped.entries) ...[
            _EventGroup(
              items: entry.value,
              onUpdateQuantity: onUpdateQuantity,
              onRemove: onRemove,
              formatPrice: (value) => _formatPrice(context, value),
            ),
            const SizedBox(height: 10),
          ],
          if (hasServiceFees) ...[
            Text(
              context.l10n.serviceFeesIncluded,
              style: const TextStyle(
                fontSize: 12,
                color: HbColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
          ],
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.bookingTotalTickets,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
              Text(
                '$totalQuantity',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: HbColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (hasServiceFees) ...[
            _PriceSummaryRow(
              label: context.l10n.ticketPriceSubtotal,
              value: _formatPrice(context, organizerTotal),
            ),
            const SizedBox(height: 4),
            _PriceSummaryRow(
              label: context.l10n.serviceFees,
              value: _formatPrice(context, feeTotal),
            ),
            const SizedBox(height: 6),
            _PriceSummaryRow(
              label: context.l10n.totalPaid,
              value: _formatPrice(context, totalAmount),
              isTotal: true,
            ),
          ] else
            _PriceSummaryRow(
              label: context.l10n.bookingTotal,
              value: _formatPrice(context, totalAmount),
              isTotal: true,
            ),
        ],
      ),
    );
  }
}

class _EventGroup extends StatelessWidget {
  final List<OrderCartItem> items;
  final void Function(String itemId, int quantity)? onUpdateQuantity;
  final void Function(String itemId)? onRemove;
  final String Function(double) formatPrice;

  const _EventGroup({
    required this.items,
    required this.onUpdateQuantity,
    required this.onRemove,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    final firstEvent = items.first.event;
    final eventTotal =
        items.fold<double>(0, (sum, item) => sum + item.lineTotal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                firstEvent.organizerName.isNotEmpty
                    ? firstEvent.organizerName
                    : firstEvent.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: HbColors.textPrimary,
                ),
              ),
            ),
            Text(
              formatPrice(eventTotal),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: HbColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          firstEvent.title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (context.bookingCartItemSlotLabel(items.first).isNotEmpty) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 12, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                context.bookingCartItemSlotLabel(items.first),
                style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _CartLineRow(
              item: item,
              onUpdateQuantity: onUpdateQuantity,
              onRemove: onRemove,
              formatPrice: formatPrice,
            ),
          ),
      ],
    );
  }
}

class _CartLineRow extends StatelessWidget {
  final OrderCartItem item;
  final void Function(String itemId, int quantity)? onUpdateQuantity;
  final void Function(String itemId)? onRemove;
  final String Function(double) formatPrice;

  const _CartLineRow({
    required this.item,
    required this.onUpdateQuantity,
    required this.onRemove,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: ticket name + line total
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.ticket.name,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: HbColors.textPrimary,
                      ),
                    ),
                    Text(
                      context.l10n.bookingPerTicket(
                        '${context.appAmount(item.ticket.buyerPrice)} €',
                      ),
                      style:
                          TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
              Text(
                formatPrice(item.lineTotal),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: HbColors.textPrimary,
                ),
              ),
            ],
          ),
          if (onUpdateQuantity != null || onRemove != null) ...[
            const SizedBox(height: 8),
            // Bottom row: stepper on the left, delete button on the right
            Row(
              children: [
                if (onUpdateQuantity != null) ...[
                  _IconStepperButton(
                    icon: Icons.remove,
                    onTap: item.quantity <= 1
                        ? null
                        : () => onUpdateQuantity!(item.id, item.quantity - 1),
                  ),
                  Container(
                    constraints: const BoxConstraints(minWidth: 24),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    child: Text(
                      '${item.quantity}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: HbColors.textPrimary,
                      ),
                    ),
                  ),
                  _IconStepperButton(
                    icon: Icons.add,
                    onTap: () => onUpdateQuantity!(item.id, item.quantity + 1),
                  ),
                ],
                const Spacer(),
                if (onRemove != null)
                  TextButton.icon(
                    onPressed: () => onRemove!(item.id),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade400,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: Text(
                      context.l10n.bookingRemove,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PriceSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _PriceSummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: HbColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 13,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal ? HbColors.brandPrimary : HbColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _IconStepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _IconStepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Material(
      color: disabled ? Colors.grey.shade100 : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: 16,
            color: disabled ? Colors.grey.shade400 : HbColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/booking/domain/models/order_cart_item.dart';

/// Récapitulatif du panier groupé par événement, avec compteurs +/− et total.
/// Aligné sur le récap sticky du panier desktop (Next.js).
class CartSummarySection extends StatelessWidget {
  final List<OrderCartItem> items;
  final void Function(String itemId, int quantity)? onUpdateQuantity;
  final void Function(String itemId)? onRemove;

  const CartSummarySection({
    super.key,
    required this.items,
    this.onUpdateQuantity,
    this.onRemove,
  });

  String _formatPrice(double value) {
    if (value == value.roundToDouble()) {
      return '${value.toInt()} €';
    }
    return '${value.toStringAsFixed(2).replaceAll('.', ',')} €';
  }

  String _formatSlot(OrderCartItem item) {
    final slot = item.selectedSlot;
    if (slot == null) return '';
    final date =
        '${slot.date.day.toString().padLeft(2, '0')}/${slot.date.month.toString().padLeft(2, '0')}/${slot.date.year}';
    final start = slot.startTime ?? '';
    return start.isEmpty ? date : '$date · $start';
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
    final totalAmount =
        items.fold<double>(0, (sum, item) => sum + item.lineTotal);

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
          const Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 20,
                color: HbColors.brandPrimary,
              ),
              SizedBox(width: 8),
              Text(
                'Recapitulatif',
                style: TextStyle(
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
              formatPrice: _formatPrice,
              formatSlot: _formatSlot,
            ),
            const SizedBox(height: 10),
          ],
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total billets',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: HbColors.textPrimary,
                ),
              ),
              Text(
                _formatPrice(totalAmount),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: HbColors.brandPrimary,
                ),
              ),
            ],
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
  final String Function(OrderCartItem) formatSlot;

  const _EventGroup({
    required this.items,
    required this.onUpdateQuantity,
    required this.onRemove,
    required this.formatPrice,
    required this.formatSlot,
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
        if (formatSlot(items.first).isNotEmpty) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 12, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                formatSlot(items.first),
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.ticket.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: HbColors.textPrimary,
                ),
              ),
              Text(
                '${formatPrice(item.ticket.price)} / billet',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        if (onUpdateQuantity != null) ...[
          _IconStepperButton(
            icon: Icons.remove,
            onTap: item.quantity <= 1
                ? null
                : () => onUpdateQuantity!(item.id, item.quantity - 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: HbColors.textPrimary,
              ),
            ),
          ),
          _IconStepperButton(
            icon: Icons.add,
            onTap: () => onUpdateQuantity!(item.id, item.quantity + 1),
          ),
        ],
        const SizedBox(width: 6),
        Text(
          formatPrice(item.lineTotal),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: HbColors.textPrimary,
          ),
        ),
        if (onRemove != null) ...[
          const SizedBox(width: 4),
          IconButton(
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
            onPressed: () => onRemove!(item.id),
            icon: Icon(Icons.delete_outline,
                size: 18, color: Colors.red.shade400),
          ),
        ],
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
    return InkResponse(
      onTap: onTap,
      radius: 16,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade100 : Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 14,
          color: disabled ? Colors.grey.shade400 : HbColors.textPrimary,
        ),
      ),
    );
  }
}

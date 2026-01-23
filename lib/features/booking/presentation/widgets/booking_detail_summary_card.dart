import 'package:flutter/material.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/core/themes/hb_theme.dart';
import 'package:lehiboo/domain/entities/booking.dart';

class BookingLineItem {
  final String label;
  final int quantity;
  final double unitPrice;
  final String? currency;

  const BookingLineItem({
    required this.label,
    required this.quantity,
    required this.unitPrice,
    this.currency = '€',
  });

  double get totalPrice => quantity * unitPrice;
}

class BookingDetailSummaryCard extends StatelessWidget {
  final List<BookingLineItem> items;
  final double totalPrice;
  final String currency;
  final String? promoCode;
  final double? discount;

  const BookingDetailSummaryCard({
    super.key,
    required this.items,
    required this.totalPrice,
    this.currency = '€',
    this.promoCode,
    this.discount,
  });

  factory BookingDetailSummaryCard.fromBooking(Booking booking) {
    // In a real app, we'd parse booking.items
    // For now, we create a simple line from booking data
    final items = <BookingLineItem>[
      BookingLineItem(
        label: 'Billet',
        quantity: booking.quantity ?? 1,
        unitPrice: (booking.totalPrice ?? 0) / (booking.quantity ?? 1),
        currency: booking.currency ?? '€',
      ),
    ];

    return BookingDetailSummaryCard(
      items: items,
      totalPrice: booking.totalPrice ?? 0,
      currency: booking.currency ?? '€',
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = HbTheme.tokens(context);
    final isFree = totalPrice <= 0;

    return Container(
      padding: EdgeInsets.all(tokens.spacing.m),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  size: 18,
                  color: HbColors.brandPrimary,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'RÉSUMÉ',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: HbColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Line items
          ...items.map((item) => _buildLineItem(item)),
          // Discount if any
          if (discount != null && discount! > 0) ...[
            const SizedBox(height: 8),
            _buildDiscountLine(),
          ],
          const SizedBox(height: 12),
          // Divider
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 12),
          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: HbColors.textPrimary,
                ),
              ),
              Text(
                isFree ? 'Gratuit' : '${totalPrice.toStringAsFixed(2)}$currency',
                style: const TextStyle(
                  fontSize: 20,
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

  Widget _buildLineItem(BookingLineItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${item.quantity}× ${item.label}',
            style: const TextStyle(
              fontSize: 14,
              color: HbColors.textPrimary,
            ),
          ),
          Text(
            '${item.totalPrice.toStringAsFixed(2)}${item.currency}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: HbColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.local_offer, size: 14, color: HbColors.success),
            const SizedBox(width: 6),
            Text(
              promoCode ?? 'Réduction',
              style: const TextStyle(
                fontSize: 14,
                color: HbColors.success,
              ),
            ),
          ],
        ),
        Text(
          '-${discount!.toStringAsFixed(2)}$currency',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: HbColors.success,
          ),
        ),
      ],
    );
  }
}

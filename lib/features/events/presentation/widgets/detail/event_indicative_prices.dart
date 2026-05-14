import 'package:flutter/material.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event_submodels.dart';

/// Informational display of indicative additional service prices.
/// Hidden when the list is empty. Not interactive — purely informational.
class EventIndicativePrices extends StatelessWidget {
  final List<IndicativePrice> prices;

  const EventIndicativePrices({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty) return const SizedBox.shrink();

    final sorted = List<IndicativePrice>.from(prices)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.eventServicesAdditionalTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.eventIndicativePrices,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                for (var i = 0; i < sorted.length; i++) ...[
                  _buildRow(sorted[i]),
                  if (i < sorted.length - 1)
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: Colors.grey.shade200,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(IndicativePrice item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Colors.grey.shade400,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.label,
              style: const TextStyle(
                fontSize: 14,
                color: HbColors.textPrimary,
              ),
            ),
          ),
          Text(
            item.formattedPrice,
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
}

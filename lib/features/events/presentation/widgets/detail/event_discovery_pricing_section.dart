import 'package:flutter/material.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/features/events/domain/entities/event.dart';

/// Pricing summary for discovery-mode events.
///
/// `discovery_pricing_type` classifies the event as free or paid. The
/// primary admission amount comes from the API's localized
/// `pricing.display`, with positive numeric prices used only as a fallback.
/// `indicative_prices` are displayed separately because they describe
/// optional informational services rather than the admission tariff.
class EventDiscoveryPricingSection extends StatelessWidget {
  final Event event;

  const EventDiscoveryPricingSection({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tarification',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: HbColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: _buildPriceContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceContent() {
    switch (event.discoveryPricingType) {
      case 'free':
        return _buildFreeContent();
      case 'paid':
        return _buildPaidContent();
      default:
        return _buildUndefinedContent();
    }
  }

  Widget _buildFreeContent() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: HbColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Gratuit',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: HbColors.success,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Aucun frais d\'entrée',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildPaidContent() {
    final primaryPrice = event.discoveryPaidPriceLabel;
    final indicativePrices = List.of(event.indicativePrices)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Payant',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: HbColors.brandPrimary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                primaryPrice ?? 'Prix non communiqué',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: HbColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
        if (indicativePrices.isNotEmpty) ...[
          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 12),
          Text(
            'Prix indicatifs communiqués par l\'organisateur',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < indicativePrices.length; i++) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    indicativePrices[i].label,
                    style: const TextStyle(
                      fontSize: 14,
                      color: HbColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  indicativePrices[i].formattedPrice,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: HbColors.textPrimary,
                  ),
                ),
              ],
            ),
            if (i < indicativePrices.length - 1)
              Divider(height: 20, color: Colors.grey.shade200),
          ],
        ],
      ],
    );
  }

  Widget _buildUndefinedContent() {
    return Row(
      children: [
        Icon(Icons.info_outline, size: 16, color: Colors.grey.shade400),
        const SizedBox(width: 8),
        Text(
          'Non définie',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

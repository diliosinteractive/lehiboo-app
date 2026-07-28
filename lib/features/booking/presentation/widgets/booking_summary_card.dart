import 'package:flutter/material.dart';
import 'package:lehiboo/core/l10n/l10n.dart';
import 'package:lehiboo/core/widgets/cards/hb_card.dart';
import 'package:lehiboo/features/booking/domain/models/booking_flow_state.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({super.key, required this.state});

  final BookingFlowState state;

  @override
  Widget build(BuildContext context) {
    final totalPrice = state.totalPrice ?? 0;
    final currency = state.currency ?? 'EUR';
    final totalLabel = state.isFree
        ? context.l10n.commonFree
        : '${totalPrice.toStringAsFixed(2)} $currency';

    return HbCard.elevated(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (state.activity.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    state.activity.imageUrl!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.activity.title,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          if (state.selectedSlot != null) ...[
            _RowInfo(
              icon: Icons.calendar_today,
              text: context
                  .appDateFormat(
                    'EEEE d MMMM yyyy HH:mm',
                    enPattern: 'EEEE, MMMM d, yyyy HH:mm',
                  )
                  .format(state.selectedSlot!.startDateTime),
            ),
            const SizedBox(height: 8),
            _RowInfo(
              icon: Icons.people,
              text: context.l10n.bookingLegacyPeopleCount(state.quantity),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.bookingTotal,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  totalLabel,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
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

class _RowInfo extends StatelessWidget {
  const _RowInfo({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

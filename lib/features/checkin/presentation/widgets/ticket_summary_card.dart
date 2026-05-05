import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/colors.dart';
import '../../data/models/ticket_summary_dto.dart';

/// Compact card showing the attendee + event info from a peeked ticket.
/// Used inside both the green/amber confirm sheet and the red blocked sheet.
class TicketSummaryCard extends StatelessWidget {
  final TicketSummaryDto ticket;

  const TicketSummaryCard({super.key, required this.ticket});

  String? _formatSlotStart() {
    final raw = ticket.slotStartDatetime;
    if (raw == null || raw.isEmpty) return null;
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    final fmt = DateFormat("EEE d MMM 'à' HH:mm", 'fr_FR');
    return fmt.format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final attendee = ticket.attendeeFullName;
    final eventTitle = ticket.eventTitle ?? '—';
    final ticketType = ticket.ticketTypeName;
    final slotLabel = _formatSlotStart();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HbColors.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HbColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (attendee.isNotEmpty)
            Text(
              attendee,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: HbColors.textPrimary,
              ),
            ),
          if (attendee.isNotEmpty) const SizedBox(height: 4),
          Text(
            eventTitle,
            style: const TextStyle(
              fontSize: 14,
              color: HbColors.textSecondary,
            ),
          ),
          if (ticketType != null && ticketType.isNotEmpty) ...[
            const SizedBox(height: 8),
            _Chip(icon: Icons.confirmation_number_outlined, label: ticketType),
          ],
          if (slotLabel != null) ...[
            const SizedBox(height: 6),
            _Chip(icon: Icons.schedule, label: slotLabel),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: HbColors.textSecondary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: HbColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

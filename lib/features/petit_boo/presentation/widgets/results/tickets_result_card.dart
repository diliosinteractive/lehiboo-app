import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/themes/colors.dart';
import '../../../data/models/tool_result_dto.dart';

/// Card displaying ticket results from getMyTickets tool
class TicketsResultCard extends StatelessWidget {
  final TicketsToolResult result;

  const TicketsResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    if (result.tickets.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: HbColors.brandSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.qr_code_2,
                    color: HbColors.brandSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Tickets',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: HbColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${result.total} ticket${result.total != 1 ? 's' : ''}'
                        '${result.activeCount > 0 ? ' • ${result.activeCount} active' : ''}',
                        style: TextStyle(
                          fontSize: 13,
                          color: HbColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Ticket items (show max 3)
          ...result.tickets.take(3).map((ticket) => _TicketItem(ticket: ticket)),

          // Show more button
          if (result.tickets.length > 3)
            InkWell(
              onTap: () => context.push('/my-tickets'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View all ${result.total} tickets',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: HbColors.brandPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: HbColors.brandPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HbColors.orangePastel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.qr_code_2,
            color: HbColors.brandSecondary.withOpacity(0.5),
            size: 24,
          ),
          const SizedBox(width: 12),
          const Text(
            'No tickets yet',
            style: TextStyle(
              fontSize: 14,
              color: HbColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketItem extends StatelessWidget {
  final TicketResultItem ticket;

  const _TicketItem({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isActive = ticket.status.toLowerCase() == 'active';

    return InkWell(
      onTap: () => context.push('/ticket/${ticket.uuid}'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // QR code preview
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isActive ? HbColors.brandSecondary.withOpacity(0.1) : Colors.grey.shade100,
              ),
              child: Icon(
                Icons.qr_code_2,
                color: isActive ? HbColors.brandSecondary : Colors.grey,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),

            // Ticket details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ticket.eventTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: HbColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (ticket.ticketType != null) ...[
                        Text(
                          ticket.ticketType!,
                          style: TextStyle(
                            fontSize: 12,
                            color: HbColors.textSecondary,
                          ),
                        ),
                        const Text(' • ', style: TextStyle(color: Colors.grey)),
                      ],
                      if (ticket.slotDate != null)
                        Text(
                          ticket.slotDate!,
                          style: TextStyle(
                            fontSize: 12,
                            color: HbColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                  if (ticket.attendeeName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      ticket.attendeeName!,
                      style: TextStyle(
                        fontSize: 11,
                        color: HbColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right,
              color: HbColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

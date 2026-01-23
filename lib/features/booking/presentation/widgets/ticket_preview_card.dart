import 'package:flutter/material.dart';
import 'package:lehiboo/core/themes/colors.dart';
import 'package:lehiboo/domain/entities/booking.dart';

enum TicketStatus {
  active,
  used,
  cancelled,
  expired,
}

extension TicketStatusExtension on TicketStatus {
  String get label {
    switch (this) {
      case TicketStatus.active:
        return 'Actif';
      case TicketStatus.used:
        return 'Utilisé';
      case TicketStatus.cancelled:
        return 'Annulé';
      case TicketStatus.expired:
        return 'Expiré';
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.active:
        return HbColors.success;
      case TicketStatus.used:
        return HbColors.brandSecondary;
      case TicketStatus.cancelled:
        return HbColors.error;
      case TicketStatus.expired:
        return Colors.grey;
    }
  }

  static TicketStatus fromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return TicketStatus.active;
      case 'used':
        return TicketStatus.used;
      case 'cancelled':
        return TicketStatus.cancelled;
      case 'expired':
        return TicketStatus.expired;
      default:
        return TicketStatus.active;
    }
  }
}

class TicketPreviewCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback? onTap;
  final String? attendeeName;
  final String? ticketTypeName;

  const TicketPreviewCard({
    super.key,
    required this.ticket,
    this.onTap,
    this.attendeeName,
    this.ticketTypeName,
  });

  @override
  Widget build(BuildContext context) {
    final status = TicketStatusExtension.fromString(ticket.status);
    final displayName = attendeeName ?? 'Participant';
    final displayType = ticketTypeName ?? ticket.ticketType ?? 'Standard';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // QR icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: HbColors.brandPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.qr_code_2,
                color: HbColors.brandPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Ticket info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayType,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: HbColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: HbColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: status.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: status.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    status.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: status.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Arrow
            Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

class TicketsSection extends StatelessWidget {
  final List<Ticket> tickets;
  final Function(Ticket) onTicketTap;
  final VoidCallback? onDownloadAll;

  const TicketsSection({
    super.key,
    required this.tickets,
    required this.onTicketTap,
    this.onDownloadAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: HbColors.brandPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.confirmation_number_outlined,
                  size: 18,
                  color: HbColors.brandPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'MES BILLETS (${tickets.length})',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: HbColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tickets list
          ...tickets.asMap().entries.map((entry) {
            final index = entry.key;
            final ticket = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < tickets.length - 1 ? 10 : 0,
              ),
              child: TicketPreviewCard(
                ticket: ticket,
                onTap: () => onTicketTap(ticket),
                attendeeName: 'Participant ${index + 1}',
              ),
            );
          }),
          // Download all button
          if (onDownloadAll != null && tickets.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onDownloadAll,
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Télécharger tous les billets'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: HbColors.brandPrimary,
                  side: const BorderSide(color: HbColors.brandPrimary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

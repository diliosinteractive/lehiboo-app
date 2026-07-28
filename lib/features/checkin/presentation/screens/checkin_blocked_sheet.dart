import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../data/models/ticket_summary_dto.dart';
import '../../domain/entities/checkin_blocker.dart';
import '../widgets/ticket_summary_card.dart';

/// Red bottom sheet shown when a ticket can't be checked in. The CTA is
/// close-only — no confirm path.
Future<void> showCheckinBlockedSheet(
  BuildContext context, {
  required CheckinBlocker reason,
  TicketSummaryDto? ticket,
  String? extraMessage,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _BlockedSheetContent(
      reason: reason,
      ticket: ticket,
      extraMessage: extraMessage,
    ),
  );
}

class _BlockedSheetContent extends StatelessWidget {
  final CheckinBlocker reason;
  final TicketSummaryDto? ticket;
  final String? extraMessage;

  const _BlockedSheetContent({
    required this.reason,
    this.ticket,
    this.extraMessage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: HbColors.grey200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: HbColors.error.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.block,
                  color: HbColors.error,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  reason.localizedTitle(l10n),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: HbColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            reason.localizedSubtitle(l10n),
            style: const TextStyle(
              fontSize: 14,
              color: HbColors.textPrimary,
            ),
          ),
          if (extraMessage != null && extraMessage!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              extraMessage!,
              style: const TextStyle(
                fontSize: 13,
                color: HbColors.textSecondary,
              ),
            ),
          ],
          if (ticket != null) ...[
            const SizedBox(height: 16),
            TicketSummaryCard(ticket: ticket!),
          ],
          const SizedBox(height: 20),
          FilledButton(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonClose),
          ),
        ],
      ),
    );
  }
}

extension _CheckinBlockerCopy on CheckinBlocker {
  String localizedTitle(AppLocalizations l10n) => switch (this) {
        CheckinBlocker.ticketCancelled =>
          l10n.checkinBlockedTicketCancelledTitle,
        CheckinBlocker.ticketRefunded => l10n.checkinBlockedTicketRefundedTitle,
        CheckinBlocker.ticketTransferred =>
          l10n.checkinBlockedTicketTransferredTitle,
        CheckinBlocker.slotNotStarted => l10n.checkinBlockedSlotNotStartedTitle,
        CheckinBlocker.wrongEvent => l10n.checkinBlockedWrongEventTitle,
        CheckinBlocker.unauthorized => l10n.checkinBlockedUnauthorizedTitle,
        CheckinBlocker.ticketNotFound => l10n.checkinBlockedTicketNotFoundTitle,
        CheckinBlocker.unknown => l10n.checkinBlockedUnknownTitle,
      };

  String localizedSubtitle(AppLocalizations l10n) => switch (this) {
        CheckinBlocker.ticketCancelled => l10n.checkinBlockedDoNotAdmit,
        CheckinBlocker.ticketRefunded => l10n.checkinBlockedDoNotAdmit,
        CheckinBlocker.ticketTransferred =>
          l10n.checkinBlockedTicketTransferredBody,
        CheckinBlocker.slotNotStarted => l10n.checkinBlockedSlotNotStartedBody,
        CheckinBlocker.wrongEvent => l10n.checkinBlockedWrongEventBody,
        CheckinBlocker.unauthorized => l10n.checkinBlockedUnauthorizedBody,
        CheckinBlocker.ticketNotFound => l10n.checkinBlockedTicketNotFoundBody,
        CheckinBlocker.unknown => l10n.checkinBlockedUnknownBody,
      };
}

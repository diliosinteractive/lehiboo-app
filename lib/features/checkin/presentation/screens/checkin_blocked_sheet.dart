import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/ticket_summary_dto.dart';
import '../../domain/entities/checkin_blocker.dart';
import '../widgets/ticket_summary_card.dart';

/// Red bottom sheet shown when a ticket can't be checked in. The CTA is
/// close-only — no confirm path.
Future<void> showCheckinBlockedSheet(
  BuildContext context, {
  required String ownerAccountId,
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
      ownerAccountId: ownerAccountId,
      reason: reason,
      ticket: ticket,
      extraMessage: extraMessage,
    ),
  );
}

class _BlockedSheetContent extends ConsumerStatefulWidget {
  final String ownerAccountId;
  final CheckinBlocker reason;
  final TicketSummaryDto? ticket;
  final String? extraMessage;

  const _BlockedSheetContent({
    required this.ownerAccountId,
    required this.reason,
    this.ticket,
    this.extraMessage,
  });

  @override
  ConsumerState<_BlockedSheetContent> createState() =>
      _BlockedSheetContentState();
}

class _BlockedSheetContentState extends ConsumerState<_BlockedSheetContent> {
  bool _invalid = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual<String?>(authSessionUserIdProvider, (_, next) {
      if (next == widget.ownerAccountId || _invalid) return;
      _invalid = true;
      if (!mounted) return;
      final navigator = Navigator.of(context);
      if (navigator.canPop()) navigator.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentAccountId = ref.watch(authSessionUserIdProvider);
    if (_invalid || currentAccountId != widget.ownerAccountId) {
      return const SizedBox.shrink();
    }

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
                  widget.reason.localizedTitle(l10n),
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
            widget.reason.localizedSubtitle(l10n),
            style: const TextStyle(
              fontSize: 14,
              color: HbColors.textPrimary,
            ),
          ),
          if (widget.extraMessage != null &&
              widget.extraMessage!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.extraMessage!,
              style: const TextStyle(
                fontSize: 13,
                color: HbColors.textSecondary,
              ),
            ),
          ],
          if (widget.ticket != null) ...[
            const SizedBox(height: 16),
            TicketSummaryCard(ticket: widget.ticket!),
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

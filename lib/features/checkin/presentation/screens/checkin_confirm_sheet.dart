import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/ticket_summary_dto.dart';
import '../widgets/ticket_summary_card.dart';

/// Bottom sheet shown after a successful peek (green or amber). Returns
/// `true` when the vendor confirms — the screen then commits.
///
/// `isReEntry` drives the amber styling and re-entry copy.
Future<bool?> showCheckinConfirmSheet(
  BuildContext context, {
  required String ownerAccountId,
  required TicketSummaryDto ticket,
  required bool isReEntry,
  bool isCommitting = false,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    isDismissible: !isCommitting,
    enableDrag: !isCommitting,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _ConfirmSheetContent(
      ownerAccountId: ownerAccountId,
      ticket: ticket,
      isReEntry: isReEntry,
    ),
  );
}

class _ConfirmSheetContent extends ConsumerStatefulWidget {
  final String ownerAccountId;
  final TicketSummaryDto ticket;
  final bool isReEntry;

  const _ConfirmSheetContent({
    required this.ownerAccountId,
    required this.ticket,
    required this.isReEntry,
  });

  @override
  ConsumerState<_ConfirmSheetContent> createState() =>
      _ConfirmSheetContentState();
}

class _ConfirmSheetContentState extends ConsumerState<_ConfirmSheetContent> {
  bool _invalid = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual<String?>(authSessionUserIdProvider, (_, next) {
      if (next == widget.ownerAccountId || _invalid) return;
      _invalid = true;
      if (!mounted) return;
      final navigator = Navigator.of(context);
      if (navigator.canPop()) navigator.pop(false);
    });
  }

  bool get _ownsCurrentSession =>
      !_invalid && ref.read(authSessionUserIdProvider) == widget.ownerAccountId;

  @override
  Widget build(BuildContext context) {
    final currentAccountId = ref.watch(authSessionUserIdProvider);
    if (_invalid || currentAccountId != widget.ownerAccountId) {
      return const SizedBox.shrink();
    }

    final color = widget.isReEntry ? HbColors.warning : HbColors.success;
    final icon = widget.isReEntry ? Icons.repeat : Icons.check_circle;
    final l10n = context.l10n;
    final title = widget.isReEntry
        ? l10n.checkinReEntryDetectedTitle
        : l10n.checkinValidTicketTitle;
    final ctaLabel = widget.isReEntry
        ? l10n.checkinConfirmReEntry
        : l10n.checkinConfirmEntry;

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
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: HbColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          if (widget.isReEntry) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: HbColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l10n.checkinAlreadyEnteredWarning(widget.ticket.checkInCount),
                style: const TextStyle(
                  fontSize: 13,
                  color: HbColors.textPrimary,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          TicketSummaryCard(ticket: widget.ticket),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (!_ownsCurrentSession) return;
                    Navigator.of(context).pop(false);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(l10n.commonCancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    if (!_ownsCurrentSession) return;
                    Navigator.of(context).pop(true);
                  },
                  child: Text(ctaLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

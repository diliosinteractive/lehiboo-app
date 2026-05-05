import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../data/models/ticket_summary_dto.dart';
import '../widgets/ticket_summary_card.dart';

/// Bottom sheet shown after a successful peek (green or amber). Returns
/// `true` when the vendor confirms — the screen then commits.
///
/// `isReEntry` drives the amber styling and re-entry copy.
Future<bool?> showCheckinConfirmSheet(
  BuildContext context, {
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
      ticket: ticket,
      isReEntry: isReEntry,
    ),
  );
}

class _ConfirmSheetContent extends StatelessWidget {
  final TicketSummaryDto ticket;
  final bool isReEntry;

  const _ConfirmSheetContent({
    required this.ticket,
    required this.isReEntry,
  });

  @override
  Widget build(BuildContext context) {
    final color = isReEntry ? HbColors.warning : HbColors.success;
    final icon = isReEntry ? Icons.repeat : Icons.check_circle;
    final title = isReEntry ? 'Ré-entrée détectée' : 'Billet valide';
    final ctaLabel =
        isReEntry ? 'Confirmer la ré-entrée' : "Confirmer l'entrée";

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
          if (isReEntry) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: HbColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Déjà entré ${ticket.checkInCount}× — vérifiez avant d\'admettre.',
                style: const TextStyle(
                  fontSize: 13,
                  color: HbColors.textPrimary,
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          TicketSummaryCard(ticket: ticket),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Annuler'),
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
                  onPressed: () => Navigator.of(context).pop(true),
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

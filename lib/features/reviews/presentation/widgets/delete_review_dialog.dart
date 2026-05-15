import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';

/// Dialog de confirmation pour la suppression d'un avis.
/// Renvoie `true` si l'utilisateur confirme.
class DeleteReviewDialog extends StatelessWidget {
  const DeleteReviewDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteReviewDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(context.l10n.reviewsDeleteConfirmTitle),
      content: Text(
        context.l10n.reviewsDeleteConfirmBody,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            context.l10n.commonCancel,
            style: const TextStyle(color: HbColors.textPrimary),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red.shade600,
          ),
          child: Text(context.l10n.reviewsDeleteAction),
        ),
      ],
    );
  }
}

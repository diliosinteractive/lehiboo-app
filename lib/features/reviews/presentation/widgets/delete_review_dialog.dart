import 'package:flutter/material.dart';

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
      title: const Text('Supprimer cet avis ?'),
      content: const Text(
        'Cette action est définitive. Vous pourrez en écrire un nouveau '
        'plus tard.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Annuler',
            style: TextStyle(color: HbColors.textPrimary),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red.shade600,
          ),
          child: const Text('Supprimer'),
        ),
      ],
    );
  }
}

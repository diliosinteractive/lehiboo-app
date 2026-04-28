import 'package:flutter/material.dart';

import '../../../../core/themes/colors.dart';
import '../../domain/entities/can_review_result.dart';
import '../../domain/entities/review_enums.dart';

/// Affiche un message contextuel quand l'utilisateur ne peut pas laisser
/// d'avis. Si la raison est `alreadyReviewed`, propose un lien "Voir mon avis".
class CanReviewMessage extends StatelessWidget {
  final CanReviewDenied denied;
  final VoidCallback? onViewMyReview;

  const CanReviewMessage({
    super.key,
    required this.denied,
    this.onViewMyReview,
  });

  @override
  Widget build(BuildContext context) {
    final reason = denied.reason;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HbColors.brandPrimary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: HbColors.brandPrimary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(reason.icon, size: 20, color: HbColors.brandPrimary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  reason.displayMessage,
                  style: const TextStyle(
                    fontSize: 13,
                    color: HbColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          if (reason == CanReviewReason.alreadyReviewed &&
              onViewMyReview != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onViewMyReview,
                style: TextButton.styleFrom(
                  foregroundColor: HbColors.brandPrimary,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 32),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Voir mon avis →'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/api_response_handler.dart';
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
                  _reasonMessage(context, reason),
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
                child: Text(context.l10n.reviewsViewMyReviewAction),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _reasonMessage(BuildContext context, CanReviewReason reason) {
    switch (reason) {
      case CanReviewReason.alreadyReviewed:
        return context.l10n.reviewsCannotReviewAlreadyReviewed;
      case CanReviewReason.organizerCannotReview:
        return context.l10n.reviewsCannotReviewOrganizer;
      case CanReviewReason.eventNotEnded:
        return context.l10n.reviewsCannotReviewEventNotEnded;
      case CanReviewReason.notParticipated:
        return context.l10n.reviewsCannotReviewNotParticipated;
      case CanReviewReason.unknown:
        return context.l10n.reviewsCannotReviewUnknown;
    }
  }
}

/// Keeps review eligibility failures distinct from a legitimate denial.
///
/// Until this request succeeds the caller must not expose a write-review CTA:
/// an error does not prove that the user is eligible or has no existing review.
class CanReviewLoadError extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const CanReviewLoadError({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HbColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HbColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_outlined, color: HbColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              ApiResponseHandler.extractError(
                error,
                fallback: context.l10n.reviewsEligibilityLoadError,
              ),
              style: const TextStyle(
                fontSize: 13,
                color: HbColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onRetry,
            child: Text(context.l10n.commonRetry),
          ),
        ],
      ),
    );
  }
}

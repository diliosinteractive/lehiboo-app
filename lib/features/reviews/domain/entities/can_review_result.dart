import 'package:equatable/equatable.dart';

import 'review.dart';
import 'review_enums.dart';

/// Résultat de l'endpoint GET /events/{slug}/reviews/can-review
sealed class CanReviewResult extends Equatable {
  const CanReviewResult();
}

/// L'utilisateur peut laisser un avis
class CanReviewAllowed extends CanReviewResult {
  final bool hasAttended;
  final bool isVerifiedPurchase;

  const CanReviewAllowed({
    this.hasAttended = true,
    this.isVerifiedPurchase = true,
  });

  @override
  List<Object?> get props => [hasAttended, isVerifiedPurchase];
}

/// L'utilisateur ne peut pas laisser d'avis
class CanReviewDenied extends CanReviewResult {
  final CanReviewReason reason;
  final bool hasAttended;
  final bool isVerifiedPurchase;

  /// Présent uniquement si reason == alreadyReviewed
  final Review? existingReview;

  /// Présent uniquement si reason == alreadyReviewed
  final ReviewStatus? reviewStatus;

  const CanReviewDenied({
    required this.reason,
    this.hasAttended = false,
    this.isVerifiedPurchase = false,
    this.existingReview,
    this.reviewStatus,
  });

  @override
  List<Object?> get props =>
      [reason, hasAttended, isVerifiedPurchase, existingReview, reviewStatus];
}

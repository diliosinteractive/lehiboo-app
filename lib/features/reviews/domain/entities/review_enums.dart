import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';

/// Statut de modération d'un avis (cf. spec REVIEWS_API_MOBILE.md §1)
enum ReviewStatus {
  pending,
  approved,
  rejected;

  static ReviewStatus fromString(String? value) {
    switch (value) {
      case 'approved':
        return ReviewStatus.approved;
      case 'rejected':
        return ReviewStatus.rejected;
      case 'pending':
      default:
        return ReviewStatus.pending;
    }
  }

  String get apiValue {
    switch (this) {
      case ReviewStatus.pending:
        return 'pending';
      case ReviewStatus.approved:
        return 'approved';
      case ReviewStatus.rejected:
        return 'rejected';
    }
  }

  String get displayLabel {
    final l10n = cachedAppLocalizations();
    switch (this) {
      case ReviewStatus.pending:
        return l10n.reviewsStatusPending;
      case ReviewStatus.approved:
        return l10n.reviewsStatusApproved;
      case ReviewStatus.rejected:
        return l10n.reviewsStatusRejected;
    }
  }

  Color get color {
    switch (this) {
      case ReviewStatus.pending:
        return const Color(0xFFF39C12);
      case ReviewStatus.approved:
        return const Color(0xFF27AE60);
      case ReviewStatus.rejected:
        return const Color(0xFFE74C3C);
    }
  }

  IconData get icon {
    switch (this) {
      case ReviewStatus.pending:
        return Icons.schedule;
      case ReviewStatus.approved:
        return Icons.check_circle;
      case ReviewStatus.rejected:
        return Icons.cancel;
    }
  }
}

/// Raison pour laquelle l'utilisateur ne peut pas laisser d'avis
enum CanReviewReason {
  alreadyReviewed,
  organizerCannotReview,
  eventNotEnded,
  notParticipated,
  unknown;

  static CanReviewReason fromString(String? value) {
    switch (value) {
      case 'already_reviewed':
        return CanReviewReason.alreadyReviewed;
      case 'organizer_cannot_review':
        return CanReviewReason.organizerCannotReview;
      case 'event_not_ended':
        return CanReviewReason.eventNotEnded;
      case 'not_participated':
        return CanReviewReason.notParticipated;
      default:
        return CanReviewReason.unknown;
    }
  }

  String get displayMessage {
    final l10n = cachedAppLocalizations();
    switch (this) {
      case CanReviewReason.alreadyReviewed:
        return l10n.reviewsCannotReviewAlreadyReviewed;
      case CanReviewReason.organizerCannotReview:
        return l10n.reviewsCannotReviewOrganizer;
      case CanReviewReason.eventNotEnded:
        return l10n.reviewsCannotReviewEventNotEnded;
      case CanReviewReason.notParticipated:
        return l10n.reviewsCannotReviewNotParticipated;
      case CanReviewReason.unknown:
        return l10n.reviewsCannotReviewUnknown;
    }
  }

  IconData get icon {
    switch (this) {
      case CanReviewReason.alreadyReviewed:
        return Icons.check_circle_outline;
      case CanReviewReason.organizerCannotReview:
        return Icons.business_center_outlined;
      case CanReviewReason.eventNotEnded:
        return Icons.event_outlined;
      case CanReviewReason.notParticipated:
        return Icons.confirmation_number_outlined;
      case CanReviewReason.unknown:
        return Icons.info_outline;
    }
  }
}

/// Raison de signalement d'un avis (cf. spec §2.8)
enum ReportReason {
  spam,
  inappropriate,
  fake,
  offensive,
  other;

  String get apiValue {
    switch (this) {
      case ReportReason.spam:
        return 'spam';
      case ReportReason.inappropriate:
        return 'inappropriate';
      case ReportReason.fake:
        return 'fake';
      case ReportReason.offensive:
        return 'offensive';
      case ReportReason.other:
        return 'other';
    }
  }

  String get displayLabel {
    final l10n = cachedAppLocalizations();
    switch (this) {
      case ReportReason.spam:
        return l10n.reviewsReportReasonSpam;
      case ReportReason.inappropriate:
        return l10n.reviewsReportReasonInappropriate;
      case ReportReason.fake:
        return l10n.reviewsReportReasonFake;
      case ReportReason.offensive:
        return l10n.reviewsReportReasonOffensive;
      case ReportReason.other:
        return l10n.reviewsReportReasonOther;
    }
  }
}

/// Tri d'une liste d'avis (cf. spec §1.1)
enum ReviewSortBy {
  helpful,
  rating,
  createdAt;

  String get apiValue {
    switch (this) {
      case ReviewSortBy.helpful:
        return 'helpful';
      case ReviewSortBy.rating:
        return 'rating';
      case ReviewSortBy.createdAt:
        return 'created_at';
    }
  }

  String get displayLabel {
    final l10n = cachedAppLocalizations();
    switch (this) {
      case ReviewSortBy.helpful:
        return l10n.reviewsSortMostHelpful;
      case ReviewSortBy.rating:
        return l10n.reviewsSortRating;
      case ReviewSortBy.createdAt:
        return l10n.reviewsSortNewest;
    }
  }
}

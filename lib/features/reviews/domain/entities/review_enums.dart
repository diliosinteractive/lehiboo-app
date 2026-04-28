import 'package:flutter/material.dart';

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
    switch (this) {
      case ReviewStatus.pending:
        return 'En attente';
      case ReviewStatus.approved:
        return 'Publié';
      case ReviewStatus.rejected:
        return 'Refusé';
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
    switch (this) {
      case CanReviewReason.alreadyReviewed:
        return 'Vous avez déjà laissé un avis sur cet événement.';
      case CanReviewReason.organizerCannotReview:
        return 'Vous ne pouvez pas noter vos propres événements.';
      case CanReviewReason.eventNotEnded:
        return 'Vous pourrez laisser un avis une fois l\'événement passé.';
      case CanReviewReason.notParticipated:
        return 'Seuls les participants à l\'événement peuvent laisser un avis.';
      case CanReviewReason.unknown:
        return 'Vous ne pouvez pas laisser d\'avis pour le moment.';
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
    switch (this) {
      case ReportReason.spam:
        return 'Spam';
      case ReportReason.inappropriate:
        return 'Contenu inapproprié';
      case ReportReason.fake:
        return 'Faux avis';
      case ReportReason.offensive:
        return 'Propos offensants';
      case ReportReason.other:
        return 'Autre';
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
    switch (this) {
      case ReviewSortBy.helpful:
        return 'Plus utiles';
      case ReviewSortBy.rating:
        return 'Note';
      case ReviewSortBy.createdAt:
        return 'Plus récents';
    }
  }
}

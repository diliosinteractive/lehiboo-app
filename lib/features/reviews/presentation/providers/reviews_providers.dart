import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_session_key_provider.dart';
import '../../domain/entities/can_review_result.dart';
import '../../domain/entities/paginated_reviews.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/repositories/reviews_repository.dart';

/// Paramètres pour la liste paginée d'avis d'un événement (clé du family).
class EventReviewsParams {
  final String eventSlug;
  final AuthSessionKey ownerSession;
  final ReviewsQuery query;

  const EventReviewsParams({
    required this.eventSlug,
    required this.ownerSession,
    this.query = const ReviewsQuery(),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventReviewsParams &&
          eventSlug == other.eventSlug &&
          identical(ownerSession, other.ownerSession) &&
          query == other.query;

  @override
  int get hashCode => Object.hash(eventSlug, ownerSession, query);
}

/// Exact identity key for the authenticated eligibility endpoint.
///
/// `can-review` can contain both an account-specific decision and the user's
/// existing review. Keeping the opaque session in the family key also prevents
/// an old A element from being reused after an A -> B -> A cycle.
class CanReviewParams {
  final String eventSlug;
  final AuthSessionKey ownerSession;

  const CanReviewParams({
    required this.eventSlug,
    required this.ownerSession,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CanReviewParams &&
          eventSlug == other.eventSlug &&
          identical(ownerSession, other.ownerSession);

  @override
  int get hashCode => Object.hash(eventSlug, ownerSession);
}

/// Liste paginée d'avis d'un événement (autoDispose pour libérer la mémoire).
final eventReviewsProvider = FutureProvider.autoDispose
    .family<PaginatedReviews, EventReviewsParams>((ref, params) async {
  var disposed = false;
  ref.onDispose(() => disposed = true);
  final activeSession = ref.watch(authSessionKeyProvider);
  if (!identical(activeSession, params.ownerSession)) {
    throw StateError('Review request no longer belongs to this account.');
  }
  final repo = ref.watch(reviewsRepositoryProvider);
  final page =
      await repo.getEventReviews(params.eventSlug, query: params.query);
  if (disposed ||
      !identical(ref.read(authSessionKeyProvider), params.ownerSession)) {
    throw StateError('Review request no longer belongs to this account.');
  }
  return page;
});

/// Stats agrégées des avis d'un événement.
final eventReviewStatsProvider = FutureProvider.autoDispose
    .family<ReviewStats, String>((ref, eventSlug) async {
  final repo = ref.watch(reviewsRepositoryProvider);
  return repo.getEventReviewStats(eventSlug);
});

/// Vérifie si l'utilisateur connecté peut laisser un avis sur cet événement.
final canReviewProvider = FutureProvider.autoDispose
    .family<CanReviewResult, CanReviewParams>((ref, params) async {
  var disposed = false;
  ref.onDispose(() => disposed = true);
  final activeSession = ref.watch(authSessionKeyProvider);
  if (!identical(activeSession, params.ownerSession)) {
    throw StateError('Review eligibility no longer belongs to this account.');
  }
  final repo = ref.watch(reviewsRepositoryProvider);
  final result = await repo.canReview(params.eventSlug);
  if (disposed ||
      !identical(ref.read(authSessionKeyProvider), params.ownerSession)) {
    throw StateError('Review eligibility no longer belongs to this account.');
  }
  return result;
});

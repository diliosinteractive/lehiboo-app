import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/can_review_result.dart';
import '../../domain/entities/paginated_reviews.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/repositories/reviews_repository.dart';

/// Paramètres pour la liste paginée d'avis d'un événement (clé du family).
class EventReviewsParams {
  final String eventSlug;
  final ReviewsQuery query;

  const EventReviewsParams({
    required this.eventSlug,
    this.query = const ReviewsQuery(),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventReviewsParams &&
          eventSlug == other.eventSlug &&
          query == other.query;

  @override
  int get hashCode => Object.hash(eventSlug, query);
}

/// Liste paginée d'avis d'un événement (autoDispose pour libérer la mémoire).
final eventReviewsProvider = FutureProvider.autoDispose
    .family<PaginatedReviews, EventReviewsParams>((ref, params) async {
  final repo = ref.watch(reviewsRepositoryProvider);
  return repo.getEventReviews(params.eventSlug, query: params.query);
});

/// Stats agrégées des avis d'un événement.
final eventReviewStatsProvider = FutureProvider.autoDispose
    .family<ReviewStats, String>((ref, eventSlug) async {
  final repo = ref.watch(reviewsRepositoryProvider);
  return repo.getEventReviewStats(eventSlug);
});

/// Vérifie si l'utilisateur connecté peut laisser un avis sur cet événement.
final canReviewProvider = FutureProvider.autoDispose
    .family<CanReviewResult, String>((ref, eventSlug) async {
  final repo = ref.watch(reviewsRepositoryProvider);
  return repo.canReview(eventSlug);
});

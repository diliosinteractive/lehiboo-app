import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/can_review_result.dart';
import '../entities/paginated_reviews.dart';
import '../entities/review.dart';
import '../entities/review_enums.dart';
import '../entities/review_stats.dart';

/// Paramètres de requête pour la liste paginée d'avis d'un événement
class ReviewsQuery {
  final int page;
  final int perPage;
  final int? rating;
  final bool verifiedOnly;
  final bool featuredOnly;
  final ReviewSortBy sortBy;
  final bool descending;

  const ReviewsQuery({
    this.page = 1,
    this.perPage = 10,
    this.rating,
    this.verifiedOnly = false,
    this.featuredOnly = false,
    this.sortBy = ReviewSortBy.helpful,
    this.descending = true,
  });

  ReviewsQuery copyWith({
    int? page,
    int? perPage,
    Object? rating = _sentinel,
    bool? verifiedOnly,
    bool? featuredOnly,
    ReviewSortBy? sortBy,
    bool? descending,
  }) {
    return ReviewsQuery(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      rating: identical(rating, _sentinel) ? this.rating : rating as int?,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      featuredOnly: featuredOnly ?? this.featuredOnly,
      sortBy: sortBy ?? this.sortBy,
      descending: descending ?? this.descending,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewsQuery &&
          page == other.page &&
          perPage == other.perPage &&
          rating == other.rating &&
          verifiedOnly == other.verifiedOnly &&
          featuredOnly == other.featuredOnly &&
          sortBy == other.sortBy &&
          descending == other.descending;

  @override
  int get hashCode => Object.hash(
        page,
        perPage,
        rating,
        verifiedOnly,
        featuredOnly,
        sortBy,
        descending,
      );
}

const Object _sentinel = Object();

abstract class ReviewsRepository {
  // Public (non auth)
  Future<PaginatedReviews> getEventReviews(
    String eventSlug, {
    ReviewsQuery query,
  });

  Future<ReviewStats> getEventReviewStats(String eventSlug);

  // Auth
  Future<CanReviewResult> canReview(String eventSlug);

  Future<Review> createReview(
    String eventSlug, {
    required int rating,
    required String title,
    required String comment,
    String? bookingUuid,
  });

  Future<Review> getReview(String reviewUuid);

  Future<Review> updateReview(
    String reviewUuid, {
    int? rating,
    String? title,
    String? comment,
  });

  Future<void> deleteReview(String reviewUuid);

  Future<VoteCounts> voteReview(String reviewUuid, {required bool isHelpful});

  Future<VoteCounts> unvoteReview(String reviewUuid);

  Future<void> reportReview(
    String reviewUuid, {
    required ReportReason reason,
    String? details,
  });

  Future<PaginatedUserReviews> getUserReviews({int page = 1, int perPage = 10});

  Future<int> getPendingCount();
}

/// Provider stub overrides dans `main.dart` (cf. favoritesRepositoryProvider).
final reviewsRepositoryProvider = Provider<ReviewsRepository>((ref) {
  throw UnimplementedError('reviewsRepositoryProvider not initialized');
});

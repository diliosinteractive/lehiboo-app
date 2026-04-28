import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/can_review_result.dart';
import '../../domain/entities/paginated_reviews.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/review_enums.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/repositories/reviews_repository.dart';
import '../datasources/reviews_api_datasource.dart';
import '../mappers/review_mapper.dart';

/// Provider de l'implémentation. Override dans `main.dart` :
///
/// ```dart
/// reviewsRepositoryProvider.overrideWith(
///   (ref) => ref.read(reviewsRepositoryImplProvider),
/// );
/// ```
final reviewsRepositoryImplProvider = Provider<ReviewsRepository>((ref) {
  final dataSource = ref.read(reviewsApiDataSourceProvider);
  return ReviewsRepositoryImpl(dataSource);
});

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsApiDataSource _dataSource;

  ReviewsRepositoryImpl(this._dataSource);

  @override
  Future<PaginatedReviews> getEventReviews(
    String eventSlug, {
    ReviewsQuery query = const ReviewsQuery(),
  }) async {
    final dto = await _dataSource.getEventReviews(
      eventSlug,
      page: query.page,
      perPage: query.perPage,
      rating: query.rating,
      verifiedOnly: query.verifiedOnly,
      featuredOnly: query.featuredOnly,
      sortBy: query.sortBy.apiValue,
      sortOrder: query.descending ? 'desc' : 'asc',
    );
    return ReviewMapper.toPaginatedReviews(dto);
  }

  @override
  Future<ReviewStats> getEventReviewStats(String eventSlug) async {
    final dto = await _dataSource.getEventReviewStats(eventSlug);
    return ReviewMapper.toStats(dto);
  }

  @override
  Future<CanReviewResult> canReview(String eventSlug) async {
    final dto = await _dataSource.canReview(eventSlug);
    return ReviewMapper.toCanReviewResult(dto);
  }

  @override
  Future<Review> createReview(
    String eventSlug, {
    required int rating,
    required String title,
    required String comment,
    String? bookingUuid,
  }) async {
    final dto = await _dataSource.createReview(
      eventSlug,
      rating: rating,
      title: title,
      comment: comment,
      bookingUuid: bookingUuid,
    );
    return ReviewMapper.toReview(dto);
  }

  @override
  Future<Review> getReview(String reviewUuid) async {
    final dto = await _dataSource.getReview(reviewUuid);
    return ReviewMapper.toReview(dto);
  }

  @override
  Future<Review> updateReview(
    String reviewUuid, {
    int? rating,
    String? title,
    String? comment,
  }) async {
    final dto = await _dataSource.updateReview(
      reviewUuid,
      rating: rating,
      title: title,
      comment: comment,
    );
    return ReviewMapper.toReview(dto);
  }

  @override
  Future<void> deleteReview(String reviewUuid) {
    return _dataSource.deleteReview(reviewUuid);
  }

  @override
  Future<VoteCounts> voteReview(
    String reviewUuid, {
    required bool isHelpful,
  }) async {
    final dto = await _dataSource.voteReview(
      reviewUuid,
      isHelpful: isHelpful,
    );
    return ReviewMapper.toVoteCounts(dto);
  }

  @override
  Future<VoteCounts> unvoteReview(String reviewUuid) async {
    final dto = await _dataSource.unvoteReview(reviewUuid);
    return ReviewMapper.toVoteCounts(dto);
  }

  @override
  Future<void> reportReview(
    String reviewUuid, {
    required ReportReason reason,
    String? details,
  }) {
    return _dataSource.reportReview(
      reviewUuid,
      reason: reason,
      details: details,
    );
  }

  @override
  Future<PaginatedUserReviews> getUserReviews({
    int page = 1,
    int perPage = 10,
  }) async {
    final dto = await _dataSource.getUserReviews(page: page, perPage: perPage);
    return ReviewMapper.toPaginatedUserReviews(dto);
  }

  @override
  Future<int> getPendingCount() {
    return _dataSource.getPendingCount();
  }
}

import '../../domain/entities/can_review_result.dart';
import '../../domain/entities/paginated_reviews.dart';
import '../../domain/entities/review.dart';
import '../../domain/entities/review_author.dart';
import '../../domain/entities/review_enums.dart';
import '../../domain/entities/review_response.dart';
import '../../domain/entities/review_stats.dart';
import '../../domain/entities/user_review.dart';
import '../models/can_review_dto.dart';
import '../models/review_dto.dart';
import '../models/user_review_dto.dart';

/// Mapping DTO → Entity pour la feature reviews.
///
/// Tous les helpers gèrent le pattern dual snake/camel (le backend peut
/// renvoyer `total_reviews` ou `totalReviews`).
class ReviewMapper {
  ReviewMapper._();

  // ---------------------------------------------------------------------------
  // Review
  // ---------------------------------------------------------------------------

  static Review toReview(ReviewDto dto) {
    return Review(
      uuid: dto.uuid,
      rating: dto.rating,
      title: dto.title ?? '',
      comment: dto.comment,
      status: ReviewStatus.fromString(dto.status),
      helpfulCount: _pickInt(dto.helpfulCount, dto.helpfulCountCamel),
      notHelpfulCount:
          _pickInt(dto.notHelpfulCount, dto.notHelpfulCountCamel),
      helpfulnessPercentage: _pickDouble(
        dto.helpfulnessPercentage,
        dto.helpfulnessPercentageCamel,
      ),
      isVerifiedPurchase:
          dto.isVerifiedPurchase || dto.isVerifiedPurchaseCamel,
      isFeatured: dto.isFeatured || dto.isFeaturedCamel,
      author: dto.author != null ? toAuthor(dto.author!) : null,
      response: dto.response != null ? toResponse(dto.response!) : null,
      userVote: dto.userVote ?? dto.userVoteCamel,
      createdAt: _parseDate(dto.createdAt ?? dto.createdAtCamel),
      createdAtFormatted: _pickString(
        dto.createdAtFormatted,
        dto.createdAtFormattedCamel,
      ),
    );
  }

  static ReviewAuthor toAuthor(ReviewAuthorDto dto) {
    return ReviewAuthor(
      name: dto.name,
      firstName: dto.firstName ?? dto.firstNameCamel,
      lastName: dto.lastName ?? dto.lastNameCamel,
      avatar: dto.avatar,
      initials: dto.initials,
    );
  }

  static ReviewResponse toResponse(ReviewResponseDto dto) {
    return ReviewResponse(
      uuid: dto.uuid,
      response: dto.response,
      organizationName: dto.organization?.name.isNotEmpty == true
          ? dto.organization!.name
          : _pickString(dto.organizationName, dto.organizationNameCamel),
      organizationLogo: dto.organization?.logo,
      authorName: dto.author?.name,
      authorAvatar: dto.author?.avatar,
      createdAt: _parseDate(dto.createdAt ?? dto.createdAtCamel),
      createdAtFormatted: _pickString(
        dto.createdAtFormatted,
        dto.createdAtFormattedCamel,
      ),
    );
  }

  static ReviewStats toStats(ReviewStatsDto dto) {
    final distribution = <int, int>{};
    for (final entry in dto.distribution.entries) {
      final k = int.tryParse(entry.key);
      if (k != null) distribution[k] = entry.value;
    }
    final percentages = <int, int>{};
    for (final entry in dto.percentages.entries) {
      final k = int.tryParse(entry.key);
      if (k != null) percentages[k] = entry.value;
    }
    return ReviewStats(
      totalReviews: _pickInt(dto.totalReviews, dto.totalReviewsCamel),
      averageRating: _pickDouble(dto.averageRating, dto.averageRatingCamel),
      verifiedCount: _pickInt(dto.verifiedCount, dto.verifiedCountCamel),
      distribution: distribution,
      percentages: percentages,
    );
  }

  // ---------------------------------------------------------------------------
  // CanReviewResult
  // ---------------------------------------------------------------------------

  static CanReviewResult toCanReviewResult(CanReviewDto dto) {
    final allowed = dto.canReview || dto.canReviewCamel;
    final hasAttended = dto.hasAttended || dto.hasAttendedCamel;
    final isVerified =
        dto.isVerifiedPurchase || dto.isVerifiedPurchaseCamel;

    if (allowed) {
      return CanReviewAllowed(
        hasAttended: hasAttended,
        isVerifiedPurchase: isVerified,
      );
    }

    final existingDto = dto.existingReview ?? dto.existingReviewSnake;
    final reviewStatusStr = dto.reviewStatus ?? dto.reviewStatusCamel;
    return CanReviewDenied(
      reason: CanReviewReason.fromString(dto.reason),
      hasAttended: hasAttended,
      isVerifiedPurchase: isVerified,
      existingReview: existingDto != null ? toReview(existingDto) : null,
      reviewStatus: reviewStatusStr != null
          ? ReviewStatus.fromString(reviewStatusStr)
          : null,
    );
  }

  // ---------------------------------------------------------------------------
  // UserReview
  // ---------------------------------------------------------------------------

  static UserReview toUserReview(UserReviewDto dto) {
    final event = dto.event;
    final org = event?.organization;
    final orgName = org?.organizationName ??
        org?.companyName ??
        org?.name ??
        '';

    return UserReview(
      uuid: dto.uuid,
      rating: dto.rating,
      title: dto.title ?? '',
      comment: dto.comment,
      status: ReviewStatus.fromString(dto.status),
      helpfulCount: _pickInt(dto.helpfulCount, dto.helpfulCountCamel),
      notHelpfulCount:
          _pickInt(dto.notHelpfulCount, dto.notHelpfulCountCamel),
      isVerifiedPurchase:
          dto.isVerifiedPurchase || dto.isVerifiedPurchaseCamel,
      response: dto.response != null ? toResponse(dto.response!) : null,
      createdAt: _parseDate(dto.createdAt ?? dto.createdAtCamel),
      createdAtFormatted: _pickString(
        dto.createdAtFormatted,
        dto.createdAtFormattedCamel,
      ),
      eventUuid: event?.uuid,
      eventTitle: event?.title ?? '',
      eventSlug: event?.slug ?? '',
      eventCoverImage: event?.coverImage ?? event?.coverImageCamel,
      organizationName: orgName,
    );
  }

  // ---------------------------------------------------------------------------
  // Pagination
  // ---------------------------------------------------------------------------

  static PaginationMeta toMeta(PaginationMetaDto? dto) {
    if (dto == null) return const PaginationMeta();
    return PaginationMeta(
      currentPage: dto.currentPage,
      lastPage: dto.lastPage,
      perPage: dto.perPage,
      total: dto.total,
    );
  }

  static PaginatedReviews toPaginatedReviews(ReviewsResponseDto dto) {
    return PaginatedReviews(
      items: dto.data.map(toReview).toList(),
      meta: toMeta(dto.meta),
    );
  }

  static PaginatedUserReviews toPaginatedUserReviews(
    UserReviewsResponseDto dto,
  ) {
    return PaginatedUserReviews(
      items: dto.data.map(toUserReview).toList(),
      meta: toMeta(dto.meta),
    );
  }

  static VoteCounts toVoteCounts(VoteCountsDto dto) {
    return VoteCounts(
      helpfulCount: _pickInt(dto.helpfulCount, dto.helpfulCountCamel),
      notHelpfulCount:
          _pickInt(dto.notHelpfulCount, dto.notHelpfulCountCamel),
    );
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  /// Préfère la valeur snake_case si non-default, sinon camelCase.
  static int _pickInt(int snake, int camel) => snake != 0 ? snake : camel;

  static double _pickDouble(double snake, double camel) =>
      snake != 0 ? snake : camel;

  static String _pickString(String snake, String camel) =>
      snake.isNotEmpty ? snake : camel;

  static DateTime? _parseDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}

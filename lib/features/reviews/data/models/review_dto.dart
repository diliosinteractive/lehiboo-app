import 'package:freezed_annotation/freezed_annotation.dart';

import 'parsing_helpers.dart';

part 'review_dto.freezed.dart';
part 'review_dto.g.dart';

/// Réponse paginée pour la liste des avis d'un événement
@freezed
class ReviewsResponseDto with _$ReviewsResponseDto {
  const factory ReviewsResponseDto({
    @Default([]) List<ReviewDto> data,
    PaginationMetaDto? meta,
  }) = _ReviewsResponseDto;

  factory ReviewsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewsResponseDtoFromJson(json);
}

/// Statistiques des avis d'un événement
@freezed
class ReviewStatsDto with _$ReviewStatsDto {
  const factory ReviewStatsDto({
    @JsonKey(name: 'total_reviews', fromJson: parseInt)
    @Default(0)
    int totalReviews,
    @JsonKey(name: 'totalReviews', fromJson: parseInt)
    @Default(0)
    int totalReviewsCamel,
    @JsonKey(name: 'average_rating', fromJson: parseDouble)
    @Default(0)
    double averageRating,
    @JsonKey(name: 'averageRating', fromJson: parseDouble)
    @Default(0)
    double averageRatingCamel,
    @JsonKey(name: 'verified_count', fromJson: parseInt)
    @Default(0)
    int verifiedCount,
    @JsonKey(name: 'verifiedCount', fromJson: parseInt)
    @Default(0)
    int verifiedCountCamel,
    @Default({}) Map<String, int> distribution,
    @Default({}) Map<String, int> percentages,
  }) = _ReviewStatsDto;

  factory ReviewStatsDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewStatsDtoFromJson(json);
}

/// Un avis individuel (entité backend complète)
@freezed
class ReviewDto with _$ReviewDto {
  const factory ReviewDto({
    required String uuid,
    @JsonKey(fromJson: parseInt) @Default(0) int rating,
    @JsonKey(fromJson: parseStringOrNull) String? title,
    @JsonKey(fromJson: parseString) @Default('') String comment,
    @JsonKey(fromJson: parseStringOrNull) String? status,
    @JsonKey(name: 'helpful_count', fromJson: parseInt)
    @Default(0)
    int helpfulCount,
    @JsonKey(name: 'helpfulCount', fromJson: parseInt)
    @Default(0)
    int helpfulCountCamel,
    @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
    @Default(0)
    int notHelpfulCount,
    @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
    @Default(0)
    int notHelpfulCountCamel,
    @JsonKey(name: 'helpfulness_percentage', fromJson: parseDouble)
    @Default(0)
    double helpfulnessPercentage,
    @JsonKey(name: 'helpfulnessPercentage', fromJson: parseDouble)
    @Default(0)
    double helpfulnessPercentageCamel,
    @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
    @Default(false)
    bool isVerifiedPurchase,
    @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
    @Default(false)
    bool isVerifiedPurchaseCamel,
    @JsonKey(name: 'is_featured', fromJson: parseBool)
    @Default(false)
    bool isFeatured,
    @JsonKey(name: 'isFeatured', fromJson: parseBool)
    @Default(false)
    bool isFeaturedCamel,
    ReviewAuthorDto? author,
    ReviewResponseDto? response,
    // Event context — populated by the organizer-scoped reviews endpoint
    // (`GET /organizers/{id}/reviews`); null when the review is fetched
    // from the event-scoped endpoint, since the event is already implicit.
    @JsonKey(name: 'eventTitle', fromJson: parseStringOrNull) String? eventTitle,
    @JsonKey(name: 'eventSlug', fromJson: parseStringOrNull) String? eventSlug,
    @JsonKey(name: 'eventUuid', fromJson: parseStringOrNull) String? eventUuid,
    ReviewEventDto? event,
    @JsonKey(name: 'hasResponse', fromJson: parseBool)
    @Default(false)
    bool hasResponse,
    @JsonKey(name: 'organizerResponse', fromJson: parseStringOrNull)
    String? organizerResponse,
    @JsonKey(name: 'user_vote', fromJson: parseBoolOrNull) bool? userVote,
    @JsonKey(name: 'userVote', fromJson: parseBoolOrNull) bool? userVoteCamel,
    @JsonKey(name: 'created_at', fromJson: parseStringOrNull) String? createdAt,
    @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
    String? createdAtCamel,
    @JsonKey(name: 'created_at_formatted', fromJson: parseString)
    @Default('')
    String createdAtFormatted,
    @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
    @Default('')
    String createdAtFormattedCamel,
  }) = _ReviewDto;

  factory ReviewDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewDtoFromJson(json);
}

/// Auteur d'un avis
@freezed
class ReviewAuthorDto with _$ReviewAuthorDto {
  const factory ReviewAuthorDto({
    @JsonKey(fromJson: parseString) @Default('') String name,
    @JsonKey(name: 'first_name', fromJson: parseStringOrNull) String? firstName,
    @JsonKey(name: 'firstName', fromJson: parseStringOrNull)
    String? firstNameCamel,
    @JsonKey(name: 'last_name', fromJson: parseStringOrNull) String? lastName,
    @JsonKey(name: 'lastName', fromJson: parseStringOrNull)
    String? lastNameCamel,
    @JsonKey(fromJson: parseStringOrNull) String? avatar,
    @JsonKey(fromJson: parseString) @Default('') String initials,
  }) = _ReviewAuthorDto;

  factory ReviewAuthorDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewAuthorDtoFromJson(json);
}

/// Réponse de l'organisateur à un avis
@freezed
class ReviewResponseDto with _$ReviewResponseDto {
  const factory ReviewResponseDto({
    required String uuid,
    @JsonKey(fromJson: parseString) @Default('') String response,
    @JsonKey(name: 'organization_name', fromJson: parseString)
    @Default('')
    String organizationName,
    @JsonKey(name: 'organizationName', fromJson: parseString)
    @Default('')
    String organizationNameCamel,
    ReviewOrganizationDto? organization,
    ReviewResponseAuthorDto? author,
    @JsonKey(name: 'created_at', fromJson: parseStringOrNull) String? createdAt,
    @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
    String? createdAtCamel,
    @JsonKey(name: 'created_at_formatted', fromJson: parseString)
    @Default('')
    String createdAtFormatted,
    @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
    @Default('')
    String createdAtFormattedCamel,
  }) = _ReviewResponseDto;

  factory ReviewResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewResponseDtoFromJson(json);
}

/// Lightweight event reference embedded on each row of the organizer-scoped
/// reviews endpoint (`GET /organizers/{id}/reviews`).
@freezed
class ReviewEventDto with _$ReviewEventDto {
  const factory ReviewEventDto({
    @JsonKey(fromJson: parseInt) @Default(0) int id,
    @JsonKey(fromJson: parseStringOrNull) String? uuid,
    @JsonKey(fromJson: parseString) @Default('') String title,
    @JsonKey(fromJson: parseString) @Default('') String slug,
  }) = _ReviewEventDto;

  factory ReviewEventDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewEventDtoFromJson(json);
}

@freezed
class ReviewOrganizationDto with _$ReviewOrganizationDto {
  const factory ReviewOrganizationDto({
    @JsonKey(fromJson: parseString) @Default('') String name,
    @JsonKey(fromJson: parseStringOrNull) String? logo,
  }) = _ReviewOrganizationDto;

  factory ReviewOrganizationDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewOrganizationDtoFromJson(json);
}

@freezed
class ReviewResponseAuthorDto with _$ReviewResponseAuthorDto {
  const factory ReviewResponseAuthorDto({
    @JsonKey(fromJson: parseString) @Default('') String name,
    @JsonKey(fromJson: parseStringOrNull) String? avatar,
  }) = _ReviewResponseAuthorDto;

  factory ReviewResponseAuthorDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewResponseAuthorDtoFromJson(json);
}

/// Pagination metadata Laravel
@freezed
class PaginationMetaDto with _$PaginationMetaDto {
  const factory PaginationMetaDto({
    @JsonKey(name: 'current_page', fromJson: parseInt)
    @Default(1)
    int currentPage,
    @JsonKey(name: 'last_page', fromJson: parseInt) @Default(1) int lastPage,
    @JsonKey(name: 'per_page', fromJson: parseInt) @Default(10) int perPage,
    @JsonKey(fromJson: parseInt) @Default(0) int total,
  }) = _PaginationMetaDto;

  factory PaginationMetaDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaDtoFromJson(json);
}

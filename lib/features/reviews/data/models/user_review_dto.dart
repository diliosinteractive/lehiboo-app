import 'package:freezed_annotation/freezed_annotation.dart';

import 'parsing_helpers.dart';
import 'review_dto.dart';

part 'user_review_dto.freezed.dart';
part 'user_review_dto.g.dart';

/// Réponse paginée pour GET /user/reviews
@freezed
class UserReviewsResponseDto with _$UserReviewsResponseDto {
  const factory UserReviewsResponseDto({
    @Default([]) List<UserReviewDto> data,
    PaginationMetaDto? meta,
  }) = _UserReviewsResponseDto;

  factory UserReviewsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$UserReviewsResponseDtoFromJson(json);
}

/// Avis enrichi avec les infos de l'événement (pour la liste "Mes Avis")
@freezed
class UserReviewDto with _$UserReviewDto {
  const factory UserReviewDto({
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
    @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
    @Default(false)
    bool isVerifiedPurchase,
    @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
    @Default(false)
    bool isVerifiedPurchaseCamel,
    @JsonKey(name: 'created_at', fromJson: parseStringOrNull) String? createdAt,
    @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
    String? createdAtCamel,
    @JsonKey(name: 'created_at_formatted', fromJson: parseString)
    @Default('')
    String createdAtFormatted,
    @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
    @Default('')
    String createdAtFormattedCamel,
    UserReviewEventDto? event,
    ReviewResponseDto? response,
    @JsonKey(name: 'has_response', fromJson: parseBool)
    @Default(false)
    bool hasResponse,
    @JsonKey(name: 'hasResponse', fromJson: parseBool)
    @Default(false)
    bool hasResponseCamel,
  }) = _UserReviewDto;

  factory UserReviewDto.fromJson(Map<String, dynamic> json) =>
      _$UserReviewDtoFromJson(json);
}

/// Sous-objet `event` embedded dans UserReviewDto
@freezed
class UserReviewEventDto with _$UserReviewEventDto {
  const factory UserReviewEventDto({
    @JsonKey(fromJson: parseStringOrNull) String? uuid,
    @JsonKey(fromJson: parseString) @Default('') String title,
    @JsonKey(fromJson: parseString) @Default('') String slug,
    @JsonKey(name: 'cover_image', fromJson: parseStringOrNull)
    String? coverImage,
    @JsonKey(name: 'coverImage', fromJson: parseStringOrNull)
    String? coverImageCamel,
    UserReviewEventOrgDto? organization,
  }) = _UserReviewEventDto;

  factory UserReviewEventDto.fromJson(Map<String, dynamic> json) =>
      _$UserReviewEventDtoFromJson(json);
}

@freezed
class UserReviewEventOrgDto with _$UserReviewEventOrgDto {
  const factory UserReviewEventOrgDto({
    @JsonKey(name: 'organization_name', fromJson: parseStringOrNull)
    String? organizationName,
    @JsonKey(name: 'company_name', fromJson: parseStringOrNull)
    String? companyName,
    @JsonKey(fromJson: parseStringOrNull) String? name,
  }) = _UserReviewEventOrgDto;

  factory UserReviewEventOrgDto.fromJson(Map<String, dynamic> json) =>
      _$UserReviewEventOrgDtoFromJson(json);
}

/// Réponse de POST /reviews/{uuid}/vote (et DELETE)
@freezed
class VoteCountsDto with _$VoteCountsDto {
  const factory VoteCountsDto({
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
  }) = _VoteCountsDto;

  factory VoteCountsDto.fromJson(Map<String, dynamic> json) =>
      _$VoteCountsDtoFromJson(json);
}

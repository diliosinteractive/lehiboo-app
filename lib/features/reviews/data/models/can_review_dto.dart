import 'package:freezed_annotation/freezed_annotation.dart';

import 'parsing_helpers.dart';
import 'review_dto.dart';

part 'can_review_dto.freezed.dart';
part 'can_review_dto.g.dart';

/// Réponse de GET /events/{slug}/reviews/can-review
///
/// Backend renvoie soit `{ canReview: true, hasAttended, isVerifiedPurchase }`
/// soit `{ canReview: false, reason, ... existingReview? }`.
@freezed
class CanReviewDto with _$CanReviewDto {
  const factory CanReviewDto({
    @JsonKey(name: 'can_review', fromJson: parseBool)
    @Default(false)
    bool canReview,
    @JsonKey(name: 'canReview', fromJson: parseBool)
    @Default(false)
    bool canReviewCamel,
    @JsonKey(fromJson: parseStringOrNull) String? reason,
    @JsonKey(name: 'has_attended', fromJson: parseBool)
    @Default(false)
    bool hasAttended,
    @JsonKey(name: 'hasAttended', fromJson: parseBool)
    @Default(false)
    bool hasAttendedCamel,
    @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
    @Default(false)
    bool isVerifiedPurchase,
    @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
    @Default(false)
    bool isVerifiedPurchaseCamel,
    @JsonKey(name: 'review_status', fromJson: parseStringOrNull)
    String? reviewStatus,
    @JsonKey(name: 'reviewStatus', fromJson: parseStringOrNull)
    String? reviewStatusCamel,
    @JsonKey(name: 'existing_review') ReviewDto? existingReviewSnake,
    @JsonKey(name: 'existingReview') ReviewDto? existingReview,
  }) = _CanReviewDto;

  factory CanReviewDto.fromJson(Map<String, dynamic> json) =>
      _$CanReviewDtoFromJson(json);
}

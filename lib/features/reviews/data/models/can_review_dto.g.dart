// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'can_review_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CanReviewDtoImpl _$$CanReviewDtoImplFromJson(Map<String, dynamic> json) =>
    _$CanReviewDtoImpl(
      canReview:
          json['can_review'] == null ? false : parseBool(json['can_review']),
      canReviewCamel:
          json['canReview'] == null ? false : parseBool(json['canReview']),
      reason: parseStringOrNull(json['reason']),
      hasAttended: json['has_attended'] == null
          ? false
          : parseBool(json['has_attended']),
      hasAttendedCamel:
          json['hasAttended'] == null ? false : parseBool(json['hasAttended']),
      isVerifiedPurchase: json['is_verified_purchase'] == null
          ? false
          : parseBool(json['is_verified_purchase']),
      isVerifiedPurchaseCamel: json['isVerifiedPurchase'] == null
          ? false
          : parseBool(json['isVerifiedPurchase']),
      reviewStatus: parseStringOrNull(json['review_status']),
      reviewStatusCamel: parseStringOrNull(json['reviewStatus']),
      existingReviewSnake: json['existing_review'] == null
          ? null
          : ReviewDto.fromJson(json['existing_review'] as Map<String, dynamic>),
      existingReview: json['existingReview'] == null
          ? null
          : ReviewDto.fromJson(json['existingReview'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CanReviewDtoImplToJson(_$CanReviewDtoImpl instance) =>
    <String, dynamic>{
      'can_review': instance.canReview,
      'canReview': instance.canReviewCamel,
      'reason': instance.reason,
      'has_attended': instance.hasAttended,
      'hasAttended': instance.hasAttendedCamel,
      'is_verified_purchase': instance.isVerifiedPurchase,
      'isVerifiedPurchase': instance.isVerifiedPurchaseCamel,
      'review_status': instance.reviewStatus,
      'reviewStatus': instance.reviewStatusCamel,
      'existing_review': instance.existingReviewSnake,
      'existingReview': instance.existingReview,
    };

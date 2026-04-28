// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_review_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserReviewsResponseDtoImpl _$$UserReviewsResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UserReviewsResponseDtoImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => UserReviewDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      meta: json['meta'] == null
          ? null
          : PaginationMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserReviewsResponseDtoImplToJson(
        _$UserReviewsResponseDtoImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

_$UserReviewDtoImpl _$$UserReviewDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserReviewDtoImpl(
      uuid: json['uuid'] as String,
      rating: json['rating'] == null ? 0 : parseInt(json['rating']),
      title: parseStringOrNull(json['title']),
      comment: json['comment'] == null ? '' : parseString(json['comment']),
      status: parseStringOrNull(json['status']),
      helpfulCount:
          json['helpful_count'] == null ? 0 : parseInt(json['helpful_count']),
      helpfulCountCamel:
          json['helpfulCount'] == null ? 0 : parseInt(json['helpfulCount']),
      notHelpfulCount: json['not_helpful_count'] == null
          ? 0
          : parseInt(json['not_helpful_count']),
      notHelpfulCountCamel: json['notHelpfulCount'] == null
          ? 0
          : parseInt(json['notHelpfulCount']),
      isVerifiedPurchase: json['is_verified_purchase'] == null
          ? false
          : parseBool(json['is_verified_purchase']),
      isVerifiedPurchaseCamel: json['isVerifiedPurchase'] == null
          ? false
          : parseBool(json['isVerifiedPurchase']),
      createdAt: parseStringOrNull(json['created_at']),
      createdAtCamel: parseStringOrNull(json['createdAt']),
      createdAtFormatted: json['created_at_formatted'] == null
          ? ''
          : parseString(json['created_at_formatted']),
      createdAtFormattedCamel: json['createdAtFormatted'] == null
          ? ''
          : parseString(json['createdAtFormatted']),
      event: json['event'] == null
          ? null
          : UserReviewEventDto.fromJson(json['event'] as Map<String, dynamic>),
      response: json['response'] == null
          ? null
          : ReviewResponseDto.fromJson(
              json['response'] as Map<String, dynamic>),
      hasResponse: json['has_response'] == null
          ? false
          : parseBool(json['has_response']),
      hasResponseCamel:
          json['hasResponse'] == null ? false : parseBool(json['hasResponse']),
    );

Map<String, dynamic> _$$UserReviewDtoImplToJson(_$UserReviewDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'rating': instance.rating,
      'title': instance.title,
      'comment': instance.comment,
      'status': instance.status,
      'helpful_count': instance.helpfulCount,
      'helpfulCount': instance.helpfulCountCamel,
      'not_helpful_count': instance.notHelpfulCount,
      'notHelpfulCount': instance.notHelpfulCountCamel,
      'is_verified_purchase': instance.isVerifiedPurchase,
      'isVerifiedPurchase': instance.isVerifiedPurchaseCamel,
      'created_at': instance.createdAt,
      'createdAt': instance.createdAtCamel,
      'created_at_formatted': instance.createdAtFormatted,
      'createdAtFormatted': instance.createdAtFormattedCamel,
      'event': instance.event,
      'response': instance.response,
      'has_response': instance.hasResponse,
      'hasResponse': instance.hasResponseCamel,
    };

_$UserReviewEventDtoImpl _$$UserReviewEventDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UserReviewEventDtoImpl(
      uuid: parseStringOrNull(json['uuid']),
      title: json['title'] == null ? '' : parseString(json['title']),
      slug: json['slug'] == null ? '' : parseString(json['slug']),
      coverImage: parseStringOrNull(json['cover_image']),
      coverImageCamel: parseStringOrNull(json['coverImage']),
      organization: json['organization'] == null
          ? null
          : UserReviewEventOrgDto.fromJson(
              json['organization'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserReviewEventDtoImplToJson(
        _$UserReviewEventDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'title': instance.title,
      'slug': instance.slug,
      'cover_image': instance.coverImage,
      'coverImage': instance.coverImageCamel,
      'organization': instance.organization,
    };

_$UserReviewEventOrgDtoImpl _$$UserReviewEventOrgDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UserReviewEventOrgDtoImpl(
      organizationName: parseStringOrNull(json['organization_name']),
      companyName: parseStringOrNull(json['company_name']),
      name: parseStringOrNull(json['name']),
    );

Map<String, dynamic> _$$UserReviewEventOrgDtoImplToJson(
        _$UserReviewEventOrgDtoImpl instance) =>
    <String, dynamic>{
      'organization_name': instance.organizationName,
      'company_name': instance.companyName,
      'name': instance.name,
    };

_$VoteCountsDtoImpl _$$VoteCountsDtoImplFromJson(Map<String, dynamic> json) =>
    _$VoteCountsDtoImpl(
      helpfulCount:
          json['helpful_count'] == null ? 0 : parseInt(json['helpful_count']),
      helpfulCountCamel:
          json['helpfulCount'] == null ? 0 : parseInt(json['helpfulCount']),
      notHelpfulCount: json['not_helpful_count'] == null
          ? 0
          : parseInt(json['not_helpful_count']),
      notHelpfulCountCamel: json['notHelpfulCount'] == null
          ? 0
          : parseInt(json['notHelpfulCount']),
    );

Map<String, dynamic> _$$VoteCountsDtoImplToJson(_$VoteCountsDtoImpl instance) =>
    <String, dynamic>{
      'helpful_count': instance.helpfulCount,
      'helpfulCount': instance.helpfulCountCamel,
      'not_helpful_count': instance.notHelpfulCount,
      'notHelpfulCount': instance.notHelpfulCountCamel,
    };

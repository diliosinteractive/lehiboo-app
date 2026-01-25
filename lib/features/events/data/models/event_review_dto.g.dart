// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_review_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventReviewsResponseDtoImpl _$$EventReviewsResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EventReviewsResponseDtoImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => EventReviewDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      meta: json['meta'] == null
          ? null
          : MetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EventReviewsResponseDtoImplToJson(
        _$EventReviewsResponseDtoImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

_$ReviewStatsDtoImpl _$$ReviewStatsDtoImplFromJson(Map<String, dynamic> json) =>
    _$ReviewStatsDtoImpl(
      totalReviews:
          json['total_reviews'] == null ? 0 : _parseInt(json['total_reviews']),
      totalReviewsCamel:
          json['totalReviews'] == null ? 0 : _parseInt(json['totalReviews']),
      averageRating: json['average_rating'] == null
          ? 0
          : _parseDouble(json['average_rating']),
      averageRatingCamel: json['averageRating'] == null
          ? 0
          : _parseDouble(json['averageRating']),
      verifiedCount: json['verified_count'] == null
          ? 0
          : _parseInt(json['verified_count']),
      verifiedCountCamel:
          json['verifiedCount'] == null ? 0 : _parseInt(json['verifiedCount']),
      distribution: (json['distribution'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      percentages: (json['percentages'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ReviewStatsDtoImplToJson(
        _$ReviewStatsDtoImpl instance) =>
    <String, dynamic>{
      'total_reviews': instance.totalReviews,
      'totalReviews': instance.totalReviewsCamel,
      'average_rating': instance.averageRating,
      'averageRating': instance.averageRatingCamel,
      'verified_count': instance.verifiedCount,
      'verifiedCount': instance.verifiedCountCamel,
      'distribution': instance.distribution,
      'percentages': instance.percentages,
    };

_$EventReviewDtoImpl _$$EventReviewDtoImplFromJson(Map<String, dynamic> json) =>
    _$EventReviewDtoImpl(
      uuid: json['uuid'] as String,
      rating: json['rating'] == null ? 0 : _parseInt(json['rating']),
      title: _parseStringOrNull(json['title']),
      comment: json['comment'] == null ? '' : _parseString(json['comment']),
      helpfulCount:
          json['helpful_count'] == null ? 0 : _parseInt(json['helpful_count']),
      helpfulCountCamel:
          json['helpfulCount'] == null ? 0 : _parseInt(json['helpfulCount']),
      notHelpfulCount: json['not_helpful_count'] == null
          ? 0
          : _parseInt(json['not_helpful_count']),
      notHelpfulCountCamel: json['notHelpfulCount'] == null
          ? 0
          : _parseInt(json['notHelpfulCount']),
      isVerifiedPurchase: json['is_verified_purchase'] == null
          ? false
          : _parseBool(json['is_verified_purchase']),
      isVerifiedPurchaseCamel: json['isVerifiedPurchase'] == null
          ? false
          : _parseBool(json['isVerifiedPurchase']),
      isFeatured:
          json['is_featured'] == null ? false : _parseBool(json['is_featured']),
      isFeaturedCamel:
          json['isFeatured'] == null ? false : _parseBool(json['isFeatured']),
      author: json['author'] == null
          ? null
          : ReviewAuthorDto.fromJson(json['author'] as Map<String, dynamic>),
      response: json['response'] == null
          ? null
          : ReviewResponseDto.fromJson(
              json['response'] as Map<String, dynamic>),
      userVote: _parseBoolOrNull(json['user_vote']),
      userVoteCamel: _parseBoolOrNull(json['userVote']),
      createdAtFormatted: json['created_at_formatted'] == null
          ? ''
          : _parseString(json['created_at_formatted']),
      createdAtFormattedCamel: json['createdAtFormatted'] == null
          ? ''
          : _parseString(json['createdAtFormatted']),
    );

Map<String, dynamic> _$$EventReviewDtoImplToJson(
        _$EventReviewDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'rating': instance.rating,
      'title': instance.title,
      'comment': instance.comment,
      'helpful_count': instance.helpfulCount,
      'helpfulCount': instance.helpfulCountCamel,
      'not_helpful_count': instance.notHelpfulCount,
      'notHelpfulCount': instance.notHelpfulCountCamel,
      'is_verified_purchase': instance.isVerifiedPurchase,
      'isVerifiedPurchase': instance.isVerifiedPurchaseCamel,
      'is_featured': instance.isFeatured,
      'isFeatured': instance.isFeaturedCamel,
      'author': instance.author,
      'response': instance.response,
      'user_vote': instance.userVote,
      'userVote': instance.userVoteCamel,
      'created_at_formatted': instance.createdAtFormatted,
      'createdAtFormatted': instance.createdAtFormattedCamel,
    };

_$ReviewAuthorDtoImpl _$$ReviewAuthorDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewAuthorDtoImpl(
      name: json['name'] == null ? '' : _parseString(json['name']),
      avatar: _parseStringOrNull(json['avatar']),
      initials: json['initials'] == null ? '' : _parseString(json['initials']),
    );

Map<String, dynamic> _$$ReviewAuthorDtoImplToJson(
        _$ReviewAuthorDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'avatar': instance.avatar,
      'initials': instance.initials,
    };

_$ReviewResponseDtoImpl _$$ReviewResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewResponseDtoImpl(
      uuid: json['uuid'] as String,
      response: json['response'] == null ? '' : _parseString(json['response']),
      organizationName: json['organization_name'] == null
          ? ''
          : _parseString(json['organization_name']),
      organizationNameCamel: json['organizationName'] == null
          ? ''
          : _parseString(json['organizationName']),
      createdAtFormatted: json['created_at_formatted'] == null
          ? ''
          : _parseString(json['created_at_formatted']),
      createdAtFormattedCamel: json['createdAtFormatted'] == null
          ? ''
          : _parseString(json['createdAtFormatted']),
    );

Map<String, dynamic> _$$ReviewResponseDtoImplToJson(
        _$ReviewResponseDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'response': instance.response,
      'organization_name': instance.organizationName,
      'organizationName': instance.organizationNameCamel,
      'created_at_formatted': instance.createdAtFormatted,
      'createdAtFormatted': instance.createdAtFormattedCamel,
    };

_$MetaDtoImpl _$$MetaDtoImplFromJson(Map<String, dynamic> json) =>
    _$MetaDtoImpl(
      currentPage:
          json['current_page'] == null ? 1 : _parseInt(json['current_page']),
      lastPage: json['last_page'] == null ? 1 : _parseInt(json['last_page']),
      perPage: json['per_page'] == null ? 15 : _parseInt(json['per_page']),
      total: json['total'] == null ? 0 : _parseInt(json['total']),
    );

Map<String, dynamic> _$$MetaDtoImplToJson(_$MetaDtoImpl instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };

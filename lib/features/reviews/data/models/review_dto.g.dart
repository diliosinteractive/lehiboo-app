// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewsResponseDtoImpl _$$ReviewsResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewsResponseDtoImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ReviewDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      meta: json['meta'] == null
          ? null
          : PaginationMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ReviewsResponseDtoImplToJson(
        _$ReviewsResponseDtoImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

_$ReviewStatsDtoImpl _$$ReviewStatsDtoImplFromJson(Map<String, dynamic> json) =>
    _$ReviewStatsDtoImpl(
      totalReviews:
          json['total_reviews'] == null ? 0 : parseInt(json['total_reviews']),
      totalReviewsCamel:
          json['totalReviews'] == null ? 0 : parseInt(json['totalReviews']),
      averageRating: json['average_rating'] == null
          ? 0
          : parseDouble(json['average_rating']),
      averageRatingCamel: json['averageRating'] == null
          ? 0
          : parseDouble(json['averageRating']),
      verifiedCount:
          json['verified_count'] == null ? 0 : parseInt(json['verified_count']),
      verifiedCountCamel:
          json['verifiedCount'] == null ? 0 : parseInt(json['verifiedCount']),
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

_$ReviewDtoImpl _$$ReviewDtoImplFromJson(Map<String, dynamic> json) =>
    _$ReviewDtoImpl(
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
      helpfulnessPercentage: json['helpfulness_percentage'] == null
          ? 0
          : parseDouble(json['helpfulness_percentage']),
      helpfulnessPercentageCamel: json['helpfulnessPercentage'] == null
          ? 0
          : parseDouble(json['helpfulnessPercentage']),
      isVerifiedPurchase: json['is_verified_purchase'] == null
          ? false
          : parseBool(json['is_verified_purchase']),
      isVerifiedPurchaseCamel: json['isVerifiedPurchase'] == null
          ? false
          : parseBool(json['isVerifiedPurchase']),
      isFeatured:
          json['is_featured'] == null ? false : parseBool(json['is_featured']),
      isFeaturedCamel:
          json['isFeatured'] == null ? false : parseBool(json['isFeatured']),
      author: json['author'] == null
          ? null
          : ReviewAuthorDto.fromJson(json['author'] as Map<String, dynamic>),
      response: json['response'] == null
          ? null
          : ReviewResponseDto.fromJson(
              json['response'] as Map<String, dynamic>),
      eventTitle: parseStringOrNull(json['eventTitle']),
      eventSlug: parseStringOrNull(json['eventSlug']),
      eventUuid: parseStringOrNull(json['eventUuid']),
      event: json['event'] == null
          ? null
          : ReviewEventDto.fromJson(json['event'] as Map<String, dynamic>),
      hasResponse:
          json['hasResponse'] == null ? false : parseBool(json['hasResponse']),
      organizerResponse: parseStringOrNull(json['organizerResponse']),
      userVote: parseBoolOrNull(json['user_vote']),
      userVoteCamel: parseBoolOrNull(json['userVote']),
      createdAt: parseStringOrNull(json['created_at']),
      createdAtCamel: parseStringOrNull(json['createdAt']),
      createdAtFormatted: json['created_at_formatted'] == null
          ? ''
          : parseString(json['created_at_formatted']),
      createdAtFormattedCamel: json['createdAtFormatted'] == null
          ? ''
          : parseString(json['createdAtFormatted']),
    );

Map<String, dynamic> _$$ReviewDtoImplToJson(_$ReviewDtoImpl instance) =>
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
      'helpfulness_percentage': instance.helpfulnessPercentage,
      'helpfulnessPercentage': instance.helpfulnessPercentageCamel,
      'is_verified_purchase': instance.isVerifiedPurchase,
      'isVerifiedPurchase': instance.isVerifiedPurchaseCamel,
      'is_featured': instance.isFeatured,
      'isFeatured': instance.isFeaturedCamel,
      'author': instance.author,
      'response': instance.response,
      'eventTitle': instance.eventTitle,
      'eventSlug': instance.eventSlug,
      'eventUuid': instance.eventUuid,
      'event': instance.event,
      'hasResponse': instance.hasResponse,
      'organizerResponse': instance.organizerResponse,
      'user_vote': instance.userVote,
      'userVote': instance.userVoteCamel,
      'created_at': instance.createdAt,
      'createdAt': instance.createdAtCamel,
      'created_at_formatted': instance.createdAtFormatted,
      'createdAtFormatted': instance.createdAtFormattedCamel,
    };

_$ReviewAuthorDtoImpl _$$ReviewAuthorDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewAuthorDtoImpl(
      name: json['name'] == null ? '' : parseString(json['name']),
      firstName: parseStringOrNull(json['first_name']),
      firstNameCamel: parseStringOrNull(json['firstName']),
      lastName: parseStringOrNull(json['last_name']),
      lastNameCamel: parseStringOrNull(json['lastName']),
      avatar: parseStringOrNull(json['avatar']),
      initials: json['initials'] == null ? '' : parseString(json['initials']),
    );

Map<String, dynamic> _$$ReviewAuthorDtoImplToJson(
        _$ReviewAuthorDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'first_name': instance.firstName,
      'firstName': instance.firstNameCamel,
      'last_name': instance.lastName,
      'lastName': instance.lastNameCamel,
      'avatar': instance.avatar,
      'initials': instance.initials,
    };

_$ReviewResponseDtoImpl _$$ReviewResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewResponseDtoImpl(
      uuid: json['uuid'] as String,
      response: json['response'] == null ? '' : parseString(json['response']),
      organizationName: json['organization_name'] == null
          ? ''
          : parseString(json['organization_name']),
      organizationNameCamel: json['organizationName'] == null
          ? ''
          : parseString(json['organizationName']),
      organization: json['organization'] == null
          ? null
          : ReviewOrganizationDto.fromJson(
              json['organization'] as Map<String, dynamic>),
      author: json['author'] == null
          ? null
          : ReviewResponseAuthorDto.fromJson(
              json['author'] as Map<String, dynamic>),
      createdAt: parseStringOrNull(json['created_at']),
      createdAtCamel: parseStringOrNull(json['createdAt']),
      createdAtFormatted: json['created_at_formatted'] == null
          ? ''
          : parseString(json['created_at_formatted']),
      createdAtFormattedCamel: json['createdAtFormatted'] == null
          ? ''
          : parseString(json['createdAtFormatted']),
    );

Map<String, dynamic> _$$ReviewResponseDtoImplToJson(
        _$ReviewResponseDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'response': instance.response,
      'organization_name': instance.organizationName,
      'organizationName': instance.organizationNameCamel,
      'organization': instance.organization,
      'author': instance.author,
      'created_at': instance.createdAt,
      'createdAt': instance.createdAtCamel,
      'created_at_formatted': instance.createdAtFormatted,
      'createdAtFormatted': instance.createdAtFormattedCamel,
    };

_$ReviewEventDtoImpl _$$ReviewEventDtoImplFromJson(Map<String, dynamic> json) =>
    _$ReviewEventDtoImpl(
      id: json['id'] == null ? 0 : parseInt(json['id']),
      uuid: parseStringOrNull(json['uuid']),
      title: json['title'] == null ? '' : parseString(json['title']),
      slug: json['slug'] == null ? '' : parseString(json['slug']),
    );

Map<String, dynamic> _$$ReviewEventDtoImplToJson(
        _$ReviewEventDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'title': instance.title,
      'slug': instance.slug,
    };

_$ReviewOrganizationDtoImpl _$$ReviewOrganizationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewOrganizationDtoImpl(
      name: json['name'] == null ? '' : parseString(json['name']),
      logo: parseStringOrNull(json['logo']),
    );

Map<String, dynamic> _$$ReviewOrganizationDtoImplToJson(
        _$ReviewOrganizationDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'logo': instance.logo,
    };

_$ReviewResponseAuthorDtoImpl _$$ReviewResponseAuthorDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReviewResponseAuthorDtoImpl(
      name: json['name'] == null ? '' : parseString(json['name']),
      avatar: parseStringOrNull(json['avatar']),
    );

Map<String, dynamic> _$$ReviewResponseAuthorDtoImplToJson(
        _$ReviewResponseAuthorDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'avatar': instance.avatar,
    };

_$PaginationMetaDtoImpl _$$PaginationMetaDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginationMetaDtoImpl(
      currentPage:
          json['current_page'] == null ? 1 : parseInt(json['current_page']),
      lastPage: json['last_page'] == null ? 1 : parseInt(json['last_page']),
      perPage: json['per_page'] == null ? 10 : parseInt(json['per_page']),
      total: json['total'] == null ? 0 : parseInt(json['total']),
    );

Map<String, dynamic> _$$PaginationMetaDtoImplToJson(
        _$PaginationMetaDtoImpl instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };

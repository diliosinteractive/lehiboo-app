// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrganizerProfileDtoImpl _$$OrganizerProfileDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$OrganizerProfileDtoImpl(
      uuid: json['uuid'] as String,
      slug: json['slug'] as String,
      name: _string(json['name']),
      displayName: _stringOrNull(json['display_name']),
      description: _stringOrNull(json['description']),
      logo: _stringOrNull(json['logo']),
      coverImage: _stringOrNull(json['cover_image']),
      website: _stringOrNull(json['website']),
      email: _stringOrNull(json['email']),
      phone: _stringOrNull(json['phone']),
      address: _stringOrNull(json['address']),
      city: _stringOrNull(json['city']),
      zipCode: _stringOrNull(json['zipCode']),
      country: _stringOrNull(json['country']),
      verified: json['verified'] == null ? false : _bool(json['verified']),
      allowPublicContact: json['allow_public_contact'] == null
          ? false
          : _bool(json['allow_public_contact']),
      eventsCount:
          json['events_count'] == null ? 0 : _int(json['events_count']),
      followersCount:
          json['followers_count'] == null ? 0 : _int(json['followers_count']),
      membersCount:
          json['members_count'] == null ? 0 : _int(json['members_count']),
      reviewsCount:
          json['reviews_count'] == null ? 0 : _int(json['reviews_count']),
      averageRating: _doubleOrNull(json['average_rating']),
      isFollowed: json['is_followed'] as bool?,
      isOwner: json['is_owner'] as bool?,
      socialLinks: json['social_links'] == null
          ? null
          : SocialLinksDto.fromJson(
              json['social_links'] as Map<String, dynamic>),
      establishmentTypes: (json['establishment_types'] as List<dynamic>?)
          ?.map((e) => EstablishmentTypeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: _stringOrNull(json['created_at']),
    );

Map<String, dynamic> _$$OrganizerProfileDtoImplToJson(
        _$OrganizerProfileDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'slug': instance.slug,
      'name': instance.name,
      'display_name': instance.displayName,
      'description': instance.description,
      'logo': instance.logo,
      'cover_image': instance.coverImage,
      'website': instance.website,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'city': instance.city,
      'zipCode': instance.zipCode,
      'country': instance.country,
      'verified': instance.verified,
      'allow_public_contact': instance.allowPublicContact,
      'events_count': instance.eventsCount,
      'followers_count': instance.followersCount,
      'members_count': instance.membersCount,
      'reviews_count': instance.reviewsCount,
      'average_rating': instance.averageRating,
      'is_followed': instance.isFollowed,
      'is_owner': instance.isOwner,
      'social_links': instance.socialLinks,
      'establishment_types': instance.establishmentTypes,
      'created_at': instance.createdAt,
    };

_$SocialLinksDtoImpl _$$SocialLinksDtoImplFromJson(Map<String, dynamic> json) =>
    _$SocialLinksDtoImpl(
      facebook: _stringOrNull(json['facebook']),
      instagram: _stringOrNull(json['instagram']),
      twitter: _stringOrNull(json['twitter']),
      linkedin: _stringOrNull(json['linkedin']),
      youtube: _stringOrNull(json['youtube']),
    );

Map<String, dynamic> _$$SocialLinksDtoImplToJson(
        _$SocialLinksDtoImpl instance) =>
    <String, dynamic>{
      'facebook': instance.facebook,
      'instagram': instance.instagram,
      'twitter': instance.twitter,
      'linkedin': instance.linkedin,
      'youtube': instance.youtube,
    };

_$EstablishmentTypeDtoImpl _$$EstablishmentTypeDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EstablishmentTypeDtoImpl(
      uuid: json['uuid'] as String,
      name: _string(json['name']),
      slug: _string(json['slug']),
    );

Map<String, dynamic> _$$EstablishmentTypeDtoImplToJson(
        _$EstablishmentTypeDtoImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'slug': instance.slug,
    };

_$FollowStateDtoImpl _$$FollowStateDtoImplFromJson(Map<String, dynamic> json) =>
    _$FollowStateDtoImpl(
      isFollowed: _bool(json['is_followed']),
      followersCount: _int(json['followers_count']),
    );

Map<String, dynamic> _$$FollowStateDtoImplToJson(
        _$FollowStateDtoImpl instance) =>
    <String, dynamic>{
      'is_followed': instance.isFollowed,
      'followers_count': instance.followersCount,
    };

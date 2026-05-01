// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organizer_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrganizerProfileDto _$OrganizerProfileDtoFromJson(Map<String, dynamic> json) {
  return _OrganizerProfileDto.fromJson(json);
}

/// @nodoc
mixin _$OrganizerProfileDto {
  String get uuid => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _string)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name', fromJson: _stringOrNull)
  String? get displayName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get logo => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_image', fromJson: _stringOrNull)
  String? get coverImage => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get website => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'zipCode', fromJson: _stringOrNull)
  String? get zipCode => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get country => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _bool)
  bool get verified => throw _privateConstructorUsedError;
  @JsonKey(name: 'allow_public_contact', fromJson: _bool)
  bool get allowPublicContact => throw _privateConstructorUsedError;
  @JsonKey(name: 'events_count', fromJson: _int)
  int get eventsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'followers_count', fromJson: _int)
  int get followersCount =>
      throw _privateConstructorUsedError; // members_count: count(active) on OrganizationMember for this org.
// Excludes pending/rejected/suspended and the owner. Defaults to 0
// when the backend response predates the addition.
  @JsonKey(name: 'members_count', fromJson: _int)
  int get membersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviews_count', fromJson: _int)
  int get reviewsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_rating', fromJson: _doubleOrNull)
  double? get averageRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_followed')
  bool? get isFollowed =>
      throw _privateConstructorUsedError; // Tri-state per spec MEMBERSHIPS_MOBILE_SPEC.md §18: null when
// unauthenticated, false for non-owner, true when the authed user owns
// this org. Hides the Rejoindre button on the user's own org.
  @JsonKey(name: 'is_owner')
  bool? get isOwner => throw _privateConstructorUsedError;
  @JsonKey(name: 'social_links')
  SocialLinksDto? get socialLinks => throw _privateConstructorUsedError;
  @JsonKey(name: 'establishment_types')
  List<EstablishmentTypeDto>? get establishmentTypes =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _stringOrNull)
  String? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrganizerProfileDtoCopyWith<OrganizerProfileDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizerProfileDtoCopyWith<$Res> {
  factory $OrganizerProfileDtoCopyWith(
          OrganizerProfileDto value, $Res Function(OrganizerProfileDto) then) =
      _$OrganizerProfileDtoCopyWithImpl<$Res, OrganizerProfileDto>;
  @useResult
  $Res call(
      {String uuid,
      String slug,
      @JsonKey(fromJson: _string) String name,
      @JsonKey(name: 'display_name', fromJson: _stringOrNull)
      String? displayName,
      @JsonKey(fromJson: _stringOrNull) String? description,
      @JsonKey(fromJson: _stringOrNull) String? logo,
      @JsonKey(name: 'cover_image', fromJson: _stringOrNull) String? coverImage,
      @JsonKey(fromJson: _stringOrNull) String? website,
      @JsonKey(fromJson: _stringOrNull) String? email,
      @JsonKey(fromJson: _stringOrNull) String? phone,
      @JsonKey(fromJson: _stringOrNull) String? address,
      @JsonKey(fromJson: _stringOrNull) String? city,
      @JsonKey(name: 'zipCode', fromJson: _stringOrNull) String? zipCode,
      @JsonKey(fromJson: _stringOrNull) String? country,
      @JsonKey(fromJson: _bool) bool verified,
      @JsonKey(name: 'allow_public_contact', fromJson: _bool)
      bool allowPublicContact,
      @JsonKey(name: 'events_count', fromJson: _int) int eventsCount,
      @JsonKey(name: 'followers_count', fromJson: _int) int followersCount,
      @JsonKey(name: 'members_count', fromJson: _int) int membersCount,
      @JsonKey(name: 'reviews_count', fromJson: _int) int reviewsCount,
      @JsonKey(name: 'average_rating', fromJson: _doubleOrNull)
      double? averageRating,
      @JsonKey(name: 'is_followed') bool? isFollowed,
      @JsonKey(name: 'is_owner') bool? isOwner,
      @JsonKey(name: 'social_links') SocialLinksDto? socialLinks,
      @JsonKey(name: 'establishment_types')
      List<EstablishmentTypeDto>? establishmentTypes,
      @JsonKey(name: 'created_at', fromJson: _stringOrNull) String? createdAt});

  $SocialLinksDtoCopyWith<$Res>? get socialLinks;
}

/// @nodoc
class _$OrganizerProfileDtoCopyWithImpl<$Res, $Val extends OrganizerProfileDto>
    implements $OrganizerProfileDtoCopyWith<$Res> {
  _$OrganizerProfileDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? slug = null,
    Object? name = null,
    Object? displayName = freezed,
    Object? description = freezed,
    Object? logo = freezed,
    Object? coverImage = freezed,
    Object? website = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? zipCode = freezed,
    Object? country = freezed,
    Object? verified = null,
    Object? allowPublicContact = null,
    Object? eventsCount = null,
    Object? followersCount = null,
    Object? membersCount = null,
    Object? reviewsCount = null,
    Object? averageRating = freezed,
    Object? isFollowed = freezed,
    Object? isOwner = freezed,
    Object? socialLinks = freezed,
    Object? establishmentTypes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      allowPublicContact: null == allowPublicContact
          ? _value.allowPublicContact
          : allowPublicContact // ignore: cast_nullable_to_non_nullable
              as bool,
      eventsCount: null == eventsCount
          ? _value.eventsCount
          : eventsCount // ignore: cast_nullable_to_non_nullable
              as int,
      followersCount: null == followersCount
          ? _value.followersCount
          : followersCount // ignore: cast_nullable_to_non_nullable
              as int,
      membersCount: null == membersCount
          ? _value.membersCount
          : membersCount // ignore: cast_nullable_to_non_nullable
              as int,
      reviewsCount: null == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: freezed == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double?,
      isFollowed: freezed == isFollowed
          ? _value.isFollowed
          : isFollowed // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOwner: freezed == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool?,
      socialLinks: freezed == socialLinks
          ? _value.socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as SocialLinksDto?,
      establishmentTypes: freezed == establishmentTypes
          ? _value.establishmentTypes
          : establishmentTypes // ignore: cast_nullable_to_non_nullable
              as List<EstablishmentTypeDto>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SocialLinksDtoCopyWith<$Res>? get socialLinks {
    if (_value.socialLinks == null) {
      return null;
    }

    return $SocialLinksDtoCopyWith<$Res>(_value.socialLinks!, (value) {
      return _then(_value.copyWith(socialLinks: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrganizerProfileDtoImplCopyWith<$Res>
    implements $OrganizerProfileDtoCopyWith<$Res> {
  factory _$$OrganizerProfileDtoImplCopyWith(_$OrganizerProfileDtoImpl value,
          $Res Function(_$OrganizerProfileDtoImpl) then) =
      __$$OrganizerProfileDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String slug,
      @JsonKey(fromJson: _string) String name,
      @JsonKey(name: 'display_name', fromJson: _stringOrNull)
      String? displayName,
      @JsonKey(fromJson: _stringOrNull) String? description,
      @JsonKey(fromJson: _stringOrNull) String? logo,
      @JsonKey(name: 'cover_image', fromJson: _stringOrNull) String? coverImage,
      @JsonKey(fromJson: _stringOrNull) String? website,
      @JsonKey(fromJson: _stringOrNull) String? email,
      @JsonKey(fromJson: _stringOrNull) String? phone,
      @JsonKey(fromJson: _stringOrNull) String? address,
      @JsonKey(fromJson: _stringOrNull) String? city,
      @JsonKey(name: 'zipCode', fromJson: _stringOrNull) String? zipCode,
      @JsonKey(fromJson: _stringOrNull) String? country,
      @JsonKey(fromJson: _bool) bool verified,
      @JsonKey(name: 'allow_public_contact', fromJson: _bool)
      bool allowPublicContact,
      @JsonKey(name: 'events_count', fromJson: _int) int eventsCount,
      @JsonKey(name: 'followers_count', fromJson: _int) int followersCount,
      @JsonKey(name: 'members_count', fromJson: _int) int membersCount,
      @JsonKey(name: 'reviews_count', fromJson: _int) int reviewsCount,
      @JsonKey(name: 'average_rating', fromJson: _doubleOrNull)
      double? averageRating,
      @JsonKey(name: 'is_followed') bool? isFollowed,
      @JsonKey(name: 'is_owner') bool? isOwner,
      @JsonKey(name: 'social_links') SocialLinksDto? socialLinks,
      @JsonKey(name: 'establishment_types')
      List<EstablishmentTypeDto>? establishmentTypes,
      @JsonKey(name: 'created_at', fromJson: _stringOrNull) String? createdAt});

  @override
  $SocialLinksDtoCopyWith<$Res>? get socialLinks;
}

/// @nodoc
class __$$OrganizerProfileDtoImplCopyWithImpl<$Res>
    extends _$OrganizerProfileDtoCopyWithImpl<$Res, _$OrganizerProfileDtoImpl>
    implements _$$OrganizerProfileDtoImplCopyWith<$Res> {
  __$$OrganizerProfileDtoImplCopyWithImpl(_$OrganizerProfileDtoImpl _value,
      $Res Function(_$OrganizerProfileDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? slug = null,
    Object? name = null,
    Object? displayName = freezed,
    Object? description = freezed,
    Object? logo = freezed,
    Object? coverImage = freezed,
    Object? website = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? zipCode = freezed,
    Object? country = freezed,
    Object? verified = null,
    Object? allowPublicContact = null,
    Object? eventsCount = null,
    Object? followersCount = null,
    Object? membersCount = null,
    Object? reviewsCount = null,
    Object? averageRating = freezed,
    Object? isFollowed = freezed,
    Object? isOwner = freezed,
    Object? socialLinks = freezed,
    Object? establishmentTypes = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$OrganizerProfileDtoImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      allowPublicContact: null == allowPublicContact
          ? _value.allowPublicContact
          : allowPublicContact // ignore: cast_nullable_to_non_nullable
              as bool,
      eventsCount: null == eventsCount
          ? _value.eventsCount
          : eventsCount // ignore: cast_nullable_to_non_nullable
              as int,
      followersCount: null == followersCount
          ? _value.followersCount
          : followersCount // ignore: cast_nullable_to_non_nullable
              as int,
      membersCount: null == membersCount
          ? _value.membersCount
          : membersCount // ignore: cast_nullable_to_non_nullable
              as int,
      reviewsCount: null == reviewsCount
          ? _value.reviewsCount
          : reviewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: freezed == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double?,
      isFollowed: freezed == isFollowed
          ? _value.isFollowed
          : isFollowed // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOwner: freezed == isOwner
          ? _value.isOwner
          : isOwner // ignore: cast_nullable_to_non_nullable
              as bool?,
      socialLinks: freezed == socialLinks
          ? _value.socialLinks
          : socialLinks // ignore: cast_nullable_to_non_nullable
              as SocialLinksDto?,
      establishmentTypes: freezed == establishmentTypes
          ? _value._establishmentTypes
          : establishmentTypes // ignore: cast_nullable_to_non_nullable
              as List<EstablishmentTypeDto>?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizerProfileDtoImpl implements _OrganizerProfileDto {
  const _$OrganizerProfileDtoImpl(
      {required this.uuid,
      required this.slug,
      @JsonKey(fromJson: _string) required this.name,
      @JsonKey(name: 'display_name', fromJson: _stringOrNull) this.displayName,
      @JsonKey(fromJson: _stringOrNull) this.description,
      @JsonKey(fromJson: _stringOrNull) this.logo,
      @JsonKey(name: 'cover_image', fromJson: _stringOrNull) this.coverImage,
      @JsonKey(fromJson: _stringOrNull) this.website,
      @JsonKey(fromJson: _stringOrNull) this.email,
      @JsonKey(fromJson: _stringOrNull) this.phone,
      @JsonKey(fromJson: _stringOrNull) this.address,
      @JsonKey(fromJson: _stringOrNull) this.city,
      @JsonKey(name: 'zipCode', fromJson: _stringOrNull) this.zipCode,
      @JsonKey(fromJson: _stringOrNull) this.country,
      @JsonKey(fromJson: _bool) this.verified = false,
      @JsonKey(name: 'allow_public_contact', fromJson: _bool)
      this.allowPublicContact = false,
      @JsonKey(name: 'events_count', fromJson: _int) this.eventsCount = 0,
      @JsonKey(name: 'followers_count', fromJson: _int) this.followersCount = 0,
      @JsonKey(name: 'members_count', fromJson: _int) this.membersCount = 0,
      @JsonKey(name: 'reviews_count', fromJson: _int) this.reviewsCount = 0,
      @JsonKey(name: 'average_rating', fromJson: _doubleOrNull)
      this.averageRating,
      @JsonKey(name: 'is_followed') this.isFollowed,
      @JsonKey(name: 'is_owner') this.isOwner,
      @JsonKey(name: 'social_links') this.socialLinks,
      @JsonKey(name: 'establishment_types')
      final List<EstablishmentTypeDto>? establishmentTypes,
      @JsonKey(name: 'created_at', fromJson: _stringOrNull) this.createdAt})
      : _establishmentTypes = establishmentTypes;

  factory _$OrganizerProfileDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizerProfileDtoImplFromJson(json);

  @override
  final String uuid;
  @override
  final String slug;
  @override
  @JsonKey(fromJson: _string)
  final String name;
  @override
  @JsonKey(name: 'display_name', fromJson: _stringOrNull)
  final String? displayName;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? description;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? logo;
  @override
  @JsonKey(name: 'cover_image', fromJson: _stringOrNull)
  final String? coverImage;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? website;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? email;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? phone;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? address;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? city;
  @override
  @JsonKey(name: 'zipCode', fromJson: _stringOrNull)
  final String? zipCode;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? country;
  @override
  @JsonKey(fromJson: _bool)
  final bool verified;
  @override
  @JsonKey(name: 'allow_public_contact', fromJson: _bool)
  final bool allowPublicContact;
  @override
  @JsonKey(name: 'events_count', fromJson: _int)
  final int eventsCount;
  @override
  @JsonKey(name: 'followers_count', fromJson: _int)
  final int followersCount;
// members_count: count(active) on OrganizationMember for this org.
// Excludes pending/rejected/suspended and the owner. Defaults to 0
// when the backend response predates the addition.
  @override
  @JsonKey(name: 'members_count', fromJson: _int)
  final int membersCount;
  @override
  @JsonKey(name: 'reviews_count', fromJson: _int)
  final int reviewsCount;
  @override
  @JsonKey(name: 'average_rating', fromJson: _doubleOrNull)
  final double? averageRating;
  @override
  @JsonKey(name: 'is_followed')
  final bool? isFollowed;
// Tri-state per spec MEMBERSHIPS_MOBILE_SPEC.md §18: null when
// unauthenticated, false for non-owner, true when the authed user owns
// this org. Hides the Rejoindre button on the user's own org.
  @override
  @JsonKey(name: 'is_owner')
  final bool? isOwner;
  @override
  @JsonKey(name: 'social_links')
  final SocialLinksDto? socialLinks;
  final List<EstablishmentTypeDto>? _establishmentTypes;
  @override
  @JsonKey(name: 'establishment_types')
  List<EstablishmentTypeDto>? get establishmentTypes {
    final value = _establishmentTypes;
    if (value == null) return null;
    if (_establishmentTypes is EqualUnmodifiableListView)
      return _establishmentTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at', fromJson: _stringOrNull)
  final String? createdAt;

  @override
  String toString() {
    return 'OrganizerProfileDto(uuid: $uuid, slug: $slug, name: $name, displayName: $displayName, description: $description, logo: $logo, coverImage: $coverImage, website: $website, email: $email, phone: $phone, address: $address, city: $city, zipCode: $zipCode, country: $country, verified: $verified, allowPublicContact: $allowPublicContact, eventsCount: $eventsCount, followersCount: $followersCount, membersCount: $membersCount, reviewsCount: $reviewsCount, averageRating: $averageRating, isFollowed: $isFollowed, isOwner: $isOwner, socialLinks: $socialLinks, establishmentTypes: $establishmentTypes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizerProfileDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.allowPublicContact, allowPublicContact) ||
                other.allowPublicContact == allowPublicContact) &&
            (identical(other.eventsCount, eventsCount) ||
                other.eventsCount == eventsCount) &&
            (identical(other.followersCount, followersCount) ||
                other.followersCount == followersCount) &&
            (identical(other.membersCount, membersCount) ||
                other.membersCount == membersCount) &&
            (identical(other.reviewsCount, reviewsCount) ||
                other.reviewsCount == reviewsCount) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.isFollowed, isFollowed) ||
                other.isFollowed == isFollowed) &&
            (identical(other.isOwner, isOwner) || other.isOwner == isOwner) &&
            (identical(other.socialLinks, socialLinks) ||
                other.socialLinks == socialLinks) &&
            const DeepCollectionEquality()
                .equals(other._establishmentTypes, _establishmentTypes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        uuid,
        slug,
        name,
        displayName,
        description,
        logo,
        coverImage,
        website,
        email,
        phone,
        address,
        city,
        zipCode,
        country,
        verified,
        allowPublicContact,
        eventsCount,
        followersCount,
        membersCount,
        reviewsCount,
        averageRating,
        isFollowed,
        isOwner,
        socialLinks,
        const DeepCollectionEquality().hash(_establishmentTypes),
        createdAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizerProfileDtoImplCopyWith<_$OrganizerProfileDtoImpl> get copyWith =>
      __$$OrganizerProfileDtoImplCopyWithImpl<_$OrganizerProfileDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizerProfileDtoImplToJson(
      this,
    );
  }
}

abstract class _OrganizerProfileDto implements OrganizerProfileDto {
  const factory _OrganizerProfileDto(
      {required final String uuid,
      required final String slug,
      @JsonKey(fromJson: _string) required final String name,
      @JsonKey(name: 'display_name', fromJson: _stringOrNull)
      final String? displayName,
      @JsonKey(fromJson: _stringOrNull) final String? description,
      @JsonKey(fromJson: _stringOrNull) final String? logo,
      @JsonKey(name: 'cover_image', fromJson: _stringOrNull)
      final String? coverImage,
      @JsonKey(fromJson: _stringOrNull) final String? website,
      @JsonKey(fromJson: _stringOrNull) final String? email,
      @JsonKey(fromJson: _stringOrNull) final String? phone,
      @JsonKey(fromJson: _stringOrNull) final String? address,
      @JsonKey(fromJson: _stringOrNull) final String? city,
      @JsonKey(name: 'zipCode', fromJson: _stringOrNull) final String? zipCode,
      @JsonKey(fromJson: _stringOrNull) final String? country,
      @JsonKey(fromJson: _bool) final bool verified,
      @JsonKey(name: 'allow_public_contact', fromJson: _bool)
      final bool allowPublicContact,
      @JsonKey(name: 'events_count', fromJson: _int) final int eventsCount,
      @JsonKey(name: 'followers_count', fromJson: _int)
      final int followersCount,
      @JsonKey(name: 'members_count', fromJson: _int) final int membersCount,
      @JsonKey(name: 'reviews_count', fromJson: _int) final int reviewsCount,
      @JsonKey(name: 'average_rating', fromJson: _doubleOrNull)
      final double? averageRating,
      @JsonKey(name: 'is_followed') final bool? isFollowed,
      @JsonKey(name: 'is_owner') final bool? isOwner,
      @JsonKey(name: 'social_links') final SocialLinksDto? socialLinks,
      @JsonKey(name: 'establishment_types')
      final List<EstablishmentTypeDto>? establishmentTypes,
      @JsonKey(name: 'created_at', fromJson: _stringOrNull)
      final String? createdAt}) = _$OrganizerProfileDtoImpl;

  factory _OrganizerProfileDto.fromJson(Map<String, dynamic> json) =
      _$OrganizerProfileDtoImpl.fromJson;

  @override
  String get uuid;
  @override
  String get slug;
  @override
  @JsonKey(fromJson: _string)
  String get name;
  @override
  @JsonKey(name: 'display_name', fromJson: _stringOrNull)
  String? get displayName;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get description;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get logo;
  @override
  @JsonKey(name: 'cover_image', fromJson: _stringOrNull)
  String? get coverImage;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get website;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get email;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get phone;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get address;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get city;
  @override
  @JsonKey(name: 'zipCode', fromJson: _stringOrNull)
  String? get zipCode;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get country;
  @override
  @JsonKey(fromJson: _bool)
  bool get verified;
  @override
  @JsonKey(name: 'allow_public_contact', fromJson: _bool)
  bool get allowPublicContact;
  @override
  @JsonKey(name: 'events_count', fromJson: _int)
  int get eventsCount;
  @override
  @JsonKey(name: 'followers_count', fromJson: _int)
  int get followersCount;
  @override // members_count: count(active) on OrganizationMember for this org.
// Excludes pending/rejected/suspended and the owner. Defaults to 0
// when the backend response predates the addition.
  @JsonKey(name: 'members_count', fromJson: _int)
  int get membersCount;
  @override
  @JsonKey(name: 'reviews_count', fromJson: _int)
  int get reviewsCount;
  @override
  @JsonKey(name: 'average_rating', fromJson: _doubleOrNull)
  double? get averageRating;
  @override
  @JsonKey(name: 'is_followed')
  bool? get isFollowed;
  @override // Tri-state per spec MEMBERSHIPS_MOBILE_SPEC.md §18: null when
// unauthenticated, false for non-owner, true when the authed user owns
// this org. Hides the Rejoindre button on the user's own org.
  @JsonKey(name: 'is_owner')
  bool? get isOwner;
  @override
  @JsonKey(name: 'social_links')
  SocialLinksDto? get socialLinks;
  @override
  @JsonKey(name: 'establishment_types')
  List<EstablishmentTypeDto>? get establishmentTypes;
  @override
  @JsonKey(name: 'created_at', fromJson: _stringOrNull)
  String? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$OrganizerProfileDtoImplCopyWith<_$OrganizerProfileDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialLinksDto _$SocialLinksDtoFromJson(Map<String, dynamic> json) {
  return _SocialLinksDto.fromJson(json);
}

/// @nodoc
mixin _$SocialLinksDto {
  @JsonKey(fromJson: _stringOrNull)
  String? get facebook => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get instagram => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get twitter => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get linkedin => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get youtube => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SocialLinksDtoCopyWith<SocialLinksDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialLinksDtoCopyWith<$Res> {
  factory $SocialLinksDtoCopyWith(
          SocialLinksDto value, $Res Function(SocialLinksDto) then) =
      _$SocialLinksDtoCopyWithImpl<$Res, SocialLinksDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _stringOrNull) String? facebook,
      @JsonKey(fromJson: _stringOrNull) String? instagram,
      @JsonKey(fromJson: _stringOrNull) String? twitter,
      @JsonKey(fromJson: _stringOrNull) String? linkedin,
      @JsonKey(fromJson: _stringOrNull) String? youtube});
}

/// @nodoc
class _$SocialLinksDtoCopyWithImpl<$Res, $Val extends SocialLinksDto>
    implements $SocialLinksDtoCopyWith<$Res> {
  _$SocialLinksDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? facebook = freezed,
    Object? instagram = freezed,
    Object? twitter = freezed,
    Object? linkedin = freezed,
    Object? youtube = freezed,
  }) {
    return _then(_value.copyWith(
      facebook: freezed == facebook
          ? _value.facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as String?,
      instagram: freezed == instagram
          ? _value.instagram
          : instagram // ignore: cast_nullable_to_non_nullable
              as String?,
      twitter: freezed == twitter
          ? _value.twitter
          : twitter // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedin: freezed == linkedin
          ? _value.linkedin
          : linkedin // ignore: cast_nullable_to_non_nullable
              as String?,
      youtube: freezed == youtube
          ? _value.youtube
          : youtube // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialLinksDtoImplCopyWith<$Res>
    implements $SocialLinksDtoCopyWith<$Res> {
  factory _$$SocialLinksDtoImplCopyWith(_$SocialLinksDtoImpl value,
          $Res Function(_$SocialLinksDtoImpl) then) =
      __$$SocialLinksDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _stringOrNull) String? facebook,
      @JsonKey(fromJson: _stringOrNull) String? instagram,
      @JsonKey(fromJson: _stringOrNull) String? twitter,
      @JsonKey(fromJson: _stringOrNull) String? linkedin,
      @JsonKey(fromJson: _stringOrNull) String? youtube});
}

/// @nodoc
class __$$SocialLinksDtoImplCopyWithImpl<$Res>
    extends _$SocialLinksDtoCopyWithImpl<$Res, _$SocialLinksDtoImpl>
    implements _$$SocialLinksDtoImplCopyWith<$Res> {
  __$$SocialLinksDtoImplCopyWithImpl(
      _$SocialLinksDtoImpl _value, $Res Function(_$SocialLinksDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? facebook = freezed,
    Object? instagram = freezed,
    Object? twitter = freezed,
    Object? linkedin = freezed,
    Object? youtube = freezed,
  }) {
    return _then(_$SocialLinksDtoImpl(
      facebook: freezed == facebook
          ? _value.facebook
          : facebook // ignore: cast_nullable_to_non_nullable
              as String?,
      instagram: freezed == instagram
          ? _value.instagram
          : instagram // ignore: cast_nullable_to_non_nullable
              as String?,
      twitter: freezed == twitter
          ? _value.twitter
          : twitter // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedin: freezed == linkedin
          ? _value.linkedin
          : linkedin // ignore: cast_nullable_to_non_nullable
              as String?,
      youtube: freezed == youtube
          ? _value.youtube
          : youtube // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialLinksDtoImpl implements _SocialLinksDto {
  const _$SocialLinksDtoImpl(
      {@JsonKey(fromJson: _stringOrNull) this.facebook,
      @JsonKey(fromJson: _stringOrNull) this.instagram,
      @JsonKey(fromJson: _stringOrNull) this.twitter,
      @JsonKey(fromJson: _stringOrNull) this.linkedin,
      @JsonKey(fromJson: _stringOrNull) this.youtube});

  factory _$SocialLinksDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialLinksDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? facebook;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? instagram;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? twitter;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? linkedin;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? youtube;

  @override
  String toString() {
    return 'SocialLinksDto(facebook: $facebook, instagram: $instagram, twitter: $twitter, linkedin: $linkedin, youtube: $youtube)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialLinksDtoImpl &&
            (identical(other.facebook, facebook) ||
                other.facebook == facebook) &&
            (identical(other.instagram, instagram) ||
                other.instagram == instagram) &&
            (identical(other.twitter, twitter) || other.twitter == twitter) &&
            (identical(other.linkedin, linkedin) ||
                other.linkedin == linkedin) &&
            (identical(other.youtube, youtube) || other.youtube == youtube));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, facebook, instagram, twitter, linkedin, youtube);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialLinksDtoImplCopyWith<_$SocialLinksDtoImpl> get copyWith =>
      __$$SocialLinksDtoImplCopyWithImpl<_$SocialLinksDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialLinksDtoImplToJson(
      this,
    );
  }
}

abstract class _SocialLinksDto implements SocialLinksDto {
  const factory _SocialLinksDto(
          {@JsonKey(fromJson: _stringOrNull) final String? facebook,
          @JsonKey(fromJson: _stringOrNull) final String? instagram,
          @JsonKey(fromJson: _stringOrNull) final String? twitter,
          @JsonKey(fromJson: _stringOrNull) final String? linkedin,
          @JsonKey(fromJson: _stringOrNull) final String? youtube}) =
      _$SocialLinksDtoImpl;

  factory _SocialLinksDto.fromJson(Map<String, dynamic> json) =
      _$SocialLinksDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get facebook;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get instagram;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get twitter;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get linkedin;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get youtube;
  @override
  @JsonKey(ignore: true)
  _$$SocialLinksDtoImplCopyWith<_$SocialLinksDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EstablishmentTypeDto _$EstablishmentTypeDtoFromJson(Map<String, dynamic> json) {
  return _EstablishmentTypeDto.fromJson(json);
}

/// @nodoc
mixin _$EstablishmentTypeDto {
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _string)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _string)
  String get slug => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EstablishmentTypeDtoCopyWith<EstablishmentTypeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EstablishmentTypeDtoCopyWith<$Res> {
  factory $EstablishmentTypeDtoCopyWith(EstablishmentTypeDto value,
          $Res Function(EstablishmentTypeDto) then) =
      _$EstablishmentTypeDtoCopyWithImpl<$Res, EstablishmentTypeDto>;
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(fromJson: _string) String name,
      @JsonKey(fromJson: _string) String slug});
}

/// @nodoc
class _$EstablishmentTypeDtoCopyWithImpl<$Res,
        $Val extends EstablishmentTypeDto>
    implements $EstablishmentTypeDtoCopyWith<$Res> {
  _$EstablishmentTypeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? name = null,
    Object? slug = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EstablishmentTypeDtoImplCopyWith<$Res>
    implements $EstablishmentTypeDtoCopyWith<$Res> {
  factory _$$EstablishmentTypeDtoImplCopyWith(_$EstablishmentTypeDtoImpl value,
          $Res Function(_$EstablishmentTypeDtoImpl) then) =
      __$$EstablishmentTypeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(fromJson: _string) String name,
      @JsonKey(fromJson: _string) String slug});
}

/// @nodoc
class __$$EstablishmentTypeDtoImplCopyWithImpl<$Res>
    extends _$EstablishmentTypeDtoCopyWithImpl<$Res, _$EstablishmentTypeDtoImpl>
    implements _$$EstablishmentTypeDtoImplCopyWith<$Res> {
  __$$EstablishmentTypeDtoImplCopyWithImpl(_$EstablishmentTypeDtoImpl _value,
      $Res Function(_$EstablishmentTypeDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? name = null,
    Object? slug = null,
  }) {
    return _then(_$EstablishmentTypeDtoImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EstablishmentTypeDtoImpl implements _EstablishmentTypeDto {
  const _$EstablishmentTypeDtoImpl(
      {required this.uuid,
      @JsonKey(fromJson: _string) required this.name,
      @JsonKey(fromJson: _string) required this.slug});

  factory _$EstablishmentTypeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EstablishmentTypeDtoImplFromJson(json);

  @override
  final String uuid;
  @override
  @JsonKey(fromJson: _string)
  final String name;
  @override
  @JsonKey(fromJson: _string)
  final String slug;

  @override
  String toString() {
    return 'EstablishmentTypeDto(uuid: $uuid, name: $name, slug: $slug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EstablishmentTypeDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, name, slug);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EstablishmentTypeDtoImplCopyWith<_$EstablishmentTypeDtoImpl>
      get copyWith =>
          __$$EstablishmentTypeDtoImplCopyWithImpl<_$EstablishmentTypeDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EstablishmentTypeDtoImplToJson(
      this,
    );
  }
}

abstract class _EstablishmentTypeDto implements EstablishmentTypeDto {
  const factory _EstablishmentTypeDto(
          {required final String uuid,
          @JsonKey(fromJson: _string) required final String name,
          @JsonKey(fromJson: _string) required final String slug}) =
      _$EstablishmentTypeDtoImpl;

  factory _EstablishmentTypeDto.fromJson(Map<String, dynamic> json) =
      _$EstablishmentTypeDtoImpl.fromJson;

  @override
  String get uuid;
  @override
  @JsonKey(fromJson: _string)
  String get name;
  @override
  @JsonKey(fromJson: _string)
  String get slug;
  @override
  @JsonKey(ignore: true)
  _$$EstablishmentTypeDtoImplCopyWith<_$EstablishmentTypeDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FollowStateDto _$FollowStateDtoFromJson(Map<String, dynamic> json) {
  return _FollowStateDto.fromJson(json);
}

/// @nodoc
mixin _$FollowStateDto {
  @JsonKey(name: 'is_followed', fromJson: _bool)
  bool get isFollowed => throw _privateConstructorUsedError;
  @JsonKey(name: 'followers_count', fromJson: _int)
  int get followersCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FollowStateDtoCopyWith<FollowStateDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowStateDtoCopyWith<$Res> {
  factory $FollowStateDtoCopyWith(
          FollowStateDto value, $Res Function(FollowStateDto) then) =
      _$FollowStateDtoCopyWithImpl<$Res, FollowStateDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'is_followed', fromJson: _bool) bool isFollowed,
      @JsonKey(name: 'followers_count', fromJson: _int) int followersCount});
}

/// @nodoc
class _$FollowStateDtoCopyWithImpl<$Res, $Val extends FollowStateDto>
    implements $FollowStateDtoCopyWith<$Res> {
  _$FollowStateDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFollowed = null,
    Object? followersCount = null,
  }) {
    return _then(_value.copyWith(
      isFollowed: null == isFollowed
          ? _value.isFollowed
          : isFollowed // ignore: cast_nullable_to_non_nullable
              as bool,
      followersCount: null == followersCount
          ? _value.followersCount
          : followersCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FollowStateDtoImplCopyWith<$Res>
    implements $FollowStateDtoCopyWith<$Res> {
  factory _$$FollowStateDtoImplCopyWith(_$FollowStateDtoImpl value,
          $Res Function(_$FollowStateDtoImpl) then) =
      __$$FollowStateDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'is_followed', fromJson: _bool) bool isFollowed,
      @JsonKey(name: 'followers_count', fromJson: _int) int followersCount});
}

/// @nodoc
class __$$FollowStateDtoImplCopyWithImpl<$Res>
    extends _$FollowStateDtoCopyWithImpl<$Res, _$FollowStateDtoImpl>
    implements _$$FollowStateDtoImplCopyWith<$Res> {
  __$$FollowStateDtoImplCopyWithImpl(
      _$FollowStateDtoImpl _value, $Res Function(_$FollowStateDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFollowed = null,
    Object? followersCount = null,
  }) {
    return _then(_$FollowStateDtoImpl(
      isFollowed: null == isFollowed
          ? _value.isFollowed
          : isFollowed // ignore: cast_nullable_to_non_nullable
              as bool,
      followersCount: null == followersCount
          ? _value.followersCount
          : followersCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FollowStateDtoImpl implements _FollowStateDto {
  const _$FollowStateDtoImpl(
      {@JsonKey(name: 'is_followed', fromJson: _bool) required this.isFollowed,
      @JsonKey(name: 'followers_count', fromJson: _int)
      required this.followersCount});

  factory _$FollowStateDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FollowStateDtoImplFromJson(json);

  @override
  @JsonKey(name: 'is_followed', fromJson: _bool)
  final bool isFollowed;
  @override
  @JsonKey(name: 'followers_count', fromJson: _int)
  final int followersCount;

  @override
  String toString() {
    return 'FollowStateDto(isFollowed: $isFollowed, followersCount: $followersCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowStateDtoImpl &&
            (identical(other.isFollowed, isFollowed) ||
                other.isFollowed == isFollowed) &&
            (identical(other.followersCount, followersCount) ||
                other.followersCount == followersCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isFollowed, followersCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowStateDtoImplCopyWith<_$FollowStateDtoImpl> get copyWith =>
      __$$FollowStateDtoImplCopyWithImpl<_$FollowStateDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FollowStateDtoImplToJson(
      this,
    );
  }
}

abstract class _FollowStateDto implements FollowStateDto {
  const factory _FollowStateDto(
      {@JsonKey(name: 'is_followed', fromJson: _bool)
      required final bool isFollowed,
      @JsonKey(name: 'followers_count', fromJson: _int)
      required final int followersCount}) = _$FollowStateDtoImpl;

  factory _FollowStateDto.fromJson(Map<String, dynamic> json) =
      _$FollowStateDtoImpl.fromJson;

  @override
  @JsonKey(name: 'is_followed', fromJson: _bool)
  bool get isFollowed;
  @override
  @JsonKey(name: 'followers_count', fromJson: _int)
  int get followersCount;
  @override
  @JsonKey(ignore: true)
  _$$FollowStateDtoImplCopyWith<_$FollowStateDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'membership_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MembershipDto _$MembershipDtoFromJson(Map<String, dynamic> json) {
  return _MembershipDto.fromJson(json);
}

/// @nodoc
mixin _$MembershipDto {
  @JsonKey(fromJson: _int)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _membershipStatus)
  MembershipStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_label', fromJson: _string)
  String get statusLabel => throw _privateConstructorUsedError;
  OrganizationSummaryDto? get organization =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'requested_at', fromJson: _stringOrNull)
  String? get requestedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at', fromJson: _stringOrNull)
  String? get approvedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejected_at', fromJson: _stringOrNull)
  String? get rejectedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _stringOrNull)
  String? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MembershipDtoCopyWith<MembershipDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipDtoCopyWith<$Res> {
  factory $MembershipDtoCopyWith(
          MembershipDto value, $Res Function(MembershipDto) then) =
      _$MembershipDtoCopyWithImpl<$Res, MembershipDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _int) int id,
      @JsonKey(fromJson: _membershipStatus) MembershipStatus status,
      @JsonKey(name: 'status_label', fromJson: _string) String statusLabel,
      OrganizationSummaryDto? organization,
      @JsonKey(name: 'requested_at', fromJson: _stringOrNull)
      String? requestedAt,
      @JsonKey(name: 'approved_at', fromJson: _stringOrNull) String? approvedAt,
      @JsonKey(name: 'rejected_at', fromJson: _stringOrNull) String? rejectedAt,
      @JsonKey(name: 'created_at', fromJson: _stringOrNull) String? createdAt});

  $OrganizationSummaryDtoCopyWith<$Res>? get organization;
}

/// @nodoc
class _$MembershipDtoCopyWithImpl<$Res, $Val extends MembershipDto>
    implements $MembershipDtoCopyWith<$Res> {
  _$MembershipDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? statusLabel = null,
    Object? organization = freezed,
    Object? requestedAt = freezed,
    Object? approvedAt = freezed,
    Object? rejectedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MembershipStatus,
      statusLabel: null == statusLabel
          ? _value.statusLabel
          : statusLabel // ignore: cast_nullable_to_non_nullable
              as String,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as OrganizationSummaryDto?,
      requestedAt: freezed == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizationSummaryDtoCopyWith<$Res>? get organization {
    if (_value.organization == null) {
      return null;
    }

    return $OrganizationSummaryDtoCopyWith<$Res>(_value.organization!, (value) {
      return _then(_value.copyWith(organization: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MembershipDtoImplCopyWith<$Res>
    implements $MembershipDtoCopyWith<$Res> {
  factory _$$MembershipDtoImplCopyWith(
          _$MembershipDtoImpl value, $Res Function(_$MembershipDtoImpl) then) =
      __$$MembershipDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _int) int id,
      @JsonKey(fromJson: _membershipStatus) MembershipStatus status,
      @JsonKey(name: 'status_label', fromJson: _string) String statusLabel,
      OrganizationSummaryDto? organization,
      @JsonKey(name: 'requested_at', fromJson: _stringOrNull)
      String? requestedAt,
      @JsonKey(name: 'approved_at', fromJson: _stringOrNull) String? approvedAt,
      @JsonKey(name: 'rejected_at', fromJson: _stringOrNull) String? rejectedAt,
      @JsonKey(name: 'created_at', fromJson: _stringOrNull) String? createdAt});

  @override
  $OrganizationSummaryDtoCopyWith<$Res>? get organization;
}

/// @nodoc
class __$$MembershipDtoImplCopyWithImpl<$Res>
    extends _$MembershipDtoCopyWithImpl<$Res, _$MembershipDtoImpl>
    implements _$$MembershipDtoImplCopyWith<$Res> {
  __$$MembershipDtoImplCopyWithImpl(
      _$MembershipDtoImpl _value, $Res Function(_$MembershipDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? statusLabel = null,
    Object? organization = freezed,
    Object? requestedAt = freezed,
    Object? approvedAt = freezed,
    Object? rejectedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$MembershipDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MembershipStatus,
      statusLabel: null == statusLabel
          ? _value.statusLabel
          : statusLabel // ignore: cast_nullable_to_non_nullable
              as String,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as OrganizationSummaryDto?,
      requestedAt: freezed == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectedAt: freezed == rejectedAt
          ? _value.rejectedAt
          : rejectedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MembershipDtoImpl implements _MembershipDto {
  const _$MembershipDtoImpl(
      {@JsonKey(fromJson: _int) required this.id,
      @JsonKey(fromJson: _membershipStatus) required this.status,
      @JsonKey(name: 'status_label', fromJson: _string)
      required this.statusLabel,
      this.organization,
      @JsonKey(name: 'requested_at', fromJson: _stringOrNull) this.requestedAt,
      @JsonKey(name: 'approved_at', fromJson: _stringOrNull) this.approvedAt,
      @JsonKey(name: 'rejected_at', fromJson: _stringOrNull) this.rejectedAt,
      @JsonKey(name: 'created_at', fromJson: _stringOrNull) this.createdAt});

  factory _$MembershipDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MembershipDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _int)
  final int id;
  @override
  @JsonKey(fromJson: _membershipStatus)
  final MembershipStatus status;
  @override
  @JsonKey(name: 'status_label', fromJson: _string)
  final String statusLabel;
  @override
  final OrganizationSummaryDto? organization;
  @override
  @JsonKey(name: 'requested_at', fromJson: _stringOrNull)
  final String? requestedAt;
  @override
  @JsonKey(name: 'approved_at', fromJson: _stringOrNull)
  final String? approvedAt;
  @override
  @JsonKey(name: 'rejected_at', fromJson: _stringOrNull)
  final String? rejectedAt;
  @override
  @JsonKey(name: 'created_at', fromJson: _stringOrNull)
  final String? createdAt;

  @override
  String toString() {
    return 'MembershipDto(id: $id, status: $status, statusLabel: $statusLabel, organization: $organization, requestedAt: $requestedAt, approvedAt: $approvedAt, rejectedAt: $rejectedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusLabel, statusLabel) ||
                other.statusLabel == statusLabel) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.rejectedAt, rejectedAt) ||
                other.rejectedAt == rejectedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, status, statusLabel,
      organization, requestedAt, approvedAt, rejectedAt, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipDtoImplCopyWith<_$MembershipDtoImpl> get copyWith =>
      __$$MembershipDtoImplCopyWithImpl<_$MembershipDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MembershipDtoImplToJson(
      this,
    );
  }
}

abstract class _MembershipDto implements MembershipDto {
  const factory _MembershipDto(
      {@JsonKey(fromJson: _int) required final int id,
      @JsonKey(fromJson: _membershipStatus)
      required final MembershipStatus status,
      @JsonKey(name: 'status_label', fromJson: _string)
      required final String statusLabel,
      final OrganizationSummaryDto? organization,
      @JsonKey(name: 'requested_at', fromJson: _stringOrNull)
      final String? requestedAt,
      @JsonKey(name: 'approved_at', fromJson: _stringOrNull)
      final String? approvedAt,
      @JsonKey(name: 'rejected_at', fromJson: _stringOrNull)
      final String? rejectedAt,
      @JsonKey(name: 'created_at', fromJson: _stringOrNull)
      final String? createdAt}) = _$MembershipDtoImpl;

  factory _MembershipDto.fromJson(Map<String, dynamic> json) =
      _$MembershipDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _int)
  int get id;
  @override
  @JsonKey(fromJson: _membershipStatus)
  MembershipStatus get status;
  @override
  @JsonKey(name: 'status_label', fromJson: _string)
  String get statusLabel;
  @override
  OrganizationSummaryDto? get organization;
  @override
  @JsonKey(name: 'requested_at', fromJson: _stringOrNull)
  String? get requestedAt;
  @override
  @JsonKey(name: 'approved_at', fromJson: _stringOrNull)
  String? get approvedAt;
  @override
  @JsonKey(name: 'rejected_at', fromJson: _stringOrNull)
  String? get rejectedAt;
  @override
  @JsonKey(name: 'created_at', fromJson: _stringOrNull)
  String? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$MembershipDtoImplCopyWith<_$MembershipDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrganizationSummaryDto _$OrganizationSummaryDtoFromJson(
    Map<String, dynamic> json) {
  return _OrganizationSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$OrganizationSummaryDto {
  @JsonKey(fromJson: _intOrNull)
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get uuid => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get slug => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _string)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_url', fromJson: _stringOrNull)
  String? get logoUrl => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get logo => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_url', fromJson: _stringOrNull)
  String? get coverUrl => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get cover => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _bool)
  bool get verified =>
      throw _privateConstructorUsedError; // members_count exposes count(active) on OrganizationMember for this
// org. Excludes pending/rejected/suspended and the owner. Null when
// the backend response predates the addition (defensive).
  @JsonKey(name: 'members_count', fromJson: _intOrNull)
  int? get membersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'membersCount', fromJson: _intOrNull)
  int? get membersCountCamel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrganizationSummaryDtoCopyWith<OrganizationSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationSummaryDtoCopyWith<$Res> {
  factory $OrganizationSummaryDtoCopyWith(OrganizationSummaryDto value,
          $Res Function(OrganizationSummaryDto) then) =
      _$OrganizationSummaryDtoCopyWithImpl<$Res, OrganizationSummaryDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intOrNull) int? id,
      @JsonKey(fromJson: _stringOrNull) String? uuid,
      @JsonKey(fromJson: _stringOrNull) String? slug,
      @JsonKey(fromJson: _string) String name,
      @JsonKey(name: 'logo_url', fromJson: _stringOrNull) String? logoUrl,
      @JsonKey(fromJson: _stringOrNull) String? logo,
      @JsonKey(name: 'cover_url', fromJson: _stringOrNull) String? coverUrl,
      @JsonKey(fromJson: _stringOrNull) String? cover,
      @JsonKey(fromJson: _stringOrNull) String? address,
      @JsonKey(fromJson: _stringOrNull) String? city,
      @JsonKey(fromJson: _bool) bool verified,
      @JsonKey(name: 'members_count', fromJson: _intOrNull) int? membersCount,
      @JsonKey(name: 'membersCount', fromJson: _intOrNull)
      int? membersCountCamel});
}

/// @nodoc
class _$OrganizationSummaryDtoCopyWithImpl<$Res,
        $Val extends OrganizationSummaryDto>
    implements $OrganizationSummaryDtoCopyWith<$Res> {
  _$OrganizationSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? uuid = freezed,
    Object? slug = freezed,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? logo = freezed,
    Object? coverUrl = freezed,
    Object? cover = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? verified = null,
    Object? membersCount = freezed,
    Object? membersCountCamel = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cover: freezed == cover
          ? _value.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      membersCount: freezed == membersCount
          ? _value.membersCount
          : membersCount // ignore: cast_nullable_to_non_nullable
              as int?,
      membersCountCamel: freezed == membersCountCamel
          ? _value.membersCountCamel
          : membersCountCamel // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizationSummaryDtoImplCopyWith<$Res>
    implements $OrganizationSummaryDtoCopyWith<$Res> {
  factory _$$OrganizationSummaryDtoImplCopyWith(
          _$OrganizationSummaryDtoImpl value,
          $Res Function(_$OrganizationSummaryDtoImpl) then) =
      __$$OrganizationSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _intOrNull) int? id,
      @JsonKey(fromJson: _stringOrNull) String? uuid,
      @JsonKey(fromJson: _stringOrNull) String? slug,
      @JsonKey(fromJson: _string) String name,
      @JsonKey(name: 'logo_url', fromJson: _stringOrNull) String? logoUrl,
      @JsonKey(fromJson: _stringOrNull) String? logo,
      @JsonKey(name: 'cover_url', fromJson: _stringOrNull) String? coverUrl,
      @JsonKey(fromJson: _stringOrNull) String? cover,
      @JsonKey(fromJson: _stringOrNull) String? address,
      @JsonKey(fromJson: _stringOrNull) String? city,
      @JsonKey(fromJson: _bool) bool verified,
      @JsonKey(name: 'members_count', fromJson: _intOrNull) int? membersCount,
      @JsonKey(name: 'membersCount', fromJson: _intOrNull)
      int? membersCountCamel});
}

/// @nodoc
class __$$OrganizationSummaryDtoImplCopyWithImpl<$Res>
    extends _$OrganizationSummaryDtoCopyWithImpl<$Res,
        _$OrganizationSummaryDtoImpl>
    implements _$$OrganizationSummaryDtoImplCopyWith<$Res> {
  __$$OrganizationSummaryDtoImplCopyWithImpl(
      _$OrganizationSummaryDtoImpl _value,
      $Res Function(_$OrganizationSummaryDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? uuid = freezed,
    Object? slug = freezed,
    Object? name = null,
    Object? logoUrl = freezed,
    Object? logo = freezed,
    Object? coverUrl = freezed,
    Object? cover = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? verified = null,
    Object? membersCount = freezed,
    Object? membersCountCamel = freezed,
  }) {
    return _then(_$OrganizationSummaryDtoImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cover: freezed == cover
          ? _value.cover
          : cover // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      membersCount: freezed == membersCount
          ? _value.membersCount
          : membersCount // ignore: cast_nullable_to_non_nullable
              as int?,
      membersCountCamel: freezed == membersCountCamel
          ? _value.membersCountCamel
          : membersCountCamel // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizationSummaryDtoImpl implements _OrganizationSummaryDto {
  const _$OrganizationSummaryDtoImpl(
      {@JsonKey(fromJson: _intOrNull) this.id,
      @JsonKey(fromJson: _stringOrNull) this.uuid,
      @JsonKey(fromJson: _stringOrNull) this.slug,
      @JsonKey(fromJson: _string) this.name = '',
      @JsonKey(name: 'logo_url', fromJson: _stringOrNull) this.logoUrl,
      @JsonKey(fromJson: _stringOrNull) this.logo,
      @JsonKey(name: 'cover_url', fromJson: _stringOrNull) this.coverUrl,
      @JsonKey(fromJson: _stringOrNull) this.cover,
      @JsonKey(fromJson: _stringOrNull) this.address,
      @JsonKey(fromJson: _stringOrNull) this.city,
      @JsonKey(fromJson: _bool) this.verified = false,
      @JsonKey(name: 'members_count', fromJson: _intOrNull) this.membersCount,
      @JsonKey(name: 'membersCount', fromJson: _intOrNull)
      this.membersCountCamel});

  factory _$OrganizationSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizationSummaryDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _intOrNull)
  final int? id;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? uuid;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? slug;
  @override
  @JsonKey(fromJson: _string)
  final String name;
  @override
  @JsonKey(name: 'logo_url', fromJson: _stringOrNull)
  final String? logoUrl;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? logo;
  @override
  @JsonKey(name: 'cover_url', fromJson: _stringOrNull)
  final String? coverUrl;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? cover;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? address;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? city;
  @override
  @JsonKey(fromJson: _bool)
  final bool verified;
// members_count exposes count(active) on OrganizationMember for this
// org. Excludes pending/rejected/suspended and the owner. Null when
// the backend response predates the addition (defensive).
  @override
  @JsonKey(name: 'members_count', fromJson: _intOrNull)
  final int? membersCount;
  @override
  @JsonKey(name: 'membersCount', fromJson: _intOrNull)
  final int? membersCountCamel;

  @override
  String toString() {
    return 'OrganizationSummaryDto(id: $id, uuid: $uuid, slug: $slug, name: $name, logoUrl: $logoUrl, logo: $logo, coverUrl: $coverUrl, cover: $cover, address: $address, city: $city, verified: $verified, membersCount: $membersCount, membersCountCamel: $membersCountCamel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationSummaryDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.logo, logo) || other.logo == logo) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.cover, cover) || other.cover == cover) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.membersCount, membersCount) ||
                other.membersCount == membersCount) &&
            (identical(other.membersCountCamel, membersCountCamel) ||
                other.membersCountCamel == membersCountCamel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      uuid,
      slug,
      name,
      logoUrl,
      logo,
      coverUrl,
      cover,
      address,
      city,
      verified,
      membersCount,
      membersCountCamel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationSummaryDtoImplCopyWith<_$OrganizationSummaryDtoImpl>
      get copyWith => __$$OrganizationSummaryDtoImplCopyWithImpl<
          _$OrganizationSummaryDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizationSummaryDtoImplToJson(
      this,
    );
  }
}

abstract class _OrganizationSummaryDto implements OrganizationSummaryDto {
  const factory _OrganizationSummaryDto(
      {@JsonKey(fromJson: _intOrNull) final int? id,
      @JsonKey(fromJson: _stringOrNull) final String? uuid,
      @JsonKey(fromJson: _stringOrNull) final String? slug,
      @JsonKey(fromJson: _string) final String name,
      @JsonKey(name: 'logo_url', fromJson: _stringOrNull) final String? logoUrl,
      @JsonKey(fromJson: _stringOrNull) final String? logo,
      @JsonKey(name: 'cover_url', fromJson: _stringOrNull)
      final String? coverUrl,
      @JsonKey(fromJson: _stringOrNull) final String? cover,
      @JsonKey(fromJson: _stringOrNull) final String? address,
      @JsonKey(fromJson: _stringOrNull) final String? city,
      @JsonKey(fromJson: _bool) final bool verified,
      @JsonKey(name: 'members_count', fromJson: _intOrNull)
      final int? membersCount,
      @JsonKey(name: 'membersCount', fromJson: _intOrNull)
      final int? membersCountCamel}) = _$OrganizationSummaryDtoImpl;

  factory _OrganizationSummaryDto.fromJson(Map<String, dynamic> json) =
      _$OrganizationSummaryDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _intOrNull)
  int? get id;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get uuid;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get slug;
  @override
  @JsonKey(fromJson: _string)
  String get name;
  @override
  @JsonKey(name: 'logo_url', fromJson: _stringOrNull)
  String? get logoUrl;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get logo;
  @override
  @JsonKey(name: 'cover_url', fromJson: _stringOrNull)
  String? get coverUrl;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get cover;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get address;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get city;
  @override
  @JsonKey(fromJson: _bool)
  bool get verified;
  @override // members_count exposes count(active) on OrganizationMember for this
// org. Excludes pending/rejected/suspended and the owner. Null when
// the backend response predates the addition (defensive).
  @JsonKey(name: 'members_count', fromJson: _intOrNull)
  int? get membersCount;
  @override
  @JsonKey(name: 'membersCount', fromJson: _intOrNull)
  int? get membersCountCamel;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationSummaryDtoImplCopyWith<_$OrganizationSummaryDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MembershipsPage _$MembershipsPageFromJson(Map<String, dynamic> json) {
  return _MembershipsPage.fromJson(json);
}

/// @nodoc
mixin _$MembershipsPage {
  List<MembershipDto> get data => throw _privateConstructorUsedError;
  MembershipsMetaDto? get meta => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MembershipsPageCopyWith<MembershipsPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipsPageCopyWith<$Res> {
  factory $MembershipsPageCopyWith(
          MembershipsPage value, $Res Function(MembershipsPage) then) =
      _$MembershipsPageCopyWithImpl<$Res, MembershipsPage>;
  @useResult
  $Res call({List<MembershipDto> data, MembershipsMetaDto? meta});

  $MembershipsMetaDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class _$MembershipsPageCopyWithImpl<$Res, $Val extends MembershipsPage>
    implements $MembershipsPageCopyWith<$Res> {
  _$MembershipsPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<MembershipDto>,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MembershipsMetaDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MembershipsMetaDtoCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $MembershipsMetaDtoCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MembershipsPageImplCopyWith<$Res>
    implements $MembershipsPageCopyWith<$Res> {
  factory _$$MembershipsPageImplCopyWith(_$MembershipsPageImpl value,
          $Res Function(_$MembershipsPageImpl) then) =
      __$$MembershipsPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MembershipDto> data, MembershipsMetaDto? meta});

  @override
  $MembershipsMetaDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class __$$MembershipsPageImplCopyWithImpl<$Res>
    extends _$MembershipsPageCopyWithImpl<$Res, _$MembershipsPageImpl>
    implements _$$MembershipsPageImplCopyWith<$Res> {
  __$$MembershipsPageImplCopyWithImpl(
      _$MembershipsPageImpl _value, $Res Function(_$MembershipsPageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_$MembershipsPageImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<MembershipDto>,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MembershipsMetaDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MembershipsPageImpl implements _MembershipsPage {
  const _$MembershipsPageImpl(
      {final List<MembershipDto> data = const [], this.meta})
      : _data = data;

  factory _$MembershipsPageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MembershipsPageImplFromJson(json);

  final List<MembershipDto> _data;
  @override
  @JsonKey()
  List<MembershipDto> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final MembershipsMetaDto? meta;

  @override
  String toString() {
    return 'MembershipsPage(data: $data, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipsPageImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), meta);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipsPageImplCopyWith<_$MembershipsPageImpl> get copyWith =>
      __$$MembershipsPageImplCopyWithImpl<_$MembershipsPageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MembershipsPageImplToJson(
      this,
    );
  }
}

abstract class _MembershipsPage implements MembershipsPage {
  const factory _MembershipsPage(
      {final List<MembershipDto> data,
      final MembershipsMetaDto? meta}) = _$MembershipsPageImpl;

  factory _MembershipsPage.fromJson(Map<String, dynamic> json) =
      _$MembershipsPageImpl.fromJson;

  @override
  List<MembershipDto> get data;
  @override
  MembershipsMetaDto? get meta;
  @override
  @JsonKey(ignore: true)
  _$$MembershipsPageImplCopyWith<_$MembershipsPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MembershipsMetaDto _$MembershipsMetaDtoFromJson(Map<String, dynamic> json) {
  return _MembershipsMetaDto.fromJson(json);
}

/// @nodoc
mixin _$MembershipsMetaDto {
  @JsonKey(fromJson: _int)
  int get total => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _int)
  int get page => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page', fromJson: _int)
  int get perPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_page', fromJson: _int)
  int get lastPage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MembershipsMetaDtoCopyWith<MembershipsMetaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MembershipsMetaDtoCopyWith<$Res> {
  factory $MembershipsMetaDtoCopyWith(
          MembershipsMetaDto value, $Res Function(MembershipsMetaDto) then) =
      _$MembershipsMetaDtoCopyWithImpl<$Res, MembershipsMetaDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _int) int total,
      @JsonKey(fromJson: _int) int page,
      @JsonKey(name: 'per_page', fromJson: _int) int perPage,
      @JsonKey(name: 'last_page', fromJson: _int) int lastPage});
}

/// @nodoc
class _$MembershipsMetaDtoCopyWithImpl<$Res, $Val extends MembershipsMetaDto>
    implements $MembershipsMetaDtoCopyWith<$Res> {
  _$MembershipsMetaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? page = null,
    Object? perPage = null,
    Object? lastPage = null,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MembershipsMetaDtoImplCopyWith<$Res>
    implements $MembershipsMetaDtoCopyWith<$Res> {
  factory _$$MembershipsMetaDtoImplCopyWith(_$MembershipsMetaDtoImpl value,
          $Res Function(_$MembershipsMetaDtoImpl) then) =
      __$$MembershipsMetaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _int) int total,
      @JsonKey(fromJson: _int) int page,
      @JsonKey(name: 'per_page', fromJson: _int) int perPage,
      @JsonKey(name: 'last_page', fromJson: _int) int lastPage});
}

/// @nodoc
class __$$MembershipsMetaDtoImplCopyWithImpl<$Res>
    extends _$MembershipsMetaDtoCopyWithImpl<$Res, _$MembershipsMetaDtoImpl>
    implements _$$MembershipsMetaDtoImplCopyWith<$Res> {
  __$$MembershipsMetaDtoImplCopyWithImpl(_$MembershipsMetaDtoImpl _value,
      $Res Function(_$MembershipsMetaDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? page = null,
    Object? perPage = null,
    Object? lastPage = null,
  }) {
    return _then(_$MembershipsMetaDtoImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MembershipsMetaDtoImpl implements _MembershipsMetaDto {
  const _$MembershipsMetaDtoImpl(
      {@JsonKey(fromJson: _int) this.total = 0,
      @JsonKey(fromJson: _int) this.page = 1,
      @JsonKey(name: 'per_page', fromJson: _int) this.perPage = 15,
      @JsonKey(name: 'last_page', fromJson: _int) this.lastPage = 1});

  factory _$MembershipsMetaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MembershipsMetaDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _int)
  final int total;
  @override
  @JsonKey(fromJson: _int)
  final int page;
  @override
  @JsonKey(name: 'per_page', fromJson: _int)
  final int perPage;
  @override
  @JsonKey(name: 'last_page', fromJson: _int)
  final int lastPage;

  @override
  String toString() {
    return 'MembershipsMetaDto(total: $total, page: $page, perPage: $perPage, lastPage: $lastPage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MembershipsMetaDtoImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, total, page, perPage, lastPage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MembershipsMetaDtoImplCopyWith<_$MembershipsMetaDtoImpl> get copyWith =>
      __$$MembershipsMetaDtoImplCopyWithImpl<_$MembershipsMetaDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MembershipsMetaDtoImplToJson(
      this,
    );
  }
}

abstract class _MembershipsMetaDto implements MembershipsMetaDto {
  const factory _MembershipsMetaDto(
          {@JsonKey(fromJson: _int) final int total,
          @JsonKey(fromJson: _int) final int page,
          @JsonKey(name: 'per_page', fromJson: _int) final int perPage,
          @JsonKey(name: 'last_page', fromJson: _int) final int lastPage}) =
      _$MembershipsMetaDtoImpl;

  factory _MembershipsMetaDto.fromJson(Map<String, dynamic> json) =
      _$MembershipsMetaDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _int)
  int get total;
  @override
  @JsonKey(fromJson: _int)
  int get page;
  @override
  @JsonKey(name: 'per_page', fromJson: _int)
  int get perPage;
  @override
  @JsonKey(name: 'last_page', fromJson: _int)
  int get lastPage;
  @override
  @JsonKey(ignore: true)
  _$$MembershipsMetaDtoImplCopyWith<_$MembershipsMetaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

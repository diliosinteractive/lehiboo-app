// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invitation_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InvitationDto _$InvitationDtoFromJson(Map<String, dynamic> json) {
  return _InvitationDto.fromJson(json);
}

/// @nodoc
mixin _$InvitationDto {
  @JsonKey(fromJson: _int)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _string)
  String get email => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_label', fromJson: _stringOrNull)
  String? get roleLabel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_valid', fromJson: _bool)
  bool get isValid => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_expired', fromJson: _bool)
  bool get isExpired => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_accepted', fromJson: _bool)
  bool get isAccepted => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_account', fromJson: _boolOrNull)
  bool? get hasAccount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get token => throw _privateConstructorUsedError;
  OrganizationSummaryDto? get organization =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'invited_by')
  InvitedByDto? get invitedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at', fromJson: _stringOrNull)
  String? get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'accepted_at', fromJson: _stringOrNull)
  String? get acceptedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: _stringOrNull)
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at', fromJson: _stringOrNull)
  String? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvitationDtoCopyWith<InvitationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvitationDtoCopyWith<$Res> {
  factory $InvitationDtoCopyWith(
          InvitationDto value, $Res Function(InvitationDto) then) =
      _$InvitationDtoCopyWithImpl<$Res, InvitationDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _int) int id,
      @JsonKey(fromJson: _stringOrNull) String? type,
      @JsonKey(fromJson: _string) String email,
      @JsonKey(fromJson: _stringOrNull) String? role,
      @JsonKey(name: 'role_label', fromJson: _stringOrNull) String? roleLabel,
      @JsonKey(name: 'is_valid', fromJson: _bool) bool isValid,
      @JsonKey(name: 'is_expired', fromJson: _bool) bool isExpired,
      @JsonKey(name: 'is_accepted', fromJson: _bool) bool isAccepted,
      @JsonKey(name: 'has_account', fromJson: _boolOrNull) bool? hasAccount,
      @JsonKey(fromJson: _stringOrNull) String? token,
      OrganizationSummaryDto? organization,
      @JsonKey(name: 'invited_by') InvitedByDto? invitedBy,
      @JsonKey(name: 'expires_at', fromJson: _stringOrNull) String? expiresAt,
      @JsonKey(name: 'accepted_at', fromJson: _stringOrNull) String? acceptedAt,
      @JsonKey(name: 'created_at', fromJson: _stringOrNull) String? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _stringOrNull) String? updatedAt});

  $OrganizationSummaryDtoCopyWith<$Res>? get organization;
  $InvitedByDtoCopyWith<$Res>? get invitedBy;
}

/// @nodoc
class _$InvitationDtoCopyWithImpl<$Res, $Val extends InvitationDto>
    implements $InvitationDtoCopyWith<$Res> {
  _$InvitationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = freezed,
    Object? email = null,
    Object? role = freezed,
    Object? roleLabel = freezed,
    Object? isValid = null,
    Object? isExpired = null,
    Object? isAccepted = null,
    Object? hasAccount = freezed,
    Object? token = freezed,
    Object? organization = freezed,
    Object? invitedBy = freezed,
    Object? expiresAt = freezed,
    Object? acceptedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      roleLabel: freezed == roleLabel
          ? _value.roleLabel
          : roleLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      isExpired: null == isExpired
          ? _value.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool,
      isAccepted: null == isAccepted
          ? _value.isAccepted
          : isAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAccount: freezed == hasAccount
          ? _value.hasAccount
          : hasAccount // ignore: cast_nullable_to_non_nullable
              as bool?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as OrganizationSummaryDto?,
      invitedBy: freezed == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as InvitedByDto?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
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

  @override
  @pragma('vm:prefer-inline')
  $InvitedByDtoCopyWith<$Res>? get invitedBy {
    if (_value.invitedBy == null) {
      return null;
    }

    return $InvitedByDtoCopyWith<$Res>(_value.invitedBy!, (value) {
      return _then(_value.copyWith(invitedBy: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InvitationDtoImplCopyWith<$Res>
    implements $InvitationDtoCopyWith<$Res> {
  factory _$$InvitationDtoImplCopyWith(
          _$InvitationDtoImpl value, $Res Function(_$InvitationDtoImpl) then) =
      __$$InvitationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _int) int id,
      @JsonKey(fromJson: _stringOrNull) String? type,
      @JsonKey(fromJson: _string) String email,
      @JsonKey(fromJson: _stringOrNull) String? role,
      @JsonKey(name: 'role_label', fromJson: _stringOrNull) String? roleLabel,
      @JsonKey(name: 'is_valid', fromJson: _bool) bool isValid,
      @JsonKey(name: 'is_expired', fromJson: _bool) bool isExpired,
      @JsonKey(name: 'is_accepted', fromJson: _bool) bool isAccepted,
      @JsonKey(name: 'has_account', fromJson: _boolOrNull) bool? hasAccount,
      @JsonKey(fromJson: _stringOrNull) String? token,
      OrganizationSummaryDto? organization,
      @JsonKey(name: 'invited_by') InvitedByDto? invitedBy,
      @JsonKey(name: 'expires_at', fromJson: _stringOrNull) String? expiresAt,
      @JsonKey(name: 'accepted_at', fromJson: _stringOrNull) String? acceptedAt,
      @JsonKey(name: 'created_at', fromJson: _stringOrNull) String? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _stringOrNull) String? updatedAt});

  @override
  $OrganizationSummaryDtoCopyWith<$Res>? get organization;
  @override
  $InvitedByDtoCopyWith<$Res>? get invitedBy;
}

/// @nodoc
class __$$InvitationDtoImplCopyWithImpl<$Res>
    extends _$InvitationDtoCopyWithImpl<$Res, _$InvitationDtoImpl>
    implements _$$InvitationDtoImplCopyWith<$Res> {
  __$$InvitationDtoImplCopyWithImpl(
      _$InvitationDtoImpl _value, $Res Function(_$InvitationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = freezed,
    Object? email = null,
    Object? role = freezed,
    Object? roleLabel = freezed,
    Object? isValid = null,
    Object? isExpired = null,
    Object? isAccepted = null,
    Object? hasAccount = freezed,
    Object? token = freezed,
    Object? organization = freezed,
    Object? invitedBy = freezed,
    Object? expiresAt = freezed,
    Object? acceptedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$InvitationDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      roleLabel: freezed == roleLabel
          ? _value.roleLabel
          : roleLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      isExpired: null == isExpired
          ? _value.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool,
      isAccepted: null == isAccepted
          ? _value.isAccepted
          : isAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAccount: freezed == hasAccount
          ? _value.hasAccount
          : hasAccount // ignore: cast_nullable_to_non_nullable
              as bool?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as OrganizationSummaryDto?,
      invitedBy: freezed == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as InvitedByDto?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvitationDtoImpl implements _InvitationDto {
  const _$InvitationDtoImpl(
      {@JsonKey(fromJson: _int) required this.id,
      @JsonKey(fromJson: _stringOrNull) this.type,
      @JsonKey(fromJson: _string) this.email = '',
      @JsonKey(fromJson: _stringOrNull) this.role,
      @JsonKey(name: 'role_label', fromJson: _stringOrNull) this.roleLabel,
      @JsonKey(name: 'is_valid', fromJson: _bool) this.isValid = false,
      @JsonKey(name: 'is_expired', fromJson: _bool) this.isExpired = false,
      @JsonKey(name: 'is_accepted', fromJson: _bool) this.isAccepted = false,
      @JsonKey(name: 'has_account', fromJson: _boolOrNull) this.hasAccount,
      @JsonKey(fromJson: _stringOrNull) this.token,
      this.organization,
      @JsonKey(name: 'invited_by') this.invitedBy,
      @JsonKey(name: 'expires_at', fromJson: _stringOrNull) this.expiresAt,
      @JsonKey(name: 'accepted_at', fromJson: _stringOrNull) this.acceptedAt,
      @JsonKey(name: 'created_at', fromJson: _stringOrNull) this.createdAt,
      @JsonKey(name: 'updated_at', fromJson: _stringOrNull) this.updatedAt});

  factory _$InvitationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvitationDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _int)
  final int id;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? type;
  @override
  @JsonKey(fromJson: _string)
  final String email;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? role;
  @override
  @JsonKey(name: 'role_label', fromJson: _stringOrNull)
  final String? roleLabel;
  @override
  @JsonKey(name: 'is_valid', fromJson: _bool)
  final bool isValid;
  @override
  @JsonKey(name: 'is_expired', fromJson: _bool)
  final bool isExpired;
  @override
  @JsonKey(name: 'is_accepted', fromJson: _bool)
  final bool isAccepted;
  @override
  @JsonKey(name: 'has_account', fromJson: _boolOrNull)
  final bool? hasAccount;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? token;
  @override
  final OrganizationSummaryDto? organization;
  @override
  @JsonKey(name: 'invited_by')
  final InvitedByDto? invitedBy;
  @override
  @JsonKey(name: 'expires_at', fromJson: _stringOrNull)
  final String? expiresAt;
  @override
  @JsonKey(name: 'accepted_at', fromJson: _stringOrNull)
  final String? acceptedAt;
  @override
  @JsonKey(name: 'created_at', fromJson: _stringOrNull)
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _stringOrNull)
  final String? updatedAt;

  @override
  String toString() {
    return 'InvitationDto(id: $id, type: $type, email: $email, role: $role, roleLabel: $roleLabel, isValid: $isValid, isExpired: $isExpired, isAccepted: $isAccepted, hasAccount: $hasAccount, token: $token, organization: $organization, invitedBy: $invitedBy, expiresAt: $expiresAt, acceptedAt: $acceptedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvitationDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.roleLabel, roleLabel) ||
                other.roleLabel == roleLabel) &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            (identical(other.isExpired, isExpired) ||
                other.isExpired == isExpired) &&
            (identical(other.isAccepted, isAccepted) ||
                other.isAccepted == isAccepted) &&
            (identical(other.hasAccount, hasAccount) ||
                other.hasAccount == hasAccount) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.invitedBy, invitedBy) ||
                other.invitedBy == invitedBy) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      email,
      role,
      roleLabel,
      isValid,
      isExpired,
      isAccepted,
      hasAccount,
      token,
      organization,
      invitedBy,
      expiresAt,
      acceptedAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvitationDtoImplCopyWith<_$InvitationDtoImpl> get copyWith =>
      __$$InvitationDtoImplCopyWithImpl<_$InvitationDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvitationDtoImplToJson(
      this,
    );
  }
}

abstract class _InvitationDto implements InvitationDto {
  const factory _InvitationDto(
      {@JsonKey(fromJson: _int) required final int id,
      @JsonKey(fromJson: _stringOrNull) final String? type,
      @JsonKey(fromJson: _string) final String email,
      @JsonKey(fromJson: _stringOrNull) final String? role,
      @JsonKey(name: 'role_label', fromJson: _stringOrNull)
      final String? roleLabel,
      @JsonKey(name: 'is_valid', fromJson: _bool) final bool isValid,
      @JsonKey(name: 'is_expired', fromJson: _bool) final bool isExpired,
      @JsonKey(name: 'is_accepted', fromJson: _bool) final bool isAccepted,
      @JsonKey(name: 'has_account', fromJson: _boolOrNull)
      final bool? hasAccount,
      @JsonKey(fromJson: _stringOrNull) final String? token,
      final OrganizationSummaryDto? organization,
      @JsonKey(name: 'invited_by') final InvitedByDto? invitedBy,
      @JsonKey(name: 'expires_at', fromJson: _stringOrNull)
      final String? expiresAt,
      @JsonKey(name: 'accepted_at', fromJson: _stringOrNull)
      final String? acceptedAt,
      @JsonKey(name: 'created_at', fromJson: _stringOrNull)
      final String? createdAt,
      @JsonKey(name: 'updated_at', fromJson: _stringOrNull)
      final String? updatedAt}) = _$InvitationDtoImpl;

  factory _InvitationDto.fromJson(Map<String, dynamic> json) =
      _$InvitationDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _int)
  int get id;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get type;
  @override
  @JsonKey(fromJson: _string)
  String get email;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get role;
  @override
  @JsonKey(name: 'role_label', fromJson: _stringOrNull)
  String? get roleLabel;
  @override
  @JsonKey(name: 'is_valid', fromJson: _bool)
  bool get isValid;
  @override
  @JsonKey(name: 'is_expired', fromJson: _bool)
  bool get isExpired;
  @override
  @JsonKey(name: 'is_accepted', fromJson: _bool)
  bool get isAccepted;
  @override
  @JsonKey(name: 'has_account', fromJson: _boolOrNull)
  bool? get hasAccount;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get token;
  @override
  OrganizationSummaryDto? get organization;
  @override
  @JsonKey(name: 'invited_by')
  InvitedByDto? get invitedBy;
  @override
  @JsonKey(name: 'expires_at', fromJson: _stringOrNull)
  String? get expiresAt;
  @override
  @JsonKey(name: 'accepted_at', fromJson: _stringOrNull)
  String? get acceptedAt;
  @override
  @JsonKey(name: 'created_at', fromJson: _stringOrNull)
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at', fromJson: _stringOrNull)
  String? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$InvitationDtoImplCopyWith<_$InvitationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InvitedByDto _$InvitedByDtoFromJson(Map<String, dynamic> json) {
  return _InvitedByDto.fromJson(json);
}

/// @nodoc
mixin _$InvitedByDto {
  @JsonKey(fromJson: _stringOrNull)
  String? get uuid => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _string)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get avatar => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvitedByDtoCopyWith<InvitedByDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvitedByDtoCopyWith<$Res> {
  factory $InvitedByDtoCopyWith(
          InvitedByDto value, $Res Function(InvitedByDto) then) =
      _$InvitedByDtoCopyWithImpl<$Res, InvitedByDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _stringOrNull) String? uuid,
      @JsonKey(fromJson: _string) String name,
      @JsonKey(fromJson: _stringOrNull) String? avatar});
}

/// @nodoc
class _$InvitedByDtoCopyWithImpl<$Res, $Val extends InvitedByDto>
    implements $InvitedByDtoCopyWith<$Res> {
  _$InvitedByDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? name = null,
    Object? avatar = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvitedByDtoImplCopyWith<$Res>
    implements $InvitedByDtoCopyWith<$Res> {
  factory _$$InvitedByDtoImplCopyWith(
          _$InvitedByDtoImpl value, $Res Function(_$InvitedByDtoImpl) then) =
      __$$InvitedByDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _stringOrNull) String? uuid,
      @JsonKey(fromJson: _string) String name,
      @JsonKey(fromJson: _stringOrNull) String? avatar});
}

/// @nodoc
class __$$InvitedByDtoImplCopyWithImpl<$Res>
    extends _$InvitedByDtoCopyWithImpl<$Res, _$InvitedByDtoImpl>
    implements _$$InvitedByDtoImplCopyWith<$Res> {
  __$$InvitedByDtoImplCopyWithImpl(
      _$InvitedByDtoImpl _value, $Res Function(_$InvitedByDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? name = null,
    Object? avatar = freezed,
  }) {
    return _then(_$InvitedByDtoImpl(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvitedByDtoImpl implements _InvitedByDto {
  const _$InvitedByDtoImpl(
      {@JsonKey(fromJson: _stringOrNull) this.uuid,
      @JsonKey(fromJson: _string) this.name = '',
      @JsonKey(fromJson: _stringOrNull) this.avatar});

  factory _$InvitedByDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvitedByDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? uuid;
  @override
  @JsonKey(fromJson: _string)
  final String name;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? avatar;

  @override
  String toString() {
    return 'InvitedByDto(uuid: $uuid, name: $name, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvitedByDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, name, avatar);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvitedByDtoImplCopyWith<_$InvitedByDtoImpl> get copyWith =>
      __$$InvitedByDtoImplCopyWithImpl<_$InvitedByDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvitedByDtoImplToJson(
      this,
    );
  }
}

abstract class _InvitedByDto implements InvitedByDto {
  const factory _InvitedByDto(
          {@JsonKey(fromJson: _stringOrNull) final String? uuid,
          @JsonKey(fromJson: _string) final String name,
          @JsonKey(fromJson: _stringOrNull) final String? avatar}) =
      _$InvitedByDtoImpl;

  factory _InvitedByDto.fromJson(Map<String, dynamic> json) =
      _$InvitedByDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get uuid;
  @override
  @JsonKey(fromJson: _string)
  String get name;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get avatar;
  @override
  @JsonKey(ignore: true)
  _$$InvitedByDtoImplCopyWith<_$InvitedByDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InvitationPreviewDto _$InvitationPreviewDtoFromJson(Map<String, dynamic> json) {
  return _InvitationPreviewDto.fromJson(json);
}

/// @nodoc
mixin _$InvitationPreviewDto {
  InvitationDto? get data => throw _privateConstructorUsedError;
  InvitationPreviewMetaDto? get meta => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get message => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvitationPreviewDtoCopyWith<InvitationPreviewDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvitationPreviewDtoCopyWith<$Res> {
  factory $InvitationPreviewDtoCopyWith(InvitationPreviewDto value,
          $Res Function(InvitationPreviewDto) then) =
      _$InvitationPreviewDtoCopyWithImpl<$Res, InvitationPreviewDto>;
  @useResult
  $Res call(
      {InvitationDto? data,
      InvitationPreviewMetaDto? meta,
      @JsonKey(fromJson: _stringOrNull) String? message});

  $InvitationDtoCopyWith<$Res>? get data;
  $InvitationPreviewMetaDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class _$InvitationPreviewDtoCopyWithImpl<$Res,
        $Val extends InvitationPreviewDto>
    implements $InvitationPreviewDtoCopyWith<$Res> {
  _$InvitationPreviewDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? meta = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as InvitationDto?,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as InvitationPreviewMetaDto?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $InvitationDtoCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $InvitationDtoCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $InvitationPreviewMetaDtoCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $InvitationPreviewMetaDtoCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InvitationPreviewDtoImplCopyWith<$Res>
    implements $InvitationPreviewDtoCopyWith<$Res> {
  factory _$$InvitationPreviewDtoImplCopyWith(_$InvitationPreviewDtoImpl value,
          $Res Function(_$InvitationPreviewDtoImpl) then) =
      __$$InvitationPreviewDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {InvitationDto? data,
      InvitationPreviewMetaDto? meta,
      @JsonKey(fromJson: _stringOrNull) String? message});

  @override
  $InvitationDtoCopyWith<$Res>? get data;
  @override
  $InvitationPreviewMetaDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class __$$InvitationPreviewDtoImplCopyWithImpl<$Res>
    extends _$InvitationPreviewDtoCopyWithImpl<$Res, _$InvitationPreviewDtoImpl>
    implements _$$InvitationPreviewDtoImplCopyWith<$Res> {
  __$$InvitationPreviewDtoImplCopyWithImpl(_$InvitationPreviewDtoImpl _value,
      $Res Function(_$InvitationPreviewDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? meta = freezed,
    Object? message = freezed,
  }) {
    return _then(_$InvitationPreviewDtoImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as InvitationDto?,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as InvitationPreviewMetaDto?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvitationPreviewDtoImpl implements _InvitationPreviewDto {
  const _$InvitationPreviewDtoImpl(
      {this.data, this.meta, @JsonKey(fromJson: _stringOrNull) this.message});

  factory _$InvitationPreviewDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvitationPreviewDtoImplFromJson(json);

  @override
  final InvitationDto? data;
  @override
  final InvitationPreviewMetaDto? meta;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? message;

  @override
  String toString() {
    return 'InvitationPreviewDto(data: $data, meta: $meta, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvitationPreviewDtoImpl &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.meta, meta) || other.meta == meta) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, data, meta, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvitationPreviewDtoImplCopyWith<_$InvitationPreviewDtoImpl>
      get copyWith =>
          __$$InvitationPreviewDtoImplCopyWithImpl<_$InvitationPreviewDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvitationPreviewDtoImplToJson(
      this,
    );
  }
}

abstract class _InvitationPreviewDto implements InvitationPreviewDto {
  const factory _InvitationPreviewDto(
          {final InvitationDto? data,
          final InvitationPreviewMetaDto? meta,
          @JsonKey(fromJson: _stringOrNull) final String? message}) =
      _$InvitationPreviewDtoImpl;

  factory _InvitationPreviewDto.fromJson(Map<String, dynamic> json) =
      _$InvitationPreviewDtoImpl.fromJson;

  @override
  InvitationDto? get data;
  @override
  InvitationPreviewMetaDto? get meta;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get message;
  @override
  @JsonKey(ignore: true)
  _$$InvitationPreviewDtoImplCopyWith<_$InvitationPreviewDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

InvitationPreviewMetaDto _$InvitationPreviewMetaDtoFromJson(
    Map<String, dynamic> json) {
  return _InvitationPreviewMetaDto.fromJson(json);
}

/// @nodoc
mixin _$InvitationPreviewMetaDto {
  @JsonKey(name: 'is_valid', fromJson: _bool)
  bool get isValid => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_in_hours', fromJson: _intOrNull)
  int? get expiresInHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_name', fromJson: _stringOrNull)
  String? get organizationName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'role_label', fromJson: _stringOrNull)
  String? get roleLabel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvitationPreviewMetaDtoCopyWith<InvitationPreviewMetaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvitationPreviewMetaDtoCopyWith<$Res> {
  factory $InvitationPreviewMetaDtoCopyWith(InvitationPreviewMetaDto value,
          $Res Function(InvitationPreviewMetaDto) then) =
      _$InvitationPreviewMetaDtoCopyWithImpl<$Res, InvitationPreviewMetaDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'is_valid', fromJson: _bool) bool isValid,
      @JsonKey(name: 'expires_in_hours', fromJson: _intOrNull)
      int? expiresInHours,
      @JsonKey(name: 'organization_name', fromJson: _stringOrNull)
      String? organizationName,
      @JsonKey(fromJson: _stringOrNull) String? role,
      @JsonKey(name: 'role_label', fromJson: _stringOrNull) String? roleLabel});
}

/// @nodoc
class _$InvitationPreviewMetaDtoCopyWithImpl<$Res,
        $Val extends InvitationPreviewMetaDto>
    implements $InvitationPreviewMetaDtoCopyWith<$Res> {
  _$InvitationPreviewMetaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? expiresInHours = freezed,
    Object? organizationName = freezed,
    Object? role = freezed,
    Object? roleLabel = freezed,
  }) {
    return _then(_value.copyWith(
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresInHours: freezed == expiresInHours
          ? _value.expiresInHours
          : expiresInHours // ignore: cast_nullable_to_non_nullable
              as int?,
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      roleLabel: freezed == roleLabel
          ? _value.roleLabel
          : roleLabel // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvitationPreviewMetaDtoImplCopyWith<$Res>
    implements $InvitationPreviewMetaDtoCopyWith<$Res> {
  factory _$$InvitationPreviewMetaDtoImplCopyWith(
          _$InvitationPreviewMetaDtoImpl value,
          $Res Function(_$InvitationPreviewMetaDtoImpl) then) =
      __$$InvitationPreviewMetaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'is_valid', fromJson: _bool) bool isValid,
      @JsonKey(name: 'expires_in_hours', fromJson: _intOrNull)
      int? expiresInHours,
      @JsonKey(name: 'organization_name', fromJson: _stringOrNull)
      String? organizationName,
      @JsonKey(fromJson: _stringOrNull) String? role,
      @JsonKey(name: 'role_label', fromJson: _stringOrNull) String? roleLabel});
}

/// @nodoc
class __$$InvitationPreviewMetaDtoImplCopyWithImpl<$Res>
    extends _$InvitationPreviewMetaDtoCopyWithImpl<$Res,
        _$InvitationPreviewMetaDtoImpl>
    implements _$$InvitationPreviewMetaDtoImplCopyWith<$Res> {
  __$$InvitationPreviewMetaDtoImplCopyWithImpl(
      _$InvitationPreviewMetaDtoImpl _value,
      $Res Function(_$InvitationPreviewMetaDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
    Object? expiresInHours = freezed,
    Object? organizationName = freezed,
    Object? role = freezed,
    Object? roleLabel = freezed,
  }) {
    return _then(_$InvitationPreviewMetaDtoImpl(
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresInHours: freezed == expiresInHours
          ? _value.expiresInHours
          : expiresInHours // ignore: cast_nullable_to_non_nullable
              as int?,
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      roleLabel: freezed == roleLabel
          ? _value.roleLabel
          : roleLabel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvitationPreviewMetaDtoImpl implements _InvitationPreviewMetaDto {
  const _$InvitationPreviewMetaDtoImpl(
      {@JsonKey(name: 'is_valid', fromJson: _bool) this.isValid = false,
      @JsonKey(name: 'expires_in_hours', fromJson: _intOrNull)
      this.expiresInHours,
      @JsonKey(name: 'organization_name', fromJson: _stringOrNull)
      this.organizationName,
      @JsonKey(fromJson: _stringOrNull) this.role,
      @JsonKey(name: 'role_label', fromJson: _stringOrNull) this.roleLabel});

  factory _$InvitationPreviewMetaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvitationPreviewMetaDtoImplFromJson(json);

  @override
  @JsonKey(name: 'is_valid', fromJson: _bool)
  final bool isValid;
  @override
  @JsonKey(name: 'expires_in_hours', fromJson: _intOrNull)
  final int? expiresInHours;
  @override
  @JsonKey(name: 'organization_name', fromJson: _stringOrNull)
  final String? organizationName;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? role;
  @override
  @JsonKey(name: 'role_label', fromJson: _stringOrNull)
  final String? roleLabel;

  @override
  String toString() {
    return 'InvitationPreviewMetaDto(isValid: $isValid, expiresInHours: $expiresInHours, organizationName: $organizationName, role: $role, roleLabel: $roleLabel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvitationPreviewMetaDtoImpl &&
            (identical(other.isValid, isValid) || other.isValid == isValid) &&
            (identical(other.expiresInHours, expiresInHours) ||
                other.expiresInHours == expiresInHours) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.roleLabel, roleLabel) ||
                other.roleLabel == roleLabel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, isValid, expiresInHours, organizationName, role, roleLabel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvitationPreviewMetaDtoImplCopyWith<_$InvitationPreviewMetaDtoImpl>
      get copyWith => __$$InvitationPreviewMetaDtoImplCopyWithImpl<
          _$InvitationPreviewMetaDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvitationPreviewMetaDtoImplToJson(
      this,
    );
  }
}

abstract class _InvitationPreviewMetaDto implements InvitationPreviewMetaDto {
  const factory _InvitationPreviewMetaDto(
      {@JsonKey(name: 'is_valid', fromJson: _bool) final bool isValid,
      @JsonKey(name: 'expires_in_hours', fromJson: _intOrNull)
      final int? expiresInHours,
      @JsonKey(name: 'organization_name', fromJson: _stringOrNull)
      final String? organizationName,
      @JsonKey(fromJson: _stringOrNull) final String? role,
      @JsonKey(name: 'role_label', fromJson: _stringOrNull)
      final String? roleLabel}) = _$InvitationPreviewMetaDtoImpl;

  factory _InvitationPreviewMetaDto.fromJson(Map<String, dynamic> json) =
      _$InvitationPreviewMetaDtoImpl.fromJson;

  @override
  @JsonKey(name: 'is_valid', fromJson: _bool)
  bool get isValid;
  @override
  @JsonKey(name: 'expires_in_hours', fromJson: _intOrNull)
  int? get expiresInHours;
  @override
  @JsonKey(name: 'organization_name', fromJson: _stringOrNull)
  String? get organizationName;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get role;
  @override
  @JsonKey(name: 'role_label', fromJson: _stringOrNull)
  String? get roleLabel;
  @override
  @JsonKey(ignore: true)
  _$$InvitationPreviewMetaDtoImplCopyWith<_$InvitationPreviewMetaDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

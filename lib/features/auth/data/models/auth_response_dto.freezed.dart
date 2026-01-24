// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthResponseDto _$AuthResponseDtoFromJson(Map<String, dynamic> json) {
  return _AuthResponseDto.fromJson(json);
}

/// @nodoc
mixin _$AuthResponseDto {
  UserDto get user => throw _privateConstructorUsedError;
  TokensDto get tokens => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthResponseDtoCopyWith<AuthResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResponseDtoCopyWith<$Res> {
  factory $AuthResponseDtoCopyWith(
          AuthResponseDto value, $Res Function(AuthResponseDto) then) =
      _$AuthResponseDtoCopyWithImpl<$Res, AuthResponseDto>;
  @useResult
  $Res call({UserDto user, TokensDto tokens});

  $UserDtoCopyWith<$Res> get user;
  $TokensDtoCopyWith<$Res> get tokens;
}

/// @nodoc
class _$AuthResponseDtoCopyWithImpl<$Res, $Val extends AuthResponseDto>
    implements $AuthResponseDtoCopyWith<$Res> {
  _$AuthResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? tokens = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserDto,
      tokens: null == tokens
          ? _value.tokens
          : tokens // ignore: cast_nullable_to_non_nullable
              as TokensDto,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserDtoCopyWith<$Res> get user {
    return $UserDtoCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TokensDtoCopyWith<$Res> get tokens {
    return $TokensDtoCopyWith<$Res>(_value.tokens, (value) {
      return _then(_value.copyWith(tokens: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthResponseDtoImplCopyWith<$Res>
    implements $AuthResponseDtoCopyWith<$Res> {
  factory _$$AuthResponseDtoImplCopyWith(_$AuthResponseDtoImpl value,
          $Res Function(_$AuthResponseDtoImpl) then) =
      __$$AuthResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserDto user, TokensDto tokens});

  @override
  $UserDtoCopyWith<$Res> get user;
  @override
  $TokensDtoCopyWith<$Res> get tokens;
}

/// @nodoc
class __$$AuthResponseDtoImplCopyWithImpl<$Res>
    extends _$AuthResponseDtoCopyWithImpl<$Res, _$AuthResponseDtoImpl>
    implements _$$AuthResponseDtoImplCopyWith<$Res> {
  __$$AuthResponseDtoImplCopyWithImpl(
      _$AuthResponseDtoImpl _value, $Res Function(_$AuthResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? tokens = null,
  }) {
    return _then(_$AuthResponseDtoImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserDto,
      tokens: null == tokens
          ? _value.tokens
          : tokens // ignore: cast_nullable_to_non_nullable
              as TokensDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResponseDtoImpl implements _AuthResponseDto {
  const _$AuthResponseDtoImpl({required this.user, required this.tokens});

  factory _$AuthResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResponseDtoImplFromJson(json);

  @override
  final UserDto user;
  @override
  final TokensDto tokens;

  @override
  String toString() {
    return 'AuthResponseDto(user: $user, tokens: $tokens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResponseDtoImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.tokens, tokens) || other.tokens == tokens));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, user, tokens);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResponseDtoImplCopyWith<_$AuthResponseDtoImpl> get copyWith =>
      __$$AuthResponseDtoImplCopyWithImpl<_$AuthResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _AuthResponseDto implements AuthResponseDto {
  const factory _AuthResponseDto(
      {required final UserDto user,
      required final TokensDto tokens}) = _$AuthResponseDtoImpl;

  factory _AuthResponseDto.fromJson(Map<String, dynamic> json) =
      _$AuthResponseDtoImpl.fromJson;

  @override
  UserDto get user;
  @override
  TokensDto get tokens;
  @override
  @JsonKey(ignore: true)
  _$$AuthResponseDtoImplCopyWith<_$AuthResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserDto _$UserDtoFromJson(Map<String, dynamic> json) {
  return _UserDto.fromJson(json);
}

/// @nodoc
mixin _$UserDto {
  int get id => throw _privateConstructorUsedError;
  String get email =>
      throw _privateConstructorUsedError; // Login/refresh returns "display_name", register returns "name"
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  String? get birthDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'registered_at')
  String? get registeredAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;
  UserCapabilitiesDto? get capabilities => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserDtoCopyWith<UserDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDtoCopyWith<$Res> {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) then) =
      _$UserDtoCopyWithImpl<$Res, UserDto>;
  @useResult
  $Res call(
      {int id,
      String email,
      @JsonKey(name: 'display_name') String? displayName,
      String? name,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      String? phone,
      String? city,
      String? bio,
      @JsonKey(name: 'birth_date') String? birthDate,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String role,
      @JsonKey(name: 'registered_at') String? registeredAt,
      @JsonKey(name: 'is_verified') bool isVerified,
      UserCapabilitiesDto? capabilities});

  $UserCapabilitiesDtoCopyWith<$Res>? get capabilities;
}

/// @nodoc
class _$UserDtoCopyWithImpl<$Res, $Val extends UserDto>
    implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? name = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? phone = freezed,
    Object? city = freezed,
    Object? bio = freezed,
    Object? birthDate = freezed,
    Object? avatarUrl = freezed,
    Object? role = null,
    Object? registeredAt = freezed,
    Object? isVerified = null,
    Object? capabilities = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      registeredAt: freezed == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      capabilities: freezed == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as UserCapabilitiesDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCapabilitiesDtoCopyWith<$Res>? get capabilities {
    if (_value.capabilities == null) {
      return null;
    }

    return $UserCapabilitiesDtoCopyWith<$Res>(_value.capabilities!, (value) {
      return _then(_value.copyWith(capabilities: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserDtoImplCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$$UserDtoImplCopyWith(
          _$UserDtoImpl value, $Res Function(_$UserDtoImpl) then) =
      __$$UserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String email,
      @JsonKey(name: 'display_name') String? displayName,
      String? name,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      String? phone,
      String? city,
      String? bio,
      @JsonKey(name: 'birth_date') String? birthDate,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      String role,
      @JsonKey(name: 'registered_at') String? registeredAt,
      @JsonKey(name: 'is_verified') bool isVerified,
      UserCapabilitiesDto? capabilities});

  @override
  $UserCapabilitiesDtoCopyWith<$Res>? get capabilities;
}

/// @nodoc
class __$$UserDtoImplCopyWithImpl<$Res>
    extends _$UserDtoCopyWithImpl<$Res, _$UserDtoImpl>
    implements _$$UserDtoImplCopyWith<$Res> {
  __$$UserDtoImplCopyWithImpl(
      _$UserDtoImpl _value, $Res Function(_$UserDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = freezed,
    Object? name = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? phone = freezed,
    Object? city = freezed,
    Object? bio = freezed,
    Object? birthDate = freezed,
    Object? avatarUrl = freezed,
    Object? role = null,
    Object? registeredAt = freezed,
    Object? isVerified = null,
    Object? capabilities = freezed,
  }) {
    return _then(_$UserDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      registeredAt: freezed == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      capabilities: freezed == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as UserCapabilitiesDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDtoImpl implements _UserDto {
  const _$UserDtoImpl(
      {required this.id,
      required this.email,
      @JsonKey(name: 'display_name') this.displayName,
      this.name,
      @JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      this.phone,
      this.city,
      this.bio,
      @JsonKey(name: 'birth_date') this.birthDate,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      required this.role,
      @JsonKey(name: 'registered_at') this.registeredAt,
      @JsonKey(name: 'is_verified') this.isVerified = false,
      this.capabilities});

  factory _$UserDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String email;
// Login/refresh returns "display_name", register returns "name"
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;
  @override
  final String? name;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  final String? phone;
  @override
  final String? city;
  @override
  final String? bio;
  @override
  @JsonKey(name: 'birth_date')
  final String? birthDate;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  final String role;
  @override
  @JsonKey(name: 'registered_at')
  final String? registeredAt;
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @override
  final UserCapabilitiesDto? capabilities;

  @override
  String toString() {
    return 'UserDto(id: $id, email: $email, displayName: $displayName, name: $name, firstName: $firstName, lastName: $lastName, phone: $phone, city: $city, bio: $bio, birthDate: $birthDate, avatarUrl: $avatarUrl, role: $role, registeredAt: $registeredAt, isVerified: $isVerified, capabilities: $capabilities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.registeredAt, registeredAt) ||
                other.registeredAt == registeredAt) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.capabilities, capabilities) ||
                other.capabilities == capabilities));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      displayName,
      name,
      firstName,
      lastName,
      phone,
      city,
      bio,
      birthDate,
      avatarUrl,
      role,
      registeredAt,
      isVerified,
      capabilities);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDtoImplCopyWith<_$UserDtoImpl> get copyWith =>
      __$$UserDtoImplCopyWithImpl<_$UserDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDtoImplToJson(
      this,
    );
  }
}

abstract class _UserDto implements UserDto {
  const factory _UserDto(
      {required final int id,
      required final String email,
      @JsonKey(name: 'display_name') final String? displayName,
      final String? name,
      @JsonKey(name: 'first_name') final String? firstName,
      @JsonKey(name: 'last_name') final String? lastName,
      final String? phone,
      final String? city,
      final String? bio,
      @JsonKey(name: 'birth_date') final String? birthDate,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      required final String role,
      @JsonKey(name: 'registered_at') final String? registeredAt,
      @JsonKey(name: 'is_verified') final bool isVerified,
      final UserCapabilitiesDto? capabilities}) = _$UserDtoImpl;

  factory _UserDto.fromJson(Map<String, dynamic> json) = _$UserDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get email;
  @override // Login/refresh returns "display_name", register returns "name"
  @JsonKey(name: 'display_name')
  String? get displayName;
  @override
  String? get name;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  String? get phone;
  @override
  String? get city;
  @override
  String? get bio;
  @override
  @JsonKey(name: 'birth_date')
  String? get birthDate;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  String get role;
  @override
  @JsonKey(name: 'registered_at')
  String? get registeredAt;
  @override
  @JsonKey(name: 'is_verified')
  bool get isVerified;
  @override
  UserCapabilitiesDto? get capabilities;
  @override
  @JsonKey(ignore: true)
  _$$UserDtoImplCopyWith<_$UserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserCapabilitiesDto _$UserCapabilitiesDtoFromJson(Map<String, dynamic> json) {
  return _UserCapabilitiesDto.fromJson(json);
}

/// @nodoc
mixin _$UserCapabilitiesDto {
  @JsonKey(name: 'can_book')
  bool get canBook => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_scan_tickets')
  bool get canScanTickets => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_manage_events')
  bool get canManageEvents => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCapabilitiesDtoCopyWith<UserCapabilitiesDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCapabilitiesDtoCopyWith<$Res> {
  factory $UserCapabilitiesDtoCopyWith(
          UserCapabilitiesDto value, $Res Function(UserCapabilitiesDto) then) =
      _$UserCapabilitiesDtoCopyWithImpl<$Res, UserCapabilitiesDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'can_book') bool canBook,
      @JsonKey(name: 'can_scan_tickets') bool canScanTickets,
      @JsonKey(name: 'can_manage_events') bool canManageEvents});
}

/// @nodoc
class _$UserCapabilitiesDtoCopyWithImpl<$Res, $Val extends UserCapabilitiesDto>
    implements $UserCapabilitiesDtoCopyWith<$Res> {
  _$UserCapabilitiesDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canBook = null,
    Object? canScanTickets = null,
    Object? canManageEvents = null,
  }) {
    return _then(_value.copyWith(
      canBook: null == canBook
          ? _value.canBook
          : canBook // ignore: cast_nullable_to_non_nullable
              as bool,
      canScanTickets: null == canScanTickets
          ? _value.canScanTickets
          : canScanTickets // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageEvents: null == canManageEvents
          ? _value.canManageEvents
          : canManageEvents // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserCapabilitiesDtoImplCopyWith<$Res>
    implements $UserCapabilitiesDtoCopyWith<$Res> {
  factory _$$UserCapabilitiesDtoImplCopyWith(_$UserCapabilitiesDtoImpl value,
          $Res Function(_$UserCapabilitiesDtoImpl) then) =
      __$$UserCapabilitiesDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'can_book') bool canBook,
      @JsonKey(name: 'can_scan_tickets') bool canScanTickets,
      @JsonKey(name: 'can_manage_events') bool canManageEvents});
}

/// @nodoc
class __$$UserCapabilitiesDtoImplCopyWithImpl<$Res>
    extends _$UserCapabilitiesDtoCopyWithImpl<$Res, _$UserCapabilitiesDtoImpl>
    implements _$$UserCapabilitiesDtoImplCopyWith<$Res> {
  __$$UserCapabilitiesDtoImplCopyWithImpl(_$UserCapabilitiesDtoImpl _value,
      $Res Function(_$UserCapabilitiesDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canBook = null,
    Object? canScanTickets = null,
    Object? canManageEvents = null,
  }) {
    return _then(_$UserCapabilitiesDtoImpl(
      canBook: null == canBook
          ? _value.canBook
          : canBook // ignore: cast_nullable_to_non_nullable
              as bool,
      canScanTickets: null == canScanTickets
          ? _value.canScanTickets
          : canScanTickets // ignore: cast_nullable_to_non_nullable
              as bool,
      canManageEvents: null == canManageEvents
          ? _value.canManageEvents
          : canManageEvents // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserCapabilitiesDtoImpl implements _UserCapabilitiesDto {
  const _$UserCapabilitiesDtoImpl(
      {@JsonKey(name: 'can_book') this.canBook = true,
      @JsonKey(name: 'can_scan_tickets') this.canScanTickets = false,
      @JsonKey(name: 'can_manage_events') this.canManageEvents = false});

  factory _$UserCapabilitiesDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserCapabilitiesDtoImplFromJson(json);

  @override
  @JsonKey(name: 'can_book')
  final bool canBook;
  @override
  @JsonKey(name: 'can_scan_tickets')
  final bool canScanTickets;
  @override
  @JsonKey(name: 'can_manage_events')
  final bool canManageEvents;

  @override
  String toString() {
    return 'UserCapabilitiesDto(canBook: $canBook, canScanTickets: $canScanTickets, canManageEvents: $canManageEvents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserCapabilitiesDtoImpl &&
            (identical(other.canBook, canBook) || other.canBook == canBook) &&
            (identical(other.canScanTickets, canScanTickets) ||
                other.canScanTickets == canScanTickets) &&
            (identical(other.canManageEvents, canManageEvents) ||
                other.canManageEvents == canManageEvents));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, canBook, canScanTickets, canManageEvents);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserCapabilitiesDtoImplCopyWith<_$UserCapabilitiesDtoImpl> get copyWith =>
      __$$UserCapabilitiesDtoImplCopyWithImpl<_$UserCapabilitiesDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserCapabilitiesDtoImplToJson(
      this,
    );
  }
}

abstract class _UserCapabilitiesDto implements UserCapabilitiesDto {
  const factory _UserCapabilitiesDto(
          {@JsonKey(name: 'can_book') final bool canBook,
          @JsonKey(name: 'can_scan_tickets') final bool canScanTickets,
          @JsonKey(name: 'can_manage_events') final bool canManageEvents}) =
      _$UserCapabilitiesDtoImpl;

  factory _UserCapabilitiesDto.fromJson(Map<String, dynamic> json) =
      _$UserCapabilitiesDtoImpl.fromJson;

  @override
  @JsonKey(name: 'can_book')
  bool get canBook;
  @override
  @JsonKey(name: 'can_scan_tickets')
  bool get canScanTickets;
  @override
  @JsonKey(name: 'can_manage_events')
  bool get canManageEvents;
  @override
  @JsonKey(ignore: true)
  _$$UserCapabilitiesDtoImplCopyWith<_$UserCapabilitiesDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TokensDto _$TokensDtoFromJson(Map<String, dynamic> json) {
  return _TokensDto.fromJson(json);
}

/// @nodoc
mixin _$TokensDto {
  @JsonKey(name: 'access_token')
  String get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'refresh_token')
  String get refreshToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'token_type')
  String get tokenType => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_in')
  int get expiresIn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TokensDtoCopyWith<TokensDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokensDtoCopyWith<$Res> {
  factory $TokensDtoCopyWith(TokensDto value, $Res Function(TokensDto) then) =
      _$TokensDtoCopyWithImpl<$Res, TokensDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String refreshToken,
      @JsonKey(name: 'token_type') String tokenType,
      @JsonKey(name: 'expires_in') int expiresIn});
}

/// @nodoc
class _$TokensDtoCopyWithImpl<$Res, $Val extends TokensDto>
    implements $TokensDtoCopyWith<$Res> {
  _$TokensDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
  }) {
    return _then(_value.copyWith(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TokensDtoImplCopyWith<$Res>
    implements $TokensDtoCopyWith<$Res> {
  factory _$$TokensDtoImplCopyWith(
          _$TokensDtoImpl value, $Res Function(_$TokensDtoImpl) then) =
      __$$TokensDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'access_token') String accessToken,
      @JsonKey(name: 'refresh_token') String refreshToken,
      @JsonKey(name: 'token_type') String tokenType,
      @JsonKey(name: 'expires_in') int expiresIn});
}

/// @nodoc
class __$$TokensDtoImplCopyWithImpl<$Res>
    extends _$TokensDtoCopyWithImpl<$Res, _$TokensDtoImpl>
    implements _$$TokensDtoImplCopyWith<$Res> {
  __$$TokensDtoImplCopyWithImpl(
      _$TokensDtoImpl _value, $Res Function(_$TokensDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = null,
    Object? refreshToken = null,
    Object? tokenType = null,
    Object? expiresIn = null,
  }) {
    return _then(_$TokensDtoImpl(
      accessToken: null == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String,
      refreshToken: null == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String,
      tokenType: null == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TokensDtoImpl implements _TokensDto {
  const _$TokensDtoImpl(
      {@JsonKey(name: 'access_token') required this.accessToken,
      @JsonKey(name: 'refresh_token') required this.refreshToken,
      @JsonKey(name: 'token_type') this.tokenType = 'Bearer',
      @JsonKey(name: 'expires_in') this.expiresIn = 604800});

  factory _$TokensDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TokensDtoImplFromJson(json);

  @override
  @JsonKey(name: 'access_token')
  final String accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @override
  @JsonKey(name: 'token_type')
  final String tokenType;
  @override
  @JsonKey(name: 'expires_in')
  final int expiresIn;

  @override
  String toString() {
    return 'TokensDto(accessToken: $accessToken, refreshToken: $refreshToken, tokenType: $tokenType, expiresIn: $expiresIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TokensDtoImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, accessToken, refreshToken, tokenType, expiresIn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TokensDtoImplCopyWith<_$TokensDtoImpl> get copyWith =>
      __$$TokensDtoImplCopyWithImpl<_$TokensDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TokensDtoImplToJson(
      this,
    );
  }
}

abstract class _TokensDto implements TokensDto {
  const factory _TokensDto(
      {@JsonKey(name: 'access_token') required final String accessToken,
      @JsonKey(name: 'refresh_token') required final String refreshToken,
      @JsonKey(name: 'token_type') final String tokenType,
      @JsonKey(name: 'expires_in') final int expiresIn}) = _$TokensDtoImpl;

  factory _TokensDto.fromJson(Map<String, dynamic> json) =
      _$TokensDtoImpl.fromJson;

  @override
  @JsonKey(name: 'access_token')
  String get accessToken;
  @override
  @JsonKey(name: 'refresh_token')
  String get refreshToken;
  @override
  @JsonKey(name: 'token_type')
  String get tokenType;
  @override
  @JsonKey(name: 'expires_in')
  int get expiresIn;
  @override
  @JsonKey(ignore: true)
  _$$TokensDtoImplCopyWith<_$TokensDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ApiResponseDto<T> {
  bool get success => throw _privateConstructorUsedError;
  T? get data => throw _privateConstructorUsedError;
  int? get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ApiResponseDtoCopyWith<T, ApiResponseDto<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiResponseDtoCopyWith<T, $Res> {
  factory $ApiResponseDtoCopyWith(
          ApiResponseDto<T> value, $Res Function(ApiResponseDto<T>) then) =
      _$ApiResponseDtoCopyWithImpl<T, $Res, ApiResponseDto<T>>;
  @useResult
  $Res call({bool success, T? data, int? status});
}

/// @nodoc
class _$ApiResponseDtoCopyWithImpl<T, $Res, $Val extends ApiResponseDto<T>>
    implements $ApiResponseDtoCopyWith<T, $Res> {
  _$ApiResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiResponseDtoImplCopyWith<T, $Res>
    implements $ApiResponseDtoCopyWith<T, $Res> {
  factory _$$ApiResponseDtoImplCopyWith(_$ApiResponseDtoImpl<T> value,
          $Res Function(_$ApiResponseDtoImpl<T>) then) =
      __$$ApiResponseDtoImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call({bool success, T? data, int? status});
}

/// @nodoc
class __$$ApiResponseDtoImplCopyWithImpl<T, $Res>
    extends _$ApiResponseDtoCopyWithImpl<T, $Res, _$ApiResponseDtoImpl<T>>
    implements _$$ApiResponseDtoImplCopyWith<T, $Res> {
  __$$ApiResponseDtoImplCopyWithImpl(_$ApiResponseDtoImpl<T> _value,
      $Res Function(_$ApiResponseDtoImpl<T>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = freezed,
    Object? status = freezed,
  }) {
    return _then(_$ApiResponseDtoImpl<T>(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$ApiResponseDtoImpl<T> implements _ApiResponseDto<T> {
  const _$ApiResponseDtoImpl({required this.success, this.data, this.status});

  @override
  final bool success;
  @override
  final T? data;
  @override
  final int? status;

  @override
  String toString() {
    return 'ApiResponseDto<$T>(success: $success, data: $data, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiResponseDtoImpl<T> &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, success, const DeepCollectionEquality().hash(data), status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiResponseDtoImplCopyWith<T, _$ApiResponseDtoImpl<T>> get copyWith =>
      __$$ApiResponseDtoImplCopyWithImpl<T, _$ApiResponseDtoImpl<T>>(
          this, _$identity);
}

abstract class _ApiResponseDto<T> implements ApiResponseDto<T> {
  const factory _ApiResponseDto(
      {required final bool success,
      final T? data,
      final int? status}) = _$ApiResponseDtoImpl<T>;

  @override
  bool get success;
  @override
  T? get data;
  @override
  int? get status;
  @override
  @JsonKey(ignore: true)
  _$$ApiResponseDtoImplCopyWith<T, _$ApiResponseDtoImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiErrorDto _$ApiErrorDtoFromJson(Map<String, dynamic> json) {
  return _ApiErrorDto.fromJson(json);
}

/// @nodoc
mixin _$ApiErrorDto {
  bool get success => throw _privateConstructorUsedError;
  ApiErrorDataDto get data => throw _privateConstructorUsedError;
  int? get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApiErrorDtoCopyWith<ApiErrorDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiErrorDtoCopyWith<$Res> {
  factory $ApiErrorDtoCopyWith(
          ApiErrorDto value, $Res Function(ApiErrorDto) then) =
      _$ApiErrorDtoCopyWithImpl<$Res, ApiErrorDto>;
  @useResult
  $Res call({bool success, ApiErrorDataDto data, int? status});

  $ApiErrorDataDtoCopyWith<$Res> get data;
}

/// @nodoc
class _$ApiErrorDtoCopyWithImpl<$Res, $Val extends ApiErrorDto>
    implements $ApiErrorDtoCopyWith<$Res> {
  _$ApiErrorDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ApiErrorDataDto,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiErrorDataDtoCopyWith<$Res> get data {
    return $ApiErrorDataDtoCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApiErrorDtoImplCopyWith<$Res>
    implements $ApiErrorDtoCopyWith<$Res> {
  factory _$$ApiErrorDtoImplCopyWith(
          _$ApiErrorDtoImpl value, $Res Function(_$ApiErrorDtoImpl) then) =
      __$$ApiErrorDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, ApiErrorDataDto data, int? status});

  @override
  $ApiErrorDataDtoCopyWith<$Res> get data;
}

/// @nodoc
class __$$ApiErrorDtoImplCopyWithImpl<$Res>
    extends _$ApiErrorDtoCopyWithImpl<$Res, _$ApiErrorDtoImpl>
    implements _$$ApiErrorDtoImplCopyWith<$Res> {
  __$$ApiErrorDtoImplCopyWithImpl(
      _$ApiErrorDtoImpl _value, $Res Function(_$ApiErrorDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? status = freezed,
  }) {
    return _then(_$ApiErrorDtoImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ApiErrorDataDto,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiErrorDtoImpl implements _ApiErrorDto {
  const _$ApiErrorDtoImpl(
      {required this.success, required this.data, this.status});

  factory _$ApiErrorDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiErrorDtoImplFromJson(json);

  @override
  final bool success;
  @override
  final ApiErrorDataDto data;
  @override
  final int? status;

  @override
  String toString() {
    return 'ApiErrorDto(success: $success, data: $data, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiErrorDtoImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, data, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiErrorDtoImplCopyWith<_$ApiErrorDtoImpl> get copyWith =>
      __$$ApiErrorDtoImplCopyWithImpl<_$ApiErrorDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiErrorDtoImplToJson(
      this,
    );
  }
}

abstract class _ApiErrorDto implements ApiErrorDto {
  const factory _ApiErrorDto(
      {required final bool success,
      required final ApiErrorDataDto data,
      final int? status}) = _$ApiErrorDtoImpl;

  factory _ApiErrorDto.fromJson(Map<String, dynamic> json) =
      _$ApiErrorDtoImpl.fromJson;

  @override
  bool get success;
  @override
  ApiErrorDataDto get data;
  @override
  int? get status;
  @override
  @JsonKey(ignore: true)
  _$$ApiErrorDtoImplCopyWith<_$ApiErrorDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiErrorDataDto _$ApiErrorDataDtoFromJson(Map<String, dynamic> json) {
  return _ApiErrorDataDto.fromJson(json);
}

/// @nodoc
mixin _$ApiErrorDataDto {
  String get error => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  Map<String, dynamic>? get details => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApiErrorDataDtoCopyWith<ApiErrorDataDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiErrorDataDtoCopyWith<$Res> {
  factory $ApiErrorDataDtoCopyWith(
          ApiErrorDataDto value, $Res Function(ApiErrorDataDto) then) =
      _$ApiErrorDataDtoCopyWithImpl<$Res, ApiErrorDataDto>;
  @useResult
  $Res call({String error, String message, Map<String, dynamic>? details});
}

/// @nodoc
class _$ApiErrorDataDtoCopyWithImpl<$Res, $Val extends ApiErrorDataDto>
    implements $ApiErrorDataDtoCopyWith<$Res> {
  _$ApiErrorDataDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
    Object? details = freezed,
  }) {
    return _then(_value.copyWith(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiErrorDataDtoImplCopyWith<$Res>
    implements $ApiErrorDataDtoCopyWith<$Res> {
  factory _$$ApiErrorDataDtoImplCopyWith(_$ApiErrorDataDtoImpl value,
          $Res Function(_$ApiErrorDataDtoImpl) then) =
      __$$ApiErrorDataDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String error, String message, Map<String, dynamic>? details});
}

/// @nodoc
class __$$ApiErrorDataDtoImplCopyWithImpl<$Res>
    extends _$ApiErrorDataDtoCopyWithImpl<$Res, _$ApiErrorDataDtoImpl>
    implements _$$ApiErrorDataDtoImplCopyWith<$Res> {
  __$$ApiErrorDataDtoImplCopyWithImpl(
      _$ApiErrorDataDtoImpl _value, $Res Function(_$ApiErrorDataDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
    Object? details = freezed,
  }) {
    return _then(_$ApiErrorDataDtoImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiErrorDataDtoImpl implements _ApiErrorDataDto {
  const _$ApiErrorDataDtoImpl(
      {required this.error,
      required this.message,
      final Map<String, dynamic>? details})
      : _details = details;

  factory _$ApiErrorDataDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiErrorDataDtoImplFromJson(json);

  @override
  final String error;
  @override
  final String message;
  final Map<String, dynamic>? _details;
  @override
  Map<String, dynamic>? get details {
    final value = _details;
    if (value == null) return null;
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ApiErrorDataDto(error: $error, message: $message, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiErrorDataDtoImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, error, message,
      const DeepCollectionEquality().hash(_details));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiErrorDataDtoImplCopyWith<_$ApiErrorDataDtoImpl> get copyWith =>
      __$$ApiErrorDataDtoImplCopyWithImpl<_$ApiErrorDataDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiErrorDataDtoImplToJson(
      this,
    );
  }
}

abstract class _ApiErrorDataDto implements ApiErrorDataDto {
  const factory _ApiErrorDataDto(
      {required final String error,
      required final String message,
      final Map<String, dynamic>? details}) = _$ApiErrorDataDtoImpl;

  factory _ApiErrorDataDto.fromJson(Map<String, dynamic> json) =
      _$ApiErrorDataDtoImpl.fromJson;

  @override
  String get error;
  @override
  String get message;
  @override
  Map<String, dynamic>? get details;
  @override
  @JsonKey(ignore: true)
  _$$ApiErrorDataDtoImplCopyWith<_$ApiErrorDataDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

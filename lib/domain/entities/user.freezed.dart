// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HbUser {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  String? get firstName => throw _privateConstructorUsedError;
  String? get lastName => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get bio => throw _privateConstructorUsedError;
  DateTime? get birthDate => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  DateTime? get registeredAt => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;
  UserCapabilities get capabilities =>
      throw _privateConstructorUsedError; // Legacy fields for backwards compatibility
  List<String>? get interestsCategoryIds => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HbUserCopyWith<HbUser> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HbUserCopyWith<$Res> {
  factory $HbUserCopyWith(HbUser value, $Res Function(HbUser) then) =
      _$HbUserCopyWithImpl<$Res, HbUser>;
  @useResult
  $Res call(
      {String id,
      String email,
      String displayName,
      String? firstName,
      String? lastName,
      String? phone,
      String? avatarUrl,
      String? city,
      String? bio,
      DateTime? birthDate,
      UserRole role,
      DateTime? registeredAt,
      bool isVerified,
      UserCapabilities capabilities,
      List<String>? interestsCategoryIds});

  $UserCapabilitiesCopyWith<$Res> get capabilities;
}

/// @nodoc
class _$HbUserCopyWithImpl<$Res, $Val extends HbUser>
    implements $HbUserCopyWith<$Res> {
  _$HbUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? city = freezed,
    Object? bio = freezed,
    Object? birthDate = freezed,
    Object? role = null,
    Object? registeredAt = freezed,
    Object? isVerified = null,
    Object? capabilities = null,
    Object? interestsCategoryIds = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
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
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
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
              as DateTime?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      registeredAt: freezed == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      capabilities: null == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as UserCapabilities,
      interestsCategoryIds: freezed == interestsCategoryIds
          ? _value.interestsCategoryIds
          : interestsCategoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCapabilitiesCopyWith<$Res> get capabilities {
    return $UserCapabilitiesCopyWith<$Res>(_value.capabilities, (value) {
      return _then(_value.copyWith(capabilities: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HbUserImplCopyWith<$Res> implements $HbUserCopyWith<$Res> {
  factory _$$HbUserImplCopyWith(
          _$HbUserImpl value, $Res Function(_$HbUserImpl) then) =
      __$$HbUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String displayName,
      String? firstName,
      String? lastName,
      String? phone,
      String? avatarUrl,
      String? city,
      String? bio,
      DateTime? birthDate,
      UserRole role,
      DateTime? registeredAt,
      bool isVerified,
      UserCapabilities capabilities,
      List<String>? interestsCategoryIds});

  @override
  $UserCapabilitiesCopyWith<$Res> get capabilities;
}

/// @nodoc
class __$$HbUserImplCopyWithImpl<$Res>
    extends _$HbUserCopyWithImpl<$Res, _$HbUserImpl>
    implements _$$HbUserImplCopyWith<$Res> {
  __$$HbUserImplCopyWithImpl(
      _$HbUserImpl _value, $Res Function(_$HbUserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? phone = freezed,
    Object? avatarUrl = freezed,
    Object? city = freezed,
    Object? bio = freezed,
    Object? birthDate = freezed,
    Object? role = null,
    Object? registeredAt = freezed,
    Object? isVerified = null,
    Object? capabilities = null,
    Object? interestsCategoryIds = freezed,
  }) {
    return _then(_$HbUserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
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
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
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
              as DateTime?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      registeredAt: freezed == registeredAt
          ? _value.registeredAt
          : registeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      capabilities: null == capabilities
          ? _value.capabilities
          : capabilities // ignore: cast_nullable_to_non_nullable
              as UserCapabilities,
      interestsCategoryIds: freezed == interestsCategoryIds
          ? _value._interestsCategoryIds
          : interestsCategoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

class _$HbUserImpl implements _HbUser {
  const _$HbUserImpl(
      {required this.id,
      required this.email,
      required this.displayName,
      this.firstName,
      this.lastName,
      this.phone,
      this.avatarUrl,
      this.city,
      this.bio,
      this.birthDate,
      this.role = UserRole.subscriber,
      this.registeredAt,
      this.isVerified = false,
      this.capabilities = const UserCapabilities(),
      final List<String>? interestsCategoryIds})
      : _interestsCategoryIds = interestsCategoryIds;

  @override
  final String id;
  @override
  final String email;
  @override
  final String displayName;
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? phone;
  @override
  final String? avatarUrl;
  @override
  final String? city;
  @override
  final String? bio;
  @override
  final DateTime? birthDate;
  @override
  @JsonKey()
  final UserRole role;
  @override
  final DateTime? registeredAt;
  @override
  @JsonKey()
  final bool isVerified;
  @override
  @JsonKey()
  final UserCapabilities capabilities;
// Legacy fields for backwards compatibility
  final List<String>? _interestsCategoryIds;
// Legacy fields for backwards compatibility
  @override
  List<String>? get interestsCategoryIds {
    final value = _interestsCategoryIds;
    if (value == null) return null;
    if (_interestsCategoryIds is EqualUnmodifiableListView)
      return _interestsCategoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'HbUser(id: $id, email: $email, displayName: $displayName, firstName: $firstName, lastName: $lastName, phone: $phone, avatarUrl: $avatarUrl, city: $city, bio: $bio, birthDate: $birthDate, role: $role, registeredAt: $registeredAt, isVerified: $isVerified, capabilities: $capabilities, interestsCategoryIds: $interestsCategoryIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HbUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.registeredAt, registeredAt) ||
                other.registeredAt == registeredAt) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.capabilities, capabilities) ||
                other.capabilities == capabilities) &&
            const DeepCollectionEquality()
                .equals(other._interestsCategoryIds, _interestsCategoryIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      displayName,
      firstName,
      lastName,
      phone,
      avatarUrl,
      city,
      bio,
      birthDate,
      role,
      registeredAt,
      isVerified,
      capabilities,
      const DeepCollectionEquality().hash(_interestsCategoryIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HbUserImplCopyWith<_$HbUserImpl> get copyWith =>
      __$$HbUserImplCopyWithImpl<_$HbUserImpl>(this, _$identity);
}

abstract class _HbUser implements HbUser {
  const factory _HbUser(
      {required final String id,
      required final String email,
      required final String displayName,
      final String? firstName,
      final String? lastName,
      final String? phone,
      final String? avatarUrl,
      final String? city,
      final String? bio,
      final DateTime? birthDate,
      final UserRole role,
      final DateTime? registeredAt,
      final bool isVerified,
      final UserCapabilities capabilities,
      final List<String>? interestsCategoryIds}) = _$HbUserImpl;

  @override
  String get id;
  @override
  String get email;
  @override
  String get displayName;
  @override
  String? get firstName;
  @override
  String? get lastName;
  @override
  String? get phone;
  @override
  String? get avatarUrl;
  @override
  String? get city;
  @override
  String? get bio;
  @override
  DateTime? get birthDate;
  @override
  UserRole get role;
  @override
  DateTime? get registeredAt;
  @override
  bool get isVerified;
  @override
  UserCapabilities get capabilities;
  @override // Legacy fields for backwards compatibility
  List<String>? get interestsCategoryIds;
  @override
  @JsonKey(ignore: true)
  _$$HbUserImplCopyWith<_$HbUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserCapabilities {
  bool get canBook => throw _privateConstructorUsedError;
  bool get canScanTickets => throw _privateConstructorUsedError;
  bool get canManageEvents => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserCapabilitiesCopyWith<UserCapabilities> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCapabilitiesCopyWith<$Res> {
  factory $UserCapabilitiesCopyWith(
          UserCapabilities value, $Res Function(UserCapabilities) then) =
      _$UserCapabilitiesCopyWithImpl<$Res, UserCapabilities>;
  @useResult
  $Res call({bool canBook, bool canScanTickets, bool canManageEvents});
}

/// @nodoc
class _$UserCapabilitiesCopyWithImpl<$Res, $Val extends UserCapabilities>
    implements $UserCapabilitiesCopyWith<$Res> {
  _$UserCapabilitiesCopyWithImpl(this._value, this._then);

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
abstract class _$$UserCapabilitiesImplCopyWith<$Res>
    implements $UserCapabilitiesCopyWith<$Res> {
  factory _$$UserCapabilitiesImplCopyWith(_$UserCapabilitiesImpl value,
          $Res Function(_$UserCapabilitiesImpl) then) =
      __$$UserCapabilitiesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool canBook, bool canScanTickets, bool canManageEvents});
}

/// @nodoc
class __$$UserCapabilitiesImplCopyWithImpl<$Res>
    extends _$UserCapabilitiesCopyWithImpl<$Res, _$UserCapabilitiesImpl>
    implements _$$UserCapabilitiesImplCopyWith<$Res> {
  __$$UserCapabilitiesImplCopyWithImpl(_$UserCapabilitiesImpl _value,
      $Res Function(_$UserCapabilitiesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canBook = null,
    Object? canScanTickets = null,
    Object? canManageEvents = null,
  }) {
    return _then(_$UserCapabilitiesImpl(
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

class _$UserCapabilitiesImpl implements _UserCapabilities {
  const _$UserCapabilitiesImpl(
      {this.canBook = true,
      this.canScanTickets = false,
      this.canManageEvents = false});

  @override
  @JsonKey()
  final bool canBook;
  @override
  @JsonKey()
  final bool canScanTickets;
  @override
  @JsonKey()
  final bool canManageEvents;

  @override
  String toString() {
    return 'UserCapabilities(canBook: $canBook, canScanTickets: $canScanTickets, canManageEvents: $canManageEvents)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserCapabilitiesImpl &&
            (identical(other.canBook, canBook) || other.canBook == canBook) &&
            (identical(other.canScanTickets, canScanTickets) ||
                other.canScanTickets == canScanTickets) &&
            (identical(other.canManageEvents, canManageEvents) ||
                other.canManageEvents == canManageEvents));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, canBook, canScanTickets, canManageEvents);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserCapabilitiesImplCopyWith<_$UserCapabilitiesImpl> get copyWith =>
      __$$UserCapabilitiesImplCopyWithImpl<_$UserCapabilitiesImpl>(
          this, _$identity);
}

abstract class _UserCapabilities implements UserCapabilities {
  const factory _UserCapabilities(
      {final bool canBook,
      final bool canScanTickets,
      final bool canManageEvents}) = _$UserCapabilitiesImpl;

  @override
  bool get canBook;
  @override
  bool get canScanTickets;
  @override
  bool get canManageEvents;
  @override
  @JsonKey(ignore: true)
  _$$UserCapabilitiesImplCopyWith<_$UserCapabilitiesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

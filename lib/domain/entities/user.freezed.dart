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
  String? get name => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get cityId => throw _privateConstructorUsedError;
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
      String? name,
      String? avatarUrl,
      String? cityId,
      List<String>? interestsCategoryIds});
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
    Object? name = freezed,
    Object? avatarUrl = freezed,
    Object? cityId = freezed,
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
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
      interestsCategoryIds: freezed == interestsCategoryIds
          ? _value.interestsCategoryIds
          : interestsCategoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
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
      String? name,
      String? avatarUrl,
      String? cityId,
      List<String>? interestsCategoryIds});
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
    Object? name = freezed,
    Object? avatarUrl = freezed,
    Object? cityId = freezed,
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
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      this.name,
      this.avatarUrl,
      this.cityId,
      final List<String>? interestsCategoryIds})
      : _interestsCategoryIds = interestsCategoryIds;

  @override
  final String id;
  @override
  final String email;
  @override
  final String? name;
  @override
  final String? avatarUrl;
  @override
  final String? cityId;
  final List<String>? _interestsCategoryIds;
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
    return 'HbUser(id: $id, email: $email, name: $name, avatarUrl: $avatarUrl, cityId: $cityId, interestsCategoryIds: $interestsCategoryIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HbUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            const DeepCollectionEquality()
                .equals(other._interestsCategoryIds, _interestsCategoryIds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, email, name, avatarUrl,
      cityId, const DeepCollectionEquality().hash(_interestsCategoryIds));

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
      final String? name,
      final String? avatarUrl,
      final String? cityId,
      final List<String>? interestsCategoryIds}) = _$HbUserImpl;

  @override
  String get id;
  @override
  String get email;
  @override
  String? get name;
  @override
  String? get avatarUrl;
  @override
  String? get cityId;
  @override
  List<String>? get interestsCategoryIds;
  @override
  @JsonKey(ignore: true)
  _$$HbUserImplCopyWith<_$HbUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

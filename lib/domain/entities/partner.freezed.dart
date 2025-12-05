// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'partner.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Partner {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get cityId => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  bool? get verified => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PartnerCopyWith<Partner> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartnerCopyWith<$Res> {
  factory $PartnerCopyWith(Partner value, $Res Function(Partner) then) =
      _$PartnerCopyWithImpl<$Res, Partner>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? logoUrl,
      String? cityId,
      String? website,
      String? email,
      String? phone,
      bool? verified});
}

/// @nodoc
class _$PartnerCopyWithImpl<$Res, $Val extends Partner>
    implements $PartnerCopyWith<$Res> {
  _$PartnerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? cityId = freezed,
    Object? website = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? verified = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
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
      verified: freezed == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartnerImplCopyWith<$Res> implements $PartnerCopyWith<$Res> {
  factory _$$PartnerImplCopyWith(
          _$PartnerImpl value, $Res Function(_$PartnerImpl) then) =
      __$$PartnerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? description,
      String? logoUrl,
      String? cityId,
      String? website,
      String? email,
      String? phone,
      bool? verified});
}

/// @nodoc
class __$$PartnerImplCopyWithImpl<$Res>
    extends _$PartnerCopyWithImpl<$Res, _$PartnerImpl>
    implements _$$PartnerImplCopyWith<$Res> {
  __$$PartnerImplCopyWithImpl(
      _$PartnerImpl _value, $Res Function(_$PartnerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? logoUrl = freezed,
    Object? cityId = freezed,
    Object? website = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? verified = freezed,
  }) {
    return _then(_$PartnerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
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
      verified: freezed == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$PartnerImpl implements _Partner {
  const _$PartnerImpl(
      {required this.id,
      required this.name,
      this.description,
      this.logoUrl,
      this.cityId,
      this.website,
      this.email,
      this.phone,
      this.verified});

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? logoUrl;
  @override
  final String? cityId;
  @override
  final String? website;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final bool? verified;

  @override
  String toString() {
    return 'Partner(id: $id, name: $name, description: $description, logoUrl: $logoUrl, cityId: $cityId, website: $website, email: $email, phone: $phone, verified: $verified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartnerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.verified, verified) ||
                other.verified == verified));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, logoUrl,
      cityId, website, email, phone, verified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PartnerImplCopyWith<_$PartnerImpl> get copyWith =>
      __$$PartnerImplCopyWithImpl<_$PartnerImpl>(this, _$identity);
}

abstract class _Partner implements Partner {
  const factory _Partner(
      {required final String id,
      required final String name,
      final String? description,
      final String? logoUrl,
      final String? cityId,
      final String? website,
      final String? email,
      final String? phone,
      final bool? verified}) = _$PartnerImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  String? get logoUrl;
  @override
  String? get cityId;
  @override
  String? get website;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  bool? get verified;
  @override
  @JsonKey(ignore: true)
  _$$PartnerImplCopyWith<_$PartnerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'taxonomy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Category {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res, Category>;
  @useResult
  $Res call({String id, String slug, String name});
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res, $Val extends Category>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryImplCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$$CategoryImplCopyWith(
          _$CategoryImpl value, $Res Function(_$CategoryImpl) then) =
      __$$CategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String slug, String name});
}

/// @nodoc
class __$$CategoryImplCopyWithImpl<$Res>
    extends _$CategoryCopyWithImpl<$Res, _$CategoryImpl>
    implements _$$CategoryImplCopyWith<$Res> {
  __$$CategoryImplCopyWithImpl(
      _$CategoryImpl _value, $Res Function(_$CategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_$CategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CategoryImpl implements _Category {
  const _$CategoryImpl(
      {required this.id, required this.slug, required this.name});

  @override
  final String id;
  @override
  final String slug;
  @override
  final String name;

  @override
  String toString() {
    return 'Category(id: $id, slug: $slug, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, slug, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      __$$CategoryImplCopyWithImpl<_$CategoryImpl>(this, _$identity);
}

abstract class _Category implements Category {
  const factory _Category(
      {required final String id,
      required final String slug,
      required final String name}) = _$CategoryImpl;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Tag {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TagCopyWith<Tag> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagCopyWith<$Res> {
  factory $TagCopyWith(Tag value, $Res Function(Tag) then) =
      _$TagCopyWithImpl<$Res, Tag>;
  @useResult
  $Res call({String id, String slug, String name});
}

/// @nodoc
class _$TagCopyWithImpl<$Res, $Val extends Tag> implements $TagCopyWith<$Res> {
  _$TagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TagImplCopyWith<$Res> implements $TagCopyWith<$Res> {
  factory _$$TagImplCopyWith(_$TagImpl value, $Res Function(_$TagImpl) then) =
      __$$TagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String slug, String name});
}

/// @nodoc
class __$$TagImplCopyWithImpl<$Res> extends _$TagCopyWithImpl<$Res, _$TagImpl>
    implements _$$TagImplCopyWith<$Res> {
  __$$TagImplCopyWithImpl(_$TagImpl _value, $Res Function(_$TagImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_$TagImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TagImpl implements _Tag {
  const _$TagImpl({required this.id, required this.slug, required this.name});

  @override
  final String id;
  @override
  final String slug;
  @override
  final String name;

  @override
  String toString() {
    return 'Tag(id: $id, slug: $slug, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TagImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, slug, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TagImplCopyWith<_$TagImpl> get copyWith =>
      __$$TagImplCopyWithImpl<_$TagImpl>(this, _$identity);
}

abstract class _Tag implements Tag {
  const factory _Tag(
      {required final String id,
      required final String slug,
      required final String name}) = _$TagImpl;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$TagImplCopyWith<_$TagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AgeRange {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  int? get minAge => throw _privateConstructorUsedError;
  int? get maxAge => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AgeRangeCopyWith<AgeRange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgeRangeCopyWith<$Res> {
  factory $AgeRangeCopyWith(AgeRange value, $Res Function(AgeRange) then) =
      _$AgeRangeCopyWithImpl<$Res, AgeRange>;
  @useResult
  $Res call({String id, String label, int? minAge, int? maxAge});
}

/// @nodoc
class _$AgeRangeCopyWithImpl<$Res, $Val extends AgeRange>
    implements $AgeRangeCopyWith<$Res> {
  _$AgeRangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? minAge = freezed,
    Object? maxAge = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      minAge: freezed == minAge
          ? _value.minAge
          : minAge // ignore: cast_nullable_to_non_nullable
              as int?,
      maxAge: freezed == maxAge
          ? _value.maxAge
          : maxAge // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AgeRangeImplCopyWith<$Res>
    implements $AgeRangeCopyWith<$Res> {
  factory _$$AgeRangeImplCopyWith(
          _$AgeRangeImpl value, $Res Function(_$AgeRangeImpl) then) =
      __$$AgeRangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String label, int? minAge, int? maxAge});
}

/// @nodoc
class __$$AgeRangeImplCopyWithImpl<$Res>
    extends _$AgeRangeCopyWithImpl<$Res, _$AgeRangeImpl>
    implements _$$AgeRangeImplCopyWith<$Res> {
  __$$AgeRangeImplCopyWithImpl(
      _$AgeRangeImpl _value, $Res Function(_$AgeRangeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? minAge = freezed,
    Object? maxAge = freezed,
  }) {
    return _then(_$AgeRangeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      minAge: freezed == minAge
          ? _value.minAge
          : minAge // ignore: cast_nullable_to_non_nullable
              as int?,
      maxAge: freezed == maxAge
          ? _value.maxAge
          : maxAge // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$AgeRangeImpl implements _AgeRange {
  const _$AgeRangeImpl(
      {required this.id, required this.label, this.minAge, this.maxAge});

  @override
  final String id;
  @override
  final String label;
  @override
  final int? minAge;
  @override
  final int? maxAge;

  @override
  String toString() {
    return 'AgeRange(id: $id, label: $label, minAge: $minAge, maxAge: $maxAge)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AgeRangeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.minAge, minAge) || other.minAge == minAge) &&
            (identical(other.maxAge, maxAge) || other.maxAge == maxAge));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, label, minAge, maxAge);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AgeRangeImplCopyWith<_$AgeRangeImpl> get copyWith =>
      __$$AgeRangeImplCopyWithImpl<_$AgeRangeImpl>(this, _$identity);
}

abstract class _AgeRange implements AgeRange {
  const factory _AgeRange(
      {required final String id,
      required final String label,
      final int? minAge,
      final int? maxAge}) = _$AgeRangeImpl;

  @override
  String get id;
  @override
  String get label;
  @override
  int? get minAge;
  @override
  int? get maxAge;
  @override
  @JsonKey(ignore: true)
  _$$AgeRangeImplCopyWith<_$AgeRangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Audience {
  String get id => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AudienceCopyWith<Audience> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudienceCopyWith<$Res> {
  factory $AudienceCopyWith(Audience value, $Res Function(Audience) then) =
      _$AudienceCopyWithImpl<$Res, Audience>;
  @useResult
  $Res call({String id, String slug, String name});
}

/// @nodoc
class _$AudienceCopyWithImpl<$Res, $Val extends Audience>
    implements $AudienceCopyWith<$Res> {
  _$AudienceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AudienceImplCopyWith<$Res>
    implements $AudienceCopyWith<$Res> {
  factory _$$AudienceImplCopyWith(
          _$AudienceImpl value, $Res Function(_$AudienceImpl) then) =
      __$$AudienceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String slug, String name});
}

/// @nodoc
class __$$AudienceImplCopyWithImpl<$Res>
    extends _$AudienceCopyWithImpl<$Res, _$AudienceImpl>
    implements _$$AudienceImplCopyWith<$Res> {
  __$$AudienceImplCopyWithImpl(
      _$AudienceImpl _value, $Res Function(_$AudienceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? slug = null,
    Object? name = null,
  }) {
    return _then(_$AudienceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AudienceImpl implements _Audience {
  const _$AudienceImpl(
      {required this.id, required this.slug, required this.name});

  @override
  final String id;
  @override
  final String slug;
  @override
  final String name;

  @override
  String toString() {
    return 'Audience(id: $id, slug: $slug, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudienceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, slug, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AudienceImplCopyWith<_$AudienceImpl> get copyWith =>
      __$$AudienceImplCopyWithImpl<_$AudienceImpl>(this, _$identity);
}

abstract class _Audience implements Audience {
  const factory _Audience(
      {required final String id,
      required final String slug,
      required final String name}) = _$AudienceImpl;

  @override
  String get id;
  @override
  String get slug;
  @override
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$AudienceImplCopyWith<_$AudienceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

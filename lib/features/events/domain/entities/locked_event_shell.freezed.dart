// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'locked_event_shell.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LockedEventShell {
  String get uuid => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get excerpt => throw _privateConstructorUsedError;
  String? get coverImage => throw _privateConstructorUsedError;
  String? get visibility => throw _privateConstructorUsedError;
  bool get isPasswordProtected => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LockedEventShellCopyWith<LockedEventShell> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LockedEventShellCopyWith<$Res> {
  factory $LockedEventShellCopyWith(
          LockedEventShell value, $Res Function(LockedEventShell) then) =
      _$LockedEventShellCopyWithImpl<$Res, LockedEventShell>;
  @useResult
  $Res call(
      {String uuid,
      String? slug,
      String title,
      String? excerpt,
      String? coverImage,
      String? visibility,
      bool isPasswordProtected});
}

/// @nodoc
class _$LockedEventShellCopyWithImpl<$Res, $Val extends LockedEventShell>
    implements $LockedEventShellCopyWith<$Res> {
  _$LockedEventShellCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? slug = freezed,
    Object? title = null,
    Object? excerpt = freezed,
    Object? coverImage = freezed,
    Object? visibility = freezed,
    Object? isPasswordProtected = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      excerpt: freezed == excerpt
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: freezed == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String?,
      isPasswordProtected: null == isPasswordProtected
          ? _value.isPasswordProtected
          : isPasswordProtected // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LockedEventShellImplCopyWith<$Res>
    implements $LockedEventShellCopyWith<$Res> {
  factory _$$LockedEventShellImplCopyWith(_$LockedEventShellImpl value,
          $Res Function(_$LockedEventShellImpl) then) =
      __$$LockedEventShellImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String? slug,
      String title,
      String? excerpt,
      String? coverImage,
      String? visibility,
      bool isPasswordProtected});
}

/// @nodoc
class __$$LockedEventShellImplCopyWithImpl<$Res>
    extends _$LockedEventShellCopyWithImpl<$Res, _$LockedEventShellImpl>
    implements _$$LockedEventShellImplCopyWith<$Res> {
  __$$LockedEventShellImplCopyWithImpl(_$LockedEventShellImpl _value,
      $Res Function(_$LockedEventShellImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? slug = freezed,
    Object? title = null,
    Object? excerpt = freezed,
    Object? coverImage = freezed,
    Object? visibility = freezed,
    Object? isPasswordProtected = null,
  }) {
    return _then(_$LockedEventShellImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      excerpt: freezed == excerpt
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: freezed == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String?,
      isPasswordProtected: null == isPasswordProtected
          ? _value.isPasswordProtected
          : isPasswordProtected // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LockedEventShellImpl implements _LockedEventShell {
  const _$LockedEventShellImpl(
      {required this.uuid,
      this.slug,
      required this.title,
      this.excerpt,
      this.coverImage,
      this.visibility,
      this.isPasswordProtected = true});

  @override
  final String uuid;
  @override
  final String? slug;
  @override
  final String title;
  @override
  final String? excerpt;
  @override
  final String? coverImage;
  @override
  final String? visibility;
  @override
  @JsonKey()
  final bool isPasswordProtected;

  @override
  String toString() {
    return 'LockedEventShell(uuid: $uuid, slug: $slug, title: $title, excerpt: $excerpt, coverImage: $coverImage, visibility: $visibility, isPasswordProtected: $isPasswordProtected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LockedEventShellImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.excerpt, excerpt) || other.excerpt == excerpt) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.isPasswordProtected, isPasswordProtected) ||
                other.isPasswordProtected == isPasswordProtected));
  }

  @override
  int get hashCode => Object.hash(runtimeType, uuid, slug, title, excerpt,
      coverImage, visibility, isPasswordProtected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LockedEventShellImplCopyWith<_$LockedEventShellImpl> get copyWith =>
      __$$LockedEventShellImplCopyWithImpl<_$LockedEventShellImpl>(
          this, _$identity);
}

abstract class _LockedEventShell implements LockedEventShell {
  const factory _LockedEventShell(
      {required final String uuid,
      final String? slug,
      required final String title,
      final String? excerpt,
      final String? coverImage,
      final String? visibility,
      final bool isPasswordProtected}) = _$LockedEventShellImpl;

  @override
  String get uuid;
  @override
  String? get slug;
  @override
  String get title;
  @override
  String? get excerpt;
  @override
  String? get coverImage;
  @override
  String? get visibility;
  @override
  bool get isPasswordProtected;
  @override
  @JsonKey(ignore: true)
  _$$LockedEventShellImplCopyWith<_$LockedEventShellImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

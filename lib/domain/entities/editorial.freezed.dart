// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editorial.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EditorialPost {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get excerpt => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  DateTime? get publishedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EditorialPostCopyWith<EditorialPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditorialPostCopyWith<$Res> {
  factory $EditorialPostCopyWith(
          EditorialPost value, $Res Function(EditorialPost) then) =
      _$EditorialPostCopyWithImpl<$Res, EditorialPost>;
  @useResult
  $Res call(
      {String id,
      String title,
      String slug,
      String excerpt,
      String content,
      String? imageUrl,
      DateTime? publishedAt});
}

/// @nodoc
class _$EditorialPostCopyWithImpl<$Res, $Val extends EditorialPost>
    implements $EditorialPostCopyWith<$Res> {
  _$EditorialPostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? slug = null,
    Object? excerpt = null,
    Object? content = null,
    Object? imageUrl = freezed,
    Object? publishedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      excerpt: null == excerpt
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EditorialPostImplCopyWith<$Res>
    implements $EditorialPostCopyWith<$Res> {
  factory _$$EditorialPostImplCopyWith(
          _$EditorialPostImpl value, $Res Function(_$EditorialPostImpl) then) =
      __$$EditorialPostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String slug,
      String excerpt,
      String content,
      String? imageUrl,
      DateTime? publishedAt});
}

/// @nodoc
class __$$EditorialPostImplCopyWithImpl<$Res>
    extends _$EditorialPostCopyWithImpl<$Res, _$EditorialPostImpl>
    implements _$$EditorialPostImplCopyWith<$Res> {
  __$$EditorialPostImplCopyWithImpl(
      _$EditorialPostImpl _value, $Res Function(_$EditorialPostImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? slug = null,
    Object? excerpt = null,
    Object? content = null,
    Object? imageUrl = freezed,
    Object? publishedAt = freezed,
  }) {
    return _then(_$EditorialPostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      excerpt: null == excerpt
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$EditorialPostImpl implements _EditorialPost {
  const _$EditorialPostImpl(
      {required this.id,
      required this.title,
      required this.slug,
      required this.excerpt,
      required this.content,
      this.imageUrl,
      this.publishedAt});

  @override
  final String id;
  @override
  final String title;
  @override
  final String slug;
  @override
  final String excerpt;
  @override
  final String content;
  @override
  final String? imageUrl;
  @override
  final DateTime? publishedAt;

  @override
  String toString() {
    return 'EditorialPost(id: $id, title: $title, slug: $slug, excerpt: $excerpt, content: $content, imageUrl: $imageUrl, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditorialPostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.excerpt, excerpt) || other.excerpt == excerpt) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, slug, excerpt, content, imageUrl, publishedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EditorialPostImplCopyWith<_$EditorialPostImpl> get copyWith =>
      __$$EditorialPostImplCopyWithImpl<_$EditorialPostImpl>(this, _$identity);
}

abstract class _EditorialPost implements EditorialPost {
  const factory _EditorialPost(
      {required final String id,
      required final String title,
      required final String slug,
      required final String excerpt,
      required final String content,
      final String? imageUrl,
      final DateTime? publishedAt}) = _$EditorialPostImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  String get slug;
  @override
  String get excerpt;
  @override
  String get content;
  @override
  String? get imageUrl;
  @override
  DateTime? get publishedAt;
  @override
  @JsonKey(ignore: true)
  _$$EditorialPostImplCopyWith<_$EditorialPostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

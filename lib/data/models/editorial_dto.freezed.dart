// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'editorial_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EditorialPostDto _$EditorialPostDtoFromJson(Map<String, dynamic> json) {
  return _EditorialPostDto.fromJson(json);
}

/// @nodoc
mixin _$EditorialPostDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String get excerpt => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'published_at')
  DateTime? get publishedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EditorialPostDtoCopyWith<EditorialPostDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditorialPostDtoCopyWith<$Res> {
  factory $EditorialPostDtoCopyWith(
          EditorialPostDto value, $Res Function(EditorialPostDto) then) =
      _$EditorialPostDtoCopyWithImpl<$Res, EditorialPostDto>;
  @useResult
  $Res call(
      {int id,
      String title,
      String slug,
      String excerpt,
      String content,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'published_at') DateTime? publishedAt});
}

/// @nodoc
class _$EditorialPostDtoCopyWithImpl<$Res, $Val extends EditorialPostDto>
    implements $EditorialPostDtoCopyWith<$Res> {
  _$EditorialPostDtoCopyWithImpl(this._value, this._then);

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
              as int,
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
abstract class _$$EditorialPostDtoImplCopyWith<$Res>
    implements $EditorialPostDtoCopyWith<$Res> {
  factory _$$EditorialPostDtoImplCopyWith(_$EditorialPostDtoImpl value,
          $Res Function(_$EditorialPostDtoImpl) then) =
      __$$EditorialPostDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String slug,
      String excerpt,
      String content,
      @JsonKey(name: 'image_url') String? imageUrl,
      @JsonKey(name: 'published_at') DateTime? publishedAt});
}

/// @nodoc
class __$$EditorialPostDtoImplCopyWithImpl<$Res>
    extends _$EditorialPostDtoCopyWithImpl<$Res, _$EditorialPostDtoImpl>
    implements _$$EditorialPostDtoImplCopyWith<$Res> {
  __$$EditorialPostDtoImplCopyWithImpl(_$EditorialPostDtoImpl _value,
      $Res Function(_$EditorialPostDtoImpl) _then)
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
    return _then(_$EditorialPostDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
@JsonSerializable()
class _$EditorialPostDtoImpl implements _EditorialPostDto {
  const _$EditorialPostDtoImpl(
      {required this.id,
      required this.title,
      required this.slug,
      required this.excerpt,
      required this.content,
      @JsonKey(name: 'image_url') this.imageUrl,
      @JsonKey(name: 'published_at') this.publishedAt});

  factory _$EditorialPostDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EditorialPostDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String slug;
  @override
  final String excerpt;
  @override
  final String content;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'published_at')
  final DateTime? publishedAt;

  @override
  String toString() {
    return 'EditorialPostDto(id: $id, title: $title, slug: $slug, excerpt: $excerpt, content: $content, imageUrl: $imageUrl, publishedAt: $publishedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditorialPostDtoImpl &&
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

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, slug, excerpt, content, imageUrl, publishedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EditorialPostDtoImplCopyWith<_$EditorialPostDtoImpl> get copyWith =>
      __$$EditorialPostDtoImplCopyWithImpl<_$EditorialPostDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EditorialPostDtoImplToJson(
      this,
    );
  }
}

abstract class _EditorialPostDto implements EditorialPostDto {
  const factory _EditorialPostDto(
          {required final int id,
          required final String title,
          required final String slug,
          required final String excerpt,
          required final String content,
          @JsonKey(name: 'image_url') final String? imageUrl,
          @JsonKey(name: 'published_at') final DateTime? publishedAt}) =
      _$EditorialPostDtoImpl;

  factory _EditorialPostDto.fromJson(Map<String, dynamic> json) =
      _$EditorialPostDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get slug;
  @override
  String get excerpt;
  @override
  String get content;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'published_at')
  DateTime? get publishedAt;
  @override
  @JsonKey(ignore: true)
  _$$EditorialPostDtoImplCopyWith<_$EditorialPostDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

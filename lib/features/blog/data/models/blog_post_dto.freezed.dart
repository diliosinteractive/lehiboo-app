// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blog_post_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BlogPostDto _$BlogPostDtoFromJson(Map<String, dynamic> json) {
  return _BlogPostDto.fromJson(json);
}

/// @nodoc
mixin _$BlogPostDto {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get excerpt => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'featured_image')
  BlogImageDto? get featuredImage => throw _privateConstructorUsedError;
  List<BlogCategoryDto>? get categories => throw _privateConstructorUsedError;
  List<BlogTagDto>? get tags => throw _privateConstructorUsedError;
  BlogAuthorDto? get author => throw _privateConstructorUsedError;
  @JsonKey(name: 'published_at')
  String? get publishedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'modified_at')
  String? get modifiedAt => throw _privateConstructorUsedError;
  String? get link => throw _privateConstructorUsedError;
  @JsonKey(name: 'reading_time')
  int? get readingTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlogPostDtoCopyWith<BlogPostDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlogPostDtoCopyWith<$Res> {
  factory $BlogPostDtoCopyWith(
          BlogPostDto value, $Res Function(BlogPostDto) then) =
      _$BlogPostDtoCopyWithImpl<$Res, BlogPostDto>;
  @useResult
  $Res call(
      {int id,
      String title,
      String slug,
      String? excerpt,
      String? content,
      @JsonKey(name: 'featured_image') BlogImageDto? featuredImage,
      List<BlogCategoryDto>? categories,
      List<BlogTagDto>? tags,
      BlogAuthorDto? author,
      @JsonKey(name: 'published_at') String? publishedAt,
      @JsonKey(name: 'modified_at') String? modifiedAt,
      String? link,
      @JsonKey(name: 'reading_time') int? readingTime});

  $BlogImageDtoCopyWith<$Res>? get featuredImage;
  $BlogAuthorDtoCopyWith<$Res>? get author;
}

/// @nodoc
class _$BlogPostDtoCopyWithImpl<$Res, $Val extends BlogPostDto>
    implements $BlogPostDtoCopyWith<$Res> {
  _$BlogPostDtoCopyWithImpl(this._value, this._then);

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
    Object? excerpt = freezed,
    Object? content = freezed,
    Object? featuredImage = freezed,
    Object? categories = freezed,
    Object? tags = freezed,
    Object? author = freezed,
    Object? publishedAt = freezed,
    Object? modifiedAt = freezed,
    Object? link = freezed,
    Object? readingTime = freezed,
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
      excerpt: freezed == excerpt
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredImage: freezed == featuredImage
          ? _value.featuredImage
          : featuredImage // ignore: cast_nullable_to_non_nullable
              as BlogImageDto?,
      categories: freezed == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<BlogCategoryDto>?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<BlogTagDto>?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as BlogAuthorDto?,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      modifiedAt: freezed == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      readingTime: freezed == readingTime
          ? _value.readingTime
          : readingTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BlogImageDtoCopyWith<$Res>? get featuredImage {
    if (_value.featuredImage == null) {
      return null;
    }

    return $BlogImageDtoCopyWith<$Res>(_value.featuredImage!, (value) {
      return _then(_value.copyWith(featuredImage: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $BlogAuthorDtoCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $BlogAuthorDtoCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BlogPostDtoImplCopyWith<$Res>
    implements $BlogPostDtoCopyWith<$Res> {
  factory _$$BlogPostDtoImplCopyWith(
          _$BlogPostDtoImpl value, $Res Function(_$BlogPostDtoImpl) then) =
      __$$BlogPostDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String slug,
      String? excerpt,
      String? content,
      @JsonKey(name: 'featured_image') BlogImageDto? featuredImage,
      List<BlogCategoryDto>? categories,
      List<BlogTagDto>? tags,
      BlogAuthorDto? author,
      @JsonKey(name: 'published_at') String? publishedAt,
      @JsonKey(name: 'modified_at') String? modifiedAt,
      String? link,
      @JsonKey(name: 'reading_time') int? readingTime});

  @override
  $BlogImageDtoCopyWith<$Res>? get featuredImage;
  @override
  $BlogAuthorDtoCopyWith<$Res>? get author;
}

/// @nodoc
class __$$BlogPostDtoImplCopyWithImpl<$Res>
    extends _$BlogPostDtoCopyWithImpl<$Res, _$BlogPostDtoImpl>
    implements _$$BlogPostDtoImplCopyWith<$Res> {
  __$$BlogPostDtoImplCopyWithImpl(
      _$BlogPostDtoImpl _value, $Res Function(_$BlogPostDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? slug = null,
    Object? excerpt = freezed,
    Object? content = freezed,
    Object? featuredImage = freezed,
    Object? categories = freezed,
    Object? tags = freezed,
    Object? author = freezed,
    Object? publishedAt = freezed,
    Object? modifiedAt = freezed,
    Object? link = freezed,
    Object? readingTime = freezed,
  }) {
    return _then(_$BlogPostDtoImpl(
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
      excerpt: freezed == excerpt
          ? _value.excerpt
          : excerpt // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredImage: freezed == featuredImage
          ? _value.featuredImage
          : featuredImage // ignore: cast_nullable_to_non_nullable
              as BlogImageDto?,
      categories: freezed == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<BlogCategoryDto>?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<BlogTagDto>?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as BlogAuthorDto?,
      publishedAt: freezed == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      modifiedAt: freezed == modifiedAt
          ? _value.modifiedAt
          : modifiedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      link: freezed == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String?,
      readingTime: freezed == readingTime
          ? _value.readingTime
          : readingTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BlogPostDtoImpl implements _BlogPostDto {
  const _$BlogPostDtoImpl(
      {required this.id,
      required this.title,
      required this.slug,
      this.excerpt,
      this.content,
      @JsonKey(name: 'featured_image') this.featuredImage,
      final List<BlogCategoryDto>? categories,
      final List<BlogTagDto>? tags,
      this.author,
      @JsonKey(name: 'published_at') this.publishedAt,
      @JsonKey(name: 'modified_at') this.modifiedAt,
      this.link,
      @JsonKey(name: 'reading_time') this.readingTime})
      : _categories = categories,
        _tags = tags;

  factory _$BlogPostDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlogPostDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String slug;
  @override
  final String? excerpt;
  @override
  final String? content;
  @override
  @JsonKey(name: 'featured_image')
  final BlogImageDto? featuredImage;
  final List<BlogCategoryDto>? _categories;
  @override
  List<BlogCategoryDto>? get categories {
    final value = _categories;
    if (value == null) return null;
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<BlogTagDto>? _tags;
  @override
  List<BlogTagDto>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final BlogAuthorDto? author;
  @override
  @JsonKey(name: 'published_at')
  final String? publishedAt;
  @override
  @JsonKey(name: 'modified_at')
  final String? modifiedAt;
  @override
  final String? link;
  @override
  @JsonKey(name: 'reading_time')
  final int? readingTime;

  @override
  String toString() {
    return 'BlogPostDto(id: $id, title: $title, slug: $slug, excerpt: $excerpt, content: $content, featuredImage: $featuredImage, categories: $categories, tags: $tags, author: $author, publishedAt: $publishedAt, modifiedAt: $modifiedAt, link: $link, readingTime: $readingTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogPostDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.excerpt, excerpt) || other.excerpt == excerpt) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.featuredImage, featuredImage) ||
                other.featuredImage == featuredImage) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.modifiedAt, modifiedAt) ||
                other.modifiedAt == modifiedAt) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.readingTime, readingTime) ||
                other.readingTime == readingTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      slug,
      excerpt,
      content,
      featuredImage,
      const DeepCollectionEquality().hash(_categories),
      const DeepCollectionEquality().hash(_tags),
      author,
      publishedAt,
      modifiedAt,
      link,
      readingTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogPostDtoImplCopyWith<_$BlogPostDtoImpl> get copyWith =>
      __$$BlogPostDtoImplCopyWithImpl<_$BlogPostDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlogPostDtoImplToJson(
      this,
    );
  }
}

abstract class _BlogPostDto implements BlogPostDto {
  const factory _BlogPostDto(
          {required final int id,
          required final String title,
          required final String slug,
          final String? excerpt,
          final String? content,
          @JsonKey(name: 'featured_image') final BlogImageDto? featuredImage,
          final List<BlogCategoryDto>? categories,
          final List<BlogTagDto>? tags,
          final BlogAuthorDto? author,
          @JsonKey(name: 'published_at') final String? publishedAt,
          @JsonKey(name: 'modified_at') final String? modifiedAt,
          final String? link,
          @JsonKey(name: 'reading_time') final int? readingTime}) =
      _$BlogPostDtoImpl;

  factory _BlogPostDto.fromJson(Map<String, dynamic> json) =
      _$BlogPostDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String get slug;
  @override
  String? get excerpt;
  @override
  String? get content;
  @override
  @JsonKey(name: 'featured_image')
  BlogImageDto? get featuredImage;
  @override
  List<BlogCategoryDto>? get categories;
  @override
  List<BlogTagDto>? get tags;
  @override
  BlogAuthorDto? get author;
  @override
  @JsonKey(name: 'published_at')
  String? get publishedAt;
  @override
  @JsonKey(name: 'modified_at')
  String? get modifiedAt;
  @override
  String? get link;
  @override
  @JsonKey(name: 'reading_time')
  int? get readingTime;
  @override
  @JsonKey(ignore: true)
  _$$BlogPostDtoImplCopyWith<_$BlogPostDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BlogImageDto _$BlogImageDtoFromJson(Map<String, dynamic> json) {
  return _BlogImageDto.fromJson(json);
}

/// @nodoc
mixin _$BlogImageDto {
  String? get thumbnail => throw _privateConstructorUsedError;
  String? get medium => throw _privateConstructorUsedError;
  String? get large => throw _privateConstructorUsedError;
  String? get full => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlogImageDtoCopyWith<BlogImageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlogImageDtoCopyWith<$Res> {
  factory $BlogImageDtoCopyWith(
          BlogImageDto value, $Res Function(BlogImageDto) then) =
      _$BlogImageDtoCopyWithImpl<$Res, BlogImageDto>;
  @useResult
  $Res call({String? thumbnail, String? medium, String? large, String? full});
}

/// @nodoc
class _$BlogImageDtoCopyWithImpl<$Res, $Val extends BlogImageDto>
    implements $BlogImageDtoCopyWith<$Res> {
  _$BlogImageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thumbnail = freezed,
    Object? medium = freezed,
    Object? large = freezed,
    Object? full = freezed,
  }) {
    return _then(_value.copyWith(
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      medium: freezed == medium
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      large: freezed == large
          ? _value.large
          : large // ignore: cast_nullable_to_non_nullable
              as String?,
      full: freezed == full
          ? _value.full
          : full // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlogImageDtoImplCopyWith<$Res>
    implements $BlogImageDtoCopyWith<$Res> {
  factory _$$BlogImageDtoImplCopyWith(
          _$BlogImageDtoImpl value, $Res Function(_$BlogImageDtoImpl) then) =
      __$$BlogImageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? thumbnail, String? medium, String? large, String? full});
}

/// @nodoc
class __$$BlogImageDtoImplCopyWithImpl<$Res>
    extends _$BlogImageDtoCopyWithImpl<$Res, _$BlogImageDtoImpl>
    implements _$$BlogImageDtoImplCopyWith<$Res> {
  __$$BlogImageDtoImplCopyWithImpl(
      _$BlogImageDtoImpl _value, $Res Function(_$BlogImageDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? thumbnail = freezed,
    Object? medium = freezed,
    Object? large = freezed,
    Object? full = freezed,
  }) {
    return _then(_$BlogImageDtoImpl(
      thumbnail: freezed == thumbnail
          ? _value.thumbnail
          : thumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      medium: freezed == medium
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      large: freezed == large
          ? _value.large
          : large // ignore: cast_nullable_to_non_nullable
              as String?,
      full: freezed == full
          ? _value.full
          : full // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BlogImageDtoImpl implements _BlogImageDto {
  const _$BlogImageDtoImpl(
      {this.thumbnail, this.medium, this.large, this.full});

  factory _$BlogImageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlogImageDtoImplFromJson(json);

  @override
  final String? thumbnail;
  @override
  final String? medium;
  @override
  final String? large;
  @override
  final String? full;

  @override
  String toString() {
    return 'BlogImageDto(thumbnail: $thumbnail, medium: $medium, large: $large, full: $full)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogImageDtoImpl &&
            (identical(other.thumbnail, thumbnail) ||
                other.thumbnail == thumbnail) &&
            (identical(other.medium, medium) || other.medium == medium) &&
            (identical(other.large, large) || other.large == large) &&
            (identical(other.full, full) || other.full == full));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, thumbnail, medium, large, full);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogImageDtoImplCopyWith<_$BlogImageDtoImpl> get copyWith =>
      __$$BlogImageDtoImplCopyWithImpl<_$BlogImageDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlogImageDtoImplToJson(
      this,
    );
  }
}

abstract class _BlogImageDto implements BlogImageDto {
  const factory _BlogImageDto(
      {final String? thumbnail,
      final String? medium,
      final String? large,
      final String? full}) = _$BlogImageDtoImpl;

  factory _BlogImageDto.fromJson(Map<String, dynamic> json) =
      _$BlogImageDtoImpl.fromJson;

  @override
  String? get thumbnail;
  @override
  String? get medium;
  @override
  String? get large;
  @override
  String? get full;
  @override
  @JsonKey(ignore: true)
  _$$BlogImageDtoImplCopyWith<_$BlogImageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BlogCategoryDto _$BlogCategoryDtoFromJson(Map<String, dynamic> json) {
  return _BlogCategoryDto.fromJson(json);
}

/// @nodoc
mixin _$BlogCategoryDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlogCategoryDtoCopyWith<BlogCategoryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlogCategoryDtoCopyWith<$Res> {
  factory $BlogCategoryDtoCopyWith(
          BlogCategoryDto value, $Res Function(BlogCategoryDto) then) =
      _$BlogCategoryDtoCopyWithImpl<$Res, BlogCategoryDto>;
  @useResult
  $Res call({int id, String name, String slug});
}

/// @nodoc
class _$BlogCategoryDtoCopyWithImpl<$Res, $Val extends BlogCategoryDto>
    implements $BlogCategoryDtoCopyWith<$Res> {
  _$BlogCategoryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlogCategoryDtoImplCopyWith<$Res>
    implements $BlogCategoryDtoCopyWith<$Res> {
  factory _$$BlogCategoryDtoImplCopyWith(_$BlogCategoryDtoImpl value,
          $Res Function(_$BlogCategoryDtoImpl) then) =
      __$$BlogCategoryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String slug});
}

/// @nodoc
class __$$BlogCategoryDtoImplCopyWithImpl<$Res>
    extends _$BlogCategoryDtoCopyWithImpl<$Res, _$BlogCategoryDtoImpl>
    implements _$$BlogCategoryDtoImplCopyWith<$Res> {
  __$$BlogCategoryDtoImplCopyWithImpl(
      _$BlogCategoryDtoImpl _value, $Res Function(_$BlogCategoryDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
  }) {
    return _then(_$BlogCategoryDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BlogCategoryDtoImpl implements _BlogCategoryDto {
  const _$BlogCategoryDtoImpl(
      {required this.id, required this.name, required this.slug});

  factory _$BlogCategoryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlogCategoryDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String slug;

  @override
  String toString() {
    return 'BlogCategoryDto(id: $id, name: $name, slug: $slug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogCategoryDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogCategoryDtoImplCopyWith<_$BlogCategoryDtoImpl> get copyWith =>
      __$$BlogCategoryDtoImplCopyWithImpl<_$BlogCategoryDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlogCategoryDtoImplToJson(
      this,
    );
  }
}

abstract class _BlogCategoryDto implements BlogCategoryDto {
  const factory _BlogCategoryDto(
      {required final int id,
      required final String name,
      required final String slug}) = _$BlogCategoryDtoImpl;

  factory _BlogCategoryDto.fromJson(Map<String, dynamic> json) =
      _$BlogCategoryDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  @JsonKey(ignore: true)
  _$$BlogCategoryDtoImplCopyWith<_$BlogCategoryDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BlogTagDto _$BlogTagDtoFromJson(Map<String, dynamic> json) {
  return _BlogTagDto.fromJson(json);
}

/// @nodoc
mixin _$BlogTagDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlogTagDtoCopyWith<BlogTagDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlogTagDtoCopyWith<$Res> {
  factory $BlogTagDtoCopyWith(
          BlogTagDto value, $Res Function(BlogTagDto) then) =
      _$BlogTagDtoCopyWithImpl<$Res, BlogTagDto>;
  @useResult
  $Res call({int id, String name, String slug});
}

/// @nodoc
class _$BlogTagDtoCopyWithImpl<$Res, $Val extends BlogTagDto>
    implements $BlogTagDtoCopyWith<$Res> {
  _$BlogTagDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlogTagDtoImplCopyWith<$Res>
    implements $BlogTagDtoCopyWith<$Res> {
  factory _$$BlogTagDtoImplCopyWith(
          _$BlogTagDtoImpl value, $Res Function(_$BlogTagDtoImpl) then) =
      __$$BlogTagDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String slug});
}

/// @nodoc
class __$$BlogTagDtoImplCopyWithImpl<$Res>
    extends _$BlogTagDtoCopyWithImpl<$Res, _$BlogTagDtoImpl>
    implements _$$BlogTagDtoImplCopyWith<$Res> {
  __$$BlogTagDtoImplCopyWithImpl(
      _$BlogTagDtoImpl _value, $Res Function(_$BlogTagDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
  }) {
    return _then(_$BlogTagDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BlogTagDtoImpl implements _BlogTagDto {
  const _$BlogTagDtoImpl(
      {required this.id, required this.name, required this.slug});

  factory _$BlogTagDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlogTagDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String slug;

  @override
  String toString() {
    return 'BlogTagDto(id: $id, name: $name, slug: $slug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogTagDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogTagDtoImplCopyWith<_$BlogTagDtoImpl> get copyWith =>
      __$$BlogTagDtoImplCopyWithImpl<_$BlogTagDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlogTagDtoImplToJson(
      this,
    );
  }
}

abstract class _BlogTagDto implements BlogTagDto {
  const factory _BlogTagDto(
      {required final int id,
      required final String name,
      required final String slug}) = _$BlogTagDtoImpl;

  factory _BlogTagDto.fromJson(Map<String, dynamic> json) =
      _$BlogTagDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get slug;
  @override
  @JsonKey(ignore: true)
  _$$BlogTagDtoImplCopyWith<_$BlogTagDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BlogAuthorDto _$BlogAuthorDtoFromJson(Map<String, dynamic> json) {
  return _BlogAuthorDto.fromJson(json);
}

/// @nodoc
mixin _$BlogAuthorDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlogAuthorDtoCopyWith<BlogAuthorDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlogAuthorDtoCopyWith<$Res> {
  factory $BlogAuthorDtoCopyWith(
          BlogAuthorDto value, $Res Function(BlogAuthorDto) then) =
      _$BlogAuthorDtoCopyWithImpl<$Res, BlogAuthorDto>;
  @useResult
  $Res call({int id, String name, String? avatar});
}

/// @nodoc
class _$BlogAuthorDtoCopyWithImpl<$Res, $Val extends BlogAuthorDto>
    implements $BlogAuthorDtoCopyWith<$Res> {
  _$BlogAuthorDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$BlogAuthorDtoImplCopyWith<$Res>
    implements $BlogAuthorDtoCopyWith<$Res> {
  factory _$$BlogAuthorDtoImplCopyWith(
          _$BlogAuthorDtoImpl value, $Res Function(_$BlogAuthorDtoImpl) then) =
      __$$BlogAuthorDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String? avatar});
}

/// @nodoc
class __$$BlogAuthorDtoImplCopyWithImpl<$Res>
    extends _$BlogAuthorDtoCopyWithImpl<$Res, _$BlogAuthorDtoImpl>
    implements _$$BlogAuthorDtoImplCopyWith<$Res> {
  __$$BlogAuthorDtoImplCopyWithImpl(
      _$BlogAuthorDtoImpl _value, $Res Function(_$BlogAuthorDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = freezed,
  }) {
    return _then(_$BlogAuthorDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$BlogAuthorDtoImpl implements _BlogAuthorDto {
  const _$BlogAuthorDtoImpl(
      {required this.id, required this.name, this.avatar});

  factory _$BlogAuthorDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlogAuthorDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? avatar;

  @override
  String toString() {
    return 'BlogAuthorDto(id: $id, name: $name, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogAuthorDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, avatar);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogAuthorDtoImplCopyWith<_$BlogAuthorDtoImpl> get copyWith =>
      __$$BlogAuthorDtoImplCopyWithImpl<_$BlogAuthorDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlogAuthorDtoImplToJson(
      this,
    );
  }
}

abstract class _BlogAuthorDto implements BlogAuthorDto {
  const factory _BlogAuthorDto(
      {required final int id,
      required final String name,
      final String? avatar}) = _$BlogAuthorDtoImpl;

  factory _BlogAuthorDto.fromJson(Map<String, dynamic> json) =
      _$BlogAuthorDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get avatar;
  @override
  @JsonKey(ignore: true)
  _$$BlogAuthorDtoImplCopyWith<_$BlogAuthorDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BlogPostsResponseDto _$BlogPostsResponseDtoFromJson(Map<String, dynamic> json) {
  return _BlogPostsResponseDto.fromJson(json);
}

/// @nodoc
mixin _$BlogPostsResponseDto {
  List<BlogPostDto> get posts => throw _privateConstructorUsedError;
  BlogPaginationDto get pagination => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlogPostsResponseDtoCopyWith<BlogPostsResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlogPostsResponseDtoCopyWith<$Res> {
  factory $BlogPostsResponseDtoCopyWith(BlogPostsResponseDto value,
          $Res Function(BlogPostsResponseDto) then) =
      _$BlogPostsResponseDtoCopyWithImpl<$Res, BlogPostsResponseDto>;
  @useResult
  $Res call({List<BlogPostDto> posts, BlogPaginationDto pagination});

  $BlogPaginationDtoCopyWith<$Res> get pagination;
}

/// @nodoc
class _$BlogPostsResponseDtoCopyWithImpl<$Res,
        $Val extends BlogPostsResponseDto>
    implements $BlogPostsResponseDtoCopyWith<$Res> {
  _$BlogPostsResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? posts = null,
    Object? pagination = null,
  }) {
    return _then(_value.copyWith(
      posts: null == posts
          ? _value.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<BlogPostDto>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as BlogPaginationDto,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BlogPaginationDtoCopyWith<$Res> get pagination {
    return $BlogPaginationDtoCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BlogPostsResponseDtoImplCopyWith<$Res>
    implements $BlogPostsResponseDtoCopyWith<$Res> {
  factory _$$BlogPostsResponseDtoImplCopyWith(_$BlogPostsResponseDtoImpl value,
          $Res Function(_$BlogPostsResponseDtoImpl) then) =
      __$$BlogPostsResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<BlogPostDto> posts, BlogPaginationDto pagination});

  @override
  $BlogPaginationDtoCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$BlogPostsResponseDtoImplCopyWithImpl<$Res>
    extends _$BlogPostsResponseDtoCopyWithImpl<$Res, _$BlogPostsResponseDtoImpl>
    implements _$$BlogPostsResponseDtoImplCopyWith<$Res> {
  __$$BlogPostsResponseDtoImplCopyWithImpl(_$BlogPostsResponseDtoImpl _value,
      $Res Function(_$BlogPostsResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? posts = null,
    Object? pagination = null,
  }) {
    return _then(_$BlogPostsResponseDtoImpl(
      posts: null == posts
          ? _value._posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<BlogPostDto>,
      pagination: null == pagination
          ? _value.pagination
          : pagination // ignore: cast_nullable_to_non_nullable
              as BlogPaginationDto,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BlogPostsResponseDtoImpl implements _BlogPostsResponseDto {
  const _$BlogPostsResponseDtoImpl(
      {required final List<BlogPostDto> posts, required this.pagination})
      : _posts = posts;

  factory _$BlogPostsResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlogPostsResponseDtoImplFromJson(json);

  final List<BlogPostDto> _posts;
  @override
  List<BlogPostDto> get posts {
    if (_posts is EqualUnmodifiableListView) return _posts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_posts);
  }

  @override
  final BlogPaginationDto pagination;

  @override
  String toString() {
    return 'BlogPostsResponseDto(posts: $posts, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogPostsResponseDtoImpl &&
            const DeepCollectionEquality().equals(other._posts, _posts) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_posts), pagination);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogPostsResponseDtoImplCopyWith<_$BlogPostsResponseDtoImpl>
      get copyWith =>
          __$$BlogPostsResponseDtoImplCopyWithImpl<_$BlogPostsResponseDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlogPostsResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _BlogPostsResponseDto implements BlogPostsResponseDto {
  const factory _BlogPostsResponseDto(
          {required final List<BlogPostDto> posts,
          required final BlogPaginationDto pagination}) =
      _$BlogPostsResponseDtoImpl;

  factory _BlogPostsResponseDto.fromJson(Map<String, dynamic> json) =
      _$BlogPostsResponseDtoImpl.fromJson;

  @override
  List<BlogPostDto> get posts;
  @override
  BlogPaginationDto get pagination;
  @override
  @JsonKey(ignore: true)
  _$$BlogPostsResponseDtoImplCopyWith<_$BlogPostsResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BlogPaginationDto _$BlogPaginationDtoFromJson(Map<String, dynamic> json) {
  return _BlogPaginationDto.fromJson(json);
}

/// @nodoc
mixin _$BlogPaginationDto {
  @JsonKey(name: 'current_page')
  int get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page')
  int get perPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_items')
  int get totalItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_pages')
  int get totalPages => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_next')
  bool get hasNext => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_prev')
  bool get hasPrev => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BlogPaginationDtoCopyWith<BlogPaginationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlogPaginationDtoCopyWith<$Res> {
  factory $BlogPaginationDtoCopyWith(
          BlogPaginationDto value, $Res Function(BlogPaginationDto) then) =
      _$BlogPaginationDtoCopyWithImpl<$Res, BlogPaginationDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page') int currentPage,
      @JsonKey(name: 'per_page') int perPage,
      @JsonKey(name: 'total_items') int totalItems,
      @JsonKey(name: 'total_pages') int totalPages,
      @JsonKey(name: 'has_next') bool hasNext,
      @JsonKey(name: 'has_prev') bool hasPrev});
}

/// @nodoc
class _$BlogPaginationDtoCopyWithImpl<$Res, $Val extends BlogPaginationDto>
    implements $BlogPaginationDtoCopyWith<$Res> {
  _$BlogPaginationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? perPage = null,
    Object? totalItems = null,
    Object? totalPages = null,
    Object? hasNext = null,
    Object? hasPrev = null,
  }) {
    return _then(_value.copyWith(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrev: null == hasPrev
          ? _value.hasPrev
          : hasPrev // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlogPaginationDtoImplCopyWith<$Res>
    implements $BlogPaginationDtoCopyWith<$Res> {
  factory _$$BlogPaginationDtoImplCopyWith(_$BlogPaginationDtoImpl value,
          $Res Function(_$BlogPaginationDtoImpl) then) =
      __$$BlogPaginationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page') int currentPage,
      @JsonKey(name: 'per_page') int perPage,
      @JsonKey(name: 'total_items') int totalItems,
      @JsonKey(name: 'total_pages') int totalPages,
      @JsonKey(name: 'has_next') bool hasNext,
      @JsonKey(name: 'has_prev') bool hasPrev});
}

/// @nodoc
class __$$BlogPaginationDtoImplCopyWithImpl<$Res>
    extends _$BlogPaginationDtoCopyWithImpl<$Res, _$BlogPaginationDtoImpl>
    implements _$$BlogPaginationDtoImplCopyWith<$Res> {
  __$$BlogPaginationDtoImplCopyWithImpl(_$BlogPaginationDtoImpl _value,
      $Res Function(_$BlogPaginationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? perPage = null,
    Object? totalItems = null,
    Object? totalPages = null,
    Object? hasNext = null,
    Object? hasPrev = null,
  }) {
    return _then(_$BlogPaginationDtoImpl(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      hasNext: null == hasNext
          ? _value.hasNext
          : hasNext // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPrev: null == hasPrev
          ? _value.hasPrev
          : hasPrev // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BlogPaginationDtoImpl implements _BlogPaginationDto {
  const _$BlogPaginationDtoImpl(
      {@JsonKey(name: 'current_page') required this.currentPage,
      @JsonKey(name: 'per_page') required this.perPage,
      @JsonKey(name: 'total_items') required this.totalItems,
      @JsonKey(name: 'total_pages') required this.totalPages,
      @JsonKey(name: 'has_next') this.hasNext = false,
      @JsonKey(name: 'has_prev') this.hasPrev = false});

  factory _$BlogPaginationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BlogPaginationDtoImplFromJson(json);

  @override
  @JsonKey(name: 'current_page')
  final int currentPage;
  @override
  @JsonKey(name: 'per_page')
  final int perPage;
  @override
  @JsonKey(name: 'total_items')
  final int totalItems;
  @override
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @override
  @JsonKey(name: 'has_next')
  final bool hasNext;
  @override
  @JsonKey(name: 'has_prev')
  final bool hasPrev;

  @override
  String toString() {
    return 'BlogPaginationDto(currentPage: $currentPage, perPage: $perPage, totalItems: $totalItems, totalPages: $totalPages, hasNext: $hasNext, hasPrev: $hasPrev)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlogPaginationDtoImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.hasNext, hasNext) || other.hasNext == hasNext) &&
            (identical(other.hasPrev, hasPrev) || other.hasPrev == hasPrev));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, currentPage, perPage, totalItems,
      totalPages, hasNext, hasPrev);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BlogPaginationDtoImplCopyWith<_$BlogPaginationDtoImpl> get copyWith =>
      __$$BlogPaginationDtoImplCopyWithImpl<_$BlogPaginationDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BlogPaginationDtoImplToJson(
      this,
    );
  }
}

abstract class _BlogPaginationDto implements BlogPaginationDto {
  const factory _BlogPaginationDto(
      {@JsonKey(name: 'current_page') required final int currentPage,
      @JsonKey(name: 'per_page') required final int perPage,
      @JsonKey(name: 'total_items') required final int totalItems,
      @JsonKey(name: 'total_pages') required final int totalPages,
      @JsonKey(name: 'has_next') final bool hasNext,
      @JsonKey(name: 'has_prev') final bool hasPrev}) = _$BlogPaginationDtoImpl;

  factory _BlogPaginationDto.fromJson(Map<String, dynamic> json) =
      _$BlogPaginationDtoImpl.fromJson;

  @override
  @JsonKey(name: 'current_page')
  int get currentPage;
  @override
  @JsonKey(name: 'per_page')
  int get perPage;
  @override
  @JsonKey(name: 'total_items')
  int get totalItems;
  @override
  @JsonKey(name: 'total_pages')
  int get totalPages;
  @override
  @JsonKey(name: 'has_next')
  bool get hasNext;
  @override
  @JsonKey(name: 'has_prev')
  bool get hasPrev;
  @override
  @JsonKey(ignore: true)
  _$$BlogPaginationDtoImplCopyWith<_$BlogPaginationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

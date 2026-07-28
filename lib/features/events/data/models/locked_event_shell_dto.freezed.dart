// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'locked_event_shell_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LockedEventShellDto _$LockedEventShellDtoFromJson(Map<String, dynamic> json) {
  return _LockedEventShellDto.fromJson(json);
}

/// @nodoc
mixin _$LockedEventShellDto {
  @JsonKey(fromJson: _string)
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get slug => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _string)
  String get title => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get excerpt => throw _privateConstructorUsedError;
  @JsonKey(name: 'short_description', fromJson: _stringOrNull)
  String? get shortDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_image', fromJson: _stringOrNull)
  String? get coverImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'featured_image', fromJson: _stringOrNull)
  String? get featuredImage => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _stringOrNull)
  String? get visibility => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_password_protected', fromJson: _bool)
  bool get isPasswordProtected => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LockedEventShellDtoCopyWith<LockedEventShellDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LockedEventShellDtoCopyWith<$Res> {
  factory $LockedEventShellDtoCopyWith(
          LockedEventShellDto value, $Res Function(LockedEventShellDto) then) =
      _$LockedEventShellDtoCopyWithImpl<$Res, LockedEventShellDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _string) String uuid,
      @JsonKey(fromJson: _stringOrNull) String? slug,
      @JsonKey(fromJson: _string) String title,
      @JsonKey(fromJson: _stringOrNull) String? excerpt,
      @JsonKey(name: 'short_description', fromJson: _stringOrNull)
      String? shortDescription,
      @JsonKey(name: 'cover_image', fromJson: _stringOrNull) String? coverImage,
      @JsonKey(name: 'featured_image', fromJson: _stringOrNull)
      String? featuredImage,
      @JsonKey(fromJson: _stringOrNull) String? visibility,
      @JsonKey(name: 'is_password_protected', fromJson: _bool)
      bool isPasswordProtected});
}

/// @nodoc
class _$LockedEventShellDtoCopyWithImpl<$Res, $Val extends LockedEventShellDto>
    implements $LockedEventShellDtoCopyWith<$Res> {
  _$LockedEventShellDtoCopyWithImpl(this._value, this._then);

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
    Object? shortDescription = freezed,
    Object? coverImage = freezed,
    Object? featuredImage = freezed,
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
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredImage: freezed == featuredImage
          ? _value.featuredImage
          : featuredImage // ignore: cast_nullable_to_non_nullable
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
abstract class _$$LockedEventShellDtoImplCopyWith<$Res>
    implements $LockedEventShellDtoCopyWith<$Res> {
  factory _$$LockedEventShellDtoImplCopyWith(_$LockedEventShellDtoImpl value,
          $Res Function(_$LockedEventShellDtoImpl) then) =
      __$$LockedEventShellDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _string) String uuid,
      @JsonKey(fromJson: _stringOrNull) String? slug,
      @JsonKey(fromJson: _string) String title,
      @JsonKey(fromJson: _stringOrNull) String? excerpt,
      @JsonKey(name: 'short_description', fromJson: _stringOrNull)
      String? shortDescription,
      @JsonKey(name: 'cover_image', fromJson: _stringOrNull) String? coverImage,
      @JsonKey(name: 'featured_image', fromJson: _stringOrNull)
      String? featuredImage,
      @JsonKey(fromJson: _stringOrNull) String? visibility,
      @JsonKey(name: 'is_password_protected', fromJson: _bool)
      bool isPasswordProtected});
}

/// @nodoc
class __$$LockedEventShellDtoImplCopyWithImpl<$Res>
    extends _$LockedEventShellDtoCopyWithImpl<$Res, _$LockedEventShellDtoImpl>
    implements _$$LockedEventShellDtoImplCopyWith<$Res> {
  __$$LockedEventShellDtoImplCopyWithImpl(_$LockedEventShellDtoImpl _value,
      $Res Function(_$LockedEventShellDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? slug = freezed,
    Object? title = null,
    Object? excerpt = freezed,
    Object? shortDescription = freezed,
    Object? coverImage = freezed,
    Object? featuredImage = freezed,
    Object? visibility = freezed,
    Object? isPasswordProtected = null,
  }) {
    return _then(_$LockedEventShellDtoImpl(
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
      shortDescription: freezed == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      featuredImage: freezed == featuredImage
          ? _value.featuredImage
          : featuredImage // ignore: cast_nullable_to_non_nullable
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
@JsonSerializable()
class _$LockedEventShellDtoImpl implements _LockedEventShellDto {
  const _$LockedEventShellDtoImpl(
      {@JsonKey(fromJson: _string) this.uuid = '',
      @JsonKey(fromJson: _stringOrNull) this.slug,
      @JsonKey(fromJson: _string) this.title = '',
      @JsonKey(fromJson: _stringOrNull) this.excerpt,
      @JsonKey(name: 'short_description', fromJson: _stringOrNull)
      this.shortDescription,
      @JsonKey(name: 'cover_image', fromJson: _stringOrNull) this.coverImage,
      @JsonKey(name: 'featured_image', fromJson: _stringOrNull)
      this.featuredImage,
      @JsonKey(fromJson: _stringOrNull) this.visibility,
      @JsonKey(name: 'is_password_protected', fromJson: _bool)
      this.isPasswordProtected = true});

  factory _$LockedEventShellDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LockedEventShellDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _string)
  final String uuid;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? slug;
  @override
  @JsonKey(fromJson: _string)
  final String title;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? excerpt;
  @override
  @JsonKey(name: 'short_description', fromJson: _stringOrNull)
  final String? shortDescription;
  @override
  @JsonKey(name: 'cover_image', fromJson: _stringOrNull)
  final String? coverImage;
  @override
  @JsonKey(name: 'featured_image', fromJson: _stringOrNull)
  final String? featuredImage;
  @override
  @JsonKey(fromJson: _stringOrNull)
  final String? visibility;
  @override
  @JsonKey(name: 'is_password_protected', fromJson: _bool)
  final bool isPasswordProtected;

  @override
  String toString() {
    return 'LockedEventShellDto(uuid: $uuid, slug: $slug, title: $title, excerpt: $excerpt, shortDescription: $shortDescription, coverImage: $coverImage, featuredImage: $featuredImage, visibility: $visibility, isPasswordProtected: $isPasswordProtected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LockedEventShellDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.excerpt, excerpt) || other.excerpt == excerpt) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage) &&
            (identical(other.featuredImage, featuredImage) ||
                other.featuredImage == featuredImage) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.isPasswordProtected, isPasswordProtected) ||
                other.isPasswordProtected == isPasswordProtected));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uuid,
      slug,
      title,
      excerpt,
      shortDescription,
      coverImage,
      featuredImage,
      visibility,
      isPasswordProtected);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LockedEventShellDtoImplCopyWith<_$LockedEventShellDtoImpl> get copyWith =>
      __$$LockedEventShellDtoImplCopyWithImpl<_$LockedEventShellDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LockedEventShellDtoImplToJson(
      this,
    );
  }
}

abstract class _LockedEventShellDto implements LockedEventShellDto {
  const factory _LockedEventShellDto(
      {@JsonKey(fromJson: _string) final String uuid,
      @JsonKey(fromJson: _stringOrNull) final String? slug,
      @JsonKey(fromJson: _string) final String title,
      @JsonKey(fromJson: _stringOrNull) final String? excerpt,
      @JsonKey(name: 'short_description', fromJson: _stringOrNull)
      final String? shortDescription,
      @JsonKey(name: 'cover_image', fromJson: _stringOrNull)
      final String? coverImage,
      @JsonKey(name: 'featured_image', fromJson: _stringOrNull)
      final String? featuredImage,
      @JsonKey(fromJson: _stringOrNull) final String? visibility,
      @JsonKey(name: 'is_password_protected', fromJson: _bool)
      final bool isPasswordProtected}) = _$LockedEventShellDtoImpl;

  factory _LockedEventShellDto.fromJson(Map<String, dynamic> json) =
      _$LockedEventShellDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _string)
  String get uuid;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get slug;
  @override
  @JsonKey(fromJson: _string)
  String get title;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get excerpt;
  @override
  @JsonKey(name: 'short_description', fromJson: _stringOrNull)
  String? get shortDescription;
  @override
  @JsonKey(name: 'cover_image', fromJson: _stringOrNull)
  String? get coverImage;
  @override
  @JsonKey(name: 'featured_image', fromJson: _stringOrNull)
  String? get featuredImage;
  @override
  @JsonKey(fromJson: _stringOrNull)
  String? get visibility;
  @override
  @JsonKey(name: 'is_password_protected', fromJson: _bool)
  bool get isPasswordProtected;
  @override
  @JsonKey(ignore: true)
  _$$LockedEventShellDtoImplCopyWith<_$LockedEventShellDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

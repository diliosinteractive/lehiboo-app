// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hero_slide_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HeroSlideDto _$HeroSlideDtoFromJson(Map<String, dynamic> json) {
  return _HeroSlideDto.fromJson(json);
}

/// @nodoc
mixin _$HeroSlideDto {
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'alt_text')
  String get altText => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HeroSlideDtoCopyWith<HeroSlideDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeroSlideDtoCopyWith<$Res> {
  factory $HeroSlideDtoCopyWith(
          HeroSlideDto value, $Res Function(HeroSlideDto) then) =
      _$HeroSlideDtoCopyWithImpl<$Res, HeroSlideDto>;
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'alt_text') String altText,
      @JsonKey(name: 'sort_order') int sortOrder});
}

/// @nodoc
class _$HeroSlideDtoCopyWithImpl<$Res, $Val extends HeroSlideDto>
    implements $HeroSlideDtoCopyWith<$Res> {
  _$HeroSlideDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? imageUrl = null,
    Object? altText = null,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      altText: null == altText
          ? _value.altText
          : altText // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HeroSlideDtoImplCopyWith<$Res>
    implements $HeroSlideDtoCopyWith<$Res> {
  factory _$$HeroSlideDtoImplCopyWith(
          _$HeroSlideDtoImpl value, $Res Function(_$HeroSlideDtoImpl) then) =
      __$$HeroSlideDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(name: 'image_url') String imageUrl,
      @JsonKey(name: 'alt_text') String altText,
      @JsonKey(name: 'sort_order') int sortOrder});
}

/// @nodoc
class __$$HeroSlideDtoImplCopyWithImpl<$Res>
    extends _$HeroSlideDtoCopyWithImpl<$Res, _$HeroSlideDtoImpl>
    implements _$$HeroSlideDtoImplCopyWith<$Res> {
  __$$HeroSlideDtoImplCopyWithImpl(
      _$HeroSlideDtoImpl _value, $Res Function(_$HeroSlideDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? imageUrl = null,
    Object? altText = null,
    Object? sortOrder = null,
  }) {
    return _then(_$HeroSlideDtoImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      altText: null == altText
          ? _value.altText
          : altText // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HeroSlideDtoImpl implements _HeroSlideDto {
  const _$HeroSlideDtoImpl(
      {this.uuid = '',
      @JsonKey(name: 'image_url') this.imageUrl = '',
      @JsonKey(name: 'alt_text') this.altText = '',
      @JsonKey(name: 'sort_order') this.sortOrder = 0});

  factory _$HeroSlideDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeroSlideDtoImplFromJson(json);

  @override
  @JsonKey()
  final String uuid;
  @override
  @JsonKey(name: 'image_url')
  final String imageUrl;
  @override
  @JsonKey(name: 'alt_text')
  final String altText;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @override
  String toString() {
    return 'HeroSlideDto(uuid: $uuid, imageUrl: $imageUrl, altText: $altText, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeroSlideDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.altText, altText) || other.altText == altText) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, uuid, imageUrl, altText, sortOrder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HeroSlideDtoImplCopyWith<_$HeroSlideDtoImpl> get copyWith =>
      __$$HeroSlideDtoImplCopyWithImpl<_$HeroSlideDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeroSlideDtoImplToJson(
      this,
    );
  }
}

abstract class _HeroSlideDto implements HeroSlideDto {
  const factory _HeroSlideDto(
      {final String uuid,
      @JsonKey(name: 'image_url') final String imageUrl,
      @JsonKey(name: 'alt_text') final String altText,
      @JsonKey(name: 'sort_order') final int sortOrder}) = _$HeroSlideDtoImpl;

  factory _HeroSlideDto.fromJson(Map<String, dynamic> json) =
      _$HeroSlideDtoImpl.fromJson;

  @override
  String get uuid;
  @override
  @JsonKey(name: 'image_url')
  String get imageUrl;
  @override
  @JsonKey(name: 'alt_text')
  String get altText;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(ignore: true)
  _$$HeroSlideDtoImplCopyWith<_$HeroSlideDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

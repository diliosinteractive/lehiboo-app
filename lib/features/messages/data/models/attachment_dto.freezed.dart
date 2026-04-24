// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AttachmentDto _$AttachmentDtoFromJson(Map<String, dynamic> json) {
  return _AttachmentDto.fromJson(json);
}

/// @nodoc
mixin _$AttachmentDto {
  String get uuid => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_name')
  String get originalName => throw _privateConstructorUsedError;
  @JsonKey(name: 'mime_type')
  String get mimeType => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_image')
  bool get isImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_pdf')
  bool get isPdf => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AttachmentDtoCopyWith<AttachmentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttachmentDtoCopyWith<$Res> {
  factory $AttachmentDtoCopyWith(
          AttachmentDto value, $Res Function(AttachmentDto) then) =
      _$AttachmentDtoCopyWithImpl<$Res, AttachmentDto>;
  @useResult
  $Res call(
      {String uuid,
      String url,
      @JsonKey(name: 'original_name') String originalName,
      @JsonKey(name: 'mime_type') String mimeType,
      int size,
      @JsonKey(name: 'is_image') bool isImage,
      @JsonKey(name: 'is_pdf') bool isPdf});
}

/// @nodoc
class _$AttachmentDtoCopyWithImpl<$Res, $Val extends AttachmentDto>
    implements $AttachmentDtoCopyWith<$Res> {
  _$AttachmentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? url = null,
    Object? originalName = null,
    Object? mimeType = null,
    Object? size = null,
    Object? isImage = null,
    Object? isPdf = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      originalName: null == originalName
          ? _value.originalName
          : originalName // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      isImage: null == isImage
          ? _value.isImage
          : isImage // ignore: cast_nullable_to_non_nullable
              as bool,
      isPdf: null == isPdf
          ? _value.isPdf
          : isPdf // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AttachmentDtoImplCopyWith<$Res>
    implements $AttachmentDtoCopyWith<$Res> {
  factory _$$AttachmentDtoImplCopyWith(
          _$AttachmentDtoImpl value, $Res Function(_$AttachmentDtoImpl) then) =
      __$$AttachmentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      String url,
      @JsonKey(name: 'original_name') String originalName,
      @JsonKey(name: 'mime_type') String mimeType,
      int size,
      @JsonKey(name: 'is_image') bool isImage,
      @JsonKey(name: 'is_pdf') bool isPdf});
}

/// @nodoc
class __$$AttachmentDtoImplCopyWithImpl<$Res>
    extends _$AttachmentDtoCopyWithImpl<$Res, _$AttachmentDtoImpl>
    implements _$$AttachmentDtoImplCopyWith<$Res> {
  __$$AttachmentDtoImplCopyWithImpl(
      _$AttachmentDtoImpl _value, $Res Function(_$AttachmentDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? url = null,
    Object? originalName = null,
    Object? mimeType = null,
    Object? size = null,
    Object? isImage = null,
    Object? isPdf = null,
  }) {
    return _then(_$AttachmentDtoImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      originalName: null == originalName
          ? _value.originalName
          : originalName // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      isImage: null == isImage
          ? _value.isImage
          : isImage // ignore: cast_nullable_to_non_nullable
              as bool,
      isPdf: null == isPdf
          ? _value.isPdf
          : isPdf // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttachmentDtoImpl implements _AttachmentDto {
  const _$AttachmentDtoImpl(
      {required this.uuid,
      required this.url,
      @JsonKey(name: 'original_name') required this.originalName,
      @JsonKey(name: 'mime_type') required this.mimeType,
      required this.size,
      @JsonKey(name: 'is_image') this.isImage = false,
      @JsonKey(name: 'is_pdf') this.isPdf = false});

  factory _$AttachmentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttachmentDtoImplFromJson(json);

  @override
  final String uuid;
  @override
  final String url;
  @override
  @JsonKey(name: 'original_name')
  final String originalName;
  @override
  @JsonKey(name: 'mime_type')
  final String mimeType;
  @override
  final int size;
  @override
  @JsonKey(name: 'is_image')
  final bool isImage;
  @override
  @JsonKey(name: 'is_pdf')
  final bool isPdf;

  @override
  String toString() {
    return 'AttachmentDto(uuid: $uuid, url: $url, originalName: $originalName, mimeType: $mimeType, size: $size, isImage: $isImage, isPdf: $isPdf)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttachmentDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.originalName, originalName) ||
                other.originalName == originalName) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.isImage, isImage) || other.isImage == isImage) &&
            (identical(other.isPdf, isPdf) || other.isPdf == isPdf));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, uuid, url, originalName, mimeType, size, isImage, isPdf);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AttachmentDtoImplCopyWith<_$AttachmentDtoImpl> get copyWith =>
      __$$AttachmentDtoImplCopyWithImpl<_$AttachmentDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttachmentDtoImplToJson(
      this,
    );
  }
}

abstract class _AttachmentDto implements AttachmentDto {
  const factory _AttachmentDto(
      {required final String uuid,
      required final String url,
      @JsonKey(name: 'original_name') required final String originalName,
      @JsonKey(name: 'mime_type') required final String mimeType,
      required final int size,
      @JsonKey(name: 'is_image') final bool isImage,
      @JsonKey(name: 'is_pdf') final bool isPdf}) = _$AttachmentDtoImpl;

  factory _AttachmentDto.fromJson(Map<String, dynamic> json) =
      _$AttachmentDtoImpl.fromJson;

  @override
  String get uuid;
  @override
  String get url;
  @override
  @JsonKey(name: 'original_name')
  String get originalName;
  @override
  @JsonKey(name: 'mime_type')
  String get mimeType;
  @override
  int get size;
  @override
  @JsonKey(name: 'is_image')
  bool get isImage;
  @override
  @JsonKey(name: 'is_pdf')
  bool get isPdf;
  @override
  @JsonKey(ignore: true)
  _$$AttachmentDtoImplCopyWith<_$AttachmentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

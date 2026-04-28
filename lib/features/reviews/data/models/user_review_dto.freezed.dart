// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_review_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserReviewsResponseDto _$UserReviewsResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _UserReviewsResponseDto.fromJson(json);
}

/// @nodoc
mixin _$UserReviewsResponseDto {
  List<UserReviewDto> get data => throw _privateConstructorUsedError;
  PaginationMetaDto? get meta => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserReviewsResponseDtoCopyWith<UserReviewsResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserReviewsResponseDtoCopyWith<$Res> {
  factory $UserReviewsResponseDtoCopyWith(UserReviewsResponseDto value,
          $Res Function(UserReviewsResponseDto) then) =
      _$UserReviewsResponseDtoCopyWithImpl<$Res, UserReviewsResponseDto>;
  @useResult
  $Res call({List<UserReviewDto> data, PaginationMetaDto? meta});

  $PaginationMetaDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class _$UserReviewsResponseDtoCopyWithImpl<$Res,
        $Val extends UserReviewsResponseDto>
    implements $UserReviewsResponseDtoCopyWith<$Res> {
  _$UserReviewsResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<UserReviewDto>,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as PaginationMetaDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PaginationMetaDtoCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $PaginationMetaDtoCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserReviewsResponseDtoImplCopyWith<$Res>
    implements $UserReviewsResponseDtoCopyWith<$Res> {
  factory _$$UserReviewsResponseDtoImplCopyWith(
          _$UserReviewsResponseDtoImpl value,
          $Res Function(_$UserReviewsResponseDtoImpl) then) =
      __$$UserReviewsResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<UserReviewDto> data, PaginationMetaDto? meta});

  @override
  $PaginationMetaDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class __$$UserReviewsResponseDtoImplCopyWithImpl<$Res>
    extends _$UserReviewsResponseDtoCopyWithImpl<$Res,
        _$UserReviewsResponseDtoImpl>
    implements _$$UserReviewsResponseDtoImplCopyWith<$Res> {
  __$$UserReviewsResponseDtoImplCopyWithImpl(
      _$UserReviewsResponseDtoImpl _value,
      $Res Function(_$UserReviewsResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_$UserReviewsResponseDtoImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<UserReviewDto>,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as PaginationMetaDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserReviewsResponseDtoImpl implements _UserReviewsResponseDto {
  const _$UserReviewsResponseDtoImpl(
      {final List<UserReviewDto> data = const [], this.meta})
      : _data = data;

  factory _$UserReviewsResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserReviewsResponseDtoImplFromJson(json);

  final List<UserReviewDto> _data;
  @override
  @JsonKey()
  List<UserReviewDto> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final PaginationMetaDto? meta;

  @override
  String toString() {
    return 'UserReviewsResponseDto(data: $data, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserReviewsResponseDtoImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.meta, meta) || other.meta == meta));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), meta);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserReviewsResponseDtoImplCopyWith<_$UserReviewsResponseDtoImpl>
      get copyWith => __$$UserReviewsResponseDtoImplCopyWithImpl<
          _$UserReviewsResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserReviewsResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _UserReviewsResponseDto implements UserReviewsResponseDto {
  const factory _UserReviewsResponseDto(
      {final List<UserReviewDto> data,
      final PaginationMetaDto? meta}) = _$UserReviewsResponseDtoImpl;

  factory _UserReviewsResponseDto.fromJson(Map<String, dynamic> json) =
      _$UserReviewsResponseDtoImpl.fromJson;

  @override
  List<UserReviewDto> get data;
  @override
  PaginationMetaDto? get meta;
  @override
  @JsonKey(ignore: true)
  _$$UserReviewsResponseDtoImplCopyWith<_$UserReviewsResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UserReviewDto _$UserReviewDtoFromJson(Map<String, dynamic> json) {
  return _UserReviewDto.fromJson(json);
}

/// @nodoc
mixin _$UserReviewDto {
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseInt)
  int get rating => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseStringOrNull)
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseString)
  String get comment => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseStringOrNull)
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'helpful_count', fromJson: parseInt)
  int get helpfulCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'helpfulCount', fromJson: parseInt)
  int get helpfulCountCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
  int get notHelpfulCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
  int get notHelpfulCountCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
  bool get isVerifiedPurchase => throw _privateConstructorUsedError;
  @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
  bool get isVerifiedPurchaseCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
  String? get createdAtCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at_formatted', fromJson: parseString)
  String get createdAtFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
  String get createdAtFormattedCamel => throw _privateConstructorUsedError;
  UserReviewEventDto? get event => throw _privateConstructorUsedError;
  ReviewResponseDto? get response => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_response', fromJson: parseBool)
  bool get hasResponse => throw _privateConstructorUsedError;
  @JsonKey(name: 'hasResponse', fromJson: parseBool)
  bool get hasResponseCamel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserReviewDtoCopyWith<UserReviewDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserReviewDtoCopyWith<$Res> {
  factory $UserReviewDtoCopyWith(
          UserReviewDto value, $Res Function(UserReviewDto) then) =
      _$UserReviewDtoCopyWithImpl<$Res, UserReviewDto>;
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(fromJson: parseInt) int rating,
      @JsonKey(fromJson: parseStringOrNull) String? title,
      @JsonKey(fromJson: parseString) String comment,
      @JsonKey(fromJson: parseStringOrNull) String? status,
      @JsonKey(name: 'helpful_count', fromJson: parseInt) int helpfulCount,
      @JsonKey(name: 'helpfulCount', fromJson: parseInt) int helpfulCountCamel,
      @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
      int notHelpfulCount,
      @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
      int notHelpfulCountCamel,
      @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
      bool isVerifiedPurchase,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
      bool isVerifiedPurchaseCamel,
      @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
      String? createdAt,
      @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
      String? createdAtCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
      String createdAtFormattedCamel,
      UserReviewEventDto? event,
      ReviewResponseDto? response,
      @JsonKey(name: 'has_response', fromJson: parseBool) bool hasResponse,
      @JsonKey(name: 'hasResponse', fromJson: parseBool)
      bool hasResponseCamel});

  $UserReviewEventDtoCopyWith<$Res>? get event;
  $ReviewResponseDtoCopyWith<$Res>? get response;
}

/// @nodoc
class _$UserReviewDtoCopyWithImpl<$Res, $Val extends UserReviewDto>
    implements $UserReviewDtoCopyWith<$Res> {
  _$UserReviewDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? rating = null,
    Object? title = freezed,
    Object? comment = null,
    Object? status = freezed,
    Object? helpfulCount = null,
    Object? helpfulCountCamel = null,
    Object? notHelpfulCount = null,
    Object? notHelpfulCountCamel = null,
    Object? isVerifiedPurchase = null,
    Object? isVerifiedPurchaseCamel = null,
    Object? createdAt = freezed,
    Object? createdAtCamel = freezed,
    Object? createdAtFormatted = null,
    Object? createdAtFormattedCamel = null,
    Object? event = freezed,
    Object? response = freezed,
    Object? hasResponse = null,
    Object? hasResponseCamel = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      helpfulCountCamel: null == helpfulCountCamel
          ? _value.helpfulCountCamel
          : helpfulCountCamel // ignore: cast_nullable_to_non_nullable
              as int,
      notHelpfulCount: null == notHelpfulCount
          ? _value.notHelpfulCount
          : notHelpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      notHelpfulCountCamel: null == notHelpfulCountCamel
          ? _value.notHelpfulCountCamel
          : notHelpfulCountCamel // ignore: cast_nullable_to_non_nullable
              as int,
      isVerifiedPurchase: null == isVerifiedPurchase
          ? _value.isVerifiedPurchase
          : isVerifiedPurchase // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerifiedPurchaseCamel: null == isVerifiedPurchaseCamel
          ? _value.isVerifiedPurchaseCamel
          : isVerifiedPurchaseCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAtCamel: freezed == createdAtCamel
          ? _value.createdAtCamel
          : createdAtCamel // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAtFormatted: null == createdAtFormatted
          ? _value.createdAtFormatted
          : createdAtFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormattedCamel: null == createdAtFormattedCamel
          ? _value.createdAtFormattedCamel
          : createdAtFormattedCamel // ignore: cast_nullable_to_non_nullable
              as String,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as UserReviewEventDto?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as ReviewResponseDto?,
      hasResponse: null == hasResponse
          ? _value.hasResponse
          : hasResponse // ignore: cast_nullable_to_non_nullable
              as bool,
      hasResponseCamel: null == hasResponseCamel
          ? _value.hasResponseCamel
          : hasResponseCamel // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserReviewEventDtoCopyWith<$Res>? get event {
    if (_value.event == null) {
      return null;
    }

    return $UserReviewEventDtoCopyWith<$Res>(_value.event!, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ReviewResponseDtoCopyWith<$Res>? get response {
    if (_value.response == null) {
      return null;
    }

    return $ReviewResponseDtoCopyWith<$Res>(_value.response!, (value) {
      return _then(_value.copyWith(response: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserReviewDtoImplCopyWith<$Res>
    implements $UserReviewDtoCopyWith<$Res> {
  factory _$$UserReviewDtoImplCopyWith(
          _$UserReviewDtoImpl value, $Res Function(_$UserReviewDtoImpl) then) =
      __$$UserReviewDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(fromJson: parseInt) int rating,
      @JsonKey(fromJson: parseStringOrNull) String? title,
      @JsonKey(fromJson: parseString) String comment,
      @JsonKey(fromJson: parseStringOrNull) String? status,
      @JsonKey(name: 'helpful_count', fromJson: parseInt) int helpfulCount,
      @JsonKey(name: 'helpfulCount', fromJson: parseInt) int helpfulCountCamel,
      @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
      int notHelpfulCount,
      @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
      int notHelpfulCountCamel,
      @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
      bool isVerifiedPurchase,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
      bool isVerifiedPurchaseCamel,
      @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
      String? createdAt,
      @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
      String? createdAtCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
      String createdAtFormattedCamel,
      UserReviewEventDto? event,
      ReviewResponseDto? response,
      @JsonKey(name: 'has_response', fromJson: parseBool) bool hasResponse,
      @JsonKey(name: 'hasResponse', fromJson: parseBool)
      bool hasResponseCamel});

  @override
  $UserReviewEventDtoCopyWith<$Res>? get event;
  @override
  $ReviewResponseDtoCopyWith<$Res>? get response;
}

/// @nodoc
class __$$UserReviewDtoImplCopyWithImpl<$Res>
    extends _$UserReviewDtoCopyWithImpl<$Res, _$UserReviewDtoImpl>
    implements _$$UserReviewDtoImplCopyWith<$Res> {
  __$$UserReviewDtoImplCopyWithImpl(
      _$UserReviewDtoImpl _value, $Res Function(_$UserReviewDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? rating = null,
    Object? title = freezed,
    Object? comment = null,
    Object? status = freezed,
    Object? helpfulCount = null,
    Object? helpfulCountCamel = null,
    Object? notHelpfulCount = null,
    Object? notHelpfulCountCamel = null,
    Object? isVerifiedPurchase = null,
    Object? isVerifiedPurchaseCamel = null,
    Object? createdAt = freezed,
    Object? createdAtCamel = freezed,
    Object? createdAtFormatted = null,
    Object? createdAtFormattedCamel = null,
    Object? event = freezed,
    Object? response = freezed,
    Object? hasResponse = null,
    Object? hasResponseCamel = null,
  }) {
    return _then(_$UserReviewDtoImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      helpfulCountCamel: null == helpfulCountCamel
          ? _value.helpfulCountCamel
          : helpfulCountCamel // ignore: cast_nullable_to_non_nullable
              as int,
      notHelpfulCount: null == notHelpfulCount
          ? _value.notHelpfulCount
          : notHelpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      notHelpfulCountCamel: null == notHelpfulCountCamel
          ? _value.notHelpfulCountCamel
          : notHelpfulCountCamel // ignore: cast_nullable_to_non_nullable
              as int,
      isVerifiedPurchase: null == isVerifiedPurchase
          ? _value.isVerifiedPurchase
          : isVerifiedPurchase // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerifiedPurchaseCamel: null == isVerifiedPurchaseCamel
          ? _value.isVerifiedPurchaseCamel
          : isVerifiedPurchaseCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAtCamel: freezed == createdAtCamel
          ? _value.createdAtCamel
          : createdAtCamel // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAtFormatted: null == createdAtFormatted
          ? _value.createdAtFormatted
          : createdAtFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormattedCamel: null == createdAtFormattedCamel
          ? _value.createdAtFormattedCamel
          : createdAtFormattedCamel // ignore: cast_nullable_to_non_nullable
              as String,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as UserReviewEventDto?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as ReviewResponseDto?,
      hasResponse: null == hasResponse
          ? _value.hasResponse
          : hasResponse // ignore: cast_nullable_to_non_nullable
              as bool,
      hasResponseCamel: null == hasResponseCamel
          ? _value.hasResponseCamel
          : hasResponseCamel // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserReviewDtoImpl implements _UserReviewDto {
  const _$UserReviewDtoImpl(
      {required this.uuid,
      @JsonKey(fromJson: parseInt) this.rating = 0,
      @JsonKey(fromJson: parseStringOrNull) this.title,
      @JsonKey(fromJson: parseString) this.comment = '',
      @JsonKey(fromJson: parseStringOrNull) this.status,
      @JsonKey(name: 'helpful_count', fromJson: parseInt) this.helpfulCount = 0,
      @JsonKey(name: 'helpfulCount', fromJson: parseInt)
      this.helpfulCountCamel = 0,
      @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
      this.notHelpfulCount = 0,
      @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
      this.notHelpfulCountCamel = 0,
      @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
      this.isVerifiedPurchase = false,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
      this.isVerifiedPurchaseCamel = false,
      @JsonKey(name: 'created_at', fromJson: parseStringOrNull) this.createdAt,
      @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
      this.createdAtCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: parseString)
      this.createdAtFormatted = '',
      @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
      this.createdAtFormattedCamel = '',
      this.event,
      this.response,
      @JsonKey(name: 'has_response', fromJson: parseBool)
      this.hasResponse = false,
      @JsonKey(name: 'hasResponse', fromJson: parseBool)
      this.hasResponseCamel = false});

  factory _$UserReviewDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserReviewDtoImplFromJson(json);

  @override
  final String uuid;
  @override
  @JsonKey(fromJson: parseInt)
  final int rating;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  final String? title;
  @override
  @JsonKey(fromJson: parseString)
  final String comment;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  final String? status;
  @override
  @JsonKey(name: 'helpful_count', fromJson: parseInt)
  final int helpfulCount;
  @override
  @JsonKey(name: 'helpfulCount', fromJson: parseInt)
  final int helpfulCountCamel;
  @override
  @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
  final int notHelpfulCount;
  @override
  @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
  final int notHelpfulCountCamel;
  @override
  @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
  final bool isVerifiedPurchase;
  @override
  @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
  final bool isVerifiedPurchaseCamel;
  @override
  @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
  final String? createdAt;
  @override
  @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
  final String? createdAtCamel;
  @override
  @JsonKey(name: 'created_at_formatted', fromJson: parseString)
  final String createdAtFormatted;
  @override
  @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
  final String createdAtFormattedCamel;
  @override
  final UserReviewEventDto? event;
  @override
  final ReviewResponseDto? response;
  @override
  @JsonKey(name: 'has_response', fromJson: parseBool)
  final bool hasResponse;
  @override
  @JsonKey(name: 'hasResponse', fromJson: parseBool)
  final bool hasResponseCamel;

  @override
  String toString() {
    return 'UserReviewDto(uuid: $uuid, rating: $rating, title: $title, comment: $comment, status: $status, helpfulCount: $helpfulCount, helpfulCountCamel: $helpfulCountCamel, notHelpfulCount: $notHelpfulCount, notHelpfulCountCamel: $notHelpfulCountCamel, isVerifiedPurchase: $isVerifiedPurchase, isVerifiedPurchaseCamel: $isVerifiedPurchaseCamel, createdAt: $createdAt, createdAtCamel: $createdAtCamel, createdAtFormatted: $createdAtFormatted, createdAtFormattedCamel: $createdAtFormattedCamel, event: $event, response: $response, hasResponse: $hasResponse, hasResponseCamel: $hasResponseCamel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserReviewDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.helpfulCount, helpfulCount) ||
                other.helpfulCount == helpfulCount) &&
            (identical(other.helpfulCountCamel, helpfulCountCamel) ||
                other.helpfulCountCamel == helpfulCountCamel) &&
            (identical(other.notHelpfulCount, notHelpfulCount) ||
                other.notHelpfulCount == notHelpfulCount) &&
            (identical(other.notHelpfulCountCamel, notHelpfulCountCamel) ||
                other.notHelpfulCountCamel == notHelpfulCountCamel) &&
            (identical(other.isVerifiedPurchase, isVerifiedPurchase) ||
                other.isVerifiedPurchase == isVerifiedPurchase) &&
            (identical(
                    other.isVerifiedPurchaseCamel, isVerifiedPurchaseCamel) ||
                other.isVerifiedPurchaseCamel == isVerifiedPurchaseCamel) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdAtCamel, createdAtCamel) ||
                other.createdAtCamel == createdAtCamel) &&
            (identical(other.createdAtFormatted, createdAtFormatted) ||
                other.createdAtFormatted == createdAtFormatted) &&
            (identical(
                    other.createdAtFormattedCamel, createdAtFormattedCamel) ||
                other.createdAtFormattedCamel == createdAtFormattedCamel) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.hasResponse, hasResponse) ||
                other.hasResponse == hasResponse) &&
            (identical(other.hasResponseCamel, hasResponseCamel) ||
                other.hasResponseCamel == hasResponseCamel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        uuid,
        rating,
        title,
        comment,
        status,
        helpfulCount,
        helpfulCountCamel,
        notHelpfulCount,
        notHelpfulCountCamel,
        isVerifiedPurchase,
        isVerifiedPurchaseCamel,
        createdAt,
        createdAtCamel,
        createdAtFormatted,
        createdAtFormattedCamel,
        event,
        response,
        hasResponse,
        hasResponseCamel
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserReviewDtoImplCopyWith<_$UserReviewDtoImpl> get copyWith =>
      __$$UserReviewDtoImplCopyWithImpl<_$UserReviewDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserReviewDtoImplToJson(
      this,
    );
  }
}

abstract class _UserReviewDto implements UserReviewDto {
  const factory _UserReviewDto(
      {required final String uuid,
      @JsonKey(fromJson: parseInt) final int rating,
      @JsonKey(fromJson: parseStringOrNull) final String? title,
      @JsonKey(fromJson: parseString) final String comment,
      @JsonKey(fromJson: parseStringOrNull) final String? status,
      @JsonKey(name: 'helpful_count', fromJson: parseInt)
      final int helpfulCount,
      @JsonKey(name: 'helpfulCount', fromJson: parseInt)
      final int helpfulCountCamel,
      @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
      final int notHelpfulCount,
      @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
      final int notHelpfulCountCamel,
      @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
      final bool isVerifiedPurchase,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
      final bool isVerifiedPurchaseCamel,
      @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
      final String? createdAt,
      @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
      final String? createdAtCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: parseString)
      final String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
      final String createdAtFormattedCamel,
      final UserReviewEventDto? event,
      final ReviewResponseDto? response,
      @JsonKey(name: 'has_response', fromJson: parseBool)
      final bool hasResponse,
      @JsonKey(name: 'hasResponse', fromJson: parseBool)
      final bool hasResponseCamel}) = _$UserReviewDtoImpl;

  factory _UserReviewDto.fromJson(Map<String, dynamic> json) =
      _$UserReviewDtoImpl.fromJson;

  @override
  String get uuid;
  @override
  @JsonKey(fromJson: parseInt)
  int get rating;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  String? get title;
  @override
  @JsonKey(fromJson: parseString)
  String get comment;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  String? get status;
  @override
  @JsonKey(name: 'helpful_count', fromJson: parseInt)
  int get helpfulCount;
  @override
  @JsonKey(name: 'helpfulCount', fromJson: parseInt)
  int get helpfulCountCamel;
  @override
  @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
  int get notHelpfulCount;
  @override
  @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
  int get notHelpfulCountCamel;
  @override
  @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
  bool get isVerifiedPurchase;
  @override
  @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
  bool get isVerifiedPurchaseCamel;
  @override
  @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
  String? get createdAt;
  @override
  @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
  String? get createdAtCamel;
  @override
  @JsonKey(name: 'created_at_formatted', fromJson: parseString)
  String get createdAtFormatted;
  @override
  @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
  String get createdAtFormattedCamel;
  @override
  UserReviewEventDto? get event;
  @override
  ReviewResponseDto? get response;
  @override
  @JsonKey(name: 'has_response', fromJson: parseBool)
  bool get hasResponse;
  @override
  @JsonKey(name: 'hasResponse', fromJson: parseBool)
  bool get hasResponseCamel;
  @override
  @JsonKey(ignore: true)
  _$$UserReviewDtoImplCopyWith<_$UserReviewDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserReviewEventDto _$UserReviewEventDtoFromJson(Map<String, dynamic> json) {
  return _UserReviewEventDto.fromJson(json);
}

/// @nodoc
mixin _$UserReviewEventDto {
  @JsonKey(fromJson: parseStringOrNull)
  String? get uuid => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseString)
  String get title => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseString)
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_image', fromJson: parseStringOrNull)
  String? get coverImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'coverImage', fromJson: parseStringOrNull)
  String? get coverImageCamel => throw _privateConstructorUsedError;
  UserReviewEventOrgDto? get organization => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserReviewEventDtoCopyWith<UserReviewEventDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserReviewEventDtoCopyWith<$Res> {
  factory $UserReviewEventDtoCopyWith(
          UserReviewEventDto value, $Res Function(UserReviewEventDto) then) =
      _$UserReviewEventDtoCopyWithImpl<$Res, UserReviewEventDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: parseStringOrNull) String? uuid,
      @JsonKey(fromJson: parseString) String title,
      @JsonKey(fromJson: parseString) String slug,
      @JsonKey(name: 'cover_image', fromJson: parseStringOrNull)
      String? coverImage,
      @JsonKey(name: 'coverImage', fromJson: parseStringOrNull)
      String? coverImageCamel,
      UserReviewEventOrgDto? organization});

  $UserReviewEventOrgDtoCopyWith<$Res>? get organization;
}

/// @nodoc
class _$UserReviewEventDtoCopyWithImpl<$Res, $Val extends UserReviewEventDto>
    implements $UserReviewEventDtoCopyWith<$Res> {
  _$UserReviewEventDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? title = null,
    Object? slug = null,
    Object? coverImage = freezed,
    Object? coverImageCamel = freezed,
    Object? organization = freezed,
  }) {
    return _then(_value.copyWith(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImageCamel: freezed == coverImageCamel
          ? _value.coverImageCamel
          : coverImageCamel // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as UserReviewEventOrgDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserReviewEventOrgDtoCopyWith<$Res>? get organization {
    if (_value.organization == null) {
      return null;
    }

    return $UserReviewEventOrgDtoCopyWith<$Res>(_value.organization!, (value) {
      return _then(_value.copyWith(organization: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserReviewEventDtoImplCopyWith<$Res>
    implements $UserReviewEventDtoCopyWith<$Res> {
  factory _$$UserReviewEventDtoImplCopyWith(_$UserReviewEventDtoImpl value,
          $Res Function(_$UserReviewEventDtoImpl) then) =
      __$$UserReviewEventDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: parseStringOrNull) String? uuid,
      @JsonKey(fromJson: parseString) String title,
      @JsonKey(fromJson: parseString) String slug,
      @JsonKey(name: 'cover_image', fromJson: parseStringOrNull)
      String? coverImage,
      @JsonKey(name: 'coverImage', fromJson: parseStringOrNull)
      String? coverImageCamel,
      UserReviewEventOrgDto? organization});

  @override
  $UserReviewEventOrgDtoCopyWith<$Res>? get organization;
}

/// @nodoc
class __$$UserReviewEventDtoImplCopyWithImpl<$Res>
    extends _$UserReviewEventDtoCopyWithImpl<$Res, _$UserReviewEventDtoImpl>
    implements _$$UserReviewEventDtoImplCopyWith<$Res> {
  __$$UserReviewEventDtoImplCopyWithImpl(_$UserReviewEventDtoImpl _value,
      $Res Function(_$UserReviewEventDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? title = null,
    Object? slug = null,
    Object? coverImage = freezed,
    Object? coverImageCamel = freezed,
    Object? organization = freezed,
  }) {
    return _then(_$UserReviewEventDtoImpl(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      coverImage: freezed == coverImage
          ? _value.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImageCamel: freezed == coverImageCamel
          ? _value.coverImageCamel
          : coverImageCamel // ignore: cast_nullable_to_non_nullable
              as String?,
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as UserReviewEventOrgDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserReviewEventDtoImpl implements _UserReviewEventDto {
  const _$UserReviewEventDtoImpl(
      {@JsonKey(fromJson: parseStringOrNull) this.uuid,
      @JsonKey(fromJson: parseString) this.title = '',
      @JsonKey(fromJson: parseString) this.slug = '',
      @JsonKey(name: 'cover_image', fromJson: parseStringOrNull)
      this.coverImage,
      @JsonKey(name: 'coverImage', fromJson: parseStringOrNull)
      this.coverImageCamel,
      this.organization});

  factory _$UserReviewEventDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserReviewEventDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: parseStringOrNull)
  final String? uuid;
  @override
  @JsonKey(fromJson: parseString)
  final String title;
  @override
  @JsonKey(fromJson: parseString)
  final String slug;
  @override
  @JsonKey(name: 'cover_image', fromJson: parseStringOrNull)
  final String? coverImage;
  @override
  @JsonKey(name: 'coverImage', fromJson: parseStringOrNull)
  final String? coverImageCamel;
  @override
  final UserReviewEventOrgDto? organization;

  @override
  String toString() {
    return 'UserReviewEventDto(uuid: $uuid, title: $title, slug: $slug, coverImage: $coverImage, coverImageCamel: $coverImageCamel, organization: $organization)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserReviewEventDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage) &&
            (identical(other.coverImageCamel, coverImageCamel) ||
                other.coverImageCamel == coverImageCamel) &&
            (identical(other.organization, organization) ||
                other.organization == organization));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, title, slug, coverImage,
      coverImageCamel, organization);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserReviewEventDtoImplCopyWith<_$UserReviewEventDtoImpl> get copyWith =>
      __$$UserReviewEventDtoImplCopyWithImpl<_$UserReviewEventDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserReviewEventDtoImplToJson(
      this,
    );
  }
}

abstract class _UserReviewEventDto implements UserReviewEventDto {
  const factory _UserReviewEventDto(
      {@JsonKey(fromJson: parseStringOrNull) final String? uuid,
      @JsonKey(fromJson: parseString) final String title,
      @JsonKey(fromJson: parseString) final String slug,
      @JsonKey(name: 'cover_image', fromJson: parseStringOrNull)
      final String? coverImage,
      @JsonKey(name: 'coverImage', fromJson: parseStringOrNull)
      final String? coverImageCamel,
      final UserReviewEventOrgDto? organization}) = _$UserReviewEventDtoImpl;

  factory _UserReviewEventDto.fromJson(Map<String, dynamic> json) =
      _$UserReviewEventDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: parseStringOrNull)
  String? get uuid;
  @override
  @JsonKey(fromJson: parseString)
  String get title;
  @override
  @JsonKey(fromJson: parseString)
  String get slug;
  @override
  @JsonKey(name: 'cover_image', fromJson: parseStringOrNull)
  String? get coverImage;
  @override
  @JsonKey(name: 'coverImage', fromJson: parseStringOrNull)
  String? get coverImageCamel;
  @override
  UserReviewEventOrgDto? get organization;
  @override
  @JsonKey(ignore: true)
  _$$UserReviewEventDtoImplCopyWith<_$UserReviewEventDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserReviewEventOrgDto _$UserReviewEventOrgDtoFromJson(
    Map<String, dynamic> json) {
  return _UserReviewEventOrgDto.fromJson(json);
}

/// @nodoc
mixin _$UserReviewEventOrgDto {
  @JsonKey(name: 'organization_name', fromJson: parseStringOrNull)
  String? get organizationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name', fromJson: parseStringOrNull)
  String? get companyName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseStringOrNull)
  String? get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserReviewEventOrgDtoCopyWith<UserReviewEventOrgDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserReviewEventOrgDtoCopyWith<$Res> {
  factory $UserReviewEventOrgDtoCopyWith(UserReviewEventOrgDto value,
          $Res Function(UserReviewEventOrgDto) then) =
      _$UserReviewEventOrgDtoCopyWithImpl<$Res, UserReviewEventOrgDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_name', fromJson: parseStringOrNull)
      String? organizationName,
      @JsonKey(name: 'company_name', fromJson: parseStringOrNull)
      String? companyName,
      @JsonKey(fromJson: parseStringOrNull) String? name});
}

/// @nodoc
class _$UserReviewEventOrgDtoCopyWithImpl<$Res,
        $Val extends UserReviewEventOrgDto>
    implements $UserReviewEventOrgDtoCopyWith<$Res> {
  _$UserReviewEventOrgDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationName = freezed,
    Object? companyName = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserReviewEventOrgDtoImplCopyWith<$Res>
    implements $UserReviewEventOrgDtoCopyWith<$Res> {
  factory _$$UserReviewEventOrgDtoImplCopyWith(
          _$UserReviewEventOrgDtoImpl value,
          $Res Function(_$UserReviewEventOrgDtoImpl) then) =
      __$$UserReviewEventOrgDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'organization_name', fromJson: parseStringOrNull)
      String? organizationName,
      @JsonKey(name: 'company_name', fromJson: parseStringOrNull)
      String? companyName,
      @JsonKey(fromJson: parseStringOrNull) String? name});
}

/// @nodoc
class __$$UserReviewEventOrgDtoImplCopyWithImpl<$Res>
    extends _$UserReviewEventOrgDtoCopyWithImpl<$Res,
        _$UserReviewEventOrgDtoImpl>
    implements _$$UserReviewEventOrgDtoImplCopyWith<$Res> {
  __$$UserReviewEventOrgDtoImplCopyWithImpl(_$UserReviewEventOrgDtoImpl _value,
      $Res Function(_$UserReviewEventOrgDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? organizationName = freezed,
    Object? companyName = freezed,
    Object? name = freezed,
  }) {
    return _then(_$UserReviewEventOrgDtoImpl(
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserReviewEventOrgDtoImpl implements _UserReviewEventOrgDto {
  const _$UserReviewEventOrgDtoImpl(
      {@JsonKey(name: 'organization_name', fromJson: parseStringOrNull)
      this.organizationName,
      @JsonKey(name: 'company_name', fromJson: parseStringOrNull)
      this.companyName,
      @JsonKey(fromJson: parseStringOrNull) this.name});

  factory _$UserReviewEventOrgDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserReviewEventOrgDtoImplFromJson(json);

  @override
  @JsonKey(name: 'organization_name', fromJson: parseStringOrNull)
  final String? organizationName;
  @override
  @JsonKey(name: 'company_name', fromJson: parseStringOrNull)
  final String? companyName;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  final String? name;

  @override
  String toString() {
    return 'UserReviewEventOrgDto(organizationName: $organizationName, companyName: $companyName, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserReviewEventOrgDtoImpl &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, organizationName, companyName, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserReviewEventOrgDtoImplCopyWith<_$UserReviewEventOrgDtoImpl>
      get copyWith => __$$UserReviewEventOrgDtoImplCopyWithImpl<
          _$UserReviewEventOrgDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserReviewEventOrgDtoImplToJson(
      this,
    );
  }
}

abstract class _UserReviewEventOrgDto implements UserReviewEventOrgDto {
  const factory _UserReviewEventOrgDto(
          {@JsonKey(name: 'organization_name', fromJson: parseStringOrNull)
          final String? organizationName,
          @JsonKey(name: 'company_name', fromJson: parseStringOrNull)
          final String? companyName,
          @JsonKey(fromJson: parseStringOrNull) final String? name}) =
      _$UserReviewEventOrgDtoImpl;

  factory _UserReviewEventOrgDto.fromJson(Map<String, dynamic> json) =
      _$UserReviewEventOrgDtoImpl.fromJson;

  @override
  @JsonKey(name: 'organization_name', fromJson: parseStringOrNull)
  String? get organizationName;
  @override
  @JsonKey(name: 'company_name', fromJson: parseStringOrNull)
  String? get companyName;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$UserReviewEventOrgDtoImplCopyWith<_$UserReviewEventOrgDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

VoteCountsDto _$VoteCountsDtoFromJson(Map<String, dynamic> json) {
  return _VoteCountsDto.fromJson(json);
}

/// @nodoc
mixin _$VoteCountsDto {
  @JsonKey(name: 'helpful_count', fromJson: parseInt)
  int get helpfulCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'helpfulCount', fromJson: parseInt)
  int get helpfulCountCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
  int get notHelpfulCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
  int get notHelpfulCountCamel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $VoteCountsDtoCopyWith<VoteCountsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoteCountsDtoCopyWith<$Res> {
  factory $VoteCountsDtoCopyWith(
          VoteCountsDto value, $Res Function(VoteCountsDto) then) =
      _$VoteCountsDtoCopyWithImpl<$Res, VoteCountsDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'helpful_count', fromJson: parseInt) int helpfulCount,
      @JsonKey(name: 'helpfulCount', fromJson: parseInt) int helpfulCountCamel,
      @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
      int notHelpfulCount,
      @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
      int notHelpfulCountCamel});
}

/// @nodoc
class _$VoteCountsDtoCopyWithImpl<$Res, $Val extends VoteCountsDto>
    implements $VoteCountsDtoCopyWith<$Res> {
  _$VoteCountsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? helpfulCount = null,
    Object? helpfulCountCamel = null,
    Object? notHelpfulCount = null,
    Object? notHelpfulCountCamel = null,
  }) {
    return _then(_value.copyWith(
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      helpfulCountCamel: null == helpfulCountCamel
          ? _value.helpfulCountCamel
          : helpfulCountCamel // ignore: cast_nullable_to_non_nullable
              as int,
      notHelpfulCount: null == notHelpfulCount
          ? _value.notHelpfulCount
          : notHelpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      notHelpfulCountCamel: null == notHelpfulCountCamel
          ? _value.notHelpfulCountCamel
          : notHelpfulCountCamel // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VoteCountsDtoImplCopyWith<$Res>
    implements $VoteCountsDtoCopyWith<$Res> {
  factory _$$VoteCountsDtoImplCopyWith(
          _$VoteCountsDtoImpl value, $Res Function(_$VoteCountsDtoImpl) then) =
      __$$VoteCountsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'helpful_count', fromJson: parseInt) int helpfulCount,
      @JsonKey(name: 'helpfulCount', fromJson: parseInt) int helpfulCountCamel,
      @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
      int notHelpfulCount,
      @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
      int notHelpfulCountCamel});
}

/// @nodoc
class __$$VoteCountsDtoImplCopyWithImpl<$Res>
    extends _$VoteCountsDtoCopyWithImpl<$Res, _$VoteCountsDtoImpl>
    implements _$$VoteCountsDtoImplCopyWith<$Res> {
  __$$VoteCountsDtoImplCopyWithImpl(
      _$VoteCountsDtoImpl _value, $Res Function(_$VoteCountsDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? helpfulCount = null,
    Object? helpfulCountCamel = null,
    Object? notHelpfulCount = null,
    Object? notHelpfulCountCamel = null,
  }) {
    return _then(_$VoteCountsDtoImpl(
      helpfulCount: null == helpfulCount
          ? _value.helpfulCount
          : helpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      helpfulCountCamel: null == helpfulCountCamel
          ? _value.helpfulCountCamel
          : helpfulCountCamel // ignore: cast_nullable_to_non_nullable
              as int,
      notHelpfulCount: null == notHelpfulCount
          ? _value.notHelpfulCount
          : notHelpfulCount // ignore: cast_nullable_to_non_nullable
              as int,
      notHelpfulCountCamel: null == notHelpfulCountCamel
          ? _value.notHelpfulCountCamel
          : notHelpfulCountCamel // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VoteCountsDtoImpl implements _VoteCountsDto {
  const _$VoteCountsDtoImpl(
      {@JsonKey(name: 'helpful_count', fromJson: parseInt)
      this.helpfulCount = 0,
      @JsonKey(name: 'helpfulCount', fromJson: parseInt)
      this.helpfulCountCamel = 0,
      @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
      this.notHelpfulCount = 0,
      @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
      this.notHelpfulCountCamel = 0});

  factory _$VoteCountsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoteCountsDtoImplFromJson(json);

  @override
  @JsonKey(name: 'helpful_count', fromJson: parseInt)
  final int helpfulCount;
  @override
  @JsonKey(name: 'helpfulCount', fromJson: parseInt)
  final int helpfulCountCamel;
  @override
  @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
  final int notHelpfulCount;
  @override
  @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
  final int notHelpfulCountCamel;

  @override
  String toString() {
    return 'VoteCountsDto(helpfulCount: $helpfulCount, helpfulCountCamel: $helpfulCountCamel, notHelpfulCount: $notHelpfulCount, notHelpfulCountCamel: $notHelpfulCountCamel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoteCountsDtoImpl &&
            (identical(other.helpfulCount, helpfulCount) ||
                other.helpfulCount == helpfulCount) &&
            (identical(other.helpfulCountCamel, helpfulCountCamel) ||
                other.helpfulCountCamel == helpfulCountCamel) &&
            (identical(other.notHelpfulCount, notHelpfulCount) ||
                other.notHelpfulCount == notHelpfulCount) &&
            (identical(other.notHelpfulCountCamel, notHelpfulCountCamel) ||
                other.notHelpfulCountCamel == notHelpfulCountCamel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, helpfulCount, helpfulCountCamel,
      notHelpfulCount, notHelpfulCountCamel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$VoteCountsDtoImplCopyWith<_$VoteCountsDtoImpl> get copyWith =>
      __$$VoteCountsDtoImplCopyWithImpl<_$VoteCountsDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VoteCountsDtoImplToJson(
      this,
    );
  }
}

abstract class _VoteCountsDto implements VoteCountsDto {
  const factory _VoteCountsDto(
      {@JsonKey(name: 'helpful_count', fromJson: parseInt)
      final int helpfulCount,
      @JsonKey(name: 'helpfulCount', fromJson: parseInt)
      final int helpfulCountCamel,
      @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
      final int notHelpfulCount,
      @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
      final int notHelpfulCountCamel}) = _$VoteCountsDtoImpl;

  factory _VoteCountsDto.fromJson(Map<String, dynamic> json) =
      _$VoteCountsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'helpful_count', fromJson: parseInt)
  int get helpfulCount;
  @override
  @JsonKey(name: 'helpfulCount', fromJson: parseInt)
  int get helpfulCountCamel;
  @override
  @JsonKey(name: 'not_helpful_count', fromJson: parseInt)
  int get notHelpfulCount;
  @override
  @JsonKey(name: 'notHelpfulCount', fromJson: parseInt)
  int get notHelpfulCountCamel;
  @override
  @JsonKey(ignore: true)
  _$$VoteCountsDtoImplCopyWith<_$VoteCountsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

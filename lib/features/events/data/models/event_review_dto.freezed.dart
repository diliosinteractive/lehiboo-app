// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_review_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventReviewsResponseDto _$EventReviewsResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _EventReviewsResponseDto.fromJson(json);
}

/// @nodoc
mixin _$EventReviewsResponseDto {
  List<EventReviewDto> get data => throw _privateConstructorUsedError;
  MetaDto? get meta => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventReviewsResponseDtoCopyWith<EventReviewsResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventReviewsResponseDtoCopyWith<$Res> {
  factory $EventReviewsResponseDtoCopyWith(EventReviewsResponseDto value,
          $Res Function(EventReviewsResponseDto) then) =
      _$EventReviewsResponseDtoCopyWithImpl<$Res, EventReviewsResponseDto>;
  @useResult
  $Res call({List<EventReviewDto> data, MetaDto? meta});

  $MetaDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class _$EventReviewsResponseDtoCopyWithImpl<$Res,
        $Val extends EventReviewsResponseDto>
    implements $EventReviewsResponseDtoCopyWith<$Res> {
  _$EventReviewsResponseDtoCopyWithImpl(this._value, this._then);

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
              as List<EventReviewDto>,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MetaDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MetaDtoCopyWith<$Res>? get meta {
    if (_value.meta == null) {
      return null;
    }

    return $MetaDtoCopyWith<$Res>(_value.meta!, (value) {
      return _then(_value.copyWith(meta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventReviewsResponseDtoImplCopyWith<$Res>
    implements $EventReviewsResponseDtoCopyWith<$Res> {
  factory _$$EventReviewsResponseDtoImplCopyWith(
          _$EventReviewsResponseDtoImpl value,
          $Res Function(_$EventReviewsResponseDtoImpl) then) =
      __$$EventReviewsResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<EventReviewDto> data, MetaDto? meta});

  @override
  $MetaDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class __$$EventReviewsResponseDtoImplCopyWithImpl<$Res>
    extends _$EventReviewsResponseDtoCopyWithImpl<$Res,
        _$EventReviewsResponseDtoImpl>
    implements _$$EventReviewsResponseDtoImplCopyWith<$Res> {
  __$$EventReviewsResponseDtoImplCopyWithImpl(
      _$EventReviewsResponseDtoImpl _value,
      $Res Function(_$EventReviewsResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_$EventReviewsResponseDtoImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<EventReviewDto>,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as MetaDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventReviewsResponseDtoImpl implements _EventReviewsResponseDto {
  const _$EventReviewsResponseDtoImpl(
      {final List<EventReviewDto> data = const [], this.meta})
      : _data = data;

  factory _$EventReviewsResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventReviewsResponseDtoImplFromJson(json);

  final List<EventReviewDto> _data;
  @override
  @JsonKey()
  List<EventReviewDto> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final MetaDto? meta;

  @override
  String toString() {
    return 'EventReviewsResponseDto(data: $data, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventReviewsResponseDtoImpl &&
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
  _$$EventReviewsResponseDtoImplCopyWith<_$EventReviewsResponseDtoImpl>
      get copyWith => __$$EventReviewsResponseDtoImplCopyWithImpl<
          _$EventReviewsResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventReviewsResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _EventReviewsResponseDto implements EventReviewsResponseDto {
  const factory _EventReviewsResponseDto(
      {final List<EventReviewDto> data,
      final MetaDto? meta}) = _$EventReviewsResponseDtoImpl;

  factory _EventReviewsResponseDto.fromJson(Map<String, dynamic> json) =
      _$EventReviewsResponseDtoImpl.fromJson;

  @override
  List<EventReviewDto> get data;
  @override
  MetaDto? get meta;
  @override
  @JsonKey(ignore: true)
  _$$EventReviewsResponseDtoImplCopyWith<_$EventReviewsResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReviewStatsDto _$ReviewStatsDtoFromJson(Map<String, dynamic> json) {
  return _ReviewStatsDto.fromJson(json);
}

/// @nodoc
mixin _$ReviewStatsDto {
  @JsonKey(name: 'total_reviews', fromJson: _parseInt)
  int get totalReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'totalReviews', fromJson: _parseInt)
  int get totalReviewsCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_rating', fromJson: _parseDouble)
  double get averageRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'averageRating', fromJson: _parseDouble)
  double get averageRatingCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'verified_count', fromJson: _parseInt)
  int get verifiedCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'verifiedCount', fromJson: _parseInt)
  int get verifiedCountCamel => throw _privateConstructorUsedError;
  Map<String, int> get distribution => throw _privateConstructorUsedError;
  Map<String, int> get percentages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewStatsDtoCopyWith<ReviewStatsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewStatsDtoCopyWith<$Res> {
  factory $ReviewStatsDtoCopyWith(
          ReviewStatsDto value, $Res Function(ReviewStatsDto) then) =
      _$ReviewStatsDtoCopyWithImpl<$Res, ReviewStatsDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_reviews', fromJson: _parseInt) int totalReviews,
      @JsonKey(name: 'totalReviews', fromJson: _parseInt) int totalReviewsCamel,
      @JsonKey(name: 'average_rating', fromJson: _parseDouble)
      double averageRating,
      @JsonKey(name: 'averageRating', fromJson: _parseDouble)
      double averageRatingCamel,
      @JsonKey(name: 'verified_count', fromJson: _parseInt) int verifiedCount,
      @JsonKey(name: 'verifiedCount', fromJson: _parseInt)
      int verifiedCountCamel,
      Map<String, int> distribution,
      Map<String, int> percentages});
}

/// @nodoc
class _$ReviewStatsDtoCopyWithImpl<$Res, $Val extends ReviewStatsDto>
    implements $ReviewStatsDtoCopyWith<$Res> {
  _$ReviewStatsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalReviews = null,
    Object? totalReviewsCamel = null,
    Object? averageRating = null,
    Object? averageRatingCamel = null,
    Object? verifiedCount = null,
    Object? verifiedCountCamel = null,
    Object? distribution = null,
    Object? percentages = null,
  }) {
    return _then(_value.copyWith(
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      totalReviewsCamel: null == totalReviewsCamel
          ? _value.totalReviewsCamel
          : totalReviewsCamel // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      averageRatingCamel: null == averageRatingCamel
          ? _value.averageRatingCamel
          : averageRatingCamel // ignore: cast_nullable_to_non_nullable
              as double,
      verifiedCount: null == verifiedCount
          ? _value.verifiedCount
          : verifiedCount // ignore: cast_nullable_to_non_nullable
              as int,
      verifiedCountCamel: null == verifiedCountCamel
          ? _value.verifiedCountCamel
          : verifiedCountCamel // ignore: cast_nullable_to_non_nullable
              as int,
      distribution: null == distribution
          ? _value.distribution
          : distribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      percentages: null == percentages
          ? _value.percentages
          : percentages // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewStatsDtoImplCopyWith<$Res>
    implements $ReviewStatsDtoCopyWith<$Res> {
  factory _$$ReviewStatsDtoImplCopyWith(_$ReviewStatsDtoImpl value,
          $Res Function(_$ReviewStatsDtoImpl) then) =
      __$$ReviewStatsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_reviews', fromJson: _parseInt) int totalReviews,
      @JsonKey(name: 'totalReviews', fromJson: _parseInt) int totalReviewsCamel,
      @JsonKey(name: 'average_rating', fromJson: _parseDouble)
      double averageRating,
      @JsonKey(name: 'averageRating', fromJson: _parseDouble)
      double averageRatingCamel,
      @JsonKey(name: 'verified_count', fromJson: _parseInt) int verifiedCount,
      @JsonKey(name: 'verifiedCount', fromJson: _parseInt)
      int verifiedCountCamel,
      Map<String, int> distribution,
      Map<String, int> percentages});
}

/// @nodoc
class __$$ReviewStatsDtoImplCopyWithImpl<$Res>
    extends _$ReviewStatsDtoCopyWithImpl<$Res, _$ReviewStatsDtoImpl>
    implements _$$ReviewStatsDtoImplCopyWith<$Res> {
  __$$ReviewStatsDtoImplCopyWithImpl(
      _$ReviewStatsDtoImpl _value, $Res Function(_$ReviewStatsDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalReviews = null,
    Object? totalReviewsCamel = null,
    Object? averageRating = null,
    Object? averageRatingCamel = null,
    Object? verifiedCount = null,
    Object? verifiedCountCamel = null,
    Object? distribution = null,
    Object? percentages = null,
  }) {
    return _then(_$ReviewStatsDtoImpl(
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      totalReviewsCamel: null == totalReviewsCamel
          ? _value.totalReviewsCamel
          : totalReviewsCamel // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      averageRatingCamel: null == averageRatingCamel
          ? _value.averageRatingCamel
          : averageRatingCamel // ignore: cast_nullable_to_non_nullable
              as double,
      verifiedCount: null == verifiedCount
          ? _value.verifiedCount
          : verifiedCount // ignore: cast_nullable_to_non_nullable
              as int,
      verifiedCountCamel: null == verifiedCountCamel
          ? _value.verifiedCountCamel
          : verifiedCountCamel // ignore: cast_nullable_to_non_nullable
              as int,
      distribution: null == distribution
          ? _value._distribution
          : distribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      percentages: null == percentages
          ? _value._percentages
          : percentages // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewStatsDtoImpl implements _ReviewStatsDto {
  const _$ReviewStatsDtoImpl(
      {@JsonKey(name: 'total_reviews', fromJson: _parseInt)
      this.totalReviews = 0,
      @JsonKey(name: 'totalReviews', fromJson: _parseInt)
      this.totalReviewsCamel = 0,
      @JsonKey(name: 'average_rating', fromJson: _parseDouble)
      this.averageRating = 0,
      @JsonKey(name: 'averageRating', fromJson: _parseDouble)
      this.averageRatingCamel = 0,
      @JsonKey(name: 'verified_count', fromJson: _parseInt)
      this.verifiedCount = 0,
      @JsonKey(name: 'verifiedCount', fromJson: _parseInt)
      this.verifiedCountCamel = 0,
      final Map<String, int> distribution = const {},
      final Map<String, int> percentages = const {}})
      : _distribution = distribution,
        _percentages = percentages;

  factory _$ReviewStatsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewStatsDtoImplFromJson(json);

  @override
  @JsonKey(name: 'total_reviews', fromJson: _parseInt)
  final int totalReviews;
  @override
  @JsonKey(name: 'totalReviews', fromJson: _parseInt)
  final int totalReviewsCamel;
  @override
  @JsonKey(name: 'average_rating', fromJson: _parseDouble)
  final double averageRating;
  @override
  @JsonKey(name: 'averageRating', fromJson: _parseDouble)
  final double averageRatingCamel;
  @override
  @JsonKey(name: 'verified_count', fromJson: _parseInt)
  final int verifiedCount;
  @override
  @JsonKey(name: 'verifiedCount', fromJson: _parseInt)
  final int verifiedCountCamel;
  final Map<String, int> _distribution;
  @override
  @JsonKey()
  Map<String, int> get distribution {
    if (_distribution is EqualUnmodifiableMapView) return _distribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_distribution);
  }

  final Map<String, int> _percentages;
  @override
  @JsonKey()
  Map<String, int> get percentages {
    if (_percentages is EqualUnmodifiableMapView) return _percentages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_percentages);
  }

  @override
  String toString() {
    return 'ReviewStatsDto(totalReviews: $totalReviews, totalReviewsCamel: $totalReviewsCamel, averageRating: $averageRating, averageRatingCamel: $averageRatingCamel, verifiedCount: $verifiedCount, verifiedCountCamel: $verifiedCountCamel, distribution: $distribution, percentages: $percentages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewStatsDtoImpl &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.totalReviewsCamel, totalReviewsCamel) ||
                other.totalReviewsCamel == totalReviewsCamel) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.averageRatingCamel, averageRatingCamel) ||
                other.averageRatingCamel == averageRatingCamel) &&
            (identical(other.verifiedCount, verifiedCount) ||
                other.verifiedCount == verifiedCount) &&
            (identical(other.verifiedCountCamel, verifiedCountCamel) ||
                other.verifiedCountCamel == verifiedCountCamel) &&
            const DeepCollectionEquality()
                .equals(other._distribution, _distribution) &&
            const DeepCollectionEquality()
                .equals(other._percentages, _percentages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalReviews,
      totalReviewsCamel,
      averageRating,
      averageRatingCamel,
      verifiedCount,
      verifiedCountCamel,
      const DeepCollectionEquality().hash(_distribution),
      const DeepCollectionEquality().hash(_percentages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewStatsDtoImplCopyWith<_$ReviewStatsDtoImpl> get copyWith =>
      __$$ReviewStatsDtoImplCopyWithImpl<_$ReviewStatsDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewStatsDtoImplToJson(
      this,
    );
  }
}

abstract class _ReviewStatsDto implements ReviewStatsDto {
  const factory _ReviewStatsDto(
      {@JsonKey(name: 'total_reviews', fromJson: _parseInt)
      final int totalReviews,
      @JsonKey(name: 'totalReviews', fromJson: _parseInt)
      final int totalReviewsCamel,
      @JsonKey(name: 'average_rating', fromJson: _parseDouble)
      final double averageRating,
      @JsonKey(name: 'averageRating', fromJson: _parseDouble)
      final double averageRatingCamel,
      @JsonKey(name: 'verified_count', fromJson: _parseInt)
      final int verifiedCount,
      @JsonKey(name: 'verifiedCount', fromJson: _parseInt)
      final int verifiedCountCamel,
      final Map<String, int> distribution,
      final Map<String, int> percentages}) = _$ReviewStatsDtoImpl;

  factory _ReviewStatsDto.fromJson(Map<String, dynamic> json) =
      _$ReviewStatsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'total_reviews', fromJson: _parseInt)
  int get totalReviews;
  @override
  @JsonKey(name: 'totalReviews', fromJson: _parseInt)
  int get totalReviewsCamel;
  @override
  @JsonKey(name: 'average_rating', fromJson: _parseDouble)
  double get averageRating;
  @override
  @JsonKey(name: 'averageRating', fromJson: _parseDouble)
  double get averageRatingCamel;
  @override
  @JsonKey(name: 'verified_count', fromJson: _parseInt)
  int get verifiedCount;
  @override
  @JsonKey(name: 'verifiedCount', fromJson: _parseInt)
  int get verifiedCountCamel;
  @override
  Map<String, int> get distribution;
  @override
  Map<String, int> get percentages;
  @override
  @JsonKey(ignore: true)
  _$$ReviewStatsDtoImplCopyWith<_$ReviewStatsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventReviewDto _$EventReviewDtoFromJson(Map<String, dynamic> json) {
  return _EventReviewDto.fromJson(json);
}

/// @nodoc
mixin _$EventReviewDto {
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseInt)
  int get rating => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get comment => throw _privateConstructorUsedError;
  @JsonKey(name: 'helpful_count', fromJson: _parseInt)
  int get helpfulCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'helpfulCount', fromJson: _parseInt)
  int get helpfulCountCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'not_helpful_count', fromJson: _parseInt)
  int get notHelpfulCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'notHelpfulCount', fromJson: _parseInt)
  int get notHelpfulCountCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified_purchase', fromJson: _parseBool)
  bool get isVerifiedPurchase => throw _privateConstructorUsedError;
  @JsonKey(name: 'isVerifiedPurchase', fromJson: _parseBool)
  bool get isVerifiedPurchaseCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_featured', fromJson: _parseBool)
  bool get isFeatured => throw _privateConstructorUsedError;
  @JsonKey(name: 'isFeatured', fromJson: _parseBool)
  bool get isFeaturedCamel => throw _privateConstructorUsedError;
  ReviewAuthorDto? get author => throw _privateConstructorUsedError;
  ReviewResponseDto? get response => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_vote', fromJson: _parseBoolOrNull)
  bool? get userVote => throw _privateConstructorUsedError;
  @JsonKey(name: 'userVote', fromJson: _parseBoolOrNull)
  bool? get userVoteCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
  String get createdAtFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
  String get createdAtFormattedCamel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventReviewDtoCopyWith<EventReviewDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventReviewDtoCopyWith<$Res> {
  factory $EventReviewDtoCopyWith(
          EventReviewDto value, $Res Function(EventReviewDto) then) =
      _$EventReviewDtoCopyWithImpl<$Res, EventReviewDto>;
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(fromJson: _parseInt) int rating,
      @JsonKey(fromJson: _parseStringOrNull) String? title,
      @JsonKey(fromJson: _parseString) String comment,
      @JsonKey(name: 'helpful_count', fromJson: _parseInt) int helpfulCount,
      @JsonKey(name: 'helpfulCount', fromJson: _parseInt) int helpfulCountCamel,
      @JsonKey(name: 'not_helpful_count', fromJson: _parseInt)
      int notHelpfulCount,
      @JsonKey(name: 'notHelpfulCount', fromJson: _parseInt)
      int notHelpfulCountCamel,
      @JsonKey(name: 'is_verified_purchase', fromJson: _parseBool)
      bool isVerifiedPurchase,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: _parseBool)
      bool isVerifiedPurchaseCamel,
      @JsonKey(name: 'is_featured', fromJson: _parseBool) bool isFeatured,
      @JsonKey(name: 'isFeatured', fromJson: _parseBool) bool isFeaturedCamel,
      ReviewAuthorDto? author,
      ReviewResponseDto? response,
      @JsonKey(name: 'user_vote', fromJson: _parseBoolOrNull) bool? userVote,
      @JsonKey(name: 'userVote', fromJson: _parseBoolOrNull)
      bool? userVoteCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      String createdAtFormattedCamel});

  $ReviewAuthorDtoCopyWith<$Res>? get author;
  $ReviewResponseDtoCopyWith<$Res>? get response;
}

/// @nodoc
class _$EventReviewDtoCopyWithImpl<$Res, $Val extends EventReviewDto>
    implements $EventReviewDtoCopyWith<$Res> {
  _$EventReviewDtoCopyWithImpl(this._value, this._then);

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
    Object? helpfulCount = null,
    Object? helpfulCountCamel = null,
    Object? notHelpfulCount = null,
    Object? notHelpfulCountCamel = null,
    Object? isVerifiedPurchase = null,
    Object? isVerifiedPurchaseCamel = null,
    Object? isFeatured = null,
    Object? isFeaturedCamel = null,
    Object? author = freezed,
    Object? response = freezed,
    Object? userVote = freezed,
    Object? userVoteCamel = freezed,
    Object? createdAtFormatted = null,
    Object? createdAtFormattedCamel = null,
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
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeaturedCamel: null == isFeaturedCamel
          ? _value.isFeaturedCamel
          : isFeaturedCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as ReviewAuthorDto?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as ReviewResponseDto?,
      userVote: freezed == userVote
          ? _value.userVote
          : userVote // ignore: cast_nullable_to_non_nullable
              as bool?,
      userVoteCamel: freezed == userVoteCamel
          ? _value.userVoteCamel
          : userVoteCamel // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAtFormatted: null == createdAtFormatted
          ? _value.createdAtFormatted
          : createdAtFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormattedCamel: null == createdAtFormattedCamel
          ? _value.createdAtFormattedCamel
          : createdAtFormattedCamel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ReviewAuthorDtoCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $ReviewAuthorDtoCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
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
abstract class _$$EventReviewDtoImplCopyWith<$Res>
    implements $EventReviewDtoCopyWith<$Res> {
  factory _$$EventReviewDtoImplCopyWith(_$EventReviewDtoImpl value,
          $Res Function(_$EventReviewDtoImpl) then) =
      __$$EventReviewDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(fromJson: _parseInt) int rating,
      @JsonKey(fromJson: _parseStringOrNull) String? title,
      @JsonKey(fromJson: _parseString) String comment,
      @JsonKey(name: 'helpful_count', fromJson: _parseInt) int helpfulCount,
      @JsonKey(name: 'helpfulCount', fromJson: _parseInt) int helpfulCountCamel,
      @JsonKey(name: 'not_helpful_count', fromJson: _parseInt)
      int notHelpfulCount,
      @JsonKey(name: 'notHelpfulCount', fromJson: _parseInt)
      int notHelpfulCountCamel,
      @JsonKey(name: 'is_verified_purchase', fromJson: _parseBool)
      bool isVerifiedPurchase,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: _parseBool)
      bool isVerifiedPurchaseCamel,
      @JsonKey(name: 'is_featured', fromJson: _parseBool) bool isFeatured,
      @JsonKey(name: 'isFeatured', fromJson: _parseBool) bool isFeaturedCamel,
      ReviewAuthorDto? author,
      ReviewResponseDto? response,
      @JsonKey(name: 'user_vote', fromJson: _parseBoolOrNull) bool? userVote,
      @JsonKey(name: 'userVote', fromJson: _parseBoolOrNull)
      bool? userVoteCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      String createdAtFormattedCamel});

  @override
  $ReviewAuthorDtoCopyWith<$Res>? get author;
  @override
  $ReviewResponseDtoCopyWith<$Res>? get response;
}

/// @nodoc
class __$$EventReviewDtoImplCopyWithImpl<$Res>
    extends _$EventReviewDtoCopyWithImpl<$Res, _$EventReviewDtoImpl>
    implements _$$EventReviewDtoImplCopyWith<$Res> {
  __$$EventReviewDtoImplCopyWithImpl(
      _$EventReviewDtoImpl _value, $Res Function(_$EventReviewDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? rating = null,
    Object? title = freezed,
    Object? comment = null,
    Object? helpfulCount = null,
    Object? helpfulCountCamel = null,
    Object? notHelpfulCount = null,
    Object? notHelpfulCountCamel = null,
    Object? isVerifiedPurchase = null,
    Object? isVerifiedPurchaseCamel = null,
    Object? isFeatured = null,
    Object? isFeaturedCamel = null,
    Object? author = freezed,
    Object? response = freezed,
    Object? userVote = freezed,
    Object? userVoteCamel = freezed,
    Object? createdAtFormatted = null,
    Object? createdAtFormattedCamel = null,
  }) {
    return _then(_$EventReviewDtoImpl(
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
      isFeatured: null == isFeatured
          ? _value.isFeatured
          : isFeatured // ignore: cast_nullable_to_non_nullable
              as bool,
      isFeaturedCamel: null == isFeaturedCamel
          ? _value.isFeaturedCamel
          : isFeaturedCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as ReviewAuthorDto?,
      response: freezed == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as ReviewResponseDto?,
      userVote: freezed == userVote
          ? _value.userVote
          : userVote // ignore: cast_nullable_to_non_nullable
              as bool?,
      userVoteCamel: freezed == userVoteCamel
          ? _value.userVoteCamel
          : userVoteCamel // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdAtFormatted: null == createdAtFormatted
          ? _value.createdAtFormatted
          : createdAtFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormattedCamel: null == createdAtFormattedCamel
          ? _value.createdAtFormattedCamel
          : createdAtFormattedCamel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventReviewDtoImpl implements _EventReviewDto {
  const _$EventReviewDtoImpl(
      {required this.uuid,
      @JsonKey(fromJson: _parseInt) this.rating = 0,
      @JsonKey(fromJson: _parseStringOrNull) this.title,
      @JsonKey(fromJson: _parseString) this.comment = '',
      @JsonKey(name: 'helpful_count', fromJson: _parseInt)
      this.helpfulCount = 0,
      @JsonKey(name: 'helpfulCount', fromJson: _parseInt)
      this.helpfulCountCamel = 0,
      @JsonKey(name: 'not_helpful_count', fromJson: _parseInt)
      this.notHelpfulCount = 0,
      @JsonKey(name: 'notHelpfulCount', fromJson: _parseInt)
      this.notHelpfulCountCamel = 0,
      @JsonKey(name: 'is_verified_purchase', fromJson: _parseBool)
      this.isVerifiedPurchase = false,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: _parseBool)
      this.isVerifiedPurchaseCamel = false,
      @JsonKey(name: 'is_featured', fromJson: _parseBool)
      this.isFeatured = false,
      @JsonKey(name: 'isFeatured', fromJson: _parseBool)
      this.isFeaturedCamel = false,
      this.author,
      this.response,
      @JsonKey(name: 'user_vote', fromJson: _parseBoolOrNull) this.userVote,
      @JsonKey(name: 'userVote', fromJson: _parseBoolOrNull) this.userVoteCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      this.createdAtFormatted = '',
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      this.createdAtFormattedCamel = ''});

  factory _$EventReviewDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventReviewDtoImplFromJson(json);

  @override
  final String uuid;
  @override
  @JsonKey(fromJson: _parseInt)
  final int rating;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? title;
  @override
  @JsonKey(fromJson: _parseString)
  final String comment;
  @override
  @JsonKey(name: 'helpful_count', fromJson: _parseInt)
  final int helpfulCount;
  @override
  @JsonKey(name: 'helpfulCount', fromJson: _parseInt)
  final int helpfulCountCamel;
  @override
  @JsonKey(name: 'not_helpful_count', fromJson: _parseInt)
  final int notHelpfulCount;
  @override
  @JsonKey(name: 'notHelpfulCount', fromJson: _parseInt)
  final int notHelpfulCountCamel;
  @override
  @JsonKey(name: 'is_verified_purchase', fromJson: _parseBool)
  final bool isVerifiedPurchase;
  @override
  @JsonKey(name: 'isVerifiedPurchase', fromJson: _parseBool)
  final bool isVerifiedPurchaseCamel;
  @override
  @JsonKey(name: 'is_featured', fromJson: _parseBool)
  final bool isFeatured;
  @override
  @JsonKey(name: 'isFeatured', fromJson: _parseBool)
  final bool isFeaturedCamel;
  @override
  final ReviewAuthorDto? author;
  @override
  final ReviewResponseDto? response;
  @override
  @JsonKey(name: 'user_vote', fromJson: _parseBoolOrNull)
  final bool? userVote;
  @override
  @JsonKey(name: 'userVote', fromJson: _parseBoolOrNull)
  final bool? userVoteCamel;
  @override
  @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
  final String createdAtFormatted;
  @override
  @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
  final String createdAtFormattedCamel;

  @override
  String toString() {
    return 'EventReviewDto(uuid: $uuid, rating: $rating, title: $title, comment: $comment, helpfulCount: $helpfulCount, helpfulCountCamel: $helpfulCountCamel, notHelpfulCount: $notHelpfulCount, notHelpfulCountCamel: $notHelpfulCountCamel, isVerifiedPurchase: $isVerifiedPurchase, isVerifiedPurchaseCamel: $isVerifiedPurchaseCamel, isFeatured: $isFeatured, isFeaturedCamel: $isFeaturedCamel, author: $author, response: $response, userVote: $userVote, userVoteCamel: $userVoteCamel, createdAtFormatted: $createdAtFormatted, createdAtFormattedCamel: $createdAtFormattedCamel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventReviewDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.comment, comment) || other.comment == comment) &&
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
            (identical(other.isFeatured, isFeatured) ||
                other.isFeatured == isFeatured) &&
            (identical(other.isFeaturedCamel, isFeaturedCamel) ||
                other.isFeaturedCamel == isFeaturedCamel) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.userVote, userVote) ||
                other.userVote == userVote) &&
            (identical(other.userVoteCamel, userVoteCamel) ||
                other.userVoteCamel == userVoteCamel) &&
            (identical(other.createdAtFormatted, createdAtFormatted) ||
                other.createdAtFormatted == createdAtFormatted) &&
            (identical(
                    other.createdAtFormattedCamel, createdAtFormattedCamel) ||
                other.createdAtFormattedCamel == createdAtFormattedCamel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      uuid,
      rating,
      title,
      comment,
      helpfulCount,
      helpfulCountCamel,
      notHelpfulCount,
      notHelpfulCountCamel,
      isVerifiedPurchase,
      isVerifiedPurchaseCamel,
      isFeatured,
      isFeaturedCamel,
      author,
      response,
      userVote,
      userVoteCamel,
      createdAtFormatted,
      createdAtFormattedCamel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventReviewDtoImplCopyWith<_$EventReviewDtoImpl> get copyWith =>
      __$$EventReviewDtoImplCopyWithImpl<_$EventReviewDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventReviewDtoImplToJson(
      this,
    );
  }
}

abstract class _EventReviewDto implements EventReviewDto {
  const factory _EventReviewDto(
      {required final String uuid,
      @JsonKey(fromJson: _parseInt) final int rating,
      @JsonKey(fromJson: _parseStringOrNull) final String? title,
      @JsonKey(fromJson: _parseString) final String comment,
      @JsonKey(name: 'helpful_count', fromJson: _parseInt)
      final int helpfulCount,
      @JsonKey(name: 'helpfulCount', fromJson: _parseInt)
      final int helpfulCountCamel,
      @JsonKey(name: 'not_helpful_count', fromJson: _parseInt)
      final int notHelpfulCount,
      @JsonKey(name: 'notHelpfulCount', fromJson: _parseInt)
      final int notHelpfulCountCamel,
      @JsonKey(name: 'is_verified_purchase', fromJson: _parseBool)
      final bool isVerifiedPurchase,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: _parseBool)
      final bool isVerifiedPurchaseCamel,
      @JsonKey(name: 'is_featured', fromJson: _parseBool) final bool isFeatured,
      @JsonKey(name: 'isFeatured', fromJson: _parseBool)
      final bool isFeaturedCamel,
      final ReviewAuthorDto? author,
      final ReviewResponseDto? response,
      @JsonKey(name: 'user_vote', fromJson: _parseBoolOrNull)
      final bool? userVote,
      @JsonKey(name: 'userVote', fromJson: _parseBoolOrNull)
      final bool? userVoteCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      final String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      final String createdAtFormattedCamel}) = _$EventReviewDtoImpl;

  factory _EventReviewDto.fromJson(Map<String, dynamic> json) =
      _$EventReviewDtoImpl.fromJson;

  @override
  String get uuid;
  @override
  @JsonKey(fromJson: _parseInt)
  int get rating;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get title;
  @override
  @JsonKey(fromJson: _parseString)
  String get comment;
  @override
  @JsonKey(name: 'helpful_count', fromJson: _parseInt)
  int get helpfulCount;
  @override
  @JsonKey(name: 'helpfulCount', fromJson: _parseInt)
  int get helpfulCountCamel;
  @override
  @JsonKey(name: 'not_helpful_count', fromJson: _parseInt)
  int get notHelpfulCount;
  @override
  @JsonKey(name: 'notHelpfulCount', fromJson: _parseInt)
  int get notHelpfulCountCamel;
  @override
  @JsonKey(name: 'is_verified_purchase', fromJson: _parseBool)
  bool get isVerifiedPurchase;
  @override
  @JsonKey(name: 'isVerifiedPurchase', fromJson: _parseBool)
  bool get isVerifiedPurchaseCamel;
  @override
  @JsonKey(name: 'is_featured', fromJson: _parseBool)
  bool get isFeatured;
  @override
  @JsonKey(name: 'isFeatured', fromJson: _parseBool)
  bool get isFeaturedCamel;
  @override
  ReviewAuthorDto? get author;
  @override
  ReviewResponseDto? get response;
  @override
  @JsonKey(name: 'user_vote', fromJson: _parseBoolOrNull)
  bool? get userVote;
  @override
  @JsonKey(name: 'userVote', fromJson: _parseBoolOrNull)
  bool? get userVoteCamel;
  @override
  @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
  String get createdAtFormatted;
  @override
  @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
  String get createdAtFormattedCamel;
  @override
  @JsonKey(ignore: true)
  _$$EventReviewDtoImplCopyWith<_$EventReviewDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewAuthorDto _$ReviewAuthorDtoFromJson(Map<String, dynamic> json) {
  return _ReviewAuthorDto.fromJson(json);
}

/// @nodoc
mixin _$ReviewAuthorDto {
  @JsonKey(fromJson: _parseString)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseStringOrNull)
  String? get avatar => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get initials => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewAuthorDtoCopyWith<ReviewAuthorDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewAuthorDtoCopyWith<$Res> {
  factory $ReviewAuthorDtoCopyWith(
          ReviewAuthorDto value, $Res Function(ReviewAuthorDto) then) =
      _$ReviewAuthorDtoCopyWithImpl<$Res, ReviewAuthorDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseString) String name,
      @JsonKey(fromJson: _parseStringOrNull) String? avatar,
      @JsonKey(fromJson: _parseString) String initials});
}

/// @nodoc
class _$ReviewAuthorDtoCopyWithImpl<$Res, $Val extends ReviewAuthorDto>
    implements $ReviewAuthorDtoCopyWith<$Res> {
  _$ReviewAuthorDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? avatar = freezed,
    Object? initials = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      initials: null == initials
          ? _value.initials
          : initials // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewAuthorDtoImplCopyWith<$Res>
    implements $ReviewAuthorDtoCopyWith<$Res> {
  factory _$$ReviewAuthorDtoImplCopyWith(_$ReviewAuthorDtoImpl value,
          $Res Function(_$ReviewAuthorDtoImpl) then) =
      __$$ReviewAuthorDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseString) String name,
      @JsonKey(fromJson: _parseStringOrNull) String? avatar,
      @JsonKey(fromJson: _parseString) String initials});
}

/// @nodoc
class __$$ReviewAuthorDtoImplCopyWithImpl<$Res>
    extends _$ReviewAuthorDtoCopyWithImpl<$Res, _$ReviewAuthorDtoImpl>
    implements _$$ReviewAuthorDtoImplCopyWith<$Res> {
  __$$ReviewAuthorDtoImplCopyWithImpl(
      _$ReviewAuthorDtoImpl _value, $Res Function(_$ReviewAuthorDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? avatar = freezed,
    Object? initials = null,
  }) {
    return _then(_$ReviewAuthorDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String?,
      initials: null == initials
          ? _value.initials
          : initials // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewAuthorDtoImpl implements _ReviewAuthorDto {
  const _$ReviewAuthorDtoImpl(
      {@JsonKey(fromJson: _parseString) this.name = '',
      @JsonKey(fromJson: _parseStringOrNull) this.avatar,
      @JsonKey(fromJson: _parseString) this.initials = ''});

  factory _$ReviewAuthorDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewAuthorDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseString)
  final String name;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  final String? avatar;
  @override
  @JsonKey(fromJson: _parseString)
  final String initials;

  @override
  String toString() {
    return 'ReviewAuthorDto(name: $name, avatar: $avatar, initials: $initials)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewAuthorDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.initials, initials) ||
                other.initials == initials));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, avatar, initials);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewAuthorDtoImplCopyWith<_$ReviewAuthorDtoImpl> get copyWith =>
      __$$ReviewAuthorDtoImplCopyWithImpl<_$ReviewAuthorDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewAuthorDtoImplToJson(
      this,
    );
  }
}

abstract class _ReviewAuthorDto implements ReviewAuthorDto {
  const factory _ReviewAuthorDto(
          {@JsonKey(fromJson: _parseString) final String name,
          @JsonKey(fromJson: _parseStringOrNull) final String? avatar,
          @JsonKey(fromJson: _parseString) final String initials}) =
      _$ReviewAuthorDtoImpl;

  factory _ReviewAuthorDto.fromJson(Map<String, dynamic> json) =
      _$ReviewAuthorDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseString)
  String get name;
  @override
  @JsonKey(fromJson: _parseStringOrNull)
  String? get avatar;
  @override
  @JsonKey(fromJson: _parseString)
  String get initials;
  @override
  @JsonKey(ignore: true)
  _$$ReviewAuthorDtoImplCopyWith<_$ReviewAuthorDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewResponseDto _$ReviewResponseDtoFromJson(Map<String, dynamic> json) {
  return _ReviewResponseDto.fromJson(json);
}

/// @nodoc
mixin _$ReviewResponseDto {
  String get uuid => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseString)
  String get response => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_name', fromJson: _parseString)
  String get organizationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'organizationName', fromJson: _parseString)
  String get organizationNameCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
  String get createdAtFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
  String get createdAtFormattedCamel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewResponseDtoCopyWith<ReviewResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewResponseDtoCopyWith<$Res> {
  factory $ReviewResponseDtoCopyWith(
          ReviewResponseDto value, $Res Function(ReviewResponseDto) then) =
      _$ReviewResponseDtoCopyWithImpl<$Res, ReviewResponseDto>;
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(fromJson: _parseString) String response,
      @JsonKey(name: 'organization_name', fromJson: _parseString)
      String organizationName,
      @JsonKey(name: 'organizationName', fromJson: _parseString)
      String organizationNameCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      String createdAtFormattedCamel});
}

/// @nodoc
class _$ReviewResponseDtoCopyWithImpl<$Res, $Val extends ReviewResponseDto>
    implements $ReviewResponseDtoCopyWith<$Res> {
  _$ReviewResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? response = null,
    Object? organizationName = null,
    Object? organizationNameCamel = null,
    Object? createdAtFormatted = null,
    Object? createdAtFormattedCamel = null,
  }) {
    return _then(_value.copyWith(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      organizationName: null == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String,
      organizationNameCamel: null == organizationNameCamel
          ? _value.organizationNameCamel
          : organizationNameCamel // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormatted: null == createdAtFormatted
          ? _value.createdAtFormatted
          : createdAtFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormattedCamel: null == createdAtFormattedCamel
          ? _value.createdAtFormattedCamel
          : createdAtFormattedCamel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewResponseDtoImplCopyWith<$Res>
    implements $ReviewResponseDtoCopyWith<$Res> {
  factory _$$ReviewResponseDtoImplCopyWith(_$ReviewResponseDtoImpl value,
          $Res Function(_$ReviewResponseDtoImpl) then) =
      __$$ReviewResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uuid,
      @JsonKey(fromJson: _parseString) String response,
      @JsonKey(name: 'organization_name', fromJson: _parseString)
      String organizationName,
      @JsonKey(name: 'organizationName', fromJson: _parseString)
      String organizationNameCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      String createdAtFormattedCamel});
}

/// @nodoc
class __$$ReviewResponseDtoImplCopyWithImpl<$Res>
    extends _$ReviewResponseDtoCopyWithImpl<$Res, _$ReviewResponseDtoImpl>
    implements _$$ReviewResponseDtoImplCopyWith<$Res> {
  __$$ReviewResponseDtoImplCopyWithImpl(_$ReviewResponseDtoImpl _value,
      $Res Function(_$ReviewResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = null,
    Object? response = null,
    Object? organizationName = null,
    Object? organizationNameCamel = null,
    Object? createdAtFormatted = null,
    Object? createdAtFormattedCamel = null,
  }) {
    return _then(_$ReviewResponseDtoImpl(
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as String,
      organizationName: null == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String,
      organizationNameCamel: null == organizationNameCamel
          ? _value.organizationNameCamel
          : organizationNameCamel // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormatted: null == createdAtFormatted
          ? _value.createdAtFormatted
          : createdAtFormatted // ignore: cast_nullable_to_non_nullable
              as String,
      createdAtFormattedCamel: null == createdAtFormattedCamel
          ? _value.createdAtFormattedCamel
          : createdAtFormattedCamel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewResponseDtoImpl implements _ReviewResponseDto {
  const _$ReviewResponseDtoImpl(
      {required this.uuid,
      @JsonKey(fromJson: _parseString) this.response = '',
      @JsonKey(name: 'organization_name', fromJson: _parseString)
      this.organizationName = '',
      @JsonKey(name: 'organizationName', fromJson: _parseString)
      this.organizationNameCamel = '',
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      this.createdAtFormatted = '',
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      this.createdAtFormattedCamel = ''});

  factory _$ReviewResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewResponseDtoImplFromJson(json);

  @override
  final String uuid;
  @override
  @JsonKey(fromJson: _parseString)
  final String response;
  @override
  @JsonKey(name: 'organization_name', fromJson: _parseString)
  final String organizationName;
  @override
  @JsonKey(name: 'organizationName', fromJson: _parseString)
  final String organizationNameCamel;
  @override
  @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
  final String createdAtFormatted;
  @override
  @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
  final String createdAtFormattedCamel;

  @override
  String toString() {
    return 'ReviewResponseDto(uuid: $uuid, response: $response, organizationName: $organizationName, organizationNameCamel: $organizationNameCamel, createdAtFormatted: $createdAtFormatted, createdAtFormattedCamel: $createdAtFormattedCamel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewResponseDtoImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.organizationNameCamel, organizationNameCamel) ||
                other.organizationNameCamel == organizationNameCamel) &&
            (identical(other.createdAtFormatted, createdAtFormatted) ||
                other.createdAtFormatted == createdAtFormatted) &&
            (identical(
                    other.createdAtFormattedCamel, createdAtFormattedCamel) ||
                other.createdAtFormattedCamel == createdAtFormattedCamel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, response, organizationName,
      organizationNameCamel, createdAtFormatted, createdAtFormattedCamel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewResponseDtoImplCopyWith<_$ReviewResponseDtoImpl> get copyWith =>
      __$$ReviewResponseDtoImplCopyWithImpl<_$ReviewResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _ReviewResponseDto implements ReviewResponseDto {
  const factory _ReviewResponseDto(
      {required final String uuid,
      @JsonKey(fromJson: _parseString) final String response,
      @JsonKey(name: 'organization_name', fromJson: _parseString)
      final String organizationName,
      @JsonKey(name: 'organizationName', fromJson: _parseString)
      final String organizationNameCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
      final String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
      final String createdAtFormattedCamel}) = _$ReviewResponseDtoImpl;

  factory _ReviewResponseDto.fromJson(Map<String, dynamic> json) =
      _$ReviewResponseDtoImpl.fromJson;

  @override
  String get uuid;
  @override
  @JsonKey(fromJson: _parseString)
  String get response;
  @override
  @JsonKey(name: 'organization_name', fromJson: _parseString)
  String get organizationName;
  @override
  @JsonKey(name: 'organizationName', fromJson: _parseString)
  String get organizationNameCamel;
  @override
  @JsonKey(name: 'created_at_formatted', fromJson: _parseString)
  String get createdAtFormatted;
  @override
  @JsonKey(name: 'createdAtFormatted', fromJson: _parseString)
  String get createdAtFormattedCamel;
  @override
  @JsonKey(ignore: true)
  _$$ReviewResponseDtoImplCopyWith<_$ReviewResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MetaDto _$MetaDtoFromJson(Map<String, dynamic> json) {
  return _MetaDto.fromJson(json);
}

/// @nodoc
mixin _$MetaDto {
  @JsonKey(name: 'current_page', fromJson: _parseInt)
  int get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_page', fromJson: _parseInt)
  int get lastPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page', fromJson: _parseInt)
  int get perPage => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _parseInt)
  int get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MetaDtoCopyWith<MetaDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetaDtoCopyWith<$Res> {
  factory $MetaDtoCopyWith(MetaDto value, $Res Function(MetaDto) then) =
      _$MetaDtoCopyWithImpl<$Res, MetaDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page', fromJson: _parseInt) int currentPage,
      @JsonKey(name: 'last_page', fromJson: _parseInt) int lastPage,
      @JsonKey(name: 'per_page', fromJson: _parseInt) int perPage,
      @JsonKey(fromJson: _parseInt) int total});
}

/// @nodoc
class _$MetaDtoCopyWithImpl<$Res, $Val extends MetaDto>
    implements $MetaDtoCopyWith<$Res> {
  _$MetaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? lastPage = null,
    Object? perPage = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MetaDtoImplCopyWith<$Res> implements $MetaDtoCopyWith<$Res> {
  factory _$$MetaDtoImplCopyWith(
          _$MetaDtoImpl value, $Res Function(_$MetaDtoImpl) then) =
      __$$MetaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page', fromJson: _parseInt) int currentPage,
      @JsonKey(name: 'last_page', fromJson: _parseInt) int lastPage,
      @JsonKey(name: 'per_page', fromJson: _parseInt) int perPage,
      @JsonKey(fromJson: _parseInt) int total});
}

/// @nodoc
class __$$MetaDtoImplCopyWithImpl<$Res>
    extends _$MetaDtoCopyWithImpl<$Res, _$MetaDtoImpl>
    implements _$$MetaDtoImplCopyWith<$Res> {
  __$$MetaDtoImplCopyWithImpl(
      _$MetaDtoImpl _value, $Res Function(_$MetaDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? lastPage = null,
    Object? perPage = null,
    Object? total = null,
  }) {
    return _then(_$MetaDtoImpl(
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      lastPage: null == lastPage
          ? _value.lastPage
          : lastPage // ignore: cast_nullable_to_non_nullable
              as int,
      perPage: null == perPage
          ? _value.perPage
          : perPage // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MetaDtoImpl implements _MetaDto {
  const _$MetaDtoImpl(
      {@JsonKey(name: 'current_page', fromJson: _parseInt) this.currentPage = 1,
      @JsonKey(name: 'last_page', fromJson: _parseInt) this.lastPage = 1,
      @JsonKey(name: 'per_page', fromJson: _parseInt) this.perPage = 15,
      @JsonKey(fromJson: _parseInt) this.total = 0});

  factory _$MetaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetaDtoImplFromJson(json);

  @override
  @JsonKey(name: 'current_page', fromJson: _parseInt)
  final int currentPage;
  @override
  @JsonKey(name: 'last_page', fromJson: _parseInt)
  final int lastPage;
  @override
  @JsonKey(name: 'per_page', fromJson: _parseInt)
  final int perPage;
  @override
  @JsonKey(fromJson: _parseInt)
  final int total;

  @override
  String toString() {
    return 'MetaDto(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetaDtoImpl &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.lastPage, lastPage) ||
                other.lastPage == lastPage) &&
            (identical(other.perPage, perPage) || other.perPage == perPage) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, currentPage, lastPage, perPage, total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MetaDtoImplCopyWith<_$MetaDtoImpl> get copyWith =>
      __$$MetaDtoImplCopyWithImpl<_$MetaDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetaDtoImplToJson(
      this,
    );
  }
}

abstract class _MetaDto implements MetaDto {
  const factory _MetaDto(
      {@JsonKey(name: 'current_page', fromJson: _parseInt)
      final int currentPage,
      @JsonKey(name: 'last_page', fromJson: _parseInt) final int lastPage,
      @JsonKey(name: 'per_page', fromJson: _parseInt) final int perPage,
      @JsonKey(fromJson: _parseInt) final int total}) = _$MetaDtoImpl;

  factory _MetaDto.fromJson(Map<String, dynamic> json) = _$MetaDtoImpl.fromJson;

  @override
  @JsonKey(name: 'current_page', fromJson: _parseInt)
  int get currentPage;
  @override
  @JsonKey(name: 'last_page', fromJson: _parseInt)
  int get lastPage;
  @override
  @JsonKey(name: 'per_page', fromJson: _parseInt)
  int get perPage;
  @override
  @JsonKey(fromJson: _parseInt)
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$MetaDtoImplCopyWith<_$MetaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReviewsResponseDto _$ReviewsResponseDtoFromJson(Map<String, dynamic> json) {
  return _ReviewsResponseDto.fromJson(json);
}

/// @nodoc
mixin _$ReviewsResponseDto {
  List<ReviewDto> get data => throw _privateConstructorUsedError;
  PaginationMetaDto? get meta => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewsResponseDtoCopyWith<ReviewsResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewsResponseDtoCopyWith<$Res> {
  factory $ReviewsResponseDtoCopyWith(
          ReviewsResponseDto value, $Res Function(ReviewsResponseDto) then) =
      _$ReviewsResponseDtoCopyWithImpl<$Res, ReviewsResponseDto>;
  @useResult
  $Res call({List<ReviewDto> data, PaginationMetaDto? meta});

  $PaginationMetaDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class _$ReviewsResponseDtoCopyWithImpl<$Res, $Val extends ReviewsResponseDto>
    implements $ReviewsResponseDtoCopyWith<$Res> {
  _$ReviewsResponseDtoCopyWithImpl(this._value, this._then);

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
              as List<ReviewDto>,
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
abstract class _$$ReviewsResponseDtoImplCopyWith<$Res>
    implements $ReviewsResponseDtoCopyWith<$Res> {
  factory _$$ReviewsResponseDtoImplCopyWith(_$ReviewsResponseDtoImpl value,
          $Res Function(_$ReviewsResponseDtoImpl) then) =
      __$$ReviewsResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ReviewDto> data, PaginationMetaDto? meta});

  @override
  $PaginationMetaDtoCopyWith<$Res>? get meta;
}

/// @nodoc
class __$$ReviewsResponseDtoImplCopyWithImpl<$Res>
    extends _$ReviewsResponseDtoCopyWithImpl<$Res, _$ReviewsResponseDtoImpl>
    implements _$$ReviewsResponseDtoImplCopyWith<$Res> {
  __$$ReviewsResponseDtoImplCopyWithImpl(_$ReviewsResponseDtoImpl _value,
      $Res Function(_$ReviewsResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? meta = freezed,
  }) {
    return _then(_$ReviewsResponseDtoImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<ReviewDto>,
      meta: freezed == meta
          ? _value.meta
          : meta // ignore: cast_nullable_to_non_nullable
              as PaginationMetaDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewsResponseDtoImpl implements _ReviewsResponseDto {
  const _$ReviewsResponseDtoImpl(
      {final List<ReviewDto> data = const [], this.meta})
      : _data = data;

  factory _$ReviewsResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewsResponseDtoImplFromJson(json);

  final List<ReviewDto> _data;
  @override
  @JsonKey()
  List<ReviewDto> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final PaginationMetaDto? meta;

  @override
  String toString() {
    return 'ReviewsResponseDto(data: $data, meta: $meta)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewsResponseDtoImpl &&
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
  _$$ReviewsResponseDtoImplCopyWith<_$ReviewsResponseDtoImpl> get copyWith =>
      __$$ReviewsResponseDtoImplCopyWithImpl<_$ReviewsResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewsResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _ReviewsResponseDto implements ReviewsResponseDto {
  const factory _ReviewsResponseDto(
      {final List<ReviewDto> data,
      final PaginationMetaDto? meta}) = _$ReviewsResponseDtoImpl;

  factory _ReviewsResponseDto.fromJson(Map<String, dynamic> json) =
      _$ReviewsResponseDtoImpl.fromJson;

  @override
  List<ReviewDto> get data;
  @override
  PaginationMetaDto? get meta;
  @override
  @JsonKey(ignore: true)
  _$$ReviewsResponseDtoImplCopyWith<_$ReviewsResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewStatsDto _$ReviewStatsDtoFromJson(Map<String, dynamic> json) {
  return _ReviewStatsDto.fromJson(json);
}

/// @nodoc
mixin _$ReviewStatsDto {
  @JsonKey(name: 'total_reviews', fromJson: parseInt)
  int get totalReviews => throw _privateConstructorUsedError;
  @JsonKey(name: 'totalReviews', fromJson: parseInt)
  int get totalReviewsCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_rating', fromJson: parseDouble)
  double get averageRating => throw _privateConstructorUsedError;
  @JsonKey(name: 'averageRating', fromJson: parseDouble)
  double get averageRatingCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'verified_count', fromJson: parseInt)
  int get verifiedCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'verifiedCount', fromJson: parseInt)
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
      {@JsonKey(name: 'total_reviews', fromJson: parseInt) int totalReviews,
      @JsonKey(name: 'totalReviews', fromJson: parseInt) int totalReviewsCamel,
      @JsonKey(name: 'average_rating', fromJson: parseDouble)
      double averageRating,
      @JsonKey(name: 'averageRating', fromJson: parseDouble)
      double averageRatingCamel,
      @JsonKey(name: 'verified_count', fromJson: parseInt) int verifiedCount,
      @JsonKey(name: 'verifiedCount', fromJson: parseInt)
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
      {@JsonKey(name: 'total_reviews', fromJson: parseInt) int totalReviews,
      @JsonKey(name: 'totalReviews', fromJson: parseInt) int totalReviewsCamel,
      @JsonKey(name: 'average_rating', fromJson: parseDouble)
      double averageRating,
      @JsonKey(name: 'averageRating', fromJson: parseDouble)
      double averageRatingCamel,
      @JsonKey(name: 'verified_count', fromJson: parseInt) int verifiedCount,
      @JsonKey(name: 'verifiedCount', fromJson: parseInt)
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
      {@JsonKey(name: 'total_reviews', fromJson: parseInt)
      this.totalReviews = 0,
      @JsonKey(name: 'totalReviews', fromJson: parseInt)
      this.totalReviewsCamel = 0,
      @JsonKey(name: 'average_rating', fromJson: parseDouble)
      this.averageRating = 0,
      @JsonKey(name: 'averageRating', fromJson: parseDouble)
      this.averageRatingCamel = 0,
      @JsonKey(name: 'verified_count', fromJson: parseInt)
      this.verifiedCount = 0,
      @JsonKey(name: 'verifiedCount', fromJson: parseInt)
      this.verifiedCountCamel = 0,
      final Map<String, int> distribution = const {},
      final Map<String, int> percentages = const {}})
      : _distribution = distribution,
        _percentages = percentages;

  factory _$ReviewStatsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewStatsDtoImplFromJson(json);

  @override
  @JsonKey(name: 'total_reviews', fromJson: parseInt)
  final int totalReviews;
  @override
  @JsonKey(name: 'totalReviews', fromJson: parseInt)
  final int totalReviewsCamel;
  @override
  @JsonKey(name: 'average_rating', fromJson: parseDouble)
  final double averageRating;
  @override
  @JsonKey(name: 'averageRating', fromJson: parseDouble)
  final double averageRatingCamel;
  @override
  @JsonKey(name: 'verified_count', fromJson: parseInt)
  final int verifiedCount;
  @override
  @JsonKey(name: 'verifiedCount', fromJson: parseInt)
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
      {@JsonKey(name: 'total_reviews', fromJson: parseInt)
      final int totalReviews,
      @JsonKey(name: 'totalReviews', fromJson: parseInt)
      final int totalReviewsCamel,
      @JsonKey(name: 'average_rating', fromJson: parseDouble)
      final double averageRating,
      @JsonKey(name: 'averageRating', fromJson: parseDouble)
      final double averageRatingCamel,
      @JsonKey(name: 'verified_count', fromJson: parseInt)
      final int verifiedCount,
      @JsonKey(name: 'verifiedCount', fromJson: parseInt)
      final int verifiedCountCamel,
      final Map<String, int> distribution,
      final Map<String, int> percentages}) = _$ReviewStatsDtoImpl;

  factory _ReviewStatsDto.fromJson(Map<String, dynamic> json) =
      _$ReviewStatsDtoImpl.fromJson;

  @override
  @JsonKey(name: 'total_reviews', fromJson: parseInt)
  int get totalReviews;
  @override
  @JsonKey(name: 'totalReviews', fromJson: parseInt)
  int get totalReviewsCamel;
  @override
  @JsonKey(name: 'average_rating', fromJson: parseDouble)
  double get averageRating;
  @override
  @JsonKey(name: 'averageRating', fromJson: parseDouble)
  double get averageRatingCamel;
  @override
  @JsonKey(name: 'verified_count', fromJson: parseInt)
  int get verifiedCount;
  @override
  @JsonKey(name: 'verifiedCount', fromJson: parseInt)
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

ReviewDto _$ReviewDtoFromJson(Map<String, dynamic> json) {
  return _ReviewDto.fromJson(json);
}

/// @nodoc
mixin _$ReviewDto {
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
  @JsonKey(name: 'helpfulness_percentage', fromJson: parseDouble)
  double get helpfulnessPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'helpfulnessPercentage', fromJson: parseDouble)
  double get helpfulnessPercentageCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
  bool get isVerifiedPurchase => throw _privateConstructorUsedError;
  @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
  bool get isVerifiedPurchaseCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_featured', fromJson: parseBool)
  bool get isFeatured => throw _privateConstructorUsedError;
  @JsonKey(name: 'isFeatured', fromJson: parseBool)
  bool get isFeaturedCamel => throw _privateConstructorUsedError;
  ReviewAuthorDto? get author => throw _privateConstructorUsedError;
  ReviewResponseDto? get response =>
      throw _privateConstructorUsedError; // Event context — populated by the organizer-scoped reviews endpoint
// (`GET /organizers/{id}/reviews`); null when the review is fetched
// from the event-scoped endpoint, since the event is already implicit.
  @JsonKey(name: 'eventTitle', fromJson: parseStringOrNull)
  String? get eventTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'eventSlug', fromJson: parseStringOrNull)
  String? get eventSlug => throw _privateConstructorUsedError;
  @JsonKey(name: 'eventUuid', fromJson: parseStringOrNull)
  String? get eventUuid => throw _privateConstructorUsedError;
  ReviewEventDto? get event => throw _privateConstructorUsedError;
  @JsonKey(name: 'hasResponse', fromJson: parseBool)
  bool get hasResponse => throw _privateConstructorUsedError;
  @JsonKey(name: 'organizerResponse', fromJson: parseStringOrNull)
  String? get organizerResponse => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_vote', fromJson: parseBoolOrNull)
  bool? get userVote => throw _privateConstructorUsedError;
  @JsonKey(name: 'userVote', fromJson: parseBoolOrNull)
  bool? get userVoteCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
  String? get createdAtCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at_formatted', fromJson: parseString)
  String get createdAtFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
  String get createdAtFormattedCamel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewDtoCopyWith<ReviewDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewDtoCopyWith<$Res> {
  factory $ReviewDtoCopyWith(ReviewDto value, $Res Function(ReviewDto) then) =
      _$ReviewDtoCopyWithImpl<$Res, ReviewDto>;
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
      @JsonKey(name: 'helpfulness_percentage', fromJson: parseDouble)
      double helpfulnessPercentage,
      @JsonKey(name: 'helpfulnessPercentage', fromJson: parseDouble)
      double helpfulnessPercentageCamel,
      @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
      bool isVerifiedPurchase,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
      bool isVerifiedPurchaseCamel,
      @JsonKey(name: 'is_featured', fromJson: parseBool) bool isFeatured,
      @JsonKey(name: 'isFeatured', fromJson: parseBool) bool isFeaturedCamel,
      ReviewAuthorDto? author,
      ReviewResponseDto? response,
      @JsonKey(name: 'eventTitle', fromJson: parseStringOrNull)
      String? eventTitle,
      @JsonKey(name: 'eventSlug', fromJson: parseStringOrNull)
      String? eventSlug,
      @JsonKey(name: 'eventUuid', fromJson: parseStringOrNull)
      String? eventUuid,
      ReviewEventDto? event,
      @JsonKey(name: 'hasResponse', fromJson: parseBool) bool hasResponse,
      @JsonKey(name: 'organizerResponse', fromJson: parseStringOrNull)
      String? organizerResponse,
      @JsonKey(name: 'user_vote', fromJson: parseBoolOrNull) bool? userVote,
      @JsonKey(name: 'userVote', fromJson: parseBoolOrNull) bool? userVoteCamel,
      @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
      String? createdAt,
      @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
      String? createdAtCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
      String createdAtFormattedCamel});

  $ReviewAuthorDtoCopyWith<$Res>? get author;
  $ReviewResponseDtoCopyWith<$Res>? get response;
  $ReviewEventDtoCopyWith<$Res>? get event;
}

/// @nodoc
class _$ReviewDtoCopyWithImpl<$Res, $Val extends ReviewDto>
    implements $ReviewDtoCopyWith<$Res> {
  _$ReviewDtoCopyWithImpl(this._value, this._then);

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
    Object? helpfulnessPercentage = null,
    Object? helpfulnessPercentageCamel = null,
    Object? isVerifiedPurchase = null,
    Object? isVerifiedPurchaseCamel = null,
    Object? isFeatured = null,
    Object? isFeaturedCamel = null,
    Object? author = freezed,
    Object? response = freezed,
    Object? eventTitle = freezed,
    Object? eventSlug = freezed,
    Object? eventUuid = freezed,
    Object? event = freezed,
    Object? hasResponse = null,
    Object? organizerResponse = freezed,
    Object? userVote = freezed,
    Object? userVoteCamel = freezed,
    Object? createdAt = freezed,
    Object? createdAtCamel = freezed,
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
      helpfulnessPercentage: null == helpfulnessPercentage
          ? _value.helpfulnessPercentage
          : helpfulnessPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      helpfulnessPercentageCamel: null == helpfulnessPercentageCamel
          ? _value.helpfulnessPercentageCamel
          : helpfulnessPercentageCamel // ignore: cast_nullable_to_non_nullable
              as double,
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
      eventTitle: freezed == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      eventSlug: freezed == eventSlug
          ? _value.eventSlug
          : eventSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      eventUuid: freezed == eventUuid
          ? _value.eventUuid
          : eventUuid // ignore: cast_nullable_to_non_nullable
              as String?,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as ReviewEventDto?,
      hasResponse: null == hasResponse
          ? _value.hasResponse
          : hasResponse // ignore: cast_nullable_to_non_nullable
              as bool,
      organizerResponse: freezed == organizerResponse
          ? _value.organizerResponse
          : organizerResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      userVote: freezed == userVote
          ? _value.userVote
          : userVote // ignore: cast_nullable_to_non_nullable
              as bool?,
      userVoteCamel: freezed == userVoteCamel
          ? _value.userVoteCamel
          : userVoteCamel // ignore: cast_nullable_to_non_nullable
              as bool?,
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

  @override
  @pragma('vm:prefer-inline')
  $ReviewEventDtoCopyWith<$Res>? get event {
    if (_value.event == null) {
      return null;
    }

    return $ReviewEventDtoCopyWith<$Res>(_value.event!, (value) {
      return _then(_value.copyWith(event: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReviewDtoImplCopyWith<$Res>
    implements $ReviewDtoCopyWith<$Res> {
  factory _$$ReviewDtoImplCopyWith(
          _$ReviewDtoImpl value, $Res Function(_$ReviewDtoImpl) then) =
      __$$ReviewDtoImplCopyWithImpl<$Res>;
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
      @JsonKey(name: 'helpfulness_percentage', fromJson: parseDouble)
      double helpfulnessPercentage,
      @JsonKey(name: 'helpfulnessPercentage', fromJson: parseDouble)
      double helpfulnessPercentageCamel,
      @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
      bool isVerifiedPurchase,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
      bool isVerifiedPurchaseCamel,
      @JsonKey(name: 'is_featured', fromJson: parseBool) bool isFeatured,
      @JsonKey(name: 'isFeatured', fromJson: parseBool) bool isFeaturedCamel,
      ReviewAuthorDto? author,
      ReviewResponseDto? response,
      @JsonKey(name: 'eventTitle', fromJson: parseStringOrNull)
      String? eventTitle,
      @JsonKey(name: 'eventSlug', fromJson: parseStringOrNull)
      String? eventSlug,
      @JsonKey(name: 'eventUuid', fromJson: parseStringOrNull)
      String? eventUuid,
      ReviewEventDto? event,
      @JsonKey(name: 'hasResponse', fromJson: parseBool) bool hasResponse,
      @JsonKey(name: 'organizerResponse', fromJson: parseStringOrNull)
      String? organizerResponse,
      @JsonKey(name: 'user_vote', fromJson: parseBoolOrNull) bool? userVote,
      @JsonKey(name: 'userVote', fromJson: parseBoolOrNull) bool? userVoteCamel,
      @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
      String? createdAt,
      @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
      String? createdAtCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
      String createdAtFormattedCamel});

  @override
  $ReviewAuthorDtoCopyWith<$Res>? get author;
  @override
  $ReviewResponseDtoCopyWith<$Res>? get response;
  @override
  $ReviewEventDtoCopyWith<$Res>? get event;
}

/// @nodoc
class __$$ReviewDtoImplCopyWithImpl<$Res>
    extends _$ReviewDtoCopyWithImpl<$Res, _$ReviewDtoImpl>
    implements _$$ReviewDtoImplCopyWith<$Res> {
  __$$ReviewDtoImplCopyWithImpl(
      _$ReviewDtoImpl _value, $Res Function(_$ReviewDtoImpl) _then)
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
    Object? helpfulnessPercentage = null,
    Object? helpfulnessPercentageCamel = null,
    Object? isVerifiedPurchase = null,
    Object? isVerifiedPurchaseCamel = null,
    Object? isFeatured = null,
    Object? isFeaturedCamel = null,
    Object? author = freezed,
    Object? response = freezed,
    Object? eventTitle = freezed,
    Object? eventSlug = freezed,
    Object? eventUuid = freezed,
    Object? event = freezed,
    Object? hasResponse = null,
    Object? organizerResponse = freezed,
    Object? userVote = freezed,
    Object? userVoteCamel = freezed,
    Object? createdAt = freezed,
    Object? createdAtCamel = freezed,
    Object? createdAtFormatted = null,
    Object? createdAtFormattedCamel = null,
  }) {
    return _then(_$ReviewDtoImpl(
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
      helpfulnessPercentage: null == helpfulnessPercentage
          ? _value.helpfulnessPercentage
          : helpfulnessPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      helpfulnessPercentageCamel: null == helpfulnessPercentageCamel
          ? _value.helpfulnessPercentageCamel
          : helpfulnessPercentageCamel // ignore: cast_nullable_to_non_nullable
              as double,
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
      eventTitle: freezed == eventTitle
          ? _value.eventTitle
          : eventTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      eventSlug: freezed == eventSlug
          ? _value.eventSlug
          : eventSlug // ignore: cast_nullable_to_non_nullable
              as String?,
      eventUuid: freezed == eventUuid
          ? _value.eventUuid
          : eventUuid // ignore: cast_nullable_to_non_nullable
              as String?,
      event: freezed == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as ReviewEventDto?,
      hasResponse: null == hasResponse
          ? _value.hasResponse
          : hasResponse // ignore: cast_nullable_to_non_nullable
              as bool,
      organizerResponse: freezed == organizerResponse
          ? _value.organizerResponse
          : organizerResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      userVote: freezed == userVote
          ? _value.userVote
          : userVote // ignore: cast_nullable_to_non_nullable
              as bool?,
      userVoteCamel: freezed == userVoteCamel
          ? _value.userVoteCamel
          : userVoteCamel // ignore: cast_nullable_to_non_nullable
              as bool?,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewDtoImpl implements _ReviewDto {
  const _$ReviewDtoImpl(
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
      @JsonKey(name: 'helpfulness_percentage', fromJson: parseDouble)
      this.helpfulnessPercentage = 0,
      @JsonKey(name: 'helpfulnessPercentage', fromJson: parseDouble)
      this.helpfulnessPercentageCamel = 0,
      @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
      this.isVerifiedPurchase = false,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
      this.isVerifiedPurchaseCamel = false,
      @JsonKey(name: 'is_featured', fromJson: parseBool)
      this.isFeatured = false,
      @JsonKey(name: 'isFeatured', fromJson: parseBool)
      this.isFeaturedCamel = false,
      this.author,
      this.response,
      @JsonKey(name: 'eventTitle', fromJson: parseStringOrNull) this.eventTitle,
      @JsonKey(name: 'eventSlug', fromJson: parseStringOrNull) this.eventSlug,
      @JsonKey(name: 'eventUuid', fromJson: parseStringOrNull) this.eventUuid,
      this.event,
      @JsonKey(name: 'hasResponse', fromJson: parseBool)
      this.hasResponse = false,
      @JsonKey(name: 'organizerResponse', fromJson: parseStringOrNull)
      this.organizerResponse,
      @JsonKey(name: 'user_vote', fromJson: parseBoolOrNull) this.userVote,
      @JsonKey(name: 'userVote', fromJson: parseBoolOrNull) this.userVoteCamel,
      @JsonKey(name: 'created_at', fromJson: parseStringOrNull) this.createdAt,
      @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
      this.createdAtCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: parseString)
      this.createdAtFormatted = '',
      @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
      this.createdAtFormattedCamel = ''});

  factory _$ReviewDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewDtoImplFromJson(json);

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
  @JsonKey(name: 'helpfulness_percentage', fromJson: parseDouble)
  final double helpfulnessPercentage;
  @override
  @JsonKey(name: 'helpfulnessPercentage', fromJson: parseDouble)
  final double helpfulnessPercentageCamel;
  @override
  @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
  final bool isVerifiedPurchase;
  @override
  @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
  final bool isVerifiedPurchaseCamel;
  @override
  @JsonKey(name: 'is_featured', fromJson: parseBool)
  final bool isFeatured;
  @override
  @JsonKey(name: 'isFeatured', fromJson: parseBool)
  final bool isFeaturedCamel;
  @override
  final ReviewAuthorDto? author;
  @override
  final ReviewResponseDto? response;
// Event context — populated by the organizer-scoped reviews endpoint
// (`GET /organizers/{id}/reviews`); null when the review is fetched
// from the event-scoped endpoint, since the event is already implicit.
  @override
  @JsonKey(name: 'eventTitle', fromJson: parseStringOrNull)
  final String? eventTitle;
  @override
  @JsonKey(name: 'eventSlug', fromJson: parseStringOrNull)
  final String? eventSlug;
  @override
  @JsonKey(name: 'eventUuid', fromJson: parseStringOrNull)
  final String? eventUuid;
  @override
  final ReviewEventDto? event;
  @override
  @JsonKey(name: 'hasResponse', fromJson: parseBool)
  final bool hasResponse;
  @override
  @JsonKey(name: 'organizerResponse', fromJson: parseStringOrNull)
  final String? organizerResponse;
  @override
  @JsonKey(name: 'user_vote', fromJson: parseBoolOrNull)
  final bool? userVote;
  @override
  @JsonKey(name: 'userVote', fromJson: parseBoolOrNull)
  final bool? userVoteCamel;
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
  String toString() {
    return 'ReviewDto(uuid: $uuid, rating: $rating, title: $title, comment: $comment, status: $status, helpfulCount: $helpfulCount, helpfulCountCamel: $helpfulCountCamel, notHelpfulCount: $notHelpfulCount, notHelpfulCountCamel: $notHelpfulCountCamel, helpfulnessPercentage: $helpfulnessPercentage, helpfulnessPercentageCamel: $helpfulnessPercentageCamel, isVerifiedPurchase: $isVerifiedPurchase, isVerifiedPurchaseCamel: $isVerifiedPurchaseCamel, isFeatured: $isFeatured, isFeaturedCamel: $isFeaturedCamel, author: $author, response: $response, eventTitle: $eventTitle, eventSlug: $eventSlug, eventUuid: $eventUuid, event: $event, hasResponse: $hasResponse, organizerResponse: $organizerResponse, userVote: $userVote, userVoteCamel: $userVoteCamel, createdAt: $createdAt, createdAtCamel: $createdAtCamel, createdAtFormatted: $createdAtFormatted, createdAtFormattedCamel: $createdAtFormattedCamel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewDtoImpl &&
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
            (identical(other.helpfulnessPercentage, helpfulnessPercentage) ||
                other.helpfulnessPercentage == helpfulnessPercentage) &&
            (identical(other.helpfulnessPercentageCamel,
                    helpfulnessPercentageCamel) ||
                other.helpfulnessPercentageCamel ==
                    helpfulnessPercentageCamel) &&
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
            (identical(other.eventTitle, eventTitle) ||
                other.eventTitle == eventTitle) &&
            (identical(other.eventSlug, eventSlug) ||
                other.eventSlug == eventSlug) &&
            (identical(other.eventUuid, eventUuid) ||
                other.eventUuid == eventUuid) &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.hasResponse, hasResponse) ||
                other.hasResponse == hasResponse) &&
            (identical(other.organizerResponse, organizerResponse) ||
                other.organizerResponse == organizerResponse) &&
            (identical(other.userVote, userVote) ||
                other.userVote == userVote) &&
            (identical(other.userVoteCamel, userVoteCamel) ||
                other.userVoteCamel == userVoteCamel) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdAtCamel, createdAtCamel) ||
                other.createdAtCamel == createdAtCamel) &&
            (identical(other.createdAtFormatted, createdAtFormatted) ||
                other.createdAtFormatted == createdAtFormatted) &&
            (identical(
                    other.createdAtFormattedCamel, createdAtFormattedCamel) ||
                other.createdAtFormattedCamel == createdAtFormattedCamel));
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
        helpfulnessPercentage,
        helpfulnessPercentageCamel,
        isVerifiedPurchase,
        isVerifiedPurchaseCamel,
        isFeatured,
        isFeaturedCamel,
        author,
        response,
        eventTitle,
        eventSlug,
        eventUuid,
        event,
        hasResponse,
        organizerResponse,
        userVote,
        userVoteCamel,
        createdAt,
        createdAtCamel,
        createdAtFormatted,
        createdAtFormattedCamel
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewDtoImplCopyWith<_$ReviewDtoImpl> get copyWith =>
      __$$ReviewDtoImplCopyWithImpl<_$ReviewDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewDtoImplToJson(
      this,
    );
  }
}

abstract class _ReviewDto implements ReviewDto {
  const factory _ReviewDto(
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
      @JsonKey(name: 'helpfulness_percentage', fromJson: parseDouble)
      final double helpfulnessPercentage,
      @JsonKey(name: 'helpfulnessPercentage', fromJson: parseDouble)
      final double helpfulnessPercentageCamel,
      @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
      final bool isVerifiedPurchase,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
      final bool isVerifiedPurchaseCamel,
      @JsonKey(name: 'is_featured', fromJson: parseBool) final bool isFeatured,
      @JsonKey(name: 'isFeatured', fromJson: parseBool)
      final bool isFeaturedCamel,
      final ReviewAuthorDto? author,
      final ReviewResponseDto? response,
      @JsonKey(name: 'eventTitle', fromJson: parseStringOrNull)
      final String? eventTitle,
      @JsonKey(name: 'eventSlug', fromJson: parseStringOrNull)
      final String? eventSlug,
      @JsonKey(name: 'eventUuid', fromJson: parseStringOrNull)
      final String? eventUuid,
      final ReviewEventDto? event,
      @JsonKey(name: 'hasResponse', fromJson: parseBool) final bool hasResponse,
      @JsonKey(name: 'organizerResponse', fromJson: parseStringOrNull)
      final String? organizerResponse,
      @JsonKey(name: 'user_vote', fromJson: parseBoolOrNull)
      final bool? userVote,
      @JsonKey(name: 'userVote', fromJson: parseBoolOrNull)
      final bool? userVoteCamel,
      @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
      final String? createdAt,
      @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
      final String? createdAtCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: parseString)
      final String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
      final String createdAtFormattedCamel}) = _$ReviewDtoImpl;

  factory _ReviewDto.fromJson(Map<String, dynamic> json) =
      _$ReviewDtoImpl.fromJson;

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
  @JsonKey(name: 'helpfulness_percentage', fromJson: parseDouble)
  double get helpfulnessPercentage;
  @override
  @JsonKey(name: 'helpfulnessPercentage', fromJson: parseDouble)
  double get helpfulnessPercentageCamel;
  @override
  @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
  bool get isVerifiedPurchase;
  @override
  @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
  bool get isVerifiedPurchaseCamel;
  @override
  @JsonKey(name: 'is_featured', fromJson: parseBool)
  bool get isFeatured;
  @override
  @JsonKey(name: 'isFeatured', fromJson: parseBool)
  bool get isFeaturedCamel;
  @override
  ReviewAuthorDto? get author;
  @override
  ReviewResponseDto? get response;
  @override // Event context — populated by the organizer-scoped reviews endpoint
// (`GET /organizers/{id}/reviews`); null when the review is fetched
// from the event-scoped endpoint, since the event is already implicit.
  @JsonKey(name: 'eventTitle', fromJson: parseStringOrNull)
  String? get eventTitle;
  @override
  @JsonKey(name: 'eventSlug', fromJson: parseStringOrNull)
  String? get eventSlug;
  @override
  @JsonKey(name: 'eventUuid', fromJson: parseStringOrNull)
  String? get eventUuid;
  @override
  ReviewEventDto? get event;
  @override
  @JsonKey(name: 'hasResponse', fromJson: parseBool)
  bool get hasResponse;
  @override
  @JsonKey(name: 'organizerResponse', fromJson: parseStringOrNull)
  String? get organizerResponse;
  @override
  @JsonKey(name: 'user_vote', fromJson: parseBoolOrNull)
  bool? get userVote;
  @override
  @JsonKey(name: 'userVote', fromJson: parseBoolOrNull)
  bool? get userVoteCamel;
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
  @JsonKey(ignore: true)
  _$$ReviewDtoImplCopyWith<_$ReviewDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewAuthorDto _$ReviewAuthorDtoFromJson(Map<String, dynamic> json) {
  return _ReviewAuthorDto.fromJson(json);
}

/// @nodoc
mixin _$ReviewAuthorDto {
  @JsonKey(fromJson: parseString)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name', fromJson: parseStringOrNull)
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'firstName', fromJson: parseStringOrNull)
  String? get firstNameCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name', fromJson: parseStringOrNull)
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'lastName', fromJson: parseStringOrNull)
  String? get lastNameCamel => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseStringOrNull)
  String? get avatar => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseString)
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
      {@JsonKey(fromJson: parseString) String name,
      @JsonKey(name: 'first_name', fromJson: parseStringOrNull)
      String? firstName,
      @JsonKey(name: 'firstName', fromJson: parseStringOrNull)
      String? firstNameCamel,
      @JsonKey(name: 'last_name', fromJson: parseStringOrNull) String? lastName,
      @JsonKey(name: 'lastName', fromJson: parseStringOrNull)
      String? lastNameCamel,
      @JsonKey(fromJson: parseStringOrNull) String? avatar,
      @JsonKey(fromJson: parseString) String initials});
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
    Object? firstName = freezed,
    Object? firstNameCamel = freezed,
    Object? lastName = freezed,
    Object? lastNameCamel = freezed,
    Object? avatar = freezed,
    Object? initials = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      firstNameCamel: freezed == firstNameCamel
          ? _value.firstNameCamel
          : firstNameCamel // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastNameCamel: freezed == lastNameCamel
          ? _value.lastNameCamel
          : lastNameCamel // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {@JsonKey(fromJson: parseString) String name,
      @JsonKey(name: 'first_name', fromJson: parseStringOrNull)
      String? firstName,
      @JsonKey(name: 'firstName', fromJson: parseStringOrNull)
      String? firstNameCamel,
      @JsonKey(name: 'last_name', fromJson: parseStringOrNull) String? lastName,
      @JsonKey(name: 'lastName', fromJson: parseStringOrNull)
      String? lastNameCamel,
      @JsonKey(fromJson: parseStringOrNull) String? avatar,
      @JsonKey(fromJson: parseString) String initials});
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
    Object? firstName = freezed,
    Object? firstNameCamel = freezed,
    Object? lastName = freezed,
    Object? lastNameCamel = freezed,
    Object? avatar = freezed,
    Object? initials = null,
  }) {
    return _then(_$ReviewAuthorDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      firstNameCamel: freezed == firstNameCamel
          ? _value.firstNameCamel
          : firstNameCamel // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastNameCamel: freezed == lastNameCamel
          ? _value.lastNameCamel
          : lastNameCamel // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {@JsonKey(fromJson: parseString) this.name = '',
      @JsonKey(name: 'first_name', fromJson: parseStringOrNull) this.firstName,
      @JsonKey(name: 'firstName', fromJson: parseStringOrNull)
      this.firstNameCamel,
      @JsonKey(name: 'last_name', fromJson: parseStringOrNull) this.lastName,
      @JsonKey(name: 'lastName', fromJson: parseStringOrNull)
      this.lastNameCamel,
      @JsonKey(fromJson: parseStringOrNull) this.avatar,
      @JsonKey(fromJson: parseString) this.initials = ''});

  factory _$ReviewAuthorDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewAuthorDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: parseString)
  final String name;
  @override
  @JsonKey(name: 'first_name', fromJson: parseStringOrNull)
  final String? firstName;
  @override
  @JsonKey(name: 'firstName', fromJson: parseStringOrNull)
  final String? firstNameCamel;
  @override
  @JsonKey(name: 'last_name', fromJson: parseStringOrNull)
  final String? lastName;
  @override
  @JsonKey(name: 'lastName', fromJson: parseStringOrNull)
  final String? lastNameCamel;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  final String? avatar;
  @override
  @JsonKey(fromJson: parseString)
  final String initials;

  @override
  String toString() {
    return 'ReviewAuthorDto(name: $name, firstName: $firstName, firstNameCamel: $firstNameCamel, lastName: $lastName, lastNameCamel: $lastNameCamel, avatar: $avatar, initials: $initials)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewAuthorDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.firstNameCamel, firstNameCamel) ||
                other.firstNameCamel == firstNameCamel) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.lastNameCamel, lastNameCamel) ||
                other.lastNameCamel == lastNameCamel) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.initials, initials) ||
                other.initials == initials));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, firstName, firstNameCamel,
      lastName, lastNameCamel, avatar, initials);

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
          {@JsonKey(fromJson: parseString) final String name,
          @JsonKey(name: 'first_name', fromJson: parseStringOrNull)
          final String? firstName,
          @JsonKey(name: 'firstName', fromJson: parseStringOrNull)
          final String? firstNameCamel,
          @JsonKey(name: 'last_name', fromJson: parseStringOrNull)
          final String? lastName,
          @JsonKey(name: 'lastName', fromJson: parseStringOrNull)
          final String? lastNameCamel,
          @JsonKey(fromJson: parseStringOrNull) final String? avatar,
          @JsonKey(fromJson: parseString) final String initials}) =
      _$ReviewAuthorDtoImpl;

  factory _ReviewAuthorDto.fromJson(Map<String, dynamic> json) =
      _$ReviewAuthorDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: parseString)
  String get name;
  @override
  @JsonKey(name: 'first_name', fromJson: parseStringOrNull)
  String? get firstName;
  @override
  @JsonKey(name: 'firstName', fromJson: parseStringOrNull)
  String? get firstNameCamel;
  @override
  @JsonKey(name: 'last_name', fromJson: parseStringOrNull)
  String? get lastName;
  @override
  @JsonKey(name: 'lastName', fromJson: parseStringOrNull)
  String? get lastNameCamel;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  String? get avatar;
  @override
  @JsonKey(fromJson: parseString)
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
  @JsonKey(fromJson: parseString)
  String get response => throw _privateConstructorUsedError;
  @JsonKey(name: 'organization_name', fromJson: parseString)
  String get organizationName => throw _privateConstructorUsedError;
  @JsonKey(name: 'organizationName', fromJson: parseString)
  String get organizationNameCamel => throw _privateConstructorUsedError;
  ReviewOrganizationDto? get organization => throw _privateConstructorUsedError;
  ReviewResponseAuthorDto? get author => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
  String? get createdAtCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at_formatted', fromJson: parseString)
  String get createdAtFormatted => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
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
      @JsonKey(fromJson: parseString) String response,
      @JsonKey(name: 'organization_name', fromJson: parseString)
      String organizationName,
      @JsonKey(name: 'organizationName', fromJson: parseString)
      String organizationNameCamel,
      ReviewOrganizationDto? organization,
      ReviewResponseAuthorDto? author,
      @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
      String? createdAt,
      @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
      String? createdAtCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
      String createdAtFormattedCamel});

  $ReviewOrganizationDtoCopyWith<$Res>? get organization;
  $ReviewResponseAuthorDtoCopyWith<$Res>? get author;
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
    Object? organization = freezed,
    Object? author = freezed,
    Object? createdAt = freezed,
    Object? createdAtCamel = freezed,
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
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as ReviewOrganizationDto?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as ReviewResponseAuthorDto?,
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
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ReviewOrganizationDtoCopyWith<$Res>? get organization {
    if (_value.organization == null) {
      return null;
    }

    return $ReviewOrganizationDtoCopyWith<$Res>(_value.organization!, (value) {
      return _then(_value.copyWith(organization: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ReviewResponseAuthorDtoCopyWith<$Res>? get author {
    if (_value.author == null) {
      return null;
    }

    return $ReviewResponseAuthorDtoCopyWith<$Res>(_value.author!, (value) {
      return _then(_value.copyWith(author: value) as $Val);
    });
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
      @JsonKey(fromJson: parseString) String response,
      @JsonKey(name: 'organization_name', fromJson: parseString)
      String organizationName,
      @JsonKey(name: 'organizationName', fromJson: parseString)
      String organizationNameCamel,
      ReviewOrganizationDto? organization,
      ReviewResponseAuthorDto? author,
      @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
      String? createdAt,
      @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
      String? createdAtCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: parseString)
      String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
      String createdAtFormattedCamel});

  @override
  $ReviewOrganizationDtoCopyWith<$Res>? get organization;
  @override
  $ReviewResponseAuthorDtoCopyWith<$Res>? get author;
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
    Object? organization = freezed,
    Object? author = freezed,
    Object? createdAt = freezed,
    Object? createdAtCamel = freezed,
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
      organization: freezed == organization
          ? _value.organization
          : organization // ignore: cast_nullable_to_non_nullable
              as ReviewOrganizationDto?,
      author: freezed == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as ReviewResponseAuthorDto?,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewResponseDtoImpl implements _ReviewResponseDto {
  const _$ReviewResponseDtoImpl(
      {required this.uuid,
      @JsonKey(fromJson: parseString) this.response = '',
      @JsonKey(name: 'organization_name', fromJson: parseString)
      this.organizationName = '',
      @JsonKey(name: 'organizationName', fromJson: parseString)
      this.organizationNameCamel = '',
      this.organization,
      this.author,
      @JsonKey(name: 'created_at', fromJson: parseStringOrNull) this.createdAt,
      @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
      this.createdAtCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: parseString)
      this.createdAtFormatted = '',
      @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
      this.createdAtFormattedCamel = ''});

  factory _$ReviewResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewResponseDtoImplFromJson(json);

  @override
  final String uuid;
  @override
  @JsonKey(fromJson: parseString)
  final String response;
  @override
  @JsonKey(name: 'organization_name', fromJson: parseString)
  final String organizationName;
  @override
  @JsonKey(name: 'organizationName', fromJson: parseString)
  final String organizationNameCamel;
  @override
  final ReviewOrganizationDto? organization;
  @override
  final ReviewResponseAuthorDto? author;
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
  String toString() {
    return 'ReviewResponseDto(uuid: $uuid, response: $response, organizationName: $organizationName, organizationNameCamel: $organizationNameCamel, organization: $organization, author: $author, createdAt: $createdAt, createdAtCamel: $createdAtCamel, createdAtFormatted: $createdAtFormatted, createdAtFormattedCamel: $createdAtFormattedCamel)';
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
            (identical(other.organization, organization) ||
                other.organization == organization) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdAtCamel, createdAtCamel) ||
                other.createdAtCamel == createdAtCamel) &&
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
      response,
      organizationName,
      organizationNameCamel,
      organization,
      author,
      createdAt,
      createdAtCamel,
      createdAtFormatted,
      createdAtFormattedCamel);

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
      @JsonKey(fromJson: parseString) final String response,
      @JsonKey(name: 'organization_name', fromJson: parseString)
      final String organizationName,
      @JsonKey(name: 'organizationName', fromJson: parseString)
      final String organizationNameCamel,
      final ReviewOrganizationDto? organization,
      final ReviewResponseAuthorDto? author,
      @JsonKey(name: 'created_at', fromJson: parseStringOrNull)
      final String? createdAt,
      @JsonKey(name: 'createdAt', fromJson: parseStringOrNull)
      final String? createdAtCamel,
      @JsonKey(name: 'created_at_formatted', fromJson: parseString)
      final String createdAtFormatted,
      @JsonKey(name: 'createdAtFormatted', fromJson: parseString)
      final String createdAtFormattedCamel}) = _$ReviewResponseDtoImpl;

  factory _ReviewResponseDto.fromJson(Map<String, dynamic> json) =
      _$ReviewResponseDtoImpl.fromJson;

  @override
  String get uuid;
  @override
  @JsonKey(fromJson: parseString)
  String get response;
  @override
  @JsonKey(name: 'organization_name', fromJson: parseString)
  String get organizationName;
  @override
  @JsonKey(name: 'organizationName', fromJson: parseString)
  String get organizationNameCamel;
  @override
  ReviewOrganizationDto? get organization;
  @override
  ReviewResponseAuthorDto? get author;
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
  @JsonKey(ignore: true)
  _$$ReviewResponseDtoImplCopyWith<_$ReviewResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewEventDto _$ReviewEventDtoFromJson(Map<String, dynamic> json) {
  return _ReviewEventDto.fromJson(json);
}

/// @nodoc
mixin _$ReviewEventDto {
  @JsonKey(fromJson: parseInt)
  int get id => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseStringOrNull)
  String? get uuid => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseString)
  String get title => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseString)
  String get slug => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewEventDtoCopyWith<ReviewEventDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewEventDtoCopyWith<$Res> {
  factory $ReviewEventDtoCopyWith(
          ReviewEventDto value, $Res Function(ReviewEventDto) then) =
      _$ReviewEventDtoCopyWithImpl<$Res, ReviewEventDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: parseInt) int id,
      @JsonKey(fromJson: parseStringOrNull) String? uuid,
      @JsonKey(fromJson: parseString) String title,
      @JsonKey(fromJson: parseString) String slug});
}

/// @nodoc
class _$ReviewEventDtoCopyWithImpl<$Res, $Val extends ReviewEventDto>
    implements $ReviewEventDtoCopyWith<$Res> {
  _$ReviewEventDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = freezed,
    Object? title = null,
    Object? slug = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewEventDtoImplCopyWith<$Res>
    implements $ReviewEventDtoCopyWith<$Res> {
  factory _$$ReviewEventDtoImplCopyWith(_$ReviewEventDtoImpl value,
          $Res Function(_$ReviewEventDtoImpl) then) =
      __$$ReviewEventDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: parseInt) int id,
      @JsonKey(fromJson: parseStringOrNull) String? uuid,
      @JsonKey(fromJson: parseString) String title,
      @JsonKey(fromJson: parseString) String slug});
}

/// @nodoc
class __$$ReviewEventDtoImplCopyWithImpl<$Res>
    extends _$ReviewEventDtoCopyWithImpl<$Res, _$ReviewEventDtoImpl>
    implements _$$ReviewEventDtoImplCopyWith<$Res> {
  __$$ReviewEventDtoImplCopyWithImpl(
      _$ReviewEventDtoImpl _value, $Res Function(_$ReviewEventDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = freezed,
    Object? title = null,
    Object? slug = null,
  }) {
    return _then(_$ReviewEventDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewEventDtoImpl implements _ReviewEventDto {
  const _$ReviewEventDtoImpl(
      {@JsonKey(fromJson: parseInt) this.id = 0,
      @JsonKey(fromJson: parseStringOrNull) this.uuid,
      @JsonKey(fromJson: parseString) this.title = '',
      @JsonKey(fromJson: parseString) this.slug = ''});

  factory _$ReviewEventDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewEventDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: parseInt)
  final int id;
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
  String toString() {
    return 'ReviewEventDto(id: $id, uuid: $uuid, title: $title, slug: $slug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewEventDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, uuid, title, slug);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewEventDtoImplCopyWith<_$ReviewEventDtoImpl> get copyWith =>
      __$$ReviewEventDtoImplCopyWithImpl<_$ReviewEventDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewEventDtoImplToJson(
      this,
    );
  }
}

abstract class _ReviewEventDto implements ReviewEventDto {
  const factory _ReviewEventDto(
          {@JsonKey(fromJson: parseInt) final int id,
          @JsonKey(fromJson: parseStringOrNull) final String? uuid,
          @JsonKey(fromJson: parseString) final String title,
          @JsonKey(fromJson: parseString) final String slug}) =
      _$ReviewEventDtoImpl;

  factory _ReviewEventDto.fromJson(Map<String, dynamic> json) =
      _$ReviewEventDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: parseInt)
  int get id;
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
  @JsonKey(ignore: true)
  _$$ReviewEventDtoImplCopyWith<_$ReviewEventDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewOrganizationDto _$ReviewOrganizationDtoFromJson(
    Map<String, dynamic> json) {
  return _ReviewOrganizationDto.fromJson(json);
}

/// @nodoc
mixin _$ReviewOrganizationDto {
  @JsonKey(fromJson: parseString)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseStringOrNull)
  String? get logo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewOrganizationDtoCopyWith<ReviewOrganizationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewOrganizationDtoCopyWith<$Res> {
  factory $ReviewOrganizationDtoCopyWith(ReviewOrganizationDto value,
          $Res Function(ReviewOrganizationDto) then) =
      _$ReviewOrganizationDtoCopyWithImpl<$Res, ReviewOrganizationDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: parseString) String name,
      @JsonKey(fromJson: parseStringOrNull) String? logo});
}

/// @nodoc
class _$ReviewOrganizationDtoCopyWithImpl<$Res,
        $Val extends ReviewOrganizationDto>
    implements $ReviewOrganizationDtoCopyWith<$Res> {
  _$ReviewOrganizationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? logo = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewOrganizationDtoImplCopyWith<$Res>
    implements $ReviewOrganizationDtoCopyWith<$Res> {
  factory _$$ReviewOrganizationDtoImplCopyWith(
          _$ReviewOrganizationDtoImpl value,
          $Res Function(_$ReviewOrganizationDtoImpl) then) =
      __$$ReviewOrganizationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: parseString) String name,
      @JsonKey(fromJson: parseStringOrNull) String? logo});
}

/// @nodoc
class __$$ReviewOrganizationDtoImplCopyWithImpl<$Res>
    extends _$ReviewOrganizationDtoCopyWithImpl<$Res,
        _$ReviewOrganizationDtoImpl>
    implements _$$ReviewOrganizationDtoImplCopyWith<$Res> {
  __$$ReviewOrganizationDtoImplCopyWithImpl(_$ReviewOrganizationDtoImpl _value,
      $Res Function(_$ReviewOrganizationDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? logo = freezed,
  }) {
    return _then(_$ReviewOrganizationDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      logo: freezed == logo
          ? _value.logo
          : logo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewOrganizationDtoImpl implements _ReviewOrganizationDto {
  const _$ReviewOrganizationDtoImpl(
      {@JsonKey(fromJson: parseString) this.name = '',
      @JsonKey(fromJson: parseStringOrNull) this.logo});

  factory _$ReviewOrganizationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewOrganizationDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: parseString)
  final String name;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  final String? logo;

  @override
  String toString() {
    return 'ReviewOrganizationDto(name: $name, logo: $logo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewOrganizationDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.logo, logo) || other.logo == logo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, logo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewOrganizationDtoImplCopyWith<_$ReviewOrganizationDtoImpl>
      get copyWith => __$$ReviewOrganizationDtoImplCopyWithImpl<
          _$ReviewOrganizationDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewOrganizationDtoImplToJson(
      this,
    );
  }
}

abstract class _ReviewOrganizationDto implements ReviewOrganizationDto {
  const factory _ReviewOrganizationDto(
          {@JsonKey(fromJson: parseString) final String name,
          @JsonKey(fromJson: parseStringOrNull) final String? logo}) =
      _$ReviewOrganizationDtoImpl;

  factory _ReviewOrganizationDto.fromJson(Map<String, dynamic> json) =
      _$ReviewOrganizationDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: parseString)
  String get name;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  String? get logo;
  @override
  @JsonKey(ignore: true)
  _$$ReviewOrganizationDtoImplCopyWith<_$ReviewOrganizationDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReviewResponseAuthorDto _$ReviewResponseAuthorDtoFromJson(
    Map<String, dynamic> json) {
  return _ReviewResponseAuthorDto.fromJson(json);
}

/// @nodoc
mixin _$ReviewResponseAuthorDto {
  @JsonKey(fromJson: parseString)
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseStringOrNull)
  String? get avatar => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewResponseAuthorDtoCopyWith<ReviewResponseAuthorDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewResponseAuthorDtoCopyWith<$Res> {
  factory $ReviewResponseAuthorDtoCopyWith(ReviewResponseAuthorDto value,
          $Res Function(ReviewResponseAuthorDto) then) =
      _$ReviewResponseAuthorDtoCopyWithImpl<$Res, ReviewResponseAuthorDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: parseString) String name,
      @JsonKey(fromJson: parseStringOrNull) String? avatar});
}

/// @nodoc
class _$ReviewResponseAuthorDtoCopyWithImpl<$Res,
        $Val extends ReviewResponseAuthorDto>
    implements $ReviewResponseAuthorDtoCopyWith<$Res> {
  _$ReviewResponseAuthorDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? avatar = freezed,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewResponseAuthorDtoImplCopyWith<$Res>
    implements $ReviewResponseAuthorDtoCopyWith<$Res> {
  factory _$$ReviewResponseAuthorDtoImplCopyWith(
          _$ReviewResponseAuthorDtoImpl value,
          $Res Function(_$ReviewResponseAuthorDtoImpl) then) =
      __$$ReviewResponseAuthorDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: parseString) String name,
      @JsonKey(fromJson: parseStringOrNull) String? avatar});
}

/// @nodoc
class __$$ReviewResponseAuthorDtoImplCopyWithImpl<$Res>
    extends _$ReviewResponseAuthorDtoCopyWithImpl<$Res,
        _$ReviewResponseAuthorDtoImpl>
    implements _$$ReviewResponseAuthorDtoImplCopyWith<$Res> {
  __$$ReviewResponseAuthorDtoImplCopyWithImpl(
      _$ReviewResponseAuthorDtoImpl _value,
      $Res Function(_$ReviewResponseAuthorDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? avatar = freezed,
  }) {
    return _then(_$ReviewResponseAuthorDtoImpl(
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
class _$ReviewResponseAuthorDtoImpl implements _ReviewResponseAuthorDto {
  const _$ReviewResponseAuthorDtoImpl(
      {@JsonKey(fromJson: parseString) this.name = '',
      @JsonKey(fromJson: parseStringOrNull) this.avatar});

  factory _$ReviewResponseAuthorDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewResponseAuthorDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: parseString)
  final String name;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  final String? avatar;

  @override
  String toString() {
    return 'ReviewResponseAuthorDto(name: $name, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewResponseAuthorDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, avatar);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewResponseAuthorDtoImplCopyWith<_$ReviewResponseAuthorDtoImpl>
      get copyWith => __$$ReviewResponseAuthorDtoImplCopyWithImpl<
          _$ReviewResponseAuthorDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewResponseAuthorDtoImplToJson(
      this,
    );
  }
}

abstract class _ReviewResponseAuthorDto implements ReviewResponseAuthorDto {
  const factory _ReviewResponseAuthorDto(
          {@JsonKey(fromJson: parseString) final String name,
          @JsonKey(fromJson: parseStringOrNull) final String? avatar}) =
      _$ReviewResponseAuthorDtoImpl;

  factory _ReviewResponseAuthorDto.fromJson(Map<String, dynamic> json) =
      _$ReviewResponseAuthorDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: parseString)
  String get name;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  String? get avatar;
  @override
  @JsonKey(ignore: true)
  _$$ReviewResponseAuthorDtoImplCopyWith<_$ReviewResponseAuthorDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PaginationMetaDto _$PaginationMetaDtoFromJson(Map<String, dynamic> json) {
  return _PaginationMetaDto.fromJson(json);
}

/// @nodoc
mixin _$PaginationMetaDto {
  @JsonKey(name: 'current_page', fromJson: parseInt)
  int get currentPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_page', fromJson: parseInt)
  int get lastPage => throw _privateConstructorUsedError;
  @JsonKey(name: 'per_page', fromJson: parseInt)
  int get perPage => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseInt)
  int get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginationMetaDtoCopyWith<PaginationMetaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationMetaDtoCopyWith<$Res> {
  factory $PaginationMetaDtoCopyWith(
          PaginationMetaDto value, $Res Function(PaginationMetaDto) then) =
      _$PaginationMetaDtoCopyWithImpl<$Res, PaginationMetaDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page', fromJson: parseInt) int currentPage,
      @JsonKey(name: 'last_page', fromJson: parseInt) int lastPage,
      @JsonKey(name: 'per_page', fromJson: parseInt) int perPage,
      @JsonKey(fromJson: parseInt) int total});
}

/// @nodoc
class _$PaginationMetaDtoCopyWithImpl<$Res, $Val extends PaginationMetaDto>
    implements $PaginationMetaDtoCopyWith<$Res> {
  _$PaginationMetaDtoCopyWithImpl(this._value, this._then);

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
abstract class _$$PaginationMetaDtoImplCopyWith<$Res>
    implements $PaginationMetaDtoCopyWith<$Res> {
  factory _$$PaginationMetaDtoImplCopyWith(_$PaginationMetaDtoImpl value,
          $Res Function(_$PaginationMetaDtoImpl) then) =
      __$$PaginationMetaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'current_page', fromJson: parseInt) int currentPage,
      @JsonKey(name: 'last_page', fromJson: parseInt) int lastPage,
      @JsonKey(name: 'per_page', fromJson: parseInt) int perPage,
      @JsonKey(fromJson: parseInt) int total});
}

/// @nodoc
class __$$PaginationMetaDtoImplCopyWithImpl<$Res>
    extends _$PaginationMetaDtoCopyWithImpl<$Res, _$PaginationMetaDtoImpl>
    implements _$$PaginationMetaDtoImplCopyWith<$Res> {
  __$$PaginationMetaDtoImplCopyWithImpl(_$PaginationMetaDtoImpl _value,
      $Res Function(_$PaginationMetaDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPage = null,
    Object? lastPage = null,
    Object? perPage = null,
    Object? total = null,
  }) {
    return _then(_$PaginationMetaDtoImpl(
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
class _$PaginationMetaDtoImpl implements _PaginationMetaDto {
  const _$PaginationMetaDtoImpl(
      {@JsonKey(name: 'current_page', fromJson: parseInt) this.currentPage = 1,
      @JsonKey(name: 'last_page', fromJson: parseInt) this.lastPage = 1,
      @JsonKey(name: 'per_page', fromJson: parseInt) this.perPage = 10,
      @JsonKey(fromJson: parseInt) this.total = 0});

  factory _$PaginationMetaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginationMetaDtoImplFromJson(json);

  @override
  @JsonKey(name: 'current_page', fromJson: parseInt)
  final int currentPage;
  @override
  @JsonKey(name: 'last_page', fromJson: parseInt)
  final int lastPage;
  @override
  @JsonKey(name: 'per_page', fromJson: parseInt)
  final int perPage;
  @override
  @JsonKey(fromJson: parseInt)
  final int total;

  @override
  String toString() {
    return 'PaginationMetaDto(currentPage: $currentPage, lastPage: $lastPage, perPage: $perPage, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginationMetaDtoImpl &&
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
  _$$PaginationMetaDtoImplCopyWith<_$PaginationMetaDtoImpl> get copyWith =>
      __$$PaginationMetaDtoImplCopyWithImpl<_$PaginationMetaDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginationMetaDtoImplToJson(
      this,
    );
  }
}

abstract class _PaginationMetaDto implements PaginationMetaDto {
  const factory _PaginationMetaDto(
      {@JsonKey(name: 'current_page', fromJson: parseInt) final int currentPage,
      @JsonKey(name: 'last_page', fromJson: parseInt) final int lastPage,
      @JsonKey(name: 'per_page', fromJson: parseInt) final int perPage,
      @JsonKey(fromJson: parseInt) final int total}) = _$PaginationMetaDtoImpl;

  factory _PaginationMetaDto.fromJson(Map<String, dynamic> json) =
      _$PaginationMetaDtoImpl.fromJson;

  @override
  @JsonKey(name: 'current_page', fromJson: parseInt)
  int get currentPage;
  @override
  @JsonKey(name: 'last_page', fromJson: parseInt)
  int get lastPage;
  @override
  @JsonKey(name: 'per_page', fromJson: parseInt)
  int get perPage;
  @override
  @JsonKey(fromJson: parseInt)
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$PaginationMetaDtoImplCopyWith<_$PaginationMetaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

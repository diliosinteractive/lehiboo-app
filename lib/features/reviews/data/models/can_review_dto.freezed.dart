// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'can_review_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CanReviewDto _$CanReviewDtoFromJson(Map<String, dynamic> json) {
  return _CanReviewDto.fromJson(json);
}

/// @nodoc
mixin _$CanReviewDto {
  @JsonKey(name: 'can_review', fromJson: parseBool)
  bool get canReview => throw _privateConstructorUsedError;
  @JsonKey(name: 'canReview', fromJson: parseBool)
  bool get canReviewCamel => throw _privateConstructorUsedError;
  @JsonKey(fromJson: parseStringOrNull)
  String? get reason => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_attended', fromJson: parseBool)
  bool get hasAttended => throw _privateConstructorUsedError;
  @JsonKey(name: 'hasAttended', fromJson: parseBool)
  bool get hasAttendedCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
  bool get isVerifiedPurchase => throw _privateConstructorUsedError;
  @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
  bool get isVerifiedPurchaseCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'review_status', fromJson: parseStringOrNull)
  String? get reviewStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'reviewStatus', fromJson: parseStringOrNull)
  String? get reviewStatusCamel => throw _privateConstructorUsedError;
  @JsonKey(name: 'existing_review')
  ReviewDto? get existingReviewSnake => throw _privateConstructorUsedError;
  @JsonKey(name: 'existingReview')
  ReviewDto? get existingReview => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CanReviewDtoCopyWith<CanReviewDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CanReviewDtoCopyWith<$Res> {
  factory $CanReviewDtoCopyWith(
          CanReviewDto value, $Res Function(CanReviewDto) then) =
      _$CanReviewDtoCopyWithImpl<$Res, CanReviewDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'can_review', fromJson: parseBool) bool canReview,
      @JsonKey(name: 'canReview', fromJson: parseBool) bool canReviewCamel,
      @JsonKey(fromJson: parseStringOrNull) String? reason,
      @JsonKey(name: 'has_attended', fromJson: parseBool) bool hasAttended,
      @JsonKey(name: 'hasAttended', fromJson: parseBool) bool hasAttendedCamel,
      @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
      bool isVerifiedPurchase,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
      bool isVerifiedPurchaseCamel,
      @JsonKey(name: 'review_status', fromJson: parseStringOrNull)
      String? reviewStatus,
      @JsonKey(name: 'reviewStatus', fromJson: parseStringOrNull)
      String? reviewStatusCamel,
      @JsonKey(name: 'existing_review') ReviewDto? existingReviewSnake,
      @JsonKey(name: 'existingReview') ReviewDto? existingReview});

  $ReviewDtoCopyWith<$Res>? get existingReviewSnake;
  $ReviewDtoCopyWith<$Res>? get existingReview;
}

/// @nodoc
class _$CanReviewDtoCopyWithImpl<$Res, $Val extends CanReviewDto>
    implements $CanReviewDtoCopyWith<$Res> {
  _$CanReviewDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canReview = null,
    Object? canReviewCamel = null,
    Object? reason = freezed,
    Object? hasAttended = null,
    Object? hasAttendedCamel = null,
    Object? isVerifiedPurchase = null,
    Object? isVerifiedPurchaseCamel = null,
    Object? reviewStatus = freezed,
    Object? reviewStatusCamel = freezed,
    Object? existingReviewSnake = freezed,
    Object? existingReview = freezed,
  }) {
    return _then(_value.copyWith(
      canReview: null == canReview
          ? _value.canReview
          : canReview // ignore: cast_nullable_to_non_nullable
              as bool,
      canReviewCamel: null == canReviewCamel
          ? _value.canReviewCamel
          : canReviewCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      hasAttended: null == hasAttended
          ? _value.hasAttended
          : hasAttended // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAttendedCamel: null == hasAttendedCamel
          ? _value.hasAttendedCamel
          : hasAttendedCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerifiedPurchase: null == isVerifiedPurchase
          ? _value.isVerifiedPurchase
          : isVerifiedPurchase // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerifiedPurchaseCamel: null == isVerifiedPurchaseCamel
          ? _value.isVerifiedPurchaseCamel
          : isVerifiedPurchaseCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      reviewStatus: freezed == reviewStatus
          ? _value.reviewStatus
          : reviewStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewStatusCamel: freezed == reviewStatusCamel
          ? _value.reviewStatusCamel
          : reviewStatusCamel // ignore: cast_nullable_to_non_nullable
              as String?,
      existingReviewSnake: freezed == existingReviewSnake
          ? _value.existingReviewSnake
          : existingReviewSnake // ignore: cast_nullable_to_non_nullable
              as ReviewDto?,
      existingReview: freezed == existingReview
          ? _value.existingReview
          : existingReview // ignore: cast_nullable_to_non_nullable
              as ReviewDto?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ReviewDtoCopyWith<$Res>? get existingReviewSnake {
    if (_value.existingReviewSnake == null) {
      return null;
    }

    return $ReviewDtoCopyWith<$Res>(_value.existingReviewSnake!, (value) {
      return _then(_value.copyWith(existingReviewSnake: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ReviewDtoCopyWith<$Res>? get existingReview {
    if (_value.existingReview == null) {
      return null;
    }

    return $ReviewDtoCopyWith<$Res>(_value.existingReview!, (value) {
      return _then(_value.copyWith(existingReview: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CanReviewDtoImplCopyWith<$Res>
    implements $CanReviewDtoCopyWith<$Res> {
  factory _$$CanReviewDtoImplCopyWith(
          _$CanReviewDtoImpl value, $Res Function(_$CanReviewDtoImpl) then) =
      __$$CanReviewDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'can_review', fromJson: parseBool) bool canReview,
      @JsonKey(name: 'canReview', fromJson: parseBool) bool canReviewCamel,
      @JsonKey(fromJson: parseStringOrNull) String? reason,
      @JsonKey(name: 'has_attended', fromJson: parseBool) bool hasAttended,
      @JsonKey(name: 'hasAttended', fromJson: parseBool) bool hasAttendedCamel,
      @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
      bool isVerifiedPurchase,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
      bool isVerifiedPurchaseCamel,
      @JsonKey(name: 'review_status', fromJson: parseStringOrNull)
      String? reviewStatus,
      @JsonKey(name: 'reviewStatus', fromJson: parseStringOrNull)
      String? reviewStatusCamel,
      @JsonKey(name: 'existing_review') ReviewDto? existingReviewSnake,
      @JsonKey(name: 'existingReview') ReviewDto? existingReview});

  @override
  $ReviewDtoCopyWith<$Res>? get existingReviewSnake;
  @override
  $ReviewDtoCopyWith<$Res>? get existingReview;
}

/// @nodoc
class __$$CanReviewDtoImplCopyWithImpl<$Res>
    extends _$CanReviewDtoCopyWithImpl<$Res, _$CanReviewDtoImpl>
    implements _$$CanReviewDtoImplCopyWith<$Res> {
  __$$CanReviewDtoImplCopyWithImpl(
      _$CanReviewDtoImpl _value, $Res Function(_$CanReviewDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? canReview = null,
    Object? canReviewCamel = null,
    Object? reason = freezed,
    Object? hasAttended = null,
    Object? hasAttendedCamel = null,
    Object? isVerifiedPurchase = null,
    Object? isVerifiedPurchaseCamel = null,
    Object? reviewStatus = freezed,
    Object? reviewStatusCamel = freezed,
    Object? existingReviewSnake = freezed,
    Object? existingReview = freezed,
  }) {
    return _then(_$CanReviewDtoImpl(
      canReview: null == canReview
          ? _value.canReview
          : canReview // ignore: cast_nullable_to_non_nullable
              as bool,
      canReviewCamel: null == canReviewCamel
          ? _value.canReviewCamel
          : canReviewCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      hasAttended: null == hasAttended
          ? _value.hasAttended
          : hasAttended // ignore: cast_nullable_to_non_nullable
              as bool,
      hasAttendedCamel: null == hasAttendedCamel
          ? _value.hasAttendedCamel
          : hasAttendedCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerifiedPurchase: null == isVerifiedPurchase
          ? _value.isVerifiedPurchase
          : isVerifiedPurchase // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerifiedPurchaseCamel: null == isVerifiedPurchaseCamel
          ? _value.isVerifiedPurchaseCamel
          : isVerifiedPurchaseCamel // ignore: cast_nullable_to_non_nullable
              as bool,
      reviewStatus: freezed == reviewStatus
          ? _value.reviewStatus
          : reviewStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewStatusCamel: freezed == reviewStatusCamel
          ? _value.reviewStatusCamel
          : reviewStatusCamel // ignore: cast_nullable_to_non_nullable
              as String?,
      existingReviewSnake: freezed == existingReviewSnake
          ? _value.existingReviewSnake
          : existingReviewSnake // ignore: cast_nullable_to_non_nullable
              as ReviewDto?,
      existingReview: freezed == existingReview
          ? _value.existingReview
          : existingReview // ignore: cast_nullable_to_non_nullable
              as ReviewDto?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CanReviewDtoImpl implements _CanReviewDto {
  const _$CanReviewDtoImpl(
      {@JsonKey(name: 'can_review', fromJson: parseBool) this.canReview = false,
      @JsonKey(name: 'canReview', fromJson: parseBool)
      this.canReviewCamel = false,
      @JsonKey(fromJson: parseStringOrNull) this.reason,
      @JsonKey(name: 'has_attended', fromJson: parseBool)
      this.hasAttended = false,
      @JsonKey(name: 'hasAttended', fromJson: parseBool)
      this.hasAttendedCamel = false,
      @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
      this.isVerifiedPurchase = false,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
      this.isVerifiedPurchaseCamel = false,
      @JsonKey(name: 'review_status', fromJson: parseStringOrNull)
      this.reviewStatus,
      @JsonKey(name: 'reviewStatus', fromJson: parseStringOrNull)
      this.reviewStatusCamel,
      @JsonKey(name: 'existing_review') this.existingReviewSnake,
      @JsonKey(name: 'existingReview') this.existingReview});

  factory _$CanReviewDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CanReviewDtoImplFromJson(json);

  @override
  @JsonKey(name: 'can_review', fromJson: parseBool)
  final bool canReview;
  @override
  @JsonKey(name: 'canReview', fromJson: parseBool)
  final bool canReviewCamel;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  final String? reason;
  @override
  @JsonKey(name: 'has_attended', fromJson: parseBool)
  final bool hasAttended;
  @override
  @JsonKey(name: 'hasAttended', fromJson: parseBool)
  final bool hasAttendedCamel;
  @override
  @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
  final bool isVerifiedPurchase;
  @override
  @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
  final bool isVerifiedPurchaseCamel;
  @override
  @JsonKey(name: 'review_status', fromJson: parseStringOrNull)
  final String? reviewStatus;
  @override
  @JsonKey(name: 'reviewStatus', fromJson: parseStringOrNull)
  final String? reviewStatusCamel;
  @override
  @JsonKey(name: 'existing_review')
  final ReviewDto? existingReviewSnake;
  @override
  @JsonKey(name: 'existingReview')
  final ReviewDto? existingReview;

  @override
  String toString() {
    return 'CanReviewDto(canReview: $canReview, canReviewCamel: $canReviewCamel, reason: $reason, hasAttended: $hasAttended, hasAttendedCamel: $hasAttendedCamel, isVerifiedPurchase: $isVerifiedPurchase, isVerifiedPurchaseCamel: $isVerifiedPurchaseCamel, reviewStatus: $reviewStatus, reviewStatusCamel: $reviewStatusCamel, existingReviewSnake: $existingReviewSnake, existingReview: $existingReview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CanReviewDtoImpl &&
            (identical(other.canReview, canReview) ||
                other.canReview == canReview) &&
            (identical(other.canReviewCamel, canReviewCamel) ||
                other.canReviewCamel == canReviewCamel) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.hasAttended, hasAttended) ||
                other.hasAttended == hasAttended) &&
            (identical(other.hasAttendedCamel, hasAttendedCamel) ||
                other.hasAttendedCamel == hasAttendedCamel) &&
            (identical(other.isVerifiedPurchase, isVerifiedPurchase) ||
                other.isVerifiedPurchase == isVerifiedPurchase) &&
            (identical(
                    other.isVerifiedPurchaseCamel, isVerifiedPurchaseCamel) ||
                other.isVerifiedPurchaseCamel == isVerifiedPurchaseCamel) &&
            (identical(other.reviewStatus, reviewStatus) ||
                other.reviewStatus == reviewStatus) &&
            (identical(other.reviewStatusCamel, reviewStatusCamel) ||
                other.reviewStatusCamel == reviewStatusCamel) &&
            (identical(other.existingReviewSnake, existingReviewSnake) ||
                other.existingReviewSnake == existingReviewSnake) &&
            (identical(other.existingReview, existingReview) ||
                other.existingReview == existingReview));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      canReview,
      canReviewCamel,
      reason,
      hasAttended,
      hasAttendedCamel,
      isVerifiedPurchase,
      isVerifiedPurchaseCamel,
      reviewStatus,
      reviewStatusCamel,
      existingReviewSnake,
      existingReview);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CanReviewDtoImplCopyWith<_$CanReviewDtoImpl> get copyWith =>
      __$$CanReviewDtoImplCopyWithImpl<_$CanReviewDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CanReviewDtoImplToJson(
      this,
    );
  }
}

abstract class _CanReviewDto implements CanReviewDto {
  const factory _CanReviewDto(
      {@JsonKey(name: 'can_review', fromJson: parseBool) final bool canReview,
      @JsonKey(name: 'canReview', fromJson: parseBool)
      final bool canReviewCamel,
      @JsonKey(fromJson: parseStringOrNull) final String? reason,
      @JsonKey(name: 'has_attended', fromJson: parseBool)
      final bool hasAttended,
      @JsonKey(name: 'hasAttended', fromJson: parseBool)
      final bool hasAttendedCamel,
      @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
      final bool isVerifiedPurchase,
      @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
      final bool isVerifiedPurchaseCamel,
      @JsonKey(name: 'review_status', fromJson: parseStringOrNull)
      final String? reviewStatus,
      @JsonKey(name: 'reviewStatus', fromJson: parseStringOrNull)
      final String? reviewStatusCamel,
      @JsonKey(name: 'existing_review') final ReviewDto? existingReviewSnake,
      @JsonKey(name: 'existingReview')
      final ReviewDto? existingReview}) = _$CanReviewDtoImpl;

  factory _CanReviewDto.fromJson(Map<String, dynamic> json) =
      _$CanReviewDtoImpl.fromJson;

  @override
  @JsonKey(name: 'can_review', fromJson: parseBool)
  bool get canReview;
  @override
  @JsonKey(name: 'canReview', fromJson: parseBool)
  bool get canReviewCamel;
  @override
  @JsonKey(fromJson: parseStringOrNull)
  String? get reason;
  @override
  @JsonKey(name: 'has_attended', fromJson: parseBool)
  bool get hasAttended;
  @override
  @JsonKey(name: 'hasAttended', fromJson: parseBool)
  bool get hasAttendedCamel;
  @override
  @JsonKey(name: 'is_verified_purchase', fromJson: parseBool)
  bool get isVerifiedPurchase;
  @override
  @JsonKey(name: 'isVerifiedPurchase', fromJson: parseBool)
  bool get isVerifiedPurchaseCamel;
  @override
  @JsonKey(name: 'review_status', fromJson: parseStringOrNull)
  String? get reviewStatus;
  @override
  @JsonKey(name: 'reviewStatus', fromJson: parseStringOrNull)
  String? get reviewStatusCamel;
  @override
  @JsonKey(name: 'existing_review')
  ReviewDto? get existingReviewSnake;
  @override
  @JsonKey(name: 'existingReview')
  ReviewDto? get existingReview;
  @override
  @JsonKey(ignore: true)
  _$$CanReviewDtoImplCopyWith<_$CanReviewDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

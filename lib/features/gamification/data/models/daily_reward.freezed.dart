// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_reward.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DailyRewardState _$DailyRewardStateFromJson(Map<String, dynamic> json) {
  return _DailyRewardState.fromJson(json);
}

/// @nodoc
mixin _$DailyRewardState {
  int get currentDay => throw _privateConstructorUsedError; // 1 to 7
  bool get isClaimedToday => throw _privateConstructorUsedError;
  DateTime get lastClaimDate => throw _privateConstructorUsedError;
  List<DailyRewardDay> get days => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyRewardStateCopyWith<DailyRewardState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyRewardStateCopyWith<$Res> {
  factory $DailyRewardStateCopyWith(
          DailyRewardState value, $Res Function(DailyRewardState) then) =
      _$DailyRewardStateCopyWithImpl<$Res, DailyRewardState>;
  @useResult
  $Res call(
      {int currentDay,
      bool isClaimedToday,
      DateTime lastClaimDate,
      List<DailyRewardDay> days});
}

/// @nodoc
class _$DailyRewardStateCopyWithImpl<$Res, $Val extends DailyRewardState>
    implements $DailyRewardStateCopyWith<$Res> {
  _$DailyRewardStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentDay = null,
    Object? isClaimedToday = null,
    Object? lastClaimDate = null,
    Object? days = null,
  }) {
    return _then(_value.copyWith(
      currentDay: null == currentDay
          ? _value.currentDay
          : currentDay // ignore: cast_nullable_to_non_nullable
              as int,
      isClaimedToday: null == isClaimedToday
          ? _value.isClaimedToday
          : isClaimedToday // ignore: cast_nullable_to_non_nullable
              as bool,
      lastClaimDate: null == lastClaimDate
          ? _value.lastClaimDate
          : lastClaimDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as List<DailyRewardDay>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyRewardStateImplCopyWith<$Res>
    implements $DailyRewardStateCopyWith<$Res> {
  factory _$$DailyRewardStateImplCopyWith(_$DailyRewardStateImpl value,
          $Res Function(_$DailyRewardStateImpl) then) =
      __$$DailyRewardStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentDay,
      bool isClaimedToday,
      DateTime lastClaimDate,
      List<DailyRewardDay> days});
}

/// @nodoc
class __$$DailyRewardStateImplCopyWithImpl<$Res>
    extends _$DailyRewardStateCopyWithImpl<$Res, _$DailyRewardStateImpl>
    implements _$$DailyRewardStateImplCopyWith<$Res> {
  __$$DailyRewardStateImplCopyWithImpl(_$DailyRewardStateImpl _value,
      $Res Function(_$DailyRewardStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentDay = null,
    Object? isClaimedToday = null,
    Object? lastClaimDate = null,
    Object? days = null,
  }) {
    return _then(_$DailyRewardStateImpl(
      currentDay: null == currentDay
          ? _value.currentDay
          : currentDay // ignore: cast_nullable_to_non_nullable
              as int,
      isClaimedToday: null == isClaimedToday
          ? _value.isClaimedToday
          : isClaimedToday // ignore: cast_nullable_to_non_nullable
              as bool,
      lastClaimDate: null == lastClaimDate
          ? _value.lastClaimDate
          : lastClaimDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      days: null == days
          ? _value._days
          : days // ignore: cast_nullable_to_non_nullable
              as List<DailyRewardDay>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyRewardStateImpl implements _DailyRewardState {
  const _$DailyRewardStateImpl(
      {required this.currentDay,
      required this.isClaimedToday,
      required this.lastClaimDate,
      required final List<DailyRewardDay> days})
      : _days = days;

  factory _$DailyRewardStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyRewardStateImplFromJson(json);

  @override
  final int currentDay;
// 1 to 7
  @override
  final bool isClaimedToday;
  @override
  final DateTime lastClaimDate;
  final List<DailyRewardDay> _days;
  @override
  List<DailyRewardDay> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  String toString() {
    return 'DailyRewardState(currentDay: $currentDay, isClaimedToday: $isClaimedToday, lastClaimDate: $lastClaimDate, days: $days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyRewardStateImpl &&
            (identical(other.currentDay, currentDay) ||
                other.currentDay == currentDay) &&
            (identical(other.isClaimedToday, isClaimedToday) ||
                other.isClaimedToday == isClaimedToday) &&
            (identical(other.lastClaimDate, lastClaimDate) ||
                other.lastClaimDate == lastClaimDate) &&
            const DeepCollectionEquality().equals(other._days, _days));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, currentDay, isClaimedToday,
      lastClaimDate, const DeepCollectionEquality().hash(_days));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyRewardStateImplCopyWith<_$DailyRewardStateImpl> get copyWith =>
      __$$DailyRewardStateImplCopyWithImpl<_$DailyRewardStateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyRewardStateImplToJson(
      this,
    );
  }
}

abstract class _DailyRewardState implements DailyRewardState {
  const factory _DailyRewardState(
      {required final int currentDay,
      required final bool isClaimedToday,
      required final DateTime lastClaimDate,
      required final List<DailyRewardDay> days}) = _$DailyRewardStateImpl;

  factory _DailyRewardState.fromJson(Map<String, dynamic> json) =
      _$DailyRewardStateImpl.fromJson;

  @override
  int get currentDay;
  @override // 1 to 7
  bool get isClaimedToday;
  @override
  DateTime get lastClaimDate;
  @override
  List<DailyRewardDay> get days;
  @override
  @JsonKey(ignore: true)
  _$$DailyRewardStateImplCopyWith<_$DailyRewardStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyRewardDay _$DailyRewardDayFromJson(Map<String, dynamic> json) {
  return _DailyRewardDay.fromJson(json);
}

/// @nodoc
mixin _$DailyRewardDay {
  int get dayNumber => throw _privateConstructorUsedError;
  int get hibonsReward => throw _privateConstructorUsedError;
  int get xpReward => throw _privateConstructorUsedError;
  String? get bonusDescription =>
      throw _privateConstructorUsedError; // e.g., "x1.2 XP", "Tour gratuit"
  bool get isJackpot => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyRewardDayCopyWith<DailyRewardDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyRewardDayCopyWith<$Res> {
  factory $DailyRewardDayCopyWith(
          DailyRewardDay value, $Res Function(DailyRewardDay) then) =
      _$DailyRewardDayCopyWithImpl<$Res, DailyRewardDay>;
  @useResult
  $Res call(
      {int dayNumber,
      int hibonsReward,
      int xpReward,
      String? bonusDescription,
      bool isJackpot});
}

/// @nodoc
class _$DailyRewardDayCopyWithImpl<$Res, $Val extends DailyRewardDay>
    implements $DailyRewardDayCopyWith<$Res> {
  _$DailyRewardDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayNumber = null,
    Object? hibonsReward = null,
    Object? xpReward = null,
    Object? bonusDescription = freezed,
    Object? isJackpot = null,
  }) {
    return _then(_value.copyWith(
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      hibonsReward: null == hibonsReward
          ? _value.hibonsReward
          : hibonsReward // ignore: cast_nullable_to_non_nullable
              as int,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      bonusDescription: freezed == bonusDescription
          ? _value.bonusDescription
          : bonusDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      isJackpot: null == isJackpot
          ? _value.isJackpot
          : isJackpot // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyRewardDayImplCopyWith<$Res>
    implements $DailyRewardDayCopyWith<$Res> {
  factory _$$DailyRewardDayImplCopyWith(_$DailyRewardDayImpl value,
          $Res Function(_$DailyRewardDayImpl) then) =
      __$$DailyRewardDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int dayNumber,
      int hibonsReward,
      int xpReward,
      String? bonusDescription,
      bool isJackpot});
}

/// @nodoc
class __$$DailyRewardDayImplCopyWithImpl<$Res>
    extends _$DailyRewardDayCopyWithImpl<$Res, _$DailyRewardDayImpl>
    implements _$$DailyRewardDayImplCopyWith<$Res> {
  __$$DailyRewardDayImplCopyWithImpl(
      _$DailyRewardDayImpl _value, $Res Function(_$DailyRewardDayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayNumber = null,
    Object? hibonsReward = null,
    Object? xpReward = null,
    Object? bonusDescription = freezed,
    Object? isJackpot = null,
  }) {
    return _then(_$DailyRewardDayImpl(
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      hibonsReward: null == hibonsReward
          ? _value.hibonsReward
          : hibonsReward // ignore: cast_nullable_to_non_nullable
              as int,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      bonusDescription: freezed == bonusDescription
          ? _value.bonusDescription
          : bonusDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      isJackpot: null == isJackpot
          ? _value.isJackpot
          : isJackpot // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyRewardDayImpl implements _DailyRewardDay {
  const _$DailyRewardDayImpl(
      {required this.dayNumber,
      required this.hibonsReward,
      required this.xpReward,
      this.bonusDescription,
      this.isJackpot = false});

  factory _$DailyRewardDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyRewardDayImplFromJson(json);

  @override
  final int dayNumber;
  @override
  final int hibonsReward;
  @override
  final int xpReward;
  @override
  final String? bonusDescription;
// e.g., "x1.2 XP", "Tour gratuit"
  @override
  @JsonKey()
  final bool isJackpot;

  @override
  String toString() {
    return 'DailyRewardDay(dayNumber: $dayNumber, hibonsReward: $hibonsReward, xpReward: $xpReward, bonusDescription: $bonusDescription, isJackpot: $isJackpot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyRewardDayImpl &&
            (identical(other.dayNumber, dayNumber) ||
                other.dayNumber == dayNumber) &&
            (identical(other.hibonsReward, hibonsReward) ||
                other.hibonsReward == hibonsReward) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward) &&
            (identical(other.bonusDescription, bonusDescription) ||
                other.bonusDescription == bonusDescription) &&
            (identical(other.isJackpot, isJackpot) ||
                other.isJackpot == isJackpot));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, dayNumber, hibonsReward,
      xpReward, bonusDescription, isJackpot);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyRewardDayImplCopyWith<_$DailyRewardDayImpl> get copyWith =>
      __$$DailyRewardDayImplCopyWithImpl<_$DailyRewardDayImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyRewardDayImplToJson(
      this,
    );
  }
}

abstract class _DailyRewardDay implements DailyRewardDay {
  const factory _DailyRewardDay(
      {required final int dayNumber,
      required final int hibonsReward,
      required final int xpReward,
      final String? bonusDescription,
      final bool isJackpot}) = _$DailyRewardDayImpl;

  factory _DailyRewardDay.fromJson(Map<String, dynamic> json) =
      _$DailyRewardDayImpl.fromJson;

  @override
  int get dayNumber;
  @override
  int get hibonsReward;
  @override
  int get xpReward;
  @override
  String? get bonusDescription;
  @override // e.g., "x1.2 XP", "Tour gratuit"
  bool get isJackpot;
  @override
  @JsonKey(ignore: true)
  _$$DailyRewardDayImplCopyWith<_$DailyRewardDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

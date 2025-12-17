// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hibons_wallet.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HibonsWallet _$HibonsWalletFromJson(Map<String, dynamic> json) {
  return _HibonsWallet.fromJson(json);
}

/// @nodoc
mixin _$HibonsWallet {
  String get userId => throw _privateConstructorUsedError;
  int get balance => throw _privateConstructorUsedError;
  int get xp => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  String get rank => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  bool get streakShieldActive => throw _privateConstructorUsedError;
  DateTime? get lastActionDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HibonsWalletCopyWith<HibonsWallet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HibonsWalletCopyWith<$Res> {
  factory $HibonsWalletCopyWith(
          HibonsWallet value, $Res Function(HibonsWallet) then) =
      _$HibonsWalletCopyWithImpl<$Res, HibonsWallet>;
  @useResult
  $Res call(
      {String userId,
      int balance,
      int xp,
      int level,
      String rank,
      int currentStreak,
      bool streakShieldActive,
      DateTime? lastActionDate});
}

/// @nodoc
class _$HibonsWalletCopyWithImpl<$Res, $Val extends HibonsWallet>
    implements $HibonsWalletCopyWith<$Res> {
  _$HibonsWalletCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? balance = null,
    Object? xp = null,
    Object? level = null,
    Object? rank = null,
    Object? currentStreak = null,
    Object? streakShieldActive = null,
    Object? lastActionDate = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as int,
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as String,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      streakShieldActive: null == streakShieldActive
          ? _value.streakShieldActive
          : streakShieldActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastActionDate: freezed == lastActionDate
          ? _value.lastActionDate
          : lastActionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HibonsWalletImplCopyWith<$Res>
    implements $HibonsWalletCopyWith<$Res> {
  factory _$$HibonsWalletImplCopyWith(
          _$HibonsWalletImpl value, $Res Function(_$HibonsWalletImpl) then) =
      __$$HibonsWalletImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int balance,
      int xp,
      int level,
      String rank,
      int currentStreak,
      bool streakShieldActive,
      DateTime? lastActionDate});
}

/// @nodoc
class __$$HibonsWalletImplCopyWithImpl<$Res>
    extends _$HibonsWalletCopyWithImpl<$Res, _$HibonsWalletImpl>
    implements _$$HibonsWalletImplCopyWith<$Res> {
  __$$HibonsWalletImplCopyWithImpl(
      _$HibonsWalletImpl _value, $Res Function(_$HibonsWalletImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? balance = null,
    Object? xp = null,
    Object? level = null,
    Object? rank = null,
    Object? currentStreak = null,
    Object? streakShieldActive = null,
    Object? lastActionDate = freezed,
  }) {
    return _then(_$HibonsWalletImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as int,
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as String,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      streakShieldActive: null == streakShieldActive
          ? _value.streakShieldActive
          : streakShieldActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastActionDate: freezed == lastActionDate
          ? _value.lastActionDate
          : lastActionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HibonsWalletImpl implements _HibonsWallet {
  const _$HibonsWalletImpl(
      {required this.userId,
      this.balance = 0,
      this.xp = 0,
      this.level = 1,
      this.rank = 'Hibou Curieux',
      this.currentStreak = 0,
      this.streakShieldActive = false,
      this.lastActionDate});

  factory _$HibonsWalletImpl.fromJson(Map<String, dynamic> json) =>
      _$$HibonsWalletImplFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final int balance;
  @override
  @JsonKey()
  final int xp;
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final String rank;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final bool streakShieldActive;
  @override
  final DateTime? lastActionDate;

  @override
  String toString() {
    return 'HibonsWallet(userId: $userId, balance: $balance, xp: $xp, level: $level, rank: $rank, currentStreak: $currentStreak, streakShieldActive: $streakShieldActive, lastActionDate: $lastActionDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HibonsWalletImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.xp, xp) || other.xp == xp) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.streakShieldActive, streakShieldActive) ||
                other.streakShieldActive == streakShieldActive) &&
            (identical(other.lastActionDate, lastActionDate) ||
                other.lastActionDate == lastActionDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, balance, xp, level, rank,
      currentStreak, streakShieldActive, lastActionDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HibonsWalletImplCopyWith<_$HibonsWalletImpl> get copyWith =>
      __$$HibonsWalletImplCopyWithImpl<_$HibonsWalletImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HibonsWalletImplToJson(
      this,
    );
  }
}

abstract class _HibonsWallet implements HibonsWallet {
  const factory _HibonsWallet(
      {required final String userId,
      final int balance,
      final int xp,
      final int level,
      final String rank,
      final int currentStreak,
      final bool streakShieldActive,
      final DateTime? lastActionDate}) = _$HibonsWalletImpl;

  factory _HibonsWallet.fromJson(Map<String, dynamic> json) =
      _$HibonsWalletImpl.fromJson;

  @override
  String get userId;
  @override
  int get balance;
  @override
  int get xp;
  @override
  int get level;
  @override
  String get rank;
  @override
  int get currentStreak;
  @override
  bool get streakShieldActive;
  @override
  DateTime? get lastActionDate;
  @override
  @JsonKey(ignore: true)
  _$$HibonsWalletImplCopyWith<_$HibonsWalletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

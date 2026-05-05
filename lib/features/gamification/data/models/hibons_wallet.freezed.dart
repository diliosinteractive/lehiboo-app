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
  int get balance => throw _privateConstructorUsedError;
  int get lifetimeEarned => throw _privateConstructorUsedError;
  String get rank => throw _privateConstructorUsedError;
  HibonsRank get rankEnum => throw _privateConstructorUsedError;
  String get rankLabel => throw _privateConstructorUsedError;
  String get rankIcon => throw _privateConstructorUsedError;
  HibonsRank? get nextRank => throw _privateConstructorUsedError;
  String? get nextRankLabel => throw _privateConstructorUsedError;
  int? get hibonsToNextRank => throw _privateConstructorUsedError;
  int get progressToNextRank => throw _privateConstructorUsedError;
  int get petitBooBonus => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get maxStreak => throw _privateConstructorUsedError;
  bool get canClaimDaily => throw _privateConstructorUsedError;
  bool get canSpinWheel => throw _privateConstructorUsedError;
  ChatQuota? get chatQuota => throw _privateConstructorUsedError;
  List<DailyRewardItem> get dailyRewards =>
      throw _privateConstructorUsedError; // Champs legacy pour compatibilité (non utilisés par l'API)
  bool get streakShieldActive => throw _privateConstructorUsedError;
  DateTime? get lastActionDate => throw _privateConstructorUsedError;
  @Deprecated('Use lifetimeEarned')
  int? get xp => throw _privateConstructorUsedError;
  @Deprecated('Use rankEnum')
  int? get level => throw _privateConstructorUsedError;
  @Deprecated('Use progressToNextRank')
  int? get progressToNextLevel => throw _privateConstructorUsedError;

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
      {int balance,
      int lifetimeEarned,
      String rank,
      HibonsRank rankEnum,
      String rankLabel,
      String rankIcon,
      HibonsRank? nextRank,
      String? nextRankLabel,
      int? hibonsToNextRank,
      int progressToNextRank,
      int petitBooBonus,
      int currentStreak,
      int maxStreak,
      bool canClaimDaily,
      bool canSpinWheel,
      ChatQuota? chatQuota,
      List<DailyRewardItem> dailyRewards,
      bool streakShieldActive,
      DateTime? lastActionDate,
      @Deprecated('Use lifetimeEarned') int? xp,
      @Deprecated('Use rankEnum') int? level,
      @Deprecated('Use progressToNextRank') int? progressToNextLevel});

  $ChatQuotaCopyWith<$Res>? get chatQuota;
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
    Object? balance = null,
    Object? lifetimeEarned = null,
    Object? rank = null,
    Object? rankEnum = null,
    Object? rankLabel = null,
    Object? rankIcon = null,
    Object? nextRank = freezed,
    Object? nextRankLabel = freezed,
    Object? hibonsToNextRank = freezed,
    Object? progressToNextRank = null,
    Object? petitBooBonus = null,
    Object? currentStreak = null,
    Object? maxStreak = null,
    Object? canClaimDaily = null,
    Object? canSpinWheel = null,
    Object? chatQuota = freezed,
    Object? dailyRewards = null,
    Object? streakShieldActive = null,
    Object? lastActionDate = freezed,
    Object? xp = freezed,
    Object? level = freezed,
    Object? progressToNextLevel = freezed,
  }) {
    return _then(_value.copyWith(
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as int,
      lifetimeEarned: null == lifetimeEarned
          ? _value.lifetimeEarned
          : lifetimeEarned // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as String,
      rankEnum: null == rankEnum
          ? _value.rankEnum
          : rankEnum // ignore: cast_nullable_to_non_nullable
              as HibonsRank,
      rankLabel: null == rankLabel
          ? _value.rankLabel
          : rankLabel // ignore: cast_nullable_to_non_nullable
              as String,
      rankIcon: null == rankIcon
          ? _value.rankIcon
          : rankIcon // ignore: cast_nullable_to_non_nullable
              as String,
      nextRank: freezed == nextRank
          ? _value.nextRank
          : nextRank // ignore: cast_nullable_to_non_nullable
              as HibonsRank?,
      nextRankLabel: freezed == nextRankLabel
          ? _value.nextRankLabel
          : nextRankLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      hibonsToNextRank: freezed == hibonsToNextRank
          ? _value.hibonsToNextRank
          : hibonsToNextRank // ignore: cast_nullable_to_non_nullable
              as int?,
      progressToNextRank: null == progressToNextRank
          ? _value.progressToNextRank
          : progressToNextRank // ignore: cast_nullable_to_non_nullable
              as int,
      petitBooBonus: null == petitBooBonus
          ? _value.petitBooBonus
          : petitBooBonus // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      maxStreak: null == maxStreak
          ? _value.maxStreak
          : maxStreak // ignore: cast_nullable_to_non_nullable
              as int,
      canClaimDaily: null == canClaimDaily
          ? _value.canClaimDaily
          : canClaimDaily // ignore: cast_nullable_to_non_nullable
              as bool,
      canSpinWheel: null == canSpinWheel
          ? _value.canSpinWheel
          : canSpinWheel // ignore: cast_nullable_to_non_nullable
              as bool,
      chatQuota: freezed == chatQuota
          ? _value.chatQuota
          : chatQuota // ignore: cast_nullable_to_non_nullable
              as ChatQuota?,
      dailyRewards: null == dailyRewards
          ? _value.dailyRewards
          : dailyRewards // ignore: cast_nullable_to_non_nullable
              as List<DailyRewardItem>,
      streakShieldActive: null == streakShieldActive
          ? _value.streakShieldActive
          : streakShieldActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastActionDate: freezed == lastActionDate
          ? _value.lastActionDate
          : lastActionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      xp: freezed == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int?,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int?,
      progressToNextLevel: freezed == progressToNextLevel
          ? _value.progressToNextLevel
          : progressToNextLevel // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ChatQuotaCopyWith<$Res>? get chatQuota {
    if (_value.chatQuota == null) {
      return null;
    }

    return $ChatQuotaCopyWith<$Res>(_value.chatQuota!, (value) {
      return _then(_value.copyWith(chatQuota: value) as $Val);
    });
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
      {int balance,
      int lifetimeEarned,
      String rank,
      HibonsRank rankEnum,
      String rankLabel,
      String rankIcon,
      HibonsRank? nextRank,
      String? nextRankLabel,
      int? hibonsToNextRank,
      int progressToNextRank,
      int petitBooBonus,
      int currentStreak,
      int maxStreak,
      bool canClaimDaily,
      bool canSpinWheel,
      ChatQuota? chatQuota,
      List<DailyRewardItem> dailyRewards,
      bool streakShieldActive,
      DateTime? lastActionDate,
      @Deprecated('Use lifetimeEarned') int? xp,
      @Deprecated('Use rankEnum') int? level,
      @Deprecated('Use progressToNextRank') int? progressToNextLevel});

  @override
  $ChatQuotaCopyWith<$Res>? get chatQuota;
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
    Object? balance = null,
    Object? lifetimeEarned = null,
    Object? rank = null,
    Object? rankEnum = null,
    Object? rankLabel = null,
    Object? rankIcon = null,
    Object? nextRank = freezed,
    Object? nextRankLabel = freezed,
    Object? hibonsToNextRank = freezed,
    Object? progressToNextRank = null,
    Object? petitBooBonus = null,
    Object? currentStreak = null,
    Object? maxStreak = null,
    Object? canClaimDaily = null,
    Object? canSpinWheel = null,
    Object? chatQuota = freezed,
    Object? dailyRewards = null,
    Object? streakShieldActive = null,
    Object? lastActionDate = freezed,
    Object? xp = freezed,
    Object? level = freezed,
    Object? progressToNextLevel = freezed,
  }) {
    return _then(_$HibonsWalletImpl(
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as int,
      lifetimeEarned: null == lifetimeEarned
          ? _value.lifetimeEarned
          : lifetimeEarned // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as String,
      rankEnum: null == rankEnum
          ? _value.rankEnum
          : rankEnum // ignore: cast_nullable_to_non_nullable
              as HibonsRank,
      rankLabel: null == rankLabel
          ? _value.rankLabel
          : rankLabel // ignore: cast_nullable_to_non_nullable
              as String,
      rankIcon: null == rankIcon
          ? _value.rankIcon
          : rankIcon // ignore: cast_nullable_to_non_nullable
              as String,
      nextRank: freezed == nextRank
          ? _value.nextRank
          : nextRank // ignore: cast_nullable_to_non_nullable
              as HibonsRank?,
      nextRankLabel: freezed == nextRankLabel
          ? _value.nextRankLabel
          : nextRankLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      hibonsToNextRank: freezed == hibonsToNextRank
          ? _value.hibonsToNextRank
          : hibonsToNextRank // ignore: cast_nullable_to_non_nullable
              as int?,
      progressToNextRank: null == progressToNextRank
          ? _value.progressToNextRank
          : progressToNextRank // ignore: cast_nullable_to_non_nullable
              as int,
      petitBooBonus: null == petitBooBonus
          ? _value.petitBooBonus
          : petitBooBonus // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      maxStreak: null == maxStreak
          ? _value.maxStreak
          : maxStreak // ignore: cast_nullable_to_non_nullable
              as int,
      canClaimDaily: null == canClaimDaily
          ? _value.canClaimDaily
          : canClaimDaily // ignore: cast_nullable_to_non_nullable
              as bool,
      canSpinWheel: null == canSpinWheel
          ? _value.canSpinWheel
          : canSpinWheel // ignore: cast_nullable_to_non_nullable
              as bool,
      chatQuota: freezed == chatQuota
          ? _value.chatQuota
          : chatQuota // ignore: cast_nullable_to_non_nullable
              as ChatQuota?,
      dailyRewards: null == dailyRewards
          ? _value._dailyRewards
          : dailyRewards // ignore: cast_nullable_to_non_nullable
              as List<DailyRewardItem>,
      streakShieldActive: null == streakShieldActive
          ? _value.streakShieldActive
          : streakShieldActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastActionDate: freezed == lastActionDate
          ? _value.lastActionDate
          : lastActionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      xp: freezed == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int?,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int?,
      progressToNextLevel: freezed == progressToNextLevel
          ? _value.progressToNextLevel
          : progressToNextLevel // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HibonsWalletImpl implements _HibonsWallet {
  const _$HibonsWalletImpl(
      {this.balance = 0,
      this.lifetimeEarned = 0,
      this.rank = 'curieux',
      this.rankEnum = HibonsRank.curieux,
      this.rankLabel = 'Curieux',
      this.rankIcon = '🔍',
      this.nextRank,
      this.nextRankLabel,
      this.hibonsToNextRank,
      this.progressToNextRank = 0,
      this.petitBooBonus = 0,
      this.currentStreak = 0,
      this.maxStreak = 7,
      this.canClaimDaily = true,
      this.canSpinWheel = true,
      this.chatQuota,
      final List<DailyRewardItem> dailyRewards = const [],
      this.streakShieldActive = false,
      this.lastActionDate,
      @Deprecated('Use lifetimeEarned') this.xp,
      @Deprecated('Use rankEnum') this.level,
      @Deprecated('Use progressToNextRank') this.progressToNextLevel})
      : _dailyRewards = dailyRewards;

  factory _$HibonsWalletImpl.fromJson(Map<String, dynamic> json) =>
      _$$HibonsWalletImplFromJson(json);

  @override
  @JsonKey()
  final int balance;
  @override
  @JsonKey()
  final int lifetimeEarned;
  @override
  @JsonKey()
  final String rank;
  @override
  @JsonKey()
  final HibonsRank rankEnum;
  @override
  @JsonKey()
  final String rankLabel;
  @override
  @JsonKey()
  final String rankIcon;
  @override
  final HibonsRank? nextRank;
  @override
  final String? nextRankLabel;
  @override
  final int? hibonsToNextRank;
  @override
  @JsonKey()
  final int progressToNextRank;
  @override
  @JsonKey()
  final int petitBooBonus;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int maxStreak;
  @override
  @JsonKey()
  final bool canClaimDaily;
  @override
  @JsonKey()
  final bool canSpinWheel;
  @override
  final ChatQuota? chatQuota;
  final List<DailyRewardItem> _dailyRewards;
  @override
  @JsonKey()
  List<DailyRewardItem> get dailyRewards {
    if (_dailyRewards is EqualUnmodifiableListView) return _dailyRewards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyRewards);
  }

// Champs legacy pour compatibilité (non utilisés par l'API)
  @override
  @JsonKey()
  final bool streakShieldActive;
  @override
  final DateTime? lastActionDate;
  @override
  @Deprecated('Use lifetimeEarned')
  final int? xp;
  @override
  @Deprecated('Use rankEnum')
  final int? level;
  @override
  @Deprecated('Use progressToNextRank')
  final int? progressToNextLevel;

  @override
  String toString() {
    return 'HibonsWallet(balance: $balance, lifetimeEarned: $lifetimeEarned, rank: $rank, rankEnum: $rankEnum, rankLabel: $rankLabel, rankIcon: $rankIcon, nextRank: $nextRank, nextRankLabel: $nextRankLabel, hibonsToNextRank: $hibonsToNextRank, progressToNextRank: $progressToNextRank, petitBooBonus: $petitBooBonus, currentStreak: $currentStreak, maxStreak: $maxStreak, canClaimDaily: $canClaimDaily, canSpinWheel: $canSpinWheel, chatQuota: $chatQuota, dailyRewards: $dailyRewards, streakShieldActive: $streakShieldActive, lastActionDate: $lastActionDate, xp: $xp, level: $level, progressToNextLevel: $progressToNextLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HibonsWalletImpl &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.lifetimeEarned, lifetimeEarned) ||
                other.lifetimeEarned == lifetimeEarned) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.rankEnum, rankEnum) ||
                other.rankEnum == rankEnum) &&
            (identical(other.rankLabel, rankLabel) ||
                other.rankLabel == rankLabel) &&
            (identical(other.rankIcon, rankIcon) ||
                other.rankIcon == rankIcon) &&
            (identical(other.nextRank, nextRank) ||
                other.nextRank == nextRank) &&
            (identical(other.nextRankLabel, nextRankLabel) ||
                other.nextRankLabel == nextRankLabel) &&
            (identical(other.hibonsToNextRank, hibonsToNextRank) ||
                other.hibonsToNextRank == hibonsToNextRank) &&
            (identical(other.progressToNextRank, progressToNextRank) ||
                other.progressToNextRank == progressToNextRank) &&
            (identical(other.petitBooBonus, petitBooBonus) ||
                other.petitBooBonus == petitBooBonus) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.maxStreak, maxStreak) ||
                other.maxStreak == maxStreak) &&
            (identical(other.canClaimDaily, canClaimDaily) ||
                other.canClaimDaily == canClaimDaily) &&
            (identical(other.canSpinWheel, canSpinWheel) ||
                other.canSpinWheel == canSpinWheel) &&
            (identical(other.chatQuota, chatQuota) ||
                other.chatQuota == chatQuota) &&
            const DeepCollectionEquality()
                .equals(other._dailyRewards, _dailyRewards) &&
            (identical(other.streakShieldActive, streakShieldActive) ||
                other.streakShieldActive == streakShieldActive) &&
            (identical(other.lastActionDate, lastActionDate) ||
                other.lastActionDate == lastActionDate) &&
            (identical(other.xp, xp) || other.xp == xp) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.progressToNextLevel, progressToNextLevel) ||
                other.progressToNextLevel == progressToNextLevel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        balance,
        lifetimeEarned,
        rank,
        rankEnum,
        rankLabel,
        rankIcon,
        nextRank,
        nextRankLabel,
        hibonsToNextRank,
        progressToNextRank,
        petitBooBonus,
        currentStreak,
        maxStreak,
        canClaimDaily,
        canSpinWheel,
        chatQuota,
        const DeepCollectionEquality().hash(_dailyRewards),
        streakShieldActive,
        lastActionDate,
        xp,
        level,
        progressToNextLevel
      ]);

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
      {final int balance,
      final int lifetimeEarned,
      final String rank,
      final HibonsRank rankEnum,
      final String rankLabel,
      final String rankIcon,
      final HibonsRank? nextRank,
      final String? nextRankLabel,
      final int? hibonsToNextRank,
      final int progressToNextRank,
      final int petitBooBonus,
      final int currentStreak,
      final int maxStreak,
      final bool canClaimDaily,
      final bool canSpinWheel,
      final ChatQuota? chatQuota,
      final List<DailyRewardItem> dailyRewards,
      final bool streakShieldActive,
      final DateTime? lastActionDate,
      @Deprecated('Use lifetimeEarned') final int? xp,
      @Deprecated('Use rankEnum') final int? level,
      @Deprecated('Use progressToNextRank')
      final int? progressToNextLevel}) = _$HibonsWalletImpl;

  factory _HibonsWallet.fromJson(Map<String, dynamic> json) =
      _$HibonsWalletImpl.fromJson;

  @override
  int get balance;
  @override
  int get lifetimeEarned;
  @override
  String get rank;
  @override
  HibonsRank get rankEnum;
  @override
  String get rankLabel;
  @override
  String get rankIcon;
  @override
  HibonsRank? get nextRank;
  @override
  String? get nextRankLabel;
  @override
  int? get hibonsToNextRank;
  @override
  int get progressToNextRank;
  @override
  int get petitBooBonus;
  @override
  int get currentStreak;
  @override
  int get maxStreak;
  @override
  bool get canClaimDaily;
  @override
  bool get canSpinWheel;
  @override
  ChatQuota? get chatQuota;
  @override
  List<DailyRewardItem> get dailyRewards;
  @override // Champs legacy pour compatibilité (non utilisés par l'API)
  bool get streakShieldActive;
  @override
  DateTime? get lastActionDate;
  @override
  @Deprecated('Use lifetimeEarned')
  int? get xp;
  @override
  @Deprecated('Use rankEnum')
  int? get level;
  @override
  @Deprecated('Use progressToNextRank')
  int? get progressToNextLevel;
  @override
  @JsonKey(ignore: true)
  _$$HibonsWalletImplCopyWith<_$HibonsWalletImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatQuota _$ChatQuotaFromJson(Map<String, dynamic> json) {
  return _ChatQuota.fromJson(json);
}

/// @nodoc
mixin _$ChatQuota {
  int get remaining => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get used => throw _privateConstructorUsedError;
  DateTime? get resetsAt => throw _privateConstructorUsedError;
  bool get canUnlock => throw _privateConstructorUsedError;
  int get unlockCost => throw _privateConstructorUsedError;
  int get unlockMessages => throw _privateConstructorUsedError;
  int get baseLimit => throw _privateConstructorUsedError;
  int get rankBonus => throw _privateConstructorUsedError;
  int get unlockedToday => throw _privateConstructorUsedError;
  String get rank => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatQuotaCopyWith<ChatQuota> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatQuotaCopyWith<$Res> {
  factory $ChatQuotaCopyWith(ChatQuota value, $Res Function(ChatQuota) then) =
      _$ChatQuotaCopyWithImpl<$Res, ChatQuota>;
  @useResult
  $Res call(
      {int remaining,
      int limit,
      int used,
      DateTime? resetsAt,
      bool canUnlock,
      int unlockCost,
      int unlockMessages,
      int baseLimit,
      int rankBonus,
      int unlockedToday,
      String rank});
}

/// @nodoc
class _$ChatQuotaCopyWithImpl<$Res, $Val extends ChatQuota>
    implements $ChatQuotaCopyWith<$Res> {
  _$ChatQuotaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? remaining = null,
    Object? limit = null,
    Object? used = null,
    Object? resetsAt = freezed,
    Object? canUnlock = null,
    Object? unlockCost = null,
    Object? unlockMessages = null,
    Object? baseLimit = null,
    Object? rankBonus = null,
    Object? unlockedToday = null,
    Object? rank = null,
  }) {
    return _then(_value.copyWith(
      remaining: null == remaining
          ? _value.remaining
          : remaining // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      used: null == used
          ? _value.used
          : used // ignore: cast_nullable_to_non_nullable
              as int,
      resetsAt: freezed == resetsAt
          ? _value.resetsAt
          : resetsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      canUnlock: null == canUnlock
          ? _value.canUnlock
          : canUnlock // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockCost: null == unlockCost
          ? _value.unlockCost
          : unlockCost // ignore: cast_nullable_to_non_nullable
              as int,
      unlockMessages: null == unlockMessages
          ? _value.unlockMessages
          : unlockMessages // ignore: cast_nullable_to_non_nullable
              as int,
      baseLimit: null == baseLimit
          ? _value.baseLimit
          : baseLimit // ignore: cast_nullable_to_non_nullable
              as int,
      rankBonus: null == rankBonus
          ? _value.rankBonus
          : rankBonus // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedToday: null == unlockedToday
          ? _value.unlockedToday
          : unlockedToday // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatQuotaImplCopyWith<$Res>
    implements $ChatQuotaCopyWith<$Res> {
  factory _$$ChatQuotaImplCopyWith(
          _$ChatQuotaImpl value, $Res Function(_$ChatQuotaImpl) then) =
      __$$ChatQuotaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int remaining,
      int limit,
      int used,
      DateTime? resetsAt,
      bool canUnlock,
      int unlockCost,
      int unlockMessages,
      int baseLimit,
      int rankBonus,
      int unlockedToday,
      String rank});
}

/// @nodoc
class __$$ChatQuotaImplCopyWithImpl<$Res>
    extends _$ChatQuotaCopyWithImpl<$Res, _$ChatQuotaImpl>
    implements _$$ChatQuotaImplCopyWith<$Res> {
  __$$ChatQuotaImplCopyWithImpl(
      _$ChatQuotaImpl _value, $Res Function(_$ChatQuotaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? remaining = null,
    Object? limit = null,
    Object? used = null,
    Object? resetsAt = freezed,
    Object? canUnlock = null,
    Object? unlockCost = null,
    Object? unlockMessages = null,
    Object? baseLimit = null,
    Object? rankBonus = null,
    Object? unlockedToday = null,
    Object? rank = null,
  }) {
    return _then(_$ChatQuotaImpl(
      remaining: null == remaining
          ? _value.remaining
          : remaining // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      used: null == used
          ? _value.used
          : used // ignore: cast_nullable_to_non_nullable
              as int,
      resetsAt: freezed == resetsAt
          ? _value.resetsAt
          : resetsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      canUnlock: null == canUnlock
          ? _value.canUnlock
          : canUnlock // ignore: cast_nullable_to_non_nullable
              as bool,
      unlockCost: null == unlockCost
          ? _value.unlockCost
          : unlockCost // ignore: cast_nullable_to_non_nullable
              as int,
      unlockMessages: null == unlockMessages
          ? _value.unlockMessages
          : unlockMessages // ignore: cast_nullable_to_non_nullable
              as int,
      baseLimit: null == baseLimit
          ? _value.baseLimit
          : baseLimit // ignore: cast_nullable_to_non_nullable
              as int,
      rankBonus: null == rankBonus
          ? _value.rankBonus
          : rankBonus // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedToday: null == unlockedToday
          ? _value.unlockedToday
          : unlockedToday // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatQuotaImpl implements _ChatQuota {
  const _$ChatQuotaImpl(
      {this.remaining = 0,
      this.limit = 3,
      this.used = 0,
      this.resetsAt,
      this.canUnlock = false,
      this.unlockCost = 100,
      this.unlockMessages = 2,
      this.baseLimit = 3,
      this.rankBonus = 0,
      this.unlockedToday = 0,
      this.rank = 'curieux'});

  factory _$ChatQuotaImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatQuotaImplFromJson(json);

  @override
  @JsonKey()
  final int remaining;
  @override
  @JsonKey()
  final int limit;
  @override
  @JsonKey()
  final int used;
  @override
  final DateTime? resetsAt;
  @override
  @JsonKey()
  final bool canUnlock;
  @override
  @JsonKey()
  final int unlockCost;
  @override
  @JsonKey()
  final int unlockMessages;
  @override
  @JsonKey()
  final int baseLimit;
  @override
  @JsonKey()
  final int rankBonus;
  @override
  @JsonKey()
  final int unlockedToday;
  @override
  @JsonKey()
  final String rank;

  @override
  String toString() {
    return 'ChatQuota(remaining: $remaining, limit: $limit, used: $used, resetsAt: $resetsAt, canUnlock: $canUnlock, unlockCost: $unlockCost, unlockMessages: $unlockMessages, baseLimit: $baseLimit, rankBonus: $rankBonus, unlockedToday: $unlockedToday, rank: $rank)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatQuotaImpl &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.used, used) || other.used == used) &&
            (identical(other.resetsAt, resetsAt) ||
                other.resetsAt == resetsAt) &&
            (identical(other.canUnlock, canUnlock) ||
                other.canUnlock == canUnlock) &&
            (identical(other.unlockCost, unlockCost) ||
                other.unlockCost == unlockCost) &&
            (identical(other.unlockMessages, unlockMessages) ||
                other.unlockMessages == unlockMessages) &&
            (identical(other.baseLimit, baseLimit) ||
                other.baseLimit == baseLimit) &&
            (identical(other.rankBonus, rankBonus) ||
                other.rankBonus == rankBonus) &&
            (identical(other.unlockedToday, unlockedToday) ||
                other.unlockedToday == unlockedToday) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      remaining,
      limit,
      used,
      resetsAt,
      canUnlock,
      unlockCost,
      unlockMessages,
      baseLimit,
      rankBonus,
      unlockedToday,
      rank);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatQuotaImplCopyWith<_$ChatQuotaImpl> get copyWith =>
      __$$ChatQuotaImplCopyWithImpl<_$ChatQuotaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatQuotaImplToJson(
      this,
    );
  }
}

abstract class _ChatQuota implements ChatQuota {
  const factory _ChatQuota(
      {final int remaining,
      final int limit,
      final int used,
      final DateTime? resetsAt,
      final bool canUnlock,
      final int unlockCost,
      final int unlockMessages,
      final int baseLimit,
      final int rankBonus,
      final int unlockedToday,
      final String rank}) = _$ChatQuotaImpl;

  factory _ChatQuota.fromJson(Map<String, dynamic> json) =
      _$ChatQuotaImpl.fromJson;

  @override
  int get remaining;
  @override
  int get limit;
  @override
  int get used;
  @override
  DateTime? get resetsAt;
  @override
  bool get canUnlock;
  @override
  int get unlockCost;
  @override
  int get unlockMessages;
  @override
  int get baseLimit;
  @override
  int get rankBonus;
  @override
  int get unlockedToday;
  @override
  String get rank;
  @override
  @JsonKey(ignore: true)
  _$$ChatQuotaImplCopyWith<_$ChatQuotaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyRewardItem _$DailyRewardItemFromJson(Map<String, dynamic> json) {
  return _DailyRewardItem.fromJson(json);
}

/// @nodoc
mixin _$DailyRewardItem {
  int get day => throw _privateConstructorUsedError;
  int get hibons => throw _privateConstructorUsedError;
  bool get claimed => throw _privateConstructorUsedError;
  bool get current => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyRewardItemCopyWith<DailyRewardItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyRewardItemCopyWith<$Res> {
  factory $DailyRewardItemCopyWith(
          DailyRewardItem value, $Res Function(DailyRewardItem) then) =
      _$DailyRewardItemCopyWithImpl<$Res, DailyRewardItem>;
  @useResult
  $Res call({int day, int hibons, bool claimed, bool current});
}

/// @nodoc
class _$DailyRewardItemCopyWithImpl<$Res, $Val extends DailyRewardItem>
    implements $DailyRewardItemCopyWith<$Res> {
  _$DailyRewardItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? hibons = null,
    Object? claimed = null,
    Object? current = null,
  }) {
    return _then(_value.copyWith(
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
      hibons: null == hibons
          ? _value.hibons
          : hibons // ignore: cast_nullable_to_non_nullable
              as int,
      claimed: null == claimed
          ? _value.claimed
          : claimed // ignore: cast_nullable_to_non_nullable
              as bool,
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyRewardItemImplCopyWith<$Res>
    implements $DailyRewardItemCopyWith<$Res> {
  factory _$$DailyRewardItemImplCopyWith(_$DailyRewardItemImpl value,
          $Res Function(_$DailyRewardItemImpl) then) =
      __$$DailyRewardItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int day, int hibons, bool claimed, bool current});
}

/// @nodoc
class __$$DailyRewardItemImplCopyWithImpl<$Res>
    extends _$DailyRewardItemCopyWithImpl<$Res, _$DailyRewardItemImpl>
    implements _$$DailyRewardItemImplCopyWith<$Res> {
  __$$DailyRewardItemImplCopyWithImpl(
      _$DailyRewardItemImpl _value, $Res Function(_$DailyRewardItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? hibons = null,
    Object? claimed = null,
    Object? current = null,
  }) {
    return _then(_$DailyRewardItemImpl(
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
      hibons: null == hibons
          ? _value.hibons
          : hibons // ignore: cast_nullable_to_non_nullable
              as int,
      claimed: null == claimed
          ? _value.claimed
          : claimed // ignore: cast_nullable_to_non_nullable
              as bool,
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyRewardItemImpl implements _DailyRewardItem {
  const _$DailyRewardItemImpl(
      {required this.day,
      required this.hibons,
      required this.claimed,
      required this.current});

  factory _$DailyRewardItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyRewardItemImplFromJson(json);

  @override
  final int day;
  @override
  final int hibons;
  @override
  final bool claimed;
  @override
  final bool current;

  @override
  String toString() {
    return 'DailyRewardItem(day: $day, hibons: $hibons, claimed: $claimed, current: $current)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyRewardItemImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.hibons, hibons) || other.hibons == hibons) &&
            (identical(other.claimed, claimed) || other.claimed == claimed) &&
            (identical(other.current, current) || other.current == current));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, day, hibons, claimed, current);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyRewardItemImplCopyWith<_$DailyRewardItemImpl> get copyWith =>
      __$$DailyRewardItemImplCopyWithImpl<_$DailyRewardItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyRewardItemImplToJson(
      this,
    );
  }
}

abstract class _DailyRewardItem implements DailyRewardItem {
  const factory _DailyRewardItem(
      {required final int day,
      required final int hibons,
      required final bool claimed,
      required final bool current}) = _$DailyRewardItemImpl;

  factory _DailyRewardItem.fromJson(Map<String, dynamic> json) =
      _$DailyRewardItemImpl.fromJson;

  @override
  int get day;
  @override
  int get hibons;
  @override
  bool get claimed;
  @override
  bool get current;
  @override
  @JsonKey(ignore: true)
  _$$DailyRewardItemImplCopyWith<_$DailyRewardItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

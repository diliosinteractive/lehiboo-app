// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hibons_api_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletResponseDto _$WalletResponseDtoFromJson(Map<String, dynamic> json) {
  return _WalletResponseDto.fromJson(json);
}

/// @nodoc
mixin _$WalletResponseDto {
  int get balance => throw _privateConstructorUsedError;
  int get xp => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  String get rank => throw _privateConstructorUsedError;
  @JsonKey(name: 'rank_label')
  String get rankLabel => throw _privateConstructorUsedError;
  @JsonKey(name: 'rank_icon')
  String get rankIcon => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_streak')
  int get currentStreak => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_streak')
  int get maxStreak => throw _privateConstructorUsedError;
  @JsonKey(name: 'progress_to_next_level')
  int get progressToNextLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_claim_daily')
  bool get canClaimDaily => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_spin_wheel')
  bool get canSpinWheel => throw _privateConstructorUsedError;
  @JsonKey(name: 'chat_quota')
  ChatQuotaDto get chatQuota => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_rewards')
  List<DailyRewardItemDto> get dailyRewards =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WalletResponseDtoCopyWith<WalletResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletResponseDtoCopyWith<$Res> {
  factory $WalletResponseDtoCopyWith(
          WalletResponseDto value, $Res Function(WalletResponseDto) then) =
      _$WalletResponseDtoCopyWithImpl<$Res, WalletResponseDto>;
  @useResult
  $Res call(
      {int balance,
      int xp,
      int level,
      String rank,
      @JsonKey(name: 'rank_label') String rankLabel,
      @JsonKey(name: 'rank_icon') String rankIcon,
      @JsonKey(name: 'current_streak') int currentStreak,
      @JsonKey(name: 'max_streak') int maxStreak,
      @JsonKey(name: 'progress_to_next_level') int progressToNextLevel,
      @JsonKey(name: 'can_claim_daily') bool canClaimDaily,
      @JsonKey(name: 'can_spin_wheel') bool canSpinWheel,
      @JsonKey(name: 'chat_quota') ChatQuotaDto chatQuota,
      @JsonKey(name: 'daily_rewards') List<DailyRewardItemDto> dailyRewards});

  $ChatQuotaDtoCopyWith<$Res> get chatQuota;
}

/// @nodoc
class _$WalletResponseDtoCopyWithImpl<$Res, $Val extends WalletResponseDto>
    implements $WalletResponseDtoCopyWith<$Res> {
  _$WalletResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balance = null,
    Object? xp = null,
    Object? level = null,
    Object? rank = null,
    Object? rankLabel = null,
    Object? rankIcon = null,
    Object? currentStreak = null,
    Object? maxStreak = null,
    Object? progressToNextLevel = null,
    Object? canClaimDaily = null,
    Object? canSpinWheel = null,
    Object? chatQuota = null,
    Object? dailyRewards = null,
  }) {
    return _then(_value.copyWith(
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
      rankLabel: null == rankLabel
          ? _value.rankLabel
          : rankLabel // ignore: cast_nullable_to_non_nullable
              as String,
      rankIcon: null == rankIcon
          ? _value.rankIcon
          : rankIcon // ignore: cast_nullable_to_non_nullable
              as String,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      maxStreak: null == maxStreak
          ? _value.maxStreak
          : maxStreak // ignore: cast_nullable_to_non_nullable
              as int,
      progressToNextLevel: null == progressToNextLevel
          ? _value.progressToNextLevel
          : progressToNextLevel // ignore: cast_nullable_to_non_nullable
              as int,
      canClaimDaily: null == canClaimDaily
          ? _value.canClaimDaily
          : canClaimDaily // ignore: cast_nullable_to_non_nullable
              as bool,
      canSpinWheel: null == canSpinWheel
          ? _value.canSpinWheel
          : canSpinWheel // ignore: cast_nullable_to_non_nullable
              as bool,
      chatQuota: null == chatQuota
          ? _value.chatQuota
          : chatQuota // ignore: cast_nullable_to_non_nullable
              as ChatQuotaDto,
      dailyRewards: null == dailyRewards
          ? _value.dailyRewards
          : dailyRewards // ignore: cast_nullable_to_non_nullable
              as List<DailyRewardItemDto>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ChatQuotaDtoCopyWith<$Res> get chatQuota {
    return $ChatQuotaDtoCopyWith<$Res>(_value.chatQuota, (value) {
      return _then(_value.copyWith(chatQuota: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WalletResponseDtoImplCopyWith<$Res>
    implements $WalletResponseDtoCopyWith<$Res> {
  factory _$$WalletResponseDtoImplCopyWith(_$WalletResponseDtoImpl value,
          $Res Function(_$WalletResponseDtoImpl) then) =
      __$$WalletResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int balance,
      int xp,
      int level,
      String rank,
      @JsonKey(name: 'rank_label') String rankLabel,
      @JsonKey(name: 'rank_icon') String rankIcon,
      @JsonKey(name: 'current_streak') int currentStreak,
      @JsonKey(name: 'max_streak') int maxStreak,
      @JsonKey(name: 'progress_to_next_level') int progressToNextLevel,
      @JsonKey(name: 'can_claim_daily') bool canClaimDaily,
      @JsonKey(name: 'can_spin_wheel') bool canSpinWheel,
      @JsonKey(name: 'chat_quota') ChatQuotaDto chatQuota,
      @JsonKey(name: 'daily_rewards') List<DailyRewardItemDto> dailyRewards});

  @override
  $ChatQuotaDtoCopyWith<$Res> get chatQuota;
}

/// @nodoc
class __$$WalletResponseDtoImplCopyWithImpl<$Res>
    extends _$WalletResponseDtoCopyWithImpl<$Res, _$WalletResponseDtoImpl>
    implements _$$WalletResponseDtoImplCopyWith<$Res> {
  __$$WalletResponseDtoImplCopyWithImpl(_$WalletResponseDtoImpl _value,
      $Res Function(_$WalletResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? balance = null,
    Object? xp = null,
    Object? level = null,
    Object? rank = null,
    Object? rankLabel = null,
    Object? rankIcon = null,
    Object? currentStreak = null,
    Object? maxStreak = null,
    Object? progressToNextLevel = null,
    Object? canClaimDaily = null,
    Object? canSpinWheel = null,
    Object? chatQuota = null,
    Object? dailyRewards = null,
  }) {
    return _then(_$WalletResponseDtoImpl(
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
      rankLabel: null == rankLabel
          ? _value.rankLabel
          : rankLabel // ignore: cast_nullable_to_non_nullable
              as String,
      rankIcon: null == rankIcon
          ? _value.rankIcon
          : rankIcon // ignore: cast_nullable_to_non_nullable
              as String,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      maxStreak: null == maxStreak
          ? _value.maxStreak
          : maxStreak // ignore: cast_nullable_to_non_nullable
              as int,
      progressToNextLevel: null == progressToNextLevel
          ? _value.progressToNextLevel
          : progressToNextLevel // ignore: cast_nullable_to_non_nullable
              as int,
      canClaimDaily: null == canClaimDaily
          ? _value.canClaimDaily
          : canClaimDaily // ignore: cast_nullable_to_non_nullable
              as bool,
      canSpinWheel: null == canSpinWheel
          ? _value.canSpinWheel
          : canSpinWheel // ignore: cast_nullable_to_non_nullable
              as bool,
      chatQuota: null == chatQuota
          ? _value.chatQuota
          : chatQuota // ignore: cast_nullable_to_non_nullable
              as ChatQuotaDto,
      dailyRewards: null == dailyRewards
          ? _value._dailyRewards
          : dailyRewards // ignore: cast_nullable_to_non_nullable
              as List<DailyRewardItemDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletResponseDtoImpl implements _WalletResponseDto {
  const _$WalletResponseDtoImpl(
      {required this.balance,
      required this.xp,
      required this.level,
      required this.rank,
      @JsonKey(name: 'rank_label') required this.rankLabel,
      @JsonKey(name: 'rank_icon') required this.rankIcon,
      @JsonKey(name: 'current_streak') required this.currentStreak,
      @JsonKey(name: 'max_streak') required this.maxStreak,
      @JsonKey(name: 'progress_to_next_level')
      required this.progressToNextLevel,
      @JsonKey(name: 'can_claim_daily') required this.canClaimDaily,
      @JsonKey(name: 'can_spin_wheel') required this.canSpinWheel,
      @JsonKey(name: 'chat_quota') required this.chatQuota,
      @JsonKey(name: 'daily_rewards')
      required final List<DailyRewardItemDto> dailyRewards})
      : _dailyRewards = dailyRewards;

  factory _$WalletResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletResponseDtoImplFromJson(json);

  @override
  final int balance;
  @override
  final int xp;
  @override
  final int level;
  @override
  final String rank;
  @override
  @JsonKey(name: 'rank_label')
  final String rankLabel;
  @override
  @JsonKey(name: 'rank_icon')
  final String rankIcon;
  @override
  @JsonKey(name: 'current_streak')
  final int currentStreak;
  @override
  @JsonKey(name: 'max_streak')
  final int maxStreak;
  @override
  @JsonKey(name: 'progress_to_next_level')
  final int progressToNextLevel;
  @override
  @JsonKey(name: 'can_claim_daily')
  final bool canClaimDaily;
  @override
  @JsonKey(name: 'can_spin_wheel')
  final bool canSpinWheel;
  @override
  @JsonKey(name: 'chat_quota')
  final ChatQuotaDto chatQuota;
  final List<DailyRewardItemDto> _dailyRewards;
  @override
  @JsonKey(name: 'daily_rewards')
  List<DailyRewardItemDto> get dailyRewards {
    if (_dailyRewards is EqualUnmodifiableListView) return _dailyRewards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dailyRewards);
  }

  @override
  String toString() {
    return 'WalletResponseDto(balance: $balance, xp: $xp, level: $level, rank: $rank, rankLabel: $rankLabel, rankIcon: $rankIcon, currentStreak: $currentStreak, maxStreak: $maxStreak, progressToNextLevel: $progressToNextLevel, canClaimDaily: $canClaimDaily, canSpinWheel: $canSpinWheel, chatQuota: $chatQuota, dailyRewards: $dailyRewards)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletResponseDtoImpl &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.xp, xp) || other.xp == xp) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.rankLabel, rankLabel) ||
                other.rankLabel == rankLabel) &&
            (identical(other.rankIcon, rankIcon) ||
                other.rankIcon == rankIcon) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.maxStreak, maxStreak) ||
                other.maxStreak == maxStreak) &&
            (identical(other.progressToNextLevel, progressToNextLevel) ||
                other.progressToNextLevel == progressToNextLevel) &&
            (identical(other.canClaimDaily, canClaimDaily) ||
                other.canClaimDaily == canClaimDaily) &&
            (identical(other.canSpinWheel, canSpinWheel) ||
                other.canSpinWheel == canSpinWheel) &&
            (identical(other.chatQuota, chatQuota) ||
                other.chatQuota == chatQuota) &&
            const DeepCollectionEquality()
                .equals(other._dailyRewards, _dailyRewards));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      balance,
      xp,
      level,
      rank,
      rankLabel,
      rankIcon,
      currentStreak,
      maxStreak,
      progressToNextLevel,
      canClaimDaily,
      canSpinWheel,
      chatQuota,
      const DeepCollectionEquality().hash(_dailyRewards));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletResponseDtoImplCopyWith<_$WalletResponseDtoImpl> get copyWith =>
      __$$WalletResponseDtoImplCopyWithImpl<_$WalletResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _WalletResponseDto implements WalletResponseDto {
  const factory _WalletResponseDto(
          {required final int balance,
          required final int xp,
          required final int level,
          required final String rank,
          @JsonKey(name: 'rank_label') required final String rankLabel,
          @JsonKey(name: 'rank_icon') required final String rankIcon,
          @JsonKey(name: 'current_streak') required final int currentStreak,
          @JsonKey(name: 'max_streak') required final int maxStreak,
          @JsonKey(name: 'progress_to_next_level')
          required final int progressToNextLevel,
          @JsonKey(name: 'can_claim_daily') required final bool canClaimDaily,
          @JsonKey(name: 'can_spin_wheel') required final bool canSpinWheel,
          @JsonKey(name: 'chat_quota') required final ChatQuotaDto chatQuota,
          @JsonKey(name: 'daily_rewards')
          required final List<DailyRewardItemDto> dailyRewards}) =
      _$WalletResponseDtoImpl;

  factory _WalletResponseDto.fromJson(Map<String, dynamic> json) =
      _$WalletResponseDtoImpl.fromJson;

  @override
  int get balance;
  @override
  int get xp;
  @override
  int get level;
  @override
  String get rank;
  @override
  @JsonKey(name: 'rank_label')
  String get rankLabel;
  @override
  @JsonKey(name: 'rank_icon')
  String get rankIcon;
  @override
  @JsonKey(name: 'current_streak')
  int get currentStreak;
  @override
  @JsonKey(name: 'max_streak')
  int get maxStreak;
  @override
  @JsonKey(name: 'progress_to_next_level')
  int get progressToNextLevel;
  @override
  @JsonKey(name: 'can_claim_daily')
  bool get canClaimDaily;
  @override
  @JsonKey(name: 'can_spin_wheel')
  bool get canSpinWheel;
  @override
  @JsonKey(name: 'chat_quota')
  ChatQuotaDto get chatQuota;
  @override
  @JsonKey(name: 'daily_rewards')
  List<DailyRewardItemDto> get dailyRewards;
  @override
  @JsonKey(ignore: true)
  _$$WalletResponseDtoImplCopyWith<_$WalletResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatQuotaDto _$ChatQuotaDtoFromJson(Map<String, dynamic> json) {
  return _ChatQuotaDto.fromJson(json);
}

/// @nodoc
mixin _$ChatQuotaDto {
  int get remaining => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get used => throw _privateConstructorUsedError;
  @JsonKey(name: 'resets_at')
  String get resetsAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_unlock')
  bool get canUnlock => throw _privateConstructorUsedError;
  @JsonKey(name: 'unlock_cost')
  int get unlockCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'unlock_messages')
  int get unlockMessages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatQuotaDtoCopyWith<ChatQuotaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatQuotaDtoCopyWith<$Res> {
  factory $ChatQuotaDtoCopyWith(
          ChatQuotaDto value, $Res Function(ChatQuotaDto) then) =
      _$ChatQuotaDtoCopyWithImpl<$Res, ChatQuotaDto>;
  @useResult
  $Res call(
      {int remaining,
      int limit,
      int used,
      @JsonKey(name: 'resets_at') String resetsAt,
      @JsonKey(name: 'can_unlock') bool canUnlock,
      @JsonKey(name: 'unlock_cost') int unlockCost,
      @JsonKey(name: 'unlock_messages') int unlockMessages});
}

/// @nodoc
class _$ChatQuotaDtoCopyWithImpl<$Res, $Val extends ChatQuotaDto>
    implements $ChatQuotaDtoCopyWith<$Res> {
  _$ChatQuotaDtoCopyWithImpl(this._value, this._then);

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
    Object? resetsAt = null,
    Object? canUnlock = null,
    Object? unlockCost = null,
    Object? unlockMessages = null,
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
      resetsAt: null == resetsAt
          ? _value.resetsAt
          : resetsAt // ignore: cast_nullable_to_non_nullable
              as String,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatQuotaDtoImplCopyWith<$Res>
    implements $ChatQuotaDtoCopyWith<$Res> {
  factory _$$ChatQuotaDtoImplCopyWith(
          _$ChatQuotaDtoImpl value, $Res Function(_$ChatQuotaDtoImpl) then) =
      __$$ChatQuotaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int remaining,
      int limit,
      int used,
      @JsonKey(name: 'resets_at') String resetsAt,
      @JsonKey(name: 'can_unlock') bool canUnlock,
      @JsonKey(name: 'unlock_cost') int unlockCost,
      @JsonKey(name: 'unlock_messages') int unlockMessages});
}

/// @nodoc
class __$$ChatQuotaDtoImplCopyWithImpl<$Res>
    extends _$ChatQuotaDtoCopyWithImpl<$Res, _$ChatQuotaDtoImpl>
    implements _$$ChatQuotaDtoImplCopyWith<$Res> {
  __$$ChatQuotaDtoImplCopyWithImpl(
      _$ChatQuotaDtoImpl _value, $Res Function(_$ChatQuotaDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? remaining = null,
    Object? limit = null,
    Object? used = null,
    Object? resetsAt = null,
    Object? canUnlock = null,
    Object? unlockCost = null,
    Object? unlockMessages = null,
  }) {
    return _then(_$ChatQuotaDtoImpl(
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
      resetsAt: null == resetsAt
          ? _value.resetsAt
          : resetsAt // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatQuotaDtoImpl implements _ChatQuotaDto {
  const _$ChatQuotaDtoImpl(
      {required this.remaining,
      required this.limit,
      required this.used,
      @JsonKey(name: 'resets_at') required this.resetsAt,
      @JsonKey(name: 'can_unlock') required this.canUnlock,
      @JsonKey(name: 'unlock_cost') required this.unlockCost,
      @JsonKey(name: 'unlock_messages') required this.unlockMessages});

  factory _$ChatQuotaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatQuotaDtoImplFromJson(json);

  @override
  final int remaining;
  @override
  final int limit;
  @override
  final int used;
  @override
  @JsonKey(name: 'resets_at')
  final String resetsAt;
  @override
  @JsonKey(name: 'can_unlock')
  final bool canUnlock;
  @override
  @JsonKey(name: 'unlock_cost')
  final int unlockCost;
  @override
  @JsonKey(name: 'unlock_messages')
  final int unlockMessages;

  @override
  String toString() {
    return 'ChatQuotaDto(remaining: $remaining, limit: $limit, used: $used, resetsAt: $resetsAt, canUnlock: $canUnlock, unlockCost: $unlockCost, unlockMessages: $unlockMessages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatQuotaDtoImpl &&
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
                other.unlockMessages == unlockMessages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, remaining, limit, used, resetsAt,
      canUnlock, unlockCost, unlockMessages);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatQuotaDtoImplCopyWith<_$ChatQuotaDtoImpl> get copyWith =>
      __$$ChatQuotaDtoImplCopyWithImpl<_$ChatQuotaDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatQuotaDtoImplToJson(
      this,
    );
  }
}

abstract class _ChatQuotaDto implements ChatQuotaDto {
  const factory _ChatQuotaDto(
      {required final int remaining,
      required final int limit,
      required final int used,
      @JsonKey(name: 'resets_at') required final String resetsAt,
      @JsonKey(name: 'can_unlock') required final bool canUnlock,
      @JsonKey(name: 'unlock_cost') required final int unlockCost,
      @JsonKey(name: 'unlock_messages')
      required final int unlockMessages}) = _$ChatQuotaDtoImpl;

  factory _ChatQuotaDto.fromJson(Map<String, dynamic> json) =
      _$ChatQuotaDtoImpl.fromJson;

  @override
  int get remaining;
  @override
  int get limit;
  @override
  int get used;
  @override
  @JsonKey(name: 'resets_at')
  String get resetsAt;
  @override
  @JsonKey(name: 'can_unlock')
  bool get canUnlock;
  @override
  @JsonKey(name: 'unlock_cost')
  int get unlockCost;
  @override
  @JsonKey(name: 'unlock_messages')
  int get unlockMessages;
  @override
  @JsonKey(ignore: true)
  _$$ChatQuotaDtoImplCopyWith<_$ChatQuotaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyRewardItemDto _$DailyRewardItemDtoFromJson(Map<String, dynamic> json) {
  return _DailyRewardItemDto.fromJson(json);
}

/// @nodoc
mixin _$DailyRewardItemDto {
  int get day => throw _privateConstructorUsedError;
  int get hibons => throw _privateConstructorUsedError;
  bool get claimed => throw _privateConstructorUsedError;
  bool get current => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyRewardItemDtoCopyWith<DailyRewardItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyRewardItemDtoCopyWith<$Res> {
  factory $DailyRewardItemDtoCopyWith(
          DailyRewardItemDto value, $Res Function(DailyRewardItemDto) then) =
      _$DailyRewardItemDtoCopyWithImpl<$Res, DailyRewardItemDto>;
  @useResult
  $Res call({int day, int hibons, bool claimed, bool current});
}

/// @nodoc
class _$DailyRewardItemDtoCopyWithImpl<$Res, $Val extends DailyRewardItemDto>
    implements $DailyRewardItemDtoCopyWith<$Res> {
  _$DailyRewardItemDtoCopyWithImpl(this._value, this._then);

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
abstract class _$$DailyRewardItemDtoImplCopyWith<$Res>
    implements $DailyRewardItemDtoCopyWith<$Res> {
  factory _$$DailyRewardItemDtoImplCopyWith(_$DailyRewardItemDtoImpl value,
          $Res Function(_$DailyRewardItemDtoImpl) then) =
      __$$DailyRewardItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int day, int hibons, bool claimed, bool current});
}

/// @nodoc
class __$$DailyRewardItemDtoImplCopyWithImpl<$Res>
    extends _$DailyRewardItemDtoCopyWithImpl<$Res, _$DailyRewardItemDtoImpl>
    implements _$$DailyRewardItemDtoImplCopyWith<$Res> {
  __$$DailyRewardItemDtoImplCopyWithImpl(_$DailyRewardItemDtoImpl _value,
      $Res Function(_$DailyRewardItemDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? hibons = null,
    Object? claimed = null,
    Object? current = null,
  }) {
    return _then(_$DailyRewardItemDtoImpl(
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
class _$DailyRewardItemDtoImpl implements _DailyRewardItemDto {
  const _$DailyRewardItemDtoImpl(
      {required this.day,
      required this.hibons,
      required this.claimed,
      required this.current});

  factory _$DailyRewardItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyRewardItemDtoImplFromJson(json);

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
    return 'DailyRewardItemDto(day: $day, hibons: $hibons, claimed: $claimed, current: $current)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyRewardItemDtoImpl &&
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
  _$$DailyRewardItemDtoImplCopyWith<_$DailyRewardItemDtoImpl> get copyWith =>
      __$$DailyRewardItemDtoImplCopyWithImpl<_$DailyRewardItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyRewardItemDtoImplToJson(
      this,
    );
  }
}

abstract class _DailyRewardItemDto implements DailyRewardItemDto {
  const factory _DailyRewardItemDto(
      {required final int day,
      required final int hibons,
      required final bool claimed,
      required final bool current}) = _$DailyRewardItemDtoImpl;

  factory _DailyRewardItemDto.fromJson(Map<String, dynamic> json) =
      _$DailyRewardItemDtoImpl.fromJson;

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
  _$$DailyRewardItemDtoImplCopyWith<_$DailyRewardItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyClaimResponseDto _$DailyClaimResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _DailyClaimResponseDto.fromJson(json);
}

/// @nodoc
mixin _$DailyClaimResponseDto {
  String get message => throw _privateConstructorUsedError;
  int get hibons => throw _privateConstructorUsedError;
  int get day => throw _privateConstructorUsedError;
  int get streak => throw _privateConstructorUsedError;
  @JsonKey(name: 'next_rewards')
  List<NextRewardDto> get nextRewards => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_balance')
  int get newBalance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DailyClaimResponseDtoCopyWith<DailyClaimResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyClaimResponseDtoCopyWith<$Res> {
  factory $DailyClaimResponseDtoCopyWith(DailyClaimResponseDto value,
          $Res Function(DailyClaimResponseDto) then) =
      _$DailyClaimResponseDtoCopyWithImpl<$Res, DailyClaimResponseDto>;
  @useResult
  $Res call(
      {String message,
      int hibons,
      int day,
      int streak,
      @JsonKey(name: 'next_rewards') List<NextRewardDto> nextRewards,
      @JsonKey(name: 'new_balance') int newBalance});
}

/// @nodoc
class _$DailyClaimResponseDtoCopyWithImpl<$Res,
        $Val extends DailyClaimResponseDto>
    implements $DailyClaimResponseDtoCopyWith<$Res> {
  _$DailyClaimResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? hibons = null,
    Object? day = null,
    Object? streak = null,
    Object? nextRewards = null,
    Object? newBalance = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      hibons: null == hibons
          ? _value.hibons
          : hibons // ignore: cast_nullable_to_non_nullable
              as int,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      nextRewards: null == nextRewards
          ? _value.nextRewards
          : nextRewards // ignore: cast_nullable_to_non_nullable
              as List<NextRewardDto>,
      newBalance: null == newBalance
          ? _value.newBalance
          : newBalance // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyClaimResponseDtoImplCopyWith<$Res>
    implements $DailyClaimResponseDtoCopyWith<$Res> {
  factory _$$DailyClaimResponseDtoImplCopyWith(
          _$DailyClaimResponseDtoImpl value,
          $Res Function(_$DailyClaimResponseDtoImpl) then) =
      __$$DailyClaimResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      int hibons,
      int day,
      int streak,
      @JsonKey(name: 'next_rewards') List<NextRewardDto> nextRewards,
      @JsonKey(name: 'new_balance') int newBalance});
}

/// @nodoc
class __$$DailyClaimResponseDtoImplCopyWithImpl<$Res>
    extends _$DailyClaimResponseDtoCopyWithImpl<$Res,
        _$DailyClaimResponseDtoImpl>
    implements _$$DailyClaimResponseDtoImplCopyWith<$Res> {
  __$$DailyClaimResponseDtoImplCopyWithImpl(_$DailyClaimResponseDtoImpl _value,
      $Res Function(_$DailyClaimResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? hibons = null,
    Object? day = null,
    Object? streak = null,
    Object? nextRewards = null,
    Object? newBalance = null,
  }) {
    return _then(_$DailyClaimResponseDtoImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      hibons: null == hibons
          ? _value.hibons
          : hibons // ignore: cast_nullable_to_non_nullable
              as int,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      nextRewards: null == nextRewards
          ? _value._nextRewards
          : nextRewards // ignore: cast_nullable_to_non_nullable
              as List<NextRewardDto>,
      newBalance: null == newBalance
          ? _value.newBalance
          : newBalance // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyClaimResponseDtoImpl implements _DailyClaimResponseDto {
  const _$DailyClaimResponseDtoImpl(
      {required this.message,
      required this.hibons,
      required this.day,
      required this.streak,
      @JsonKey(name: 'next_rewards')
      required final List<NextRewardDto> nextRewards,
      @JsonKey(name: 'new_balance') required this.newBalance})
      : _nextRewards = nextRewards;

  factory _$DailyClaimResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyClaimResponseDtoImplFromJson(json);

  @override
  final String message;
  @override
  final int hibons;
  @override
  final int day;
  @override
  final int streak;
  final List<NextRewardDto> _nextRewards;
  @override
  @JsonKey(name: 'next_rewards')
  List<NextRewardDto> get nextRewards {
    if (_nextRewards is EqualUnmodifiableListView) return _nextRewards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nextRewards);
  }

  @override
  @JsonKey(name: 'new_balance')
  final int newBalance;

  @override
  String toString() {
    return 'DailyClaimResponseDto(message: $message, hibons: $hibons, day: $day, streak: $streak, nextRewards: $nextRewards, newBalance: $newBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyClaimResponseDtoImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.hibons, hibons) || other.hibons == hibons) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            const DeepCollectionEquality()
                .equals(other._nextRewards, _nextRewards) &&
            (identical(other.newBalance, newBalance) ||
                other.newBalance == newBalance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, hibons, day, streak,
      const DeepCollectionEquality().hash(_nextRewards), newBalance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyClaimResponseDtoImplCopyWith<_$DailyClaimResponseDtoImpl>
      get copyWith => __$$DailyClaimResponseDtoImplCopyWithImpl<
          _$DailyClaimResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyClaimResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _DailyClaimResponseDto implements DailyClaimResponseDto {
  const factory _DailyClaimResponseDto(
          {required final String message,
          required final int hibons,
          required final int day,
          required final int streak,
          @JsonKey(name: 'next_rewards')
          required final List<NextRewardDto> nextRewards,
          @JsonKey(name: 'new_balance') required final int newBalance}) =
      _$DailyClaimResponseDtoImpl;

  factory _DailyClaimResponseDto.fromJson(Map<String, dynamic> json) =
      _$DailyClaimResponseDtoImpl.fromJson;

  @override
  String get message;
  @override
  int get hibons;
  @override
  int get day;
  @override
  int get streak;
  @override
  @JsonKey(name: 'next_rewards')
  List<NextRewardDto> get nextRewards;
  @override
  @JsonKey(name: 'new_balance')
  int get newBalance;
  @override
  @JsonKey(ignore: true)
  _$$DailyClaimResponseDtoImplCopyWith<_$DailyClaimResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

NextRewardDto _$NextRewardDtoFromJson(Map<String, dynamic> json) {
  return _NextRewardDto.fromJson(json);
}

/// @nodoc
mixin _$NextRewardDto {
  int get day => throw _privateConstructorUsedError;
  int get hibons => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NextRewardDtoCopyWith<NextRewardDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NextRewardDtoCopyWith<$Res> {
  factory $NextRewardDtoCopyWith(
          NextRewardDto value, $Res Function(NextRewardDto) then) =
      _$NextRewardDtoCopyWithImpl<$Res, NextRewardDto>;
  @useResult
  $Res call({int day, int hibons});
}

/// @nodoc
class _$NextRewardDtoCopyWithImpl<$Res, $Val extends NextRewardDto>
    implements $NextRewardDtoCopyWith<$Res> {
  _$NextRewardDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? hibons = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NextRewardDtoImplCopyWith<$Res>
    implements $NextRewardDtoCopyWith<$Res> {
  factory _$$NextRewardDtoImplCopyWith(
          _$NextRewardDtoImpl value, $Res Function(_$NextRewardDtoImpl) then) =
      __$$NextRewardDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int day, int hibons});
}

/// @nodoc
class __$$NextRewardDtoImplCopyWithImpl<$Res>
    extends _$NextRewardDtoCopyWithImpl<$Res, _$NextRewardDtoImpl>
    implements _$$NextRewardDtoImplCopyWith<$Res> {
  __$$NextRewardDtoImplCopyWithImpl(
      _$NextRewardDtoImpl _value, $Res Function(_$NextRewardDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? day = null,
    Object? hibons = null,
  }) {
    return _then(_$NextRewardDtoImpl(
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as int,
      hibons: null == hibons
          ? _value.hibons
          : hibons // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NextRewardDtoImpl implements _NextRewardDto {
  const _$NextRewardDtoImpl({required this.day, required this.hibons});

  factory _$NextRewardDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NextRewardDtoImplFromJson(json);

  @override
  final int day;
  @override
  final int hibons;

  @override
  String toString() {
    return 'NextRewardDto(day: $day, hibons: $hibons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NextRewardDtoImpl &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.hibons, hibons) || other.hibons == hibons));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, day, hibons);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NextRewardDtoImplCopyWith<_$NextRewardDtoImpl> get copyWith =>
      __$$NextRewardDtoImplCopyWithImpl<_$NextRewardDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NextRewardDtoImplToJson(
      this,
    );
  }
}

abstract class _NextRewardDto implements NextRewardDto {
  const factory _NextRewardDto(
      {required final int day,
      required final int hibons}) = _$NextRewardDtoImpl;

  factory _NextRewardDto.fromJson(Map<String, dynamic> json) =
      _$NextRewardDtoImpl.fromJson;

  @override
  int get day;
  @override
  int get hibons;
  @override
  @JsonKey(ignore: true)
  _$$NextRewardDtoImplCopyWith<_$NextRewardDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WheelConfigResponseDto _$WheelConfigResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _WheelConfigResponseDto.fromJson(json);
}

/// @nodoc
mixin _$WheelConfigResponseDto {
  List<WheelPrizeDto> get prizes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WheelConfigResponseDtoCopyWith<WheelConfigResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WheelConfigResponseDtoCopyWith<$Res> {
  factory $WheelConfigResponseDtoCopyWith(WheelConfigResponseDto value,
          $Res Function(WheelConfigResponseDto) then) =
      _$WheelConfigResponseDtoCopyWithImpl<$Res, WheelConfigResponseDto>;
  @useResult
  $Res call({List<WheelPrizeDto> prizes});
}

/// @nodoc
class _$WheelConfigResponseDtoCopyWithImpl<$Res,
        $Val extends WheelConfigResponseDto>
    implements $WheelConfigResponseDtoCopyWith<$Res> {
  _$WheelConfigResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prizes = null,
  }) {
    return _then(_value.copyWith(
      prizes: null == prizes
          ? _value.prizes
          : prizes // ignore: cast_nullable_to_non_nullable
              as List<WheelPrizeDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WheelConfigResponseDtoImplCopyWith<$Res>
    implements $WheelConfigResponseDtoCopyWith<$Res> {
  factory _$$WheelConfigResponseDtoImplCopyWith(
          _$WheelConfigResponseDtoImpl value,
          $Res Function(_$WheelConfigResponseDtoImpl) then) =
      __$$WheelConfigResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<WheelPrizeDto> prizes});
}

/// @nodoc
class __$$WheelConfigResponseDtoImplCopyWithImpl<$Res>
    extends _$WheelConfigResponseDtoCopyWithImpl<$Res,
        _$WheelConfigResponseDtoImpl>
    implements _$$WheelConfigResponseDtoImplCopyWith<$Res> {
  __$$WheelConfigResponseDtoImplCopyWithImpl(
      _$WheelConfigResponseDtoImpl _value,
      $Res Function(_$WheelConfigResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prizes = null,
  }) {
    return _then(_$WheelConfigResponseDtoImpl(
      prizes: null == prizes
          ? _value._prizes
          : prizes // ignore: cast_nullable_to_non_nullable
              as List<WheelPrizeDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WheelConfigResponseDtoImpl implements _WheelConfigResponseDto {
  const _$WheelConfigResponseDtoImpl(
      {required final List<WheelPrizeDto> prizes})
      : _prizes = prizes;

  factory _$WheelConfigResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WheelConfigResponseDtoImplFromJson(json);

  final List<WheelPrizeDto> _prizes;
  @override
  List<WheelPrizeDto> get prizes {
    if (_prizes is EqualUnmodifiableListView) return _prizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prizes);
  }

  @override
  String toString() {
    return 'WheelConfigResponseDto(prizes: $prizes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WheelConfigResponseDtoImpl &&
            const DeepCollectionEquality().equals(other._prizes, _prizes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_prizes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WheelConfigResponseDtoImplCopyWith<_$WheelConfigResponseDtoImpl>
      get copyWith => __$$WheelConfigResponseDtoImplCopyWithImpl<
          _$WheelConfigResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WheelConfigResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _WheelConfigResponseDto implements WheelConfigResponseDto {
  const factory _WheelConfigResponseDto(
          {required final List<WheelPrizeDto> prizes}) =
      _$WheelConfigResponseDtoImpl;

  factory _WheelConfigResponseDto.fromJson(Map<String, dynamic> json) =
      _$WheelConfigResponseDtoImpl.fromJson;

  @override
  List<WheelPrizeDto> get prizes;
  @override
  @JsonKey(ignore: true)
  _$$WheelConfigResponseDtoImplCopyWith<_$WheelConfigResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

WheelPrizeDto _$WheelPrizeDtoFromJson(Map<String, dynamic> json) {
  return _WheelPrizeDto.fromJson(json);
}

/// @nodoc
mixin _$WheelPrizeDto {
  int get index => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WheelPrizeDtoCopyWith<WheelPrizeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WheelPrizeDtoCopyWith<$Res> {
  factory $WheelPrizeDtoCopyWith(
          WheelPrizeDto value, $Res Function(WheelPrizeDto) then) =
      _$WheelPrizeDtoCopyWithImpl<$Res, WheelPrizeDto>;
  @useResult
  $Res call({int index, int amount, String label});
}

/// @nodoc
class _$WheelPrizeDtoCopyWithImpl<$Res, $Val extends WheelPrizeDto>
    implements $WheelPrizeDtoCopyWith<$Res> {
  _$WheelPrizeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? amount = null,
    Object? label = null,
  }) {
    return _then(_value.copyWith(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WheelPrizeDtoImplCopyWith<$Res>
    implements $WheelPrizeDtoCopyWith<$Res> {
  factory _$$WheelPrizeDtoImplCopyWith(
          _$WheelPrizeDtoImpl value, $Res Function(_$WheelPrizeDtoImpl) then) =
      __$$WheelPrizeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int index, int amount, String label});
}

/// @nodoc
class __$$WheelPrizeDtoImplCopyWithImpl<$Res>
    extends _$WheelPrizeDtoCopyWithImpl<$Res, _$WheelPrizeDtoImpl>
    implements _$$WheelPrizeDtoImplCopyWith<$Res> {
  __$$WheelPrizeDtoImplCopyWithImpl(
      _$WheelPrizeDtoImpl _value, $Res Function(_$WheelPrizeDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? index = null,
    Object? amount = null,
    Object? label = null,
  }) {
    return _then(_$WheelPrizeDtoImpl(
      index: null == index
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WheelPrizeDtoImpl implements _WheelPrizeDto {
  const _$WheelPrizeDtoImpl(
      {required this.index, required this.amount, required this.label});

  factory _$WheelPrizeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WheelPrizeDtoImplFromJson(json);

  @override
  final int index;
  @override
  final int amount;
  @override
  final String label;

  @override
  String toString() {
    return 'WheelPrizeDto(index: $index, amount: $amount, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WheelPrizeDtoImpl &&
            (identical(other.index, index) || other.index == index) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, index, amount, label);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WheelPrizeDtoImplCopyWith<_$WheelPrizeDtoImpl> get copyWith =>
      __$$WheelPrizeDtoImplCopyWithImpl<_$WheelPrizeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WheelPrizeDtoImplToJson(
      this,
    );
  }
}

abstract class _WheelPrizeDto implements WheelPrizeDto {
  const factory _WheelPrizeDto(
      {required final int index,
      required final int amount,
      required final String label}) = _$WheelPrizeDtoImpl;

  factory _WheelPrizeDto.fromJson(Map<String, dynamic> json) =
      _$WheelPrizeDtoImpl.fromJson;

  @override
  int get index;
  @override
  int get amount;
  @override
  String get label;
  @override
  @JsonKey(ignore: true)
  _$$WheelPrizeDtoImplCopyWith<_$WheelPrizeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WheelSpinResponseDto _$WheelSpinResponseDtoFromJson(Map<String, dynamic> json) {
  return _WheelSpinResponseDto.fromJson(json);
}

/// @nodoc
mixin _$WheelSpinResponseDto {
  int get prize => throw _privateConstructorUsedError;
  @JsonKey(name: 'prize_index')
  int get prizeIndex => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_balance')
  int get newBalance => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WheelSpinResponseDtoCopyWith<WheelSpinResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WheelSpinResponseDtoCopyWith<$Res> {
  factory $WheelSpinResponseDtoCopyWith(WheelSpinResponseDto value,
          $Res Function(WheelSpinResponseDto) then) =
      _$WheelSpinResponseDtoCopyWithImpl<$Res, WheelSpinResponseDto>;
  @useResult
  $Res call(
      {int prize,
      @JsonKey(name: 'prize_index') int prizeIndex,
      String message,
      @JsonKey(name: 'new_balance') int newBalance});
}

/// @nodoc
class _$WheelSpinResponseDtoCopyWithImpl<$Res,
        $Val extends WheelSpinResponseDto>
    implements $WheelSpinResponseDtoCopyWith<$Res> {
  _$WheelSpinResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prize = null,
    Object? prizeIndex = null,
    Object? message = null,
    Object? newBalance = null,
  }) {
    return _then(_value.copyWith(
      prize: null == prize
          ? _value.prize
          : prize // ignore: cast_nullable_to_non_nullable
              as int,
      prizeIndex: null == prizeIndex
          ? _value.prizeIndex
          : prizeIndex // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      newBalance: null == newBalance
          ? _value.newBalance
          : newBalance // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WheelSpinResponseDtoImplCopyWith<$Res>
    implements $WheelSpinResponseDtoCopyWith<$Res> {
  factory _$$WheelSpinResponseDtoImplCopyWith(_$WheelSpinResponseDtoImpl value,
          $Res Function(_$WheelSpinResponseDtoImpl) then) =
      __$$WheelSpinResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int prize,
      @JsonKey(name: 'prize_index') int prizeIndex,
      String message,
      @JsonKey(name: 'new_balance') int newBalance});
}

/// @nodoc
class __$$WheelSpinResponseDtoImplCopyWithImpl<$Res>
    extends _$WheelSpinResponseDtoCopyWithImpl<$Res, _$WheelSpinResponseDtoImpl>
    implements _$$WheelSpinResponseDtoImplCopyWith<$Res> {
  __$$WheelSpinResponseDtoImplCopyWithImpl(_$WheelSpinResponseDtoImpl _value,
      $Res Function(_$WheelSpinResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prize = null,
    Object? prizeIndex = null,
    Object? message = null,
    Object? newBalance = null,
  }) {
    return _then(_$WheelSpinResponseDtoImpl(
      prize: null == prize
          ? _value.prize
          : prize // ignore: cast_nullable_to_non_nullable
              as int,
      prizeIndex: null == prizeIndex
          ? _value.prizeIndex
          : prizeIndex // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      newBalance: null == newBalance
          ? _value.newBalance
          : newBalance // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WheelSpinResponseDtoImpl implements _WheelSpinResponseDto {
  const _$WheelSpinResponseDtoImpl(
      {required this.prize,
      @JsonKey(name: 'prize_index') required this.prizeIndex,
      required this.message,
      @JsonKey(name: 'new_balance') required this.newBalance});

  factory _$WheelSpinResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WheelSpinResponseDtoImplFromJson(json);

  @override
  final int prize;
  @override
  @JsonKey(name: 'prize_index')
  final int prizeIndex;
  @override
  final String message;
  @override
  @JsonKey(name: 'new_balance')
  final int newBalance;

  @override
  String toString() {
    return 'WheelSpinResponseDto(prize: $prize, prizeIndex: $prizeIndex, message: $message, newBalance: $newBalance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WheelSpinResponseDtoImpl &&
            (identical(other.prize, prize) || other.prize == prize) &&
            (identical(other.prizeIndex, prizeIndex) ||
                other.prizeIndex == prizeIndex) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.newBalance, newBalance) ||
                other.newBalance == newBalance));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, prize, prizeIndex, message, newBalance);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WheelSpinResponseDtoImplCopyWith<_$WheelSpinResponseDtoImpl>
      get copyWith =>
          __$$WheelSpinResponseDtoImplCopyWithImpl<_$WheelSpinResponseDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WheelSpinResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _WheelSpinResponseDto implements WheelSpinResponseDto {
  const factory _WheelSpinResponseDto(
          {required final int prize,
          @JsonKey(name: 'prize_index') required final int prizeIndex,
          required final String message,
          @JsonKey(name: 'new_balance') required final int newBalance}) =
      _$WheelSpinResponseDtoImpl;

  factory _WheelSpinResponseDto.fromJson(Map<String, dynamic> json) =
      _$WheelSpinResponseDtoImpl.fromJson;

  @override
  int get prize;
  @override
  @JsonKey(name: 'prize_index')
  int get prizeIndex;
  @override
  String get message;
  @override
  @JsonKey(name: 'new_balance')
  int get newBalance;
  @override
  @JsonKey(ignore: true)
  _$$WheelSpinResponseDtoImplCopyWith<_$WheelSpinResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TransactionDto _$TransactionDtoFromJson(Map<String, dynamic> json) {
  return _TransactionDto.fromJson(json);
}

/// @nodoc
mixin _$TransactionDto {
  String get id => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // earn, spend, purchase, refund
  int get amount => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionDtoCopyWith<TransactionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionDtoCopyWith<$Res> {
  factory $TransactionDtoCopyWith(
          TransactionDto value, $Res Function(TransactionDto) then) =
      _$TransactionDtoCopyWithImpl<$Res, TransactionDto>;
  @useResult
  $Res call(
      {String id,
      String type,
      int amount,
      String description,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class _$TransactionDtoCopyWithImpl<$Res, $Val extends TransactionDto>
    implements $TransactionDtoCopyWith<$Res> {
  _$TransactionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? description = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionDtoImplCopyWith<$Res>
    implements $TransactionDtoCopyWith<$Res> {
  factory _$$TransactionDtoImplCopyWith(_$TransactionDtoImpl value,
          $Res Function(_$TransactionDtoImpl) then) =
      __$$TransactionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      int amount,
      String description,
      @JsonKey(name: 'created_at') String createdAt});
}

/// @nodoc
class __$$TransactionDtoImplCopyWithImpl<$Res>
    extends _$TransactionDtoCopyWithImpl<$Res, _$TransactionDtoImpl>
    implements _$$TransactionDtoImplCopyWith<$Res> {
  __$$TransactionDtoImplCopyWithImpl(
      _$TransactionDtoImpl _value, $Res Function(_$TransactionDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? amount = null,
    Object? description = null,
    Object? createdAt = null,
  }) {
    return _then(_$TransactionDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionDtoImpl implements _TransactionDto {
  const _$TransactionDtoImpl(
      {required this.id,
      required this.type,
      required this.amount,
      required this.description,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$TransactionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
// earn, spend, purchase, refund
  @override
  final int amount;
  @override
  final String description;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'TransactionDto(id: $id, type: $type, amount: $amount, description: $description, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, type, amount, description, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionDtoImplCopyWith<_$TransactionDtoImpl> get copyWith =>
      __$$TransactionDtoImplCopyWithImpl<_$TransactionDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionDtoImplToJson(
      this,
    );
  }
}

abstract class _TransactionDto implements TransactionDto {
  const factory _TransactionDto(
          {required final String id,
          required final String type,
          required final int amount,
          required final String description,
          @JsonKey(name: 'created_at') required final String createdAt}) =
      _$TransactionDtoImpl;

  factory _TransactionDto.fromJson(Map<String, dynamic> json) =
      _$TransactionDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override // earn, spend, purchase, refund
  int get amount;
  @override
  String get description;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$TransactionDtoImplCopyWith<_$TransactionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HibonPackageDto _$HibonPackageDtoFromJson(Map<String, dynamic> json) {
  return _HibonPackageDto.fromJson(json);
}

/// @nodoc
mixin _$HibonPackageDto {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get hibons => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError; // en centimes
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'bonus_percent')
  int? get bonusPercent => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_popular')
  bool get isPopular => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HibonPackageDtoCopyWith<HibonPackageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HibonPackageDtoCopyWith<$Res> {
  factory $HibonPackageDtoCopyWith(
          HibonPackageDto value, $Res Function(HibonPackageDto) then) =
      _$HibonPackageDtoCopyWithImpl<$Res, HibonPackageDto>;
  @useResult
  $Res call(
      {String id,
      String name,
      int hibons,
      int price,
      String? description,
      @JsonKey(name: 'bonus_percent') int? bonusPercent,
      @JsonKey(name: 'is_popular') bool isPopular});
}

/// @nodoc
class _$HibonPackageDtoCopyWithImpl<$Res, $Val extends HibonPackageDto>
    implements $HibonPackageDtoCopyWith<$Res> {
  _$HibonPackageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? hibons = null,
    Object? price = null,
    Object? description = freezed,
    Object? bonusPercent = freezed,
    Object? isPopular = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      hibons: null == hibons
          ? _value.hibons
          : hibons // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      bonusPercent: freezed == bonusPercent
          ? _value.bonusPercent
          : bonusPercent // ignore: cast_nullable_to_non_nullable
              as int?,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HibonPackageDtoImplCopyWith<$Res>
    implements $HibonPackageDtoCopyWith<$Res> {
  factory _$$HibonPackageDtoImplCopyWith(_$HibonPackageDtoImpl value,
          $Res Function(_$HibonPackageDtoImpl) then) =
      __$$HibonPackageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int hibons,
      int price,
      String? description,
      @JsonKey(name: 'bonus_percent') int? bonusPercent,
      @JsonKey(name: 'is_popular') bool isPopular});
}

/// @nodoc
class __$$HibonPackageDtoImplCopyWithImpl<$Res>
    extends _$HibonPackageDtoCopyWithImpl<$Res, _$HibonPackageDtoImpl>
    implements _$$HibonPackageDtoImplCopyWith<$Res> {
  __$$HibonPackageDtoImplCopyWithImpl(
      _$HibonPackageDtoImpl _value, $Res Function(_$HibonPackageDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? hibons = null,
    Object? price = null,
    Object? description = freezed,
    Object? bonusPercent = freezed,
    Object? isPopular = null,
  }) {
    return _then(_$HibonPackageDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      hibons: null == hibons
          ? _value.hibons
          : hibons // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      bonusPercent: freezed == bonusPercent
          ? _value.bonusPercent
          : bonusPercent // ignore: cast_nullable_to_non_nullable
              as int?,
      isPopular: null == isPopular
          ? _value.isPopular
          : isPopular // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HibonPackageDtoImpl implements _HibonPackageDto {
  const _$HibonPackageDtoImpl(
      {required this.id,
      required this.name,
      required this.hibons,
      required this.price,
      this.description,
      @JsonKey(name: 'bonus_percent') this.bonusPercent,
      @JsonKey(name: 'is_popular') this.isPopular = false});

  factory _$HibonPackageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HibonPackageDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int hibons;
  @override
  final int price;
// en centimes
  @override
  final String? description;
  @override
  @JsonKey(name: 'bonus_percent')
  final int? bonusPercent;
  @override
  @JsonKey(name: 'is_popular')
  final bool isPopular;

  @override
  String toString() {
    return 'HibonPackageDto(id: $id, name: $name, hibons: $hibons, price: $price, description: $description, bonusPercent: $bonusPercent, isPopular: $isPopular)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HibonPackageDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.hibons, hibons) || other.hibons == hibons) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.bonusPercent, bonusPercent) ||
                other.bonusPercent == bonusPercent) &&
            (identical(other.isPopular, isPopular) ||
                other.isPopular == isPopular));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, hibons, price,
      description, bonusPercent, isPopular);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HibonPackageDtoImplCopyWith<_$HibonPackageDtoImpl> get copyWith =>
      __$$HibonPackageDtoImplCopyWithImpl<_$HibonPackageDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HibonPackageDtoImplToJson(
      this,
    );
  }
}

abstract class _HibonPackageDto implements HibonPackageDto {
  const factory _HibonPackageDto(
          {required final String id,
          required final String name,
          required final int hibons,
          required final int price,
          final String? description,
          @JsonKey(name: 'bonus_percent') final int? bonusPercent,
          @JsonKey(name: 'is_popular') final bool isPopular}) =
      _$HibonPackageDtoImpl;

  factory _HibonPackageDto.fromJson(Map<String, dynamic> json) =
      _$HibonPackageDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get hibons;
  @override
  int get price;
  @override // en centimes
  String? get description;
  @override
  @JsonKey(name: 'bonus_percent')
  int? get bonusPercent;
  @override
  @JsonKey(name: 'is_popular')
  bool get isPopular;
  @override
  @JsonKey(ignore: true)
  _$$HibonPackageDtoImplCopyWith<_$HibonPackageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PurchaseResponseDto _$PurchaseResponseDtoFromJson(Map<String, dynamic> json) {
  return _PurchaseResponseDto.fromJson(json);
}

/// @nodoc
mixin _$PurchaseResponseDto {
  @JsonKey(name: 'client_secret')
  String get clientSecret => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_intent_id')
  String get paymentIntentId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PurchaseResponseDtoCopyWith<PurchaseResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseResponseDtoCopyWith<$Res> {
  factory $PurchaseResponseDtoCopyWith(
          PurchaseResponseDto value, $Res Function(PurchaseResponseDto) then) =
      _$PurchaseResponseDtoCopyWithImpl<$Res, PurchaseResponseDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'client_secret') String clientSecret,
      @JsonKey(name: 'payment_intent_id') String paymentIntentId});
}

/// @nodoc
class _$PurchaseResponseDtoCopyWithImpl<$Res, $Val extends PurchaseResponseDto>
    implements $PurchaseResponseDtoCopyWith<$Res> {
  _$PurchaseResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientSecret = null,
    Object? paymentIntentId = null,
  }) {
    return _then(_value.copyWith(
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      paymentIntentId: null == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PurchaseResponseDtoImplCopyWith<$Res>
    implements $PurchaseResponseDtoCopyWith<$Res> {
  factory _$$PurchaseResponseDtoImplCopyWith(_$PurchaseResponseDtoImpl value,
          $Res Function(_$PurchaseResponseDtoImpl) then) =
      __$$PurchaseResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'client_secret') String clientSecret,
      @JsonKey(name: 'payment_intent_id') String paymentIntentId});
}

/// @nodoc
class __$$PurchaseResponseDtoImplCopyWithImpl<$Res>
    extends _$PurchaseResponseDtoCopyWithImpl<$Res, _$PurchaseResponseDtoImpl>
    implements _$$PurchaseResponseDtoImplCopyWith<$Res> {
  __$$PurchaseResponseDtoImplCopyWithImpl(_$PurchaseResponseDtoImpl _value,
      $Res Function(_$PurchaseResponseDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientSecret = null,
    Object? paymentIntentId = null,
  }) {
    return _then(_$PurchaseResponseDtoImpl(
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      paymentIntentId: null == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PurchaseResponseDtoImpl implements _PurchaseResponseDto {
  const _$PurchaseResponseDtoImpl(
      {@JsonKey(name: 'client_secret') required this.clientSecret,
      @JsonKey(name: 'payment_intent_id') required this.paymentIntentId});

  factory _$PurchaseResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PurchaseResponseDtoImplFromJson(json);

  @override
  @JsonKey(name: 'client_secret')
  final String clientSecret;
  @override
  @JsonKey(name: 'payment_intent_id')
  final String paymentIntentId;

  @override
  String toString() {
    return 'PurchaseResponseDto(clientSecret: $clientSecret, paymentIntentId: $paymentIntentId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseResponseDtoImpl &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, clientSecret, paymentIntentId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseResponseDtoImplCopyWith<_$PurchaseResponseDtoImpl> get copyWith =>
      __$$PurchaseResponseDtoImplCopyWithImpl<_$PurchaseResponseDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PurchaseResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _PurchaseResponseDto implements PurchaseResponseDto {
  const factory _PurchaseResponseDto(
      {@JsonKey(name: 'client_secret') required final String clientSecret,
      @JsonKey(name: 'payment_intent_id')
      required final String paymentIntentId}) = _$PurchaseResponseDtoImpl;

  factory _PurchaseResponseDto.fromJson(Map<String, dynamic> json) =
      _$PurchaseResponseDtoImpl.fromJson;

  @override
  @JsonKey(name: 'client_secret')
  String get clientSecret;
  @override
  @JsonKey(name: 'payment_intent_id')
  String get paymentIntentId;
  @override
  @JsonKey(ignore: true)
  _$$PurchaseResponseDtoImplCopyWith<_$PurchaseResponseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AchievementDto _$AchievementDtoFromJson(Map<String, dynamic> json) {
  return _AchievementDto.fromJson(json);
}

/// @nodoc
mixin _$AchievementDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'icon_url')
  String? get iconUrl => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_unlocked')
  bool get isUnlocked => throw _privateConstructorUsedError;
  @JsonKey(name: 'progress_current')
  int get progressCurrent => throw _privateConstructorUsedError;
  @JsonKey(name: 'progress_target')
  int get progressTarget => throw _privateConstructorUsedError;
  @JsonKey(name: 'unlocked_at')
  String? get unlockedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AchievementDtoCopyWith<AchievementDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AchievementDtoCopyWith<$Res> {
  factory $AchievementDtoCopyWith(
          AchievementDto value, $Res Function(AchievementDto) then) =
      _$AchievementDtoCopyWithImpl<$Res, AchievementDto>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      @JsonKey(name: 'icon_url') String? iconUrl,
      String category,
      @JsonKey(name: 'is_unlocked') bool isUnlocked,
      @JsonKey(name: 'progress_current') int progressCurrent,
      @JsonKey(name: 'progress_target') int progressTarget,
      @JsonKey(name: 'unlocked_at') String? unlockedAt});
}

/// @nodoc
class _$AchievementDtoCopyWithImpl<$Res, $Val extends AchievementDto>
    implements $AchievementDtoCopyWith<$Res> {
  _$AchievementDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? iconUrl = freezed,
    Object? category = null,
    Object? isUnlocked = null,
    Object? progressCurrent = null,
    Object? progressTarget = null,
    Object? unlockedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      progressCurrent: null == progressCurrent
          ? _value.progressCurrent
          : progressCurrent // ignore: cast_nullable_to_non_nullable
              as int,
      progressTarget: null == progressTarget
          ? _value.progressTarget
          : progressTarget // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedAt: freezed == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AchievementDtoImplCopyWith<$Res>
    implements $AchievementDtoCopyWith<$Res> {
  factory _$$AchievementDtoImplCopyWith(_$AchievementDtoImpl value,
          $Res Function(_$AchievementDtoImpl) then) =
      __$$AchievementDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      @JsonKey(name: 'icon_url') String? iconUrl,
      String category,
      @JsonKey(name: 'is_unlocked') bool isUnlocked,
      @JsonKey(name: 'progress_current') int progressCurrent,
      @JsonKey(name: 'progress_target') int progressTarget,
      @JsonKey(name: 'unlocked_at') String? unlockedAt});
}

/// @nodoc
class __$$AchievementDtoImplCopyWithImpl<$Res>
    extends _$AchievementDtoCopyWithImpl<$Res, _$AchievementDtoImpl>
    implements _$$AchievementDtoImplCopyWith<$Res> {
  __$$AchievementDtoImplCopyWithImpl(
      _$AchievementDtoImpl _value, $Res Function(_$AchievementDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? iconUrl = freezed,
    Object? category = null,
    Object? isUnlocked = null,
    Object? progressCurrent = null,
    Object? progressTarget = null,
    Object? unlockedAt = freezed,
  }) {
    return _then(_$AchievementDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      iconUrl: freezed == iconUrl
          ? _value.iconUrl
          : iconUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isUnlocked: null == isUnlocked
          ? _value.isUnlocked
          : isUnlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      progressCurrent: null == progressCurrent
          ? _value.progressCurrent
          : progressCurrent // ignore: cast_nullable_to_non_nullable
              as int,
      progressTarget: null == progressTarget
          ? _value.progressTarget
          : progressTarget // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedAt: freezed == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AchievementDtoImpl implements _AchievementDto {
  const _$AchievementDtoImpl(
      {required this.id,
      required this.title,
      required this.description,
      @JsonKey(name: 'icon_url') this.iconUrl,
      required this.category,
      @JsonKey(name: 'is_unlocked') this.isUnlocked = false,
      @JsonKey(name: 'progress_current') this.progressCurrent = 0,
      @JsonKey(name: 'progress_target') this.progressTarget = 1,
      @JsonKey(name: 'unlocked_at') this.unlockedAt});

  factory _$AchievementDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AchievementDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey(name: 'icon_url')
  final String? iconUrl;
  @override
  final String category;
  @override
  @JsonKey(name: 'is_unlocked')
  final bool isUnlocked;
  @override
  @JsonKey(name: 'progress_current')
  final int progressCurrent;
  @override
  @JsonKey(name: 'progress_target')
  final int progressTarget;
  @override
  @JsonKey(name: 'unlocked_at')
  final String? unlockedAt;

  @override
  String toString() {
    return 'AchievementDto(id: $id, title: $title, description: $description, iconUrl: $iconUrl, category: $category, isUnlocked: $isUnlocked, progressCurrent: $progressCurrent, progressTarget: $progressTarget, unlockedAt: $unlockedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AchievementDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconUrl, iconUrl) || other.iconUrl == iconUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isUnlocked, isUnlocked) ||
                other.isUnlocked == isUnlocked) &&
            (identical(other.progressCurrent, progressCurrent) ||
                other.progressCurrent == progressCurrent) &&
            (identical(other.progressTarget, progressTarget) ||
                other.progressTarget == progressTarget) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, iconUrl,
      category, isUnlocked, progressCurrent, progressTarget, unlockedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AchievementDtoImplCopyWith<_$AchievementDtoImpl> get copyWith =>
      __$$AchievementDtoImplCopyWithImpl<_$AchievementDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AchievementDtoImplToJson(
      this,
    );
  }
}

abstract class _AchievementDto implements AchievementDto {
  const factory _AchievementDto(
          {required final String id,
          required final String title,
          required final String description,
          @JsonKey(name: 'icon_url') final String? iconUrl,
          required final String category,
          @JsonKey(name: 'is_unlocked') final bool isUnlocked,
          @JsonKey(name: 'progress_current') final int progressCurrent,
          @JsonKey(name: 'progress_target') final int progressTarget,
          @JsonKey(name: 'unlocked_at') final String? unlockedAt}) =
      _$AchievementDtoImpl;

  factory _AchievementDto.fromJson(Map<String, dynamic> json) =
      _$AchievementDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  @JsonKey(name: 'icon_url')
  String? get iconUrl;
  @override
  String get category;
  @override
  @JsonKey(name: 'is_unlocked')
  bool get isUnlocked;
  @override
  @JsonKey(name: 'progress_current')
  int get progressCurrent;
  @override
  @JsonKey(name: 'progress_target')
  int get progressTarget;
  @override
  @JsonKey(name: 'unlocked_at')
  String? get unlockedAt;
  @override
  @JsonKey(ignore: true)
  _$$AchievementDtoImplCopyWith<_$AchievementDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChallengeDto _$ChallengeDtoFromJson(Map<String, dynamic> json) {
  return _ChallengeDto.fromJson(json);
}

/// @nodoc
mixin _$ChallengeDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // daily, weekly, sponsored
  @JsonKey(name: 'reward_hibons')
  int get rewardHibons => throw _privateConstructorUsedError;
  @JsonKey(name: 'reward_xp')
  int get rewardXp => throw _privateConstructorUsedError;
  @JsonKey(name: 'progress_current')
  int get progressCurrent => throw _privateConstructorUsedError;
  @JsonKey(name: 'progress_target')
  int get progressTarget => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_completed')
  bool get isCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_claimed')
  bool get isClaimed => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  String? get expiresAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChallengeDtoCopyWith<ChallengeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChallengeDtoCopyWith<$Res> {
  factory $ChallengeDtoCopyWith(
          ChallengeDto value, $Res Function(ChallengeDto) then) =
      _$ChallengeDtoCopyWithImpl<$Res, ChallengeDto>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String type,
      @JsonKey(name: 'reward_hibons') int rewardHibons,
      @JsonKey(name: 'reward_xp') int rewardXp,
      @JsonKey(name: 'progress_current') int progressCurrent,
      @JsonKey(name: 'progress_target') int progressTarget,
      @JsonKey(name: 'is_completed') bool isCompleted,
      @JsonKey(name: 'is_claimed') bool isClaimed,
      @JsonKey(name: 'expires_at') String? expiresAt});
}

/// @nodoc
class _$ChallengeDtoCopyWithImpl<$Res, $Val extends ChallengeDto>
    implements $ChallengeDtoCopyWith<$Res> {
  _$ChallengeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? rewardHibons = null,
    Object? rewardXp = null,
    Object? progressCurrent = null,
    Object? progressTarget = null,
    Object? isCompleted = null,
    Object? isClaimed = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      rewardHibons: null == rewardHibons
          ? _value.rewardHibons
          : rewardHibons // ignore: cast_nullable_to_non_nullable
              as int,
      rewardXp: null == rewardXp
          ? _value.rewardXp
          : rewardXp // ignore: cast_nullable_to_non_nullable
              as int,
      progressCurrent: null == progressCurrent
          ? _value.progressCurrent
          : progressCurrent // ignore: cast_nullable_to_non_nullable
              as int,
      progressTarget: null == progressTarget
          ? _value.progressTarget
          : progressTarget // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isClaimed: null == isClaimed
          ? _value.isClaimed
          : isClaimed // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChallengeDtoImplCopyWith<$Res>
    implements $ChallengeDtoCopyWith<$Res> {
  factory _$$ChallengeDtoImplCopyWith(
          _$ChallengeDtoImpl value, $Res Function(_$ChallengeDtoImpl) then) =
      __$$ChallengeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String type,
      @JsonKey(name: 'reward_hibons') int rewardHibons,
      @JsonKey(name: 'reward_xp') int rewardXp,
      @JsonKey(name: 'progress_current') int progressCurrent,
      @JsonKey(name: 'progress_target') int progressTarget,
      @JsonKey(name: 'is_completed') bool isCompleted,
      @JsonKey(name: 'is_claimed') bool isClaimed,
      @JsonKey(name: 'expires_at') String? expiresAt});
}

/// @nodoc
class __$$ChallengeDtoImplCopyWithImpl<$Res>
    extends _$ChallengeDtoCopyWithImpl<$Res, _$ChallengeDtoImpl>
    implements _$$ChallengeDtoImplCopyWith<$Res> {
  __$$ChallengeDtoImplCopyWithImpl(
      _$ChallengeDtoImpl _value, $Res Function(_$ChallengeDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? rewardHibons = null,
    Object? rewardXp = null,
    Object? progressCurrent = null,
    Object? progressTarget = null,
    Object? isCompleted = null,
    Object? isClaimed = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_$ChallengeDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      rewardHibons: null == rewardHibons
          ? _value.rewardHibons
          : rewardHibons // ignore: cast_nullable_to_non_nullable
              as int,
      rewardXp: null == rewardXp
          ? _value.rewardXp
          : rewardXp // ignore: cast_nullable_to_non_nullable
              as int,
      progressCurrent: null == progressCurrent
          ? _value.progressCurrent
          : progressCurrent // ignore: cast_nullable_to_non_nullable
              as int,
      progressTarget: null == progressTarget
          ? _value.progressTarget
          : progressTarget // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isClaimed: null == isClaimed
          ? _value.isClaimed
          : isClaimed // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChallengeDtoImpl implements _ChallengeDto {
  const _$ChallengeDtoImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.type,
      @JsonKey(name: 'reward_hibons') this.rewardHibons = 0,
      @JsonKey(name: 'reward_xp') this.rewardXp = 0,
      @JsonKey(name: 'progress_current') this.progressCurrent = 0,
      @JsonKey(name: 'progress_target') this.progressTarget = 1,
      @JsonKey(name: 'is_completed') this.isCompleted = false,
      @JsonKey(name: 'is_claimed') this.isClaimed = false,
      @JsonKey(name: 'expires_at') this.expiresAt});

  factory _$ChallengeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChallengeDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String type;
// daily, weekly, sponsored
  @override
  @JsonKey(name: 'reward_hibons')
  final int rewardHibons;
  @override
  @JsonKey(name: 'reward_xp')
  final int rewardXp;
  @override
  @JsonKey(name: 'progress_current')
  final int progressCurrent;
  @override
  @JsonKey(name: 'progress_target')
  final int progressTarget;
  @override
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @override
  @JsonKey(name: 'is_claimed')
  final bool isClaimed;
  @override
  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  @override
  String toString() {
    return 'ChallengeDto(id: $id, title: $title, description: $description, type: $type, rewardHibons: $rewardHibons, rewardXp: $rewardXp, progressCurrent: $progressCurrent, progressTarget: $progressTarget, isCompleted: $isCompleted, isClaimed: $isClaimed, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChallengeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.rewardHibons, rewardHibons) ||
                other.rewardHibons == rewardHibons) &&
            (identical(other.rewardXp, rewardXp) ||
                other.rewardXp == rewardXp) &&
            (identical(other.progressCurrent, progressCurrent) ||
                other.progressCurrent == progressCurrent) &&
            (identical(other.progressTarget, progressTarget) ||
                other.progressTarget == progressTarget) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.isClaimed, isClaimed) ||
                other.isClaimed == isClaimed) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      type,
      rewardHibons,
      rewardXp,
      progressCurrent,
      progressTarget,
      isCompleted,
      isClaimed,
      expiresAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChallengeDtoImplCopyWith<_$ChallengeDtoImpl> get copyWith =>
      __$$ChallengeDtoImplCopyWithImpl<_$ChallengeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChallengeDtoImplToJson(
      this,
    );
  }
}

abstract class _ChallengeDto implements ChallengeDto {
  const factory _ChallengeDto(
          {required final String id,
          required final String title,
          required final String description,
          required final String type,
          @JsonKey(name: 'reward_hibons') final int rewardHibons,
          @JsonKey(name: 'reward_xp') final int rewardXp,
          @JsonKey(name: 'progress_current') final int progressCurrent,
          @JsonKey(name: 'progress_target') final int progressTarget,
          @JsonKey(name: 'is_completed') final bool isCompleted,
          @JsonKey(name: 'is_claimed') final bool isClaimed,
          @JsonKey(name: 'expires_at') final String? expiresAt}) =
      _$ChallengeDtoImpl;

  factory _ChallengeDto.fromJson(Map<String, dynamic> json) =
      _$ChallengeDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get type;
  @override // daily, weekly, sponsored
  @JsonKey(name: 'reward_hibons')
  int get rewardHibons;
  @override
  @JsonKey(name: 'reward_xp')
  int get rewardXp;
  @override
  @JsonKey(name: 'progress_current')
  int get progressCurrent;
  @override
  @JsonKey(name: 'progress_target')
  int get progressTarget;
  @override
  @JsonKey(name: 'is_completed')
  bool get isCompleted;
  @override
  @JsonKey(name: 'is_claimed')
  bool get isClaimed;
  @override
  @JsonKey(name: 'expires_at')
  String? get expiresAt;
  @override
  @JsonKey(ignore: true)
  _$$ChallengeDtoImplCopyWith<_$ChallengeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

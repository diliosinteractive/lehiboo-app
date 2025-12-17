
import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_reward.freezed.dart';
part 'daily_reward.g.dart';

@freezed
class DailyRewardState with _$DailyRewardState {
  const factory DailyRewardState({
    required int currentDay, // 1 to 7
    required bool isClaimedToday,
    required DateTime lastClaimDate,
    required List<DailyRewardDay> days,
  }) = _DailyRewardState;

  factory DailyRewardState.fromJson(Map<String, dynamic> json) =>
      _$DailyRewardStateFromJson(json);
}

@freezed
class DailyRewardDay with _$DailyRewardDay {
  const factory DailyRewardDay({
    required int dayNumber,
    required int hibonsReward,
    required int xpReward,
    String? bonusDescription, // e.g., "x1.2 XP", "Tour gratuit"
    @Default(false) bool isJackpot, // Day 7
  }) = _DailyRewardDay;

  factory DailyRewardDay.fromJson(Map<String, dynamic> json) =>
      _$DailyRewardDayFromJson(json);
}

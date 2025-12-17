
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gamification_items.freezed.dart';
part 'gamification_items.g.dart';

@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String id,
    required String title,
    required String description,
    required String iconUrl,
    required String category, // Explorer, Social, etc.
    @Default(false) bool isUnlocked,
    required int progressCurrent,
    required int progressTarget,
    DateTime? unlockedAt,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
}

@freezed
class Challenge with _$Challenge {
  const factory Challenge({
    required String id,
    required String title,
    required String description,
    required String type, // daily, weekly, sponsored
    required int rewardHibons,
    required int rewardXp,
    required int progressCurrent,
    required int progressTarget,
    @Default(false) bool isCompleted,
    @Default(false) bool isClaimed,
    DateTime? expiresAt,
  }) = _Challenge;

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
}

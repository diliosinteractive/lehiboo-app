// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'quota_dto.freezed.dart';
part 'quota_dto.g.dart';

/// DTO for user's chat quota
@freezed
class QuotaDto with _$QuotaDto {
  const QuotaDto._();

  const factory QuotaDto({
    /// Messages used in current period
    @Default(0) int used,

    /// Maximum messages allowed in period
    @Default(3) int limit,

    /// Remaining messages
    @Default(3) int remaining,

    /// When the quota resets (ISO 8601)
    @JsonKey(name: 'resets_at') String? resetsAt,

    /// Backward-compatible reset key used by older Python responses
    @JsonKey(name: 'reset_at') String? resetAt,

    /// Period type (daily, weekly, monthly)
    @Default('daily') String period,

    /// Base daily messages before rank/unlock bonuses
    @JsonKey(name: 'base_limit') @Default(3) int baseLimit,

    /// Messages granted by current Hibons rank
    @JsonKey(name: 'rank_bonus') @Default(0) int rankBonus,

    /// Messages unlocked today using Hibons
    @JsonKey(name: 'unlocked_today') @Default(0) int unlockedToday,

    /// Whether the user can unlock more messages
    @JsonKey(name: 'can_unlock') @Default(false) bool canUnlock,

    /// Hibons cost for an unlock
    @JsonKey(name: 'unlock_cost') @Default(100) int unlockCost,

    /// Number of messages unlocked per purchase
    @JsonKey(name: 'unlock_messages') @Default(2) int unlockMessages,

    /// Current Hibons rank
    @Default('curieux') String rank,
  }) = _QuotaDto;

  factory QuotaDto.fromJson(Map<String, dynamic> json) =>
      _$QuotaDtoFromJson(json);

  /// Check if quota is exhausted
  bool get isExhausted => remaining <= 0;

  /// Effective reset timestamp, accepting both new and legacy API keys
  String? get effectiveResetsAt => resetsAt ?? resetAt;

  /// Get quota usage percentage (0.0 to 1.0)
  double get usagePercentage => limit > 0 ? used / limit : 0.0;

  /// Get formatted remaining messages string
  String get remainingDisplay => '$remaining/$limit';
}

/// Response wrapper for quota endpoint
@freezed
class QuotaResponseDto with _$QuotaResponseDto {
  const factory QuotaResponseDto({
    required bool success,
    required QuotaDto data,
  }) = _QuotaResponseDto;

  factory QuotaResponseDto.fromJson(Map<String, dynamic> json) =>
      _$QuotaResponseDtoFromJson(json);
}

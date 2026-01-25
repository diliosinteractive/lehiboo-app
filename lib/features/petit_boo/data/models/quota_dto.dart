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
    @Default(10) int limit,

    /// Remaining messages
    @Default(10) int remaining,

    /// When the quota resets (ISO 8601)
    @JsonKey(name: 'resets_at') String? resetsAt,

    /// Period type (daily, weekly, monthly)
    @Default('daily') String period,
  }) = _QuotaDto;

  factory QuotaDto.fromJson(Map<String, dynamic> json) =>
      _$QuotaDtoFromJson(json);

  /// Check if quota is exhausted
  bool get isExhausted => remaining <= 0;

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

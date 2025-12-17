
import 'package:flutter/material.dart'; // For Color
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wheel_models.freezed.dart';
part 'wheel_models.g.dart';

// Ignore Color for json serialization for now or use a converter
// For simplicity in this DTO, we'll store color as int or string if needed, 
// but UI will probably map ID to visual style.

@freezed
class WheelSegment with _$WheelSegment {
  const factory WheelSegment({
    required String id,
    required String label,
    required String type, // hibons, multiplier, badge, jackpot
    required int value, // Amount of hibons or multiplier value (e.g. 15 for 1.5x)
    required double probability,
    @Default(0xFFFFFFFF) int colorInt, 
  }) = _WheelSegment;

  factory WheelSegment.fromJson(Map<String, dynamic> json) =>
      _$WheelSegmentFromJson(json);
}

@freezed
class WheelConfig with _$WheelConfig {
  const factory WheelConfig({
    required List<WheelSegment> segments,
    required int costPerSpin,
    required bool isFreeSpinAvailable,
    DateTime? nextFreeSpinDate,
  }) = _WheelConfig;

  factory WheelConfig.fromJson(Map<String, dynamic> json) =>
      _$WheelConfigFromJson(json);
}

@freezed
class WheelSpinResult with _$WheelSpinResult {
  const factory WheelSpinResult({
    required WheelSegment segment,
    required int earnedHibons, // Calculated value
    required String message,
  }) = _WheelSpinResult;

  factory WheelSpinResult.fromJson(Map<String, dynamic> json) =>
      _$WheelSpinResultFromJson(json);
}

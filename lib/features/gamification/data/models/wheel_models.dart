import 'package:freezed_annotation/freezed_annotation.dart';

part 'wheel_models.freezed.dart';
part 'wheel_models.g.dart';

/// Configuration de la roue de la fortune (depuis l'API)
@freezed
class WheelConfig with _$WheelConfig {
  const factory WheelConfig({
    required List<WheelPrize> prizes,
    // Champs legacy pour compatibilité avec l'UI existante
    @Default(0) int costPerSpin,
    @Default(true) bool isFreeSpinAvailable,
    DateTime? nextFreeSpinDate,
  }) = _WheelConfig;

  factory WheelConfig.fromJson(Map<String, dynamic> json) =>
      _$WheelConfigFromJson(json);
}

/// Prix/segment de la roue
@freezed
class WheelPrize with _$WheelPrize {
  const factory WheelPrize({
    required int index,
    required int amount,
    required String label,
    // Champs UI (non fournis par l'API, à définir côté app)
    @Default(0xFFFFFFFF) int colorInt,
  }) = _WheelPrize;

  factory WheelPrize.fromJson(Map<String, dynamic> json) =>
      _$WheelPrizeFromJson(json);
}

/// Résultat d'un spin de la roue
@freezed
class WheelSpinResult with _$WheelSpinResult {
  const factory WheelSpinResult({
    required int prize,
    required int prizeIndex,
    required String message,
    required int newBalance,
  }) = _WheelSpinResult;

  factory WheelSpinResult.fromJson(Map<String, dynamic> json) =>
      _$WheelSpinResultFromJson(json);
}

// === Legacy models for backward compatibility with existing UI ===

/// Ancien format de segment (utilisé par l'UI existante)
/// Mappé depuis WheelPrize si nécessaire
@freezed
class WheelSegment with _$WheelSegment {
  const factory WheelSegment({
    required String id,
    required String label,
    required String type, // hibons, multiplier, badge, jackpot
    required int value,
    required double probability,
    @Default(0xFFFFFFFF) int colorInt,
  }) = _WheelSegment;

  factory WheelSegment.fromJson(Map<String, dynamic> json) =>
      _$WheelSegmentFromJson(json);

  /// Convertit un WheelPrize API en WheelSegment legacy
  factory WheelSegment.fromPrize(WheelPrize prize, {int? color}) {
    return WheelSegment(
      id: prize.index.toString(),
      label: prize.label,
      type: prize.amount > 0 ? 'hibons' : 'empty',
      value: prize.amount,
      probability: 1.0 / 8, // Probabilité égale par défaut
      colorInt: color ?? _getColorForIndex(prize.index),
    );
  }
}

/// Couleurs par défaut pour les segments de la roue
int _getColorForIndex(int index) {
  const colors = [
    0xFFE0E0E0, // Gris clair
    0xFFB3E5FC, // Bleu clair
    0xFF81C784, // Vert
    0xFFFFF176, // Jaune
    0xFFFFCC80, // Orange clair
    0xFFFFAB91, // Orange
    0xFFCE93D8, // Violet
    0xFFFFD700, // Or
  ];
  return colors[index % colors.length];
}

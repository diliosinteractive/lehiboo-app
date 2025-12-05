import 'package:flutter/material.dart';
import 'spacing.dart';

class LeHibooTokens extends ThemeExtension<LeHibooTokens> {
  final Color brand;
  final Color brandSecondary;
  final Color graySoft;
  final HbSpacing spacing;
  final double radiusXL;

  const LeHibooTokens({
    required this.brand,
    required this.brandSecondary,
    required this.graySoft,
    required this.spacing,
    required this.radiusXL,
  });

  @override
  LeHibooTokens copyWith({
    Color? brand,
    Color? brandSecondary,
    Color? graySoft,
    HbSpacing? spacing,
    double? radiusXL,
  }) {
    return LeHibooTokens(
      brand: brand ?? this.brand,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      graySoft: graySoft ?? this.graySoft,
      spacing: spacing ?? this.spacing,
      radiusXL: radiusXL ?? this.radiusXL,
    );
  }

  @override
  LeHibooTokens lerp(ThemeExtension<LeHibooTokens>? other, double t) {
    if (other is! LeHibooTokens) {
      return this;
    }
    return LeHibooTokens(
      brand: Color.lerp(brand, other.brand, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      graySoft: Color.lerp(graySoft, other.graySoft, t)!,
      spacing: other.spacing, // Spacing typically doesn't lerp nicely, keeping target
      radiusXL: other.radiusXL, // Keeping target for simplicity
    );
  }
}

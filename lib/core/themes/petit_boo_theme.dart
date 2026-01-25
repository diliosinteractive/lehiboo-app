import 'package:flutter/material.dart';

/// Design tokens pour Petit Boo Chat - UI Kit complet
/// Aligné sur le design web vendor dashboard
class PetitBooTheme {
  PetitBooTheme._();

  // ═══════════════════════════════════════════════════════════════════════════
  // COULEURS
  // ═══════════════════════════════════════════════════════════════════════════

  // Primary Orange
  static const Color primary = Color(0xFFFF601F);
  static const Color primaryHover = Color(0xFFE6490F);
  static const Color primaryLight = Color(0xFFFFE6D5);
  static const Color primaryLighter = Color(0xFFFFF8F5);

  // Neutrals (Grey Scale)
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF4F7FE);
  static const Color grey200 = Color(0xFFE4E7EC);
  static const Color grey300 = Color(0xFFD0D5DD);
  static const Color grey400 = Color(0xFF98A2B3);
  static const Color grey500 = Color(0xFF667085);
  static const Color grey600 = Color(0xFF475467);
  static const Color grey700 = Color(0xFF344054);
  static const Color grey800 = Color(0xFF1D2939);
  static const Color grey900 = Color(0xFF101828);

  // Semantic Colors
  static const Color success = Color(0xFF12B76A);
  static const Color successLight = Color(0xFFECFDF3);
  static const Color error = Color(0xFFF04438);
  static const Color errorLight = Color(0xFFFEF3F2);
  static const Color warning = Color(0xFFF79009);
  static const Color warningLight = Color(0xFFFFFAEB);

  // Backgrounds
  static const Color background = grey100; // #F4F7FE - fond principal
  static const Color surface = Colors.white;
  static const Color surfaceElevated = grey50; // #F9FAFB - chips, cards légères

  // Text Colors
  static const Color textPrimary = grey800;
  static const Color textSecondary = grey500;
  static const Color textTertiary = grey400;
  static const Color textOnPrimary = Colors.white;

  // Border Colors
  static const Color border = grey200;
  static const Color borderLight = grey100;
  static const Color borderFocus = primary;

  // ═══════════════════════════════════════════════════════════════════════════
  // SPACING
  // ═══════════════════════════════════════════════════════════════════════════

  static const double spacing2 = 2;
  static const double spacing4 = 4;
  static const double spacing6 = 6;
  static const double spacing8 = 8;
  static const double spacing10 = 10;
  static const double spacing12 = 12;
  static const double spacing14 = 14;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER RADIUS
  // ═══════════════════════════════════════════════════════════════════════════

  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radius2xl = 20;
  static const double radius3xl = 24;
  static const double radiusFull = 9999;

  // Shortcuts
  static BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  static BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
  static BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);
  static BorderRadius get borderRadius2xl => BorderRadius.circular(radius2xl);
  static BorderRadius get borderRadius3xl => BorderRadius.circular(radius3xl);
  static BorderRadius get borderRadiusFull => BorderRadius.circular(radiusFull);

  // Message bubble border radius (coin coupé)
  static BorderRadius get bubbleUser => const BorderRadius.only(
        topLeft: Radius.circular(radius2xl),
        topRight: Radius.circular(radiusSm), // coin coupé
        bottomLeft: Radius.circular(radius2xl),
        bottomRight: Radius.circular(radius2xl),
      );

  static BorderRadius get bubbleAssistant => const BorderRadius.only(
        topLeft: Radius.circular(radiusSm), // coin coupé
        topRight: Radius.circular(radius2xl),
        bottomLeft: Radius.circular(radius2xl),
        bottomRight: Radius.circular(radius2xl),
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // SHADOWS
  // ═══════════════════════════════════════════════════════════════════════════

  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get shadowXl => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];

  // Shadow spéciale pour les bulles user (teinte orange)
  static List<BoxShadow> get shadowOrange => [
        BoxShadow(
          color: primary.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  // Shadow pour input (vers le haut)
  static List<BoxShadow> get shadowUp => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ];

  // ═══════════════════════════════════════════════════════════════════════════
  // TYPOGRAPHY
  // ═══════════════════════════════════════════════════════════════════════════

  static TextStyle get headingLg => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.3,
      );

  static TextStyle get headingMd => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.3,
      );

  static TextStyle get headingSm => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      );

  static TextStyle get bodyLg => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.5,
      );

  static TextStyle get bodyMd => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.6,
      );

  static TextStyle get bodySm => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.5,
      );

  static TextStyle get caption => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textTertiary,
        height: 1.4,
      );

  static TextStyle get label => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        height: 1.4,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPONENT SIZES
  // ═══════════════════════════════════════════════════════════════════════════

  // Avatars
  static const double avatarSm = 32;
  static const double avatarMd = 40;
  static const double avatarLg = 48;
  static const double avatarXl = 80;

  // Buttons
  static const double buttonHeightSm = 36;
  static const double buttonHeightMd = 44;
  static const double buttonHeightLg = 52;

  // Input
  static const double inputHeight = 56;

  // Chips
  static const double chipHeight = 40;

  // Icons
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;

  // ═══════════════════════════════════════════════════════════════════════════
  // BOX DECORATIONS (Shortcuts pour widgets)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Décoration pour les cards
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: surface,
        borderRadius: borderRadiusXl,
        border: Border.all(color: border, width: 1),
        boxShadow: shadowSm,
      );

  /// Décoration pour les inputs
  static BoxDecoration get inputDecoration => BoxDecoration(
        color: surface,
        borderRadius: borderRadiusXl,
        border: Border.all(color: border, width: 1),
      );

  /// Décoration pour les inputs focus
  static BoxDecoration get inputFocusDecoration => BoxDecoration(
        color: surface,
        borderRadius: borderRadiusXl,
        border: Border.all(color: primary, width: 1.5),
      );

  /// Décoration pour les chips/suggestions
  static BoxDecoration get chipDecoration => BoxDecoration(
        color: surfaceElevated,
        borderRadius: borderRadiusFull,
        border: Border.all(color: border, width: 1),
      );

  /// Décoration pour les chips active
  static BoxDecoration get chipActiveDecoration => BoxDecoration(
        color: primary,
        borderRadius: borderRadiusFull,
      );

  /// Décoration pour bulle user
  static BoxDecoration get bubbleUserDecoration => BoxDecoration(
        color: primary,
        borderRadius: bubbleUser,
        boxShadow: shadowOrange,
      );

  /// Décoration pour bulle assistant
  static BoxDecoration get bubbleAssistantDecoration => BoxDecoration(
        color: surface,
        borderRadius: bubbleAssistant,
        border: Border.all(color: border, width: 1),
        boxShadow: shadowSm,
      );

  /// Décoration pour le typing indicator
  static BoxDecoration get typingDecoration => BoxDecoration(
        color: surface,
        borderRadius: borderRadius3xl,
        border: Border.all(color: border, width: 1),
        boxShadow: shadowSm,
      );

  // ═══════════════════════════════════════════════════════════════════════════
  // ANIMATION DURATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // ═══════════════════════════════════════════════════════════════════════════
  // ASSET PATHS
  // ═══════════════════════════════════════════════════════════════════════════

  static const String owlLogoPath = 'assets/images/petit_boo_logo.png';
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';
import 'lehiboo_tokens.dart';

class AppTheme {
  static const _spacing = HbSpacing();
  
  static final lightTheme = ThemeData(
    useMaterial3: true,
    primaryColor: HbColors.brandPrimary,
    scaffoldBackgroundColor: HbColors.graySoft,
    
    // Color Scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: HbColors.brandPrimary,
      primary: HbColors.brandPrimary,
      secondary: HbColors.brandSecondary,
      surface: HbColors.white,
      background: HbColors.graySoft,
      error: HbColors.error,
    ),

    // Extensions
    extensions: const [
      LeHibooTokens(
        brand: HbColors.brandPrimary,
        brandSecondary: HbColors.brandSecondary,
        graySoft: HbColors.graySoft,
        spacing: _spacing,
        radiusXL: 16.0,
      ),
    ],

    // Typography
    textTheme: hbTextTheme,

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: HbColors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: HbColors.textPrimary),
      titleTextStyle: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: HbColors.textPrimary,
      ),
    ),

    // Card
    cardTheme: CardThemeData(
      color: HbColors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: HbColors.brandPrimary,
        foregroundColor: HbColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: HbColors.brandPrimary,
        side: const BorderSide(color: HbColors.brandPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: HbColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: HbColors.brandPrimary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: HbColors.error),
      ),
    ),
  );

  static final darkTheme = lightTheme; // For now
}
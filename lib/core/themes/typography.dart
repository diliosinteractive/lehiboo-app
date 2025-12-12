import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

// Typographies selon la charte graphique Le Hiboo
// Titres: Montserrat | Texte: Figtree
final hbTextTheme = TextTheme(
  displayLarge: GoogleFonts.montserrat(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: HbColors.textPrimary,
  ),
  headlineMedium: GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: HbColors.textPrimary,
  ),
  titleLarge: GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: HbColors.textPrimary,
  ),
  titleMedium: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: HbColors.textPrimary,
  ),
  titleSmall: GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: HbColors.textPrimary,
  ),
  bodyLarge: GoogleFonts.figtree(
    fontSize: 16,
    color: HbColors.textPrimary,
  ),
  bodyMedium: GoogleFonts.figtree(
    fontSize: 14,
    color: HbColors.textPrimary,
  ),
  bodySmall: GoogleFonts.figtree(
    fontSize: 12,
    color: HbColors.textSecondary,
  ),
  labelLarge: GoogleFonts.figtree(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: HbColors.textPrimary,
  ),
  labelMedium: GoogleFonts.figtree(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: HbColors.textPrimary,
  ),
  labelSmall: GoogleFonts.figtree(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: HbColors.textSecondary,
  ),
);

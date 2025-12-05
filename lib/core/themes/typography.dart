import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

final hbTextTheme = TextTheme(
  displayLarge: GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: HbColors.textPrimary,
  ),
  headlineMedium: GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: HbColors.textPrimary,
  ),
  titleLarge: GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: HbColors.textPrimary,
  ),
  bodyLarge: GoogleFonts.inter(
    fontSize: 16,
    color: HbColors.textPrimary,
  ),
  bodyMedium: GoogleFonts.inter(
    fontSize: 14,
    color: HbColors.textPrimary,
  ),
  labelLarge: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: HbColors.textPrimary,
  ),
  labelSmall: GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: HbColors.textSecondary,
  ),
);

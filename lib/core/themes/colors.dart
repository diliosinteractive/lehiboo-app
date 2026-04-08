import 'package:flutter/material.dart';

class HbColors {
  // Couleurs principales de la charte graphique Le Hiboo
  static const brandPrimary = Color(0xFFFF601F);      // Orange vif
  static const brandSecondary = Color(0xFF233D4C);    // Bleu pétrole
  static const orangePastel = Color(0xFFFFF8F5);      // Orange pastel (fond legacy)
  static const graySoft = orangePastel;               // Alias pour compatibilité
  static const textPrimary = Color(0xFF233D4C);       // Bleu pétrole pour le texte
  static const textSecondary = Color(0xFF4B5563);     // Gris secondaire
  static const white = Colors.white;
  static const error = Color(0xFFE74C3C);
  static const success = Color(0xFF27AE60);
  static const warning = Color(0xFFF39C12);

  // ─────────────────────────────────────────────────────────────────────────
  // Nouvelles couleurs alignées sur le design web (pour Petit Boo et futur)
  // ─────────────────────────────────────────────────────────────────────────

  // Backgrounds
  static const backgroundLight = Color(0xFFF4F7FE);   // Fond gris-bleu clair
  static const surfaceWhite = Colors.white;
  static const surfaceElevated = Color(0xFFF9FAFB);  // Surface légèrement grise

  // Grey Scale
  static const grey200 = Color(0xFFE4E7EC);          // Borders
  static const grey400 = Color(0xFF98A2B3);          // Text muted
  static const grey500 = Color(0xFF667085);          // Text secondary
  static const grey800 = Color(0xFF1D2939);          // Text primary

  // Surfaces
  static const surfaceLight = Color(0xFFF7F7F7);       // Fond gris très léger
  static const surfaceInput = Color(0xFFF5F5F7);       // Fond champs de saisie

  // Brand variants
  static const brandPrimaryDark = Color(0xFFE8491D);   // Orange foncé (gradients)

  // Borders
  static const borderLight = Color(0xFFE4E7EC);
  static const borderFocus = brandPrimary;

  // Text
  static const textDark = Color(0xFF222222);            // Noir quasi-pur
  static const textTertiary = Color(0xFF666666);        // Gris moyen

  // Text aliases
  static const textMuted = Color(0xFF667085);
}

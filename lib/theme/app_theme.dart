/// Thème visuel de l'application ConcourQuiz BF.
///
/// Palette inspirée de l'identité burkinabè :
/// - Vert Faso : #009E49 (espoir, nature)
/// - Rouge Terre : #C8102E (courage, latérite)
/// - Or / Jaune Réussite : #FFB800 (l'étoile du drapeau, la réussite)
/// - Fond sombre doux : #1A1A2E (modernité, lisibilité)
/// - Surface card : #16213E
/// - Texte clair : #EAEAEA
library;

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ─── Couleurs principales ───────────────────────────────────────────

  /// Vert du drapeau du Burkina Faso — couleur primaire
  static const Color vertFaso = Color(0xFF009E49);

  /// Rouge terre / latérite — accent de danger / erreurs
  static const Color rougeTerre = Color(0xFFC8102E);

  /// Or / Jaune Réussite — accent doré pour succès et récompenses
  static const Color orReussite = Color(0xFFFFB800);

  /// Fond principal sombre
  static const Color fondSombre = Color(0xFF1A1A2E);

  /// Surface de carte (légèrement plus claire)
  static const Color surfaceCard = Color(0xFF16213E);

  /// Surface de carte active / survol
  static const Color surfaceCardActive = Color(0xFF1F2B47);

  /// Texte principal clair
  static const Color textPrimary = Color(0xFFF0F0F0);

  /// Texte secondaire
  static const Color textSecondary = Color(0xFFB0B0C0);

  /// Bordure discrète
  static const Color borderSubtle = Color(0xFF2A2A4A);

  /// Vert clair pour bonne réponse (feedback)
  static const Color correctGreen = Color(0xFF00C853);

  /// Rouge clair pour mauvaise réponse (feedback)
  static const Color incorrectRed = Color(0xFFFF5252);

  /// Gris neutre pour options non sélectionnées après validation
  static const Color neutralGrey = Color(0xFF3A3A5A);

  // ─── ThemeData complet ──────────────────────────────────────────────

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      fontFamily: 'Roboto',

      // Couleur de fond
      scaffoldBackgroundColor: fondSombre,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: vertFaso,
        secondary: orReussite,
        error: rougeTerre,
        surface: surfaceCard,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onError: Colors.white,
        onSurface: textPrimary,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: fondSombre,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),

      // Cards
      cardTheme: CardTheme(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
      ),

      // ElevatedButton principal (Valider, etc.)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: vertFaso,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Texte
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.5,
        ),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return vertFaso;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: const BorderSide(color: textSecondary, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: vertFaso, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: rougeTerre),
        ),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
        labelStyle: const TextStyle(color: textPrimary, fontSize: 14),
      ),

      // LinearProgressIndicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        linearTrackColor: borderSubtle,
        color: vertFaso,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: borderSubtle,
        thickness: 1,
      ),
    );
  }
}

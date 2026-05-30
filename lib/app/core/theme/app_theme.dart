/// Thème visuel de l'application ConcoursOp BF.
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

  // ─── Couleurs Sombre ───────────────────────────────────────────────
  static const Color fondSombre = Color(0xFF1A1A2E);
  static const Color surfaceCardSombre = Color(0xFF16213E);
  static const Color surfaceCardActiveSombre = Color(0xFF1F2B47);
  static const Color textPrimarySombre = Color(0xFFF0F0F0);
  static const Color textSecondarySombre = Color(0xFFB0B0C0);
  static const Color borderSubtleSombre = Color(0xFF2A2A4A);

  // ─── Couleurs Clair ────────────────────────────────────────────────
  static const Color fondClair = Color(0xFFF8F9FA);
  static const Color surfaceCardClair = Colors.white;
  static const Color surfaceCardActiveClair = Color(0xFFF1F3F5);
  static const Color textPrimaryClair = Color(0xFF212529);
  static const Color textSecondaryClair = Color(0xFF6C757D);
  static const Color borderSubtleClair = Color(0xFFE9ECEF);

  /// Vert clair pour bonne réponse (feedback)
  static const Color correctGreen = Color(0xFF00C853);

  /// Rouge clair pour mauvaise réponse (feedback)
  static const Color incorrectRed = Color(0xFFFF5252);

  /// Gris neutre pour options non sélectionnées après validation
  static const Color neutralGrey = Color(0xFF3A3A5A);
  static const Color neutralGreyClair = Color(0xFFCED4DA);

  // ─── ThemeData Sombre ──────────────────────────────────────────────

  static ThemeData get darkTheme {
    return _buildTheme(
      brightness: Brightness.dark,
      background: fondSombre,
      surface: surfaceCardSombre,
      border: borderSubtleSombre,
      textPrimary: textPrimarySombre,
      textSecondary: textSecondarySombre,
    );
  }

  // ─── ThemeData Clair ───────────────────────────────────────────────

  static ThemeData get lightTheme {
    return _buildTheme(
      brightness: Brightness.light,
      background: fondClair,
      surface: surfaceCardClair,
      border: borderSubtleClair,
      textPrimary: textPrimaryClair,
      textSecondary: textSecondaryClair,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: vertFaso,
        onPrimary: Colors.white,
        secondary: orReussite,
        onSecondary: isDark ? Colors.black : Colors.white,
        error: rougeTerre,
        onError: Colors.white,
        surface: surface,
        onSurface: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
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
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border, width: 1),
        ),
      ),
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
      textTheme: TextTheme(
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: vertFaso, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: rougeTerre),
        ),
        hintStyle: TextStyle(color: textSecondary, fontSize: 14),
        labelStyle: TextStyle(color: textPrimary, fontSize: 14),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        linearTrackColor: border,
        color: vertFaso,
      ),
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
      ),
    );
  }

  // Helpers for custom UI colors not in ThemeData
  static Color getSurfaceCardActive(bool isDark) => 
      isDark ? surfaceCardActiveSombre : surfaceCardActiveClair;
  
  static Color getBorderSubtle(bool isDark) => 
      isDark ? borderSubtleSombre : borderSubtleClair;
  
  static Color getTextPrimary(bool isDark) => 
      isDark ? textPrimarySombre : textPrimaryClair;
      
  static Color getTextSecondary(bool isDark) => 
      isDark ? textSecondarySombre : textSecondaryClair;

  static const Color fondSombreLegacy = fondSombre; // For backward compatibility if needed
}

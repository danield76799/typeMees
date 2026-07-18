import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fortnite/Roblox-geïnspireerd thema — fel, stoer, kindvriendelijk.
class AppTheme {
  AppTheme._();

  // 🎨 Kernkleuren
  static const Color primary = Color(0xFFFF6B35); // Fel oranje
  static const Color secondary = Color(0xFF00D4FF); // Cyber-blauw
  static const Color accent = Color(0xFFFFD700); // Goud (punten!)
  static const Color success = Color(0xFF00E676); // Groen
  static const Color danger = Color(0xFFFF1744); // Rood
  static const Color dark = Color(0xFF1A1A2E); // Donkerblauw (achtergrond)
  static const Color surface = Color(0xFF16213E); // Kaart-achtergrond
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCFD8DC);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: danger,
      ),
      textTheme: GoogleFonts.bangersTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        headlineLarge: GoogleFonts.bangers(
          fontSize: 48,
          color: textPrimary,
          letterSpacing: 2,
        ),
        headlineMedium: GoogleFonts.bangers(
          fontSize: 32,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.bangers(
          fontSize: 24,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.nunito(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.bangers(fontSize: 22, letterSpacing: 1),
          elevation: 8,
          shadowColor: primary.withAlpha(100),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 6,
        shadowColor: secondary.withAlpha(60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: secondary.withAlpha(40), width: 1.5),
        ),
      ),
    );
  }
}

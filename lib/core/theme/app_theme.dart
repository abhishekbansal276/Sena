import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors — Imperial Topaz
  static const Color primary = Color(0xFF8B3D00); // Deep Burnt Amber
  static const Color primaryLight = Color(0xFFA84E0F); // Warm Copper
  static const Color accent = Color(0xFFF0A500); // Golden Topaz
  static const Color accentDark = Color(0xFFD48C00); // Deep Gold
  static const Color surface = Color(0xFFFDF7EE); // Warm Cream
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1C0A00); // Deep Warm Brown
  static const Color textSecondary = Color(0xFF7A5C45); // Muted Amber Brown
  static const Color textLight = Color(0xFFB8977D); // Sandy Taupe
  static const Color success = Color(0xFF2D8A6E); // Teal Green
  static const Color warning = Color(0xFFF0A500); // Golden Amber
  static const Color error = Color(0xFFC0392B); // Deep Red
  static const Color divider = Color(0xFFEDD9C0); // Pale Topaz

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: surface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: textPrimary,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: surface,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
            fontSize: 32, fontWeight: FontWeight.w800, color: textPrimary),
        displayMedium: GoogleFonts.inter(
            fontSize: 26, fontWeight: FontWeight.w700, color: textPrimary),
        displaySmall: GoogleFonts.inter(
            fontSize: 22, fontWeight: FontWeight.w700, color: textPrimary),
        headlineMedium: GoogleFonts.inter(
            fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
        headlineSmall: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: GoogleFonts.inter(
            fontSize: 15, fontWeight: FontWeight.w400, color: textPrimary),
        bodyMedium: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w400, color: textSecondary),
        labelLarge: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
        labelMedium: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
            fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle:
              GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle:
              GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 14, color: textSecondary),
        hintStyle: GoogleFonts.inter(fontSize: 14, color: textLight),
      ),
      cardTheme: CardThemeData(
        color: cardBg,
        elevation: 2,
        shadowColor: primary.withOpacity(0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: primary.withOpacity(0.1),
        labelStyle:
            GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: divider),
      ),
      dividerTheme: const DividerThemeData(color: divider, thickness: 1),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: textPrimary,
        elevation: 4,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassTheme {
  // Brand Colors (Ayurveda Green Palette)
  static const Color primaryGreen = Color(0xFF2E7D32); // Deep forest green
  static const Color lightGreen = Color(0xFF81C784); // Soft herbal green
  static const Color accentTeal = Color(0xFF00695C); // Deep teal
  static const Color frostedWhite = Color(0xFFFFFFFF);

  // Backgrounds
  static const Color bgDark = Color(0xFF1B231E); // Very dark earth/green tint
  static const Color bgLight = Color(0xFFF1F8E9); // Light moss tint

  // Text Colors
  static const Color textPrimaryLight =
      Color(0xFF102318); // High-contrast text for light mode
  static const Color textSecondaryLight = Color(0xFF415443);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFC8E6C9);

  /// Standard border radius for all glass elements
  static BorderRadius defaultRadius = BorderRadius.circular(20);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: bgLight,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: accentTeal,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPrimaryLight),
        titleTextStyle: GoogleFonts.poppins(
          color: textPrimaryLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: bgDark,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: accentTeal,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPrimaryDark),
        titleTextStyle: GoogleFonts.poppins(
          color: textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

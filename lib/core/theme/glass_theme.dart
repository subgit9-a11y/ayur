import 'package:flutter/material.dart';

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
  static const Color textPrimaryLight = Color(0xFF1B5E20); // Dark green text for light mode
  static const Color textSecondaryLight = Color(0xFF558B2F);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFC8E6C9);

  /// Standard border radius for all glass elements
  static BorderRadius defaultRadius = BorderRadius.circular(20);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: bgLight,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: accentTeal,
      ),
      fontFamily: 'SF Pro Display', // Defaulting to system fonts or custom if added
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimaryLight),
        titleTextStyle: TextStyle(
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
      colorScheme: const ColorScheme.dark(
        primary: primaryGreen,
        secondary: accentTeal,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimaryDark),
        titleTextStyle: TextStyle(
          color: textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color background = Color(0xFF0A0E1A);
  static const Color backgroundGradientTop = Color(0xFF0D1B34);
  static const Color card = Color(0xFF16213E);
  static const Color primary = Color(0xFF2563EB);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color border = Color(0xFF2A3654);
  static const Color inputFill = Color(0xFF141C2F);
  static const Color danger = Color(0xFFEF4444);

  // Theme
  static final ThemeData dark = ThemeData(
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    colorScheme: const ColorScheme.dark(primary: primary, surface: card),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputFill,
      hintStyle: const TextStyle(color: textSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),

      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppTheme.primary),
      ),
    ),
  );
}

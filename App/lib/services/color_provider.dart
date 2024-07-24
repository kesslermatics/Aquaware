import 'package:flutter/material.dart';

class ColorProvider {
  // Primary Colors
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF0D47A1);

  // Secondary Colors
  static const Color secondary = Color(0xFF00ACC1);
  static const Color secondaryDark = Color(0xFF004D40);

  // Accent Colors
  static const Color accentRed = Color(0xFFE53935);
  static const Color accentOrange = Color(0xFFFB8C00);

  // Neutral Colors
  static const Color background = Color(0xFFECEFF1);
  static const Color textDark = Color(0xFF455A64);
  static const Color textLight = Color(0xFFFFFFFF);

  static ColorScheme get colorScheme => const ColorScheme(
        primary: primary,
        primaryContainer: primaryDark,
        secondary: secondary,
        secondaryContainer: secondaryDark,
        surface: Colors.white,
        background: background,
        error: accentRed,
        onPrimary: textLight,
        onSecondary: textLight,
        onSurface: textDark,
        onBackground: textDark,
        onError: textLight,
        brightness: Brightness.light,
      );
}

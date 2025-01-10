import 'package:flutter/material.dart';

class ColorProvider {
  // n1 bis n16 aus Tailwind
  static const n1 = Color(0xFFFFFFFF); // Weiß
  static const n2 = Color(0xFFCAC6DD); // Sehr helles Grau
  static const n3 = Color(0xFFADA8C3); // Helles Grau mit leichtem Violett-Stich
  static const n4 = Color(0xFF757185); // Mittelgrau
  static const n5 =
      Color(0xFF3F3A52); // Dunkles Grau mit einem leichten Blau-Stich
  static const n6 = Color(0xFF07304f); // Sehr dunkles Grau
  static const n7 = Color(0xFF051521); // Fast Schwarz
  static const n8 = Color(0xFF031726); // Sehr dunkles Schwarz
  static const n9 = Color(0xFF474060); // Dunkles Grau mit Blau-Violett-Ton
  static const n10 = Color(0xFF43435C); // Blau-Grau, etwas dunkler als 9
  static const n11 = Color(0xFF1B1B2E); // Sehr dunkles Blau-Schwarz
  static const n12 = Color(0xFF2E2A41); // Dunkles Blau-Grau
  static const n13 = Color(0xFF6C7275); // Grau mit leichtem Blau-Grün-Ton
  static const n14 = Color(0xFF031726); // Marineblau
  static const n15 = Color(0xFF575ab2); // Blauviolett
  static const n16 = Color(0xFF9c9eed); // Helles Blauviolett
  static const n17 = Color(0xFF2563EB); // Mittleres Blau

  // Farbschema für ThemeData
  static ColorScheme get colorScheme => const ColorScheme(
        brightness: Brightness.dark,
        primary: n1, // Primärfarbe
        onPrimary: n1, // Text auf Primärfarbe
        secondary: n2, // Sekundärfarbe
        onSecondary: n1, // Text auf Hintergrund
        surface: n9, // Oberfläche
        onSurface: n1, // Text auf Oberfläche
        error: n13, // Fehlerfarbe
        onError: n1, // Text auf Fehlerfarbe
      );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system for the Flutter Low-Code Platform
class AppTypography {
  // Base font family
  static String get fontFamily => 'Segoe UI';

  // Text theme
  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      height: 1.2,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      height: 1.2,
      letterSpacing: -0.25,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      height: 1.3,
    ),
    headlineLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
  );

  // Specific text styles for different components
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 1.5,
  );

  // Code editor specific typography
  static const TextStyle codeStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    fontFamily: 'Consolas',
  );

  static const TextStyle codeSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    fontFamily: 'Consolas',
  );

  // Widget library typography
  static TextStyle get widgetTitle =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, height: 1.3);

  static TextStyle get widgetSubtitle => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
  );

  static TextStyle get categoryTitle => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.5,
  );

  // Properties panel typography
  static TextStyle get propertyLabel =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, height: 1.3);

  static TextStyle get propertyValue => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
  );

  static TextStyle get sectionTitle =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, height: 1.3);

  // Button typography
  static TextStyle get buttonLarge =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, height: 1.2);

  static TextStyle get buttonMedium =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, height: 1.2);

  static TextStyle get buttonSmall =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, height: 1.2);

  // Input field typography
  static TextStyle get inputText => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  static TextStyle get inputLabel =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, height: 1.3);

  static TextStyle get inputHint => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.4,
  );

  // Tooltip typography
  static TextStyle get tooltip => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
  );

  // Error typography
  static TextStyle get errorText => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
  );

  // Success typography
  static TextStyle get successText => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.3,
  );

  // Navigation typography
  static TextStyle get navItem =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, height: 1.3);

  static TextStyle get navTitle =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, height: 1.3);

  // Tab typography
  static TextStyle get tabLabel =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, height: 1.3);

  // Dialog typography
  static TextStyle get dialogTitle =>
      GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3);

  static TextStyle get dialogContent => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  // Utility methods
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  static TextStyle withHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }
}

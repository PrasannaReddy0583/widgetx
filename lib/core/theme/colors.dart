import 'package:flutter/material.dart';

/// Application color palette following the design specifications
class AppColors {
  // Primary Dark Theme Colors
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color onSurface = Color(0xFFE1E1E1);
  
  // Accent Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Canvas Specific Colors
  static const Color canvasBackground = Color(0xFF2A2A2A);
  static const Color gridColor = Color(0xFF404040);
  static const Color selectionBlue = Color(0xFF2196F3);
  static const Color selectionBorder = Color(0xFF1976D2);
  static const Color dropZoneHighlight = Color(0xFF4CAF50);
  
  // Widget Library Colors
  static const Color categoryHeader = Color(0xFF2C2C2C);
  static const Color widgetItem = Color(0xFF333333);
  static const Color widgetItemHover = Color(0xFF3A3A3A);
  static const Color widgetItemSelected = Color(0xFF1976D2);
  
  // Properties Panel Colors
  static const Color propertySection = Color(0xFF252525);
  static const Color propertyItem = Color(0xFF2A2A2A);
  static const Color propertyLabel = Color(0xFFB0B0B0);
  static const Color propertyValue = Color(0xFFE1E1E1);
  
  // Code Editor Colors
  static const Color codeBackground = Color(0xFF1A1A1A);
  static const Color codeForeground = Color(0xFFE1E1E1);
  static const Color codeKeyword = Color(0xFF569CD6);
  static const Color codeString = Color(0xFFCE9178);
  static const Color codeComment = Color(0xFF6A9955);
  static const Color codeNumber = Color(0xFFB5CEA8);
  
  // Status Colors
  static const Color online = Color(0xFF4CAF50);
  static const Color offline = Color(0xFF9E9E9E);
  static const Color loading = Color(0xFFFF9800);
  static const Color errorState = Color(0xFFF44336);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [Color(0xFF1E1E1E), Color(0xFF252525)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Opacity Variants
  static Color get primaryWithOpacity => primary.withOpacity(0.1);
  static Color get secondaryWithOpacity => secondary.withOpacity(0.1);
  static Color get errorWithOpacity => error.withOpacity(0.1);
  static Color get successWithOpacity => success.withOpacity(0.1);
  static Color get warningWithOpacity => warning.withOpacity(0.1);
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
  
  // Border Colors
  static const Color borderLight = Color(0xFF404040);
  static const Color borderMedium = Color(0xFF606060);
  static const Color borderDark = Color(0xFF808080);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFE1E1E1);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textTertiary = Color(0xFF808080);
  static const Color textDisabled = Color(0xFF606060);
  
  // Icon Colors
  static const Color iconPrimary = Color(0xFFE1E1E1);
  static const Color iconSecondary = Color(0xFFB0B0B0);
  static const Color iconDisabled = Color(0xFF606060);
  
  // Hover and Focus Colors
  static Color get hoverColor => primary.withOpacity(0.04);
  static Color get focusColor => primary.withOpacity(0.12);
  static Color get pressedColor => primary.withOpacity(0.16);
  
  // Device Frame Colors
  static const Color deviceFrameBorder = Color(0xFF404040);
  static const Color deviceFrameBackground = Color(0xFF2A2A2A);
  static const Color deviceScreen = Color(0xFFFFFFFF);
  
  // Drag and Drop Colors
  static const Color dragFeedback = Color(0x88FFFFFF);
  static const Color dropTarget = Color(0x334CAF50);
  static const Color dropTargetActive = Color(0x664CAF50);
  
  // Animation Colors
  static Color get fadeInColor => Colors.transparent;
  static Color get fadeOutColor => surface;
  
  // Utility Methods
  static Color withAlpha(Color color, int alpha) {
    return color.withAlpha(alpha);
  }
  
  static Color blend(Color color1, Color color2, double ratio) {
    return Color.lerp(color1, color2, ratio) ?? color1;
  }
  
  static bool isLight(Color color) {
    return color.computeLuminance() > 0.5;
  }
  
  static Color getContrastColor(Color color) {
    return isLight(color) ? Colors.black : Colors.white;
  }
}

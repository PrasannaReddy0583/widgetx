import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';
import 'typography.dart';

/// Application theme configuration
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      textTheme: AppTypography.textTheme,
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      dividerTheme: _dividerTheme,
      iconTheme: _iconTheme,
      chipTheme: _chipTheme,
      tooltipTheme: _tooltipTheme,
      popupMenuTheme: _popupMenuTheme,
      dialogTheme: _dialogTheme,
      bottomSheetTheme: _bottomSheetTheme,
      tabBarTheme: _tabBarTheme,
      switchTheme: _switchTheme,
      checkboxTheme: _checkboxTheme,
      radioTheme: _radioTheme,
      sliderTheme: _sliderTheme,
      progressIndicatorTheme: _progressIndicatorTheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.surface,
      splashColor: AppColors.primary.withOpacity(0.1),
      highlightColor: AppColors.primary.withOpacity(0.05),
      focusColor: AppColors.primary.withOpacity(0.2),
      hoverColor: AppColors.primary.withOpacity(0.04),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      textTheme: AppTypography.textTheme,
      appBarTheme: _appBarTheme.copyWith(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      canvasColor: Colors.white,
    );
  }

  // Color Schemes
  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: AppColors.surface,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: AppColors.onSurface,
    onError: Colors.white,
  );

  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    surface: Colors.white,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black87,
    onError: Colors.white,
  );

  // Component Themes
  static const AppBarTheme _appBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.onSurface,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    ),
  );

  static const CardThemeData _cardTheme = CardThemeData(
    elevation: 2,
    color: AppColors.surface,
    shadowColor: Colors.black26,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  );

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: AppColors.primary),
        ),
      );

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static const InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.error),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );

  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: Colors.grey,
    thickness: 1,
    space: 1,
  );

  static const IconThemeData _iconTheme = IconThemeData(
    color: AppColors.onSurface,
    size: 24,
  );

  static const ChipThemeData _chipTheme = ChipThemeData(
    backgroundColor: AppColors.surface,
    selectedColor: AppColors.primary,
    labelStyle: TextStyle(color: AppColors.onSurface),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  static const TooltipThemeData _tooltipTheme = TooltipThemeData(
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
    textStyle: TextStyle(color: Colors.white, fontSize: 12),
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  );

  static const PopupMenuThemeData _popupMenuTheme = PopupMenuThemeData(
    color: AppColors.surface,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );

  static const DialogThemeData _dialogTheme = DialogThemeData(
    backgroundColor: AppColors.surface,
    elevation: 24,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  static const BottomSheetThemeData _bottomSheetTheme = BottomSheetThemeData(
    backgroundColor: AppColors.surface,
    elevation: 16,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  );

  static const TabBarThemeData _tabBarTheme = TabBarThemeData(
    labelColor: AppColors.primary,
    unselectedLabelColor: Colors.grey,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
  );

  static final SwitchThemeData _switchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return Colors.grey;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary.withOpacity(0.5);
      }
      return Colors.grey.withOpacity(0.3);
    }),
  );

  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(Colors.white),
  );

  static final RadioThemeData _radioTheme = RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return Colors.grey;
    }),
  );

  static final SliderThemeData _sliderTheme = SliderThemeData(
    activeTrackColor: AppColors.primary,
    inactiveTrackColor: AppColors.primary.withOpacity(0.3),
    thumbColor: AppColors.primary,
    overlayColor: AppColors.primary.withOpacity(0.2),
  );

  static const ProgressIndicatorThemeData _progressIndicatorTheme =
      ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: Colors.grey,
        circularTrackColor: Colors.grey,
      );
}

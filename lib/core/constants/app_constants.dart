/// Core application constants for the Flutter Low-Code Platform
class AppConstants {
  // Application Info
  static const String appName = 'WidgetX';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Professional Flutter Low-Code Platform';
  
  // Canvas Settings
  static const double defaultCanvasWidth = 375.0;
  static const double defaultCanvasHeight = 812.0;
  static const double minZoom = 0.25;
  static const double maxZoom = 2.0;
  static const double gridSize = 20.0;
  
  // Padding Constants
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Panel Dimensions
  static const double leftPanelWidth = 300.0;
  static const double rightPanelWidth = 350.0;
  static const double headerHeight = 60.0;
  static const double codeEditorHeight = 300.0;
  
  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 200);
  static const Duration dragFeedbackDuration = Duration(milliseconds: 150);
  static const Duration debounceDelay = Duration(milliseconds: 300);
  
  // Storage Keys
  static const String projectsKey = 'saved_projects';
  static const String settingsKey = 'app_settings';
  static const String recentProjectsKey = 'recent_projects';
  
  // Code Generation
  static const String defaultImports = '''
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
''';
  
  // Widget Limits
  static const int maxWidgetsPerScreen = 100;
  static const int maxUndoHistory = 50;
  static const int maxProjectScreens = 20;
}

import 'package:flutter/material.dart';

/// Device frame configurations for responsive preview
class DeviceFrame {
  const DeviceFrame({
    required this.name,
    required this.width,
    required this.height,
    required this.devicePixelRatio,
    required this.icon,
    this.statusBarHeight = 44.0,
    this.bottomSafeArea = 34.0,
  });

  final String name;
  final double width;
  final double height;
  final double devicePixelRatio;
  final IconData icon;
  final double statusBarHeight;
  final double bottomSafeArea;

  // Common device frames
  static const iphone14 = DeviceFrame(
    name: 'iPhone 14',
    width: 390,
    height: 844,
    devicePixelRatio: 3.0,
    icon: Icons.phone_iphone,
    statusBarHeight: 47,
    bottomSafeArea: 34,
  );

  static const iphone14Pro = DeviceFrame(
    name: 'iPhone 14 Pro',
    width: 393,
    height: 852,
    devicePixelRatio: 3.0,
    icon: Icons.phone_iphone,
    statusBarHeight: 59,
    bottomSafeArea: 34,
  );

  static const ipadAir = DeviceFrame(
    name: 'iPad Air',
    width: 820,
    height: 1180,
    devicePixelRatio: 2.0,
    icon: Icons.tablet_mac,
    statusBarHeight: 24,
    bottomSafeArea: 20,
  );

  static const pixel7 = DeviceFrame(
    name: 'Pixel 7',
    width: 412,
    height: 915,
    devicePixelRatio: 2.625,
    icon: Icons.phone_android,
    statusBarHeight: 24,
    bottomSafeArea: 0,
  );

  static const galaxyS23 = DeviceFrame(
    name: 'Galaxy S23',
    width: 360,
    height: 780,
    devicePixelRatio: 3.0,
    icon: Icons.phone_android,
    statusBarHeight: 24,
    bottomSafeArea: 0,
  );

  static const desktop = DeviceFrame(
    name: 'Desktop',
    width: 1440,
    height: 900,
    devicePixelRatio: 1.0,
    icon: Icons.desktop_mac,
    statusBarHeight: 0,
    bottomSafeArea: 0,
  );

  static const web = DeviceFrame(
    name: 'Web',
    width: 1200,
    height: 800,
    devicePixelRatio: 1.0,
    icon: Icons.web,
    statusBarHeight: 0,
    bottomSafeArea: 0,
  );

  static const custom = DeviceFrame(
    name: 'Custom',
    width: 375,
    height: 812,
    devicePixelRatio: 2.0,
    icon: Icons.crop_free,
  );

  // All available device frames
  static const List<DeviceFrame> allFrames = [
    iphone14,
    iphone14Pro,
    pixel7,
    galaxyS23,
    ipadAir,
    desktop,
    web,
    custom,
  ];

  // Responsive breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  /// Get device category based on width
  DeviceCategory get category {
    if (width < mobileBreakpoint) return DeviceCategory.mobile;
    if (width < tabletBreakpoint) return DeviceCategory.tablet;
    return DeviceCategory.desktop;
  }

  /// Get safe area insets
  EdgeInsets get safeAreaInsets => EdgeInsets.only(
    top: statusBarHeight,
    bottom: bottomSafeArea,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceFrame &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

/// Device categories for responsive design
enum DeviceCategory {
  mobile('Mobile'),
  tablet('Tablet'),
  desktop('Desktop');

  const DeviceCategory(this.displayName);
  final String displayName;
}

/// Orientation options
enum DeviceOrientation {
  portrait('Portrait', Icons.stay_current_portrait),
  landscape('Landscape', Icons.stay_current_landscape);

  const DeviceOrientation(this.displayName, this.icon);
  final String displayName;
  final IconData icon;
}

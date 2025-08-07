import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'screen_model.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

/// Model representing a complete Flutter project
@freezed
abstract class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    required String id,
    required String name,
    required String description,
    @Default([]) List<ScreenModel> screens,
    @Default({}) Map<String, dynamic> settings,
    @Default('1.0.0') String version,
    @Default('com.example.app') String packageName,
    @Default([]) List<String> dependencies,
    @Default([]) List<String> assets,
    @Default({}) Map<String, String> environment,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? thumbnailPath,
    @Default(false) bool isTemplate,
    @Default([]) List<String> tags,
    String? authorId,
    String? authorName,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) =>
      _$ProjectModelFromJson(json);

  /// Create a new project with default settings
  factory ProjectModel.create({required String name, String? description}) {
    final now = DateTime.now();
    final projectId = const Uuid().v4();

    return ProjectModel(
      id: projectId,
      name: name,
      description: description ?? 'A new Flutter project created with WidgetX',
      screens: [ScreenModel.create(name: 'Home', isMain: true)],
      settings: _getDefaultSettings(),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Get default project settings
  static Map<String, dynamic> _getDefaultSettings() {
    return {
      'theme': {
        'primaryColor': '#2196F3',
        'accentColor': '#03DAC6',
        'brightness': 'light',
        'fontFamily': 'Roboto',
      },
      'app': {
        'title': 'My App',
        'debugShowCheckedModeBanner': false,
        'supportedLocales': ['en'],
      },
      'build': {
        'targetSdk': 'flutter',
        'minSdkVersion': 21,
        'targetSdkVersion': 33,
        'versionCode': 1,
      },
      'export': {
        'includeAssets': true,
        'includeDependencies': true,
        'generateReadme': true,
        'codeStyle': 'clean',
      },
    };
  }
}

/// Extension methods for ProjectModel
extension ProjectModelExtensions on ProjectModel {
  /// Get the main screen
  ScreenModel? get mainScreen {
    try {
      return screens.firstWhere((screen) => screen.isMain);
    } catch (e) {
      return screens.isNotEmpty ? screens.first : null;
    }
  }

  /// Get screen by ID
  ScreenModel? getScreenById(String screenId) {
    try {
      return screens.firstWhere((screen) => screen.id == screenId);
    } catch (e) {
      return null;
    }
  }

  /// Add a new screen
  ProjectModel addScreen(ScreenModel screen) {
    return copyWith(screens: [...screens, screen], updatedAt: DateTime.now());
  }

  /// Remove a screen
  ProjectModel removeScreen(String screenId) {
    final updatedScreens = screens
        .where((screen) => screen.id != screenId)
        .toList();

    // Ensure we always have at least one screen
    if (updatedScreens.isEmpty) {
      updatedScreens.add(ScreenModel.create(name: 'Home', isMain: true));
    }

    // If we removed the main screen, make the first screen main
    if (updatedScreens.isNotEmpty &&
        !updatedScreens.any((screen) => screen.isMain)) {
      updatedScreens[0] = updatedScreens[0].copyWith(isMain: true);
    }

    return copyWith(screens: updatedScreens, updatedAt: DateTime.now());
  }

  /// Update a screen
  ProjectModel updateScreen(ScreenModel updatedScreen) {
    final screenIndex = screens.indexWhere(
      (screen) => screen.id == updatedScreen.id,
    );
    if (screenIndex == -1) return this;

    final updatedScreens = List<ScreenModel>.from(screens);
    updatedScreens[screenIndex] = updatedScreen;

    return copyWith(screens: updatedScreens, updatedAt: DateTime.now());
  }

  /// Set main screen
  ProjectModel setMainScreen(String screenId) {
    final updatedScreens = screens.map((screen) {
      return screen.copyWith(isMain: screen.id == screenId);
    }).toList();

    return copyWith(screens: updatedScreens, updatedAt: DateTime.now());
  }

  /// Add dependency
  ProjectModel addDependency(String dependency) {
    if (dependencies.contains(dependency)) return this;

    return copyWith(
      dependencies: [...dependencies, dependency],
      updatedAt: DateTime.now(),
    );
  }

  /// Remove dependency
  ProjectModel removeDependency(String dependency) {
    return copyWith(
      dependencies: dependencies.where((dep) => dep != dependency).toList(),
      updatedAt: DateTime.now(),
    );
  }

  /// Add asset
  ProjectModel addAsset(String assetPath) {
    if (assets.contains(assetPath)) return this;

    return copyWith(assets: [...assets, assetPath], updatedAt: DateTime.now());
  }

  /// Remove asset
  ProjectModel removeAsset(String assetPath) {
    return copyWith(
      assets: assets.where((asset) => asset != assetPath).toList(),
      updatedAt: DateTime.now(),
    );
  }

  /// Update settings
  ProjectModel updateSettings(Map<String, dynamic> newSettings) {
    final updatedSettings = Map<String, dynamic>.from(settings);

    // Deep merge settings
    newSettings.forEach((key, value) {
      if (value is Map<String, dynamic> &&
          updatedSettings[key] is Map<String, dynamic>) {
        updatedSettings[key] = {
          ...updatedSettings[key] as Map<String, dynamic>,
          ...value,
        };
      } else {
        updatedSettings[key] = value;
      }
    });

    return copyWith(settings: updatedSettings, updatedAt: DateTime.now());
  }

  /// Get total widget count across all screens
  int get totalWidgetCount {
    return screens.fold(0, (total, screen) => total + screen.widgets.length);
  }

  /// Get project statistics
  Map<String, dynamic> get statistics {
    final widgetTypes = <String, int>{};
    final totalWidgets = totalWidgetCount;

    for (final screen in screens) {
      for (final widget in screen.widgets) {
        final typeName = widget.type.displayName;
        widgetTypes[typeName] = (widgetTypes[typeName] ?? 0) + 1;
      }
    }

    return {
      'screenCount': screens.length,
      'totalWidgets': totalWidgets,
      'widgetTypes': widgetTypes,
      'dependencies': dependencies.length,
      'assets': assets.length,
      'lastModified': updatedAt?.toIso8601String(),
    };
  }

  /// Check if project is valid for export
  bool get isValidForExport {
    return name.isNotEmpty && screens.isNotEmpty && mainScreen != null;
  }

  /// Get export validation errors
  List<String> get exportValidationErrors {
    final errors = <String>[];

    if (name.isEmpty) {
      errors.add('Project name is required');
    }

    if (screens.isEmpty) {
      errors.add('Project must have at least one screen');
    }

    if (mainScreen == null) {
      errors.add('Project must have a main screen');
    }

    if (packageName.isEmpty || !_isValidPackageName(packageName)) {
      errors.add('Valid package name is required');
    }

    return errors;
  }

  /// Validate package name format
  bool _isValidPackageName(String packageName) {
    final regex = RegExp(r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)*$');
    return regex.hasMatch(packageName);
  }

  /// Create a duplicate project
  ProjectModel duplicate({String? newName}) {
    final now = DateTime.now();
    final duplicatedScreens = screens
        .map((screen) => screen.duplicate())
        .toList();

    return copyWith(
      id: const Uuid().v4(),
      name: newName ?? '$name Copy',
      screens: duplicatedScreens,
      createdAt: now,
      updatedAt: now,
      thumbnailPath: null,
    );
  }

  /// Export project metadata
  Map<String, dynamic> toExportJson() {
    return {
      'project': toJson(),
      'metadata': {
        'exportedAt': DateTime.now().toIso8601String(),
        'exportedBy': 'WidgetX',
        'version': '1.0.0',
      },
      'statistics': statistics,
    };
  }
}

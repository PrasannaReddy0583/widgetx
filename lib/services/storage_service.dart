import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project_model.dart';
import '../core/constants/app_constants.dart';

/// Storage service for persisting data locally
class StorageService {
  static final StorageService _instance = StorageService._internal();
  static StorageService get instance => _instance;

  StorageService._internal();

  SharedPreferences? _prefs;

  /// Initialize the storage service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save project to local storage
  Future<void> saveProject(ProjectModel project) async {
    if (_prefs == null) throw Exception('StorageService not initialized');
    final projectJson = jsonEncode(project.toJson());
    await _prefs!.setString('project_${project.id}', projectJson);

    // Update project list
    final projectIds = getProjectIds();
    if (!projectIds.contains(project.id)) {
      projectIds.add(project.id);
      await _prefs!.setStringList('project_ids', projectIds);
    }
  }

  /// Load project from local storage
  Future<ProjectModel?> loadProject(String projectId) async {
    if (_prefs == null) return null;
    final projectJson = _prefs!.getString('project_$projectId');
    if (projectJson == null) return null;

    try {
      final projectData = jsonDecode(projectJson) as Map<String, dynamic>;
      return ProjectModel.fromJson(projectData);
    } catch (e) {
      return null;
    }
  }

  /// Delete project from local storage
  Future<void> deleteProject(String projectId) async {
    if (_prefs == null) throw Exception('StorageService not initialized');
    await _prefs!.remove('project_$projectId');

    // Update project list
    final projectIds = getProjectIds();
    projectIds.remove(projectId);
    await _prefs!.setStringList('project_ids', projectIds);
  }

  /// Get all project IDs
  List<String> getProjectIds() {
    if (_prefs == null) return [];
    return _prefs!.getStringList('project_ids') ?? [];
  }

  /// Get all projects
  Future<List<ProjectModel>> getAllProjects() async {
    final projectIds = getProjectIds();
    final projects = <ProjectModel>[];

    for (final id in projectIds) {
      final project = await loadProject(id);
      if (project != null) {
        projects.add(project);
      }
    }

    return projects;
  }

  /// Save recent projects
  Future<void> saveRecentProjects(List<ProjectModel> projects) async {
    if (_prefs == null) throw Exception('StorageService not initialized');
    final recentData = projects.map((p) => p.toJson()).toList();
    final recentJson = jsonEncode(recentData);
    await _prefs!.setString(AppConstants.recentProjectsKey, recentJson);
  }

  /// Get recent projects
  Future<List<ProjectModel>> getRecentProjects() async {
    if (_prefs == null) return [];
    final recentJson = _prefs!.getString(AppConstants.recentProjectsKey);
    if (recentJson == null) return [];

    try {
      final recentData = jsonDecode(recentJson) as List<dynamic>;
      return recentData
          .map((data) => ProjectModel.fromJson(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Save app settings
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    if (_prefs == null) throw Exception('StorageService not initialized');
    final settingsJson = jsonEncode(settings);
    await _prefs!.setString(AppConstants.settingsKey, settingsJson);
  }

  /// Get app settings
  Map<String, dynamic> getSettings() {
    if (_prefs == null) return {};
    final settingsJson = _prefs!.getString(AppConstants.settingsKey);
    if (settingsJson == null) return {};

    try {
      return jsonDecode(settingsJson) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  /// Clear all data
  Future<void> clearAll() async {
    if (_prefs == null) throw Exception('StorageService not initialized');
    await _prefs!.clear();
  }

  /// Export project data
  Map<String, dynamic> exportProject(ProjectModel project) {
    return {
      'project': project.toJson(),
      'exportedAt': DateTime.now().toIso8601String(),
      'exportedBy': AppConstants.appName,
      'version': AppConstants.appVersion,
    };
  }

  /// Import project data
  ProjectModel? importProject(Map<String, dynamic> data) {
    try {
      final projectData = data['project'] as Map<String, dynamic>;
      return ProjectModel.fromJson(projectData);
    } catch (e) {
      return null;
    }
  }
}

/// Storage service provider
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden');
});

/// Initialize storage service
Future<Override> initializeStorageService() async {
  final storageService = StorageService.instance;
  await storageService.init();
  return storageServiceProvider.overrideWithValue(storageService);
}

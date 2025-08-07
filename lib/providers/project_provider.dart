import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project_model.dart';
import '../models/screen_model.dart';
import '../services/storage_service.dart';

/// Project state
class ProjectState {
  const ProjectState({
    this.currentProject,
    this.recentProjects = const [],
    this.isLoading = false,
    this.error,
  });

  final ProjectModel? currentProject;
  final List<ProjectModel> recentProjects;
  final bool isLoading;
  final String? error;

  ProjectState copyWith({
    ProjectModel? currentProject,
    List<ProjectModel>? recentProjects,
    bool? isLoading,
    String? error,
  }) {
    return ProjectState(
      currentProject: currentProject ?? this.currentProject,
      recentProjects: recentProjects ?? this.recentProjects,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Project provider
class ProjectNotifier extends StateNotifier<ProjectState> {
  ProjectNotifier(this._storageService) : super(const ProjectState()) {
    _loadRecentProjects();
  }

  final StorageService _storageService;

  /// Create new project
  Future<void> createProject({
    required String name,
    String? description,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final project = ProjectModel.create(name: name, description: description);

      await _storageService.saveProject(project);
      await _addToRecentProjects(project);

      state = state.copyWith(currentProject: project, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create project: $e',
      );
    }
  }

  /// Load project
  Future<void> loadProject(String projectId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final project = await _storageService.loadProject(projectId);
      if (project != null) {
        await _addToRecentProjects(project);
        state = state.copyWith(currentProject: project, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, error: 'Project not found');
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load project: $e',
      );
    }
  }

  /// Save current project
  Future<void> saveProject() async {
    if (state.currentProject == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _storageService.saveProject(state.currentProject!);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to save project: $e',
      );
    }
  }

  /// Update project
  void updateProject(ProjectModel updatedProject) {
    state = state.copyWith(currentProject: updatedProject);
    // Auto-save after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (state.currentProject?.id == updatedProject.id) {
        saveProject();
      }
    });
  }

  /// Add screen to current project
  void addScreen(ScreenModel screen) {
    if (state.currentProject == null) return;

    final updatedProject = state.currentProject!.addScreen(screen);
    updateProject(updatedProject);
  }

  /// Remove screen from current project
  void removeScreen(String screenId) {
    if (state.currentProject == null) return;

    final updatedProject = state.currentProject!.removeScreen(screenId);
    updateProject(updatedProject);
  }

  /// Update screen in current project
  void updateScreen(ScreenModel updatedScreen) {
    if (state.currentProject == null) return;

    final updatedProject = state.currentProject!.updateScreen(updatedScreen);
    updateProject(updatedProject);
  }

  /// Set main screen
  void setMainScreen(String screenId) {
    if (state.currentProject == null) return;

    final updatedProject = state.currentProject!.setMainScreen(screenId);
    updateProject(updatedProject);
  }

  /// Update project settings
  void updateSettings(Map<String, dynamic> settings) {
    if (state.currentProject == null) return;

    final updatedProject = state.currentProject!.updateSettings(settings);
    updateProject(updatedProject);
  }

  /// Add dependency
  void addDependency(String dependency) {
    if (state.currentProject == null) return;

    final updatedProject = state.currentProject!.addDependency(dependency);
    updateProject(updatedProject);
  }

  /// Remove dependency
  void removeDependency(String dependency) {
    if (state.currentProject == null) return;

    final updatedProject = state.currentProject!.removeDependency(dependency);
    updateProject(updatedProject);
  }

  /// Add asset
  void addAsset(String assetPath) {
    if (state.currentProject == null) return;

    final updatedProject = state.currentProject!.addAsset(assetPath);
    updateProject(updatedProject);
  }

  /// Remove asset
  void removeAsset(String assetPath) {
    if (state.currentProject == null) return;

    final updatedProject = state.currentProject!.removeAsset(assetPath);
    updateProject(updatedProject);
  }

  /// Delete project
  Future<void> deleteProject(String projectId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _storageService.deleteProject(projectId);

      // Remove from recent projects
      final updatedRecent = state.recentProjects
          .where((p) => p.id != projectId)
          .toList();

      // Clear current project if it's the one being deleted
      final updatedCurrent = state.currentProject?.id == projectId
          ? null
          : state.currentProject;

      state = state.copyWith(
        currentProject: updatedCurrent,
        recentProjects: updatedRecent,
        isLoading: false,
      );

      await _saveRecentProjects();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to delete project: $e',
      );
    }
  }

  /// Duplicate project
  Future<void> duplicateProject(String projectId, {String? newName}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final originalProject = await _storageService.loadProject(projectId);
      if (originalProject == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Original project not found',
        );
        return;
      }

      final duplicatedProject = originalProject.duplicate(newName: newName);
      await _storageService.saveProject(duplicatedProject);
      await _addToRecentProjects(duplicatedProject);

      state = state.copyWith(
        currentProject: duplicatedProject,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to duplicate project: $e',
      );
    }
  }

  /// Load recent projects
  Future<void> _loadRecentProjects() async {
    try {
      final recent = await _storageService.getRecentProjects();
      state = state.copyWith(recentProjects: recent);
    } catch (e) {
      // Ignore errors when loading recent projects
    }
  }

  /// Add project to recent projects
  Future<void> _addToRecentProjects(ProjectModel project) async {
    final recent = List<ProjectModel>.from(state.recentProjects);

    // Remove if already exists
    recent.removeWhere((p) => p.id == project.id);

    // Add to beginning
    recent.insert(0, project);

    // Limit to 10 recent projects
    if (recent.length > 10) {
      recent.removeRange(10, recent.length);
    }

    state = state.copyWith(recentProjects: recent);
    await _saveRecentProjects();
  }

  /// Save recent projects
  Future<void> _saveRecentProjects() async {
    try {
      await _storageService.saveRecentProjects(state.recentProjects);
    } catch (e) {
      // Ignore errors when saving recent projects
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Get project statistics
  Map<String, dynamic> get projectStatistics {
    if (state.currentProject == null) return {};
    return state.currentProject!.statistics;
  }

  /// Check if project is valid for export
  bool get canExport {
    return state.currentProject?.isValidForExport ?? false;
  }

  /// Get export validation errors
  List<String> get exportValidationErrors {
    return state.currentProject?.exportValidationErrors ?? [];
  }
}

/// Project provider
final projectProvider = StateNotifierProvider<ProjectNotifier, ProjectState>((
  ref,
) {
  final storageService = ref.watch(storageServiceProvider);
  return ProjectNotifier(storageService);
});

/// Current project provider
final currentProjectProvider = Provider<ProjectModel?>((ref) {
  return ref.watch(projectProvider).currentProject;
});

/// Recent projects provider
final recentProjectsProvider = Provider<List<ProjectModel>>((ref) {
  return ref.watch(projectProvider).recentProjects;
});

/// Project loading state provider
final projectLoadingProvider = Provider<bool>((ref) {
  return ref.watch(projectProvider).isLoading;
});

/// Project error provider
final projectErrorProvider = Provider<String?>((ref) {
  return ref.watch(projectProvider).error;
});

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../models/screen_model.dart';
import '../models/widget_model.dart';

/// Auto-compilation service for real-time preview
class AutoCompilationService {
  static final AutoCompilationService _instance = AutoCompilationService._internal();
  factory AutoCompilationService() => _instance;
  AutoCompilationService._internal();

  Timer? _compilationTimer;
  final StreamController<CompilationResult> _compilationController = 
      StreamController<CompilationResult>.broadcast();
  
  Stream<CompilationResult> get compilationStream => _compilationController.stream;
  
  CompilationStatus _currentStatus = CompilationStatus.idle;
  CompilationStatus get currentStatus => _currentStatus;

  /// Start auto-compilation for a project
  void startAutoCompilation(ProjectModel project) {
    _cancelCurrentCompilation();
    _scheduleCompilation(project);
  }

  /// Stop auto-compilation
  void stopAutoCompilation() {
    _cancelCurrentCompilation();
    _updateStatus(CompilationStatus.idle);
  }

  /// Manually trigger compilation
  Future<CompilationResult> compileProject(ProjectModel project) async {
    _updateStatus(CompilationStatus.compiling);
    
    try {
      // Simulate compilation process
      await Future.delayed(const Duration(milliseconds: 500));
      
      final result = await _performCompilation(project);
      _compilationController.add(result);
      
      _updateStatus(result.hasErrors 
          ? CompilationStatus.error 
          : CompilationStatus.success);
      
      return result;
    } catch (e) {
      final errorResult = CompilationResult(
        success: false,
        errors: [CompilationError(
          message: 'Compilation failed: $e',
          type: ErrorType.fatal,
          line: 0,
          column: 0,
        )],
        warnings: [],
        compilationTime: DateTime.now(),
      );
      
      _compilationController.add(errorResult);
      _updateStatus(CompilationStatus.error);
      
      return errorResult;
    }
  }

  void _scheduleCompilation(ProjectModel project) {
    _compilationTimer = Timer(const Duration(milliseconds: 300), () async {
      await compileProject(project);
    });
  }

  void _cancelCurrentCompilation() {
    _compilationTimer?.cancel();
    _compilationTimer = null;
  }

  void _updateStatus(CompilationStatus status) {
    _currentStatus = status;
  }

  Future<CompilationResult> _performCompilation(ProjectModel project) async {
    final errors = <CompilationError>[];
    final warnings = <CompilationWarning>[];

    // Validate project structure
    _validateProject(project, errors, warnings);

    // Validate each screen
    for (final screen in project.screens) {
      _validateScreen(screen, errors, warnings);
    }

    return CompilationResult(
      success: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      compilationTime: DateTime.now(),
    );
  }

  void _validateProject(ProjectModel project, List<CompilationError> errors, List<CompilationWarning> warnings) {
    // Check if project has at least one screen
    if (project.screens.isEmpty) {
      errors.add(CompilationError(
        message: 'Project must have at least one screen',
        type: ErrorType.structural,
        line: 0,
        column: 0,
      ));
    }

    // Check if project has a main screen
    if (project.mainScreen == null) {
      warnings.add(CompilationWarning(
        message: 'No main screen defined. First screen will be used as main.',
        type: WarningType.configuration,
        line: 0,
        column: 0,
      ));
    }

    // Validate package name
    if (!_isValidPackageName(project.packageName)) {
      errors.add(CompilationError(
        message: 'Invalid package name: ${project.packageName}',
        type: ErrorType.configuration,
        line: 0,
        column: 0,
      ));
    }
  }

  void _validateScreen(ScreenModel screen, List<CompilationError> errors, List<CompilationWarning> warnings) {
    // Check screen name
    if (screen.name.trim().isEmpty) {
      errors.add(CompilationError(
        message: 'Screen name cannot be empty',
        type: ErrorType.naming,
        line: 0,
        column: 0,
        screenId: screen.id,
      ));
    }

    // Validate widgets in screen
    for (final widget in screen.widgets) {
      _validateWidget(widget, screen, errors, warnings);
    }

    // Check for widget hierarchy issues
    _validateWidgetHierarchy(screen.widgets, screen, errors, warnings);
  }

  void _validateWidget(WidgetModel widget, ScreenModel screen, List<CompilationError> errors, List<CompilationWarning> warnings) {
    // Check widget name
    if (widget.name.trim().isEmpty) {
      warnings.add(CompilationWarning(
        message: 'Widget has no name',
        type: WarningType.naming,
        line: 0,
        column: 0,
        screenId: screen.id,
        widgetId: widget.id,
      ));
    }

    // Check widget bounds
    if (widget.size.width <= 0 || widget.size.height <= 0) {
      errors.add(CompilationError(
        message: 'Widget must have positive width and height',
        type: ErrorType.layout,
        line: 0,
        column: 0,
        screenId: screen.id,
        widgetId: widget.id,
      ));
    }

    // Check widget position
    if (widget.position.dx < 0 || widget.position.dy < 0) {
      warnings.add(CompilationWarning(
        message: 'Widget has negative position',
        type: WarningType.layout,
        line: 0,
        column: 0,
        screenId: screen.id,
        widgetId: widget.id,
      ));
    }

    // Validate widget-specific properties
    _validateWidgetProperties(widget, screen, errors, warnings);

    // Recursively validate children
    for (final child in widget.children) {
      _validateWidget(child, screen, errors, warnings);
    }
  }

  void _validateWidgetProperties(WidgetModel widget, ScreenModel screen, List<CompilationError> errors, List<CompilationWarning> warnings) {
    switch (widget.type.name) {
      case 'text':
        final text = widget.properties['text'];
        if (text == null || text.toString().trim().isEmpty) {
          warnings.add(CompilationWarning(
            message: 'Text widget has no content',
            type: WarningType.content,
            line: 0,
            column: 0,
            screenId: screen.id,
            widgetId: widget.id,
          ));
        }
        break;
      
      case 'textField':
        // Check if TextField has proper validation
        break;
      
      case 'elevatedButton':
      case 'textButton':
      case 'outlinedButton':
        final buttonText = widget.properties['text'];
        if (buttonText == null || buttonText.toString().trim().isEmpty) {
          warnings.add(CompilationWarning(
            message: 'Button has no text',
            type: WarningType.content,
            line: 0,
            column: 0,
            screenId: screen.id,
            widgetId: widget.id,
          ));
        }
        break;
    }
  }

  void _validateWidgetHierarchy(List<WidgetModel> widgets, ScreenModel screen, List<CompilationError> errors, List<CompilationWarning> warnings) {
    // Check for overlapping widgets
    for (int i = 0; i < widgets.length; i++) {
      for (int j = i + 1; j < widgets.length; j++) {
        if (_widgetsOverlap(widgets[i], widgets[j])) {
          warnings.add(CompilationWarning(
            message: 'Widgets "${widgets[i].name}" and "${widgets[j].name}" overlap',
            type: WarningType.layout,
            line: 0,
            column: 0,
            screenId: screen.id,
            widgetId: widgets[i].id,
          ));
        }
      }
    }

    // Check for widgets outside screen bounds
    for (final widget in widgets) {
      if (_isWidgetOutsideScreen(widget)) {
        warnings.add(CompilationWarning(
          message: 'Widget "${widget.name}" extends outside screen bounds',
          type: WarningType.layout,
          line: 0,
          column: 0,
          screenId: screen.id,
          widgetId: widget.id,
        ));
      }
    }
  }

  bool _widgetsOverlap(WidgetModel widget1, WidgetModel widget2) {
    final rect1 = Rect.fromLTWH(
      widget1.position.dx,
      widget1.position.dy,
      widget1.size.width,
      widget1.size.height,
    );
    
    final rect2 = Rect.fromLTWH(
      widget2.position.dx,
      widget2.position.dy,
      widget2.size.width,
      widget2.size.height,
    );
    
    return rect1.overlaps(rect2);
  }

  bool _isWidgetOutsideScreen(WidgetModel widget) {
    // Assuming standard screen dimensions
    const screenWidth = 375.0;
    const screenHeight = 812.0;
    
    return widget.position.dx < 0 ||
           widget.position.dy < 0 ||
           widget.position.dx + widget.size.width > screenWidth ||
           widget.position.dy + widget.size.height > screenHeight;
  }

  bool _isValidPackageName(String packageName) {
    final regex = RegExp(r'^[a-z][a-z0-9_]*(\.[a-z][a-z0-9_]*)*$');
    return regex.hasMatch(packageName);
  }

  void dispose() {
    _cancelCurrentCompilation();
    _compilationController.close();
  }
}

/// Compilation result
class CompilationResult {
  final bool success;
  final List<CompilationError> errors;
  final List<CompilationWarning> warnings;
  final DateTime compilationTime;

  CompilationResult({
    required this.success,
    required this.errors,
    required this.warnings,
    required this.compilationTime,
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
  int get totalIssues => errors.length + warnings.length;
}

/// Compilation error
class CompilationError {
  final String message;
  final ErrorType type;
  final int line;
  final int column;
  final String? screenId;
  final String? widgetId;

  CompilationError({
    required this.message,
    required this.type,
    required this.line,
    required this.column,
    this.screenId,
    this.widgetId,
  });
}

/// Compilation warning
class CompilationWarning {
  final String message;
  final WarningType type;
  final int line;
  final int column;
  final String? screenId;
  final String? widgetId;

  CompilationWarning({
    required this.message,
    required this.type,
    required this.line,
    required this.column,
    this.screenId,
    this.widgetId,
  });
}

/// Compilation status
enum CompilationStatus {
  idle,
  compiling,
  success,
  error,
}

/// Error types
enum ErrorType {
  syntax,
  structural,
  layout,
  configuration,
  naming,
  fatal,
}

/// Warning types
enum WarningType {
  layout,
  content,
  naming,
  configuration,
  performance,
}

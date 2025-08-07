import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/widget_model.dart';
import '../models/screen_model.dart';
import '../models/project_model.dart';
import '../providers/canvas_provider.dart';
import '../providers/project_provider.dart';
import '../services/auto_compilation_service.dart';

/// Central synchronization service for bi-directional updates
class SynchronizationService {
  static final SynchronizationService _instance = SynchronizationService._internal();
  factory SynchronizationService() => _instance;
  SynchronizationService._internal();

  final StreamController<SyncEvent> _syncController = StreamController<SyncEvent>.broadcast();
  Stream<SyncEvent> get syncStream => _syncController.stream;

  Timer? _debounceTimer;
  final Duration _debounceDelay = const Duration(milliseconds: 150);
  
  bool _isSyncing = false;
  final List<SyncEvent> _pendingEvents = [];

  /// Initialize synchronization with providers
  void initialize(WidgetRef ref) {
    // Listen to canvas changes
    ref.listen<CanvasState>(canvasProvider, (previous, next) {
      if (previous != null && next != previous) {
        _handleCanvasChange(previous, next, ref);
      }
    });

    // Listen to project changes
    ref.listen<ProjectModel?>(currentProjectProvider, (previous, next) {
      if (previous != null && next != null && next != previous) {
        _handleProjectChange(previous, next, ref);
      }
    });
  }

  /// Sync UI changes to properties and code
  void syncFromUI({
    required WidgetModel widget,
    required SyncSource source,
    required WidgetRef ref,
  }) {
    if (_isSyncing) {
      _pendingEvents.add(SyncEvent(
        type: SyncType.uiToProperties,
        widget: widget,
        source: source,
        timestamp: DateTime.now(),
      ));
      return;
    }

    _performSync(() async {
      // Update properties panel
      _updatePropertiesFromUI(widget, ref);
      
      // Update code display
      _updateCodeFromUI(widget, ref);
      
      // Trigger auto-compilation
      _triggerAutoCompilation(ref);
      
      _syncController.add(SyncEvent(
        type: SyncType.uiToProperties,
        widget: widget,
        source: source,
        timestamp: DateTime.now(),
      ));
    });
  }

  /// Sync properties changes to UI and code
  void syncFromProperties({
    required WidgetModel widget,
    required Map<String, dynamic> newProperties,
    required WidgetRef ref,
  }) {
    if (_isSyncing) {
      _pendingEvents.add(SyncEvent(
        type: SyncType.propertiesToUI,
        widget: widget,
        properties: newProperties,
        source: SyncSource.properties,
        timestamp: DateTime.now(),
      ));
      return;
    }

    _performSync(() async {
      // Update widget model
      final updatedWidget = widget.copyWith(properties: newProperties);
      
      // Update canvas
      ref.read(canvasProvider.notifier).updateWidget(updatedWidget);
      
      // Update code display
      _updateCodeFromProperties(updatedWidget, ref);
      
      // Trigger auto-compilation
      _triggerAutoCompilation(ref);
      
      _syncController.add(SyncEvent(
        type: SyncType.propertiesToUI,
        widget: updatedWidget,
        properties: newProperties,
        source: SyncSource.properties,
        timestamp: DateTime.now(),
      ));
    });
  }

  /// Sync code changes to UI and properties
  void syncFromCode({
    required String code,
    required String widgetId,
    required WidgetRef ref,
  }) {
    if (_isSyncing) {
      _pendingEvents.add(SyncEvent(
        type: SyncType.codeToUI,
        code: code,
        widgetId: widgetId,
        source: SyncSource.code,
        timestamp: DateTime.now(),
      ));
      return;
    }

    _performSync(() async {
      try {
        // Parse code to extract widget properties
        final parsedWidget = _parseCodeToWidget(code, widgetId, ref);
        
        if (parsedWidget != null) {
          // Update canvas
          ref.read(canvasProvider.notifier).updateWidget(parsedWidget);
          
          // Update properties panel (will be handled by canvas listener)
          
          // Trigger auto-compilation
          _triggerAutoCompilation(ref);
          
          _syncController.add(SyncEvent(
            type: SyncType.codeToUI,
            widget: parsedWidget,
            code: code,
            source: SyncSource.code,
            timestamp: DateTime.now(),
          ));
        }
      } catch (e) {
        _syncController.add(SyncEvent(
          type: SyncType.error,
          error: 'Failed to parse code: $e',
          source: SyncSource.code,
          timestamp: DateTime.now(),
        ));
      }
    });
  }

  /// Handle canvas state changes
  void _handleCanvasChange(CanvasState previous, CanvasState next, WidgetRef ref) {
    // Check for widget updates
    if (previous.currentScreen != next.currentScreen) {
      _handleScreenChange(previous.currentScreen, next.currentScreen, ref);
    }

    // Check for selection changes
    if (previous.selectedWidgetIds != next.selectedWidgetIds) {
      _handleSelectionChange(previous.selectedWidgetIds, next.selectedWidgetIds, ref);
    }
  }

  /// Handle project changes
  void _handleProjectChange(ProjectModel previous, ProjectModel next, WidgetRef ref) {
    // Trigger auto-compilation for project-level changes
    _debounceAutoCompilation(ref);
  }

  /// Handle screen changes
  void _handleScreenChange(ScreenModel? previous, ScreenModel? next, WidgetRef ref) {
    if (next != null) {
      // Update code display for new screen
      _updateCodeFromScreen(next, ref);
      
      // Trigger auto-compilation
      _triggerAutoCompilation(ref);
    }
  }

  /// Handle selection changes
  void _handleSelectionChange(List<String> previous, List<String> next, WidgetRef ref) {
    // Update properties panel and code display based on new selection
    if (next.isNotEmpty) {
      final selectedWidget = _getWidgetById(next.first, ref);
      if (selectedWidget != null) {
        _updatePropertiesFromUI(selectedWidget, ref);
        _updateCodeFromUI(selectedWidget, ref);
      }
    }
  }

  /// Perform synchronized operation
  void _performSync(Future<void> Function() operation) async {
    _isSyncing = true;
    try {
      await operation();
      
      // Process pending events
      while (_pendingEvents.isNotEmpty) {
        final event = _pendingEvents.removeAt(0);
        _processPendingEvent(event);
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Process pending sync event
  void _processPendingEvent(SyncEvent event) {
    // Re-queue the event for processing
    Timer.run(() {
      switch (event.type) {
        case SyncType.uiToProperties:
          if (event.widget != null) {
            // Re-trigger sync from UI
          }
          break;
        case SyncType.propertiesToUI:
          if (event.widget != null && event.properties != null) {
            // Re-trigger sync from properties
          }
          break;
        case SyncType.codeToUI:
          if (event.code != null && event.widgetId != null) {
            // Re-trigger sync from code
          }
          break;
        default:
          break;
      }
    });
  }

  /// Update properties panel from UI changes
  void _updatePropertiesFromUI(WidgetModel widget, WidgetRef ref) {
    // Properties panel will automatically update through Riverpod listeners
    // This method can be used for additional property-specific logic
  }

  /// Update code display from UI changes
  void _updateCodeFromUI(WidgetModel widget, WidgetRef ref) {
    // Code display will automatically update through Riverpod listeners
    // This method can be used for additional code generation logic
  }

  /// Update code display from properties changes
  void _updateCodeFromProperties(WidgetModel widget, WidgetRef ref) {
    // Generate updated code based on new properties
    // This will be handled by the code learning panel
  }

  /// Update code display from screen changes
  void _updateCodeFromScreen(ScreenModel screen, WidgetRef ref) {
    // Generate code for entire screen
    // This will be handled by the code learning panel
  }

  /// Parse code string to widget model
  WidgetModel? _parseCodeToWidget(String code, String widgetId, WidgetRef ref) {
    // This is a simplified parser - in a real implementation,
    // you would use a proper Dart AST parser
    
    final currentWidget = _getWidgetById(widgetId, ref);
    if (currentWidget == null) return null;

    try {
      final properties = <String, dynamic>{};
      
      // Parse common properties from code
      _parseTextProperty(code, properties);
      _parseColorProperty(code, properties);
      _parseSizeProperties(code, properties);
      _parsePaddingProperty(code, properties);
      
      return currentWidget.copyWith(properties: properties);
    } catch (e) {
      return null;
    }
  }

  /// Parse text property from code
  void _parseTextProperty(String code, Map<String, dynamic> properties) {
    final textRegex = RegExp(r'''Text\s*\(\s*(['"])((?:\\.|(?!\1)[^\\])*?)\1\s*\)''');
    final match = textRegex.firstMatch(code);
    if (match != null) {
      properties['text'] = match.group(1);
    }
  }

  /// Parse color property from code
  void _parseColorProperty(String code, Map<String, dynamic> properties) {
    final colorRegex = RegExp(r"color:\s*Color\s*\(\s*0x([0-9a-fA-F]+)\s*\)");
    final match = colorRegex.firstMatch(code);
    if (match != null) {
      final colorValue = int.parse(match.group(1)!, radix: 16);
      properties['backgroundColor'] = Color(colorValue);
    }
  }

  /// Parse size properties from code
  void _parseSizeProperties(String code, Map<String, dynamic> properties) {
    final widthRegex = RegExp(r"width:\s*([0-9.]+)");
    final heightRegex = RegExp(r"height:\s*([0-9.]+)");
    
    final widthMatch = widthRegex.firstMatch(code);
    if (widthMatch != null) {
      properties['width'] = double.parse(widthMatch.group(1)!);
    }
    
    final heightMatch = heightRegex.firstMatch(code);
    if (heightMatch != null) {
      properties['height'] = double.parse(heightMatch.group(1)!);
    }
  }

  /// Parse padding property from code
  void _parsePaddingProperty(String code, Map<String, dynamic> properties) {
    final paddingRegex = RegExp(r"padding:\s*EdgeInsets\.all\s*\(\s*([0-9.]+)\s*\)");
    final match = paddingRegex.firstMatch(code);
    if (match != null) {
      final paddingValue = double.parse(match.group(1)!);
      properties['padding'] = EdgeInsets.all(paddingValue);
    }
  }

  /// Get widget by ID from current screen
  WidgetModel? _getWidgetById(String widgetId, WidgetRef ref) {
    final currentScreen = ref.read(canvasProvider).currentScreen;
    if (currentScreen == null) return null;
    
    return _findWidgetInList(currentScreen.widgets, widgetId);
  }

  /// Find widget in list recursively
  WidgetModel? _findWidgetInList(List<WidgetModel> widgets, String id) {
    for (final widget in widgets) {
      if (widget.id == id) return widget;
      final found = _findWidgetInList(widget.children, id);
      if (found != null) return found;
    }
    return null;
  }

  /// Trigger auto-compilation immediately
  void _triggerAutoCompilation(WidgetRef ref) {
    final project = ref.read(currentProjectProvider);
    if (project != null) {
      AutoCompilationService().startAutoCompilation(project);
    }
  }

  /// Debounce auto-compilation
  void _debounceAutoCompilation(WidgetRef ref) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDelay, () {
      _triggerAutoCompilation(ref);
    });
  }

  /// Resolve sync conflicts
  SyncResolution resolveSyncConflict({
    required SyncEvent event1,
    required SyncEvent event2,
  }) {
    // Resolve conflicts based on timestamp and source priority
    final timeDiff = event2.timestamp.difference(event1.timestamp);
    
    if (timeDiff.inMilliseconds < 100) {
      // Events are very close in time, use source priority
      final priority1 = _getSourcePriority(event1.source);
      final priority2 = _getSourcePriority(event2.source);
      
      if (priority1 > priority2) {
        return SyncResolution.useFirst;
      } else if (priority2 > priority1) {
        return SyncResolution.useSecond;
      } else {
        return SyncResolution.merge;
      }
    } else {
      // Use the more recent event
      return SyncResolution.useSecond;
    }
  }

  /// Get source priority for conflict resolution
  int _getSourcePriority(SyncSource source) {
    switch (source) {
      case SyncSource.user:
        return 3; // Highest priority
      case SyncSource.properties:
        return 2;
      case SyncSource.ui:
        return 1;
      case SyncSource.code:
        return 1;
      case SyncSource.system:
        return 0; // Lowest priority
    }
  }

  void dispose() {
    _debounceTimer?.cancel();
    _syncController.close();
  }
}

/// Sync event data
class SyncEvent {
  final SyncType type;
  final WidgetModel? widget;
  final Map<String, dynamic>? properties;
  final String? code;
  final String? widgetId;
  final String? error;
  final SyncSource source;
  final DateTime timestamp;

  SyncEvent({
    required this.type,
    this.widget,
    this.properties,
    this.code,
    this.widgetId,
    this.error,
    required this.source,
    required this.timestamp,
  });
}

/// Sync types
enum SyncType {
  uiToProperties,
  propertiesToUI,
  codeToUI,
  uiToCode,
  propertiesToCode,
  codeToProperties,
  error,
}

/// Sync sources
enum SyncSource {
  ui,
  properties,
  code,
  user,
  system,
}

/// Sync conflict resolution
enum SyncResolution {
  useFirst,
  useSecond,
  merge,
  askUser,
}

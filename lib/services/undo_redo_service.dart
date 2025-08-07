import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/screen_model.dart';
import '../models/widget_model.dart';

/// Undo/Redo service for managing action history
class UndoRedoService {
  static final UndoRedoService _instance = UndoRedoService._internal();
  factory UndoRedoService() => _instance;
  UndoRedoService._internal();

  final Queue<UndoableAction> _undoStack = Queue<UndoableAction>();
  final Queue<UndoableAction> _redoStack = Queue<UndoableAction>();

  static const int _maxHistorySize = 50;

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  int get undoCount => _undoStack.length;
  int get redoCount => _redoStack.length;

  /// Execute an action and add it to undo stack
  void executeAction(UndoableAction action) {
    action.execute();
    _addToUndoStack(action);
    _redoStack.clear(); // Clear redo stack when new action is performed
  }

  /// Undo the last action
  bool undo() {
    if (!canUndo) return false;

    final action = _undoStack.removeLast();
    action.undo();
    _redoStack.addLast(action);

    return true;
  }

  /// Redo the last undone action
  bool redo() {
    if (!canRedo) return false;

    final action = _redoStack.removeLast();
    action.execute();
    _undoStack.addLast(action);

    return true;
  }

  /// Clear all history
  void clearHistory() {
    _undoStack.clear();
    _redoStack.clear();
  }

  /// Get undo stack preview for UI
  List<String> getUndoPreview() {
    return _undoStack
        .map((action) => action.description)
        .toList()
        .reversed
        .toList();
  }

  /// Get redo stack preview for UI
  List<String> getRedoPreview() {
    return _redoStack
        .map((action) => action.description)
        .toList()
        .reversed
        .toList();
  }

  void _addToUndoStack(UndoableAction action) {
    _undoStack.addLast(action);

    // Maintain max history size
    while (_undoStack.length > _maxHistorySize) {
      _undoStack.removeFirst();
    }
  }

  /// Create compound action from multiple actions
  UndoableAction createCompoundAction(
    String description,
    List<UndoableAction> actions,
  ) {
    return CompoundAction(description, actions);
  }
}

/// Base class for undoable actions
abstract class UndoableAction {
  final String description;
  final DateTime timestamp;

  UndoableAction(this.description) : timestamp = DateTime.now();

  void execute();
  void undo();
}

/// Compound action that groups multiple actions
class CompoundAction extends UndoableAction {
  final List<UndoableAction> actions;

  CompoundAction(super.description, this.actions);

  @override
  void execute() {
    for (final action in actions) {
      action.execute();
    }
  }

  @override
  void undo() {
    // Undo in reverse order
    for (final action in actions.reversed) {
      action.undo();
    }
  }
}

/// Add widget action
class AddWidgetAction extends UndoableAction {
  final WidgetModel widget;
  final ScreenModel screen;
  final Function(WidgetModel) onAdd;
  final Function(String) onRemove;

  AddWidgetAction({
    required this.widget,
    required this.screen,
    required this.onAdd,
    required this.onRemove,
  }) : super('Add ${widget.type.displayName}');

  @override
  void execute() {
    onAdd(widget);
  }

  @override
  void undo() {
    onRemove(widget.id);
  }
}

/// Remove widget action
class RemoveWidgetAction extends UndoableAction {
  final WidgetModel widget;
  final ScreenModel screen;
  final Function(WidgetModel) onAdd;
  final Function(String) onRemove;

  RemoveWidgetAction({
    required this.widget,
    required this.screen,
    required this.onAdd,
    required this.onRemove,
  }) : super('Remove ${widget.type.displayName}');

  @override
  void execute() {
    onRemove(widget.id);
  }

  @override
  void undo() {
    onAdd(widget);
  }
}

/// Move widget action
class MoveWidgetAction extends UndoableAction {
  final String widgetId;
  final Offset oldPosition;
  final Offset newPosition;
  final Function(String, Offset) onMove;

  MoveWidgetAction({
    required this.widgetId,
    required this.oldPosition,
    required this.newPosition,
    required this.onMove,
  }) : super('Move widget');

  @override
  void execute() {
    onMove(widgetId, newPosition);
  }

  @override
  void undo() {
    onMove(widgetId, oldPosition);
  }
}

/// Resize widget action
class ResizeWidgetAction extends UndoableAction {
  final String widgetId;
  final Size oldSize;
  final Size newSize;
  final Function(String, Size) onResize;

  ResizeWidgetAction({
    required this.widgetId,
    required this.oldSize,
    required this.newSize,
    required this.onResize,
  }) : super('Resize widget');

  @override
  void execute() {
    onResize(widgetId, newSize);
  }

  @override
  void undo() {
    onResize(widgetId, oldSize);
  }
}

/// Update widget properties action
class UpdatePropertiesAction extends UndoableAction {
  final String widgetId;
  final Map<String, dynamic> oldProperties;
  final Map<String, dynamic> newProperties;
  final Function(String, Map<String, dynamic>) onUpdate;

  UpdatePropertiesAction({
    required this.widgetId,
    required this.oldProperties,
    required this.newProperties,
    required this.onUpdate,
  }) : super('Update properties');

  @override
  void execute() {
    onUpdate(widgetId, newProperties);
  }

  @override
  void undo() {
    onUpdate(widgetId, oldProperties);
  }
}

/// Add screen action
class AddScreenAction extends UndoableAction {
  final ScreenModel screen;
  final Function(ScreenModel) onAdd;
  final Function(String) onRemove;

  AddScreenAction({
    required this.screen,
    required this.onAdd,
    required this.onRemove,
  }) : super('Add screen "${screen.name}"');

  @override
  void execute() {
    onAdd(screen);
  }

  @override
  void undo() {
    if (screen.id != null) {
      onRemove(screen.id!);
    }
  }
}

/// Remove screen action
class RemoveScreenAction extends UndoableAction {
  final ScreenModel screen;
  final Function(ScreenModel) onAdd;
  final Function(String) onRemove;

  RemoveScreenAction({
    required this.screen,
    required this.onAdd,
    required this.onRemove,
  }) : super('Remove screen "${screen.name}"');

  @override
  void execute() {
    final id = screen.id;
    if (id != null) {
      onRemove(id);
    }
  }

  @override
  void undo() {
    onAdd(screen);
  }
}

/// Rename action (for widgets, screens, etc.)
class RenameAction extends UndoableAction {
  final String itemId;
  final String oldName;
  final String newName;
  final Function(String, String) onRename;

  RenameAction({
    required this.itemId,
    required this.oldName,
    required this.newName,
    required this.onRename,
  }) : super('Rename "$oldName" to "$newName"');

  @override
  void execute() {
    onRename(itemId, newName);
  }

  @override
  void undo() {
    onRename(itemId, oldName);
  }
}

/// Duplicate action
class DuplicateAction extends UndoableAction {
  final WidgetModel originalWidget;
  final WidgetModel duplicatedWidget;
  final Function(WidgetModel) onAdd;
  final Function(String) onRemove;

  DuplicateAction({
    required this.originalWidget,
    required this.duplicatedWidget,
    required this.onAdd,
    required this.onRemove,
  }) : super('Duplicate ${originalWidget.type.displayName}');

  @override
  void execute() {
    onAdd(duplicatedWidget);
  }

  @override
  void undo() {
    onRemove(duplicatedWidget.id);
  }
}

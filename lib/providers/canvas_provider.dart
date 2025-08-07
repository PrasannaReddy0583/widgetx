import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/widget_model.dart';
import '../models/screen_model.dart';
import '../core/constants/device_frames.dart';
import '../core/constants/app_constants.dart';

/// Canvas state for managing the design canvas
class CanvasState {
  const CanvasState({
    this.currentScreen,
    this.selectedWidgetIds = const [],
    this.zoomLevel = 1.0,
    this.deviceFrame = DeviceFrame.iphone14,
    this.showGrid = true,
    this.snapToGrid = true,
    this.isLoading = false,
    this.draggedWidget,
    this.dropPosition,
    this.undoHistory = const [],
    this.redoHistory = const [],
  });

  final ScreenModel? currentScreen;
  final List<String> selectedWidgetIds;
  final double zoomLevel;
  final DeviceFrame deviceFrame;
  final bool showGrid;
  final bool snapToGrid;
  final bool isLoading;
  final WidgetModel? draggedWidget;
  final Offset? dropPosition;
  final List<ScreenModel> undoHistory;
  final List<ScreenModel> redoHistory;

  CanvasState copyWith({
    ScreenModel? currentScreen,
    List<String>? selectedWidgetIds,
    double? zoomLevel,
    DeviceFrame? deviceFrame,
    bool? showGrid,
    bool? snapToGrid,
    bool? isLoading,
    WidgetModel? draggedWidget,
    Offset? dropPosition,
    List<ScreenModel>? undoHistory,
    List<ScreenModel>? redoHistory,
  }) {
    return CanvasState(
      currentScreen: currentScreen ?? this.currentScreen,
      selectedWidgetIds: selectedWidgetIds ?? this.selectedWidgetIds,
      zoomLevel: zoomLevel ?? this.zoomLevel,
      deviceFrame: deviceFrame ?? this.deviceFrame,
      showGrid: showGrid ?? this.showGrid,
      snapToGrid: snapToGrid ?? this.snapToGrid,
      isLoading: isLoading ?? this.isLoading,
      draggedWidget: draggedWidget ?? this.draggedWidget,
      dropPosition: dropPosition ?? this.dropPosition,
      undoHistory: undoHistory ?? this.undoHistory,
      redoHistory: redoHistory ?? this.redoHistory,
    );
  }

  List<WidgetModel> get selectedWidgets {
    if (currentScreen == null) return [];
    return currentScreen!.widgets
        .where((widget) => selectedWidgetIds.contains(widget.id))
        .toList();
  }

  bool get canUndo => undoHistory.isNotEmpty;
  bool get canRedo => redoHistory.isNotEmpty;
}

/// Canvas provider for managing canvas state
class CanvasNotifier extends StateNotifier<CanvasState> {
  CanvasNotifier() : super(const CanvasState());

  /// Set the current screen
  void setCurrentScreen(ScreenModel screen) {
    state = state.copyWith(currentScreen: screen);
  }

  /// Add widget to canvas
  void addWidget(WidgetModel widget) {
    if (state.currentScreen == null) return;

    _saveToHistory();
    final updatedScreen = state.currentScreen!.addWidget(widget);
    state = state.copyWith(
      currentScreen: updatedScreen,
      selectedWidgetIds: [widget.id],
    );
  }

  /// Remove widget from canvas
  void removeWidget(String widgetId) {
    if (state.currentScreen == null) return;

    _saveToHistory();
    final updatedScreen = state.currentScreen!.removeWidget(widgetId);
    final updatedSelection = state.selectedWidgetIds
        .where((id) => id != widgetId)
        .toList();

    state = state.copyWith(
      currentScreen: updatedScreen,
      selectedWidgetIds: updatedSelection,
    );
  }

  /// Update widget properties
  void updateWidget(WidgetModel updatedWidget) {
    if (state.currentScreen == null) return;

    final updatedScreen = state.currentScreen!.updateWidget(updatedWidget);
    state = state.copyWith(currentScreen: updatedScreen);
  }

  /// Move widget to new position
  void moveWidget(String widgetId, Offset newPosition) {
    if (state.currentScreen == null) return;

    final snappedPosition = state.snapToGrid
        ? _snapToGrid(newPosition)
        : newPosition;

    final updatedScreen = state.currentScreen!.moveWidget(
      widgetId,
      snappedPosition,
    );
    state = state.copyWith(currentScreen: updatedScreen);
  }

  /// Move widget to a different parent in the hierarchy
  void moveWidgetToParent(String widgetId, String? newParentId) {
    if (state.currentScreen == null) return;

    _saveToHistory();
    final updatedScreen = state.currentScreen!.moveWidgetToParent(
      widgetId,
      newParentId,
    );
    state = state.copyWith(currentScreen: updatedScreen);
  }

  /// Resize widget
  void resizeWidget(String widgetId, Size newSize) {
    if (state.currentScreen == null) return;

    final updatedScreen = state.currentScreen!.resizeWidget(widgetId, newSize);
    state = state.copyWith(currentScreen: updatedScreen);
  }

  /// Select widget
  void selectWidget(String? widgetId) {
    if (state.currentScreen == null) return;

    final updatedScreen = state.currentScreen!.selectWidget(widgetId);
    final selectedIds = widgetId != null ? [widgetId] : <String>[];

    state = state.copyWith(
      currentScreen: updatedScreen,
      selectedWidgetIds: selectedIds,
    );
  }

  /// Select multiple widgets
  void selectWidgets(List<String> widgetIds) {
    if (state.currentScreen == null) return;

    final updatedScreen = state.currentScreen!.selectWidgets(widgetIds);
    state = state.copyWith(
      currentScreen: updatedScreen,
      selectedWidgetIds: widgetIds,
    );
  }

  /// Toggle widget selection
  void toggleWidgetSelection(String widgetId) {
    final currentSelection = List<String>.from(state.selectedWidgetIds);

    if (currentSelection.contains(widgetId)) {
      currentSelection.remove(widgetId);
    } else {
      currentSelection.add(widgetId);
    }

    selectWidgets(currentSelection);
  }

  /// Clear selection
  void clearSelection() {
    if (state.currentScreen == null) return;

    final updatedScreen = state.currentScreen!.clearSelection();
    state = state.copyWith(currentScreen: updatedScreen, selectedWidgetIds: []);
  }

  /// Duplicate selected widgets
  void duplicateSelectedWidgets() {
    if (state.currentScreen == null || state.selectedWidgetIds.isEmpty) return;

    _saveToHistory();
    final updatedScreen = state.currentScreen!.duplicateSelectedWidgets();
    state = state.copyWith(currentScreen: updatedScreen);
  }

  /// Delete selected widgets
  void deleteSelectedWidgets() {
    if (state.currentScreen == null || state.selectedWidgetIds.isEmpty) return;

    _saveToHistory();
    final updatedScreen = state.currentScreen!.deleteSelectedWidgets();
    state = state.copyWith(currentScreen: updatedScreen, selectedWidgetIds: []);
  }

  /// Align selected widgets
  void alignSelectedWidgets(Alignment alignment) {
    if (state.currentScreen == null || state.selectedWidgetIds.length < 2) return;

    _saveToHistory();
    final selectedWidgets = state.selectedWidgets;
    if (selectedWidgets.isEmpty) return;

    // Find the bounds of all selected widgets
    double minX = selectedWidgets.first.position.dx;
    double maxX = selectedWidgets.first.position.dx + selectedWidgets.first.size.width;
    double minY = selectedWidgets.first.position.dy;
    double maxY = selectedWidgets.first.position.dy + selectedWidgets.first.size.height;

    for (final widget in selectedWidgets) {
      minX = minX < widget.position.dx ? minX : widget.position.dx;
      maxX = maxX > (widget.position.dx + widget.size.width) ? maxX : (widget.position.dx + widget.size.width);
      minY = minY < widget.position.dy ? minY : widget.position.dy;
      maxY = maxY > (widget.position.dy + widget.size.height) ? maxY : (widget.position.dy + widget.size.height);
    }

    final centerX = (minX + maxX) / 2;
    final centerY = (minY + maxY) / 2;

    ScreenModel updatedScreen = state.currentScreen!;

    for (final widget in selectedWidgets) {
      Offset newPosition;
      
      switch (alignment) {
        case Alignment.topLeft:
          newPosition = Offset(minX, minY);
          break;
        case Alignment.topCenter:
          newPosition = Offset(centerX - widget.size.width / 2, minY);
          break;
        case Alignment.topRight:
          newPosition = Offset(maxX - widget.size.width, minY);
          break;
        case Alignment.centerLeft:
          newPosition = Offset(minX, centerY - widget.size.height / 2);
          break;
        case Alignment.center:
          newPosition = Offset(centerX - widget.size.width / 2, centerY - widget.size.height / 2);
          break;
        case Alignment.centerRight:
          newPosition = Offset(maxX - widget.size.width, centerY - widget.size.height / 2);
          break;
        case Alignment.bottomLeft:
          newPosition = Offset(minX, maxY - widget.size.height);
          break;
        case Alignment.bottomCenter:
          newPosition = Offset(centerX - widget.size.width / 2, maxY - widget.size.height);
          break;
        case Alignment.bottomRight:
          newPosition = Offset(maxX - widget.size.width, maxY - widget.size.height);
          break;
        default:
          newPosition = widget.position;
      }

      final updatedWidget = widget.copyWith(position: newPosition);
      updatedScreen = updatedScreen.updateWidget(updatedWidget);
    }

    state = state.copyWith(currentScreen: updatedScreen);
  }

  /// Distribute selected widgets horizontally
  void distributeSelectedWidgetsHorizontally() {
    if (state.currentScreen == null || state.selectedWidgetIds.length < 3) return;

    _saveToHistory();
    final selectedWidgets = List<WidgetModel>.from(state.selectedWidgets);
    if (selectedWidgets.isEmpty) return;

    // Sort widgets by X position
    selectedWidgets.sort((a, b) => a.position.dx.compareTo(b.position.dx));

    final leftmost = selectedWidgets.first;
    final rightmost = selectedWidgets.last;
    final totalWidth = (rightmost.position.dx + rightmost.size.width) - leftmost.position.dx;
    final totalWidgetWidth = selectedWidgets.fold<double>(0, (sum, widget) => sum + widget.size.width);
    final availableSpace = totalWidth - totalWidgetWidth;
    final spacing = availableSpace / (selectedWidgets.length - 1);

    ScreenModel updatedScreen = state.currentScreen!;
    double currentX = leftmost.position.dx;

    for (int i = 0; i < selectedWidgets.length; i++) {
      if (i == 0) {
        currentX += selectedWidgets[i].size.width;
        continue; // Skip the first widget (leftmost)
      }
      
      if (i == selectedWidgets.length - 1) {
        break; // Skip the last widget (rightmost)
      }

      currentX += spacing;
      final newPosition = Offset(currentX, selectedWidgets[i].position.dy);
      final updatedWidget = selectedWidgets[i].copyWith(position: newPosition);
      updatedScreen = updatedScreen.updateWidget(updatedWidget);
      currentX += selectedWidgets[i].size.width;
    }

    state = state.copyWith(currentScreen: updatedScreen);
  }

  /// Distribute selected widgets vertically
  void distributeSelectedWidgetsVertically() {
    if (state.currentScreen == null || state.selectedWidgetIds.length < 3) return;

    _saveToHistory();
    final selectedWidgets = List<WidgetModel>.from(state.selectedWidgets);
    if (selectedWidgets.isEmpty) return;

    // Sort widgets by Y position
    selectedWidgets.sort((a, b) => a.position.dy.compareTo(b.position.dy));

    final topmost = selectedWidgets.first;
    final bottommost = selectedWidgets.last;
    final totalHeight = (bottommost.position.dy + bottommost.size.height) - topmost.position.dy;
    final totalWidgetHeight = selectedWidgets.fold<double>(0, (sum, widget) => sum + widget.size.height);
    final availableSpace = totalHeight - totalWidgetHeight;
    final spacing = availableSpace / (selectedWidgets.length - 1);

    ScreenModel updatedScreen = state.currentScreen!;
    double currentY = topmost.position.dy;

    for (int i = 0; i < selectedWidgets.length; i++) {
      if (i == 0) {
        currentY += selectedWidgets[i].size.height;
        continue; // Skip the first widget (topmost)
      }
      
      if (i == selectedWidgets.length - 1) {
        break; // Skip the last widget (bottommost)
      }

      currentY += spacing;
      final newPosition = Offset(selectedWidgets[i].position.dx, currentY);
      final updatedWidget = selectedWidgets[i].copyWith(position: newPosition);
      updatedScreen = updatedScreen.updateWidget(updatedWidget);
      currentY += selectedWidgets[i].size.height;
    }

    state = state.copyWith(currentScreen: updatedScreen);
  }

  /// Set zoom level
  void setZoomLevel(double zoom) {
    final clampedZoom = zoom.clamp(AppConstants.minZoom, AppConstants.maxZoom);
    state = state.copyWith(zoomLevel: clampedZoom);
  }

  /// Zoom in
  void zoomIn() {
    setZoomLevel(state.zoomLevel * 1.2);
  }

  /// Zoom out
  void zoomOut() {
    setZoomLevel(state.zoomLevel / 1.2);
  }

  /// Reset zoom
  void resetZoom() {
    setZoomLevel(1.0);
  }

  /// Set device frame
  void setDeviceFrame(DeviceFrame frame) {
    state = state.copyWith(deviceFrame: frame);
  }

  /// Toggle grid visibility
  void toggleGrid() {
    state = state.copyWith(showGrid: !state.showGrid);
  }

  /// Toggle snap to grid
  void toggleSnapToGrid() {
    state = state.copyWith(snapToGrid: !state.snapToGrid);
  }

  /// Set drag state
  void setDraggedWidget(WidgetModel? widget) {
    state = state.copyWith(draggedWidget: widget);
  }

  /// Set drop position
  void setDropPosition(Offset? position) {
    state = state.copyWith(dropPosition: position);
  }

  /// Undo last action
  void undo() {
    if (!state.canUndo) return;

    final previousScreen = state.undoHistory.last;
    final newUndoHistory = List<ScreenModel>.from(state.undoHistory)
      ..removeLast();
    final newRedoHistory = state.currentScreen != null
        ? [...state.redoHistory, state.currentScreen!]
        : state.redoHistory;

    state = state.copyWith(
      currentScreen: previousScreen,
      undoHistory: newUndoHistory,
      redoHistory: newRedoHistory,
      selectedWidgetIds: [],
    );
  }

  /// Redo last undone action
  void redo() {
    if (!state.canRedo) return;

    final nextScreen = state.redoHistory.last;
    final newRedoHistory = List<ScreenModel>.from(state.redoHistory)
      ..removeLast();
    final newUndoHistory = state.currentScreen != null
        ? [...state.undoHistory, state.currentScreen!]
        : state.undoHistory;

    state = state.copyWith(
      currentScreen: nextScreen,
      undoHistory: newUndoHistory,
      redoHistory: newRedoHistory,
      selectedWidgetIds: [],
    );
  }

  /// Save current state to history
  void _saveToHistory() {
    if (state.currentScreen == null) return;

    final newHistory = [...state.undoHistory, state.currentScreen!];

    // Limit history size
    if (newHistory.length > AppConstants.maxUndoHistory) {
      newHistory.removeAt(0);
    }

    state = state.copyWith(
      undoHistory: newHistory,
      redoHistory: [], // Clear redo history when new action is performed
    );
  }

  /// Snap position to grid
  Offset _snapToGrid(Offset position) {
    const gridSize = AppConstants.gridSize;
    return Offset(
      (position.dx / gridSize).round() * gridSize,
      (position.dy / gridSize).round() * gridSize,
    );
  }

  /// Get widgets at position
  List<WidgetModel> getWidgetsAtPosition(Offset position) {
    if (state.currentScreen == null) return [];
    return state.currentScreen!.getWidgetsAtPosition(position);
  }

  /// Get widgets in area
  List<WidgetModel> getWidgetsInArea(Rect area) {
    if (state.currentScreen == null) return [];
    return state.currentScreen!.getWidgetsInArea(area);
  }

  /// Select widgets in area
  void selectWidgetsInArea(Rect area) {
    final widgetsInArea = getWidgetsInArea(area);
    final widgetIds = widgetsInArea.map((widget) => widget.id).toList();
    selectWidgets(widgetIds);
  }

  /// Set loading state
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
}

/// Canvas provider
final canvasProvider = StateNotifierProvider<CanvasNotifier, CanvasState>((
  ref,
) {
  return CanvasNotifier();
});

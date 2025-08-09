import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/widget_model.dart';
import '../../core/constants/widget_types.dart';
import '../../providers/canvas_provider.dart';
import '../../providers/properties_provider.dart';
import 'flutter_widget_renderer.dart';

/// Enhanced drag and drop system with proper Flutter widget hierarchy
class EnhancedDragDropSystem extends ConsumerStatefulWidget {
  final Widget child;
  final bool isCanvas;

  const EnhancedDragDropSystem({
    super.key,
    required this.child,
    this.isCanvas = false,
  });

  @override
  ConsumerState<EnhancedDragDropSystem> createState() => _EnhancedDragDropSystemState();
}

class _EnhancedDragDropSystemState extends ConsumerState<EnhancedDragDropSystem> {
  WidgetModel? _draggedWidget;
  Offset? _dragPosition;
  String? _dropTargetId;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return widget.isCanvas 
      ? _buildCanvasDropTarget() 
      : widget.child;
  }

  Widget _buildCanvasDropTarget() {
    return DragTarget<WidgetDefinition>(
      onWillAccept: (data) {
        return data != null;
      },
      onAccept: (data) {
        _handleWidgetDrop(data);
      },
      onAcceptWithDetails: (details) {
        final data = details.data;
        final position = details.offset;
        _handleWidgetDropWithPosition(data, position);
      },
      builder: (context, candidateData, rejectedData) {
        return Stack(
          children: [
            widget.child,
            if (_isDragging && _dragPosition != null)
              Positioned(
                left: _dragPosition!.dx - 50,
                top: _dragPosition!.dy - 25,
                child: _buildDropIndicator(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDropIndicator() {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.3),
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.add, color: Colors.blue, size: 24),
      ),
    );
  }

  void _handleWidgetDrop(WidgetDefinition definition) {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    final propertiesNotifier = ref.read(propertiesProvider.notifier);
    
    // Create new widget at drop position
    final newWidget = WidgetModel.create(
      type: definition.type,
      position: _dragPosition ?? const Offset(100, 100),
    );
    
    // Add to canvas
    canvasNotifier.addWidget(newWidget);
    
    // Select the new widget
    canvasNotifier.selectWidget(newWidget.id);
    propertiesNotifier.setSelectedWidget(newWidget);
    
    setState(() {
      _isDragging = false;
      _dragPosition = null;
    });
  }

  void _handleWidgetDropWithPosition(WidgetDefinition definition, Offset position) {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    final propertiesNotifier = ref.read(propertiesProvider.notifier);
    
    // Convert global position to local canvas position
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final localPosition = renderBox?.globalToLocal(position) ?? position;
    
    // Find potential drop target (parent widget)
    final dropTarget = _findDropTargetAt(localPosition);
    
    // Create new widget
    final newWidget = WidgetModel.create(
      type: definition.type,
      position: dropTarget != null ? Offset.zero : localPosition, // Position relative to parent or canvas
    );
    
    if (dropTarget != null && _canAcceptChild(dropTarget, definition.type)) {
      // Add as child to drop target
      final updatedParent = dropTarget.addChild(newWidget);
      canvasNotifier.updateWidget(updatedParent);
    } else {
      // Add to canvas root
      canvasNotifier.addWidget(newWidget);
    }
    
    // Select the new widget
    canvasNotifier.selectWidget(newWidget.id);
    propertiesNotifier.setSelectedWidget(newWidget);
  }

  WidgetModel? _findDropTargetAt(Offset position) {
    final canvasState = ref.read(canvasProvider);
    if (canvasState.currentScreen == null) return null;
    
    // Find widgets at position (in reverse order to get topmost)
    final widgets = canvasState.currentScreen!.widgets.reversed.toList();
    
    for (final widget in widgets) {
      if (_isPointInWidget(position, widget) && _canAcceptChildren(widget.type)) {
        return widget;
      }
    }
    
    return null;
  }

  bool _isPointInWidget(Offset point, WidgetModel widget) {
    final rect = Rect.fromLTWH(
      widget.position.dx,
      widget.position.dy,
      widget.size.width,
      widget.size.height,
    );
    return rect.contains(point);
  }

  bool _canAcceptChildren(FlutterWidgetType type) {
    switch (type.category) {
      case WidgetCategory.layout:
        return true;
      case WidgetCategory.scrolling:
        return true;
      default:
        return false;
    }
  }

  bool _canAcceptChild(WidgetModel parent, FlutterWidgetType childType) {
    // Specific rules for widget hierarchy
    switch (parent.type) {
      case FlutterWidgetType.container:
      case FlutterWidgetType.card:
      case FlutterWidgetType.padding:
      case FlutterWidgetType.center:
      case FlutterWidgetType.align:
        return true; // These can accept single child
        
      case FlutterWidgetType.row:
      case FlutterWidgetType.column:
      case FlutterWidgetType.wrap:
        return true; // These can accept multiple children
        
      case FlutterWidgetType.stack:
        return true; // Stack can have multiple positioned children
        
      case FlutterWidgetType.listView:
      case FlutterWidgetType.gridView:
        return true; // Scrollable widgets can have children
        
      case FlutterWidgetType.scaffold:
        // Scaffold has specific child slots
        return childType == FlutterWidgetType.appBar ||
               childType == FlutterWidgetType.bottomNavigationBar ||
               childType.category == WidgetCategory.layout;
        
      default:
        return false;
    }
  }
}

/// Widget definition for drag and drop
class WidgetDefinition {
  final FlutterWidgetType type;
  final String name;
  final String description;
  final IconData icon;
  final List<String> tags;
  final Widget? previewWidget;

  const WidgetDefinition({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    this.tags = const [],
    this.previewWidget,
  });
}

/// Canvas widget that renders the widget tree
class CanvasRenderer extends ConsumerWidget {
  final Size deviceSize;
  final double zoom;

  const CanvasRenderer({
    super.key,
    required this.deviceSize,
    this.zoom = 1.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canvasState = ref.watch(canvasProvider);
    final propertiesState = ref.watch(propertiesProvider);
    
    if (canvasState.currentScreen == null) {
      return Container(
        width: deviceSize.width,
        height: deviceSize.height,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(
          child: Text(
            'Drop widgets here to start building',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final widgets = canvasState.currentScreen!.widgets;
    
    return Container(
      width: deviceSize.width,
      height: deviceSize.height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: widgets.map((widget) {
          final isSelected = canvasState.selectedWidgetIds.contains(widget.id);
          
          return Positioned(
            left: widget.position.dx,
            top: widget.position.dy,
            child: GestureDetector(
              onTap: () => _selectWidget(ref, widget),
              onPanUpdate: (details) => _moveWidget(ref, widget, details.delta),
              child: _buildWidget(widget, isSelected, ref),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCanvasWidget(
    WidgetModel widget,
    List<WidgetModel> allWidgets,
    bool isSelected,
    WidgetRef ref,
  ) {
    // Skip rendering child widgets here as they'll be rendered by their parents
    if (widget.parentId != null) {
      return const SizedBox.shrink();
    }
    
    // Get all descendant children recursively
    final children = _getWidgetChildrenRecursive(widget, allWidgets);
    
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: GestureDetector(
        onTap: () => _selectWidget(ref, widget),
        onPanUpdate: (details) => _moveWidget(ref, widget, details.delta),
        child: FlutterWidgetRenderer.render(
          widget,
          isSelected: isSelected,
          children: children,
          onTap: () => _selectWidget(ref, widget),
        ),
      ),
    );
  }

  List<WidgetModel> _getWidgetChildrenRecursive(WidgetModel widget, List<WidgetModel> allWidgets) {
    final directChildren = allWidgets.where((w) => w.parentId == widget.id).toList();
    
    // For each direct child, populate its children recursively
    for (int i = 0; i < directChildren.length; i++) {
      final child = directChildren[i];
      final grandChildren = _getWidgetChildrenRecursive(child, allWidgets);
      
      // Update the child with its populated children
      directChildren[i] = child.copyWith(children: grandChildren);
    }
    
    return directChildren;
  }

  void _selectWidget(WidgetRef ref, WidgetModel widget) {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    final propertiesNotifier = ref.read(propertiesProvider.notifier);
    
    canvasNotifier.selectWidget(widget.id);
    propertiesNotifier.setSelectedWidget(widget);
  }

  void _moveWidget(WidgetRef ref, WidgetModel widget, Offset delta) {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    canvasNotifier.moveWidget(widget.id, widget.position + delta);
  }

  Widget _buildWidget(WidgetModel widget, bool isSelected, WidgetRef ref) {
    final canvasState = ref.read(canvasProvider);
    if (canvasState.currentScreen == null) return const SizedBox.shrink();
    
    // Get children for this widget
    final children = _getWidgetChildrenRecursive(widget, canvasState.currentScreen!.widgets);
    
    return FlutterWidgetRenderer.render(
      widget,
      isSelected: isSelected,
      children: children,
      onTap: () => _selectWidget(ref, widget),
    );
  }
}

/// Draggable widget item from the library
class DraggableWidgetItem extends StatelessWidget {
  final WidgetDefinition definition;
  final Widget child;

  const DraggableWidgetItem({
    super.key,
    required this.definition,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<WidgetDefinition>(
      data: definition,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(definition.icon, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                definition.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: child,
      ),
      child: child,
    );
  }
}

/// Widget library with predefined widgets
class WidgetLibraryDefinitions {
  static const List<WidgetDefinition> allWidgets = [
    // Layout Widgets
    WidgetDefinition(
      type: FlutterWidgetType.container,
      name: 'Container',
      description: 'A convenience widget that combines common painting, positioning, and sizing widgets',
      icon: Icons.crop_square,
      tags: ['layout', 'basic'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.row,
      name: 'Row',
      description: 'A widget that displays its children in a horizontal array',
      icon: Icons.view_week,
      tags: ['layout', 'flex'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.column,
      name: 'Column',
      description: 'A widget that displays its children in a vertical array',
      icon: Icons.view_agenda,
      tags: ['layout', 'flex'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.stack,
      name: 'Stack',
      description: 'A widget that positions its children relative to the edges of its box',
      icon: Icons.layers,
      tags: ['layout', 'positioning'],
    ),
    
    // Display Widgets
    WidgetDefinition(
      type: FlutterWidgetType.text,
      name: 'Text',
      description: 'A run of text with a single style',
      icon: Icons.text_fields,
      tags: ['display', 'basic'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.image,
      name: 'Image',
      description: 'A widget that displays an image',
      icon: Icons.image,
      tags: ['display', 'media'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.icon,
      name: 'Icon',
      description: 'A graphical icon widget drawn with a glyph from a font',
      icon: Icons.star,
      tags: ['display', 'basic'],
    ),
    
    // Input Widgets
    WidgetDefinition(
      type: FlutterWidgetType.elevatedButton,
      name: 'Elevated Button',
      description: 'A Material Design elevated button',
      icon: Icons.smart_button,
      tags: ['input', 'material'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.textField,
      name: 'Text Field',
      description: 'A Material Design text field',
      icon: Icons.text_snippet,
      tags: ['input', 'form'],
    ),
    
    // Scrolling Widgets
    WidgetDefinition(
      type: FlutterWidgetType.listView,
      name: 'List View',
      description: 'A scrollable, linear list of widgets',
      icon: Icons.list,
      tags: ['scrolling', 'list'],
    ),
  ];
  
  static List<WidgetDefinition> getByCategory(WidgetCategory category) {
    return allWidgets.where((w) => w.type.category == category).toList();
  }
  
  static List<WidgetDefinition> search(String query) {
    final lowerQuery = query.toLowerCase();
    return allWidgets.where((w) {
      return w.name.toLowerCase().contains(lowerQuery) ||
             w.description.toLowerCase().contains(lowerQuery) ||
             w.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}

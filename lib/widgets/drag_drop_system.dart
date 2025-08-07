import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/widget_model.dart';
import '../providers/canvas_provider.dart';
import '../core/constants/widget_types.dart';

/// Enhanced drag & drop system for FlutterFlow-like functionality
class DragDropSystem extends ConsumerStatefulWidget {
  final Widget child;
  final bool isCanvas;

  const DragDropSystem({super.key, required this.child, this.isCanvas = false});

  @override
  ConsumerState<DragDropSystem> createState() => _DragDropSystemState();
}

class _DragDropSystemState extends ConsumerState<DragDropSystem> {
  Offset? _dragPosition;
  WidgetModel? _draggedWidget;
  final bool _isDragging = false;
  String? _dropTargetId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DragTarget<WidgetModel>(
          onWillAcceptWithDetails: (data) {
            if (widget.isCanvas && data != null) {
              setState(() {
                _dropTargetId = 'canvas';
              });
              return true;
            }
            return false;
          },
          onAcceptWithDetails: (data) {
            if (widget.isCanvas) {
              _handleCanvasDrop(data.data);
            }
            setState(() {
              _dropTargetId = null;
            });
          },
          onLeave: (data) {
            setState(() {
              _dropTargetId = null;
            });
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              decoration: widget.isCanvas && _dropTargetId == 'canvas'
                  ? BoxDecoration(
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              child: widget.child,
            );
          },
        ),
        if (_isDragging && _dragPosition != null && _draggedWidget != null)
          Positioned(
            left: _dragPosition!.dx - 50,
            top: _dragPosition!.dy - 25,
            child: _buildDragPreview(_draggedWidget!),
          ),
      ],
    );
  }

  void _handleCanvasDrop(WidgetModel widget) {
    final canvasNotifier = ref.read(canvasProvider.notifier);

    // Calculate drop position relative to canvas
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && _dragPosition != null) {
      final localPosition = renderBox.globalToLocal(_dragPosition!);

      // Create new widget at drop position
      final newWidget = widget.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        position: Offset(
          localPosition.dx.clamp(0, renderBox.size.width - widget.size.width),
          localPosition.dy.clamp(0, renderBox.size.height - widget.size.height),
        ),
      );

      canvasNotifier.addWidget(newWidget);
    }
  }

  Widget _buildDragPreview(WidgetModel widget) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 100,
        height: 50,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getWidgetIcon(widget.type), size: 20, color: Colors.blue),
            const SizedBox(height: 4),
            Text(
              widget.type.displayName,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWidgetIcon(FlutterWidgetType type) {
    switch (type) {
      case FlutterWidgetType.container:
        return Icons.crop_square;
      case FlutterWidgetType.text:
        return Icons.text_fields;
      case FlutterWidgetType.elevatedButton:
        return Icons.smart_button;
      case FlutterWidgetType.row:
        return Icons.view_week;
      case FlutterWidgetType.column:
        return Icons.view_column;
      case FlutterWidgetType.stack:
        return Icons.layers;
      case FlutterWidgetType.image:
        return Icons.image;
      case FlutterWidgetType.icon:
        return Icons.star;
      case FlutterWidgetType.listView:
        return Icons.list;
      default:
        return Icons.widgets;
    }
  }
}

/// Draggable widget item for the widget library
class DraggableWidgetItem extends StatefulWidget {
  final WidgetModel widget;
  final Widget child;

  const DraggableWidgetItem({
    super.key,
    required this.widget,
    required this.child,
  });

  @override
  State<DraggableWidgetItem> createState() => _DraggableWidgetItemState();
}

class _DraggableWidgetItemState extends State<DraggableWidgetItem> {
  @override
  Widget build(BuildContext context) {
    return Draggable<WidgetModel>(
      data: widget.widget,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 120,
          height: 60,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getWidgetIcon(widget.widget.type),
                size: 24,
                color: Colors.blue,
              ),
              const SizedBox(height: 4),
              Text(
                widget.widget.type.displayName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.5, child: widget.child),
      child: widget.child,
    );
  }

  IconData _getWidgetIcon(FlutterWidgetType type) {
    switch (type) {
      case FlutterWidgetType.container:
        return Icons.crop_square;
      case FlutterWidgetType.text:
        return Icons.text_fields;
      case FlutterWidgetType.elevatedButton:
        return Icons.smart_button;
      case FlutterWidgetType.row:
        return Icons.view_week;
      case FlutterWidgetType.column:
        return Icons.view_column;
      case FlutterWidgetType.stack:
        return Icons.layers;
      case FlutterWidgetType.image:
        return Icons.image;
      case FlutterWidgetType.icon:
        return Icons.star;
      case FlutterWidgetType.listView:
        return Icons.list;
      default:
        return Icons.widgets;
    }
  }
}

/// Enhanced drop zone for nested widget placement
class WidgetDropZone extends ConsumerStatefulWidget {
  final String parentWidgetId;
  final Widget child;

  const WidgetDropZone({
    super.key,
    required this.parentWidgetId,
    required this.child,
  });

  @override
  ConsumerState<WidgetDropZone> createState() => _WidgetDropZoneState();
}

class _WidgetDropZoneState extends ConsumerState<WidgetDropZone> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<WidgetModel>(
      onWillAcceptWithDetails: (data) {
        setState(() => _isHovered = true);
        return data != null;
      },
      onAcceptWithDetails: (data) {
        _handleNestedDrop(data.data);
        setState(() => _isHovered = false);
      },
      onLeave: (data) {
        setState(() => _isHovered = false);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          decoration: _isHovered
              ? BoxDecoration(
                  border: Border.all(
                    color: Colors.green.withOpacity(0.7),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: widget.child,
        );
      },
    );
  }

  void _handleNestedDrop(WidgetModel droppedWidget) {
    final canvasNotifier = ref.read(canvasProvider.notifier);

    // Create new widget as child of parent
    final newWidget = droppedWidget.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      parentId: widget.parentWidgetId,
      position: const Offset(0, 0), // Relative to parent
    );

    canvasNotifier.addWidget(newWidget);
  }
}

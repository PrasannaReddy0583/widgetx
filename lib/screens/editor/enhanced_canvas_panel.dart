import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/widget_model.dart';
import '../../providers/canvas_provider.dart';
import '../../providers/properties_provider.dart';
import '../../widgets/drag_drop_system.dart';
import '../../core/constants/widget_types.dart';

/// Enhanced canvas panel with real-time visual feedback and drag & drop
class EnhancedCanvasPanel extends ConsumerStatefulWidget {
  const EnhancedCanvasPanel({super.key});

  @override
  ConsumerState<EnhancedCanvasPanel> createState() =>
      _EnhancedCanvasPanelState();
}

class _EnhancedCanvasPanelState extends ConsumerState<EnhancedCanvasPanel> {
  final GlobalKey _canvasKey = GlobalKey();
  double _zoomLevel = 1.0;
  bool _showGrid = true;
  String _selectedDeviceFrame = 'Mobile';

  final Map<String, Size> _deviceFrames = {
    'Mobile': const Size(375, 812),
    'Tablet': const Size(768, 1024),
    'Desktop': const Size(1200, 800),
    'Custom': const Size(400, 600),
  };

  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasProvider);
    final deviceSize = _deviceFrames[_selectedDeviceFrame]!;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.symmetric(
            vertical: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
        ),
        child: Column(
          children: [
            _buildToolbar(),
            Expanded(
              child: DragDropSystem(
                isCanvas: true,
                child: _buildCanvasArea(canvasState, deviceSize),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          // Device frame selector
          DropdownButton<String>(
            value: _selectedDeviceFrame,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedDeviceFrame = value);
              }
            },
            items: _deviceFrames.keys.map((frame) {
              final size = _deviceFrames[frame]!;
              return DropdownMenuItem(
                value: frame,
                child: Text(
                  '$frame (${size.width.toInt()}×${size.height.toInt()})',
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 16),

          // Zoom controls
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () => _updateZoom(_zoomLevel * 0.8),
            tooltip: 'Zoom Out',
          ),
          Text('${(_zoomLevel * 100).toInt()}%'),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () => _updateZoom(_zoomLevel * 1.25),
            tooltip: 'Zoom In',
          ),
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            onPressed: _resetView,
            tooltip: 'Reset View',
          ),

          const SizedBox(width: 16),

          // Grid toggle
          IconButton(
            icon: Icon(_showGrid ? Icons.grid_on : Icons.grid_off),
            onPressed: () => setState(() => _showGrid = !_showGrid),
            tooltip: 'Toggle Grid',
          ),

          const Spacer(),

          // Canvas actions
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: _selectAll,
            tooltip: 'Select All',
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearCanvas,
            tooltip: 'Clear Canvas',
          ),
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: _exportCode,
            tooltip: 'Export Code',
          ),
        ],
      ),
    );
  }

  Widget _buildCanvasArea(CanvasState canvasState, Size deviceSize) {
    return InteractiveViewer(
      transformationController: TransformationController(),
      boundaryMargin: const EdgeInsets.all(100),
      minScale: 0.1,
      maxScale: 5.0,
      onInteractionUpdate: (details) {
        setState(() {
          _zoomLevel = details.scale;
        });
      },
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Grid background
            if (_showGrid) _buildGrid(),

            // Device frame
            Center(
              child: Container(
                key: _canvasKey,
                width: deviceSize.width,
                height: deviceSize.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildCanvasContent(canvasState),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return CustomPaint(painter: GridPainter(), size: Size.infinite);
  }

  Widget _buildCanvasContent(CanvasState canvasState) {
    return Stack(
      children: [
        // Background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),

        // Widgets
        if (canvasState.currentScreen != null)
          ...canvasState.currentScreen!.widgets.map(
            (widget) => _buildCanvasWidget(widget),
          ),

        // Selection overlay
        if (canvasState.selectedWidgetIds.isNotEmpty)
          ..._buildSelectionOverlays(canvasState),
      ],
    );
  }

  Widget _buildCanvasWidget(WidgetModel widget) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: CanvasWidget(
        key: ValueKey('${widget.id}_${widget.updatedAt}'),
        widget: widget,
      ),
    );
  }

  List<Widget> _buildSelectionOverlays(CanvasState canvasState) {
    if (canvasState.currentScreen == null) return [];
    return canvasState.selectedWidgetIds
        .map(
          (id) => canvasState.currentScreen!.widgets.firstWhere(
            (w) => w.id == id,
              orElse: () => WidgetModel(
                id: '',
                name: 'Empty',
                type: FlutterWidgetType.container,
                position: Offset.zero,
                size: const Size(100, 100),
                properties: const {},
              ),
          ),
        )
        .where((widget) => widget.id.isNotEmpty)
        .map((widget) => _buildSelectionOverlay(widget))
        .toList();
  }

  Widget _buildSelectionOverlay(WidgetModel widget) {
    return Positioned(
      left: widget.position.dx - 2,
      top: widget.position.dy - 2,
      child: Container(
        width: widget.size.width + 4,
        height: widget.size.height + 4,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Stack(
          children: [
            // Resize handles
            ..._buildResizeHandles(widget),

            // Widget label
            Positioned(
              top: -24,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.type.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildResizeHandles(WidgetModel widget) {
    const handleSize = 8.0;
    final handles = <Widget>[];

    // Corner handles
    final positions = [
      const Offset(-4, -4), // Top-left
      Offset(widget.size.width - 4, -4), // Top-right
      Offset(-4, widget.size.height - 4), // Bottom-left
      Offset(widget.size.width - 4, widget.size.height - 4), // Bottom-right
    ];

    for (final position in positions) {
      handles.add(
        Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onPanUpdate: (details) => _handleResize(widget, details),
            child: Container(
              width: handleSize,
              height: handleSize,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      );
    }

    return handles;
  }

  void _handleResize(WidgetModel widget, DragUpdateDetails details) {
    final canvasNotifier = ref.read(canvasProvider.notifier);

    // Simple resize logic - can be enhanced for more sophisticated resizing
    final newSize = Size(
      (widget.size.width + details.delta.dx).clamp(20, 500),
      (widget.size.height + details.delta.dy).clamp(20, 500),
    );

    final updatedWidget = widget.copyWith(size: newSize);
    canvasNotifier.updateWidget(updatedWidget);
  }

  void _updateZoom(double newZoom) {
    setState(() {
      _zoomLevel = newZoom.clamp(0.1, 5.0);
    });
  }

  void _resetView() {
    setState(() {
      _zoomLevel = 1.0;
    });
  }

  void _selectAll() {
    final canvasState = ref.read(canvasProvider);
    final canvasNotifier = ref.read(canvasProvider.notifier);

    if (canvasState.currentScreen != null) {
      final widgetIds = canvasState.currentScreen!.widgets
          .map((w) => w.id)
          .toList();
      canvasNotifier.selectWidgets(widgetIds);
    }
  }

  void _clearCanvas() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Canvas'),
        content: const Text(
          'Are you sure you want to remove all widgets from the canvas?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final canvasNotifier = ref.read(canvasProvider.notifier);
              final canvasState = ref.read(canvasProvider);
              // Clear all widgets from current screen
              if (canvasState.currentScreen != null) {
                for (final widget in canvasState.currentScreen!.widgets) {
                  canvasNotifier.removeWidget(widget.id);
                }
              }
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _exportCode() {
    // TODO: Implement Flutter code export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code export feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

/// Individual canvas widget with interaction handling
class CanvasWidget extends ConsumerStatefulWidget {
  final WidgetModel widget;

  const CanvasWidget({super.key, required this.widget});

  @override
  ConsumerState<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends ConsumerState<CanvasWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasProvider);
    final isSelected = canvasState.selectedWidgetIds.contains(widget.widget.id);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _selectWidget(),
        onPanUpdate: (details) => _moveWidget(details),
        child: Container(
          width: widget.widget.size.width,
          height: widget.widget.size.height,
          decoration: BoxDecoration(
            border: _isHovered && !isSelected
                ? Border.all(color: Colors.blue.withValues(alpha: 0.5), width: 1)
                : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: _buildWidgetPreview(widget.widget),
        ),
      ),
    );
  }

  Widget _buildWidgetPreview(WidgetModel model) {
    switch (model.type) {
      case FlutterWidgetType.container:
        return _buildContainerPreview(model);
      case FlutterWidgetType.text:
        return _buildTextPreview(model);
      case FlutterWidgetType.elevatedButton:
        return _buildButtonPreview(model);
      case FlutterWidgetType.row:
        return _buildRowPreview(model);
      case FlutterWidgetType.column:
        return _buildColumnPreview(model);
      case FlutterWidgetType.stack:
        return _buildStackPreview(model);
      case FlutterWidgetType.image:
        return _buildImagePreview(model);
      case FlutterWidgetType.icon:
        return _buildIconPreview(model);
      default:
        return _buildDefaultPreview(model);
    }
  }

  Widget _buildContainerPreview(WidgetModel model) {
    final color =
        _parseColor(model.properties['color']) ?? Colors.blue.withOpacity(0.3);
    final borderRadius = (model.properties['borderRadius'] as double?) ?? 8.0;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.5), width: 1),
      ),
      child: const Center(
        child: Icon(Icons.crop_square, color: Colors.blue, size: 24),
      ),
    );
  }

  Widget _buildTextPreview(WidgetModel model) {
    final text = model.properties['text'] as String? ?? 'Text';
    final fontSize = (model.properties['fontSize'] as double?) ?? 16.0;
    final color = _parseColor(model.properties['color']) ?? Colors.black;

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, color: color),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
    );
  }

  Widget _buildButtonPreview(WidgetModel model) {
    final text = model.properties['text'] as String? ?? 'Button';
    final color = _parseColor(model.properties['color']) ?? Colors.blue.withValues(alpha: 0.3);

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildRowPreview(WidgetModel model) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        border: Border.all(color: Colors.purple.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.crop_square, color: Colors.purple, size: 16),
          Icon(Icons.crop_square, color: Colors.purple, size: 16),
          Icon(Icons.crop_square, color: Colors.purple, size: 16),
        ],
      ),
    );
  }

  Widget _buildColumnPreview(WidgetModel model) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        border: Border.all(color: Colors.purple.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.crop_square, color: Colors.purple, size: 16),
          Icon(Icons.crop_square, color: Colors.purple, size: 16),
          Icon(Icons.crop_square, color: Colors.purple, size: 16),
        ],
      ),
    );
  }

  Widget _buildStackPreview(WidgetModel model) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        border: Border.all(color: Colors.purple.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Stack(
        children: [
          Positioned(
            left: 8,
            top: 8,
            child: Icon(Icons.crop_square, color: Colors.purple, size: 20),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Icon(Icons.crop_square, color: Colors.purple, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(WidgetModel model) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        border: Border.all(color: Colors.teal.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Icon(Icons.image, color: Colors.teal, size: 32),
      ),
    );
  }

  Widget _buildIconPreview(WidgetModel model) {
    final iconCode = model.properties['icon'] as int? ?? Icons.star.codePoint;
    final size = (model.properties['size'] as double?) ?? 24.0;
    final color = _parseColor(model.properties['color']) ?? Colors.black;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Icon(
          IconData(iconCode, fontFamily: 'MaterialIcons'),
          size: size,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDefaultPreview(WidgetModel model) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.widgets, color: Colors.grey, size: 24),
            const SizedBox(height: 4),
            Text(
              model.type.displayName,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _parseColor(dynamic value) {
    if (value == null) return null;

    if (value is Color) return value;
    if (value is int) return Color(value);

    return null;
  }

  void _selectWidget() {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    final propertiesNotifier = ref.read(propertiesProvider.notifier);

    canvasNotifier.selectWidget(widget.widget.id);
    propertiesNotifier.setSelectedWidget(widget.widget);
  }

  void _moveWidget(DragUpdateDetails details) {
    final canvasNotifier = ref.read(canvasProvider.notifier);

    final newPosition = Offset(
      widget.widget.position.dx + details.delta.dx,
      widget.widget.position.dy + details.delta.dy,
    );

    final updatedWidget = widget.widget.copyWith(position: newPosition);
    canvasNotifier.updateWidget(updatedWidget);
  }
}

/// Custom painter for grid background
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 0.5;

    const gridSize = 20.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

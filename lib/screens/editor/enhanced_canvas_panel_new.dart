import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/canvas/enhanced_drag_drop_system.dart';
import '../../widgets/canvas/flutter_widget_renderer.dart';
import '../../models/widget_model.dart';
import '../../providers/canvas_provider.dart';
import '../../providers/properties_provider.dart';
import '../../services/synchronization/bidirectional_sync_service.dart';
import '../../core/constants/device_frames.dart';

/// Enhanced canvas panel with proper Flutter widget rendering and drag-drop
class EnhancedCanvasPanel extends ConsumerStatefulWidget {
  const EnhancedCanvasPanel({super.key});

  @override
  ConsumerState<EnhancedCanvasPanel> createState() => _EnhancedCanvasPanelState();
}

class _EnhancedCanvasPanelState extends ConsumerState<EnhancedCanvasPanel> {
  double _zoomLevel = 1.0;
  DeviceFrame _selectedDevice = DeviceFrame.iphone14;
  bool _showGrid = true;
  bool _showRulers = true;
  final TransformationController _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasProvider);
    final syncService = ref.read(bidirectionalSyncServiceProvider);
    
    return Column(
      children: [
        _buildToolbar(),
        Expanded(
          child: _buildCanvasArea(canvasState, syncService),
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Device frame selector
          DropdownButton<DeviceFrame>(
            value: _selectedDevice,
            onChanged: (device) {
              if (device != null) {
                setState(() => _selectedDevice = device);
              }
            },
            items: DeviceFrame.allFrames.map((device) {
              return DropdownMenuItem(
                value: device,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(device.icon, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${device.name} (${device.width.toInt()}×${device.height.toInt()})',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(width: 16),
          const VerticalDivider(width: 1),
          const SizedBox(width: 16),

          // Zoom controls
          IconButton(
            icon: const Icon(Icons.zoom_out, size: 20),
            onPressed: _zoomLevel > 0.25 ? _zoomOut : null,
            tooltip: 'Zoom Out',
          ),
          SizedBox(
            width: 60,
            child: Text(
              '${(_zoomLevel * 100).toInt()}%',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in, size: 20),
            onPressed: _zoomLevel < 3.0 ? _zoomIn : null,
            tooltip: 'Zoom In',
          ),
          IconButton(
            icon: const Icon(Icons.center_focus_strong, size: 20),
            onPressed: _resetZoom,
            tooltip: 'Reset Zoom',
          ),

          const SizedBox(width: 16),
          const VerticalDivider(width: 1),
          const SizedBox(width: 16),

          // View options
          IconButton(
            icon: Icon(
              _showGrid ? Icons.grid_on : Icons.grid_off,
              size: 20,
              color: _showGrid ? Theme.of(context).colorScheme.primary : null,
            ),
            onPressed: () => setState(() => _showGrid = !_showGrid),
            tooltip: 'Toggle Grid',
          ),
          IconButton(
            icon: Icon(
              _showRulers ? Icons.straighten : Icons.straighten_outlined,
              size: 20,
              color: _showRulers ? Theme.of(context).colorScheme.primary : null,
            ),
            onPressed: () => setState(() => _showRulers = !_showRulers),
            tooltip: 'Toggle Rulers',
          ),

          const Spacer(),

          // Canvas actions
          IconButton(
            icon: const Icon(Icons.select_all, size: 20),
            onPressed: _selectAll,
            tooltip: 'Select All',
          ),
          IconButton(
            icon: const Icon(Icons.content_copy, size: 20),
            onPressed: _copySelection,
            tooltip: 'Copy',
          ),
          IconButton(
            icon: const Icon(Icons.content_paste, size: 20),
            onPressed: _paste,
            tooltip: 'Paste',
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: _deleteSelection,
            tooltip: 'Delete Selected',
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.play_arrow, size: 20),
            onPressed: _previewApp,
            tooltip: 'Preview App',
          ),
        ],
      ),
    );
  }

  Widget _buildCanvasArea(CanvasState canvasState, BidirectionalSyncService syncService) {
    return Container(
      color: Colors.grey[100],
      child: Stack(
        children: [
          // Rulers
          if (_showRulers) ...[
            _buildHorizontalRuler(),
            _buildVerticalRuler(),
          ],
          
          // Main canvas area
          Positioned.fill(
            left: _showRulers ? 32 : 0,
            top: _showRulers ? 32 : 0,
            child: InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: const EdgeInsets.all(100),
              minScale: 0.1,
              maxScale: 5.0,
              onInteractionUpdate: (details) {
                setState(() {
                  _zoomLevel = details.scale;
                });
              },
              child: Center(
                child: EnhancedDragDropSystem(
                  isCanvas: true,
                  child: _buildDeviceFrame(canvasState, syncService),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceFrame(CanvasState canvasState, BidirectionalSyncService syncService) {
    return Container(
      width: _selectedDevice.width,
      height: _selectedDevice.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Grid background
          if (_showGrid)
            CustomPaint(
              painter: GridPainter(
                gridSize: 16,
                gridColor: Colors.grey[300]!,
              ),
              size: Size(_selectedDevice.width, _selectedDevice.height),
            ),
          
          // Canvas content
          _buildCanvasContent(canvasState, syncService, Size(_selectedDevice.width, _selectedDevice.height)),
          
          // Drop zones
          _buildDropZones(Size(_selectedDevice.width, _selectedDevice.height)),
        ],
      ),
    );
  }

  Widget _buildCanvasContent(CanvasState canvasState, BidirectionalSyncService syncService, Size deviceSize) {
    if (canvasState.currentScreen == null) {
      return _buildEmptyState(deviceSize);
    }

    final allWidgets = canvasState.currentScreen!.widgets;
    final selectedIds = canvasState.selectedWidgetIds;
    
    // Only render root widgets (those without parents)
    final rootWidgets = allWidgets.where((w) => w.parentId == null).toList();

    return Stack(
      children: [
        // Render only root widgets (children will be rendered recursively)
        ...rootWidgets.map((widget) {
          return _buildCanvasWidget(
            widget,
            allWidgets,
            selectedIds.contains(widget.id),
            syncService,
          );
        }),
        
        // Selection indicators for all selected widgets (including children)
        ...selectedIds.map((id) {
          final widget = allWidgets.where((w) => w.id == id).firstOrNull;
          if (widget != null) {
            return _buildSelectionIndicator(widget);
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildCanvasWidget(
    WidgetModel widget,
    List<WidgetModel> allWidgets,
    bool isSelected,
    BidirectionalSyncService syncService,
  ) {
    // Get children for this widget
    final children = allWidgets.where((w) => w.parentId == widget.id).toList();
    
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: GestureDetector(
        onTap: () => _selectWidget(widget, syncService),
        onPanStart: (details) => _startWidgetDrag(widget),
        onPanUpdate: (details) => _updateWidgetDrag(widget, details.delta, syncService),
        onPanEnd: (details) => _endWidgetDrag(widget, syncService),
        child: MouseRegion(
          cursor: isSelected ? SystemMouseCursors.move : SystemMouseCursors.click,
          child: FlutterWidgetRenderer.render(
            widget,
            isSelected: isSelected,
            children: children,
            onTap: () => _selectWidget(widget, syncService),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Size deviceSize) {
    return SizedBox(
      width: deviceSize.width,
      height: deviceSize.height,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.widgets_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Drag widgets here to start building',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your app will come to life!',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(WidgetModel widget) {
    return Positioned(
      left: widget.position.dx - 2,
      top: widget.position.dy - 2,
      child: Container(
        width: widget.size.width + 4,
        height: widget.size.height + 4,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Stack(
          children: [
            // Corner handles
            _buildCornerHandle(Alignment.topLeft),
            _buildCornerHandle(Alignment.topRight),
            _buildCornerHandle(Alignment.bottomLeft),
            _buildCornerHandle(Alignment.bottomRight),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerHandle(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
      ),
    );
  }

  Widget _buildDropZones(Size deviceSize) {
    return Stack(
      children: [
        // Add drop zone indicators when dragging
        // This would be shown during drag operations
      ],
    );
  }

  Widget _buildHorizontalRuler() {
    return Positioned(
      top: 0,
      left: 32,
      right: 0,
      height: 32,
      child: Container(
        color: Colors.grey[200],
        child: CustomPaint(
          painter: RulerPainter(isHorizontal: true),
        ),
      ),
    );
  }

  Widget _buildVerticalRuler() {
    return Positioned(
      left: 0,
      top: 32,
      bottom: 0,
      width: 32,
      child: Container(
        color: Colors.grey[200],
        child: CustomPaint(
          painter: RulerPainter(isHorizontal: false),
        ),
      ),
    );
  }

  // Widget interaction methods
  void _selectWidget(WidgetModel widget, BidirectionalSyncService syncService) {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    final propertiesNotifier = ref.read(propertiesProvider.notifier);
    
    canvasNotifier.selectWidget(widget.id);
    propertiesNotifier.setSelectedWidget(widget);
    
    // Trigger synchronization
    final currentScreen = ref.read(canvasProvider).currentScreen;
    if (currentScreen != null) {
      syncService.syncFromUI(currentScreen, widget.id);
    }
  }

  void _startWidgetDrag(WidgetModel widget) {
    // Save initial position for undo
  }

  void _updateWidgetDrag(
    WidgetModel widget,
    Offset delta,
    BidirectionalSyncService syncService,
  ) {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    canvasNotifier.moveWidget(widget.id, widget.position + delta);
  }

  void _endWidgetDrag(WidgetModel widget, BidirectionalSyncService syncService) {
    // Trigger synchronization after drag
    final currentScreen = ref.read(canvasProvider).currentScreen;
    if (currentScreen != null) {
      syncService.syncFromUI(currentScreen, widget.id);
    }
  }

  // Toolbar actions
  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel * 1.25).clamp(0.1, 5.0);
    });
    _applyZoom();
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel / 1.25).clamp(0.1, 5.0);
    });
    _applyZoom();
  }

  void _resetZoom() {
    setState(() {
      _zoomLevel = 1.0;
    });
    _transformationController.value = Matrix4.identity();
  }

  void _applyZoom() {
    final matrix = Matrix4.identity()..scale(_zoomLevel);
    _transformationController.value = matrix;
  }

  void _selectAll() {
    final canvasState = ref.read(canvasProvider);
    if (canvasState.currentScreen != null) {
      final allIds = canvasState.currentScreen!.widgets.map((w) => w.id).toList();
      ref.read(canvasProvider.notifier).selectWidgets(allIds);
    }
  }

  void _copySelection() {
    // Implement copy functionality
    final canvasState = ref.read(canvasProvider);
    final selectedWidgets = canvasState.selectedWidgets;
    
    if (selectedWidgets.isNotEmpty) {
      // Store in clipboard or local storage
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied ${selectedWidgets.length} widget(s)'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _paste() {
    // Implement paste functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Paste functionality coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteSelection() {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    canvasNotifier.deleteSelectedWidgets();
    
    // Trigger synchronization
    final syncService = ref.read(bidirectionalSyncServiceProvider);
    final currentScreen = ref.read(canvasProvider).currentScreen;
    if (currentScreen != null) {
      syncService.syncFromUI(currentScreen, null);
    }
  }

  void _previewApp() {
    // Show preview dialog or navigate to preview screen
    showDialog(
      context: context,
      builder: (context) => _buildPreviewDialog(),
    );
  }

  Widget _buildPreviewDialog() {
    return Dialog(
      child: Container(
        width: 400,
        height: 600,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.play_arrow),
                const SizedBox(width: 8),
                const Text('App Preview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('Live preview of your app will appear here'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid painter for canvas background
class GridPainter extends CustomPainter {
  final double gridSize;
  final Color gridColor;

  GridPainter({required this.gridSize, required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Ruler painter for canvas rulers
class RulerPainter extends CustomPainter {
  final bool isHorizontal;

  RulerPainter({required this.isHorizontal});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[600]!
      ..strokeWidth = 1;

    const tickSpacing = 10.0;
    const majorTickSpacing = 50.0;

    if (isHorizontal) {
      // Draw horizontal ruler
      for (double x = 0; x <= size.width; x += tickSpacing) {
        final isMajorTick = x % majorTickSpacing == 0;
        final tickHeight = isMajorTick ? 8.0 : 4.0;
        
        canvas.drawLine(
          Offset(x, size.height - tickHeight),
          Offset(x, size.height),
          paint,
        );

        if (isMajorTick && x > 0) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: x.toInt().toString(),
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          textPainter.paint(canvas, Offset(x - textPainter.width / 2, 2));
        }
      }
    } else {
      // Draw vertical ruler
      for (double y = 0; y <= size.height; y += tickSpacing) {
        final isMajorTick = y % majorTickSpacing == 0;
        final tickWidth = isMajorTick ? 8.0 : 4.0;
        
        canvas.drawLine(
          Offset(size.width - tickWidth, y),
          Offset(size.width, y),
          paint,
        );

        if (isMajorTick && y > 0) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: y.toInt().toString(),
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
            textDirection: TextDirection.ltr,
          );
          textPainter.layout();
          canvas.save();
          canvas.translate(2, y + textPainter.width / 2);
          canvas.rotate(-1.5708); // -90 degrees
          textPainter.paint(canvas, Offset.zero);
          canvas.restore();
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

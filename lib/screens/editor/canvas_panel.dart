import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetx/core/constants/widget_types.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/device_frames.dart';
import '../../core/theme/colors.dart';
import '../../providers/canvas_provider.dart';
import '../../providers/widget_library_provider.dart';
import '../../models/widget_model.dart';
import '../../services/widget_hierarchy_service.dart';

/// Canvas panel for designing the UI
class CanvasPanel extends ConsumerStatefulWidget {
  const CanvasPanel({super.key});

  @override
  ConsumerState<CanvasPanel> createState() => _CanvasPanelState();
}

class _CanvasPanelState extends ConsumerState<CanvasPanel> {
  final TransformationController _transformationController =
      TransformationController();
  Offset? _selectionStart;
  Offset? _selectionEnd;
  final bool _isSelecting = false;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasProvider);
    final canvasNotifier = ref.read(canvasProvider.notifier);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.canvasBackground,
      child: Stack(
        children: [
          // Main canvas area
          Positioned.fill(
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: AppConstants.minZoom,
              maxScale: AppConstants.maxZoom,
              constrained: false,
              child: SizedBox(
                width: 2000,
                height: 2000,
                child: Stack(
                  children: [
                    // Grid background
                    if (canvasState.showGrid) _buildGrid(),

                    // Device frame
                    Positioned(
                      left: 500,
                      top: 200,
                      child: _DeviceFrameWidget(
                        deviceFrame: canvasState.deviceFrame,
                        child: _CanvasContent(),
                      ),
                    ),

                    // Selection rectangle
                    if (_isSelecting &&
                        _selectionStart != null &&
                        _selectionEnd != null)
                      _buildSelectionRectangle(),
                  ],
                ),
              ),
            ),
          ),

          // Canvas overlay controls
          Positioned(top: 16, right: 16, child: _CanvasControls()),

          // Drop zone indicator
          if (canvasState.draggedWidget != null)
            Positioned.fill(
              child: Container(
                color: AppColors.dropTarget,
                child: const Center(
                  child: Text(
                    'Drop widget here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return CustomPaint(
      size: const Size(2000, 2000),
      painter: _GridPainter(
        gridSize: AppConstants.gridSize,
        color: AppColors.gridColor,
      ),
    );
  }

  Widget _buildSelectionRectangle() {
    final start = _selectionStart!;
    final end = _selectionEnd!;
    final rect = Rect.fromPoints(start, end);

    return Positioned(
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: rect.height,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.selectionBlue, width: 2),
          color: AppColors.selectionBlue.withOpacity(0.1),
        ),
      ),
    );
  }
}

/// Device frame widget wrapper
class _DeviceFrameWidget extends StatelessWidget {
  const _DeviceFrameWidget({required this.deviceFrame, required this.child});

  final DeviceFrame deviceFrame;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceFrame.width,
      height: deviceFrame.height,
      decoration: BoxDecoration(
        color: AppColors.deviceFrameBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.deviceFrameBorder, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          children: [
            // Status bar
            if (deviceFrame.statusBarHeight > 0)
              Container(
                height: deviceFrame.statusBarHeight,
                color: Colors.black,
                child: const Center(
                  child: Text(
                    '9:41',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

            // Screen content
            Expanded(
              child: Container(color: AppColors.deviceScreen, child: child),
            ),

            // Bottom safe area
            if (deviceFrame.bottomSafeArea > 0)
              Container(
                height: deviceFrame.bottomSafeArea,
                color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }
}

/// Canvas content area where widgets are placed
class _CanvasContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canvasState = ref.watch(canvasProvider);
    final canvasNotifier = ref.read(canvasProvider.notifier);

    // Get the root widgets for the current screen
    final widgets = canvasState.currentScreen?.widgets ?? [];

    return DragTarget<WidgetDefinition>(
      onAcceptWithDetails: (details) {
        // Calculate drop position relative to device frame
        final RenderBox? box = context.findRenderObject() as RenderBox?;
        Offset dropPosition = const Offset(100, 100);
        if (box != null) {
          final localOffset = box.globalToLocal(details.offset);
          // Adjust for device frame position (500, 200) + some padding
          dropPosition = localOffset - const Offset(500, 200);
        }
        // Enforce Flutter UI construction rules
        final definition = details.data;
        final validation = WidgetHierarchyService.validateDrop(
          draggedType: definition.type,
          targetWidget: null, // root-level drop for now
          allWidgets: canvasState.currentScreen?.widgets ?? [],
        );
        if (!validation.isValid) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(validation.message)));
          return;
        }
        _addWidgetToCanvas(ref, definition, dropPosition);
      },
      onWillAcceptWithDetails: (details) {
        final definition = details.data;
        final validation = WidgetHierarchyService.validateDrop(
          draggedType: definition.type,
          targetWidget: null, // root-level drop for now
          allWidgets: canvasState.currentScreen?.widgets ?? [],
        );
        return validation.isValid;
      },
      builder: (context, candidateData, rejectedData) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Background
              Container(
                color:
                    canvasState.currentScreen?.backgroundColor ?? Colors.white,
              ),
              // Render the real widget tree
              if (widgets.isNotEmpty)
                ...widgets.map(
                  (widget) => _CanvasWidget(
                    key: ValueKey(
                      '${widget.id}_${widget.updatedAt?.millisecondsSinceEpoch ?? 0}',
                    ),
                    widget: widget,
                  ),
                ),
              // Empty state
              if (widgets.isEmpty)
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.widgets_outlined,
                        size: 64,
                        color: AppColors.iconDisabled,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Drag widgets from the library to start designing',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _addWidgetToCanvas(
    WidgetRef ref,
    WidgetDefinition definition,
    Offset position,
  ) {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    final libraryNotifier = ref.read(widgetLibraryProvider.notifier);

    final widget = libraryNotifier.createWidgetFromDefinition(
      definition,
      position,
    );
    canvasNotifier.addWidget(widget);
  }
}

/// Individual widget on the canvas
class _CanvasWidget extends ConsumerStatefulWidget {
  const _CanvasWidget({super.key, required this.widget});

  final WidgetModel widget;

  @override
  ConsumerState<_CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends ConsumerState<_CanvasWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasProvider);
    final canvasNotifier = ref.read(canvasProvider.notifier);
    final isSelected = canvasState.selectedWidgetIds.contains(widget.widget.id);

    return Positioned(
      left: widget.widget.position.dx,
      top: widget.widget.position.dy,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () {
            canvasNotifier.selectWidget(widget.widget.id);
          },
          onPanUpdate: (details) {
            final newPosition = widget.widget.position + details.delta;
            canvasNotifier.moveWidget(widget.widget.id, newPosition);
          },
          child: Container(
            width: widget.widget.size.width,
            height: widget.widget.size.height,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? AppColors.selectionBlue
                    : _isHovered
                    ? AppColors.primary.withOpacity(0.5)
                    : Colors.transparent,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                // Widget preview
                _buildWidgetPreview(),

                // Selection handles
                if (isSelected) ..._buildSelectionHandles(),

                // Widget label
                if (_isHovered || isSelected)
                  Positioned(
                    top: -24,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetPreview() {
    final model = widget.widget;

    switch (model.type) {
      case FlutterWidgetType.container:
        final width = (model.properties['width'] ?? model.size.width) as double;
        final height =
            (model.properties['height'] ?? model.size.height) as double;
        final color =
            _parseColor(model.properties['color']) ??
            Colors.blue.withOpacity(0.3);
        final borderRadius =
            (model.properties['borderRadius'] ?? 8.0) as double;
        final padding = (model.properties['padding'] ?? 16.0) as double;
        final margin = (model.properties['margin'] ?? 8.0) as double;

        return Container(
          width: width,
          height: height,
          margin: EdgeInsets.all(margin),
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: model.children.isNotEmpty
              ? Stack(
                  children: model.children
                      .map(
                        (child) => _CanvasWidget(
                          key: ValueKey(
                            '${child.id}_${child.updatedAt?.millisecondsSinceEpoch ?? 0}',
                          ),
                          widget: child,
                        ),
                      )
                      .toList(),
                )
              : Center(
                  child: Text(
                    'Container',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        );

      case FlutterWidgetType.text:
        final text = model.properties['text'] ?? 'Sample Text';
        final fontSize = (model.properties['fontSize'] ?? 16.0) as double;
        final color = _parseColor(model.properties['color']) ?? Colors.black;

        return Container(
          width: model.size.width,
          height: model.size.height,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: color,
              fontWeight: _parseFontWeight(model.properties['fontWeight']),
            ),
            textAlign: _parseTextAlign(model.properties['textAlign']),
          ),
        );

      case FlutterWidgetType.elevatedButton:
        final text = model.properties['text'] ?? 'Button';
        final backgroundColor =
            _parseColor(model.properties['backgroundColor']) ?? Colors.blue;
        final foregroundColor =
            _parseColor(model.properties['foregroundColor']) ?? Colors.white;

        return SizedBox(
          width: model.size.width,
          height: model.size.height,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(text),
          ),
        );

      case FlutterWidgetType.row:
        return Container(
          width: model.size.width,
          height: model.size.height,
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            border: Border.all(color: Colors.orange.withOpacity(0.5), width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: model.children.isNotEmpty
              ? Row(
                  mainAxisAlignment: _parseMainAxisAlignment(
                    model.properties['mainAxisAlignment'],
                  ),
                  crossAxisAlignment: _parseCrossAxisAlignment(
                    model.properties['crossAxisAlignment'],
                  ),
                  children: model.children
                      .map(
                        (child) => _CanvasWidget(
                          key: ValueKey(
                            '${child.id}_${child.updatedAt?.millisecondsSinceEpoch ?? 0}',
                          ),
                          widget: child,
                        ),
                      )
                      .toList(),
                )
              : const Center(
                  child: Text(
                    'Row\n(Drop widgets here)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        );

      case FlutterWidgetType.column:
        return Container(
          width: model.size.width,
          height: model.size.height,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            border: Border.all(color: Colors.green.withOpacity(0.5), width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: model.children.isNotEmpty
              ? Column(
                  mainAxisAlignment: _parseMainAxisAlignment(
                    model.properties['mainAxisAlignment'],
                  ),
                  crossAxisAlignment: _parseCrossAxisAlignment(
                    model.properties['crossAxisAlignment'],
                  ),
                  children: model.children
                      .map(
                        (child) => _CanvasWidget(
                          key: ValueKey(
                            '${child.id}_${child.updatedAt?.millisecondsSinceEpoch ?? 0}',
                          ),
                          widget: child,
                        ),
                      )
                      .toList(),
                )
              : const Center(
                  child: Text(
                    'Column\n(Drop widgets here)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        );

      default:
        return Container(
          width: model.size.width,
          height: model.size.height,
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            border: Border.all(color: Colors.purple.withOpacity(0.5), width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.widgets, color: Colors.purple, size: 24),
                const SizedBox(height: 4),
                Text(
                  model.type.displayName,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
    }
  }

  List<Widget> _buildSelectionHandles() {
    const handleSize = 8.0;
    const handleColor = AppColors.selectionBlue;

    return [
      // Top-left
      const Positioned(
        left: -handleSize / 2,
        top: -handleSize / 2,
        child: _SelectionHandle(size: handleSize, color: handleColor),
      ),
      // Top-right
      const Positioned(
        right: -handleSize / 2,
        top: -handleSize / 2,
        child: _SelectionHandle(size: handleSize, color: handleColor),
      ),
      // Bottom-left
      const Positioned(
        left: -handleSize / 2,
        bottom: -handleSize / 2,
        child: _SelectionHandle(size: handleSize, color: handleColor),
      ),
      // Bottom-right
      const Positioned(
        right: -handleSize / 2,
        bottom: -handleSize / 2,
        child: _SelectionHandle(size: handleSize, color: handleColor),
      ),
    ];
  }

  // Helper methods for parsing properties
  Color? _parseColor(dynamic value) {
    if (value == null) return null;

    if (value is Color) {
      return value;
    }

    if (value is int) {
      return Color(value);
    }

    if (value is String) {
      if (value.startsWith('#')) {
        final hex = value.substring(1);
        final colorValue = int.parse(hex, radix: 16);
        return Color(colorValue | 0xFF000000);
      } else if (value.startsWith('0x')) {
        final colorValue = int.parse(value, radix: 16);
        return Color(colorValue);
      }
    }

    return null;
  }

  FontWeight _parseFontWeight(dynamic value) {
    switch (value) {
      case 'bold':
        return FontWeight.bold;
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }

  TextAlign _parseTextAlign(dynamic value) {
    switch (value) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      case 'left':
        return TextAlign.left;
      case 'justify':
        return TextAlign.justify;
      case 'start':
        return TextAlign.start;
      case 'end':
        return TextAlign.end;
      default:
        return TextAlign.left;
    }
  }

  MainAxisAlignment _parseMainAxisAlignment(dynamic value) {
    switch (value) {
      case 'center':
        return MainAxisAlignment.center;
      case 'end':
        return MainAxisAlignment.end;
      case 'spaceBetween':
        return MainAxisAlignment.spaceBetween;
      case 'spaceAround':
        return MainAxisAlignment.spaceAround;
      case 'spaceEvenly':
        return MainAxisAlignment.spaceEvenly;
      case 'start':
      default:
        return MainAxisAlignment.start;
    }
  }

  CrossAxisAlignment _parseCrossAxisAlignment(dynamic value) {
    switch (value) {
      case 'center':
        return CrossAxisAlignment.center;
      case 'end':
        return CrossAxisAlignment.end;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      case 'baseline':
        return CrossAxisAlignment.baseline;
      case 'start':
      default:
        return CrossAxisAlignment.start;
    }
  }
}

/// Selection handle widget
class _SelectionHandle extends StatelessWidget {
  const _SelectionHandle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}

/// Canvas controls overlay
class _CanvasControls extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canvasState = ref.watch(canvasProvider);
    final canvasNotifier = ref.read(canvasProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Zoom controls
          IconButton(
            icon: const Icon(Icons.zoom_in, size: 18),
            onPressed: canvasNotifier.zoomIn,
            tooltip: 'Zoom In',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          Text(
            '${(canvasState.zoomLevel * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out, size: 18),
            onPressed: canvasNotifier.zoomOut,
            tooltip: 'Zoom Out',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),

          const Divider(height: 16),

          // Reset zoom
          IconButton(
            icon: const Icon(Icons.center_focus_strong, size: 18),
            onPressed: canvasNotifier.resetZoom,
            tooltip: 'Reset Zoom',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

/// Grid painter for canvas background
class _GridPainter extends CustomPainter {
  _GridPainter({required this.gridSize, required this.color});

  final double gridSize;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
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

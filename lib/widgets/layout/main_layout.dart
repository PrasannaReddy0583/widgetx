import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/colors.dart';
import '../../screens/editor/widget_library_panel.dart';
import '../../screens/editor/canvas_panel.dart';
import '../../screens/editor/properties_panel.dart';
import '../../screens/editor/code_editor_panel.dart';
import '../panels/widget_tree_panel.dart';
import '../../services/undo_redo_service.dart';

/// Main layout with three panels: Widget Library, Canvas, Properties
class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  bool _isCodeEditorVisible = false;
  final double _codeEditorHeight = AppConstants.codeEditorHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Main content area
          Expanded(
            child: Row(
              children: [
                // Left Panel - Widget Library
                Container(
                  width: AppConstants.leftPanelWidth,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      right: BorderSide(color: AppColors.borderLight),
                    ),
                  ),
                  child: const WidgetLibraryPanel(),
                ),

                // Widget Tree Panel (new)
                Container(
                  width: 220, // Adjust width as needed
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      right: BorderSide(color: AppColors.borderLight),
                    ),
                  ),
                  child: const WidgetTreePanel(),
                ),

                // Center Panel - Canvas and Code Editor
                Expanded(
                  child: Column(
                    children: [
                      // Canvas Area
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.canvasBackground,
                          ),
                          child: const CanvasPanel(),
                        ),
                      ),

                      // Code Editor (collapsible)
                      if (_isCodeEditorVisible)
                        Container(
                          height: _codeEditorHeight,
                          decoration: const BoxDecoration(
                            color: AppColors.codeBackground,
                            border: Border(
                              top: BorderSide(color: AppColors.borderLight),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Code editor header
                              Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColors.surface,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: AppColors.borderLight,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.code,
                                      size: 16,
                                      color: AppColors.iconSecondary,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Generated Code',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: AppColors.iconSecondary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isCodeEditorVisible = false;
                                        });
                                      },
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 24,
                                        minHeight: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Code editor content
                              Expanded(
                                child: CodeEditorPanel(
                                  onToggleVisibility: () {
                                    setState(() {
                                      _isCodeEditorVisible =
                                          !_isCodeEditorVisible;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Right Panel - Properties
                Container(
                  width: AppConstants.rightPanelWidth,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      left: BorderSide(color: AppColors.borderLight),
                    ),
                  ),
                  child: const PropertiesPanel(),
                ),
              ],
            ),
          ),
        ],
      ),

      // Floating action button to toggle code editor
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Undo button
          FloatingActionButton(
            heroTag: 'undo',
            onPressed: () {
              final didUndo = UndoRedoService().undo();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    didUndo ? 'Undo successful' : 'Nothing to undo',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
              setState(() {}); // Trigger UI update
            },
            backgroundColor: AppColors.primary,
            mini: true,
            child: const Icon(Icons.undo, color: Colors.white),
          ),
          const SizedBox(width: 12),
          // Redo button
          FloatingActionButton(
            heroTag: 'redo',
            onPressed: () {
              final didRedo = UndoRedoService().redo();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    didRedo ? 'Redo successful' : 'Nothing to redo',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
              setState(() {}); // Trigger UI update
            },
            backgroundColor: AppColors.primary,
            mini: true,
            child: const Icon(Icons.redo, color: Colors.white),
          ),
          const SizedBox(width: 12),
          // Existing code editor toggle button
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _isCodeEditorVisible = !_isCodeEditorVisible;
              });
            },
            backgroundColor: AppColors.primary,
            child: Icon(
              _isCodeEditorVisible ? Icons.code_off : Icons.code,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

/// Resizable panel widget
class ResizablePanel extends StatefulWidget {
  const ResizablePanel({
    super.key,
    required this.child,
    required this.initialHeight,
    this.minHeight = 100,
    this.maxHeight = 600,
    this.onHeightChanged,
  });

  final Widget child;
  final double initialHeight;
  final double minHeight;
  final double maxHeight;
  final ValueChanged<double>? onHeightChanged;

  @override
  State<ResizablePanel> createState() => _ResizablePanelState();
}

class _ResizablePanelState extends State<ResizablePanel> {
  late double _height;
  bool _isResizing = false;

  @override
  void initState() {
    super.initState();
    _height = widget.initialHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Resize handle
        GestureDetector(
          onPanStart: (details) {
            _isResizing = true;
          },
          onPanUpdate: (details) {
            if (_isResizing) {
              setState(() {
                _height = (_height - details.delta.dy).clamp(
                  widget.minHeight,
                  widget.maxHeight,
                );
              });
              widget.onHeightChanged?.call(_height);
            }
          },
          onPanEnd: (details) {
            _isResizing = false;
          },
          child: Container(
            height: 4,
            width: double.infinity,
            color: AppColors.borderMedium,
            child: Center(
              child: Container(
                height: 2,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.borderDark,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        ),

        // Panel content
        SizedBox(height: _height, child: widget.child),
      ],
    );
  }
}

/// Panel divider widget
class PanelDivider extends StatelessWidget {
  const PanelDivider({super.key, this.isVertical = true});

  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isVertical ? 1 : double.infinity,
      height: isVertical ? double.infinity : 1,
      color: AppColors.borderLight,
    );
  }
}

/// Collapsible panel widget
class CollapsiblePanel extends StatefulWidget {
  const CollapsiblePanel({
    super.key,
    required this.title,
    required this.child,
    this.isExpanded = true,
    this.icon,
  });

  final String title;
  final Widget child;
  final bool isExpanded;
  final IconData? icon;

  @override
  State<CollapsiblePanel> createState() => _CollapsiblePanelState();
}

class _CollapsiblePanelState extends State<CollapsiblePanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        InkWell(
          onTap: _toggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.propertySection,
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 16, color: AppColors.iconSecondary),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: AppConstants.animationDuration,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: AppColors.iconSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content
        SizeTransition(sizeFactor: _expandAnimation, child: widget.child),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/widget_model.dart';
import '../../models/screen_model.dart';
import '../../providers/canvas_provider.dart';
import '../../services/widget_hierarchy_service.dart';
import '../../core/theme/colors.dart';
import '../../core/constants/app_constants.dart';

/// Widget tree panel showing hierarchical structure
class WidgetTreePanel extends ConsumerStatefulWidget {
  const WidgetTreePanel({super.key});

  @override
  ConsumerState<WidgetTreePanel> createState() => _WidgetTreePanelState();
}

class _WidgetTreePanelState extends ConsumerState<WidgetTreePanel> {
  final Set<String> _expandedNodes = <String>{};
  String? _draggedWidgetId;
  String? _dropTargetId;

  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasProvider);
    final currentScreen = canvasState.currentScreen;

    if (currentScreen == null) {
      return const Center(
        child: Text(
          'No screen selected',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_tree,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Widget Tree',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _expandAll,
                  icon: const Icon(Icons.unfold_more, size: 16),
                  tooltip: 'Expand All',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
                IconButton(
                  onPressed: _collapseAll,
                  icon: const Icon(Icons.unfold_less, size: 16),
                  tooltip: 'Collapse All',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                ),
              ],
            ),
          ),

          // Tree content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              children: [
                _buildScreenNode(currentScreen),
                ...currentScreen.widgets.map(
                  (widget) => _buildWidgetNode(widget, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenNode(ScreenModel screen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.phone_android, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              screen.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '${screen.widgets.length} widgets',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetNode(WidgetModel widget, int depth) {
    final isExpanded = _expandedNodes.contains(widget.id);
    final isSelected = ref
        .watch(canvasProvider)
        .selectedWidgetIds
        .contains(widget.id);
    final hasChildren = widget.children.isNotEmpty;
    final canHaveChildren = WidgetHierarchyService.canHaveChildren(widget.type);
    final isDropTarget = _dropTargetId == widget.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DragTarget<String>(
          onWillAcceptWithDetails: (details) {
            final draggedId = details.data;
            if (draggedId == widget.id) return false;

            // Find dragged widget
            final draggedWidget = _findWidgetById(draggedId);
            if (draggedWidget == null) return false;

            // Validate drop
            final validation = WidgetHierarchyService.validateDrop(
              draggedType: draggedWidget.type,
              targetWidget: widget,
              allWidgets: ref.read(canvasProvider).currentScreen?.widgets ?? [],
            );

            setState(() {
              _dropTargetId = validation.isValid ? widget.id : null;
            });

            return validation.isValid;
          },
          onAcceptWithDetails: (details) {
            final draggedId = details.data;
            _handleWidgetDrop(draggedId, widget.id);
            setState(() {
              _dropTargetId = null;
            });
          },
          onLeave: (_) {
            setState(() {
              _dropTargetId = null;
            });
          },
          builder: (context, candidateData, rejectedData) {
            return Draggable<String>(
              data: widget.id,
              onDragStarted: () {
                setState(() {
                  _draggedWidgetId = widget.id;
                });
              },
              onDragEnd: (_) {
                setState(() {
                  _draggedWidgetId = null;
                  _dropTargetId = null;
                });
              },
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        WidgetHierarchyService.getWidgetIcon(widget.type),
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(left: depth * 16.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : isDropTarget
                      ? AppColors.success.withOpacity(0.1)
                      : null,
                  borderRadius: BorderRadius.circular(4),
                  border: isDropTarget
                      ? Border.all(color: AppColors.success, width: 2)
                      : isSelected
                      ? Border.all(color: AppColors.primary, width: 1)
                      : null,
                ),
                child: InkWell(
                  onTap: () => _selectWidget(widget.id),
                  onSecondaryTap: () => _showContextMenu(context, widget),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        // Expand/collapse button
                        SizedBox(
                          width: 16,
                          child: hasChildren
                              ? InkWell(
                                  onTap: () => _toggleExpansion(widget.id),
                                  child: Icon(
                                    isExpanded
                                        ? Icons.expand_more
                                        : Icons.chevron_right,
                                    size: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                )
                              : canHaveChildren
                              ? Icon(
                                  Icons.add,
                                  size: 12,
                                  color: AppColors.textSecondary.withOpacity(
                                    0.5,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 4),

                        // Widget icon
                        Icon(
                          WidgetHierarchyService.getWidgetIcon(widget.type),
                          size: 14,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),

                        // Widget name
                        Expanded(
                          child: Text(
                            widget.name,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // Widget type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textSecondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            widget.type.displayName,
                            style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),

                        // Visibility toggle
                        IconButton(
                          onPressed: () => _toggleVisibility(widget.id),
                          icon: Icon(
                            widget.isVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 12,
                            color: AppColors.textSecondary,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // Children
        if (hasChildren && isExpanded)
          ...widget.children.map((child) => _buildWidgetNode(child, depth + 1)),
      ],
    );
  }

  void _expandAll() {
    setState(() {
      final currentScreen = ref.read(canvasProvider).currentScreen;
      if (currentScreen != null) {
        _expandedNodes.addAll(_getAllWidgetIds(currentScreen.widgets));
      }
    });
  }

  void _collapseAll() {
    setState(() {
      _expandedNodes.clear();
    });
  }

  void _toggleExpansion(String widgetId) {
    setState(() {
      if (_expandedNodes.contains(widgetId)) {
        _expandedNodes.remove(widgetId);
      } else {
        _expandedNodes.add(widgetId);
      }
    });
  }

  void _selectWidget(String widgetId) {
    ref.read(canvasProvider.notifier).selectWidget(widgetId);
  }

  void _toggleVisibility(String widgetId) {
    final currentScreen = ref.read(canvasProvider).currentScreen;
    if (currentScreen == null) return;

    final widget = _findWidgetById(widgetId);
    if (widget == null) return;

    final updatedWidget = widget.copyWith(isVisible: !widget.isVisible);
    ref.read(canvasProvider.notifier).updateWidget(updatedWidget);
  }

  void _showContextMenu(BuildContext context, WidgetModel widget) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + renderBox.size.width,
        position.dy + renderBox.size.height,
      ),
      items: [
        PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              const Icon(Icons.copy, size: 16),
              const SizedBox(width: 8),
              const Text('Duplicate'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete, size: 16, color: AppColors.error),
              const SizedBox(width: 8),
              const Text('Delete', style: TextStyle(color: AppColors.error)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'rename',
          child: Row(
            children: [
              const Icon(Icons.edit, size: 16),
              const SizedBox(width: 8),
              const Text('Rename'),
            ],
          ),
        ),
      ],
    ).then((value) {
      switch (value) {
        case 'duplicate':
          _duplicateWidget(widget);
          break;
        case 'delete':
          _deleteWidget(widget.id);
          break;
        case 'rename':
          _renameWidget(widget);
          break;
      }
    });
  }

  void _duplicateWidget(WidgetModel widget) {
    final duplicated = widget.duplicate(offset: const Offset(20, 20));
    ref.read(canvasProvider.notifier).addWidget(duplicated);
  }

  void _deleteWidget(String widgetId) {
    ref.read(canvasProvider.notifier).removeWidget(widgetId);
  }

  void _renameWidget(WidgetModel widget) {
    showDialog(
      context: context,
      builder: (context) => _RenameWidgetDialog(
        widget: widget,
        onRenamed: (newName) {
          final updatedWidget = widget.copyWith(name: newName);
          ref.read(canvasProvider.notifier).updateWidget(updatedWidget);
        },
      ),
    );
  }

  void _handleWidgetDrop(String draggedId, String targetId) {
    // Handle widget reordering in the hierarchy
    ref.read(canvasProvider.notifier).moveWidgetToParent(draggedId, targetId);
  }

  WidgetModel? _findWidgetById(String id) {
    final currentScreen = ref.read(canvasProvider).currentScreen;
    if (currentScreen == null) return null;

    return _findWidgetInList(currentScreen.widgets, id);
  }

  WidgetModel? _findWidgetInList(List<WidgetModel> widgets, String id) {
    for (final widget in widgets) {
      if (widget.id == id) return widget;
      final found = _findWidgetInList(widget.children, id);
      if (found != null) return found;
    }
    return null;
  }

  Set<String> _getAllWidgetIds(List<WidgetModel> widgets) {
    final ids = <String>{};
    for (final widget in widgets) {
      ids.add(widget.id);
      ids.addAll(_getAllWidgetIds(widget.children));
    }
    return ids;
  }
}

/// Dialog for renaming widgets
class _RenameWidgetDialog extends StatefulWidget {
  const _RenameWidgetDialog({required this.widget, required this.onRenamed});

  final WidgetModel widget;
  final ValueChanged<String> onRenamed;

  @override
  State<_RenameWidgetDialog> createState() => _RenameWidgetDialogState();
}

class _RenameWidgetDialogState extends State<_RenameWidgetDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.widget.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename Widget'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Widget Name',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Rename')),
      ],
    );
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      widget.onRenamed(name);
      Navigator.of(context).pop();
    }
  }
}

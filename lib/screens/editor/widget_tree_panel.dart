import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/widget_model.dart';
import '../../providers/canvas_provider.dart';
import '../../providers/properties_provider.dart';
import '../../core/constants/widget_types.dart';

/// Enhanced widget tree panel for hierarchical widget management
class WidgetTreePanel extends ConsumerStatefulWidget {
  const WidgetTreePanel({super.key});

  @override
  ConsumerState<WidgetTreePanel> createState() => _WidgetTreePanelState();
}

class _WidgetTreePanelState extends ConsumerState<WidgetTreePanel> {
  final Set<String> _expandedNodes = <String>{};
  String? _hoveredWidgetId;

  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasProvider);
    final widgets = canvasState.currentScreen?.widgets ?? [];
    final selectedWidgetIds = canvasState.selectedWidgetIds;
    
    // Build widget hierarchy
    final rootWidgets = _buildWidgetHierarchy(widgets);

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          left: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildToolbar(),
          Expanded(
            child: rootWidgets.isEmpty
                ? _buildEmptyState()
                : _buildWidgetTree(rootWidgets, selectedWidgetIds.toSet()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.account_tree, color: Colors.green[600], size: 24),
          const SizedBox(width: 8),
          Text(
            'Widget Tree',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.expand_more, size: 20),
            onPressed: _expandAll,
            tooltip: 'Expand All',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          IconButton(
            icon: const Icon(Icons.expand_less, size: 20),
            onPressed: _collapseAll,
            tooltip: 'Collapse All',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: _deleteSelected,
            tooltip: 'Delete Selected',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_tree, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No widgets on canvas',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Drag widgets from the library to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetTree(List<WidgetModel> widgets, Set<String> selectedIds) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: widgets.length,
      itemBuilder: (context, index) {
        return _buildWidgetNode(widgets[index], selectedIds, 0);
      },
    );
  }

  Widget _buildWidgetNode(WidgetModel widget, Set<String> selectedIds, int depth) {
    final isSelected = selectedIds.contains(widget.id);
    final isExpanded = _expandedNodes.contains(widget.id);
    final hasChildren = widget.children.isNotEmpty;
    final isHovered = _hoveredWidgetId == widget.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _hoveredWidgetId = widget.id),
          onExit: (_) => setState(() => _hoveredWidgetId = null),
          child: GestureDetector(
            onTap: () => _selectWidget(widget.id),
            onSecondaryTap: () => _showContextMenu(widget),
            child: Container(
              margin: EdgeInsets.only(left: depth * 16.0),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue.withValues(alpha: 0.1)
                    : isHovered
                        ? Colors.grey.withValues(alpha: 0.1)
                        : null,
                borderRadius: BorderRadius.circular(6),
                border: isSelected
                    ? Border.all(color: Colors.blue, width: 1)
                    : null,
              ),
              child: Row(
                children: [
                  // Expand/collapse button
                  SizedBox(
                    width: 20,
                    child: hasChildren
                        ? IconButton(
                            icon: Icon(
                              isExpanded ? Icons.expand_more : Icons.chevron_right,
                              size: 16,
                            ),
                            onPressed: () => _toggleExpanded(widget.id),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                          )
                        : null,
                  ),
                  const SizedBox(width: 4),
                  // Widget icon
                  Icon(
                    _getWidgetIcon(widget.type),
                    size: 16,
                    color: _getWidgetColor(widget.type),
                  ),
                  const SizedBox(width: 8),
                  // Widget name
                  Expanded(
                    child: Text(
                      _getWidgetDisplayName(widget),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue[700] : Colors.grey[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Visibility toggle
                  IconButton(
                    icon: Icon(
                      widget.isVisible ? Icons.visibility : Icons.visibility_off,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    onPressed: () => _toggleVisibility(widget),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Children
        if (hasChildren && isExpanded)
          ...widget.children.map((child) => _buildWidgetNode(child, selectedIds, depth + 1)),
      ],
    );
  }

  List<WidgetModel> _buildWidgetHierarchy(List<WidgetModel> allWidgets) {
    // Create a map for quick lookup
    final widgetMap = <String, WidgetModel>{};
    for (final widget in allWidgets) {
      widgetMap[widget.id] = widget;
    }

    // Build hierarchy
    final rootWidgets = <WidgetModel>[];
    for (final widget in allWidgets) {
      if (widget.parentId == null) {
        rootWidgets.add(_buildWidgetWithChildren(widget, widgetMap));
      }
    }

    return rootWidgets;
  }

  WidgetModel _buildWidgetWithChildren(WidgetModel widget, Map<String, WidgetModel> widgetMap) {
    final children = <WidgetModel>[];
    // For now, return the widget as-is since we're using the children property directly
    // If we need to build from childIds, we would iterate through them here
    return widget.copyWith(children: children);
  }

  String _getWidgetDisplayName(WidgetModel widget) {
    String baseName = widget.type.displayName;
    
    // Add specific properties for better identification
    switch (widget.type) {
      case FlutterWidgetType.text:
        final text = widget.properties['text'] as String?;
        if (text != null && text.isNotEmpty) {
          baseName += ' "${text.length > 20 ? '${text.substring(0, 20)}...' : text}"';
        }
        break;
      case FlutterWidgetType.elevatedButton:
        final text = widget.properties['text'] as String?;
        if (text != null && text.isNotEmpty) {
          baseName += ' "$text"';
        }
        break;
      case FlutterWidgetType.row:
      case FlutterWidgetType.column:
        final childCount = widget.children.length;
        baseName += ' ($childCount children)';
        break;
      case FlutterWidgetType.stack:
        final childCount = widget.children.length;
        baseName += ' ($childCount children)';
        break;
      case FlutterWidgetType.container:
        final width = widget.properties['width'] as double?;
        final height = widget.properties['height'] as double?;
        if (width != null && height != null) {
          baseName += ' (${width.toInt()}×${height.toInt()})';
        }
        break;
      default:
        // For other widget types, just use the display name
        break;
    }
    
    return baseName;
  }

  void _selectWidget(String widgetId) {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    final propertiesNotifier = ref.read(propertiesProvider.notifier);
    
    canvasNotifier.selectWidget(widgetId);
    // Find widget and select it
    final canvasState = ref.read(canvasProvider);
    if (canvasState.currentScreen != null) {
      final widget = canvasState.currentScreen!.widgets
          .where((w) => w.id == widgetId)
          .firstOrNull;
      if (widget != null) {
        propertiesNotifier.setSelectedWidget(widget);
      }
    }
  }

  void _toggleExpanded(String widgetId) {
    setState(() {
      if (_expandedNodes.contains(widgetId)) {
        _expandedNodes.remove(widgetId);
      } else {
        _expandedNodes.add(widgetId);
      }
    });
  }

  void _expandAll() {
    final canvasState = ref.read(canvasProvider);
    setState(() {
      _expandedNodes.addAll((canvasState.currentScreen?.widgets ?? []).map((w) => w.id));
    });
  }

  void _collapseAll() {
    setState(() {
      _expandedNodes.clear();
    });
  }

  void _deleteSelected() {
    final canvasState = ref.read(canvasProvider);
    final canvasNotifier = ref.read(canvasProvider.notifier);
    
    for (final widgetId in canvasState.selectedWidgetIds) {
      canvasNotifier.removeWidget(widgetId);
    }
  }

  void _toggleVisibility(WidgetModel widget) {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    final updatedWidget = widget.copyWith(isVisible: !widget.isVisible);
    canvasNotifier.updateWidget(updatedWidget);
  }

  void _showContextMenu(WidgetModel widget) {
    // TODO: Implement context menu with options like:
    // - Duplicate
    // - Delete
    // - Move up/down
    // - Copy/Paste
    // - Rename
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

  Color _getWidgetColor(FlutterWidgetType type) {
    switch (type) {
      case FlutterWidgetType.container:
        return Colors.blue;
      case FlutterWidgetType.text:
        return Colors.green;
      case FlutterWidgetType.elevatedButton:
        return Colors.orange;
      case FlutterWidgetType.row:
      case FlutterWidgetType.column:
      case FlutterWidgetType.stack:
        return Colors.purple;
      case FlutterWidgetType.image:
        return Colors.teal;
      case FlutterWidgetType.icon:
        return Colors.amber;
      case FlutterWidgetType.listView:
        return Colors.indigo;
      default:
        return Colors.blue;
    }
  }
}

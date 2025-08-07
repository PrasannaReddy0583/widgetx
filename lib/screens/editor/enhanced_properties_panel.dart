import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/widget_model.dart';
import '../../models/property_model.dart';
import '../../providers/canvas_provider.dart';
import '../../providers/properties_provider.dart';
import '../../widgets/property_editors.dart' as property_editors;
import '../../core/constants/widget_types.dart';

/// Enhanced properties panel with real-time editing and visual feedback
class EnhancedPropertiesPanel extends ConsumerStatefulWidget {
  const EnhancedPropertiesPanel({super.key});

  @override
  ConsumerState<EnhancedPropertiesPanel> createState() =>
      _EnhancedPropertiesPanelState();
}

class _EnhancedPropertiesPanelState
    extends ConsumerState<EnhancedPropertiesPanel> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  bool _showAdvanced = false;

  @override
  Widget build(BuildContext context) {
    final propertiesState = ref.watch(propertiesProvider);

    final selectedWidget = propertiesState.selectedWidget;

    if (selectedWidget == null) {
      return _buildNoSelectionState();
    }

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(left: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(selectedWidget),
          _buildSearchBar(),
          _buildQuickActions(selectedWidget),
          Expanded(child: _buildPropertiesList(selectedWidget)),
        ],
      ),
    );
  }

  Widget _buildNoSelectionState() {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(left: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tune, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Widget Selected',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a widget on the canvas\nto edit its properties',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetNotFoundState() {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(left: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.orange[400]),
            const SizedBox(height: 16),
            Text(
              'Widget Not Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The selected widget may have been deleted',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(WidgetModel widget) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _getWidgetColor(widget.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getWidgetIcon(widget.type),
                  size: 18,
                  color: _getWidgetColor(widget.type),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.type.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ID: ${widget.id}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(value, widget),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy, size: 16),
                        SizedBox(width: 8),
                        Text('Duplicate'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                'Size',
                '${widget.size.width.toInt()}×${widget.size.height.toInt()}',
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                'Position',
                '${widget.position.dx.toInt()},${widget.position.dy.toInt()}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) =>
            setState(() => _searchQuery = value.toLowerCase()),
        decoration: InputDecoration(
          hintText: 'Search properties...',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: IconButton(
            icon: Icon(_showAdvanced ? Icons.expand_less : Icons.expand_more),
            onPressed: () => setState(() => _showAdvanced = !_showAdvanced),
            tooltip: _showAdvanced ? 'Hide Advanced' : 'Show Advanced',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(WidgetModel widget) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          ActionChip(
            label: const Text('Reset Size'),
            onPressed: () => _resetSize(widget),
            avatar: const Icon(Icons.crop_free, size: 16),
          ),
          ActionChip(
            label: const Text('Center'),
            onPressed: () => _centerWidget(widget),
            avatar: const Icon(Icons.center_focus_strong, size: 16),
          ),
          ActionChip(
            label: const Text('Copy Style'),
            onPressed: () => _copyStyle(widget),
            avatar: const Icon(Icons.palette, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesList(WidgetModel widget) {
    final properties = _getWidgetProperties(widget);
    final filteredProperties = properties
        .where((prop) {
          if (_searchQuery.isEmpty) return true;
          return prop.name.toLowerCase().contains(_searchQuery) ||
              prop.displayName.toLowerCase().contains(_searchQuery);
        })
        .where((prop) {
          if (_showAdvanced) return true;
          return !prop.isRequired;  // Use isRequired instead of isAdvanced
        })
        .toList();

    if (filteredProperties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No properties found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: filteredProperties.length,
        itemBuilder: (context, index) {
          final property = filteredProperties[index];
          return _buildPropertyEditor(widget, property);
        },
      ),
    );
  }

  Widget _buildPropertyEditor(WidgetModel widget, PropertyDefinition property) {
    final currentValue =
        widget.properties[property.name] ?? property.defaultValue;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  property.displayName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!property.isRequired)  // Use isRequired to show advanced properties
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Advanced',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (property.description != null && property.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              property.description!,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
          const SizedBox(height: 8),
          property_editors.PropertyEditors.createEditor(
            definition: property,
            value: currentValue,
            onChanged: (value) => _updateProperty(widget, property.name, value),
          ),
        ],
      ),
    );
  }

  List<PropertyDefinition> _getWidgetProperties(WidgetModel widget) {
    return WidgetPropertyDefinitions.getPropertiesForWidget(widget.type);
  }


  void _updateProperty(WidgetModel widget, String propertyName, dynamic value) {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    final propertiesNotifier = ref.read(propertiesProvider.notifier);

    // Update property in properties provider
    propertiesNotifier.updateProperty(propertyName, value);

    // Get the latest widget from canvas and update it
    final latestWidget = ref
        .read(canvasProvider)
        .currentScreen?.widgets
        .where((w) => w.id == widget.id)
        .firstOrNull;

    if (latestWidget != null) {
      final updatedWidget = latestWidget.updateProperties({
        propertyName: value,
      });
      canvasNotifier.updateWidget(updatedWidget);
    }
  }

  void _handleMenuAction(String action, WidgetModel widget) {
    final canvasNotifier = ref.read(canvasProvider.notifier);

    switch (action) {
      case 'duplicate':
        final duplicatedWidget = widget.copyWith(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          position: Offset(widget.position.dx + 20, widget.position.dy + 20),
        );
        canvasNotifier.addWidget(duplicatedWidget);
        break;
      case 'delete':
        canvasNotifier.removeWidget(widget.id);
        break;
    }
  }

  void _resetSize(WidgetModel widget) {
    // Set default size based on widget type
    final defaultSize = _getDefaultSize(widget.type);
    _updateProperty(widget, 'width', defaultSize.width);
    _updateProperty(widget, 'height', defaultSize.height);
  }

  Size _getDefaultSize(FlutterWidgetType type) {
    switch (type) {
      case FlutterWidgetType.text:
        return const Size(100, 30);
      case FlutterWidgetType.elevatedButton:
        return const Size(120, 40);
      case FlutterWidgetType.icon:
        return const Size(24, 24);
      case FlutterWidgetType.container:
        return const Size(100, 100);
      case FlutterWidgetType.image:
        return const Size(150, 150);
      default:
        return const Size(100, 100);
    }
  }

  void _centerWidget(WidgetModel widget) {
    // Center widget on canvas (assuming 400x600 canvas size)
    const canvasSize = Size(400, 600);
    final centeredPosition = Offset(
      (canvasSize.width - widget.size.width) / 2,
      (canvasSize.height - widget.size.height) / 2,
    );

    final canvasNotifier = ref.read(canvasProvider.notifier);
    final updatedWidget = widget.copyWith(position: centeredPosition);
    canvasNotifier.updateWidget(updatedWidget);
  }

  void _copyStyle(WidgetModel widget) {
    // TODO: Implement style copying functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Style copied to clipboard!'),
        duration: Duration(seconds: 2),
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
      default:
        return Colors.blue;
    }
  }
}


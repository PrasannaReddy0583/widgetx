import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/widget_model.dart';
import '../../providers/widget_library_provider.dart';
import '../../widgets/drag_drop_system.dart';
import '../../core/constants/widget_types.dart';

/// Enhanced widget library panel with categories and search
class EnhancedWidgetLibrary extends ConsumerStatefulWidget {
  const EnhancedWidgetLibrary({super.key});

  @override
  ConsumerState<EnhancedWidgetLibrary> createState() =>
      _EnhancedWidgetLibraryState();
}

class _EnhancedWidgetLibraryState extends ConsumerState<EnhancedWidgetLibrary> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Layout',
    'Input',
    'Display',
    'Navigation',
    'Media',
  ];

  @override
  Widget build(BuildContext context) {
    final widgetLibraryState = ref.watch(widgetLibraryProvider);
    final widgetLibraryNotifier = ref.read(widgetLibraryProvider.notifier);
    final widgets = widgetLibraryNotifier.filteredWidgets;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(right: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildCategoryTabs(),
          Expanded(child: _buildWidgetGrid(widgets)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          Icon(Icons.widgets, color: Colors.blue[600], size: 24),
          const SizedBox(width: 8),
          Text(
            'Widget Library',
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) =>
            setState(() => _searchQuery = value.toLowerCase()),
        decoration: InputDecoration(
          hintText: 'Search widgets...',
          prefixIcon: const Icon(Icons.search, size: 20),
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

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue[100],
              checkmarkColor: Colors.blue[700],
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue[700] : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWidgetGrid(List<WidgetDefinition> widgets) {
    final filteredWidgets = widgets.where((widget) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          widget.name.toLowerCase().contains(_searchQuery) ||
          widget.description.toLowerCase().contains(_searchQuery);

      final matchesCategory =
          _selectedCategory == 'All' || widget.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    if (filteredWidgets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No widgets found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or category filter',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredWidgets.length,
      itemBuilder: (context, index) {
        final widgetDef = filteredWidgets[index];
        return _buildWidgetCard(widgetDef);
      },
    );
  }

  Widget _buildWidgetCard(WidgetDefinition widgetDef) {
    final widgetLibraryNotifier = ref.read(widgetLibraryProvider.notifier);
    final newWidget = widgetLibraryNotifier.createWidgetFromDefinition(
      widgetDef,
      Offset.zero,
    );

    return DraggableWidgetItem(
      widget: newWidget,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _onWidgetTap(newWidget),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getWidgetColor(widgetDef.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getWidgetIcon(widgetDef.type),
                    size: 24,
                    color: _getWidgetColor(widgetDef.type),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widgetDef.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widgetDef.description,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onWidgetTap(WidgetModel widget) {
    // Show tooltip or quick info about the widget
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Drag ${widget.type.displayName} to canvas to add it'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
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
      case FlutterWidgetType.textField:
        return Icons.text_fields;
      case FlutterWidgetType.checkbox:
        return Icons.check_box;
      case FlutterWidgetType.radio:
        return Icons.radio_button_checked;
      case FlutterWidgetType.switchWidget:
        return Icons.toggle_on;
      case FlutterWidgetType.slider:
        return Icons.linear_scale;
      case FlutterWidgetType.appBar:
        return Icons.web_asset;
      case FlutterWidgetType.scaffold:
        return Icons.web;
      case FlutterWidgetType.card:
        return Icons.credit_card;
      case FlutterWidgetType.divider:
        return Icons.horizontal_rule;
      case FlutterWidgetType.spacer:
        return Icons.space_bar;
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
      case FlutterWidgetType.textField:
      case FlutterWidgetType.checkbox:
      case FlutterWidgetType.radio:
      case FlutterWidgetType.switchWidget:
      case FlutterWidgetType.slider:
        return Colors.cyan;
      case FlutterWidgetType.appBar:
      case FlutterWidgetType.scaffold:
        return Colors.deepPurple;
      case FlutterWidgetType.card:
        return Colors.brown;
      case FlutterWidgetType.divider:
      case FlutterWidgetType.spacer:
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
}

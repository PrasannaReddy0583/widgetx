import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/widget_types.dart';
import '../../core/theme/colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/canvas_provider.dart';
import '../../models/widget_model.dart';
import '../../services/widget_hierarchy_service.dart';

/// Enhanced widget library panel with 25+ widgets
class EnhancedWidgetLibraryPanel extends ConsumerStatefulWidget {
  const EnhancedWidgetLibraryPanel({super.key});

  @override
  ConsumerState<EnhancedWidgetLibraryPanel> createState() =>
      _EnhancedWidgetLibraryPanelState();
}

class _EnhancedWidgetLibraryPanelState
    extends ConsumerState<EnhancedWidgetLibraryPanel> {
  String _searchQuery = '';
  WidgetCategory? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  // Comprehensive widget library with 25+ widgets
  static final Map<WidgetCategory, List<FlutterWidgetType>> _widgetLibrary = {
    WidgetCategory.layout: [
      FlutterWidgetType.container,
      FlutterWidgetType.row,
      FlutterWidgetType.column,
      FlutterWidgetType.stack,
      FlutterWidgetType.wrap,
      FlutterWidgetType.expanded,
      FlutterWidgetType.flexible,
      FlutterWidgetType.positioned,
      FlutterWidgetType.align,
      FlutterWidgetType.center,
      FlutterWidgetType.padding,
      FlutterWidgetType.sizedBox,
      FlutterWidgetType.spacer,
      FlutterWidgetType.divider,
      FlutterWidgetType.verticalDivider,
    ],
    WidgetCategory.input: [
      FlutterWidgetType.textField,
      FlutterWidgetType.elevatedButton,
      FlutterWidgetType.textButton,
      FlutterWidgetType.outlinedButton,
      FlutterWidgetType.iconButton,
      FlutterWidgetType.floatingActionButton,
      FlutterWidgetType.checkbox,
      FlutterWidgetType.radio,
      FlutterWidgetType.switchWidget,
      FlutterWidgetType.slider,
      FlutterWidgetType.dropdownButton,
    ],
    WidgetCategory.display: [
      FlutterWidgetType.text,
      FlutterWidgetType.richText,
      FlutterWidgetType.image,
      FlutterWidgetType.icon,
      FlutterWidgetType.card,
      FlutterWidgetType.chip,
      FlutterWidgetType.circularProgressIndicator,
      FlutterWidgetType.linearProgressIndicator,
      FlutterWidgetType.tooltip,
    ],
    WidgetCategory.navigation: [
      FlutterWidgetType.scaffold,
      FlutterWidgetType.appBar,
      FlutterWidgetType.bottomNavigationBar,
      FlutterWidgetType.tabBar,
      FlutterWidgetType.tabBarView,
      FlutterWidgetType.drawer,
      FlutterWidgetType.bottomSheet,
    ],
    WidgetCategory.scrolling: [
      FlutterWidgetType.listView,
      FlutterWidgetType.gridView,
      FlutterWidgetType.singleChildScrollView,
      FlutterWidgetType.pageView,
      FlutterWidgetType.customScrollView,
    ],
    WidgetCategory.advanced: [
      FlutterWidgetType.gestureDetector,
      FlutterWidgetType.inkWell,
      FlutterWidgetType.hero,
      FlutterWidgetType.animatedContainer,
      FlutterWidgetType.fadeTransition,
    ],
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildCategoryTabs(),
          Expanded(child: _buildWidgetGrid()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          Icon(Icons.widgets, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          const Text(
            'Widget Library',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_getTotalWidgetCount()} widgets',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search widgets...',
          prefixIcon: const Icon(Icons.search, size: 16),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.clear, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          isDense: true,
        ),
        style: const TextStyle(fontSize: 12),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: WidgetCategory.values.length + 1, // +1 for "All" tab
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildCategoryTab(null, 'All', Icons.all_inclusive);
          }

          final category = WidgetCategory.values[index - 1];
          return _buildCategoryTab(
            category,
            category.displayName,
            category.icon,
          );
        },
      ),
    );
  }

  Widget _buildCategoryTab(
    WidgetCategory? category,
    String label,
    IconData icon,
  ) {
    final isSelected = _selectedCategory == category;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCategory = category;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.borderLight,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetGrid() {
    final filteredWidgets = _getFilteredWidgets();

    if (filteredWidgets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 48,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No widgets found',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or category filter',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: filteredWidgets.length,
      itemBuilder: (context, index) {
        final widget = filteredWidgets[index];
        return _buildWidgetCard(widget);
      },
    );
  }

  Widget _buildWidgetCard(FlutterWidgetType widgetType) {
    final canvasState = ref.watch(canvasProvider);
    final draggedWidget = canvasState.draggedWidget;
    final isDragging = draggedWidget?.type == widgetType;

    return Draggable<FlutterWidgetType>(
      data: widgetType,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                WidgetHierarchyService.getWidgetIcon(widgetType),
                size: 24,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Text(
                widgetType.displayName,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderLight,
            style: BorderStyle.solid,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.drag_indicator,
            color: AppColors.textSecondary,
            size: 24,
          ),
        ),
      ),
      onDragStarted: () {
        final widget = WidgetModel.create(
          type: widgetType,
          position: Offset.zero,
        );
        ref.read(canvasProvider.notifier).setDraggedWidget(widget);
      },
      onDragEnd: (details) {
        ref.read(canvasProvider.notifier).setDraggedWidget(null);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDragging
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDragging ? AppColors.primary : AppColors.borderLight,
            width: isDragging ? 2 : 1,
          ),
        ),
        child: InkWell(
          onTap: () => _addWidgetToCanvas(widgetType),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  WidgetHierarchyService.getWidgetIcon(widgetType),
                  size: 24,
                  color: isDragging
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                const SizedBox(height: 6),
                Text(
                  widgetType.displayName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isDragging
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(widgetType).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getWidgetCategory(widgetType).displayName,
                    style: TextStyle(
                      fontSize: 8,
                      color: _getCategoryColor(widgetType),
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

  List<FlutterWidgetType> _getFilteredWidgets() {
    List<FlutterWidgetType> widgets = [];

    // Get widgets based on selected category
    if (_selectedCategory == null) {
      // All widgets
      for (final categoryWidgets in _widgetLibrary.values) {
        widgets.addAll(categoryWidgets);
      }
    } else {
      widgets = _widgetLibrary[_selectedCategory] ?? [];
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      widgets = widgets.where((widget) {
        return widget.displayName.toLowerCase().contains(_searchQuery) ||
            widget.name.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    return widgets;
  }

  WidgetCategory _getWidgetCategory(FlutterWidgetType widgetType) {
    for (final entry in _widgetLibrary.entries) {
      if (entry.value.contains(widgetType)) {
        return entry.key;
      }
    }
    return WidgetCategory.layout; // Default
  }

  Color _getCategoryColor(FlutterWidgetType widgetType) {
    final category = _getWidgetCategory(widgetType);
    switch (category) {
      case WidgetCategory.layout:
        return Colors.blue;
      case WidgetCategory.input:
        return Colors.green;
      case WidgetCategory.display:
        return Colors.orange;
      case WidgetCategory.navigation:
        return Colors.purple;
      case WidgetCategory.scrolling:
        return Colors.teal;
      case WidgetCategory.advanced:
        return Colors.red;
    }
  }

  int _getTotalWidgetCount() {
    return _widgetLibrary.values.fold(
      0,
      (sum, widgets) => sum + widgets.length,
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  void _addWidgetToCanvas(FlutterWidgetType widgetType) {
    final widget = WidgetModel.create(
      type: widgetType,
      position: const Offset(100, 100), // Default position
    );

    ref.read(canvasProvider.notifier).addWidget(widget);

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widgetType.displayName} added to canvas'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

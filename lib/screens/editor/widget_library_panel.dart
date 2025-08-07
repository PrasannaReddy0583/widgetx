import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/widget_types.dart';
import '../../core/theme/colors.dart';
import '../../providers/widget_library_provider.dart';
import '../../widgets/layout/main_layout.dart';

/// Widget library panel showing available Flutter widgets
class WidgetLibraryPanel extends ConsumerStatefulWidget {
  const WidgetLibraryPanel({super.key});

  @override
  ConsumerState<WidgetLibraryPanel> createState() => _WidgetLibraryPanelState();
}

class _WidgetLibraryPanelState extends ConsumerState<WidgetLibraryPanel> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final libraryState = ref.watch(widgetLibraryProvider);
    final libraryNotifier = ref.read(widgetLibraryProvider.notifier);
    final widgetsByCategory = libraryNotifier.widgetsByCategory;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.categoryHeader,
            border: Border(bottom: BorderSide(color: AppColors.borderLight)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Widget Library',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              // Search field
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search widgets...',
                  prefixIcon: Icon(Icons.search, size: 18),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                onChanged: libraryNotifier.setSearchQuery,
              ),

              const SizedBox(height: 12),

              // Category filter chips
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: WidgetCategory.values.map((category) {
                  final isSelected = libraryState.selectedCategory == category;
                  return FilterChip(
                    label: Text(
                      category.displayName,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        libraryNotifier.setSelectedCategory(category);
                      } else {
                        libraryNotifier.clearCategoryFilter();
                      }
                    },
                    backgroundColor: AppColors.widgetItem,
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Widget list
        Expanded(
          child: widgetsByCategory.isEmpty
              ? const Center(
                  child: Text(
                    'No widgets found',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: widgetsByCategory.length,
                  itemBuilder: (context, index) {
                    final category = widgetsByCategory.keys.elementAt(index);
                    final widgets = widgetsByCategory[category]!;

                    return CollapsiblePanel(
                      title: category.displayName,
                      icon: category.icon,
                      child: Column(
                        children: widgets.map((widget) {
                          return _WidgetListItem(
                            definition: widget,
                            onTap: () => _onWidgetSelected(widget),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _onWidgetSelected(WidgetDefinition definition) {
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected ${definition.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

/// Individual widget list item
class _WidgetListItem extends StatefulWidget {
  const _WidgetListItem({required this.definition, required this.onTap});

  final WidgetDefinition definition;
  final VoidCallback onTap;

  @override
  State<_WidgetListItem> createState() => _WidgetListItemState();
}

class _WidgetListItemState extends State<_WidgetListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Draggable<WidgetDefinition>(
        data: widget.definition,
        feedback: _DragFeedback(definition: widget.definition),
        childWhenDragging: _buildItem(isDragging: true),
        child: _buildItem(),
      ),
    );
  }

  Widget _buildItem({bool isDragging = false}) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _isHovered && !isDragging
              ? AppColors.widgetItemHover
              : isDragging
              ? AppColors.widgetItem.withOpacity(0.5)
              : AppColors.widgetItem,
          border: const Border(
            bottom: BorderSide(color: AppColors.borderLight, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Widget icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                widget.definition.icon,
                size: 16,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 12),

            // Widget info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.definition.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.definition.description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Drag indicator
            const Icon(
              Icons.drag_indicator,
              size: 16,
              color: AppColors.iconDisabled,
            ),
          ],
        ),
      ),
    );
  }
}

/// Drag feedback widget
class _DragFeedback extends StatelessWidget {
  const _DragFeedback({required this.definition});

  final WidgetDefinition definition;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(definition.icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                definition.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget preview dialog
class _WidgetPreviewDialog extends StatelessWidget {
  const _WidgetPreviewDialog({required this.definition});

  final WidgetDefinition definition;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(definition.icon, size: 24, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  definition.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              definition.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 16),

            // Tags
            if (definition.tags.isNotEmpty) ...[
              const Text(
                'Tags:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: definition.tags.map((tag) {
                  return Chip(
                    label: Text(tag, style: const TextStyle(fontSize: 10)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Preview
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.canvasBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderLight),
              ),
              child:
                  definition.previewWidget ??
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          definition.icon,
                          size: 48,
                          color: AppColors.iconSecondary,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Preview not available',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
            ),

            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // TODO: Add widget to canvas
                  },
                  child: const Text('Add to Canvas'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

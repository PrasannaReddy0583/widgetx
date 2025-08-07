import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/colors.dart';
import '../../core/constants/widget_types.dart';
import '../../providers/properties_provider.dart';
import '../../providers/canvas_provider.dart';
import '../../models/property_model.dart';
import '../../models/widget_model.dart';
import '../../widgets/property_editors.dart' as PropertyEditorsWidget;
import '../../widgets/layout/collapsible_panel.dart';
import '../../services/undo_redo_service.dart';
//import '../../core/property_definitions/widget_property_definitions.dart';

/// Properties panel for editing selected widget properties
class PropertiesPanel extends ConsumerWidget {
  const PropertiesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesState = ref.watch(propertiesProvider);
    final canvasState = ref.watch(canvasProvider);
    final selectedWidget = canvasState.selectedWidgets.isNotEmpty
        ? canvasState.selectedWidgets.first
        : null;

    // Update properties provider when selection changes OR when selected widget properties change
    ref.listen(canvasProvider, (previous, next) {
      final previousSelected = previous?.selectedWidgets.isNotEmpty == true
          ? previous!.selectedWidgets.first
          : null;
      final currentSelected = next.selectedWidgets.isNotEmpty
          ? next.selectedWidgets.first
          : null;

      // Update if selection changed OR if the same widget's properties changed
      if (previousSelected?.id != currentSelected?.id ||
          (currentSelected != null && 
           previousSelected != null &&
           currentSelected.id == previousSelected.id &&
           currentSelected.updatedAt != previousSelected.updatedAt)) {
        ref
            .read(propertiesProvider.notifier)
            .setSelectedWidget(currentSelected);
      }
    });

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppColors.categoryHeader,
            border: Border(bottom: BorderSide(color: AppColors.borderLight)),
          ),
          child: Row(
            children: [
              const Text(
                'Properties',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (selectedWidget != null) ...[
                IconButton(
                  icon: const Icon(Icons.refresh, size: 18),
                  onPressed: () {
                    ref.read(propertiesProvider.notifier).resetToDefaults();
                  },
                  tooltip: 'Reset to Defaults',
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  color: AppColors.iconSecondary,
                ),
                IconButton(
                  icon: const Icon(Icons.unfold_more, size: 18),
                  onPressed: () {
                    ref.read(propertiesProvider.notifier).expandAllSections();
                  },
                  tooltip: 'Expand All',
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  color: AppColors.iconSecondary,
                ),
              ],
            ],
          ),
        ),

        // Content
        Expanded(
          child: selectedWidget == null
              ? const _EmptyPropertiesView()
              : _PropertiesContent(widget: selectedWidget),
        ),
      ],
    );
  }
}

/// Empty state when no widget is selected
class _EmptyPropertiesView extends StatelessWidget {
  const _EmptyPropertiesView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.tune, size: 64, color: AppColors.iconDisabled),
          SizedBox(height: 16),
          Text(
            'Select a widget to edit its properties',
            style: TextStyle(fontSize: 16, color: AppColors.textTertiary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Properties content for selected widget
class _PropertiesContent extends ConsumerWidget {
  const _PropertiesContent({required this.widget});

  final WidgetModel widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesByCategory =
        WidgetPropertyDefinitions.getPropertiesByCategory(widget.type);

    return Column(
      children: [
        // Widget info header
        _WidgetInfoHeader(widget: widget),

        // Properties sections
        Expanded(
          child: ListView.builder(
            itemCount: propertiesByCategory.length,
            itemBuilder: (context, index) {
              final category = propertiesByCategory.keys.elementAt(index);
              final properties = propertiesByCategory[category]!;

              return CollapsiblePanel(
                title: category,
                isExpanded: true,
                child: Column(
                  children: properties.map((property) {
                    return _PropertyEditor(property: property, widget: widget);
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Widget info header showing basic widget information
class _WidgetInfoHeader extends StatelessWidget {
  const _WidgetInfoHeader({required this.widget});

  final WidgetModel widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.propertySection,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
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
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getWidgetIcon(widget.type),
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      widget.type.displayName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(label: 'ID', value: widget.id.substring(0, 8)),
              const SizedBox(width: 8),
              _InfoChip(
                label: 'Size',
                value:
                    '${widget.size.width.toInt()}×${widget.size.height.toInt()}',
              ),
              const SizedBox(width: 8),
              _InfoChip(
                label: 'Position',
                value:
                    '${widget.position.dx.toInt()},${widget.position.dy.toInt()}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getWidgetIcon(FlutterWidgetType type) {
    switch (type.category) {
      case WidgetCategory.layout:
        return Icons.view_quilt;
      case WidgetCategory.input:
        return Icons.input;
      case WidgetCategory.display:
        return Icons.text_fields;
      case WidgetCategory.navigation:
        return Icons.navigation;
      case WidgetCategory.scrolling:
        return Icons.view_list;
      case WidgetCategory.advanced:
        return Icons.extension;
    }
  }
}

/// Info chip widget
class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.propertyItem,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual property editor
class _PropertyEditor extends ConsumerWidget {
  const _PropertyEditor({required this.property, required this.widget});

  final PropertyDefinition property;
  final WidgetModel widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesNotifier = ref.read(propertiesProvider.notifier);
    final canvasNotifier = ref.read(canvasProvider.notifier);
    final canvasState = ref.watch(canvasProvider);
    
    // Always use the latest widget from canvas state to avoid stale references
    final latestWidget = canvasState.selectedWidgets.isNotEmpty
        ? canvasState.selectedWidgets.firstWhere(
            (w) => w.id == widget.id,
            orElse: () => widget,
          )
        : widget;
    
    final currentValue =
        latestWidget.properties[property.name] ?? property.defaultValue;
    final hasError = propertiesNotifier.hasValidationError(property.name);
    final errorMessage = propertiesNotifier.getValidationError(property.name);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property label
          Row(
            children: [
              Expanded(
                child: Text(
                  property.displayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: hasError ? AppColors.error : AppColors.propertyLabel,
                  ),
                ),
              ),
              if (property.isRequired)
                const Text(
                  '*',
                  style: TextStyle(color: AppColors.error, fontSize: 12),
                ),
            ],
          ),

          if (property.description?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              property.description!,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textTertiary,
              ),
            ),
          ],

          const SizedBox(height: 8),

          // Property editor
          PropertyEditorsWidget.PropertyEditors.createEditor(
            definition: property,
            value: currentValue,
            errorMessage: errorMessage,
            onChanged: (value) {
              // Use the latest widget reference to avoid stale data
              final currentLatestWidget = canvasState.selectedWidgets.isNotEmpty
                  ? canvasState.selectedWidgets.firstWhere(
                      (w) => w.id == widget.id,
                      orElse: () => widget,
                    )
                  : widget;
              
              // Update the property immediately for real-time feedback
              propertiesNotifier.updateProperty(property.name, value);
              
              // Create updated widget using the latest widget state
              final updatedWidget = currentLatestWidget.updateProperties({
                property.name: value,
              });
              canvasNotifier.updateWidget(updatedWidget);
              
              // Add to undo/redo history
              final oldValue = currentLatestWidget.properties[property.name] ?? property.defaultValue;
              final oldProperties = Map<String, dynamic>.from(currentLatestWidget.properties);
              final newProperties = Map<String, dynamic>.from(currentLatestWidget.properties);
              newProperties[property.name] = value;
              
              UndoRedoService().executeAction(
                UpdatePropertiesAction(
                  widgetId: currentLatestWidget.id,
                  oldProperties: oldProperties,
                  newProperties: newProperties,
                  onUpdate: (id, props) {
                    // Use the latest widget reference for history updates too
                    final latestForHistory = ref.read(canvasProvider).selectedWidgets.isNotEmpty
                        ? ref.read(canvasProvider).selectedWidgets.firstWhere(
                            (w) => w.id == id,
                            orElse: () => currentLatestWidget,
                          )
                        : currentLatestWidget;
                    final updatedWidgetForHistory = latestForHistory.updateProperties(props);
                    canvasNotifier.updateWidget(updatedWidgetForHistory);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Property section header
class _PropertySectionHeader extends ConsumerWidget {
  const _PropertySectionHeader({
    required this.title,
    required this.isExpanded,
    required this.onToggle,
  });

  final String title;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.propertySection,
          border: Border(bottom: BorderSide(color: AppColors.borderLight)),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: AppColors.iconSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick actions for selected widget
class _QuickActions extends ConsumerWidget {
  const _QuickActions({required this.widget});

  final WidgetModel widget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canvasNotifier = ref.read(canvasProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.propertySection,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ActionButton(
                icon: Icons.content_copy,
                label: 'Duplicate',
                onPressed: () {
                  canvasNotifier.duplicateSelectedWidgets();
                },
              ),
              _ActionButton(
                icon: Icons.delete,
                label: 'Delete',
                onPressed: () {
                  canvasNotifier.deleteSelectedWidgets();
                },
                isDestructive: true,
              ),
              _ActionButton(
                icon: Icons.lock,
                label: widget.isLocked ? 'Unlock' : 'Lock',
                onPressed: () {
                  final updatedWidget = widget.copyWith(
                    isLocked: !widget.isLocked,
                  );
                  canvasNotifier.updateWidget(updatedWidget);
                },
              ),
              _ActionButton(
                icon: widget.isVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                label: widget.isVisible ? 'Hide' : 'Show',
                onPressed: () {
                  final updatedWidget = widget.copyWith(
                    isVisible: !widget.isVisible,
                  );
                  canvasNotifier.updateWidget(updatedWidget);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Action button widget
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.propertyItem,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isDestructive ? AppColors.error : AppColors.iconSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDestructive
                    ? AppColors.error
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

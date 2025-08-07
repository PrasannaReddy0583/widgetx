import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/widget_model.dart';
import '../../providers/canvas_provider.dart';
import '../../core/theme/colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/widget_types.dart';
import '../property_editors/text_property_editor.dart';
import '../property_editors/color_property_editor.dart';
import '../property_editors/number_property_editor.dart';
import '../property_editors/dropdown_property_editor.dart';
import '../property_editors/alignment_property_editor.dart';
import '../property_editors/edge_insets_property_editor.dart';
import '../property_editors/border_property_editor.dart';
import '../property_editors/shadow_property_editor.dart';

/// Enhanced properties panel with real-time updates
class EnhancedPropertiesPanel extends ConsumerStatefulWidget {
  const EnhancedPropertiesPanel({super.key});

  @override
  ConsumerState<EnhancedPropertiesPanel> createState() =>
      _EnhancedPropertiesPanelState();
}

class _EnhancedPropertiesPanelState
    extends ConsumerState<EnhancedPropertiesPanel> {
  final Map<String, bool> _expandedSections = {
    'layout': true,
    'appearance': true,
    'text': true,
    'behavior': false,
    'animation': false,
  };

  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasProvider);
    final selectedWidgets = canvasState.selectedWidgetIds;

    if (selectedWidgets.isEmpty) {
      return _buildEmptyState();
    }

    if (selectedWidgets.length > 1) {
      return _buildMultiSelectionState(selectedWidgets);
    }

    final selectedWidget = _getSelectedWidget(selectedWidgets.first);
    if (selectedWidget == null) {
      return _buildEmptyState();
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(left: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        children: [
          _buildHeader(selectedWidget),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              children: [
                _buildLayoutSection(selectedWidget),
                _buildAppearanceSection(selectedWidget),
                if (_hasTextProperties(selectedWidget.type))
                  _buildTextSection(selectedWidget),
                _buildBehaviorSection(selectedWidget),
                _buildAnimationSection(selectedWidget),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(left: BorderSide(color: AppColors.borderLight)),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings, size: 48, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text(
              'Select a widget\nto edit properties',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiSelectionState(List<String> selectedWidgets) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(left: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppConstants.paddingMedium),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.select_all,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${selectedWidgets.length} widgets selected',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bulk Actions',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBulkActionButton(
                    'Align Left',
                    Icons.format_align_left,
                    () => _alignWidgets(Alignment.centerLeft),
                  ),
                  _buildBulkActionButton(
                    'Align Center',
                    Icons.format_align_center,
                    () => _alignWidgets(Alignment.center),
                  ),
                  _buildBulkActionButton(
                    'Align Right',
                    Icons.format_align_right,
                    () => _alignWidgets(Alignment.centerRight),
                  ),
                  const SizedBox(height: 12),
                  _buildBulkActionButton(
                    'Distribute Horizontally',
                    Icons.horizontal_distribute,
                    _distributeHorizontally,
                  ),
                  _buildBulkActionButton(
                    'Distribute Vertically',
                    Icons.vertical_distribute,
                    _distributeVertically,
                  ),
                  const SizedBox(height: 12),
                  _buildBulkActionButton(
                    'Delete All',
                    Icons.delete,
                    _deleteSelectedWidgets,
                    isDestructive: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulkActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 16,
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          side: BorderSide(
            color: isDestructive ? AppColors.error : AppColors.borderLight,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(WidgetModel widget) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getWidgetIcon(widget.type),
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _duplicateWidget(widget),
                icon: const Icon(Icons.copy, size: 16),
                tooltip: 'Duplicate',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
              IconButton(
                onPressed: () => _deleteWidget(widget.id),
                icon: const Icon(
                  Icons.delete,
                  size: 16,
                  color: AppColors.error,
                ),
                tooltip: 'Delete',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.type.displayName,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutSection(WidgetModel widget) {
    return _buildSection('layout', 'Layout', Icons.crop_square, [
      // Position
      Row(
        children: [
          Expanded(
            child: NumberPropertyEditor(
              label: 'X',
              value: widget.position.dx,
              onChanged: (value) =>
                  _updatePosition(widget, value, widget.position.dy),
              min: 0,
              max: 2000,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: NumberPropertyEditor(
              label: 'Y',
              value: widget.position.dy,
              onChanged: (value) =>
                  _updatePosition(widget, widget.position.dx, value),
              min: 0,
              max: 2000,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),

      // Size
      Row(
        children: [
          Expanded(
            child: NumberPropertyEditor(
              label: 'Width',
              value: widget.size.width,
              onChanged: (value) =>
                  _updateSize(widget, value, widget.size.height),
              min: 0,
              max: 2000,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: NumberPropertyEditor(
              label: 'Height',
              value: widget.size.height,
              onChanged: (value) =>
                  _updateSize(widget, widget.size.width, value),
              min: 0,
              max: 2000,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),

      // Padding (for containers)
      if (_supportsPadding(widget.type))
        EdgeInsetsPropertyEditor(
          label: 'Padding',
          value: _getEdgeInsets(widget.properties['padding']),
          onChanged: (value) => _updateProperty(widget, 'padding', value),
        ),

      // Margin (for containers)
      if (_supportsMargin(widget.type))
        EdgeInsetsPropertyEditor(
          label: 'Margin',
          value: _getEdgeInsets(widget.properties['margin']),
          onChanged: (value) => _updateProperty(widget, 'margin', value),
        ),

      // Alignment
      if (_supportsAlignment(widget.type))
        AlignmentPropertyEditor(
          label: 'Alignment',
          value: _getAlignment(widget.properties['alignment']),
          onChanged: (value) => _updateProperty(widget, 'alignment', value),
        ),
    ]);
  }

  Widget _buildAppearanceSection(WidgetModel widget) {
    return _buildSection('appearance', 'Appearance', Icons.palette, [
      // Background Color
      if (_supportsBackgroundColor(widget.type))
        ColorPropertyEditor(
          label: 'Background Color',
          value: _getColor(widget.properties['backgroundColor']),
          onChanged: (value) =>
              _updateProperty(widget, 'backgroundColor', value),
        ),

      // Border
      if (_supportsBorder(widget.type))
        BorderPropertyEditor(
          label: 'Border',
          value: _getBorder(widget.properties['border']),
          onChanged: (value) => _updateProperty(widget, 'border', value),
        ),

      // Border Radius
      if (_supportsBorderRadius(widget.type))
        NumberPropertyEditor(
          label: 'Border Radius',
          value: _getDouble(widget.properties['borderRadius']) ?? 0.0,
          onChanged: (value) => _updateProperty(widget, 'borderRadius', value),
          min: 0,
          max: 100,
        ),

      // Shadow
      if (_supportsShadow(widget.type))
        ShadowPropertyEditor(
          label: 'Shadow',
          value: _getShadow(widget.properties['shadow']),
          onChanged: (value) => _updateProperty(widget, 'shadow', value),
        ),

      // Opacity
      NumberPropertyEditor(
        label: 'Opacity',
        value: widget.opacity,
        onChanged: (value) => _updateOpacity(widget, value),
        min: 0,
        max: 1,
        divisions: 100,
      ),
    ]);
  }

  Widget _buildTextSection(WidgetModel widget) {
    return _buildSection('text', 'Text', Icons.text_fields, [
      // Text Content
      if (widget.type == FlutterWidgetType.text)
        TextPropertyEditor(
          label: 'Text',
          value: widget.properties['text']?.toString() ?? 'Text',
          onChanged: (value) => _updateProperty(widget, 'text', value),
        ),

      // Font Size
      NumberPropertyEditor(
        label: 'Font Size',
        value: _getDouble(widget.properties['fontSize']) ?? 14.0,
        onChanged: (value) => _updateProperty(widget, 'fontSize', value),
        min: 8,
        max: 72,
      ),

      // Text Color
      ColorPropertyEditor(
        label: 'Text Color',
        value: _getColor(widget.properties['color']),
        onChanged: (value) => _updateProperty(widget, 'color', value),
      ),

      // Font Weight
      DropdownPropertyEditor<FontWeight>(
        label: 'Font Weight',
        value: _getFontWeight(widget.properties['fontWeight']),
        items: const [
          DropdownMenuItem(value: FontWeight.w100, child: Text('Thin')),
          DropdownMenuItem(value: FontWeight.w300, child: Text('Light')),
          DropdownMenuItem(value: FontWeight.w400, child: Text('Normal')),
          DropdownMenuItem(value: FontWeight.w500, child: Text('Medium')),
          DropdownMenuItem(value: FontWeight.w600, child: Text('Semi Bold')),
          DropdownMenuItem(value: FontWeight.w700, child: Text('Bold')),
          DropdownMenuItem(value: FontWeight.w900, child: Text('Black')),
        ],
        onChanged: (value) => _updateProperty(widget, 'fontWeight', value),
      ),

      // Text Align
      if (widget.type == FlutterWidgetType.text)
        DropdownPropertyEditor<TextAlign>(
          label: 'Text Align',
          value: _getTextAlign(widget.properties['textAlign']),
          items: const [
            DropdownMenuItem(value: TextAlign.left, child: Text('Left')),
            DropdownMenuItem(value: TextAlign.center, child: Text('Center')),
            DropdownMenuItem(value: TextAlign.right, child: Text('Right')),
            DropdownMenuItem(value: TextAlign.justify, child: Text('Justify')),
          ],
          onChanged: (value) => _updateProperty(widget, 'textAlign', value),
        ),
    ]);
  }

  Widget _buildBehaviorSection(WidgetModel widget) {
    return _buildSection('behavior', 'Behavior', Icons.touch_app, [
      // Visibility
      SwitchListTile(
        title: const Text('Visible', style: TextStyle(fontSize: 12)),
        value: widget.isVisible,
        onChanged: (value) => _updateVisibility(widget, value),
        dense: true,
        contentPadding: EdgeInsets.zero,
      ),

      // Lock
      SwitchListTile(
        title: const Text('Locked', style: TextStyle(fontSize: 12)),
        value: widget.isLocked,
        onChanged: (value) => _updateLock(widget, value),
        dense: true,
        contentPadding: EdgeInsets.zero,
      ),

      // Button specific properties
      if (_isButton(widget.type))
        TextPropertyEditor(
          label: 'Button Text',
          value: widget.properties['text']?.toString() ?? 'Button',
          onChanged: (value) => _updateProperty(widget, 'text', value),
        ),
    ]);
  }

  Widget _buildAnimationSection(WidgetModel widget) {
    return _buildSection('animation', 'Animation', Icons.animation, [
      // Rotation
      NumberPropertyEditor(
        label: 'Rotation (degrees)',
        value: widget.rotation * 180 / 3.14159, // Convert radians to degrees
        onChanged: (value) => _updateRotation(widget, value * 3.14159 / 180),
        min: 0,
        max: 360,
      ),

      // Scale
      NumberPropertyEditor(
        label: 'Scale',
        value: _getDouble(widget.properties['scale']) ?? 1.0,
        onChanged: (value) => _updateProperty(widget, 'scale', value),
        min: 0.1,
        max: 3.0,
        divisions: 29,
      ),
    ]);
  }

  Widget _buildSection(
    String key,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    final isExpanded = _expandedSections[key] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => _toggleSection(key),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(8),
                  bottom: isExpanded ? Radius.zero : const Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
        ],
      ),
    );
  }

  void _toggleSection(String key) {
    setState(() {
      _expandedSections[key] = !(_expandedSections[key] ?? false);
    });
  }

  // Update methods
  void _updatePosition(WidgetModel widget, double x, double y) {
    final updatedWidget = widget.copyWith(position: Offset(x, y));
    ref.read(canvasProvider.notifier).updateWidget(updatedWidget);
  }

  void _updateSize(WidgetModel widget, double width, double height) {
    final updatedWidget = widget.copyWith(size: Size(width, height));
    ref.read(canvasProvider.notifier).updateWidget(updatedWidget);
  }

  void _updateProperty(WidgetModel widget, String key, dynamic value) {
    final updatedProperties = Map<String, dynamic>.from(widget.properties);
    updatedProperties[key] = value;
    final updatedWidget = widget.copyWith(properties: updatedProperties);
    ref.read(canvasProvider.notifier).updateWidget(updatedWidget);
  }

  void _updateOpacity(WidgetModel widget, double opacity) {
    final updatedWidget = widget.copyWith(opacity: opacity);
    ref.read(canvasProvider.notifier).updateWidget(updatedWidget);
  }

  void _updateRotation(WidgetModel widget, double rotation) {
    final updatedWidget = widget.copyWith(rotation: rotation);
    ref.read(canvasProvider.notifier).updateWidget(updatedWidget);
  }

  void _updateVisibility(WidgetModel widget, bool isVisible) {
    final updatedWidget = widget.copyWith(isVisible: isVisible);
    ref.read(canvasProvider.notifier).updateWidget(updatedWidget);
  }

  void _updateLock(WidgetModel widget, bool isLocked) {
    final updatedWidget = widget.copyWith(isLocked: isLocked);
    ref.read(canvasProvider.notifier).updateWidget(updatedWidget);
  }

  void _duplicateWidget(WidgetModel widget) {
    final duplicated = widget.duplicate(offset: const Offset(20, 20));
    ref.read(canvasProvider.notifier).addWidget(duplicated);
  }

  void _deleteWidget(String widgetId) {
    ref.read(canvasProvider.notifier).removeWidget(widgetId);
  }

  // Bulk actions
  void _alignWidgets(Alignment alignment) {
    // Implementation for bulk alignment
    ref.read(canvasProvider.notifier).alignSelectedWidgets(alignment);
  }

  void _distributeHorizontally() {
    ref.read(canvasProvider.notifier).distributeSelectedWidgetsHorizontally();
  }

  void _distributeVertically() {
    ref.read(canvasProvider.notifier).distributeSelectedWidgetsVertically();
  }

  void _deleteSelectedWidgets() {
    ref.read(canvasProvider.notifier).deleteSelectedWidgets();
  }

  // Helper methods
  WidgetModel? _getSelectedWidget(String widgetId) {
    final currentScreen = ref.read(canvasProvider).currentScreen;
    if (currentScreen == null) return null;
    return _findWidgetInList(currentScreen.widgets, widgetId);
  }

  WidgetModel? _findWidgetInList(List<WidgetModel> widgets, String id) {
    for (final widget in widgets) {
      if (widget.id == id) return widget;
      final found = _findWidgetInList(widget.children, id);
      if (found != null) return found;
    }
    return null;
  }

  IconData _getWidgetIcon(FlutterWidgetType type) {
    // Use the same icon logic as in widget hierarchy service
    switch (type) {
      case FlutterWidgetType.container:
        return Icons.crop_square;
      case FlutterWidgetType.text:
        return Icons.text_fields;
      case FlutterWidgetType.elevatedButton:
        return Icons.smart_button;
      default:
        return Icons.widgets;
    }
  }

  // Property type checking methods
  bool _hasTextProperties(FlutterWidgetType type) {
    return [
      FlutterWidgetType.text,
      FlutterWidgetType.elevatedButton,
      FlutterWidgetType.textButton,
      FlutterWidgetType.outlinedButton,
      FlutterWidgetType.textField,
    ].contains(type);
  }

  bool _supportsPadding(FlutterWidgetType type) {
    return [
      FlutterWidgetType.container,
      FlutterWidgetType.padding,
    ].contains(type);
  }

  bool _supportsMargin(FlutterWidgetType type) {
    return [FlutterWidgetType.container].contains(type);
  }

  bool _supportsAlignment(FlutterWidgetType type) {
    return [
      FlutterWidgetType.container,
      FlutterWidgetType.align,
      FlutterWidgetType.center,
    ].contains(type);
  }

  bool _supportsBackgroundColor(FlutterWidgetType type) {
    return [
      FlutterWidgetType.container,
      FlutterWidgetType.card,
      FlutterWidgetType.scaffold,
    ].contains(type);
  }

  bool _supportsBorder(FlutterWidgetType type) {
    return [FlutterWidgetType.container].contains(type);
  }

  bool _supportsBorderRadius(FlutterWidgetType type) {
    return [FlutterWidgetType.container, FlutterWidgetType.card].contains(type);
  }

  bool _supportsShadow(FlutterWidgetType type) {
    return [FlutterWidgetType.container, FlutterWidgetType.card].contains(type);
  }

  bool _isButton(FlutterWidgetType type) {
    return [
      FlutterWidgetType.elevatedButton,
      FlutterWidgetType.textButton,
      FlutterWidgetType.outlinedButton,
      FlutterWidgetType.iconButton,
    ].contains(type);
  }

  // Property value getters
  EdgeInsets _getEdgeInsets(dynamic value) {
    if (value is EdgeInsets) return value;
    if (value is Map) {
      return EdgeInsets.fromLTRB(
        (value['left'] as num?)?.toDouble() ?? 0,
        (value['top'] as num?)?.toDouble() ?? 0,
        (value['right'] as num?)?.toDouble() ?? 0,
        (value['bottom'] as num?)?.toDouble() ?? 0,
      );
    }
    return EdgeInsets.zero;
  }

  Alignment _getAlignment(dynamic value) {
    if (value is Alignment) return value;
    return Alignment.center;
  }

  Color? _getColor(dynamic value) {
    if (value is Color) return value;
    if (value is int) return Color(value);
    return null;
  }

  double? _getDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    return null;
  }

  FontWeight _getFontWeight(dynamic value) {
    if (value is FontWeight) return value;
    return FontWeight.normal;
  }

  TextAlign _getTextAlign(dynamic value) {
    if (value is TextAlign) return value;
    return TextAlign.left;
  }

  Border? _getBorder(dynamic value) {
    if (value is Border) return value;
    return null;
  }

  BoxShadow? _getShadow(dynamic value) {
    if (value is BoxShadow) return value;
    return null;
  }
}

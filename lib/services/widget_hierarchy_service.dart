import 'package:flutter/material.dart';
import '../core/constants/widget_types.dart';
import '../models/widget_model.dart';

/// Service for managing widget hierarchy validation and rules
class WidgetHierarchyService {
  /// Check if a widget type can have children
  static bool canHaveChildren(FlutterWidgetType type) {
    switch (type) {
      // Layout widgets that can have children
      case FlutterWidgetType.container:
      case FlutterWidgetType.row:
      case FlutterWidgetType.column:
      case FlutterWidgetType.stack:
      case FlutterWidgetType.wrap:
      case FlutterWidgetType.expanded:
      case FlutterWidgetType.flexible:
      case FlutterWidgetType.positioned:
      case FlutterWidgetType.align:
      case FlutterWidgetType.center:
      case FlutterWidgetType.padding:
      case FlutterWidgetType.scaffold:
      case FlutterWidgetType.appBar:
      case FlutterWidgetType.card:
      case FlutterWidgetType.listView:
      case FlutterWidgetType.gridView:
      case FlutterWidgetType.singleChildScrollView:
      case FlutterWidgetType.pageView:
      case FlutterWidgetType.tabBarView:
      case FlutterWidgetType.bottomNavigationBar:
      case FlutterWidgetType.drawer:
      case FlutterWidgetType.bottomSheet:
        return true;
      
      // Widgets that cannot have children
      case FlutterWidgetType.text:
      case FlutterWidgetType.textField:
      case FlutterWidgetType.image:
      case FlutterWidgetType.icon:
      case FlutterWidgetType.elevatedButton:
      case FlutterWidgetType.textButton:
      case FlutterWidgetType.outlinedButton:
      case FlutterWidgetType.iconButton:
      case FlutterWidgetType.floatingActionButton:
      case FlutterWidgetType.checkbox:
      case FlutterWidgetType.radio:
      case FlutterWidgetType.switchWidget:
      case FlutterWidgetType.slider:
      case FlutterWidgetType.circularProgressIndicator:
      case FlutterWidgetType.linearProgressIndicator:
      case FlutterWidgetType.divider:
      case FlutterWidgetType.verticalDivider:
      case FlutterWidgetType.spacer:
      case FlutterWidgetType.sizedBox:
        return false;
      
      // Special cases
      case FlutterWidgetType.richText:
      case FlutterWidgetType.dropdownButton:
        return false;
      
      default:
        return false;
    }
  }

  /// Check if a widget can be a child of another widget
  static bool canBeChildOf(FlutterWidgetType childType, FlutterWidgetType parentType) {
    // Special parent-child relationship rules
    switch (parentType) {
      case FlutterWidgetType.scaffold:
        // Scaffold can have specific children
        return _isValidScaffoldChild(childType);
      
      case FlutterWidgetType.appBar:
        // AppBar can have limited children
        return _isValidAppBarChild(childType);
      
      case FlutterWidgetType.row:
      case FlutterWidgetType.column:
        // Row/Column prefer Expanded/Flexible children but can have any widget
        return true;
      
      case FlutterWidgetType.stack:
        // Stack children should ideally be Positioned
        return true;
      
      case FlutterWidgetType.listView:
      case FlutterWidgetType.gridView:
        // ListView/GridView have special item builders
        return false; // Items are generated, not dragged
      
      case FlutterWidgetType.expanded:
      case FlutterWidgetType.flexible:
        // These can only have one child
        return true;
      
      case FlutterWidgetType.container:
      case FlutterWidgetType.center:
      case FlutterWidgetType.align:
      case FlutterWidgetType.padding:
        // Single child containers
        return true;
      
      default:
        return canHaveChildren(parentType);
    }
  }

  /// Check if widget is a valid Scaffold child
  static bool _isValidScaffoldChild(FlutterWidgetType childType) {
    switch (childType) {
      case FlutterWidgetType.appBar:
      case FlutterWidgetType.container:
      case FlutterWidgetType.column:
      case FlutterWidgetType.row:
      case FlutterWidgetType.stack:
      case FlutterWidgetType.center:
      case FlutterWidgetType.listView:
      case FlutterWidgetType.gridView:
      case FlutterWidgetType.singleChildScrollView:
      case FlutterWidgetType.pageView:
      case FlutterWidgetType.tabBarView:
      case FlutterWidgetType.bottomNavigationBar:
      case FlutterWidgetType.drawer:
      case FlutterWidgetType.floatingActionButton:
        return true;
      default:
        return false;
    }
  }

  /// Check if widget is a valid AppBar child
  static bool _isValidAppBarChild(FlutterWidgetType childType) {
    switch (childType) {
      case FlutterWidgetType.text:
      case FlutterWidgetType.icon:
      case FlutterWidgetType.iconButton:
      case FlutterWidgetType.row:
      case FlutterWidgetType.container:
        return true;
      default:
        return false;
    }
  }

  /// Get maximum children count for a widget type
  static int? getMaxChildrenCount(FlutterWidgetType type) {
    switch (type) {
      case FlutterWidgetType.container:
      case FlutterWidgetType.center:
      case FlutterWidgetType.align:
      case FlutterWidgetType.padding:
      case FlutterWidgetType.expanded:
      case FlutterWidgetType.flexible:
      case FlutterWidgetType.positioned:
      case FlutterWidgetType.sizedBox:
        return 1; // Single child widgets
      
      case FlutterWidgetType.row:
      case FlutterWidgetType.column:
      case FlutterWidgetType.stack:
      case FlutterWidgetType.wrap:
        return null; // Unlimited children
      
      case FlutterWidgetType.scaffold:
        return 10; // Limited but multiple children (body, appBar, etc.)
      
      default:
        return canHaveChildren(type) ? null : 0;
    }
  }

  /// Validate drop operation
  static DropValidationResult validateDrop({
    required FlutterWidgetType draggedType,
    required WidgetModel? targetWidget,
    required List<WidgetModel> allWidgets,
  }) {
    // If no target, it's a root level drop
    if (targetWidget == null) {
      return DropValidationResult(
        isValid: true,
        message: 'Drop at root level',
        dropZone: DropZone.root,
      );
    }

    // Check if target can have children
    if (!canHaveChildren(targetWidget.type)) {
      return DropValidationResult(
        isValid: false,
        message: '${targetWidget.type.displayName} cannot have children',
        dropZone: DropZone.invalid,
      );
    }

    // Check parent-child relationship
    if (!canBeChildOf(draggedType, targetWidget.type)) {
      return DropValidationResult(
        isValid: false,
        message: '${draggedType.displayName} cannot be child of ${targetWidget.type.displayName}',
        dropZone: DropZone.invalid,
      );
    }

    // Check maximum children count
    final maxChildren = getMaxChildrenCount(targetWidget.type);
    if (maxChildren != null && targetWidget.children.length >= maxChildren) {
      return DropValidationResult(
        isValid: false,
        message: '${targetWidget.type.displayName} can only have $maxChildren child(ren)',
        dropZone: DropZone.invalid,
      );
    }

    return DropValidationResult(
      isValid: true,
      message: 'Valid drop zone',
      dropZone: DropZone.valid,
    );
  }

  /// Get widget icon for tree display
  static IconData getWidgetIcon(FlutterWidgetType type) {
    switch (type) {
      case FlutterWidgetType.scaffold:
        return Icons.phone_android;
      case FlutterWidgetType.appBar:
        return Icons.web_asset;
      case FlutterWidgetType.container:
        return Icons.crop_square;
      case FlutterWidgetType.row:
        return Icons.view_week;
      case FlutterWidgetType.column:
        return Icons.view_agenda;
      case FlutterWidgetType.stack:
        return Icons.layers;
      case FlutterWidgetType.text:
        return Icons.text_fields;
      case FlutterWidgetType.textField:
        return Icons.input;
      case FlutterWidgetType.elevatedButton:
      case FlutterWidgetType.textButton:
      case FlutterWidgetType.outlinedButton:
        return Icons.smart_button;
      case FlutterWidgetType.iconButton:
        return Icons.radio_button_unchecked;
      case FlutterWidgetType.image:
        return Icons.image;
      case FlutterWidgetType.icon:
        return Icons.star;
      case FlutterWidgetType.listView:
        return Icons.list;
      case FlutterWidgetType.gridView:
        return Icons.grid_view;
      case FlutterWidgetType.card:
        return Icons.credit_card;
      case FlutterWidgetType.checkbox:
        return Icons.check_box;
      case FlutterWidgetType.radio:
        return Icons.radio_button_checked;
      case FlutterWidgetType.switchWidget:
        return Icons.toggle_on;
      case FlutterWidgetType.slider:
        return Icons.tune;
      case FlutterWidgetType.floatingActionButton:
        return Icons.add_circle;
      default:
        return Icons.widgets;
    }
  }

  /// Get suggested parent widgets for a given widget type
  static List<FlutterWidgetType> getSuggestedParents(FlutterWidgetType childType) {
    switch (childType) {
      case FlutterWidgetType.appBar:
        return [FlutterWidgetType.scaffold];
      
      case FlutterWidgetType.floatingActionButton:
        return [FlutterWidgetType.scaffold];
      
      case FlutterWidgetType.text:
      case FlutterWidgetType.icon:
        return [
          FlutterWidgetType.container,
          FlutterWidgetType.row,
          FlutterWidgetType.column,
          FlutterWidgetType.center,
          FlutterWidgetType.appBar,
        ];
      
      case FlutterWidgetType.elevatedButton:
      case FlutterWidgetType.textButton:
      case FlutterWidgetType.outlinedButton:
        return [
          FlutterWidgetType.row,
          FlutterWidgetType.column,
          FlutterWidgetType.container,
          FlutterWidgetType.center,
        ];
      
      default:
        return [
          FlutterWidgetType.container,
          FlutterWidgetType.row,
          FlutterWidgetType.column,
          FlutterWidgetType.stack,
        ];
    }
  }
}

/// Result of drop validation
class DropValidationResult {
  const DropValidationResult({
    required this.isValid,
    required this.message,
    required this.dropZone,
  });

  final bool isValid;
  final String message;
  final DropZone dropZone;
}

/// Drop zone types for visual feedback
enum DropZone {
  valid,
  invalid,
  root,
}

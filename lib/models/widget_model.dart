import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/widget_types.dart';
import '../core/converters/offset_converter.dart';
import '../core/converters/size_converter.dart';

part 'widget_model.freezed.dart';
part 'widget_model.g.dart';

/// Model representing a widget instance on the canvas
@freezed
abstract class WidgetModel with _$WidgetModel {
  const factory WidgetModel({
    required String id,
    required FlutterWidgetType type,
    required String name,
    @OffsetConverter() required Offset position,
    @SizeConverter() required Size size,
    @Default({}) Map<String, dynamic> properties,
    @Default([]) List<WidgetModel> children,
    String? parentId,
    @Default(0) int zIndex,
    @Default(false) bool isSelected,
    @Default(false) bool isLocked,
    @Default(true) bool isVisible,
    @Default(1.0) double opacity,
    @Default(0.0) double rotation,
    Map<String, dynamic>? responsiveProperties,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WidgetModel;

  factory WidgetModel.fromJson(Map<String, dynamic> json) =>
      _$WidgetModelFromJson(json);

  /// Create a new widget with default properties
  factory WidgetModel.create({
    required FlutterWidgetType type,
    required Offset position,
    Size? size,
    Map<String, dynamic>? properties,
  }) {
    final now = DateTime.now();
    return WidgetModel(
      id: const Uuid().v4(),
      type: type,
      name: type.displayName,
      position: position,
      size: size ?? _getDefaultSize(type),
      properties: properties ?? getDefaultProperties(type),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Get default size for widget type
  static Size _getDefaultSize(FlutterWidgetType type) {
    switch (type.category) {
      case WidgetCategory.layout:
        return const Size(200, 100);
      case WidgetCategory.input:
        return const Size(150, 48);
      case WidgetCategory.display:
        return const Size(100, 50);
      case WidgetCategory.navigation:
        return const Size(300, 56);
      case WidgetCategory.scrolling:
        return const Size(250, 200);
      case WidgetCategory.advanced:
        return const Size(150, 150);
    }
  }

  /// Get default properties for widget type
  static Map<String, dynamic> getDefaultProperties(FlutterWidgetType type) {
    switch (type) {
      case FlutterWidgetType.container:
        return {
          'width': 200.0,
          'height': 120.0,
          'color': Colors.blue.withOpacity(0.3).value,
          'padding': 16.0,
          'margin': 8.0,
          'borderRadius': 8.0,
          'borderColor': Colors.blue.withOpacity(0.7).value,
          'borderWidth': 2.0,
        };
      case FlutterWidgetType.text:
        return {
          'text': 'Sample Text',
          'fontSize': 16.0,
          'fontWeight': 'normal',
          'color': Colors.black87.value,
          'textAlign': 'left',
        };
      case FlutterWidgetType.elevatedButton:
        return {
          'text': 'Button',
          'onPressed': 'null',
          'backgroundColor': Colors.blue.value,
          'foregroundColor': Colors.white.value,
          'elevation': 2.0,
          'borderRadius': 8.0,
          'padding': 16.0,
        };
      case FlutterWidgetType.row:
        return {
          'mainAxisAlignment': 'start',
          'crossAxisAlignment': 'center',
          'mainAxisSize': 'max',
        };
      case FlutterWidgetType.column:
        return {
          'mainAxisAlignment': 'start',
          'crossAxisAlignment': 'center',
          'mainAxisSize': 'max',
        };
      case FlutterWidgetType.textField:
        return {
          'hintText': 'Enter text',
          'labelText': 'Label',
          'borderType': 'outline',
          'filled': true,
          'fillColor': Colors.grey[100]?.value ?? Colors.grey.value,
        };
      case FlutterWidgetType.image:
        return {
          'src': 'assets/images/placeholder.png',
          'fit': 'cover',
          'width': 150.0,
          'height': 150.0,
        };
      case FlutterWidgetType.icon:
        return {
          'icon': Icons.star.codePoint,
          'size': 24.0,
          'color': Colors.black.value,
        };
      case FlutterWidgetType.stack:
        return {'alignment': 'topLeft', 'fit': 'loose'};
      case FlutterWidgetType.listView:
        return {'scrollDirection': 'vertical', 'itemCount': 5, 'padding': 16.0};
      case FlutterWidgetType.gridView:
        return {
          'crossAxisCount': 2,
          'mainAxisSpacing': 8.0,
          'crossAxisSpacing': 8.0,
          'childAspectRatio': 1.0,
        };
      case FlutterWidgetType.card:
        return {
          'elevation': 4.0,
          'margin': 8.0,
          'borderRadius': 12.0,
          'color': Colors.white.value,
        };
      case FlutterWidgetType.appBar:
        return {
          'title': 'App Bar',
          'backgroundColor': Colors.blue.value,
          'foregroundColor': Colors.white.value,
          'elevation': 4.0,
          'centerTitle': false,
        };
      default:
        return {};
    }
  }
}

/// Extension methods for WidgetModel
extension WidgetModelExtensions on WidgetModel {
  /// Check if widget can have children
  bool get canHaveChildren {
    switch (type.category) {
      case WidgetCategory.layout:
        return true;
      case WidgetCategory.scrolling:
        return true;
      case WidgetCategory.navigation:
        return type == FlutterWidgetType.appBar;
      default:
        return false;
    }
  }

  /// Check if widget can be a child of another widget
  bool canBeChildOf(FlutterWidgetType parentType) {
    // Basic compatibility rules
    switch (parentType.category) {
      case WidgetCategory.layout:
        return true;
      case WidgetCategory.scrolling:
        return true;
      case WidgetCategory.navigation:
        return type.category != WidgetCategory.navigation;
      default:
        return false;
    }
  }

  /// Get widget bounds
  Rect get bounds =>
      Rect.fromLTWH(position.dx, position.dy, size.width, size.height);

  /// Check if point is inside widget bounds
  bool containsPoint(Offset point) {
    return bounds.contains(point);
  }

  /// Create a copy with updated position
  WidgetModel moveBy(Offset delta) {
    return copyWith(position: position + delta, updatedAt: DateTime.now());
  }

  /// Create a copy with updated size
  WidgetModel resizeTo(Size newSize) {
    return copyWith(size: newSize, updatedAt: DateTime.now());
  }

  /// Create a copy with updated properties
  WidgetModel updateProperties(Map<String, dynamic> newProperties) {
    final updatedProps = Map<String, dynamic>.from(properties);
    updatedProps.addAll(newProperties);
    return copyWith(properties: updatedProps, updatedAt: DateTime.now());
  }

  /// Create a copy with a new child added
  WidgetModel addChild(WidgetModel child) {
    if (!canHaveChildren) return this;

    final updatedChild = child.copyWith(parentId: id);
    return copyWith(
      children: [...children, updatedChild],
      updatedAt: DateTime.now(),
    );
  }

  /// Create a copy with a child removed
  WidgetModel removeChild(String childId) {
    return copyWith(
      children: children.where((child) => child.id != childId).toList(),
      updatedAt: DateTime.now(),
    );
  }

  /// Create a copy with updated child
  WidgetModel updateChild(WidgetModel updatedChild) {
    final childIndex = children.indexWhere(
      (child) => child.id == updatedChild.id,
    );
    if (childIndex == -1) return this;

    final updatedChildren = List<WidgetModel>.from(children);
    updatedChildren[childIndex] = updatedChild;

    return copyWith(children: updatedChildren, updatedAt: DateTime.now());
  }

  /// Get all descendant widgets (recursive)
  List<WidgetModel> get allDescendants {
    final descendants = <WidgetModel>[];
    for (final child in children) {
      descendants.add(child);
      descendants.addAll(child.allDescendants);
    }
    return descendants;
  }

  /// Get widget depth in the tree
  int get depth {
    if (parentId == null) return 0;
    // This would need to be calculated with access to the full widget tree
    return 1;
  }

  /// Check if widget is ancestor of another widget
  bool isAncestorOf(WidgetModel other) {
    return allDescendants.any((descendant) => descendant.id == other.id);
  }

  /// Create a duplicate with new ID
  WidgetModel duplicate({Offset? offset}) {
    final now = DateTime.now();
    final newPosition = offset != null ? position + offset : position;

    return copyWith(
      id: const Uuid().v4(),
      position: newPosition,
      name: '$name Copy',
      isSelected: false,
      children: children.map((child) => child.duplicate()).toList(),
      createdAt: now,
      updatedAt: now,
    );
  }
}

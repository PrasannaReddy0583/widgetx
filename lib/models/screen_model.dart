import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:widgetx/core/constants/widget_types.dart';
import 'widget_model.dart';
import '../core/constants/device_frames.dart';
import '../core/converters/color_converter.dart';
import '../core/converters/device_frame_converter.dart';

part 'screen_model.freezed.dart';
part 'screen_model.g.dart';

/// Model representing a screen in the Flutter project
@freezed
abstract class ScreenModel with _$ScreenModel {
  const factory ScreenModel({
    String? id,
    required String name,
    @Default([]) List<WidgetModel> widgets,
    @Default(false) bool isMain,
    @Default('') String route,
    @Default({}) Map<String, dynamic> properties,
    @DeviceFrameConverter()
    @Default(DeviceFrame.iphone14)
    DeviceFrame deviceFrame,
    @ColorConverter() @Default(Color(0xFFFFFFFF)) Color backgroundColor,
    @Default(true) bool showAppBar,
    @Default('') String appBarTitle,
    @Default(false) bool showBottomNavBar,
    @Default([]) List<String> navigationItems,
    @Default({}) Map<String, dynamic> responsiveSettings,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? description,
    @Default([]) List<String> tags,
  }) = _ScreenModel;

  factory ScreenModel.fromJson(Map<String, dynamic> json) =>
      _$ScreenModelFromJson(json);

  /// Create a new screen with default settings
  factory ScreenModel.create({
    required String name,
    bool isMain = false,
    String? route,
  }) {
    final now = DateTime.now();
    final screenId = const Uuid().v4();

    return ScreenModel(
      id: screenId,
      name: name,
      isMain: isMain,
      route: route ?? '/${name.toLowerCase().replaceAll(' ', '_')}',
      properties: _getDefaultProperties(),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Create a new screen from a template
  factory ScreenModel.createFromTemplate({
    required String name,
    required String template,
    bool isMain = false,
    String? route,
  }) {
    final now = DateTime.now();
    final screenId = const Uuid().v4();
    final templateWidgets = _getTemplateWidgets(template);
    final templateProperties = _getTemplateProperties(template);

    return ScreenModel(
      id: screenId,
      name: name,
      isMain: isMain,
      route: route ?? '/${name.toLowerCase().replaceAll(' ', '_')}',
      widgets: templateWidgets,
      properties: {..._getDefaultProperties(), ...templateProperties},
      createdAt: now,
      updatedAt: now,
      description: 'Screen created from $template template',
      tags: [template, 'template'],
    );
  }

  /// Get default screen properties
  static Map<String, dynamic> _getDefaultProperties() {
    return {
      'safeArea': true,
      'resizeToAvoidBottomInset': true,
      'extendBody': false,
      'extendBodyBehindAppBar': false,
      'scrollable': false,
      'padding': 16.0,
      'physics': 'bouncing',
    };
  }

  /// Get template-specific widgets
  static List<WidgetModel> _getTemplateWidgets(String template) {
    switch (template) {
      case 'login':
        final emailField = WidgetModel.create(
          type: FlutterWidgetType.textField,
          position: const Offset(0, 0),
          size: const Size(280, 50),
          properties: {'hintText': 'Email', 'keyboardType': 'email'},
        );
        
        final passwordField = WidgetModel.create(
          type: FlutterWidgetType.textField,
          position: const Offset(0, 70),
          size: const Size(280, 50),
          properties: {'hintText': 'Password', 'obscureText': true},
        );
        
        final loginButton = WidgetModel.create(
          type: FlutterWidgetType.elevatedButton,
          position: const Offset(0, 140),
          size: const Size(280, 50),
          properties: {'text': 'Login', 'backgroundColor': '0xFF2196F3'},
        );
        
        final columnWidget = WidgetModel.create(
          type: FlutterWidgetType.column,
          position: const Offset(20, 100),
          size: const Size(300, 400),
          properties: {
            'mainAxisAlignment': 'center',
            'crossAxisAlignment': 'center',
          },
        ).addChild(emailField).addChild(passwordField).addChild(loginButton);
        
        return [
          columnWidget,
        ];
      case 'home':
        return [
          WidgetModel.create(
            type: FlutterWidgetType.appBar,
            position: const Offset(0, 0),
            size: const Size(400, 56),
            properties: {'title': 'Home', 'backgroundColor': '0xFF2196F3'},
          ),
          () {
            final welcomeText = WidgetModel.create(
              type: FlutterWidgetType.text,
              position: const Offset(0, 0),
              size: const Size(360, 40),
              properties: {
                'text': 'Welcome to the App!',
                'fontSize': 24.0,
                'fontWeight': 'bold',
              },
            );
            
            final cardWidget = WidgetModel.create(
              type: FlutterWidgetType.card,
              position: const Offset(0, 60),
              size: const Size(360, 120),
              properties: {'elevation': 4.0, 'margin': '16.0'},
            );
            
            return WidgetModel.create(
              type: FlutterWidgetType.column,
              position: const Offset(20, 80),
              size: const Size(360, 500),
              properties: {
                'mainAxisAlignment': 'start',
                'crossAxisAlignment': 'stretch',
              },
            ).addChild(welcomeText).addChild(cardWidget);
          }(),
        ];
      case 'profile':
        final avatar = WidgetModel.create(
          type: FlutterWidgetType.avatar,
          position: const Offset(0, 0),
          size: const Size(80, 80),
          properties: {'radius': 40.0, 'backgroundColor': '0xFF9E9E9E'},
        );
        
        final nameText = WidgetModel.create(
          type: FlutterWidgetType.text,
          position: const Offset(0, 100),
          size: const Size(360, 30),
          properties: {
            'text': 'User Name',
            'fontSize': 20.0,
            'fontWeight': 'bold',
          },
        );
        
        final emailText = WidgetModel.create(
          type: FlutterWidgetType.text,
          position: const Offset(0, 140),
          size: const Size(360, 20),
          properties: {
            'text': 'user@example.com',
            'fontSize': 16.0,
            'color': '0xFF757575',
          },
        );
        
        final profileColumn = WidgetModel.create(
          type: FlutterWidgetType.column,
          position: const Offset(20, 100),
          size: const Size(360, 400),
          properties: {
            'mainAxisAlignment': 'start',
            'crossAxisAlignment': 'center',
          },
        ).addChild(avatar).addChild(nameText).addChild(emailText);
        
        return [profileColumn];
      case 'settings':
        var listView = WidgetModel.create(
          type: FlutterWidgetType.listView,
          position: const Offset(0, 100),
          size: const Size(400, 500),
          properties: {'itemCount': 5, 'separatorBuilder': true},
        );
        for (final child in [
          WidgetModel.create(
            type: FlutterWidgetType.listTile,
            position: const Offset(0, 0),
            size: const Size(400, 60),
            properties: {
              'title': 'Account Settings',
              'leading': 'Icons.account_circle',
              'trailing': 'Icons.arrow_forward_ios',
            },
          ),
          WidgetModel.create(
            type: FlutterWidgetType.listTile,
            position: const Offset(0, 60),
            size: const Size(400, 60),
            properties: {
              'title': 'Notifications',
              'leading': 'Icons.notifications',
              'trailing': 'Icons.arrow_forward_ios',
            },
          ),
        ]) {
          listView = listView.addChild(child);
        }
        return [listView];
      case 'list':
        var listView = WidgetModel.create(
          type: FlutterWidgetType.listView,
          position: const Offset(0, 100),
          size: const Size(400, 500),
          properties: {'itemCount': 10, 'separatorBuilder': true},
        );
        for (final child in List.generate(
          3,
          (index) => WidgetModel.create(
            type: FlutterWidgetType.listTile,
            position: Offset(0, (index * 60).toDouble()),
            size: const Size(400, 60),
            properties: {
              'title': 'Item ${index + 1}',
              'subtitle': 'Description for item ${index + 1}',
              'leading': 'Icons.list',
            },
          ),
        )) {
          listView = listView.addChild(child);
        }
        return [listView];
      default:
        return [];
    }
  }

  /// Get template-specific properties
  static Map<String, dynamic> _getTemplateProperties(String template) {
    switch (template) {
      case 'login':
        return {
          'showAppBar': false,
          'backgroundColor': '0xFFF5F5F5',
          'padding': 20.0,
        };
      case 'home':
        return {
          'showAppBar': true,
          'appBarTitle': 'Home',
          'backgroundColor': '0xFFFFFFFF',
        };
      case 'profile':
        return {
          'showAppBar': true,
          'appBarTitle': 'Profile',
          'backgroundColor': '0xFFFFFFFF',
        };
      case 'settings':
        return {
          'showAppBar': true,
          'appBarTitle': 'Settings',
          'backgroundColor': '0xFFFFFFFF',
        };
      case 'list':
        return {
          'showAppBar': true,
          'appBarTitle': 'List',
          'backgroundColor': '0xFFFFFFFF',
          'scrollable': true,
        };
      default:
        return {};
    }
  }
}

/// Extension methods for ScreenModel
extension ScreenModelExtensions on ScreenModel {
  /// Get widget by ID
  WidgetModel? getWidgetById(String widgetId) {
    try {
      return widgets.firstWhere((widget) => widget.id == widgetId);
    } catch (e) {
      return null;
    }
  }

  /// Add a widget to the screen
  ScreenModel addWidget(WidgetModel widget) {
    return copyWith(widgets: [...widgets, widget], updatedAt: DateTime.now());
  }

  /// Remove a widget from the screen
  ScreenModel removeWidget(String widgetId) {
    return copyWith(
      widgets: widgets.where((widget) => widget.id != widgetId).toList(),
      updatedAt: DateTime.now(),
    );
  }

  /// Update a widget on the screen
  ScreenModel updateWidget(WidgetModel updatedWidget) {
    final widgetIndex = widgets.indexWhere(
      (widget) => widget.id == updatedWidget.id,
    );
    if (widgetIndex == -1) return this;

    final updatedWidgets = List<WidgetModel>.from(widgets);
    updatedWidgets[widgetIndex] = updatedWidget;

    return copyWith(widgets: updatedWidgets, updatedAt: DateTime.now());
  }

  /// Move widget to new position
  ScreenModel moveWidget(String widgetId, Offset newPosition) {
    final widget = getWidgetById(widgetId);
    if (widget == null) return this;

    final updatedWidget = widget.copyWith(
      position: newPosition,
      updatedAt: DateTime.now(),
    );

    return updateWidget(updatedWidget);
  }

  /// Move widget to a different parent in the hierarchy
  ScreenModel moveWidgetToParent(String widgetId, String? newParentId) {
    final widget = getWidgetById(widgetId);
    if (widget == null) return this;

    // Don't allow moving a widget to itself or its descendants
    if (widgetId == newParentId || _isDescendant(widgetId, newParentId)) {
      return this;
    }

    // Remove widget from current parent
    final updatedWidgets = List<WidgetModel>.from(widgets);
    final widgetIndex = updatedWidgets.indexWhere((w) => w.id == widgetId);
    if (widgetIndex == -1) return this;

    final movedWidget = updatedWidgets[widgetIndex];
    updatedWidgets.removeAt(widgetIndex);

    // Update the widget's parent
    final updatedWidget = movedWidget.copyWith(
      parentId: newParentId,
      updatedAt: DateTime.now(),
    );

    // Add widget to new position
    if (newParentId == null) {
      // Moving to root level
      updatedWidgets.add(updatedWidget);
    } else {
      // Find the target parent and add after it
      final parentIndex = updatedWidgets.indexWhere((w) => w.id == newParentId);
      if (parentIndex != -1) {
        updatedWidgets.insert(parentIndex + 1, updatedWidget);
      } else {
        updatedWidgets.add(updatedWidget);
      }
    }

    return copyWith(widgets: updatedWidgets, updatedAt: DateTime.now());
  }

  /// Check if a widget is a descendant of another widget
  bool _isDescendant(String ancestorId, String? descendantId) {
    if (descendantId == null) return false;

    final descendant = getWidgetById(descendantId);
    if (descendant == null) return false;

    String? currentParentId = descendant.parentId;
    while (currentParentId != null) {
      if (currentParentId == ancestorId) return true;
      final parent = getWidgetById(currentParentId);
      currentParentId = parent?.parentId;
    }

    return false;
  }

  /// Resize widget
  ScreenModel resizeWidget(String widgetId, Size newSize) {
    final widget = getWidgetById(widgetId);
    if (widget == null) return this;

    final updatedWidget = widget.copyWith(
      size: newSize,
      updatedAt: DateTime.now(),
    );

    return updateWidget(updatedWidget);
  }

  /// Select/deselect widgets
  ScreenModel selectWidget(String? widgetId) {
    final updatedWidgets = widgets.map((widget) {
      return widget.copyWith(isSelected: widget.id == widgetId);
    }).toList();

    return copyWith(widgets: updatedWidgets, updatedAt: DateTime.now());
  }

  /// Select multiple widgets
  ScreenModel selectWidgets(List<String> widgetIds) {
    final updatedWidgets = widgets.map((widget) {
      return widget.copyWith(isSelected: widgetIds.contains(widget.id));
    }).toList();

    return copyWith(widgets: updatedWidgets, updatedAt: DateTime.now());
  }

  /// Clear all selections
  ScreenModel clearSelection() {
    final updatedWidgets = widgets.map((widget) {
      return widget.copyWith(isSelected: false);
    }).toList();

    return copyWith(widgets: updatedWidgets, updatedAt: DateTime.now());
  }

  /// Get selected widgets
  List<WidgetModel> get selectedWidgets {
    return widgets.where((widget) => widget.isSelected).toList();
  }

  /// Get widgets at position
  List<WidgetModel> getWidgetsAtPosition(Offset position) {
    return widgets.where((widget) => widget.containsPoint(position)).toList();
  }

  /// Get widgets in area
  List<WidgetModel> getWidgetsInArea(Rect area) {
    return widgets.where((widget) => area.overlaps(widget.bounds)).toList();
  }

  /// Duplicate selected widgets
  ScreenModel duplicateSelectedWidgets({Offset offset = const Offset(20, 20)}) {
    final selectedWidgets = this.selectedWidgets;
    if (selectedWidgets.isEmpty) return this;

    final duplicatedWidgets = selectedWidgets.map((widget) {
      return widget.duplicate(offset: offset);
    }).toList();

    return copyWith(
      widgets: [...widgets, ...duplicatedWidgets],
      updatedAt: DateTime.now(),
    );
  }

  /// Delete selected widgets
  ScreenModel deleteSelectedWidgets() {
    final selectedIds = selectedWidgets.map((widget) => widget.id).toSet();

    return copyWith(
      widgets: widgets
          .where((widget) => !selectedIds.contains(widget.id))
          .toList(),
      updatedAt: DateTime.now(),
    );
  }

  /// Group selected widgets
  ScreenModel groupSelectedWidgets() {
    final selectedWidgets = this.selectedWidgets;
    if (selectedWidgets.length < 2) return this;

    // Calculate bounding box of selected widgets
    final bounds = _calculateBoundingBox(selectedWidgets);

    // Create container widget to hold the group
    final groupContainer = WidgetModel.create(
      type: FlutterWidgetType.container,
      position: bounds.topLeft,
      size: bounds.size,
    );

    // Remove selected widgets and add group container
    final remainingWidgets = widgets
        .where((widget) => !widget.isSelected)
        .toList();

    return copyWith(
      widgets: [...remainingWidgets, groupContainer],
      updatedAt: DateTime.now(),
    );
  }

  /// Calculate bounding box for a list of widgets
  Rect _calculateBoundingBox(List<WidgetModel> widgets) {
    if (widgets.isEmpty) return Rect.zero;

    double minX = widgets.first.position.dx;
    double minY = widgets.first.position.dy;
    double maxX = widgets.first.position.dx + widgets.first.size.width;
    double maxY = widgets.first.position.dy + widgets.first.size.height;

    for (final widget in widgets.skip(1)) {
      minX = minX < widget.position.dx ? minX : widget.position.dx;
      minY = minY < widget.position.dy ? minY : widget.position.dy;
      maxX = maxX > (widget.position.dx + widget.size.width)
          ? maxX
          : (widget.position.dx + widget.size.width);
      maxY = maxY > (widget.position.dy + widget.size.height)
          ? maxY
          : (widget.position.dy + widget.size.height);
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  /// Align selected widgets
  ScreenModel alignSelectedWidgets(AlignmentType alignmentType) {
    final selectedWidgets = this.selectedWidgets;
    if (selectedWidgets.length < 2) return this;

    final bounds = _calculateBoundingBox(selectedWidgets);
    final updatedWidgets = List<WidgetModel>.from(widgets);

    for (int i = 0; i < updatedWidgets.length; i++) {
      final widget = updatedWidgets[i];
      if (!widget.isSelected) continue;

      Offset newPosition = widget.position;

      switch (alignmentType) {
        case AlignmentType.left:
          newPosition = Offset(bounds.left, widget.position.dy);
          break;
        case AlignmentType.right:
          newPosition = Offset(
            bounds.right - widget.size.width,
            widget.position.dy,
          );
          break;
        case AlignmentType.top:
          newPosition = Offset(widget.position.dx, bounds.top);
          break;
        case AlignmentType.bottom:
          newPosition = Offset(
            widget.position.dx,
            bounds.bottom - widget.size.height,
          );
          break;
        case AlignmentType.centerHorizontal:
          newPosition = Offset(
            bounds.center.dx - widget.size.width / 2,
            widget.position.dy,
          );
          break;
        case AlignmentType.centerVertical:
          newPosition = Offset(
            widget.position.dx,
            bounds.center.dy - widget.size.height / 2,
          );
          break;
      }

      updatedWidgets[i] = widget.copyWith(position: newPosition);
    }

    return copyWith(widgets: updatedWidgets, updatedAt: DateTime.now());
  }

  /// Distribute selected widgets
  ScreenModel distributeSelectedWidgets(DistributionType distributionType) {
    final selectedWidgets = this.selectedWidgets;
    if (selectedWidgets.length < 3) return this;

    final sortedWidgets = List<WidgetModel>.from(selectedWidgets);

    // Sort widgets based on distribution type
    switch (distributionType) {
      case DistributionType.horizontal:
        sortedWidgets.sort((a, b) => a.position.dx.compareTo(b.position.dx));
        break;
      case DistributionType.vertical:
        sortedWidgets.sort((a, b) => a.position.dy.compareTo(b.position.dy));
        break;
    }

    final first = sortedWidgets.first;
    final last = sortedWidgets.last;
    final totalSpace = distributionType == DistributionType.horizontal
        ? (last.position.dx - first.position.dx)
        : (last.position.dy - first.position.dy);

    final spacing = totalSpace / (sortedWidgets.length - 1);
    final updatedWidgets = List<WidgetModel>.from(widgets);

    for (int i = 1; i < sortedWidgets.length - 1; i++) {
      final widget = sortedWidgets[i];
      final widgetIndex = updatedWidgets.indexWhere((w) => w.id == widget.id);

      if (widgetIndex != -1) {
        Offset newPosition = widget.position;

        if (distributionType == DistributionType.horizontal) {
          newPosition = Offset(
            first.position.dx + (spacing * i),
            widget.position.dy,
          );
        } else {
          newPosition = Offset(
            widget.position.dx,
            first.position.dy + (spacing * i),
          );
        }

        updatedWidgets[widgetIndex] = widget.copyWith(position: newPosition);
      }
    }

    return copyWith(widgets: updatedWidgets, updatedAt: DateTime.now());
  }

  /// Get screen statistics
  Map<String, dynamic> get statistics {
    final widgetTypes = <String, int>{};

    for (final widget in widgets) {
      final typeName = widget.type.displayName;
      widgetTypes[typeName] = (widgetTypes[typeName] ?? 0) + 1;
    }

    return {
      'widgetCount': widgets.length,
      'widgetTypes': widgetTypes,
      'selectedCount': selectedWidgets.length,
      'deviceFrame': deviceFrame.name,
      'lastModified': updatedAt?.toIso8601String(),
    };
  }

  /// Create a duplicate screen
  ScreenModel duplicate({String? newName}) {
    final now = DateTime.now();
    final duplicatedWidgets = widgets
        .map((widget) => widget.duplicate())
        .toList();

    return copyWith(
      id: const Uuid().v4(),
      name: newName ?? '$name Copy',
      widgets: duplicatedWidgets,
      isMain: false,
      route: '/${(newName ?? '$name Copy').toLowerCase().replaceAll(' ', '_')}',
      createdAt: now,
      updatedAt: now,
    );
  }
}

/// Alignment types for widget alignment
enum AlignmentType {
  left,
  right,
  top,
  bottom,
  centerHorizontal,
  centerVertical,
}

/// Distribution types for widget distribution
enum DistributionType { horizontal, vertical }

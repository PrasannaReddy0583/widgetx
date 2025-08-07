import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/widget_types.dart';
import '../models/widget_model.dart';

/// Widget definition for the library
class WidgetDefinition {
  const WidgetDefinition({
    required this.type,
    required this.name,
    required this.category,
    required this.icon,
    required this.description,
    this.previewWidget,
    this.tags = const [],
  });

  final FlutterWidgetType type;
  final String name;
  final WidgetCategory category;
  final IconData icon;
  final String description;
  final Widget? previewWidget;
  final List<String> tags;
}

/// Widget library state
class WidgetLibraryState {
  const WidgetLibraryState({
    this.searchQuery = '',
    this.selectedCategory,
    this.isExpanded = true,
  });

  final String searchQuery;
  final WidgetCategory? selectedCategory;
  final bool isExpanded;

  WidgetLibraryState copyWith({
    String? searchQuery,
    WidgetCategory? selectedCategory,
    bool? isExpanded,
  }) {
    return WidgetLibraryState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

/// Widget library provider
class WidgetLibraryNotifier extends StateNotifier<WidgetLibraryState> {
  WidgetLibraryNotifier() : super(const WidgetLibraryState());

  /// All available widget definitions
  static const List<WidgetDefinition> _allWidgets = [
    // Layout Widgets
    WidgetDefinition(
      type: FlutterWidgetType.container,
      name: 'Container',
      category: WidgetCategory.layout,
      icon: Icons.crop_square,
      description: 'A convenience widget that combines common painting, positioning, and sizing widgets.',
      tags: ['box', 'layout', 'decoration'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.row,
      name: 'Row',
      category: WidgetCategory.layout,
      icon: Icons.view_column,
      description: 'A widget that displays its children in a horizontal array.',
      tags: ['horizontal', 'flex', 'layout'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.column,
      name: 'Column',
      category: WidgetCategory.layout,
      icon: Icons.view_agenda,
      description: 'A widget that displays its children in a vertical array.',
      tags: ['vertical', 'flex', 'layout'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.stack,
      name: 'Stack',
      category: WidgetCategory.layout,
      icon: Icons.layers,
      description: 'A widget that positions its children relative to the edges of its box.',
      tags: ['overlay', 'position', 'z-index'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.wrap,
      name: 'Wrap',
      category: WidgetCategory.layout,
      icon: Icons.wrap_text,
      description: 'A widget that displays its children in multiple horizontal or vertical runs.',
      tags: ['wrap', 'flow', 'responsive'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.expanded,
      name: 'Expanded',
      category: WidgetCategory.layout,
      icon: Icons.open_in_full,
      description: 'A widget that expands a child of a Row, Column, or Flex.',
      tags: ['flex', 'expand', 'fill'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.flexible,
      name: 'Flexible',
      category: WidgetCategory.layout,
      icon: Icons.settings_ethernet,
      description: 'A widget that controls how a child of a Row, Column, or Flex flexes.',
      tags: ['flex', 'flexible', 'responsive'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.positioned,
      name: 'Positioned',
      category: WidgetCategory.layout,
      icon: Icons.place,
      description: 'A widget that controls where a child of a Stack is positioned.',
      tags: ['position', 'absolute', 'stack'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.align,
      name: 'Align',
      category: WidgetCategory.layout,
      icon: Icons.center_focus_strong,
      description: 'A widget that aligns its child within itself.',
      tags: ['align', 'center', 'position'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.center,
      name: 'Center',
      category: WidgetCategory.layout,
      icon: Icons.center_focus_weak,
      description: 'A widget that centers its child within itself.',
      tags: ['center', 'align', 'middle'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.padding,
      name: 'Padding',
      category: WidgetCategory.layout,
      icon: Icons.space_bar,
      description: 'A widget that insets its child by the given padding.',
      tags: ['padding', 'spacing', 'margin'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.sizedBox,
      name: 'SizedBox',
      category: WidgetCategory.layout,
      icon: Icons.crop_din,
      description: 'A box with a specified size.',
      tags: ['size', 'box', 'spacer'],
    ),

    // Input Widgets
    WidgetDefinition(
      type: FlutterWidgetType.textField,
      name: 'TextField',
      category: WidgetCategory.input,
      icon: Icons.text_fields,
      description: 'A text input field.',
      tags: ['input', 'text', 'form'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.elevatedButton,
      name: 'ElevatedButton',
      category: WidgetCategory.input,
      icon: Icons.smart_button,
      description: 'A Material Design elevated button.',
      tags: ['button', 'action', 'click'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.textButton,
      name: 'TextButton',
      category: WidgetCategory.input,
      icon: Icons.text_snippet,
      description: 'A Material Design text button.',
      tags: ['button', 'text', 'flat'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.outlinedButton,
      name: 'OutlinedButton',
      category: WidgetCategory.input,
      icon: Icons.border_style,
      description: 'A Material Design outlined button.',
      tags: ['button', 'outline', 'border'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.iconButton,
      name: 'IconButton',
      category: WidgetCategory.input,
      icon: Icons.radio_button_unchecked,
      description: 'A Material Design icon button.',
      tags: ['button', 'icon', 'action'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.floatingActionButton,
      name: 'FloatingActionButton',
      category: WidgetCategory.input,
      icon: Icons.add_circle,
      description: 'A Material Design floating action button.',
      tags: ['fab', 'floating', 'action'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.checkbox,
      name: 'Checkbox',
      category: WidgetCategory.input,
      icon: Icons.check_box,
      description: 'A Material Design checkbox.',
      tags: ['checkbox', 'boolean', 'form'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.radio,
      name: 'Radio',
      category: WidgetCategory.input,
      icon: Icons.radio_button_checked,
      description: 'A Material Design radio button.',
      tags: ['radio', 'choice', 'form'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.switchWidget,
      name: 'Switch',
      category: WidgetCategory.input,
      icon: Icons.toggle_on,
      description: 'A Material Design switch.',
      tags: ['switch', 'toggle', 'boolean'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.slider,
      name: 'Slider',
      category: WidgetCategory.input,
      icon: Icons.tune,
      description: 'A Material Design slider.',
      tags: ['slider', 'range', 'value'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.dropdownButton,
      name: 'DropdownButton',
      category: WidgetCategory.input,
      icon: Icons.arrow_drop_down,
      description: 'A Material Design dropdown button.',
      tags: ['dropdown', 'select', 'menu'],
    ),

    // Display Widgets
    WidgetDefinition(
      type: FlutterWidgetType.text,
      name: 'Text',
      category: WidgetCategory.display,
      icon: Icons.text_format,
      description: 'A run of text with a single style.',
      tags: ['text', 'label', 'content'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.richText,
      name: 'RichText',
      category: WidgetCategory.display,
      icon: Icons.format_color_text,
      description: 'A paragraph of rich text.',
      tags: ['rich', 'formatted', 'styled'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.image,
      name: 'Image',
      category: WidgetCategory.display,
      icon: Icons.image,
      description: 'A widget that displays an image.',
      tags: ['image', 'picture', 'media'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.icon,
      name: 'Icon',
      category: WidgetCategory.display,
      icon: Icons.star,
      description: 'A graphical icon widget.',
      tags: ['icon', 'symbol', 'graphic'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.card,
      name: 'Card',
      category: WidgetCategory.display,
      icon: Icons.credit_card,
      description: 'A Material Design card.',
      tags: ['card', 'surface', 'container'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.chip,
      name: 'Chip',
      category: WidgetCategory.display,
      icon: Icons.label,
      description: 'A Material Design chip.',
      tags: ['chip', 'tag', 'label'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.avatar,
      name: 'CircleAvatar',
      category: WidgetCategory.display,
      icon: Icons.account_circle,
      description: 'A circle that represents a user.',
      tags: ['avatar', 'profile', 'user'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.divider,
      name: 'Divider',
      category: WidgetCategory.display,
      icon: Icons.horizontal_rule,
      description: 'A thin horizontal line.',
      tags: ['divider', 'separator', 'line'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.progressIndicator,
      name: 'CircularProgressIndicator',
      category: WidgetCategory.display,
      icon: Icons.refresh,
      description: 'A circular progress indicator.',
      tags: ['progress', 'loading', 'spinner'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.linearProgressIndicator,
      name: 'LinearProgressIndicator',
      category: WidgetCategory.display,
      icon: Icons.linear_scale,
      description: 'A linear progress indicator.',
      tags: ['progress', 'loading', 'bar'],
    ),

    // Navigation Widgets
    WidgetDefinition(
      type: FlutterWidgetType.appBar,
      name: 'AppBar',
      category: WidgetCategory.navigation,
      icon: Icons.web_asset,
      description: 'A Material Design app bar.',
      tags: ['appbar', 'header', 'navigation'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.bottomNavigationBar,
      name: 'BottomNavigationBar',
      category: WidgetCategory.navigation,
      icon: Icons.navigation,
      description: 'A Material Design bottom navigation bar.',
      tags: ['bottom', 'navigation', 'tabs'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.drawer,
      name: 'Drawer',
      category: WidgetCategory.navigation,
      icon: Icons.menu,
      description: 'A Material Design drawer.',
      tags: ['drawer', 'sidebar', 'menu'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.tabBar,
      name: 'TabBar',
      category: WidgetCategory.navigation,
      icon: Icons.tab,
      description: 'A Material Design tab bar.',
      tags: ['tabs', 'navigation', 'switch'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.navigationRail,
      name: 'NavigationRail',
      category: WidgetCategory.navigation,
      icon: Icons.view_sidebar,
      description: 'A Material Design navigation rail.',
      tags: ['rail', 'sidebar', 'navigation'],
    ),

    // Scrolling Widgets
    WidgetDefinition(
      type: FlutterWidgetType.listView,
      name: 'ListView',
      category: WidgetCategory.scrolling,
      icon: Icons.list,
      description: 'A scrollable list of widgets.',
      tags: ['list', 'scroll', 'vertical'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.gridView,
      name: 'GridView',
      category: WidgetCategory.scrolling,
      icon: Icons.grid_view,
      description: 'A scrollable 2D array of widgets.',
      tags: ['grid', 'scroll', '2d'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.singleChildScrollView,
      name: 'SingleChildScrollView',
      category: WidgetCategory.scrolling,
      icon: Icons.swap_vert,
      description: 'A box in which a single widget can be scrolled.',
      tags: ['scroll', 'single', 'overflow'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.pageView,
      name: 'PageView',
      category: WidgetCategory.scrolling,
      icon: Icons.view_carousel,
      description: 'A scrollable list that works page by page.',
      tags: ['page', 'swipe', 'carousel'],
    ),

    // Advanced Widgets
    WidgetDefinition(
      type: FlutterWidgetType.animatedContainer,
      name: 'AnimatedContainer',
      category: WidgetCategory.advanced,
      icon: Icons.animation,
      description: 'Animated version of Container.',
      tags: ['animated', 'container', 'transition'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.hero,
      name: 'Hero',
      category: WidgetCategory.advanced,
      icon: Icons.flight_takeoff,
      description: 'A widget that marks its child as a hero.',
      tags: ['hero', 'transition', 'animation'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.gestureDetector,
      name: 'GestureDetector',
      category: WidgetCategory.advanced,
      icon: Icons.touch_app,
      description: 'A widget that detects gestures.',
      tags: ['gesture', 'touch', 'interaction'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.inkWell,
      name: 'InkWell',
      category: WidgetCategory.advanced,
      icon: Icons.touch_app,
      description: 'A rectangular area that responds to touch.',
      tags: ['inkwell', 'ripple', 'touch'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.opacity,
      name: 'Opacity',
      category: WidgetCategory.advanced,
      icon: Icons.opacity,
      description: 'A widget that makes its child partially transparent.',
      tags: ['opacity', 'transparent', 'fade'],
    ),
    WidgetDefinition(
      type: FlutterWidgetType.transform,
      name: 'Transform',
      category: WidgetCategory.advanced,
      icon: Icons.transform,
      description: 'A widget that applies a transformation before painting.',
      tags: ['transform', 'rotate', 'scale'],
    ),
  ];

  /// Get all widget definitions
  List<WidgetDefinition> get allWidgets => _allWidgets;

  /// Get filtered widgets based on search and category
  List<WidgetDefinition> get filteredWidgets {
    var widgets = _allWidgets;

    // Filter by category
    if (state.selectedCategory != null) {
      widgets = widgets.where((w) => w.category == state.selectedCategory).toList();
    }

    // Filter by search query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      widgets = widgets.where((w) {
        return w.name.toLowerCase().contains(query) ||
               w.description.toLowerCase().contains(query) ||
               w.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    return widgets;
  }

  /// Get widgets grouped by category
  Map<WidgetCategory, List<WidgetDefinition>> get widgetsByCategory {
    final grouped = <WidgetCategory, List<WidgetDefinition>>{};
    
    for (final widget in filteredWidgets) {
      grouped[widget.category] = [...(grouped[widget.category] ?? []), widget];
    }
    
    return grouped;
  }

  /// Set search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Set selected category
  void setSelectedCategory(WidgetCategory? category) {
    state = state.copyWith(selectedCategory: category);
  }

  /// Clear category filter
  void clearCategoryFilter() {
    state = state.copyWith(selectedCategory: null);
  }

  /// Toggle library expansion
  void toggleExpansion() {
    state = state.copyWith(isExpanded: !state.isExpanded);
  }

  /// Create widget model from definition
  WidgetModel createWidgetFromDefinition(
    WidgetDefinition definition,
    Offset position,
  ) {
    return WidgetModel.create(
      type: definition.type,
      position: position,
    );
  }

  /// Get widget definition by type
  WidgetDefinition? getDefinitionByType(FlutterWidgetType type) {
    try {
      return _allWidgets.firstWhere((w) => w.type == type);
    } catch (e) {
      return null;
    }
  }
}

/// Widget library provider
final widgetLibraryProvider = StateNotifierProvider<WidgetLibraryNotifier, WidgetLibraryState>((ref) {
  return WidgetLibraryNotifier();
});

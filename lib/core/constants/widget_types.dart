import 'package:flutter/material.dart';

/// Widget categories for the widget library
enum WidgetCategory {
  layout('Layout', Icons.view_quilt),
  input('Input', Icons.input),
  display('Display', Icons.text_fields),
  navigation('Navigation', Icons.navigation),
  scrolling('Scrolling', Icons.view_list),
  advanced('Advanced', Icons.extension);

  const WidgetCategory(this.displayName, this.icon);
  final String displayName;
  final IconData icon;
}

/// Flutter widget types supported by the platform
enum FlutterWidgetType {
  // Layout Widgets
  container('Container', WidgetCategory.layout),
  row('Row', WidgetCategory.layout),
  column('Column', WidgetCategory.layout),
  stack('Stack', WidgetCategory.layout),
  wrap('Wrap', WidgetCategory.layout),
  expanded('Expanded', WidgetCategory.layout),
  flexible('Flexible', WidgetCategory.layout),
  positioned('Positioned', WidgetCategory.layout),
  align('Align', WidgetCategory.layout),
  center('Center', WidgetCategory.layout),
  padding('Padding', WidgetCategory.layout),
  sizedBox('SizedBox', WidgetCategory.layout),
  spacer('Spacer', WidgetCategory.layout),
  verticalDivider('Vertical Divider', WidgetCategory.layout),

  // Input Widgets
  textField('TextField', WidgetCategory.input),
  elevatedButton('ElevatedButton', WidgetCategory.input),
  textButton('TextButton', WidgetCategory.input),
  outlinedButton('OutlinedButton', WidgetCategory.input),
  iconButton('IconButton', WidgetCategory.input),
  floatingActionButton('FloatingActionButton', WidgetCategory.input),
  checkbox('Checkbox', WidgetCategory.input),
  radio('Radio', WidgetCategory.input),
  switchWidget('Switch', WidgetCategory.input),
  slider('Slider', WidgetCategory.input),
  dropdownButton('DropdownButton', WidgetCategory.input),

  // Display Widgets
  text('Text', WidgetCategory.display),
  richText('RichText', WidgetCategory.display),
  image('Image', WidgetCategory.display),
  icon('Icon', WidgetCategory.display),
  card('Card', WidgetCategory.display),
  chip('Chip', WidgetCategory.display),
  avatar('CircleAvatar', WidgetCategory.display),
  divider('Divider', WidgetCategory.display),
  circularProgressIndicator(
    'CircularProgressIndicator',
    WidgetCategory.display,
  ),
  progressIndicator('ProgressIndicator', WidgetCategory.display),
  linearProgressIndicator('LinearProgressIndicator', WidgetCategory.display),
  tooltip('Tooltip', WidgetCategory.display),
  listTile('ListTile', WidgetCategory.display),

  // Navigation Widgets
  appBar('AppBar', WidgetCategory.navigation),
  bottomNavigationBar('BottomNavigationBar', WidgetCategory.navigation),
  drawer('Drawer', WidgetCategory.navigation),
  tabBar('TabBar', WidgetCategory.navigation),
  navigationRail('NavigationRail', WidgetCategory.navigation),
  scaffold('Scaffold', WidgetCategory.navigation),
  tabBarView('TabBarView', WidgetCategory.navigation),
  bottomSheet('BottomSheet', WidgetCategory.navigation),

  // Scrolling Widgets
  listView('ListView', WidgetCategory.scrolling),
  gridView('GridView', WidgetCategory.scrolling),
  singleChildScrollView('SingleChildScrollView', WidgetCategory.scrolling),
  pageView('PageView', WidgetCategory.scrolling),
  customScrollView('CustomScrollView', WidgetCategory.scrolling),

  // Advanced Widgets
  animatedContainer('AnimatedContainer', WidgetCategory.advanced),
  hero('Hero', WidgetCategory.advanced),
  gestureDetector('GestureDetector', WidgetCategory.advanced),
  inkWell('InkWell', WidgetCategory.advanced),
  opacity('Opacity', WidgetCategory.advanced),
  fadeTransition('FadeTransition', WidgetCategory.advanced),
  transform('Transform', WidgetCategory.advanced);

  const FlutterWidgetType(this.displayName, this.category);
  final String displayName;
  final WidgetCategory category;
}

/// Property types for widget configuration
enum PropertyType {
  text('Text'),
  number('Number'),
  boolean('Boolean'),
  color('Color'),
  dropdown('Dropdown'),
  alignment('Alignment'),
  edgeInsets('EdgeInsets'),
  borderRadius('BorderRadius'),
  boxShadow('BoxShadow'),
  textStyle('TextStyle'),
  icon('Icon'),
  image('Image'),
  list('List');

  const PropertyType(this.displayName);
  final String displayName;
}

/// Alignment options for widgets
enum AlignmentOption {
  topLeft(Alignment.topLeft, 'Top Left'),
  topCenter(Alignment.topCenter, 'Top Center'),
  topRight(Alignment.topRight, 'Top Right'),
  centerLeft(Alignment.centerLeft, 'Center Left'),
  center(Alignment.center, 'Center'),
  centerRight(Alignment.centerRight, 'Center Right'),
  bottomLeft(Alignment.bottomLeft, 'Bottom Left'),
  bottomCenter(Alignment.bottomCenter, 'Bottom Center'),
  bottomRight(Alignment.bottomRight, 'Bottom Right');

  const AlignmentOption(this.alignment, this.displayName);
  final Alignment alignment;
  final String displayName;
}

/// Main axis alignment options
enum MainAxisAlignmentOption {
  start(MainAxisAlignment.start, 'Start'),
  end(MainAxisAlignment.end, 'End'),
  center(MainAxisAlignment.center, 'Center'),
  spaceBetween(MainAxisAlignment.spaceBetween, 'Space Between'),
  spaceAround(MainAxisAlignment.spaceAround, 'Space Around'),
  spaceEvenly(MainAxisAlignment.spaceEvenly, 'Space Evenly');

  const MainAxisAlignmentOption(this.alignment, this.displayName);
  final MainAxisAlignment alignment;
  final String displayName;
}

/// Cross axis alignment options
enum CrossAxisAlignmentOption {
  start(CrossAxisAlignment.start, 'Start'),
  end(CrossAxisAlignment.end, 'End'),
  center(CrossAxisAlignment.center, 'Center'),
  stretch(CrossAxisAlignment.stretch, 'Stretch'),
  baseline(CrossAxisAlignment.baseline, 'Baseline');

  const CrossAxisAlignmentOption(this.alignment, this.displayName);
  final CrossAxisAlignment alignment;
  final String displayName;
}

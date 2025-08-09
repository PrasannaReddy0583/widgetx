import 'package:flutter/material.dart';
import '../../models/widget_model.dart';
import '../../core/constants/widget_types.dart';

/// Renders WidgetModel instances as actual Flutter widgets
class FlutterWidgetRenderer {
  /// Renders a widget model as a Flutter widget with proper hierarchy support
  static Widget render(WidgetModel model, {
    bool isSelected = false,
    VoidCallback? onTap,
    List<WidgetModel> children = const [],
    bool applyPositioning = true,
  }) {
    Widget child;
    
    try {
      // Use the model's own children if available, otherwise use provided children
      final effectiveChildren = model.children.isNotEmpty ? model.children : children;
      
      switch (model.type) {
        case FlutterWidgetType.container:
          child = _renderContainer(model, effectiveChildren);
          break;
        case FlutterWidgetType.text:
          child = _renderText(model);
          break;
        case FlutterWidgetType.elevatedButton:
          child = _renderElevatedButton(model, effectiveChildren);
          break;
        case FlutterWidgetType.row:
          child = _renderRow(model, effectiveChildren);
          break;
        case FlutterWidgetType.column:
          child = _renderColumn(model, effectiveChildren);
          break;
        case FlutterWidgetType.stack:
          child = _renderStack(model, effectiveChildren);
          break;
        case FlutterWidgetType.textField:
          child = _renderTextField(model);
          break;
        case FlutterWidgetType.image:
          child = _renderImage(model);
          break;
        case FlutterWidgetType.icon:
          child = _renderIcon(model);
          break;
        case FlutterWidgetType.listView:
          child = _renderListView(model, effectiveChildren);
          break;
        case FlutterWidgetType.gridView:
          child = _renderGridView(model, effectiveChildren);
          break;
        case FlutterWidgetType.card:
          child = _renderCard(model, effectiveChildren);
          break;
        case FlutterWidgetType.padding:
          child = _renderPadding(model, effectiveChildren);
          break;
        case FlutterWidgetType.center:
          child = _renderCenter(model, effectiveChildren);
          break;
        case FlutterWidgetType.align:
          child = _renderAlign(model, effectiveChildren);
          break;
        case FlutterWidgetType.sizedBox:
          child = _renderSizedBox(model, effectiveChildren);
          break;
        case FlutterWidgetType.expanded:
          child = _renderExpanded(model, effectiveChildren);
          break;
        case FlutterWidgetType.flexible:
          child = _renderFlexible(model, effectiveChildren);
          break;
        case FlutterWidgetType.wrap:
          child = _renderWrap(model, effectiveChildren);
          break;
        case FlutterWidgetType.scaffold:
          child = _renderScaffold(model, effectiveChildren);
          break;
        case FlutterWidgetType.appBar:
          child = _renderAppBar(model, effectiveChildren);
          break;
        default:
          child = _renderFallback(model);
      }
    } catch (e) {
      // Fallback for any rendering errors
      child = _renderError(model, e.toString());
    }

    // Apply opacity if specified
    if (model.opacity < 1.0) {
      child = Opacity(
        opacity: model.opacity,
        child: child,
      );
    }

    // Apply rotation if specified
    if (model.rotation != 0.0) {
      child = Transform.rotate(
        angle: model.rotation,
        child: child,
      );
    }

    // Wrap with selection indicator if selected
    if (isSelected) {
      child = _wrapWithSelection(child);
    }

    // Wrap with gesture detector for interaction
    if (onTap != null) {
      child = GestureDetector(
        onTap: onTap,
        child: child,
      );
    }

    // Apply positioning only if requested and position is not zero
    if (applyPositioning && model.position != Offset.zero && model.parentId == null) {
      child = Positioned(
        left: model.position.dx,
        top: model.position.dy,
        child: child,
      );
    }

    // Apply visibility
    if (!model.isVisible) {
      child = Visibility(
        visible: false,
        child: child,
      );
    }

    return child;
  }

  // Container widget renderer
  static Widget _renderContainer(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return Container(
      width: _getDoubleProperty(properties, 'width'),
      height: _getDoubleProperty(properties, 'height'),
      padding: _getEdgeInsetsProperty(properties, 'padding'),
      margin: _getEdgeInsetsProperty(properties, 'margin'),
      decoration: BoxDecoration(
        color: _getColorProperty(properties, 'color'),
        borderRadius: BorderRadius.circular(
          _getDoubleProperty(properties, 'borderRadius') ?? 0.0,
        ),
        border: _getBorderProperty(properties),
      ),
      alignment: _getAlignmentProperty(properties, 'alignment'),
      child: children.isEmpty ? null : _buildChildWidget(children),
    );
  }

  // Text widget renderer
  static Widget _renderText(WidgetModel model) {
    final properties = model.properties;
    
    return Text(
      _getStringProperty(properties, 'text', 'Text'),
      style: TextStyle(
        fontSize: _getDoubleProperty(properties, 'fontSize', 16.0),
        color: _getColorProperty(properties, 'color') ?? Colors.black,
        fontWeight: _getFontWeightProperty(properties, 'fontWeight'),
      ),
      textAlign: _getTextAlignProperty(properties, 'textAlign'),
      maxLines: _getIntProperty(properties, 'maxLines'),
      overflow: _getIntProperty(properties, 'maxLines') != null 
        ? TextOverflow.ellipsis 
        : null,
    );
  }

  // ElevatedButton widget renderer
  static Widget _renderElevatedButton(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return ElevatedButton(
      onPressed: () {
        // Handle button press
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _getColorProperty(properties, 'backgroundColor'),
        foregroundColor: _getColorProperty(properties, 'foregroundColor'),
        elevation: _getDoubleProperty(properties, 'elevation') ?? 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            _getDoubleProperty(properties, 'borderRadius') ?? 8.0,
          ),
        ),
        padding: _getEdgeInsetsProperty(properties, 'padding'),
      ),
      child: children.isNotEmpty 
        ? _buildChildWidget(children)
        : Text(_getStringProperty(properties, 'text', 'Button')),
    );
  }

  // Row widget renderer
  static Widget _renderRow(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return Row(
      mainAxisAlignment: _getMainAxisAlignmentProperty(properties, 'mainAxisAlignment'),
      crossAxisAlignment: _getCrossAxisAlignmentProperty(properties, 'crossAxisAlignment'),
      mainAxisSize: _getMainAxisSizeProperty(properties, 'mainAxisSize'),
      children: children.map((child) => render(child)).toList(),
    );
  }

  // Column widget renderer
  static Widget _renderColumn(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return Column(
      mainAxisAlignment: _getMainAxisAlignmentProperty(properties, 'mainAxisAlignment'),
      crossAxisAlignment: _getCrossAxisAlignmentProperty(properties, 'crossAxisAlignment'),
      mainAxisSize: _getMainAxisSizeProperty(properties, 'mainAxisSize'),
      children: children.map((child) => render(child)).toList(),
    );
  }

  // Stack widget renderer
  static Widget _renderStack(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return Stack(
      alignment: _getAlignmentProperty(properties, 'alignment') ?? Alignment.topLeft,
      fit: _getStackFitProperty(properties, 'fit'),
      children: children.map((child) => render(child)).toList(),
    );
  }

  // TextField widget renderer
  static Widget _renderTextField(WidgetModel model) {
    final properties = model.properties;
    
    return TextField(
      decoration: InputDecoration(
        hintText: _getStringProperty(properties, 'hintText'),
        labelText: _getStringProperty(properties, 'labelText'),
        filled: _getBoolProperty(properties, 'filled', false),
        fillColor: _getColorProperty(properties, 'fillColor'),
        border: _getInputBorderProperty(properties, 'borderType'),
      ),
      obscureText: _getBoolProperty(properties, 'obscureText', false),
      maxLines: _getIntProperty(properties, 'maxLines') ?? 1,
    );
  }

  // Image widget renderer
  static Widget _renderImage(WidgetModel model) {
    final properties = model.properties;
    final src = _getStringProperty(properties, 'src', '');
    
    if (src.isEmpty) {
      return Container(
        width: _getDoubleProperty(properties, 'width', 150.0),
        height: _getDoubleProperty(properties, 'height', 150.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.image, color: Colors.grey, size: 48),
        ),
      );
    }

    BoxFit? fit = _getBoxFitProperty(properties, 'fit');
    
    if (src.startsWith('http')) {
      return Image.network(
        src,
        width: _getDoubleProperty(properties, 'width'),
        height: _getDoubleProperty(properties, 'height'),
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          width: _getDoubleProperty(properties, 'width', 150.0),
          height: _getDoubleProperty(properties, 'height', 150.0),
          color: Colors.red[100],
          child: const Icon(Icons.error, color: Colors.red),
        ),
      );
    } else {
      return Image.asset(
        src,
        width: _getDoubleProperty(properties, 'width'),
        height: _getDoubleProperty(properties, 'height'),
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          width: _getDoubleProperty(properties, 'width', 150.0),
          height: _getDoubleProperty(properties, 'height', 150.0),
          color: Colors.grey[300],
          child: const Icon(Icons.image, color: Colors.grey, size: 48),
        ),
      );
    }
  }

  // Icon widget renderer
  static Widget _renderIcon(WidgetModel model) {
    final properties = model.properties;
    final iconCodePoint = _getIntProperty(properties, 'icon') ?? Icons.star.codePoint;
    
    return Icon(
      IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
      size: _getDoubleProperty(properties, 'size', 24.0),
      color: _getColorProperty(properties, 'color'),
    );
  }

  // ListView widget renderer
  static Widget _renderListView(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return ListView(
      scrollDirection: _getAxisProperty(properties, 'scrollDirection'),
      padding: _getEdgeInsetsProperty(properties, 'padding'),
      children: children.map((child) => render(child)).toList(),
    );
  }

  // Card widget renderer
  static Widget _renderCard(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return Card(
      elevation: _getDoubleProperty(properties, 'elevation', 1.0),
      margin: _getEdgeInsetsProperty(properties, 'margin'),
      color: _getColorProperty(properties, 'color'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          _getDoubleProperty(properties, 'borderRadius') ?? 4.0,
        ),
      ),
      child: children.isEmpty ? null : _buildChildWidget(children),
    );
  }

  // Padding widget renderer
  static Widget _renderPadding(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return Padding(
      padding: _getEdgeInsetsProperty(properties, 'padding') ?? EdgeInsets.zero,
      child: children.isEmpty ? const SizedBox() : _buildChildWidget(children),
    );
  }

  // Center widget renderer
  static Widget _renderCenter(WidgetModel model, List<WidgetModel> children) {
    return Center(
      child: children.isEmpty ? const SizedBox() : _buildChildWidget(children),
    );
  }

  // SizedBox widget renderer
  static Widget _renderSizedBox(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return SizedBox(
      width: _getDoubleProperty(properties, 'width'),
      height: _getDoubleProperty(properties, 'height'),
      child: children.isEmpty ? null : _buildChildWidget(children),
    );
  }

  // GridView widget renderer
  static Widget _renderGridView(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return GridView.count(
      crossAxisCount: _getIntProperty(properties, 'crossAxisCount') ?? 2,
      mainAxisSpacing: _getDoubleProperty(properties, 'mainAxisSpacing') ?? 8.0,
      crossAxisSpacing: _getDoubleProperty(properties, 'crossAxisSpacing') ?? 8.0,
      childAspectRatio: _getDoubleProperty(properties, 'childAspectRatio') ?? 1.0,
      padding: _getEdgeInsetsProperty(properties, 'padding'),
      children: children.map((child) => render(child, applyPositioning: false)).toList(),
    );
  }

  // Align widget renderer
  static Widget _renderAlign(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return Align(
      alignment: _getAlignmentProperty(properties, 'alignment') ?? Alignment.center,
      child: children.isEmpty ? const SizedBox() : _buildChildWidget(children),
    );
  }

  // Expanded widget renderer
  static Widget _renderExpanded(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return Expanded(
      flex: _getIntProperty(properties, 'flex') ?? 1,
      child: children.isEmpty ? const SizedBox() : _buildChildWidget(children),
    );
  }

  // Flexible widget renderer
  static Widget _renderFlexible(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return Flexible(
      flex: _getIntProperty(properties, 'flex') ?? 1,
      fit: _getFlexFitProperty(properties, 'fit'),
      child: children.isEmpty ? const SizedBox() : _buildChildWidget(children),
    );
  }

  // Wrap widget renderer
  static Widget _renderWrap(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return Wrap(
      direction: _getAxisProperty(properties, 'direction'),
      alignment: _getWrapAlignmentProperty(properties, 'alignment'),
      spacing: _getDoubleProperty(properties, 'spacing') ?? 0.0,
      runSpacing: _getDoubleProperty(properties, 'runSpacing') ?? 0.0,
      children: children.map((child) => render(child, applyPositioning: false)).toList(),
    );
  }

  // Scaffold widget renderer
  static Widget _renderScaffold(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    // Find specific children types
    final appBar = children.where((child) => child.type == FlutterWidgetType.appBar).firstOrNull;
    final body = children.where((child) => child.type != FlutterWidgetType.appBar && child.type != FlutterWidgetType.bottomNavigationBar).firstOrNull;
    final bottomNavBar = children.where((child) => child.type == FlutterWidgetType.bottomNavigationBar).firstOrNull;
    
    return Scaffold(
      backgroundColor: _getColorProperty(properties, 'backgroundColor'),
      appBar: appBar != null ? _renderAppBar(appBar, []) as PreferredSizeWidget : null,
      body: body != null ? render(body, applyPositioning: false) : const SizedBox(),
      bottomNavigationBar: bottomNavBar != null ? render(bottomNavBar, applyPositioning: false) : null,
      floatingActionButton: _getBoolProperty(properties, 'hasFloatingActionButton', false)
          ? FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  // AppBar widget renderer
  static Widget _renderAppBar(WidgetModel model, List<WidgetModel> children) {
    final properties = model.properties;
    
    return AppBar(
      title: Text(_getStringProperty(properties, 'title', 'App Bar')),
      backgroundColor: _getColorProperty(properties, 'backgroundColor'),
      foregroundColor: _getColorProperty(properties, 'foregroundColor'),
      elevation: _getDoubleProperty(properties, 'elevation', 4.0),
      centerTitle: _getBoolProperty(properties, 'centerTitle', false),
      actions: children.isNotEmpty 
        ? children.map((child) => render(child, applyPositioning: false)).toList()
        : null,
    );
  }

  // Build child widget from children list
  static Widget _buildChildWidget(List<WidgetModel> children) {
    if (children.isEmpty) return const SizedBox();
    if (children.length == 1) return render(children.first);
    
    // Multiple children - wrap in Column by default
    return Column(
      children: children.map((child) => render(child)).toList(),
    );
  }

  // Fallback renderer
  static Widget _renderFallback(WidgetModel model) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          model.type.displayName,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Error renderer
  static Widget _renderError(WidgetModel model, String error) {
    return Container(
      width: 150,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.red[100],
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 20),
          Text(
            model.type.displayName,
            style: const TextStyle(fontSize: 10, color: Colors.red),
          ),
          Text(
            'Error: $error',
            style: const TextStyle(fontSize: 8, color: Colors.red),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Selection wrapper
  static Widget _wrapWithSelection(Widget child) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }

  // Property getters with type safety
  static String _getStringProperty(Map<String, dynamic> props, String key, [String? defaultValue]) {
    return props[key]?.toString() ?? defaultValue ?? '';
  }

  static double? _getDoubleProperty(Map<String, dynamic> props, String key, [double? defaultValue]) {
    final value = props[key];
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static int? _getIntProperty(Map<String, dynamic> props, String key, [int? defaultValue]) {
    final value = props[key];
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  static bool _getBoolProperty(Map<String, dynamic> props, String key, [bool defaultValue = false]) {
    final value = props[key];
    if (value == null) return defaultValue;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return defaultValue;
  }

  static Color? _getColorProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return null;
    if (value is Color) return value;
    if (value is int) return Color(value);
    if (value is String) {
      if (value.startsWith('#')) {
        final hex = value.substring(1);
        return Color(int.parse(hex, radix: 16) | 0xFF000000);
      }
    }
    return null;
  }

  static EdgeInsets? _getEdgeInsetsProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return null;
    if (value is EdgeInsets) return value;
    if (value is double || value is int) {
      return EdgeInsets.all(value.toDouble());
    }
    if (value is Map) {
      return EdgeInsets.fromLTRB(
        (value['left'] as num?)?.toDouble() ?? 0,
        (value['top'] as num?)?.toDouble() ?? 0,
        (value['right'] as num?)?.toDouble() ?? 0,
        (value['bottom'] as num?)?.toDouble() ?? 0,
      );
    }
    return null;
  }

  static Alignment? _getAlignmentProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return null;
    if (value is Alignment) return value;
    
    switch (value.toString().toLowerCase()) {
      case 'topleft': return Alignment.topLeft;
      case 'topcenter': return Alignment.topCenter;
      case 'topright': return Alignment.topRight;
      case 'centerleft': return Alignment.centerLeft;
      case 'center': return Alignment.center;
      case 'centerright': return Alignment.centerRight;
      case 'bottomleft': return Alignment.bottomLeft;
      case 'bottomcenter': return Alignment.bottomCenter;
      case 'bottomright': return Alignment.bottomRight;
      default: return null;
    }
  }

  static FontWeight _getFontWeightProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return FontWeight.normal;
    
    switch (value.toString().toLowerCase()) {
      case 'bold': return FontWeight.bold;
      case 'w100': return FontWeight.w100;
      case 'w200': return FontWeight.w200;
      case 'w300': return FontWeight.w300;
      case 'w400': return FontWeight.w400;
      case 'w500': return FontWeight.w500;
      case 'w600': return FontWeight.w600;
      case 'w700': return FontWeight.w700;
      case 'w800': return FontWeight.w800;
      case 'w900': return FontWeight.w900;
      default: return FontWeight.normal;
    }
  }

  static TextAlign _getTextAlignProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return TextAlign.left;
    
    switch (value.toString().toLowerCase()) {
      case 'left': return TextAlign.left;
      case 'center': return TextAlign.center;
      case 'right': return TextAlign.right;
      case 'justify': return TextAlign.justify;
      default: return TextAlign.left;
    }
  }

  static MainAxisAlignment _getMainAxisAlignmentProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return MainAxisAlignment.start;
    
    switch (value.toString().toLowerCase()) {
      case 'start': return MainAxisAlignment.start;
      case 'end': return MainAxisAlignment.end;
      case 'center': return MainAxisAlignment.center;
      case 'spacebetween': return MainAxisAlignment.spaceBetween;
      case 'spacearound': return MainAxisAlignment.spaceAround;
      case 'spaceevenly': return MainAxisAlignment.spaceEvenly;
      default: return MainAxisAlignment.start;
    }
  }

  static CrossAxisAlignment _getCrossAxisAlignmentProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return CrossAxisAlignment.center;
    
    switch (value.toString().toLowerCase()) {
      case 'start': return CrossAxisAlignment.start;
      case 'end': return CrossAxisAlignment.end;
      case 'center': return CrossAxisAlignment.center;
      case 'stretch': return CrossAxisAlignment.stretch;
      case 'baseline': return CrossAxisAlignment.baseline;
      default: return CrossAxisAlignment.center;
    }
  }

  static MainAxisSize _getMainAxisSizeProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return MainAxisSize.max;
    
    switch (value.toString().toLowerCase()) {
      case 'max': return MainAxisSize.max;
      case 'min': return MainAxisSize.min;
      default: return MainAxisSize.max;
    }
  }

  static StackFit _getStackFitProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return StackFit.loose;
    
    switch (value.toString().toLowerCase()) {
      case 'loose': return StackFit.loose;
      case 'expand': return StackFit.expand;
      case 'passthrough': return StackFit.passthrough;
      default: return StackFit.loose;
    }
  }

  static Axis _getAxisProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return Axis.vertical;
    
    switch (value.toString().toLowerCase()) {
      case 'horizontal': return Axis.horizontal;
      case 'vertical': return Axis.vertical;
      default: return Axis.vertical;
    }
  }

  static BoxFit? _getBoxFitProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return null;
    
    switch (value.toString().toLowerCase()) {
      case 'contain': return BoxFit.contain;
      case 'cover': return BoxFit.cover;
      case 'fill': return BoxFit.fill;
      case 'fitwidth': return BoxFit.fitWidth;
      case 'fitheight': return BoxFit.fitHeight;
      case 'none': return BoxFit.none;
      case 'scaledown': return BoxFit.scaleDown;
      default: return BoxFit.cover;
    }
  }

  static Border? _getBorderProperty(Map<String, dynamic> props) {
    final borderColor = _getColorProperty(props, 'borderColor');
    final borderWidth = _getDoubleProperty(props, 'borderWidth', 0.0);
    
    if (borderColor != null && borderWidth != null && borderWidth > 0) {
      return Border.all(color: borderColor, width: borderWidth);
    }
    return null;
  }

  static InputBorder? _getInputBorderProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return const OutlineInputBorder();
    
    switch (value.toString().toLowerCase()) {
      case 'outline': return const OutlineInputBorder();
      case 'underline': return const UnderlineInputBorder();
      case 'none': return InputBorder.none;
      default: return const OutlineInputBorder();
    }
  }

  static FlexFit _getFlexFitProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return FlexFit.loose;
    
    switch (value.toString().toLowerCase()) {
      case 'tight': return FlexFit.tight;
      case 'loose': return FlexFit.loose;
      default: return FlexFit.loose;
    }
  }

  static WrapAlignment _getWrapAlignmentProperty(Map<String, dynamic> props, String key) {
    final value = props[key];
    if (value == null) return WrapAlignment.start;
    
    switch (value.toString().toLowerCase()) {
      case 'start': return WrapAlignment.start;
      case 'end': return WrapAlignment.end;
      case 'center': return WrapAlignment.center;
      case 'spacebetween': return WrapAlignment.spaceBetween;
      case 'spacearound': return WrapAlignment.spaceAround;
      case 'spaceevenly': return WrapAlignment.spaceEvenly;
      default: return WrapAlignment.start;
    }
  }
}

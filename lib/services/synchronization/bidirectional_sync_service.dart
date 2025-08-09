import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/widget_model.dart';
import '../../models/screen_model.dart';
import '../../models/ai_context.dart';
import '../../core/constants/widget_types.dart';
import '../../providers/canvas_provider.dart';
import '../../providers/properties_provider.dart';
import '../../providers/code_generation_provider.dart';
import '../ai/enhanced_ai_service.dart';

/// Bidirectional synchronization service that keeps all parts of the system in sync
class BidirectionalSyncService {
  static final BidirectionalSyncService _instance = BidirectionalSyncService._internal();
  factory BidirectionalSyncService() => _instance;
  BidirectionalSyncService._internal();

  final _syncController = StreamController<SyncEvent>.broadcast();
  Stream<SyncEvent> get syncStream => _syncController.stream;
  
  bool _isSyncing = false;
  Ref? _ref;
  
  void initialize(Ref ref) {
    _ref = ref;
  }

  /// Sync from UI changes to all other components
  Future<void> syncFromUI(ScreenModel screen, String? selectedWidgetId) async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      _syncController.add(SyncEvent.uiChanged(screen, selectedWidgetId));
      
      // Update properties if widget is selected
      if (selectedWidgetId != null) {
        final selectedWidget = _findWidget(screen, selectedWidgetId);
        if (selectedWidget != null) {
          await _syncToProperties(selectedWidget);
        }
      }
      
      // Generate code from UI
      await _syncToCode(screen);
      
      // Update widget tree
      await _syncToWidgetTree(screen);
      
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync from property changes to UI and code
  Future<void> syncFromProperties(WidgetModel updatedWidget) async {
    if (_isSyncing || _ref == null) return;
    _isSyncing = true;

    try {
      _syncController.add(SyncEvent.propertiesChanged(updatedWidget));
      
      // Update UI with new properties
      await _syncToUI(updatedWidget);
      
      // Update code generation
      final canvasState = _ref!.read(canvasProvider);
      if (canvasState.currentScreen != null) {
        await _syncToCode(canvasState.currentScreen!);
      }
      
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync from code changes to UI and properties
  Future<void> syncFromCode(String code) async {
    if (_isSyncing || _ref == null) return;
    _isSyncing = true;

    try {
      _syncController.add(SyncEvent.codeChanged(code));
      
      // Parse code and update UI
      await _syncCodeToUI(code);
      
    } finally {
      _isSyncing = false;
    }
  }

  /// Sync from widget tree changes to UI and code
  Future<void> syncFromWidgetTree(List<WidgetModel> widgets) async {
    if (_isSyncing || _ref == null) return;
    _isSyncing = true;

    try {
      _syncController.add(SyncEvent.widgetTreeChanged(widgets));
      
      // Update screen with new widget hierarchy
      final canvasNotifier = _ref!.read(canvasProvider.notifier);
      final currentScreen = _ref!.read(canvasProvider).currentScreen;
      
      if (currentScreen != null) {
        final updatedScreen = currentScreen.copyWith(widgets: widgets);
        canvasNotifier.setCurrentScreen(updatedScreen);
        
        // Generate code from new structure
        await _syncToCode(updatedScreen);
      }
      
    } finally {
      _isSyncing = false;
    }
  }

  // Private sync methods
  Future<void> _syncToProperties(WidgetModel widget) async {
    if (_ref == null) return;
    
    final propertiesNotifier = _ref!.read(propertiesProvider.notifier);
    propertiesNotifier.setSelectedWidget(widget);
  }

  Future<void> _syncToUI(WidgetModel updatedWidget) async {
    if (_ref == null) return;
    
    final canvasNotifier = _ref!.read(canvasProvider.notifier);
    canvasNotifier.updateWidget(updatedWidget);
  }

  Future<void> _syncToCode(ScreenModel screen) async {
    if (_ref == null) return;
    
    try {
      // Generate clean Flutter code from the widget tree
      final code = await _generateFlutterCode(screen);
      
      final codeNotifier = _ref!.read(codeGenerationProvider.notifier);
      codeNotifier.updateCode(code);
      
    } catch (e) {
      debugPrint('Error generating code: $e');
    }
  }

  Future<void> _syncToWidgetTree(ScreenModel screen) async {
    // Widget tree is automatically updated by the UI
    // This could trigger tree view updates
    _syncController.add(SyncEvent.widgetTreeUpdated(screen.widgets));
  }

  Future<void> _syncCodeToUI(String code) async {
    if (_ref == null) return;
    
    try {
      // Parse Flutter code and extract widget structure
      final widgets = await _parseCodeToWidgets(code);
      
      if (widgets.isNotEmpty) {
        final canvasNotifier = _ref!.read(canvasProvider.notifier);
        final currentScreen = _ref!.read(canvasProvider).currentScreen;
        
        if (currentScreen != null) {
          final updatedScreen = currentScreen.copyWith(widgets: widgets);
          canvasNotifier.setCurrentScreen(updatedScreen);
        }
      }
      
    } catch (e) {
      debugPrint('Error parsing code to UI: $e');
    }
  }

  // Code generation using AI
  Future<String> _generateFlutterCode(ScreenModel screen) async {
    try {
      // Create a comprehensive prompt for code generation
      final prompt = _buildCodeGenerationPrompt(screen);
      
      // Use AI service to generate clean, modular code
      final aiService = enhancedAIService;
      final code = await aiService.generateCodeWithContext(
        AIContext(userIntent: 'Generate code for screen: ${screen.name}'),
        [screen],
        {},
      );
      
      return _formatGeneratedCode(code, screen);
      
    } catch (e) {
      // Fallback to template-based generation
      return _generateCodeFromTemplate(screen);
    }
  }

  String _buildCodeGenerationPrompt(ScreenModel screen) {
    final buffer = StringBuffer();
    
    buffer.writeln('Generate clean, production-ready Flutter code for the following widget structure:');
    buffer.writeln('');
    buffer.writeln('Screen: ${screen.name}');
    buffer.writeln('Widgets: ${screen.widgets.length}');
    buffer.writeln('');
    
    // Build widget tree description
    buffer.writeln('Widget Tree Structure:');
    for (final widget in screen.widgets) {
      buffer.writeln(_describeWidget(widget, 0));
    }
    
    buffer.writeln('');
    buffer.writeln('Requirements:');
    buffer.writeln('- Use proper Flutter widget hierarchy');
    buffer.writeln('- Include proper imports');
    buffer.writeln('- Use StatelessWidget or StatefulWidget as appropriate');
    buffer.writeln('- Follow Flutter best practices');
    buffer.writeln('- Add proper documentation');
    buffer.writeln('- Use Material Design 3 where applicable');
    buffer.writeln('- Ensure responsive design');
    buffer.writeln('- Include proper error handling');
    
    return buffer.toString();
  }

  String _describeWidget(WidgetModel widget, int depth) {
    final indent = '  ' * depth;
    final buffer = StringBuffer();
    
    buffer.write('$indent- ${widget.type.displayName}');
    
    // Add key properties
    final props = widget.properties;
    if (props.isNotEmpty) {
      buffer.write(' (');
      final keyProps = <String>[];
      
      if (props.containsKey('text')) {
        keyProps.add('text: "${props['text']}"');
      }
      if (props.containsKey('width')) {
        keyProps.add('width: ${props['width']}');
      }
      if (props.containsKey('height')) {
        keyProps.add('height: ${props['height']}');
      }
      if (props.containsKey('color')) {
        keyProps.add('color: Color(${props['color']})');
      }
      
      buffer.write(keyProps.join(', '));
      buffer.write(')');
    }
    
    buffer.writeln();
    
    // Add children
    for (final child in widget.children) {
      buffer.write(_describeWidget(child, depth + 1));
    }
    
    return buffer.toString();
  }

  String _formatGeneratedCode(String rawCode, ScreenModel screen) {
    // Clean up the generated code
    String code = rawCode;
    
    // Remove code blocks if present
    if (code.contains('```dart')) {
      code = code.split('```dart')[1].split('```')[0];
    } else if (code.contains('```')) {
      code = code.split('```')[1];
    }
    
    // Add proper class structure if missing
    if (!code.contains('class ${screen.name}')) {
      code = _wrapInClass(code, screen.name);
    }
    
    // Add imports if missing
    if (!code.contains('import \'package:flutter/material.dart\'')) {
      code = 'import \'package:flutter/material.dart\';\n\n$code';
    }
    
    return code.trim();
  }

  String _wrapInClass(String widgetCode, String screenName) {
    return '''
class ${screenName}Widget extends StatelessWidget {
  const ${screenName}Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return $widgetCode;
  }
}
''';
  }

  // Template-based code generation fallback
  String _generateCodeFromTemplate(ScreenModel screen) {
    final buffer = StringBuffer();
    
    buffer.writeln('import \'package:flutter/material.dart\';');
    buffer.writeln('');
    buffer.writeln('class ${screen.name}Widget extends StatelessWidget {');
    buffer.writeln('  const ${screen.name}Widget({super.key});');
    buffer.writeln('');
    buffer.writeln('  @override');
    buffer.writeln('  Widget build(BuildContext context) {');
    buffer.writeln('    return Scaffold(');
    buffer.writeln('      body: ${_generateWidgetTree(screen.widgets, 3)},');
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');
    
    return buffer.toString();
  }

  String _generateWidgetTree(List<WidgetModel> widgets, int indent) {
    if (widgets.isEmpty) {
      return 'const SizedBox()';
    }
    
    if (widgets.length == 1) {
      return _generateSingleWidget(widgets.first, indent);
    }
    
    // Multiple widgets - wrap in Column
    final indentStr = '  ' * indent;
    final buffer = StringBuffer();
    
    buffer.writeln('Column(');
    buffer.writeln('${indentStr}children: [');
    
    for (final widget in widgets) {
      buffer.writeln('$indentStr  ${_generateSingleWidget(widget, indent + 2)},');
    }
    
    buffer.writeln('$indentStr],');
    buffer.write('$indentStr)');
    
    return buffer.toString();
  }

  String _generateSingleWidget(WidgetModel widget, int indent) {
    final props = widget.properties;
    
    switch (widget.type.name) {
      case 'container':
        return _generateContainer(widget, indent);
      case 'text':
        return _generateText(widget, indent);
      case 'elevatedButton':
        return _generateElevatedButton(widget, indent);
      case 'row':
        return _generateRow(widget, indent);
      case 'column':
        return _generateColumn(widget, indent);
      default:
        return '${widget.type.displayName}()';
    }
  }

  String _generateContainer(WidgetModel widget, int indent) {
    final props = widget.properties;
    final indentStr = '  ' * indent;
    final buffer = StringBuffer();
    
    buffer.write('Container(');
    
    final params = <String>[];
    
    if (props.containsKey('width')) {
      params.add('width: ${props['width']}');
    }
    if (props.containsKey('height')) {
      params.add('height: ${props['height']}');
    }
    if (props.containsKey('color')) {
      params.add('color: Color(${props['color']})');
    }
    if (props.containsKey('padding')) {
      params.add('padding: EdgeInsets.all(${props['padding']})');
    }
    
    if (widget.children.isNotEmpty) {
      params.add('child: ${_generateWidgetTree(widget.children, indent + 1)}');
    }
    
    if (params.isNotEmpty) {
      buffer.write('\n');
      for (int i = 0; i < params.length; i++) {
        buffer.write('$indentStr  ${params[i]}');
        if (i < params.length - 1) buffer.write(',');
        buffer.write('\n');
      }
      buffer.write('$indentStr');
    }
    
    buffer.write(')');
    return buffer.toString();
  }

  String _generateText(WidgetModel widget, int indent) {
    final props = widget.properties;
    final text = props['text'] ?? 'Text';
    
    final buffer = StringBuffer();
    buffer.write('Text(\'$text\'');
    
    if (props.containsKey('fontSize') || props.containsKey('color') || props.containsKey('fontWeight')) {
      buffer.write(', style: TextStyle(');
      
      final styleParams = <String>[];
      if (props.containsKey('fontSize')) {
        styleParams.add('fontSize: ${props['fontSize']}');
      }
      if (props.containsKey('color')) {
        styleParams.add('color: Color(${props['color']})');
      }
      if (props.containsKey('fontWeight')) {
        styleParams.add('fontWeight: FontWeight.${props['fontWeight']}');
      }
      
      buffer.write(styleParams.join(', '));
      buffer.write(')');
    }
    
    buffer.write(')');
    return buffer.toString();
  }

  String _generateElevatedButton(WidgetModel widget, int indent) {
    final props = widget.properties;
    final text = props['text'] ?? 'Button';
    
    return 'ElevatedButton(\n'
           '  onPressed: () {},\n'
           '  child: Text(\'$text\'),\n'
           ')';
  }

  String _generateRow(WidgetModel widget, int indent) {
    final indentStr = '  ' * indent;
    return 'Row(\n'
           '${indentStr}children: [\n'
           '${widget.children.map((child) => '$indentStr  ${_generateSingleWidget(child, indent + 2)},').join('\n')}\n'
           '${indentStr}],\n'
           '$indentStr)';
  }

  String _generateColumn(WidgetModel widget, int indent) {
    final indentStr = '  ' * indent;
    return 'Column(\n'
           '${indentStr}children: [\n'
           '${widget.children.map((child) => '$indentStr  ${_generateSingleWidget(child, indent + 2)},').join('\n')}\n'
           '${indentStr}],\n'
           '$indentStr)';
  }

  // Code parsing (simplified - in production, use a proper Dart parser)
  Future<List<WidgetModel>> _parseCodeToWidgets(String code) async {
    // This is a simplified parser - in production, use analyzer package
    final widgets = <WidgetModel>[];
    
    // Extract widget declarations from code
    final widgetPattern = RegExp(r'(\w+)\s*\([^}]*\)');
    final matches = widgetPattern.allMatches(code);
    
    double yOffset = 50;
    
    for (final match in matches) {
      final widgetName = match.group(1)?.toLowerCase();
      if (widgetName != null) {
        final type = _getWidgetTypeFromName(widgetName);
        if (type != null) {
          final widget = WidgetModel.create(
            type: type,
            position: Offset(50, yOffset),
          );
          widgets.add(widget);
          yOffset += 80;
        }
      }
    }
    
    return widgets;
  }

  FlutterWidgetType? _getWidgetTypeFromName(String name) {
    switch (name.toLowerCase()) {
      case 'container': return FlutterWidgetType.container;
      case 'text': return FlutterWidgetType.text;
      case 'elevatedbutton': return FlutterWidgetType.elevatedButton;
      case 'row': return FlutterWidgetType.row;
      case 'column': return FlutterWidgetType.column;
      case 'stack': return FlutterWidgetType.stack;
      default: return null;
    }
  }

  WidgetModel? _findWidget(ScreenModel screen, String widgetId) {
    return screen.widgets.where((w) => w.id == widgetId).firstOrNull;
  }

  void dispose() {
    _syncController.close();
  }
}

/// Sync event types for the bidirectional sync system
sealed class SyncEvent {
  const SyncEvent();
  
  factory SyncEvent.uiChanged(ScreenModel screen, String? selectedWidgetId) = UiChangedEvent;
  factory SyncEvent.propertiesChanged(WidgetModel widget) = PropertiesChangedEvent;
  factory SyncEvent.codeChanged(String code) = CodeChangedEvent;
  factory SyncEvent.widgetTreeChanged(List<WidgetModel> widgets) = WidgetTreeChangedEvent;
  factory SyncEvent.widgetTreeUpdated(List<WidgetModel> widgets) = WidgetTreeUpdatedEvent;
}

class UiChangedEvent extends SyncEvent {
  final ScreenModel screen;
  final String? selectedWidgetId;
  
  const UiChangedEvent(this.screen, this.selectedWidgetId);
}

class PropertiesChangedEvent extends SyncEvent {
  final WidgetModel widget;
  
  const PropertiesChangedEvent(this.widget);
}

class CodeChangedEvent extends SyncEvent {
  final String code;
  
  const CodeChangedEvent(this.code);
}

class WidgetTreeChangedEvent extends SyncEvent {
  final List<WidgetModel> widgets;
  
  const WidgetTreeChangedEvent(this.widgets);
}

class WidgetTreeUpdatedEvent extends SyncEvent {
  final List<WidgetModel> widgets;
  
  const WidgetTreeUpdatedEvent(this.widgets);
}

// Provider for the sync service
final bidirectionalSyncServiceProvider = Provider<BidirectionalSyncService>((ref) {
  final service = BidirectionalSyncService();
  service.initialize(ref);
  
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

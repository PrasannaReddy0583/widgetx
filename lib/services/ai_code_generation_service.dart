import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../models/screen_model.dart';
import '../models/widget_model.dart';
import '../core/constants/widget_types.dart';

/// AI-powered code generation service
class AICodeGenerationService {
  /// Generate complete Flutter project code
  static Future<GeneratedProject> generateProject(ProjectModel project) async {
    final analysis = _analyzeProject(project);

    return GeneratedProject(
      mainDart: _generateMainDart(project, analysis),
      screens: _generateScreens(project.screens, analysis),
      widgets: _generateCustomWidgets(project, analysis),
      models: _generateModels(project, analysis),
      services: _generateServices(project, analysis),
      pubspecYaml: _generatePubspecYaml(project, analysis),
      architecture: analysis.architecture,
      analysis: analysis,
    );
  }

  /// Analyze project to understand its purpose and structure
  static ProjectAnalysis _analyzeProject(ProjectModel project) {
    final screenTypes = <String>[];
    final widgetTypes = <FlutterWidgetType>{};
    final features = <String>[];

    // Analyze screens
    for (final screen in project.screens) {
      screenTypes.add(_classifyScreen(screen));
      for (final widget in screen.widgets) {
        widgetTypes.add(widget.type);
        _analyzeWidgetForFeatures(widget, features);
      }
    }

    final projectType = _determineProjectType(screenTypes, features);
    final architecture = _recommendArchitecture(
      project.screens.length,
      widgetTypes.length,
    );

    return ProjectAnalysis(
      projectType: projectType,
      architecture: architecture,
      screenTypes: screenTypes,
      features: features,
      complexity: _calculateComplexity(project),
      stateManagement: _recommendStateManagement(project),
      dependencies: _recommendDependencies(features),
    );
  }

  static String _generateMainDart(
    ProjectModel project,
    ProjectAnalysis analysis,
  ) {
    final mainScreen = project.mainScreen?.name ?? 'HomeScreen';

    return '''
import 'package:flutter/material.dart';
${analysis.stateManagement == StateManagement.riverpod ? "import 'package:flutter_riverpod/flutter_riverpod.dart';" : ''}
${analysis.stateManagement == StateManagement.bloc ? "import 'package:flutter_bloc/flutter_bloc.dart';" : ''}
import 'package:go_router/go_router.dart';

${project.screens.map((s) => "import 'presentation/screens/${_toSnakeCase(s.name)}_screen.dart';").join('\n')}
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(${analysis.stateManagement == StateManagement.riverpod ? 'ProviderScope(child: ' : ''}MyApp()${analysis.stateManagement == StateManagement.riverpod ? ')' : ''});
}

class MyApp extends ${analysis.stateManagement == StateManagement.riverpod ? 'ConsumerWidget' : 'StatelessWidget'} {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context${analysis.stateManagement == StateManagement.riverpod ? ', WidgetRef ref' : ''}) {
    return MaterialApp.router(
      title: '${project.name}',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
''';
  }

  static Map<String, String> _generateScreens(
    List<ScreenModel> screens,
    ProjectAnalysis analysis,
  ) {
    final generatedScreens = <String, String>{};

    for (final screen in screens) {
      final screenCode = _generateScreenCode(screen, analysis);
      generatedScreens['${_toSnakeCase(screen.name)}_screen.dart'] = screenCode;
    }

    return generatedScreens;
  }

  static String _generateScreenCode(
    ScreenModel screen,
    ProjectAnalysis analysis,
  ) {
    final className = '${_toPascalCase(screen.name)}Screen';
    final widgets = _generateWidgetTree(screen.widgets, 2);

    return '''
import 'package:flutter/material.dart';
${analysis.stateManagement == StateManagement.riverpod ? "import 'package:flutter_riverpod/flutter_riverpod.dart';" : ''}

class $className extends ${analysis.stateManagement == StateManagement.riverpod ? 'ConsumerWidget' : 'StatelessWidget'} {
  const $className({super.key});

  @override
  Widget build(BuildContext context${analysis.stateManagement == StateManagement.riverpod ? ', WidgetRef ref' : ''}) {
    return Scaffold(
      body: $widgets,
    );
  }
}
''';
  }

  static String _generateWidgetTree(List<WidgetModel> widgets, int indent) {
    if (widgets.isEmpty) {
      return 'const Center(child: Text("Empty Screen"))';
    }

    if (widgets.length == 1) {
      return _generateWidgetCode(widgets.first, indent);
    }

    return '''Column(
${' ' * indent}children: [
${widgets.map((w) => '${' ' * (indent + 2)}${_generateWidgetCode(w, indent + 2)},').join('\n')}
${' ' * indent}],
${' ' * (indent - 2)})''';
  }

  static String _generateWidgetCode(WidgetModel widget, int indent) {
    switch (widget.type) {
      case FlutterWidgetType.container:
        return _generateContainer(widget, indent);
      case FlutterWidgetType.text:
        return _generateText(widget);
      case FlutterWidgetType.elevatedButton:
        return _generateElevatedButton(widget);
      case FlutterWidgetType.row:
        return _generateRow(widget, indent);
      case FlutterWidgetType.column:
        return _generateColumn(widget, indent);
      default:
        return '${widget.type.displayName}()';
    }
  }

  static String _generateContainer(WidgetModel widget, int indent) {
    final props = widget.properties;
    final hasChild = widget.children.isNotEmpty;

    return '''Container(
${' ' * (indent + 2)}width: ${widget.size.width},
${' ' * (indent + 2)}height: ${widget.size.height},
${props['backgroundColor'] != null ? '${' ' * (indent + 2)}color: ${_colorToCode(props['backgroundColor'])},\n' : ''}${props['padding'] != null ? '${' ' * (indent + 2)}padding: ${_edgeInsetsToCode(props['padding'])},\n' : ''}${hasChild ? '${' ' * (indent + 2)}child: ${_generateWidgetTree(widget.children, indent + 2)},' : ''}
${' ' * indent})''';
  }

  static String _generateText(WidgetModel widget) {
    final text = widget.properties['text']?.toString() ?? 'Text';
    final fontSize = widget.properties['fontSize'];
    final color = widget.properties['color'];

    if (fontSize != null || color != null) {
      return '''Text(
  '$text',
  style: TextStyle(
${fontSize != null ? '    fontSize: $fontSize,\n' : ''}${color != null ? '    color: ${_colorToCode(color)},\n' : ''}  ),
)''';
    }

    return "Text('$text')";
  }

  static String _generateElevatedButton(WidgetModel widget) {
    final text = widget.properties['text']?.toString() ?? 'Button';

    return '''ElevatedButton(
  onPressed: () {
    // TODO: Implement button action
  },
  child: Text('$text'),
)''';
  }

  static String _generateRow(WidgetModel widget, int indent) {
    return '''Row(
${' ' * (indent + 2)}children: [
${widget.children.map((w) => '${' ' * (indent + 4)}${_generateWidgetCode(w, indent + 4)},').join('\n')}
${' ' * (indent + 2)}],
${' ' * indent})''';
  }

  static String _generateColumn(WidgetModel widget, int indent) {
    return '''Column(
${' ' * (indent + 2)}children: [
${widget.children.map((w) => '${' ' * (indent + 4)}${_generateWidgetCode(w, indent + 4)},').join('\n')}
${' ' * (indent + 2)}],
${' ' * indent})''';
  }

  // Helper methods
  static String _classifyScreen(ScreenModel screen) {
    final name = screen.name.toLowerCase();
    if (name.contains('login') || name.contains('auth')) {
      return 'authentication';
    }
    if (name.contains('home') || name.contains('main')) return 'home';
    if (name.contains('profile') || name.contains('account')) return 'profile';
    if (name.contains('settings')) return 'settings';
    if (name.contains('list') || name.contains('feed')) return 'list';
    return 'general';
  }

  static void _analyzeWidgetForFeatures(
    WidgetModel widget,
    List<String> features,
  ) {
    switch (widget.type) {
      case FlutterWidgetType.textField:
        if (!features.contains('forms')) features.add('forms');
        break;
      case FlutterWidgetType.listView:
        if (!features.contains('lists')) features.add('lists');
        break;
      case FlutterWidgetType.image:
        if (!features.contains('images')) features.add('images');
        break;
      case FlutterWidgetType.elevatedButton:
      case FlutterWidgetType.textButton:
        if (!features.contains('interactions')) features.add('interactions');
        break;
      default:
        break;
    }
  }

  static String _determineProjectType(
    List<String> screenTypes,
    List<String> features,
  ) {
    if (screenTypes.contains('authentication') &&
        screenTypes.contains('profile')) {
      return 'Social/User App';
    }
    if (features.contains('lists') && features.contains('forms')) {
      return 'Business/Productivity App';
    }
    if (screenTypes.contains('home') && features.contains('interactions')) {
      return 'General Purpose App';
    }
    return 'Custom App';
  }

  static Architecture _recommendArchitecture(int screenCount, int widgetCount) {
    if (screenCount > 5 || widgetCount > 50) {
      return Architecture.cleanArchitecture;
    } else if (screenCount > 2) {
      return Architecture.mvvm;
    }
    return Architecture.simple;
  }

  static int _calculateComplexity(ProjectModel project) {
    int complexity = 0;
    complexity += project.screens.length * 2;
    for (final screen in project.screens) {
      complexity += screen.widgets.length;
    }
    return complexity;
  }

  static StateManagement _recommendStateManagement(ProjectModel project) {
    final complexity = _calculateComplexity(project);
    if (complexity > 50) return StateManagement.bloc;
    if (complexity > 20) return StateManagement.riverpod;
    return StateManagement.setState;
  }

  static List<String> _recommendDependencies(List<String> features) {
    final deps = <String>['flutter', 'go_router'];
    if (features.contains('forms')) deps.add('flutter_form_builder');
    if (features.contains('images')) deps.add('cached_network_image');
    if (features.contains('lists')) deps.add('flutter_staggered_grid_view');
    return deps;
  }

  // Code generation helpers
  static String _colorToCode(dynamic color) {
    if (color is Color) {
      return 'Color(0x${color.value.toRadixString(16).padLeft(8, '0')})';
    }
    return 'Colors.black';
  }

  static String _edgeInsetsToCode(dynamic padding) {
    if (padding is EdgeInsets) {
      if (padding.left == padding.right && padding.top == padding.bottom) {
        if (padding.left == padding.top) {
          return 'EdgeInsets.all(${padding.left})';
        }
        return 'EdgeInsets.symmetric(horizontal: ${padding.left}, vertical: ${padding.top})';
      }
      return 'EdgeInsets.fromLTRB(${padding.left}, ${padding.top}, ${padding.right}, ${padding.bottom})';
    }
    return 'EdgeInsets.zero';
  }

  static String _toSnakeCase(String input) {
    return input
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');
  }

  static String _toPascalCase(String input) {
    return input
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : '',
        )
        .join('');
  }

  // Additional generation methods would continue here...
  static Map<String, String> _generateCustomWidgets(
    ProjectModel project,
    ProjectAnalysis analysis,
  ) {
    return {}; // Placeholder
  }

  static Map<String, String> _generateModels(
    ProjectModel project,
    ProjectAnalysis analysis,
  ) {
    return {}; // Placeholder
  }

  static Map<String, String> _generateServices(
    ProjectModel project,
    ProjectAnalysis analysis,
  ) {
    return {}; // Placeholder
  }

  static String _generatePubspecYaml(
    ProjectModel project,
    ProjectAnalysis analysis,
  ) {
    return '''
name: ${_toSnakeCase(project.name)}
description: ${project.description}
version: ${project.version}

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
${analysis.dependencies.where((d) => d != 'flutter').map((d) => '  $d: ^1.0.0').join('\n')}

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
''';
  }

  /// Generate code for a single widget (modular, clean architecture)
  static Future<String> generateWidgetCode(
    WidgetModel widget, {
    bool formatCode = true,
    bool includeComments = true,
  }) async {
    final buffer = StringBuffer();
    final className = _toPascalCase(widget.name);
    if (includeComments) {
      buffer.writeln('// Widget: $className');
    }
    buffer.writeln('import "package:flutter/material.dart";');
    buffer.writeln('');
    buffer.writeln('class $className extends StatelessWidget {');
    buffer.writeln('  const $className({Key? key}) : super(key: key);');
    buffer.writeln('');
    buffer.writeln('  @override');
    buffer.writeln('  Widget build(BuildContext context) {');
    buffer.writeln('    return ${_generateWidgetCode(widget, 6)};');
    buffer.writeln('  }');
    buffer.writeln('}');
    return buffer.toString();
  }

  /// Generate code for a screen (modular, clean architecture)
  static Future<String> generateScreenCode(
    ScreenModel screen, {
    bool formatCode = true,
    bool includeComments = true,
  }) async {
    final buffer = StringBuffer();
    final className = '${_toPascalCase(screen.name)}Screen';
    if (includeComments) {
      buffer.writeln('// Screen: $className');
    }
    buffer.writeln('import "package:flutter/material.dart";');
    buffer.writeln('');
    buffer.writeln('class $className extends StatelessWidget {');
    buffer.writeln('  const $className({Key? key}) : super(key: key);');
    buffer.writeln('');
    buffer.writeln('  @override');
    buffer.writeln('  Widget build(BuildContext context) {');
    if (screen.widgets.isEmpty) {
      buffer.writeln('    return const Center(child: Text("Empty Screen"));');
    } else if (screen.widgets.length == 1) {
      buffer.writeln(
        '    return ${_generateWidgetCode(screen.widgets.first, 6)};',
      );
    } else {
      buffer.writeln('    return Column(');
      buffer.writeln('      children: [');
      for (final w in screen.widgets) {
        buffer.writeln('        ${_generateWidgetCode(w, 8)},');
      }
      buffer.writeln('      ],');
      buffer.writeln('    );');
    }
    buffer.writeln('  }');
    buffer.writeln('}');
    return buffer.toString();
  }

  /// Generate code for the entire project (entry point, modular structure)
  static Future<String> generateCompleteFlutterApp(
    ProjectModel project, {
    bool formatCode = true,
    bool includeComments = true,
  }) async {
    final buffer = StringBuffer();
    if (includeComments) {
      buffer.writeln('// Main entry point for ${project.name}');
    }
    buffer.writeln('import "package:flutter/material.dart";');
    buffer.writeln('import "core/theme/app_theme.dart";');
    buffer.writeln('import "core/router/app_router.dart";');
    for (final screen in project.screens) {
      buffer.writeln(
        'import "presentation/screens/${_toSnakeCase(screen.name)}_screen.dart";',
      );
    }
    buffer.writeln('');
    buffer.writeln('void main() {');
    buffer.writeln('  runApp(const MyApp());');
    buffer.writeln('}');
    buffer.writeln('');
    buffer.writeln('class MyApp extends StatelessWidget {');
    buffer.writeln('  const MyApp({Key? key}) : super(key: key);');
    buffer.writeln('');
    buffer.writeln('  @override');
    buffer.writeln('  Widget build(BuildContext context) {');
    buffer.writeln('    return MaterialApp.router(');
    buffer.writeln('      title: "${project.name}",');
    buffer.writeln('      theme: AppTheme.lightTheme,');
    buffer.writeln('      darkTheme: AppTheme.darkTheme,');
    buffer.writeln('      routerConfig: AppRouter.router,');
    buffer.writeln('      debugShowCheckedModeBanner: false,');
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');
    return buffer.toString();
  }
}

// Data classes
class GeneratedProject {
  final String mainDart;
  final Map<String, String> screens;
  final Map<String, String> widgets;
  final Map<String, String> models;
  final Map<String, String> services;
  final String pubspecYaml;
  final Architecture architecture;
  final ProjectAnalysis analysis;

  GeneratedProject({
    required this.mainDart,
    required this.screens,
    required this.widgets,
    required this.models,
    required this.services,
    required this.pubspecYaml,
    required this.architecture,
    required this.analysis,
  });
}

class ProjectAnalysis {
  final String projectType;
  final Architecture architecture;
  final List<String> screenTypes;
  final List<String> features;
  final int complexity;
  final StateManagement stateManagement;
  final List<String> dependencies;

  ProjectAnalysis({
    required this.projectType,
    required this.architecture,
    required this.screenTypes,
    required this.features,
    required this.complexity,
    required this.stateManagement,
    required this.dependencies,
  });
}

enum Architecture { simple, mvvm, cleanArchitecture }

enum StateManagement { setState, riverpod, bloc }

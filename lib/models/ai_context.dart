import 'widget_model.dart';
import 'screen_model.dart';
import 'project_model.dart';

/// Context information for AI code generation
class AIContext {
  final List<WidgetModel> widgets;
  final List<ScreenModel> screens;
  final ProjectModel? project;
  final String userIntent;
  final Map<String, dynamic> metadata;
  final String targetFramework;
  final String targetLanguage;
  final bool includeComments;
  final bool includeImports;
  final String designSystem;
  final DateTime? timestamp;

  const AIContext({
    this.widgets = const [],
    this.screens = const [],
    this.project,
    this.userIntent = '',
    this.metadata = const {},
    this.targetFramework = 'flutter',
    this.targetLanguage = 'dart',
    this.includeComments = false,
    this.includeImports = false,
    this.designSystem = 'material',
    this.timestamp,
  });

  factory AIContext.fromJson(Map<String, dynamic> json) {
    return AIContext(
      widgets: (json['widgets'] as List<dynamic>? ?? [])
          .map((e) => WidgetModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      screens: (json['screens'] as List<dynamic>? ?? [])
          .map((e) => ScreenModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      project: json['project'] != null
          ? ProjectModel.fromJson(json['project'] as Map<String, dynamic>)
          : null,
      userIntent: json['userIntent'] as String? ?? '',
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      targetFramework: json['targetFramework'] as String? ?? 'flutter',
      targetLanguage: json['targetLanguage'] as String? ?? 'dart',
      includeComments: json['includeComments'] as bool? ?? false,
      includeImports: json['includeImports'] as bool? ?? false,
      designSystem: json['designSystem'] as String? ?? 'material',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'widgets': widgets.map((e) => e.toJson()).toList(),
      'screens': screens.map((e) => e.toJson()).toList(),
      'project': project?.toJson(),
      'userIntent': userIntent,
      'metadata': metadata,
      'targetFramework': targetFramework,
      'targetLanguage': targetLanguage,
      'includeComments': includeComments,
      'includeImports': includeImports,
      'designSystem': designSystem,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  AIContext copyWith({
    List<WidgetModel>? widgets,
    List<ScreenModel>? screens,
    ProjectModel? project,
    String? userIntent,
    Map<String, dynamic>? metadata,
    String? targetFramework,
    String? targetLanguage,
    bool? includeComments,
    bool? includeImports,
    String? designSystem,
    DateTime? timestamp,
  }) {
    return AIContext(
      widgets: widgets ?? this.widgets,
      screens: screens ?? this.screens,
      project: project ?? this.project,
      userIntent: userIntent ?? this.userIntent,
      metadata: metadata ?? this.metadata,
      targetFramework: targetFramework ?? this.targetFramework,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      includeComments: includeComments ?? this.includeComments,
      includeImports: includeImports ?? this.includeImports,
      designSystem: designSystem ?? this.designSystem,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// AI generation request types
enum AIRequestType {
  codeGeneration,
  widgetSuggestion,
  layoutOptimization,
  propertyRecommendation,
  codeExplanation,
  bugFix,
  performance,
}

/// AI generation options
class AIGenerationOptions {
  final AIRequestType type;
  final bool includeTests;
  final bool includeDocumentation;
  final bool optimizeForPerformance;
  final bool followBestPractices;
  final String codeStyle;
  final List<String> customRules;

  const AIGenerationOptions({
    this.type = AIRequestType.codeGeneration,
    this.includeTests = false,
    this.includeDocumentation = false,
    this.optimizeForPerformance = false,
    this.followBestPractices = true,
    this.codeStyle = 'clean',
    this.customRules = const [],
  });

  factory AIGenerationOptions.fromJson(Map<String, dynamic> json) {
    return AIGenerationOptions(
      type: AIRequestType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AIRequestType.codeGeneration,
      ),
      includeTests: json['includeTests'] as bool? ?? false,
      includeDocumentation: json['includeDocumentation'] as bool? ?? false,
      optimizeForPerformance: json['optimizeForPerformance'] as bool? ?? false,
      followBestPractices: json['followBestPractices'] as bool? ?? true,
      codeStyle: json['codeStyle'] as String? ?? 'clean',
      customRules: (json['customRules'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'includeTests': includeTests,
      'includeDocumentation': includeDocumentation,
      'optimizeForPerformance': optimizeForPerformance,
      'followBestPractices': followBestPractices,
      'codeStyle': codeStyle,
      'customRules': customRules,
    };
  }
}

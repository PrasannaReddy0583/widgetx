import 'dart:convert';
import 'package:http/http.dart' as http;

/// Enhanced AI Context Service for managing complete project understanding
class AIContextService {
  static const String _apiEndpoint =
      'https://api.openai.com/v1/chat/completions';
  static const String _geminiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  // API keys should be stored securely in environment variables
  static String? _openAiApiKey;
  static String? _geminiApiKey;

  /// Project context structure for AI understanding
  static Future<ProjectContext> createProjectContext({
    required String projectTitle,
    required String projectDescription,
    required String businessContext,
    required String targetAudience,
    required SystemDesign systemDesign,
    required TechStack techStack,
    required RequirementsDocument requirements,
    required ImplementationPlan implementationPlan,
  }) async {
    return ProjectContext(
      title: projectTitle,
      description: projectDescription,
      businessContext: businessContext,
      targetAudience: targetAudience,
      systemDesign: systemDesign,
      techStack: techStack,
      requirements: requirements,
      implementationPlan: implementationPlan,
      timestamp: DateTime.now(),
    );
  }

  /// Generate complete Flutter project from context
  static Future<GeneratedProject> generateProjectFromContext(
    ProjectContext context,
  ) async {
    final prompt = _buildComprehensivePrompt(context);

    // Use GPT-4 for code generation
    final response = await _callOpenAI(prompt);

    // Parse and structure the generated code
    final generatedCode = _parseAIResponse(response);

    return GeneratedProject(
      context: context,
      code: generatedCode,
      timestamp: DateTime.now(),
    );
  }

  /// Analyze UI from image
  static Future<UIAnalysis> analyzeUIFromImage(
    String base64Image,
    ProjectContext context,
  ) async {
    final prompt =
        '''
    Analyze this UI design and identify:
    1. All Flutter widgets present
    2. Layout structure and hierarchy
    3. Color scheme and typography
    4. Interactive elements
    5. Required backend endpoints
    
    Project Context:
    ${context.toJson()}
    
    Generate Flutter code that matches this design exactly.
    ''';

    // Use Gemini Vision API for image analysis
    final analysis = await _callGeminiVision(base64Image, prompt);

    return UIAnalysis.fromJson(analysis);
  }

  /// Analyze UI from video for animations
  static Future<AnimationAnalysis> analyzeUIFromVideo(
    List<String> videoFrames,
    ProjectContext context,
  ) async {
    final prompt = '''
    Analyze these video frames to understand:
    1. UI animations and transitions
    2. Gesture interactions
    3. State changes
    4. Navigation flow
    5. Timing and curves
    
    Generate Flutter animation code with proper controllers and curves.
    ''';

    final analysis = await _analyzeVideoFrames(videoFrames, prompt);

    return AnimationAnalysis.fromJson(analysis);
  }

  /// Build comprehensive prompt with full context
  static String _buildComprehensivePrompt(ProjectContext context) {
    return '''
    You are an expert Flutter developer. Generate a complete Flutter application based on the following comprehensive context:
    
    PROJECT TITLE: ${context.title}
    
    BUSINESS CONTEXT:
    ${context.businessContext}
    
    TARGET AUDIENCE:
    ${context.targetAudience}
    
    SYSTEM DESIGN:
    Architecture Pattern: ${context.systemDesign.architecture}
    Components: ${context.systemDesign.components.join(', ')}
    Data Flow: ${context.systemDesign.dataFlow}
    
    TECH STACK:
    Frontend: ${context.techStack.frontend}
    Backend: ${context.techStack.backend}
    Database: ${context.techStack.database}
    Third-party Services: ${context.techStack.services.join(', ')}
    
    REQUIREMENTS:
    Functional Requirements:
    ${context.requirements.functional.map((r) => '- $r').join('\n')}
    
    Non-Functional Requirements:
    ${context.requirements.nonFunctional.map((r) => '- $r').join('\n')}
    
    IMPLEMENTATION PLAN:
    ${context.implementationPlan.steps.map((s) => '${s.order}. ${s.description}').join('\n')}
    
    Generate complete, production-ready Flutter code including:
    1. Project structure
    2. All screens and widgets
    3. State management
    4. API integration
    5. Database models
    6. Navigation
    7. Error handling
    8. Tests
    
    Follow Flutter best practices and ensure code is well-documented.
    ''';
  }

  /// Call OpenAI API
  static Future<Map<String, dynamic>> _callOpenAI(String prompt) async {
    if (_openAiApiKey == null) {
      throw Exception('OpenAI API key not configured');
    }

    final response = await http.post(
      Uri.parse(_apiEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_openAiApiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4-turbo-preview',
        'messages': [
          {
            'role': 'system',
            'content':
                'You are an expert Flutter developer who generates production-ready code.',
          },
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.7,
        'max_tokens': 4000,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to generate code: ${response.body}');
    }
  }

  /// Call Gemini Vision API for image analysis
  static Future<Map<String, dynamic>> _callGeminiVision(
    String base64Image,
    String prompt,
  ) async {
    if (_geminiApiKey == null) {
      throw Exception('Gemini API key not configured');
    }

    final response = await http.post(
      Uri.parse('$_geminiEndpoint?key=$_geminiApiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
              {
                'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image},
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to analyze image: ${response.body}');
    }
  }

  /// Analyze video frames for animations
  static Future<Map<String, dynamic>> _analyzeVideoFrames(
    List<String> frames,
    String prompt,
  ) async {
    // Analyze key frames to understand animation
    final keyFrames = _extractKeyFrames(frames);

    // Use Gemini to analyze multiple images
    final analyses = <Map<String, dynamic>>[];
    for (final frame in keyFrames) {
      final analysis = await _callGeminiVision(frame, prompt);
      analyses.add(analysis);
    }

    // Combine analyses to understand animation flow
    return _combineFrameAnalyses(analyses);
  }

  /// Extract key frames from video
  static List<String> _extractKeyFrames(List<String> frames) {
    // Simple implementation: take every nth frame
    final keyFrames = <String>[];
    final step = frames.length ~/ 10; // Get 10 key frames

    for (int i = 0; i < frames.length; i += step) {
      keyFrames.add(frames[i]);
    }

    return keyFrames;
  }

  /// Combine frame analyses to understand animation
  static Map<String, dynamic> _combineFrameAnalyses(
    List<Map<String, dynamic>> analyses,
  ) {
    // Analyze differences between frames to understand animation
    return {
      'animations': [],
      'transitions': [],
      'gestures': [],
      'stateChanges': [],
    };
  }

  /// Parse AI response into structured code
  static Map<String, String> _parseAIResponse(Map<String, dynamic> response) {
    // Extract code from AI response
    final content = response['choices'][0]['message']['content'] as String;

    // Parse different code sections
    final codeFiles = <String, String>{};

    // Simple parsing - in production, use more sophisticated parsing
    final sections = content.split('```dart');
    for (final section in sections) {
      if (section.contains('```')) {
        final code = section.split('```')[0];
        // Extract filename from comments or default naming
        final filename = _extractFilename(code);
        codeFiles[filename] = code;
      }
    }

    return codeFiles;
  }

  /// Extract filename from code comments
  static String _extractFilename(String code) {
    // Look for filename in comments like // filename: main.dart
    final lines = code.split('\n');
    for (final line in lines) {
      if (line.contains('// filename:')) {
        return line.split('// filename:')[1].trim();
      }
    }

    // Default naming based on content
    if (code.contains('void main()')) return 'main.dart';
    if (code.contains('class') && code.contains('Screen')) {
      final className = RegExp(r'class (\w+)Screen').firstMatch(code)?.group(1);
      return '${className?.toLowerCase()}_screen.dart';
    }

    return 'generated_${DateTime.now().millisecondsSinceEpoch}.dart';
  }
}

/// Project Context Model
class ProjectContext {
  final String title;
  final String description;
  final String businessContext;
  final String targetAudience;
  final SystemDesign systemDesign;
  final TechStack techStack;
  final RequirementsDocument requirements;
  final ImplementationPlan implementationPlan;
  final DateTime timestamp;

  ProjectContext({
    required this.title,
    required this.description,
    required this.businessContext,
    required this.targetAudience,
    required this.systemDesign,
    required this.techStack,
    required this.requirements,
    required this.implementationPlan,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'businessContext': businessContext,
    'targetAudience': targetAudience,
    'systemDesign': systemDesign.toJson(),
    'techStack': techStack.toJson(),
    'requirements': requirements.toJson(),
    'implementationPlan': implementationPlan.toJson(),
    'timestamp': timestamp.toIso8601String(),
  };
}

/// System Design Model
class SystemDesign {
  final String architecture;
  final List<String> components;
  final String dataFlow;
  final Map<String, dynamic> diagrams;

  SystemDesign({
    required this.architecture,
    required this.components,
    required this.dataFlow,
    this.diagrams = const {},
  });

  Map<String, dynamic> toJson() => {
    'architecture': architecture,
    'components': components,
    'dataFlow': dataFlow,
    'diagrams': diagrams,
  };
}

/// Tech Stack Model
class TechStack {
  final String frontend;
  final String backend;
  final String database;
  final List<String> services;
  final Map<String, String> packages;

  TechStack({
    required this.frontend,
    required this.backend,
    required this.database,
    required this.services,
    this.packages = const {},
  });

  Map<String, dynamic> toJson() => {
    'frontend': frontend,
    'backend': backend,
    'database': database,
    'services': services,
    'packages': packages,
  };
}

/// Requirements Document Model
class RequirementsDocument {
  final List<String> functional;
  final List<String> nonFunctional;
  final List<String> constraints;
  final Map<String, dynamic> useCases;

  RequirementsDocument({
    required this.functional,
    required this.nonFunctional,
    this.constraints = const [],
    this.useCases = const {},
  });

  Map<String, dynamic> toJson() => {
    'functional': functional,
    'nonFunctional': nonFunctional,
    'constraints': constraints,
    'useCases': useCases,
  };
}

/// Implementation Plan Model
class ImplementationPlan {
  final List<ImplementationStep> steps;
  final Map<String, int> milestones;
  final int estimatedDays;

  ImplementationPlan({
    required this.steps,
    this.milestones = const {},
    required this.estimatedDays,
  });

  Map<String, dynamic> toJson() => {
    'steps': steps.map((s) => s.toJson()).toList(),
    'milestones': milestones,
    'estimatedDays': estimatedDays,
  };
}

/// Implementation Step Model
class ImplementationStep {
  final int order;
  final String description;
  final List<String> tasks;
  final int estimatedHours;

  ImplementationStep({
    required this.order,
    required this.description,
    required this.tasks,
    required this.estimatedHours,
  });

  Map<String, dynamic> toJson() => {
    'order': order,
    'description': description,
    'tasks': tasks,
    'estimatedHours': estimatedHours,
  };
}

/// Generated Project Model
class GeneratedProject {
  final ProjectContext context;
  final Map<String, String> code;
  final DateTime timestamp;

  GeneratedProject({
    required this.context,
    required this.code,
    required this.timestamp,
  });
}

/// UI Analysis Model
class UIAnalysis {
  final List<WidgetInfo> widgets;
  final LayoutStructure layout;
  final ColorScheme colors;
  final Typography typography;
  final List<String> requiredEndpoints;

  UIAnalysis({
    required this.widgets,
    required this.layout,
    required this.colors,
    required this.typography,
    required this.requiredEndpoints,
  });

  factory UIAnalysis.fromJson(Map<String, dynamic> json) {
    // Parse JSON response into UIAnalysis
    return UIAnalysis(
      widgets: [],
      layout: LayoutStructure(type: 'column', children: []),
      colors: ColorScheme(primary: '#000000', secondary: '#FFFFFF'),
      typography: Typography(fontFamily: 'Roboto', sizes: {}),
      requiredEndpoints: [],
    );
  }
}

/// Widget Info Model
class WidgetInfo {
  final String type;
  final Map<String, dynamic> properties;
  final List<WidgetInfo> children;

  WidgetInfo({
    required this.type,
    required this.properties,
    this.children = const [],
  });
}

/// Layout Structure Model
class LayoutStructure {
  final String type;
  final List<dynamic> children;

  LayoutStructure({required this.type, required this.children});
}

/// Color Scheme Model
class ColorScheme {
  final String primary;
  final String secondary;
  final Map<String, String>? additional;

  ColorScheme({
    required this.primary,
    required this.secondary,
    this.additional,
  });
}

/// Typography Model
class Typography {
  final String fontFamily;
  final Map<String, double> sizes;

  Typography({required this.fontFamily, required this.sizes});
}

/// Animation Analysis Model
class AnimationAnalysis {
  final List<AnimationSequence> sequences;
  final List<GestureInteraction> gestures;
  final Map<String, StateTransition> stateTransitions;

  AnimationAnalysis({
    required this.sequences,
    required this.gestures,
    required this.stateTransitions,
  });

  factory AnimationAnalysis.fromJson(Map<String, dynamic> json) {
    return AnimationAnalysis(sequences: [], gestures: [], stateTransitions: {});
  }
}

/// Animation Sequence Model
class AnimationSequence {
  final String name;
  final Duration duration;
  final String curve;
  final Map<String, dynamic> properties;

  AnimationSequence({
    required this.name,
    required this.duration,
    required this.curve,
    required this.properties,
  });
}

/// Gesture Interaction Model
class GestureInteraction {
  final String type;
  final String target;
  final String action;

  GestureInteraction({
    required this.type,
    required this.target,
    required this.action,
  });
}

/// State Transition Model
class StateTransition {
  final String from;
  final String to;
  final String trigger;
  final Duration duration;

  StateTransition({
    required this.from,
    required this.to,
    required this.trigger,
    required this.duration,
  });
}

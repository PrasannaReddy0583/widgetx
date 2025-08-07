import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project_model.dart';
import '../models/screen_model.dart';
import '../models/widget_model.dart';
import '../services/code_generation_service.dart';

/// Code generation state
class CodeGenerationState {
  const CodeGenerationState({
    this.generatedCode = '',
    this.isGenerating = false,
    this.error,
    this.lastGenerated,
    this.codeType = CodeType.widget,
    this.formatCode = true,
    this.includeComments = true,
  });

  final String generatedCode;
  final bool isGenerating;
  final String? error;
  final DateTime? lastGenerated;
  final CodeType codeType;
  final bool formatCode;
  final bool includeComments;

  CodeGenerationState copyWith({
    String? generatedCode,
    bool? isGenerating,
    String? error,
    DateTime? lastGenerated,
    CodeType? codeType,
    bool? formatCode,
    bool? includeComments,
  }) {
    return CodeGenerationState(
      generatedCode: generatedCode ?? this.generatedCode,
      isGenerating: isGenerating ?? this.isGenerating,
      error: error ?? this.error,
      lastGenerated: lastGenerated ?? this.lastGenerated,
      codeType: codeType ?? this.codeType,
      formatCode: formatCode ?? this.formatCode,
      includeComments: includeComments ?? this.includeComments,
    );
  }
}

/// Code generation types
enum CodeType { widget, screen, project }

/// Code generation provider
class CodeGenerationNotifier extends StateNotifier<CodeGenerationState> {
  CodeGenerationNotifier(this._codeGenerationService)
    : super(const CodeGenerationState());

  final CodeGenerationService _codeGenerationService;

  /// Generate code for a widget
  Future<void> generateWidgetCode(WidgetModel widget) async {
    state = state.copyWith(
      isGenerating: true,
      error: null,
      codeType: CodeType.widget,
    );

    try {
      final code = await _codeGenerationService.generateWidgetCode(
        widget,
        formatCode: state.formatCode,
        includeComments: state.includeComments,
      );

      state = state.copyWith(
        generatedCode: code,
        isGenerating: false,
        lastGenerated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        error: 'Failed to generate widget code: $e',
      );
    }
  }

  /// Generate code for a screen
  Future<void> generateScreenCode(ScreenModel screen) async {
    state = state.copyWith(
      isGenerating: true,
      error: null,
      codeType: CodeType.screen,
    );

    try {
      final code = await _codeGenerationService.generateScreenCode(
        screen,
        formatCode: state.formatCode,
        includeComments: state.includeComments,
      );

      state = state.copyWith(
        generatedCode: code,
        isGenerating: false,
        lastGenerated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        error: 'Failed to generate screen code: $e',
      );
    }
  }

  /// Generate code for entire project
  Future<void> generateProjectCode(ProjectModel project) async {
    state = state.copyWith(
      isGenerating: true,
      error: null,
      codeType: CodeType.project,
    );

    try {
      final code = await _codeGenerationService.generateCompleteFlutterApp(
        project,
        formatCode: state.formatCode,
        includeComments: state.includeComments,
      );

      state = state.copyWith(
        generatedCode: code,
        isGenerating: false,
        lastGenerated: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        isGenerating: false,
        error: 'Failed to generate project code: $e',
      );
    }
  }

  /// Set code type
  void setCodeType(CodeType type) {
    state = state.copyWith(codeType: type);
  }

  /// Toggle code formatting
  void toggleFormatCode() {
    state = state.copyWith(formatCode: !state.formatCode);
  }

  /// Toggle comments inclusion
  void toggleIncludeComments() {
    state = state.copyWith(includeComments: !state.includeComments);
  }

  /// Clear generated code
  void clearCode() {
    state = state.copyWith(generatedCode: '', error: null, lastGenerated: null);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Update generated code manually
  void updateCode(String code) {
    state = state.copyWith(generatedCode: code, lastGenerated: DateTime.now());
  }
}

/// Code generation provider
final codeGenerationProvider =
    StateNotifierProvider<CodeGenerationNotifier, CodeGenerationState>((ref) {
      final codeGenerationService = ref.watch(codeGenerationServiceProvider);
      return CodeGenerationNotifier(codeGenerationService);
    });

/// Generated code provider
final generatedCodeProvider = Provider<String>((ref) {
  return ref.watch(codeGenerationProvider).generatedCode;
});

/// Code generation loading state provider
final codeGenerationLoadingProvider = Provider<bool>((ref) {
  return ref.watch(codeGenerationProvider).isGenerating;
});

/// Code generation error provider
final codeGenerationErrorProvider = Provider<String?>((ref) {
  return ref.watch(codeGenerationProvider).error;
});

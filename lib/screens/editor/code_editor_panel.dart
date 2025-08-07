import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/dart.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../providers/code_generation_provider.dart';
import '../../providers/canvas_provider.dart';
import '../../providers/project_provider.dart';
import '../../services/synchronization_service.dart';

/// Code editor panel showing generated Flutter code
class CodeEditorPanel extends ConsumerStatefulWidget {
  const CodeEditorPanel({super.key, this.onToggleVisibility});

  final VoidCallback? onToggleVisibility;

  @override
  ConsumerState<CodeEditorPanel> createState() => _CodeEditorPanelState();
}

class _CodeEditorPanelState extends ConsumerState<CodeEditorPanel>
    with SingleTickerProviderStateMixin {
  late CodeController _codeController;
  late TabController _tabController;
  bool _isAutoGenerate = true;
  CodeType _currentCodeType = CodeType.widget;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _codeController = CodeController(
      text: '',
      //language: 'dart',
      //theme: vs2015Theme,
      language: dart,
    );

    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentCodeType = CodeType.values[_tabController.index];
        });
        _generateCode();
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final codeState = ref.watch(codeGenerationProvider);
    final canvasState = ref.watch(canvasProvider);
    final currentProject = ref.watch(currentProjectProvider);

    // Update code when generation completes
    ref.listen(codeGenerationProvider, (previous, next) {
      if (previous?.generatedCode != next.generatedCode) {
        _codeController.text = next.generatedCode;
      }
    });

    // Auto-generate code when canvas changes
    ref.listen(canvasProvider, (previous, next) {
      if (_isAutoGenerate &&
          previous?.currentScreen?.widgets != next.currentScreen?.widgets) {
        _generateCode();
      }
    });

    return Column(
      children: [
        // Code editor content
        Expanded(
          child: Container(
            color: AppColors.codeBackground,
            child: Column(
              children: [
                // Tab bar
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      bottom: BorderSide(color: AppColors.borderLight),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Widget'),
                      Tab(text: 'Screen'),
                      Tab(text: 'Project'),
                    ],
                    labelStyle: const TextStyle(fontSize: 12),
                    unselectedLabelStyle: const TextStyle(fontSize: 12),
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),

                // Toolbar
                _CodeToolbar(
                  isAutoGenerate: _isAutoGenerate,
                  onAutoGenerateChanged: (value) {
                    setState(() {
                      _isAutoGenerate = value;
                    });
                  },
                  onGenerate: _generateCode,
                  onCopy: _copyCode,
                  onFormat: _formatCode,
                  isGenerating: codeState.isGenerating,
                  onSyncToUI: _syncToUI,
                ),

                // Code editor
                Expanded(
                  child: codeState.isGenerating
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Generating code...',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : codeState.error != null
                      ? _ErrorView(error: codeState.error!)
                      : _CodeEditorView(controller: _codeController),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _generateCode() {
    final codeNotifier = ref.read(codeGenerationProvider.notifier);
    final canvasState = ref.read(canvasProvider);
    final currentProject = ref.read(currentProjectProvider);

    switch (_currentCodeType) {
      case CodeType.widget:
        final selectedWidgets = canvasState.selectedWidgets;
        if (selectedWidgets.isNotEmpty) {
          codeNotifier.generateWidgetCode(selectedWidgets.first);
        } else if (canvasState.currentScreen?.widgets.isNotEmpty == true) {
          codeNotifier.generateWidgetCode(
            canvasState.currentScreen!.widgets.first,
          );
        }
        break;

      case CodeType.screen:
        if (canvasState.currentScreen != null) {
          codeNotifier.generateScreenCode(canvasState.currentScreen!);
        }
        break;

      case CodeType.project:
        if (currentProject != null) {
          codeNotifier.generateProjectCode(currentProject);
        }
        break;
    }
  }

  void _copyCode() {
    if (_codeController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _codeController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Code copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _formatCode() {
    // Basic code formatting - in a real implementation, you'd use dart_style
    final lines = _codeController.text.split('\n');
    final formatted = <String>[];
    int indentLevel = 0;

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        formatted.add('');
        continue;
      }

      // Decrease indent for closing braces
      if (trimmed.startsWith('}') ||
          trimmed.startsWith(']') ||
          trimmed.startsWith(')')) {
        indentLevel = (indentLevel - 1).clamp(0, 100);
      }

      // Add indented line
      formatted.add('${'  ' * indentLevel}$trimmed');

      // Increase indent for opening braces
      if (trimmed.endsWith('{') ||
          trimmed.endsWith('[') ||
          trimmed.endsWith('(')) {
        indentLevel++;
      }
    }

    _codeController.text = formatted.join('\n');
  }

  void _syncToUI() {
    final code = _codeController.text;
    final canvasState = ref.read(canvasProvider);
    final selectedWidgets = canvasState.selectedWidgets;
    if (selectedWidgets.isNotEmpty) {
      // Sync code to selected widget
      final widgetId = selectedWidgets.first.id;
      final syncService = SynchronizationService();
      syncService.syncFromCode(code: code, widgetId: widgetId, ref: ref);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Synced code to UI/properties/widget tree'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a widget to sync code to UI')),
      );
    }
  }
}

/// Code editor toolbar
class _CodeToolbar extends StatelessWidget {
  const _CodeToolbar({
    required this.isAutoGenerate,
    required this.onAutoGenerateChanged,
    required this.onGenerate,
    required this.onCopy,
    required this.onFormat,
    required this.isGenerating,
    required this.onSyncToUI,
  });

  final bool isAutoGenerate;
  final ValueChanged<bool> onAutoGenerateChanged;
  final VoidCallback onGenerate;
  final VoidCallback onCopy;
  final VoidCallback onFormat;
  final bool isGenerating;
  final VoidCallback onSyncToUI;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          // Auto-generate toggle
          Row(
            children: [
              Switch(
                value: isAutoGenerate,
                onChanged: onAutoGenerateChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 8),
              const Text(
                'Auto-generate',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Generate button
          IconButton(
            icon: const Icon(Icons.refresh, size: 16),
            onPressed: isGenerating ? null : onGenerate,
            tooltip: 'Generate Code',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            color: AppColors.iconSecondary,
          ),

          // Sync to UI button
          IconButton(
            icon: const Icon(Icons.sync, size: 16),
            onPressed: onSyncToUI,
            tooltip: 'Sync to UI',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            color: AppColors.iconSecondary,
          ),

          const Spacer(),

          // Code actions
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.content_copy, size: 16),
                onPressed: onCopy,
                tooltip: 'Copy Code',
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                color: AppColors.iconSecondary,
              ),
              IconButton(
                icon: const Icon(Icons.code, size: 16),
                onPressed: onFormat,
                tooltip: 'Format Code',
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                color: AppColors.iconSecondary,
              ),
              IconButton(
                icon: const Icon(Icons.download, size: 16),
                onPressed: () => _showExportDialog(context),
                tooltip: 'Export Code',
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                color: AppColors.iconSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Code'),
        content: const Text(
          'Code export functionality will be implemented in Phase 6.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Code editor view
class _CodeEditorView extends StatelessWidget {
  const _CodeEditorView({required this.controller});

  final CodeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.codeBackground,
      child: SingleChildScrollView(
        child: CodeField(
          controller: controller,
          textStyle: AppTypography.codeStyle.copyWith(
            color: AppColors.codeForeground,
          ),
          background: AppColors.codeBackground,
          lineNumberStyle: const LineNumberStyle(
            textStyle: TextStyle(color: AppColors.textTertiary, fontSize: 12),
            background: AppColors.codeBackground,
            margin: 8,
          ),
          wrap: true,
          lineNumbers: true,
          readOnly: false,
        ),
      ),
    );
  }
}

/// Error view for code generation errors
class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.codeBackground,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              const Text(
                'Code Generation Error',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Clear error and retry
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Code statistics widget
class _CodeStats extends StatelessWidget {
  const _CodeStats({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final lines = code.split('\n').length;
    final characters = code.length;
    final words = code.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.propertyItem,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatItem(label: 'Lines', value: lines.toString()),
          const SizedBox(width: 12),
          _StatItem(label: 'Words', value: words.toString()),
          const SizedBox(width: 12),
          _StatItem(label: 'Chars', value: characters.toString()),
        ],
      ),
    );
  }
}

/// Individual stat item
class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textTertiary),
        ),
      ],
    );
  }
}

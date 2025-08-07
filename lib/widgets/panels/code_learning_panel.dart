import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetx/providers/project_provider.dart';
import '../../models/widget_model.dart';
import '../../providers/canvas_provider.dart';
import '../../services/ai_code_generation_service.dart';
import '../../core/theme/colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/widget_types.dart';

/// Code learning panel showing widget-specific code
class CodeLearningPanel extends ConsumerStatefulWidget {
  const CodeLearningPanel({super.key});

  @override
  ConsumerState<CodeLearningPanel> createState() => _CodeLearningPanelState();
}

class _CodeLearningPanelState extends ConsumerState<CodeLearningPanel> {
  bool _showFullProject = false;
  String? _generatedCode;
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final canvasState = ref.watch(canvasProvider);
    final selectedWidgets = canvasState.selectedWidgetIds;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        children: [
          _buildHeader(selectedWidgets),
          Expanded(
            child: _showFullProject
                ? _buildFullProjectCode()
                : _buildWidgetCode(selectedWidgets),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(List<String> selectedWidgets) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          Icon(Icons.code, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            _showFullProject ? 'Generated Project Code' : 'Widget Code',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),

          // Toggle view button
          IconButton(
            onPressed: () {
              setState(() {
                _showFullProject = !_showFullProject;
              });
            },
            icon: Icon(
              _showFullProject ? Icons.widgets : Icons.folder,
              size: 16,
            ),
            tooltip: _showFullProject
                ? 'Show Widget Code'
                : 'Show Project Code',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),

          // Generate full code button
          if (!_showFullProject)
            IconButton(
              onPressed: _isGenerating ? null : _generateFullProject,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome, size: 16),
              tooltip: 'Generate Full Project',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
        ],
      ),
    );
  }

  Widget _buildWidgetCode(List<String> selectedWidgets) {
    if (selectedWidgets.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.code, size: 48, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text(
              'Select a widget to view its code',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    final selectedWidget = _getSelectedWidget(selectedWidgets.first);
    if (selectedWidget == null) {
      return const Center(
        child: Text(
          'Widget not found',
          style: TextStyle(color: AppColors.error),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWidgetInfo(selectedWidget),
          const SizedBox(height: 16),
          _buildCodeSection('Widget Code', _generateWidgetCode(selectedWidget)),
          const SizedBox(height: 16),
          _buildCodeSection(
            'Usage Example',
            _generateUsageExample(selectedWidget),
          ),
          const SizedBox(height: 16),
          _buildPropertiesSection(selectedWidget),
          const SizedBox(height: 16),
          _buildDocumentationSection(selectedWidget),
        ],
      ),
    );
  }

  Widget _buildFullProjectCode() {
    if (_generatedCode == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome, size: 48, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text(
              'Click "Generate Full Project" to see\nthe complete Flutter code',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCodeSection('main.dart', _generatedCode!),
          // Add more generated files here
        ],
      ),
    );
  }

  Widget _buildWidgetInfo(WidgetModel widget) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getWidgetIcon(widget.type),
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                widget.type.displayName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getWidgetDescription(widget.type),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeSection(String title, String code) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _copyToClipboard(code),
              icon: const Icon(Icons.copy, size: 16),
              tooltip: 'Copy Code',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: SelectableText(
            code,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertiesSection(WidgetModel widget) {
    final properties = _getWidgetProperties(widget.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Properties',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ...properties.map(
          (prop) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prop.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  prop.description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (prop.example != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Example: ${prop.example}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontFamily: 'monospace',
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentationSection(WidgetModel widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Learn More',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => _openDocumentation(widget.type),
                child: Row(
                  children: [
                    const Icon(
                      Icons.open_in_new,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Flutter ${widget.type.displayName} Documentation',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getWidgetTips(widget.type),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper methods
  WidgetModel? _getSelectedWidget(String widgetId) {
    final currentScreen = ref.read(canvasProvider).currentScreen;
    if (currentScreen == null) return null;
    return _findWidgetInList(currentScreen.widgets, widgetId);
  }

  WidgetModel? _findWidgetInList(List<WidgetModel> widgets, String id) {
    for (final widget in widgets) {
      if (widget.id == id) return widget;
      final found = _findWidgetInList(widget.children, id);
      if (found != null) return found;
    }
    return null;
  }

  String _generateWidgetCode(WidgetModel widget) {
    switch (widget.type) {
      case FlutterWidgetType.container:
        return _generateContainerCode(widget);
      case FlutterWidgetType.text:
        return _generateTextCode(widget);
      case FlutterWidgetType.elevatedButton:
        return _generateButtonCode(widget);
      case FlutterWidgetType.row:
        return _generateRowCode(widget);
      case FlutterWidgetType.column:
        return _generateColumnCode(widget);
      default:
        return '${widget.type.displayName}()';
    }
  }

  String _generateContainerCode(WidgetModel widget) {
    final props = widget.properties;
    final lines = <String>['Container('];

    lines.add('  width: ${widget.size.width},');
    lines.add('  height: ${widget.size.height},');

    if (props['backgroundColor'] != null) {
      lines.add('  color: ${_colorToCode(props['backgroundColor'])},');
    }

    if (props['padding'] != null) {
      lines.add('  padding: ${_edgeInsetsToCode(props['padding'])},');
    }

    if (widget.children.isNotEmpty) {
      lines.add('  child: ${_generateWidgetCode(widget.children.first)},');
    }

    lines.add(')');
    return lines.join('\n');
  }

  String _generateTextCode(WidgetModel widget) {
    final text = widget.properties['text']?.toString() ?? 'Text';
    final fontSize = widget.properties['fontSize'];
    final color = widget.properties['color'];

    if (fontSize != null || color != null) {
      final lines = <String>['Text('];
      lines.add("  '$text',");
      lines.add('  style: TextStyle(');
      if (fontSize != null) lines.add('    fontSize: $fontSize,');
      if (color != null) lines.add('    color: ${_colorToCode(color)},');
      lines.add('  ),');
      lines.add(')');
      return lines.join('\n');
    }

    return "Text('$text')";
  }

  String _generateButtonCode(WidgetModel widget) {
    final text = widget.properties['text']?.toString() ?? 'Button';
    return '''ElevatedButton(
  onPressed: () {
    // Add your button action here
  },
  child: Text('$text'),
)''';
  }

  String _generateRowCode(WidgetModel widget) {
    return '''Row(
  children: [
    // Add child widgets here
  ],
)''';
  }

  String _generateColumnCode(WidgetModel widget) {
    return '''Column(
  children: [
    // Add child widgets here
  ],
)''';
  }

  String _generateUsageExample(WidgetModel widget) {
    return '''class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ${_generateWidgetCode(widget)};
  }
}''';
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openDocumentation(FlutterWidgetType type) {
    // In a real app, this would open the Flutter documentation
    // For now, we'll show a placeholder
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${type.displayName} documentation...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _generateFullProject() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      // Simulate AI generation delay
      await Future.delayed(const Duration(seconds: 2));

      final projectState = ref.read(projectProvider);
      final project = projectState.currentProject;
      
      if (project == null) {
        throw Exception('No project is currently loaded');
      }
      
      final generatedProject = await AICodeGenerationService.generateProject(project);
      setState(() {
        _generatedCode = generatedProject.mainDart;
        _showFullProject = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating code: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  // Widget information methods
  IconData _getWidgetIcon(FlutterWidgetType type) {
    switch (type) {
      case FlutterWidgetType.container:
        return Icons.crop_square;
      case FlutterWidgetType.text:
        return Icons.text_fields;
      case FlutterWidgetType.elevatedButton:
        return Icons.smart_button;
      case FlutterWidgetType.row:
        return Icons.view_week;
      case FlutterWidgetType.column:
        return Icons.view_agenda;
      default:
        return Icons.widgets;
    }
  }

  String _getWidgetDescription(FlutterWidgetType type) {
    switch (type) {
      case FlutterWidgetType.container:
        return 'A convenience widget that combines common painting, positioning, and sizing widgets.';
      case FlutterWidgetType.text:
        return 'A run of text with a single style.';
      case FlutterWidgetType.elevatedButton:
        return 'A Material Design elevated button.';
      case FlutterWidgetType.row:
        return 'A widget that displays its children in a horizontal array.';
      case FlutterWidgetType.column:
        return 'A widget that displays its children in a vertical array.';
      default:
        return 'A Flutter widget.';
    }
  }

  List<WidgetProperty> _getWidgetProperties(FlutterWidgetType type) {
    switch (type) {
      case FlutterWidgetType.container:
        return [
          WidgetProperty('width', 'The width of the container', 'width: 100'),
          WidgetProperty('height', 'The height of the container', 'height: 50'),
          WidgetProperty('color', 'The background color', 'color: Colors.blue'),
          WidgetProperty(
            'padding',
            'Internal padding',
            'padding: EdgeInsets.all(8)',
          ),
          WidgetProperty(
            'margin',
            'External margin',
            'margin: EdgeInsets.all(8)',
          ),
        ];
      case FlutterWidgetType.text:
        return [
          WidgetProperty('data', 'The text to display', "'Hello World'"),
          WidgetProperty(
            'style',
            'Text styling',
            'style: TextStyle(fontSize: 16)',
          ),
          WidgetProperty(
            'textAlign',
            'Text alignment',
            'textAlign: TextAlign.center',
          ),
        ];
      default:
        return [];
    }
  }

  String _getWidgetTips(FlutterWidgetType type) {
    switch (type) {
      case FlutterWidgetType.container:
        return 'Tip: Use Container for layout, styling, and positioning. It\'s one of the most versatile widgets in Flutter.';
      case FlutterWidgetType.text:
        return 'Tip: Use TextStyle to customize appearance. For rich text with multiple styles, consider RichText widget.';
      case FlutterWidgetType.elevatedButton:
        return 'Tip: Always provide an onPressed callback. Use null to disable the button.';
      default:
        return 'Tip: Check the Flutter documentation for more details about this widget.';
    }
  }

  String _colorToCode(dynamic color) {
    if (color is Color) {
      return 'Color(0x${color.value.toRadixString(16).padLeft(8, '0')})';
    }
    return 'Colors.black';
  }

  String _edgeInsetsToCode(dynamic padding) {
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
}

class WidgetProperty {
  final String name;
  final String description;
  final String? example;

  WidgetProperty(this.name, this.description, [this.example]);
}

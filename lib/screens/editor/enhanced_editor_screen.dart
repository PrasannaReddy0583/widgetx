import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'enhanced_widget_library.dart';
import 'enhanced_canvas_panel_new.dart';
import 'enhanced_properties_panel.dart';
import 'widget_tree_panel.dart';
import '../../providers/canvas_provider.dart';

/// Enhanced editor screen that integrates all FlutterFlow-like functionality
class EnhancedEditorScreen extends ConsumerStatefulWidget {
  const EnhancedEditorScreen({super.key});

  @override
  ConsumerState<EnhancedEditorScreen> createState() =>
      _EnhancedEditorScreenState();
}

class _EnhancedEditorScreenState extends ConsumerState<EnhancedEditorScreen> {
  bool _showWidgetTree = true;
  bool _showProperties = true;
  bool _showWidgetLibrary = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: Row(
        children: [
          // Widget Library Panel
          if (_showWidgetLibrary) const EnhancedWidgetLibrary(),

          // Main Canvas Area  
          const Expanded(child: EnhancedCanvasPanel()),

          // Right Side Panels
          if (_showWidgetTree || _showProperties)
            Row(
              children: [
                // Widget Tree Panel
                if (_showWidgetTree) const WidgetTreePanel(),

                // Properties Panel
                if (_showProperties) const EnhancedPropertiesPanel(),
              ],
            ),
        ],
      ),
      bottomNavigationBar: _buildStatusBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final canvasState = ref.watch(canvasProvider);

    return AppBar(
      title: const Text(
        'WidgetX - Flutter App Builder',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 1,
      actions: [
        // Undo/Redo
        IconButton(
          icon: const Icon(Icons.undo),
          onPressed: canvasState.canUndo ? _undo : null,
          tooltip: 'Undo',
        ),
        IconButton(
          icon: const Icon(Icons.redo),
          onPressed: canvasState.canRedo ? _redo : null,
          tooltip: 'Redo',
        ),

        const VerticalDivider(),

        // View toggles
        IconButton(
          icon: Icon(
            _showWidgetLibrary ? Icons.widgets : Icons.widgets_outlined,
          ),
          onPressed: () =>
              setState(() => _showWidgetLibrary = !_showWidgetLibrary),
          tooltip: 'Toggle Widget Library',
        ),
        IconButton(
          icon: Icon(
            _showWidgetTree ? Icons.account_tree : Icons.account_tree_outlined,
          ),
          onPressed: () => setState(() => _showWidgetTree = !_showWidgetTree),
          tooltip: 'Toggle Widget Tree',
        ),
        IconButton(
          icon: Icon(_showProperties ? Icons.tune : Icons.tune_outlined),
          onPressed: () => setState(() => _showProperties = !_showProperties),
          tooltip: 'Toggle Properties Panel',
        ),

        const VerticalDivider(),

        // Project actions
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveProject,
          tooltip: 'Save Project',
        ),
        IconButton(
          icon: const Icon(Icons.folder_open),
          onPressed: _openProject,
          tooltip: 'Open Project',
        ),
        IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: _previewApp,
          tooltip: 'Preview App',
        ),
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: _exportCode,
          tooltip: 'Export Flutter Code',
        ),

        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildStatusBar() {
    final canvasState = ref.watch(canvasProvider);

    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Row(
        children: [
          Text(
            'Widgets: ${canvasState.currentScreen?.widgets.length ?? 0}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 16),
          Text(
            'Selected: ${canvasState.selectedWidgetIds.length}',
            style: const TextStyle(fontSize: 12),
          ),
          const Spacer(),
          if (canvasState.selectedWidgetIds.isNotEmpty) ...[
            const Text(
              'Ready',
              style: TextStyle(fontSize: 12, color: Colors.green),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.check_circle, size: 16, color: Colors.green),
          ] else ...[
            const Text(
              'Select a widget to edit properties',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  void _undo() {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    canvasNotifier.undo();
  }

  void _redo() {
    final canvasNotifier = ref.read(canvasProvider.notifier);
    canvasNotifier.redo();
  }

  void _saveProject() {
    // TODO: Implement project saving
    _showFeatureDialog(
      'Save Project',
      'Project saving functionality will be implemented soon.',
    );
  }

  void _openProject() {
    // TODO: Implement project opening
    _showFeatureDialog(
      'Open Project',
      'Project opening functionality will be implemented soon.',
    );
  }

  void _previewApp() {
    // TODO: Implement app preview
    _showFeatureDialog(
      'Preview App',
      'Live app preview functionality will be implemented soon.',
    );
  }

  void _exportCode() {
    // TODO: Implement Flutter code export
    _showFeatureDialog(
      'Export Code',
      'Flutter code export functionality will be implemented soon.',
    );
  }

  void _showFeatureDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
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

/// Keyboard shortcuts handler
class KeyboardShortcuts extends StatelessWidget {
  final Widget child;

  const KeyboardShortcuts({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final Map<ShortcutActivator, Intent> shortcuts = {
        const SingleActivator(LogicalKeyboardKey.keyZ, control: true): UndoIntent(),
        const SingleActivator(LogicalKeyboardKey.keyY, control: true): RedoIntent(),
        const SingleActivator(LogicalKeyboardKey.keyS, control: true): SaveIntent(),
        const SingleActivator(LogicalKeyboardKey.keyO, control: true): OpenIntent(),
        const SingleActivator(LogicalKeyboardKey.delete): DeleteIntent(),
        const SingleActivator(LogicalKeyboardKey.keyA, control: true):
            SelectAllIntent(),
        const SingleActivator(LogicalKeyboardKey.keyC, control: true): CopyIntent(),
        const SingleActivator(LogicalKeyboardKey.keyV, control: true): PasteIntent(),
        const SingleActivator(LogicalKeyboardKey.keyD, control: true):
            DuplicateIntent(),
      };
    
    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: {
          UndoIntent: CallbackAction<UndoIntent>(onInvoke: _handleUndo),
          RedoIntent: CallbackAction<RedoIntent>(onInvoke: _handleRedo),
          SaveIntent: CallbackAction<SaveIntent>(onInvoke: _handleSave),
          OpenIntent: CallbackAction<OpenIntent>(onInvoke: _handleOpen),
          DeleteIntent: CallbackAction<DeleteIntent>(onInvoke: _handleDelete),
          SelectAllIntent: CallbackAction<SelectAllIntent>(
            onInvoke: _handleSelectAll,
          ),
          CopyIntent: CallbackAction<CopyIntent>(onInvoke: _handleCopy),
          PasteIntent: CallbackAction<PasteIntent>(onInvoke: _handlePaste),
          DuplicateIntent: CallbackAction<DuplicateIntent>(
            onInvoke: _handleDuplicate,
          ),
        },
        child: child,
      ),
    );
  }

  Object? _handleUndo(UndoIntent intent) {
    // TODO: Implement undo
    return null;
  }

  Object? _handleRedo(RedoIntent intent) {
    // TODO: Implement redo
    return null;
  }

  Object? _handleSave(SaveIntent intent) {
    // TODO: Implement save
    return null;
  }

  Object? _handleOpen(OpenIntent intent) {
    // TODO: Implement open
    return null;
  }

  Object? _handleDelete(DeleteIntent intent) {
    // TODO: Implement delete
    return null;
  }

  Object? _handleSelectAll(SelectAllIntent intent) {
    // TODO: Implement select all
    return null;
  }

  Object? _handleCopy(CopyIntent intent) {
    // TODO: Implement copy
    return null;
  }

  Object? _handlePaste(PasteIntent intent) {
    // TODO: Implement paste
    return null;
  }

  Object? _handleDuplicate(DuplicateIntent intent) {
    // TODO: Implement duplicate
    return null;
  }
}

// Intent classes for keyboard shortcuts
class UndoIntent extends Intent {}

class RedoIntent extends Intent {}

class SaveIntent extends Intent {}

class OpenIntent extends Intent {}

class DeleteIntent extends Intent {}

class SelectAllIntent extends Intent {}

class CopyIntent extends Intent {}

class PasteIntent extends Intent {}

class DuplicateIntent extends Intent {}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/screen_model.dart';
import '../../providers/project_provider.dart';
import '../../providers/canvas_provider.dart';
import '../../core/theme/colors.dart';

/// Screen tabs widget for multi-screen management
class ScreenTabs extends ConsumerStatefulWidget {
  const ScreenTabs({super.key});

  @override
  ConsumerState<ScreenTabs> createState() => _ScreenTabsState();
}

class _ScreenTabsState extends ConsumerState<ScreenTabs> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(projectProvider);
    final canvasState = ref.watch(canvasProvider);
    final currentScreen = canvasState.currentScreen;

    return Container(
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          // Screen tabs
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: project.currentProject?.screens.length ?? 0,
              itemBuilder: (context, index) {
                final screen = project.currentProject!.screens[index];
                final isSelected = currentScreen?.id == screen.id;
                final isMain = screen.isMain;

                return _buildScreenTab(
                  screen: screen,
                  isSelected: isSelected,
                  isMain: isMain,
                  onTap: () => _selectScreen(screen),
                  onClose: (project.currentProject?.screens.length ?? 0) > 1
                      ? () => _closeScreen(screen)
                      : null,
                  onRename: () => _renameScreen(screen),
                  onDuplicate: () => _duplicateScreen(screen),
                  onSetAsMain: !isMain ? () => _setAsMainScreen(screen) : null,
                );
              },
            ),
          ),

          // Add screen button
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.borderLight)),
            ),
            child: IconButton(
              onPressed: _addScreen,
              icon: const Icon(Icons.add, size: 16),
              tooltip: 'Add Screen',
            ),
          ),

          // Screen templates dropdown
          Container(
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.borderLight)),
            ),
            child: PopupMenuButton<ScreenTemplate>(
              onSelected: _addScreenFromTemplate,
              icon: const Icon(Icons.dashboard, size: 16),
              tooltip: 'Add from Template',
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: ScreenTemplate.blank,
                  child: Row(
                    children: [
                      Icon(Icons.crop_square, size: 16),
                      SizedBox(width: 8),
                      Text('Blank Screen'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: ScreenTemplate.login,
                  child: Row(
                    children: [
                      Icon(Icons.login, size: 16),
                      SizedBox(width: 8),
                      Text('Login Screen'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: ScreenTemplate.home,
                  child: Row(
                    children: [
                      Icon(Icons.home, size: 16),
                      SizedBox(width: 8),
                      Text('Home Screen'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: ScreenTemplate.profile,
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 16),
                      SizedBox(width: 8),
                      Text('Profile Screen'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: ScreenTemplate.settings,
                  child: Row(
                    children: [
                      Icon(Icons.settings, size: 16),
                      SizedBox(width: 8),
                      Text('Settings Screen'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: ScreenTemplate.list,
                  child: Row(
                    children: [
                      Icon(Icons.list, size: 16),
                      SizedBox(width: 8),
                      Text('List Screen'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenTab({
    required ScreenModel screen,
    required bool isSelected,
    required bool isMain,
    required VoidCallback onTap,
    VoidCallback? onClose,
    required VoidCallback onRename,
    required VoidCallback onDuplicate,
    VoidCallback? onSetAsMain,
  }) {
    return GestureDetector(
      onSecondaryTap: () => _showScreenContextMenu(
        screen: screen,
        onRename: onRename,
        onDuplicate: onDuplicate,
        onClose: onClose,
        onSetAsMain: onSetAsMain,
      ),
      child: Container(
        constraints: const BoxConstraints(minWidth: 120, maxWidth: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
          border: Border(
            right: const BorderSide(color: AppColors.borderLight),
            bottom: isSelected
                ? BorderSide(color: AppColors.primary, width: 2)
                : BorderSide.none,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Main screen indicator
                if (isMain)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),

                // Screen name
                Expanded(
                  child: Text(
                    screen.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Widget count badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${screen.widgets.length}',
                    style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                // Close button
                if (onClose != null)
                  InkWell(
                    onTap: onClose,
                    borderRadius: BorderRadius.circular(2),
                    child: Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(left: 4),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showScreenContextMenu({
    required ScreenModel screen,
    required VoidCallback onRename,
    required VoidCallback onDuplicate,
    VoidCallback? onClose,
    VoidCallback? onSetAsMain,
  }) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + 40,
        position.dx + 200,
        position.dy + 200,
      ),
      items: [
        PopupMenuItem(
          value: 'rename',
          child: Row(
            children: [
              const Icon(Icons.edit, size: 16),
              const SizedBox(width: 8),
              const Text('Rename'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              const Icon(Icons.copy, size: 16),
              const SizedBox(width: 8),
              const Text('Duplicate'),
            ],
          ),
        ),
        if (onSetAsMain != null)
          PopupMenuItem(
            value: 'setMain',
            child: Row(
              children: [
                const Icon(Icons.star, size: 16),
                const SizedBox(width: 8),
                const Text('Set as Main'),
              ],
            ),
          ),
        if (onClose != null)
          PopupMenuItem(
            value: 'close',
            child: Row(
              children: [
                const Icon(Icons.close, size: 16, color: AppColors.error),
                const SizedBox(width: 8),
                const Text('Close', style: TextStyle(color: AppColors.error)),
              ],
            ),
          ),
      ],
    ).then((value) {
      switch (value) {
        case 'rename':
          onRename();
          break;
        case 'duplicate':
          onDuplicate();
          break;
        case 'setMain':
          onSetAsMain?.call();
          break;
        case 'close':
          onClose?.call();
          break;
      }
    });
  }

  void _selectScreen(ScreenModel screen) {
    ref.read(canvasProvider.notifier).setCurrentScreen(screen);
  }

  void _addScreen() {
    final project = ref.read(projectProvider);
    // if (project == null) return;

    final newScreen = ScreenModel.create(
      name: 'Screen ${project.currentProject!.screens.length + 1}',
    );

    ref.read(projectProvider.notifier).addScreen(newScreen);
    ref.read(canvasProvider.notifier).setCurrentScreen(newScreen);
  }

  void _addScreenFromTemplate(ScreenTemplate template) {
    final project = ref.read(projectProvider);
    // if (project == null) return;

    final newScreen = _createScreenFromTemplate(
      template,
      project.currentProject!.screens.length + 1,
    );
    ref.read(projectProvider.notifier).addScreen(newScreen);
    ref.read(canvasProvider.notifier).setCurrentScreen(newScreen);
  }

  void _closeScreen(ScreenModel screen) {
    final project = ref.read(projectProvider);
    if ( /*project == null ||*/ project.currentProject!.screens.length <= 1) {
      return;
    }

    // If closing the current screen, switch to another screen first
    final currentScreen = ref.read(canvasProvider).currentScreen;
    if (currentScreen?.id == screen.id) {
      final otherScreen = project.currentProject!.screens.firstWhere(
        (s) => s.id != screen.id,
      );
      ref.read(canvasProvider.notifier).setCurrentScreen(otherScreen);
    }

    ref.read(projectProvider.notifier).removeScreen(screen.id!);
  }

  void _renameScreen(ScreenModel screen) {
    showDialog(
      context: context,
      builder: (context) => _RenameScreenDialog(
        screen: screen,
        onRenamed: (newName) {
          final updatedScreen = screen.copyWith(name: newName);
          ref.read(projectProvider.notifier).updateScreen(updatedScreen);
        },
      ),
    );
  }

  void _duplicateScreen(ScreenModel screen) {
    final duplicatedScreen = screen.duplicate(newName: '${screen.name} Copy');
    ref.read(projectProvider.notifier).addScreen(duplicatedScreen);
    ref.read(canvasProvider.notifier).setCurrentScreen(duplicatedScreen);
  }

  void _setAsMainScreen(ScreenModel screen) {
    ref.read(projectProvider.notifier).setMainScreen(screen.id!);
  }

  ScreenModel _createScreenFromTemplate(
    ScreenTemplate template,
    int screenNumber,
  ) {
    switch (template) {
      case ScreenTemplate.blank:
        return ScreenModel.create(name: 'Screen $screenNumber');

      case ScreenTemplate.login:
        return ScreenModel.createFromTemplate(
          name: 'Login Screen',
          template: 'login',
        );

      case ScreenTemplate.home:
        return ScreenModel.createFromTemplate(
          name: 'Home Screen',
          template: 'home',
        );

      case ScreenTemplate.profile:
        return ScreenModel.createFromTemplate(
          name: 'Profile Screen',
          template: 'profile',
        );

      case ScreenTemplate.settings:
        return ScreenModel.createFromTemplate(
          name: 'Settings Screen',
          template: 'settings',
        );

      case ScreenTemplate.list:
        return ScreenModel.createFromTemplate(
          name: 'List Screen',
          template: 'list',
        );
    }
  }
}

/// Screen template types
enum ScreenTemplate { blank, login, home, profile, settings, list }

/// Dialog for renaming screens
class _RenameScreenDialog extends StatefulWidget {
  const _RenameScreenDialog({required this.screen, required this.onRenamed});

  final ScreenModel screen;
  final ValueChanged<String> onRenamed;

  @override
  State<_RenameScreenDialog> createState() => _RenameScreenDialogState();
}

class _RenameScreenDialogState extends State<_RenameScreenDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.screen.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename Screen'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Screen Name',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Rename')),
      ],
    );
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      widget.onRenamed(name);
      Navigator.of(context).pop();
    }
  }
}

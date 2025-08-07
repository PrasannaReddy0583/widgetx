import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetx/core/constants/device_frames.dart';
import 'package:widgetx/models/project_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/colors.dart';
import '../../providers/project_provider.dart';
import '../../providers/canvas_provider.dart';

/// Header component with project info and actions
class Header extends ConsumerWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentProject = ref.watch(currentProjectProvider);
    final canvasState = ref.watch(canvasProvider);

    return Container(
      height: AppConstants.headerHeight,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          // Logo and app name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.widgets,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Project info
          if (currentProject != null) ...[
            const VerticalDivider(color: AppColors.borderLight),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentProject.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${currentProject.screens.length} screens • ${currentProject.totalWidgetCount} widgets',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Spacer(),

          // Canvas controls
          Row(
            children: [
              // Device frame selector
              _DeviceFrameSelector(),

              const SizedBox(width: 8),

              // Zoom controls
              _ZoomControls(),

              const SizedBox(width: 8),

              // Canvas options
              _CanvasOptions(),

              const SizedBox(width: 16),

              // Undo/Redo
              _UndoRedoButtons(),

              const SizedBox(width: 16),

              // Project actions
              _ProjectActions(),
            ],
          ),
        ],
      ),
    );
  }
}

/// Device frame selector dropdown
class _DeviceFrameSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canvasState = ref.watch(canvasProvider);
    final canvasNotifier = ref.read(canvasProvider.notifier);

    return PopupMenuButton<DeviceFrame>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.propertyItem,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              canvasState.deviceFrame.icon,
              size: 16,
              color: AppColors.iconSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              canvasState.deviceFrame.name,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: AppColors.iconSecondary,
            ),
          ],
        ),
      ),
      itemBuilder: (context) {
        return DeviceFrame.allFrames.map((frame) {
          return PopupMenuItem<DeviceFrame>(
            value: frame,
            child: Row(
              children: [
                Icon(frame.icon, size: 16, color: AppColors.iconSecondary),
                const SizedBox(width: 8),
                Text(frame.name),
                const Spacer(),
                Text(
                  '${frame.width.toInt()}×${frame.height.toInt()}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      onSelected: (frame) {
        canvasNotifier.setDeviceFrame(frame);
      },
    );
  }
}

/// Zoom controls
class _ZoomControls extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canvasState = ref.watch(canvasProvider);
    final canvasNotifier = ref.read(canvasProvider.notifier);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.zoom_out, size: 18),
          onPressed: canvasNotifier.zoomOut,
          tooltip: 'Zoom Out',
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          color: AppColors.iconSecondary,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.propertyItem,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${(canvasState.zoomLevel * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.zoom_in, size: 18),
          onPressed: canvasNotifier.zoomIn,
          tooltip: 'Zoom In',
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          color: AppColors.iconSecondary,
        ),
      ],
    );
  }
}

/// Canvas options
class _CanvasOptions extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canvasState = ref.watch(canvasProvider);
    final canvasNotifier = ref.read(canvasProvider.notifier);

    return Row(
      children: [
        IconButton(
          icon: Icon(
            canvasState.showGrid ? Icons.grid_on : Icons.grid_off,
            size: 18,
          ),
          onPressed: canvasNotifier.toggleGrid,
          tooltip: 'Toggle Grid',
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          color: canvasState.showGrid
              ? AppColors.primary
              : AppColors.iconSecondary,
        ),
        IconButton(
          icon: Icon(
            canvasState.snapToGrid ? Icons.grid_4x4 : Icons.grid_3x3,
            size: 18,
          ),
          onPressed: canvasNotifier.toggleSnapToGrid,
          tooltip: 'Toggle Snap to Grid',
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          color: canvasState.snapToGrid
              ? AppColors.primary
              : AppColors.iconSecondary,
        ),
      ],
    );
  }
}

/// Undo/Redo buttons
class _UndoRedoButtons extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canvasState = ref.watch(canvasProvider);
    final canvasNotifier = ref.read(canvasProvider.notifier);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.undo, size: 18),
          onPressed: canvasState.canUndo ? canvasNotifier.undo : null,
          tooltip: 'Undo',
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          color: canvasState.canUndo
              ? AppColors.iconPrimary
              : AppColors.iconDisabled,
        ),
        IconButton(
          icon: const Icon(Icons.redo, size: 18),
          onPressed: canvasState.canRedo ? canvasNotifier.redo : null,
          tooltip: 'Redo',
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          color: canvasState.canRedo
              ? AppColors.iconPrimary
              : AppColors.iconDisabled,
        ),
      ],
    );
  }
}

/// Project actions
class _ProjectActions extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentProject = ref.watch(currentProjectProvider);
    final projectNotifier = ref.read(projectProvider.notifier);

    return Row(
      children: [
        // Save button
        IconButton(
          icon: const Icon(Icons.save, size: 18),
          onPressed: currentProject != null
              ? projectNotifier.saveProject
              : null,
          tooltip: 'Save Project',
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          color: currentProject != null
              ? AppColors.iconPrimary
              : AppColors.iconDisabled,
        ),

        // Export button
        IconButton(
          icon: const Icon(Icons.download, size: 18),
          onPressed: currentProject != null
              ? () => _showExportDialog(context, ref)
              : null,
          tooltip: 'Export Project',
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          color: currentProject != null
              ? AppColors.iconPrimary
              : AppColors.iconDisabled,
        ),

        // Settings button
        IconButton(
          icon: const Icon(Icons.settings, size: 18),
          onPressed: () => _showSettingsDialog(context, ref),
          tooltip: 'Settings',
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          color: AppColors.iconSecondary,
        ),
      ],
    );
  }

  void _showExportDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Project'),
        content: const Text(
          'Export functionality will be implemented in Phase 6.',
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

  void _showSettingsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: const Text('Settings panel will be implemented in Phase 6.'),
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

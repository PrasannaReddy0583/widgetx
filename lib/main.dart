import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/storage_service.dart';
import 'models/screen_model.dart';
import 'providers/canvas_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  final storageServiceOverride = await initializeStorageService();

  // Create a container with the storage service override
  final container = ProviderContainer(overrides: [storageServiceOverride]);

  // Ensure at least one screen exists and set it as current
  final defaultScreen = ScreenModel.create(name: 'Main Screen', isMain: true);
  container.read(canvasProvider.notifier).setCurrentScreen(defaultScreen);

  // Run the app with the container's provider scope
  runApp(
    UncontrolledProviderScope(container: container, child: const WidgetXApp()),
  );
}

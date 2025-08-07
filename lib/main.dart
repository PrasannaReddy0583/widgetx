import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'screens/editor_screen.dart';
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
  runApp(UncontrolledProviderScope(
    container: container,
    child: const WidgetXApp(),
  ));
}

class WidgetXApp extends ConsumerWidget {
  const WidgetXApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'WidgetX - Flutter Low-Code Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark theme
      routerConfig: _router,
    );
  }
}

// Router configuration
final _router = GoRouter(
  initialLocation: '/editor',
  routes: [
    GoRoute(
      path: '/editor',
      name: 'editor',
      builder: (context, state) => const EditorScreen(),
    ),
    // Add more routes as needed for future features
    GoRoute(path: '/', redirect: (context, state) => '/editor'),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Page not found: ${state.matchedLocation}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/editor'),
            child: const Text('Go to Editor'),
          ),
        ],
      ),
    ),
  ),
);

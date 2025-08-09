import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'screens/dashboard/main_dashboard.dart';
import 'screens/editor/enhanced_editor_screen.dart';
import 'screens/ai_context_screen.dart';
import 'screens/settings_screen.dart';

class WidgetXApp extends ConsumerWidget {
  const WidgetXApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'WidgetX - AI Low-Code Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: _router,
    );
  }
}

// Main router configuration
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const MainDashboard(),
    ),
    GoRoute(
      path: '/editor',
      name: 'editor',
      builder: (context, state) => const EnhancedEditorScreen(),
    ),
    GoRoute(
      path: '/ai-context',
      name: 'ai-context',
      builder: (context, state) => const AIContextScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
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
            onPressed: () => context.go('/'),
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    ),
  ),
);

// settings_screen.dart content
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Account'),
            subtitle: Text('Manage your account details'),
          ),
          const ListTile(
            leading: Icon(Icons.palette),
            title: Text('Appearance'),
            subtitle: Text('Customize the look and feel'),
          ),
          const ListTile(
            leading: Icon(Icons.key),
            title: Text('API Keys'),
            subtitle: Text('Manage your AI provider API keys'),
          ),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Configure your notification preferences'),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            value: true, // Replace with actual state
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}

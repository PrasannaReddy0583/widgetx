import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/layout/main_layout.dart';
import '../widgets/layout/header.dart';

/// Main editor screen containing the low-code platform interface
class EditorScreen extends ConsumerWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Column(
        children: [
          // Header with project controls and device frame selector
          Header(),
          
          // Main layout with three panels
          Expanded(
            child: MainLayout(),
          ),
        ],
      ),
    );
  }
}

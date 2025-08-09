import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetx/widgets/canvas/enhanced_drag_drop_system.dart';
import 'package:widgetx/providers/widget_library_provider.dart';
import 'package:widgetx/core/constants/widget_types.dart';

void main() {
  group('Enhanced Drag Drop System Tests', () {
    testWidgets('Should create DraggableWidgetItem correctly', (WidgetTester tester) async {
      final widgetDefinition = WidgetDefinition(
        type: FlutterWidgetType.container,
        name: 'Container',
        description: 'A container widget',
        icon: Icons.crop_square,
        category: WidgetCategory.layout,
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DraggableWidgetItem(
                definition: widgetDefinition,
                child: Container(
                  width: 100,
                  height: 50,
                  child: const Text('Drag Me'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Drag Me'), findsOneWidget);
    });

    testWidgets('Should create EnhancedDragDropSystem', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: EnhancedDragDropSystem(
                isCanvas: true,
                child: Container(
                  width: 200,
                  height: 200,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(EnhancedDragDropSystem), findsOneWidget);
    });
  });
}

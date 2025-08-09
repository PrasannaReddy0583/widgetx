import 'package:flutter/material.dart';
import 'models/widget_model.dart';
import 'widgets/canvas/flutter_widget_renderer.dart';
import 'core/constants/widget_types.dart';

/// Simple test widget to demonstrate enhanced widget rendering
class TestEnhancedWidgets extends StatelessWidget {
  const TestEnhancedWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Widget Rendering Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test 1: Container with Text Child',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildContainerWithText(),
            const SizedBox(height: 32),
            
            const Text(
              'Test 2: Column with Multiple Children',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildColumnWithChildren(),
            const SizedBox(height: 32),
            
            const Text(
              'Test 3: Row with Buttons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRowWithButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerWithText() {
    // Create a container widget with a text child
    final containerWidget = WidgetModel.create(
      type: FlutterWidgetType.container,
      position: const Offset(0, 0),
      size: const Size(200, 100),
      properties: {
        'width': 200.0,
        'height': 100.0,
        'color': Colors.blue.withOpacity(0.2).value,
        'borderRadius': 12.0,
        'borderColor': Colors.blue.value,
        'borderWidth': 2.0,
      },
    );

    final textWidget = WidgetModel.create(
      type: FlutterWidgetType.text,
      position: const Offset(0, 0),
    ).copyWith(
      parentId: containerWidget.id,
      properties: {
        'text': 'Hello Container!',
        'fontSize': 16.0,
        'color': Colors.blue.value,
        'textAlign': 'center',
      },
    );

    // Add the text as a child to the container
    final containerWithChild = containerWidget.addChild(textWidget);

    return FlutterWidgetRenderer.render(
      containerWithChild,
      applyPositioning: false,
    );
  }

  Widget _buildColumnWithChildren() {
    // Create a column widget with multiple children
    final columnWidget = WidgetModel.create(
      type: FlutterWidgetType.column,
      position: const Offset(0, 0),
      properties: {
        'mainAxisAlignment': 'center',
        'crossAxisAlignment': 'start',
      },
    );

    final text1 = WidgetModel.create(
      type: FlutterWidgetType.text,
      position: const Offset(0, 0),
    ).copyWith(
      parentId: columnWidget.id,
      properties: {
        'text': 'First Item',
        'fontSize': 16.0,
        'color': Colors.black.value,
      },
    );

    final text2 = WidgetModel.create(
      type: FlutterWidgetType.text,
      position: const Offset(0, 0),
    ).copyWith(
      parentId: columnWidget.id,
      properties: {
        'text': 'Second Item',
        'fontSize': 14.0,
        'color': Colors.grey.value,
      },
    );

    final text3 = WidgetModel.create(
      type: FlutterWidgetType.text,
      position: const Offset(0, 0),
    ).copyWith(
      parentId: columnWidget.id,
      properties: {
        'text': 'Third Item',
        'fontSize': 12.0,
        'color': Colors.red.value,
      },
    );

    // Add children to the column
    final columnWithChildren = columnWidget
        .addChild(text1)
        .addChild(text2)
        .addChild(text3);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FlutterWidgetRenderer.render(
        columnWithChildren,
        applyPositioning: false,
      ),
    );
  }

  Widget _buildRowWithButtons() {
    // Create a row widget with button children
    final rowWidget = WidgetModel.create(
      type: FlutterWidgetType.row,
      position: const Offset(0, 0),
      properties: {
        'mainAxisAlignment': 'spaceEvenly',
        'crossAxisAlignment': 'center',
      },
    );

    final button1 = WidgetModel.create(
      type: FlutterWidgetType.elevatedButton,
      position: const Offset(0, 0),
    ).copyWith(
      parentId: rowWidget.id,
      properties: {
        'text': 'Button 1',
        'backgroundColor': Colors.blue.value,
        'foregroundColor': Colors.white.value,
      },
    );

    final button2 = WidgetModel.create(
      type: FlutterWidgetType.elevatedButton,
      position: const Offset(0, 0),
    ).copyWith(
      parentId: rowWidget.id,
      properties: {
        'text': 'Button 2',
        'backgroundColor': Colors.green.value,
        'foregroundColor': Colors.white.value,
      },
    );

    final button3 = WidgetModel.create(
      type: FlutterWidgetType.elevatedButton,
      position: const Offset(0, 0),
    ).copyWith(
      parentId: rowWidget.id,
      properties: {
        'text': 'Button 3',
        'backgroundColor': Colors.orange.value,
        'foregroundColor': Colors.white.value,
      },
    );

    // Add children to the row
    final rowWithChildren = rowWidget
        .addChild(button1)
        .addChild(button2)
        .addChild(button3);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FlutterWidgetRenderer.render(
        rowWithChildren,
        applyPositioning: false,
      ),
    );
  }
}

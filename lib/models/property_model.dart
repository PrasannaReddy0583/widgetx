import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../core/constants/widget_types.dart';

part 'property_model.freezed.dart';
part 'property_model.g.dart';

/// Model representing a widget property definition
@freezed
abstract class PropertyDefinition with _$PropertyDefinition {
  const factory PropertyDefinition({
    required String name,
    required String displayName,
    required PropertyType type,
    required dynamic defaultValue,
    String? description,
    @Default(false) bool isRequired,
    @Default(true) bool isEditable,
    @Default([]) List<dynamic> options,
    double? minValue,
    double? maxValue,
    String? category,
    @Default({}) Map<String, dynamic> metadata,
  }) = _PropertyDefinition;

  factory PropertyDefinition.fromJson(Map<String, dynamic> json) =>
      _$PropertyDefinitionFromJson(json);
}

/// Model representing a property value with validation
@freezed
abstract class PropertyValue with _$PropertyValue {
  const factory PropertyValue({
    required String propertyName,
    required dynamic value,
    @Default(true) bool isValid,
    String? errorMessage,
    DateTime? lastModified,
  }) = _PropertyValue;

  factory PropertyValue.fromJson(Map<String, dynamic> json) =>
      _$PropertyValueFromJson(json);
}

/// Property definitions for different widget types
class WidgetPropertyDefinitions {
  static Map<FlutterWidgetType, List<PropertyDefinition>> get definitions => {
    FlutterWidgetType.container: [
      const PropertyDefinition(
        name: 'width',
        displayName: 'Width',
        type: PropertyType.number,
        defaultValue: 200.0,
        minValue: 0,
        category: 'Layout',
      ),
      const PropertyDefinition(
        name: 'height',
        displayName: 'Height',
        type: PropertyType.number,
        defaultValue: 100.0,
        minValue: 0,
        category: 'Layout',
      ),
      PropertyDefinition(
        name: 'color',
        displayName: 'Background Color',
        type: PropertyType.color,
        defaultValue: Colors.blue.value,
        category: 'Style',
      ),
      const PropertyDefinition(
        name: 'padding',
        displayName: 'Padding',
        type: PropertyType.edgeInsets,
        defaultValue: 16.0,
        category: 'Layout',
      ),
      const PropertyDefinition(
        name: 'margin',
        displayName: 'Margin',
        type: PropertyType.edgeInsets,
        defaultValue: 8.0,
        category: 'Layout',
      ),
      const PropertyDefinition(
        name: 'borderRadius',
        displayName: 'Border Radius',
        type: PropertyType.borderRadius,
        defaultValue: 8.0,
        category: 'Style',
      ),
      PropertyDefinition(
        name: 'borderColor',
        displayName: 'Border Color',
        type: PropertyType.color,
        defaultValue: Colors.transparent.value,
        category: 'Style',
      ),
      const PropertyDefinition(
        name: 'borderWidth',
        displayName: 'Border Width',
        type: PropertyType.number,
        defaultValue: 0.0,
        minValue: 0,
        category: 'Style',
      ),
      PropertyDefinition(
        name: 'alignment',
        displayName: 'Alignment',
        type: PropertyType.alignment,
        defaultValue: 'center',
        options: AlignmentOption.values.map((e) => e.name).toList(),
        category: 'Layout',
      ),
    ],

    FlutterWidgetType.text: [
      const PropertyDefinition(
        name: 'text',
        displayName: 'Text',
        type: PropertyType.text,
        defaultValue: 'Text',
        isRequired: true,
        category: 'Content',
      ),
      const PropertyDefinition(
        name: 'fontSize',
        displayName: 'Font Size',
        type: PropertyType.number,
        defaultValue: 16.0,
        minValue: 8,
        maxValue: 72,
        category: 'Style',
      ),
      const PropertyDefinition(
        name: 'fontWeight',
        displayName: 'Font Weight',
        type: PropertyType.dropdown,
        defaultValue: 'normal',
        options: [
          'normal',
          'bold',
          'w100',
          'w200',
          'w300',
          'w400',
          'w500',
          'w600',
          'w700',
          'w800',
          'w900',
        ],
        category: 'Style',
      ),
      PropertyDefinition(
        name: 'color',
        displayName: 'Text Color',
        type: PropertyType.color,
        defaultValue: Colors.black.value,
        category: 'Style',
      ),
      const PropertyDefinition(
        name: 'textAlign',
        displayName: 'Text Alignment',
        type: PropertyType.dropdown,
        defaultValue: 'left',
        options: ['left', 'center', 'right', 'justify'],
        category: 'Style',
      ),
      const PropertyDefinition(
        name: 'maxLines',
        displayName: 'Max Lines',
        type: PropertyType.number,
        defaultValue: null,
        minValue: 1,
        category: 'Layout',
      ),
    ],

    FlutterWidgetType.elevatedButton: [
      const PropertyDefinition(
        name: 'text',
        displayName: 'Button Text',
        type: PropertyType.text,
        defaultValue: 'Button',
        isRequired: true,
        category: 'Content',
      ),
      const PropertyDefinition(
        name: 'onPressed',
        displayName: 'On Pressed',
        type: PropertyType.text,
        defaultValue: 'null',
        category: 'Actions',
      ),
      PropertyDefinition(
        name: 'backgroundColor',
        displayName: 'Background Color',
        type: PropertyType.color,
        defaultValue: Colors.blue.value,
        category: 'Style',
      ),
      PropertyDefinition(
        name: 'foregroundColor',
        displayName: 'Text Color',
        type: PropertyType.color,
        defaultValue: Colors.white.value,
        category: 'Style',
      ),
      const PropertyDefinition(
        name: 'elevation',
        displayName: 'Elevation',
        type: PropertyType.number,
        defaultValue: 2.0,
        minValue: 0,
        maxValue: 24,
        category: 'Style',
      ),
    ],

    FlutterWidgetType.textField: [
      const PropertyDefinition(
        name: 'hintText',
        displayName: 'Hint Text',
        type: PropertyType.text,
        defaultValue: 'Enter text',
        category: 'Content',
      ),
      const PropertyDefinition(
        name: 'labelText',
        displayName: 'Label Text',
        type: PropertyType.text,
        defaultValue: 'Label',
        category: 'Content',
      ),
      const PropertyDefinition(
        name: 'borderType',
        displayName: 'Border Type',
        type: PropertyType.dropdown,
        defaultValue: 'outline',
        options: ['outline', 'underline', 'none'],
        category: 'Style',
      ),
      const PropertyDefinition(
        name: 'filled',
        displayName: 'Filled',
        type: PropertyType.boolean,
        defaultValue: true,
        category: 'Style',
      ),
      const PropertyDefinition(
        name: 'obscureText',
        displayName: 'Obscure Text',
        type: PropertyType.boolean,
        defaultValue: false,
        category: 'Behavior',
      ),
    ],

    FlutterWidgetType.image: [
      const PropertyDefinition(
        name: 'src',
        displayName: 'Image Source',
        type: PropertyType.image,
        defaultValue: 'assets/images/placeholder.png',
        isRequired: true,
        category: 'Content',
      ),
      const PropertyDefinition(
        name: 'fit',
        displayName: 'Fit',
        type: PropertyType.dropdown,
        defaultValue: 'cover',
        options: [
          'cover',
          'contain',
          'fill',
          'fitWidth',
          'fitHeight',
          'none',
          'scaleDown',
        ],
        category: 'Layout',
      ),
      const PropertyDefinition(
        name: 'width',
        displayName: 'Width',
        type: PropertyType.number,
        defaultValue: 150.0,
        minValue: 0,
        category: 'Layout',
      ),
      const PropertyDefinition(
        name: 'height',
        displayName: 'Height',
        type: PropertyType.number,
        defaultValue: 150.0,
        minValue: 0,
        category: 'Layout',
      ),
    ],

    FlutterWidgetType.icon: [
      PropertyDefinition(
        name: 'icon',
        displayName: 'Icon',
        type: PropertyType.icon,
        defaultValue: Icons.star.codePoint,
        isRequired: true,
        category: 'Content',
      ),
      const PropertyDefinition(
        name: 'size',
        displayName: 'Size',
        type: PropertyType.number,
        defaultValue: 24.0,
        minValue: 8,
        maxValue: 128,
        category: 'Style',
      ),
      PropertyDefinition(
        name: 'color',
        displayName: 'Color',
        type: PropertyType.color,
        defaultValue: Colors.black.value,
        category: 'Style',
      ),
    ],

    FlutterWidgetType.row: [
      PropertyDefinition(
        name: 'mainAxisAlignment',
        displayName: 'Main Axis Alignment',
        type: PropertyType.dropdown,
        defaultValue: 'start',
        options: MainAxisAlignmentOption.values.map((e) => e.name).toList(),
        category: 'Layout',
      ),
      PropertyDefinition(
        name: 'crossAxisAlignment',
        displayName: 'Cross Axis Alignment',
        type: PropertyType.dropdown,
        defaultValue: 'center',
        options: CrossAxisAlignmentOption.values.map((e) => e.name).toList(),
        category: 'Layout',
      ),
      const PropertyDefinition(
        name: 'mainAxisSize',
        displayName: 'Main Axis Size',
        type: PropertyType.dropdown,
        defaultValue: 'max',
        options: ['max', 'min'],
        category: 'Layout',
      ),
    ],

    FlutterWidgetType.column: [
      PropertyDefinition(
        name: 'mainAxisAlignment',
        displayName: 'Main Axis Alignment',
        type: PropertyType.dropdown,
        defaultValue: 'start',
        options: MainAxisAlignmentOption.values.map((e) => e.name).toList(),
        category: 'Layout',
      ),
      PropertyDefinition(
        name: 'crossAxisAlignment',
        displayName: 'Cross Axis Alignment',
        type: PropertyType.dropdown,
        defaultValue: 'center',
        options: CrossAxisAlignmentOption.values.map((e) => e.name).toList(),
        category: 'Layout',
      ),
      const PropertyDefinition(
        name: 'mainAxisSize',
        displayName: 'Main Axis Size',
        type: PropertyType.dropdown,
        defaultValue: 'max',
        options: ['max', 'min'],
        category: 'Layout',
      ),
    ],
  };

  /// Get property definitions for a widget type
  static List<PropertyDefinition> getPropertiesForWidget(
    FlutterWidgetType type,
  ) {
    return definitions[type] ?? [];
  }

  /// Get property definition by name for a widget type
  static PropertyDefinition? getPropertyDefinition(
    FlutterWidgetType type,
    String propertyName,
  ) {
    final properties = getPropertiesForWidget(type);
    try {
      return properties.firstWhere((prop) => prop.name == propertyName);
    } catch (e) {
      return null;
    }
  }

  /// Get properties grouped by category
  static Map<String, List<PropertyDefinition>> getPropertiesByCategory(
    FlutterWidgetType type,
  ) {
    final properties = getPropertiesForWidget(type);
    final grouped = <String, List<PropertyDefinition>>{};

    for (final property in properties) {
      final category = property.category ?? 'General';
      grouped[category] = [...(grouped[category] ?? []), property];
    }

    return grouped;
  }

  /// Validate property value
  static PropertyValue validateProperty(
    PropertyDefinition definition,
    dynamic value,
  ) {
    String? errorMessage;
    bool isValid = true;

    try {
      switch (definition.type) {
        case PropertyType.text:
          if (definition.isRequired &&
              (value == null || value.toString().isEmpty)) {
            errorMessage = '${definition.displayName} is required';
            isValid = false;
          }
          break;

        case PropertyType.number:
          final numValue = double.tryParse(value.toString());
          if (numValue == null) {
            errorMessage = '${definition.displayName} must be a number';
            isValid = false;
          } else {
            if (definition.minValue != null &&
                numValue < definition.minValue!) {
              errorMessage =
                  '${definition.displayName} must be at least ${definition.minValue}';
              isValid = false;
            }
            if (definition.maxValue != null &&
                numValue > definition.maxValue!) {
              errorMessage =
                  '${definition.displayName} must be at most ${definition.maxValue}';
              isValid = false;
            }
          }
          break;

        case PropertyType.boolean:
          if (value is! bool) {
            errorMessage = '${definition.displayName} must be true or false';
            isValid = false;
          }
          break;

        case PropertyType.dropdown:
          if (!definition.options.contains(value)) {
            errorMessage =
                '${definition.displayName} must be one of: ${definition.options.join(', ')}';
            isValid = false;
          }
          break;

        case PropertyType.color:
          // Color validation - should be a valid color value
          if (value is! int || value < 0 || value > 0xFFFFFFFF) {
            errorMessage = '${definition.displayName} must be a valid color';
            isValid = false;
          }
          break;

        default:
          // Other types are considered valid for now
          break;
      }
    } catch (e) {
      errorMessage = 'Invalid value for ${definition.displayName}';
      isValid = false;
    }

    return PropertyValue(
      propertyName: definition.name,
      value: value,
      isValid: isValid,
      errorMessage: errorMessage,
      lastModified: DateTime.now(),
    );
  }
}

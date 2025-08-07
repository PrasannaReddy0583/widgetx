import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/widget_model.dart';
import '../models/property_model.dart';
import '../core/constants/widget_types.dart';

/// Properties panel state
class PropertiesState {
  const PropertiesState({
    this.selectedWidget,
    this.expandedSections = const {'Layout', 'Style'},
    this.isLoading = false,
    this.validationErrors = const {},
  });

  final WidgetModel? selectedWidget;
  final Set<String> expandedSections;
  final bool isLoading;
  final Map<String, String> validationErrors;

  PropertiesState copyWith({
    WidgetModel? selectedWidget,
    Set<String>? expandedSections,
    bool? isLoading,
    Map<String, String>? validationErrors,
  }) {
    return PropertiesState(
      selectedWidget: selectedWidget ?? this.selectedWidget,
      expandedSections: expandedSections ?? this.expandedSections,
      isLoading: isLoading ?? this.isLoading,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }

  /// Get properties grouped by category
  Map<String, List<PropertyDefinition>> get propertiesByCategory {
    if (selectedWidget == null) return {};
    return WidgetPropertyDefinitions.getPropertiesByCategory(
      selectedWidget!.type,
    );
  }

  /// Check if section is expanded
  bool isSectionExpanded(String section) {
    return expandedSections.contains(section);
  }
}

/// Properties provider
class PropertiesNotifier extends StateNotifier<PropertiesState> {
  PropertiesNotifier() : super(const PropertiesState());

  /// Set selected widget
  void setSelectedWidget(WidgetModel? widget) {
    state = state.copyWith(selectedWidget: widget, validationErrors: {});
  }

  /// Update widget property
  void updateProperty(String propertyName, dynamic value) {
    if (state.selectedWidget == null) return;

    final propertyDef = WidgetPropertyDefinitions.getPropertyDefinition(
      state.selectedWidget!.type,
      propertyName,
    );

    if (propertyDef == null) return;

    // Validate property value
    final validation = WidgetPropertyDefinitions.validateProperty(
      propertyDef,
      value,
    );

    if (!validation.isValid) {
      // Update validation errors
      final errors = Map<String, String>.from(state.validationErrors);
      errors[propertyName] = validation.errorMessage ?? 'Invalid value';
      state = state.copyWith(validationErrors: errors);
      return;
    }

    // Clear validation error if it exists
    final errors = Map<String, String>.from(state.validationErrors);
    errors.remove(propertyName);
    state = state.copyWith(validationErrors: errors);

    // Update widget properties
    final updatedProperties = Map<String, dynamic>.from(
      state.selectedWidget!.properties,
    );
    updatedProperties[propertyName] = value;

    final updatedWidget = state.selectedWidget!.copyWith(
      properties: updatedProperties,
      updatedAt: DateTime.now(),
    );

    state = state.copyWith(selectedWidget: updatedWidget);
  }

  /// Toggle section expansion
  void toggleSection(String section) {
    final expanded = Set<String>.from(state.expandedSections);

    if (expanded.contains(section)) {
      expanded.remove(section);
    } else {
      expanded.add(section);
    }

    state = state.copyWith(expandedSections: expanded);
  }

  /// Expand all sections
  void expandAllSections() {
    if (state.selectedWidget == null) return;

    final allSections = state.propertiesByCategory.keys.toSet();
    state = state.copyWith(expandedSections: allSections);
  }

  /// Collapse all sections
  void collapseAllSections() {
    state = state.copyWith(expandedSections: {});
  }

  /// Reset widget properties to defaults
  void resetToDefaults() {
    if (state.selectedWidget == null) return;

    final defaultProperties = WidgetModel.getDefaultProperties(
      state.selectedWidget!.type,
    );
    final updatedWidget = state.selectedWidget!.copyWith(
      properties: defaultProperties,
      updatedAt: DateTime.now(),
    );

    state = state.copyWith(selectedWidget: updatedWidget, validationErrors: {});
  }

  /// Get property value
  dynamic getPropertyValue(String propertyName) {
    if (state.selectedWidget == null) return null;
    return state.selectedWidget!.properties[propertyName];
  }

  /// Check if property has validation error
  bool hasValidationError(String propertyName) {
    return state.validationErrors.containsKey(propertyName);
  }

  /// Get validation error message
  String? getValidationError(String propertyName) {
    return state.validationErrors[propertyName];
  }

  /// Set loading state
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  /// Validate all properties
  Map<String, String> validateAllProperties() {
    if (state.selectedWidget == null) return {};

    final errors = <String, String>{};
    final properties = WidgetPropertyDefinitions.getPropertiesForWidget(
      state.selectedWidget!.type,
    );

    for (final property in properties) {
      final value = getPropertyValue(property.name);
      final validation = WidgetPropertyDefinitions.validateProperty(
        property,
        value,
      );

      if (!validation.isValid) {
        errors[property.name] = validation.errorMessage ?? 'Invalid value';
      }
    }

    state = state.copyWith(validationErrors: errors);
    return errors;
  }

  /// Check if widget has any validation errors
  bool get hasAnyErrors => state.validationErrors.isNotEmpty;

  /// Get all validation errors
  Map<String, String> get allErrors => state.validationErrors;
}

/// Properties provider
final propertiesProvider =
    StateNotifierProvider<PropertiesNotifier, PropertiesState>((ref) {
      return PropertiesNotifier();
    });

/// Property editor widgets
class PropertyEditors {
  /// Create property editor widget based on type
  static Widget createEditor({
    required PropertyDefinition definition,
    required dynamic value,
    required Function(dynamic) onChanged,
    String? errorMessage,
  }) {
    switch (definition.type) {
      case PropertyType.text:
        return _TextPropertyEditor(
          definition: definition,
          value: value?.toString() ?? '',
          onChanged: onChanged,
          errorMessage: errorMessage,
        );

      case PropertyType.number:
        return _NumberPropertyEditor(
          definition: definition,
          value:
              value?.toDouble() ?? definition.defaultValue?.toDouble() ?? 0.0,
          onChanged: onChanged,
          errorMessage: errorMessage,
        );

      case PropertyType.boolean:
        return _BooleanPropertyEditor(
          definition: definition,
          value: value ?? definition.defaultValue ?? false,
          onChanged: onChanged,
        );

      case PropertyType.color:
        return _ColorPropertyEditor(
          definition: definition,
          value: value ?? definition.defaultValue ?? Colors.blue.value,
          onChanged: onChanged,
        );

      case PropertyType.dropdown:
        return _DropdownPropertyEditor(
          definition: definition,
          value: value ?? definition.defaultValue,
          onChanged: onChanged,
          errorMessage: errorMessage,
        );

      case PropertyType.alignment:
        return _AlignmentPropertyEditor(
          definition: definition,
          value: value ?? definition.defaultValue,
          onChanged: onChanged,
        );

      case PropertyType.edgeInsets:
        return _EdgeInsetsPropertyEditor(
          definition: definition,
          value:
              value?.toDouble() ?? definition.defaultValue?.toDouble() ?? 0.0,
          onChanged: onChanged,
          errorMessage: errorMessage,
        );

      default:
        return _TextPropertyEditor(
          definition: definition,
          value: value?.toString() ?? '',
          onChanged: onChanged,
          errorMessage: errorMessage,
        );
    }
  }
}

/// Text property editor
class _TextPropertyEditor extends StatelessWidget {
  const _TextPropertyEditor({
    required this.definition,
    required this.value,
    required this.onChanged,
    this.errorMessage,
  });

  final PropertyDefinition definition;
  final String value;
  final Function(String) onChanged;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            labelText: definition.displayName,
            hintText: definition.description,
            errorText: errorMessage,
            isDense: true,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Number property editor
class _NumberPropertyEditor extends StatelessWidget {
  const _NumberPropertyEditor({
    required this.definition,
    required this.value,
    required this.onChanged,
    this.errorMessage,
  });

  final PropertyDefinition definition;
  final double value;
  final Function(double) onChanged;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: value.toString(),
          decoration: InputDecoration(
            labelText: definition.displayName,
            hintText: definition.description,
            errorText: errorMessage,
            isDense: true,
          ),
          keyboardType: TextInputType.number,
          onChanged: (text) {
            final parsed = double.tryParse(text);
            if (parsed != null) {
              onChanged(parsed);
            }
          },
        ),
        if (definition.minValue != null || definition.maxValue != null)
          Slider(
            value: value.clamp(
              definition.minValue ?? 0,
              definition.maxValue ?? 100,
            ),
            min: definition.minValue ?? 0,
            max: definition.maxValue ?? 100,
            onChanged: onChanged,
          ),
      ],
    );
  }
}

/// Boolean property editor
class _BooleanPropertyEditor extends StatelessWidget {
  const _BooleanPropertyEditor({
    required this.definition,
    required this.value,
    required this.onChanged,
  });

  final PropertyDefinition definition;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(definition.displayName),
      subtitle: definition.description != null
          ? Text(definition.description!)
          : null,
      value: value,
      onChanged: onChanged,
      dense: true,
    );
  }
}

/// Color property editor
class _ColorPropertyEditor extends StatelessWidget {
  const _ColorPropertyEditor({
    required this.definition,
    required this.value,
    required this.onChanged,
  });

  final PropertyDefinition definition;
  final int value;
  final Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(definition.displayName),
      subtitle: definition.description != null
          ? Text(definition.description!)
          : null,
      trailing: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color(value),
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onTap: () {
        // TODO: Implement color picker dialog
        // For now, cycle through some common colors
        final colors = [
          Colors.blue.value,
          Colors.red.value,
          Colors.green.value,
          Colors.orange.value,
          Colors.purple.value,
          Colors.teal.value,
        ];
        final currentIndex = colors.indexOf(value);
        final nextIndex = (currentIndex + 1) % colors.length;
        onChanged(colors[nextIndex]);
      },
      dense: true,
    );
  }
}

/// Dropdown property editor
class _DropdownPropertyEditor extends StatelessWidget {
  const _DropdownPropertyEditor({
    required this.definition,
    required this.value,
    required this.onChanged,
    this.errorMessage,
  });

  final PropertyDefinition definition;
  final dynamic value;
  final Function(dynamic) onChanged;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField(
          value: value,
          decoration: InputDecoration(
            labelText: definition.displayName,
            errorText: errorMessage,
            isDense: true,
          ),
          items: definition.options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option.toString()),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Alignment property editor
class _AlignmentPropertyEditor extends StatelessWidget {
  const _AlignmentPropertyEditor({
    required this.definition,
    required this.value,
    required this.onChanged,
  });

  final PropertyDefinition definition;
  final dynamic value;
  final Function(dynamic) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(definition.displayName),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: AlignmentOption.values.map((option) {
            final isSelected = value == option.name;
            return GestureDetector(
              onTap: () => onChanged(option.name),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    option.displayName.split(' ').map((w) => w[0]).join(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// EdgeInsets property editor
class _EdgeInsetsPropertyEditor extends StatelessWidget {
  const _EdgeInsetsPropertyEditor({
    required this.definition,
    required this.value,
    required this.onChanged,
    this.errorMessage,
  });

  final PropertyDefinition definition;
  final double value;
  final Function(double) onChanged;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(definition.displayName),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: value.toString(),
                decoration: InputDecoration(
                  labelText: 'All',
                  errorText: errorMessage,
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  final parsed = double.tryParse(text);
                  if (parsed != null) {
                    onChanged(parsed);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

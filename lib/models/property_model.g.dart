// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PropertyDefinition _$PropertyDefinitionFromJson(Map<String, dynamic> json) =>
    _PropertyDefinition(
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      type: $enumDecode(_$PropertyTypeEnumMap, json['type']),
      defaultValue: json['defaultValue'],
      description: json['description'] as String?,
      isRequired: json['isRequired'] as bool? ?? false,
      isEditable: json['isEditable'] as bool? ?? true,
      options: json['options'] as List<dynamic>? ?? const [],
      minValue: (json['minValue'] as num?)?.toDouble(),
      maxValue: (json['maxValue'] as num?)?.toDouble(),
      category: json['category'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$PropertyDefinitionToJson(_PropertyDefinition instance) =>
    <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'type': _$PropertyTypeEnumMap[instance.type]!,
      'defaultValue': instance.defaultValue,
      'description': instance.description,
      'isRequired': instance.isRequired,
      'isEditable': instance.isEditable,
      'options': instance.options,
      'minValue': instance.minValue,
      'maxValue': instance.maxValue,
      'category': instance.category,
      'metadata': instance.metadata,
    };

const _$PropertyTypeEnumMap = {
  PropertyType.text: 'text',
  PropertyType.number: 'number',
  PropertyType.boolean: 'boolean',
  PropertyType.color: 'color',
  PropertyType.dropdown: 'dropdown',
  PropertyType.alignment: 'alignment',
  PropertyType.edgeInsets: 'edgeInsets',
  PropertyType.borderRadius: 'borderRadius',
  PropertyType.boxShadow: 'boxShadow',
  PropertyType.textStyle: 'textStyle',
  PropertyType.icon: 'icon',
  PropertyType.image: 'image',
  PropertyType.list: 'list',
};

_PropertyValue _$PropertyValueFromJson(Map<String, dynamic> json) =>
    _PropertyValue(
      propertyName: json['propertyName'] as String,
      value: json['value'],
      isValid: json['isValid'] as bool? ?? true,
      errorMessage: json['errorMessage'] as String?,
      lastModified: json['lastModified'] == null
          ? null
          : DateTime.parse(json['lastModified'] as String),
    );

Map<String, dynamic> _$PropertyValueToJson(_PropertyValue instance) =>
    <String, dynamic>{
      'propertyName': instance.propertyName,
      'value': instance.value,
      'isValid': instance.isValid,
      'errorMessage': instance.errorMessage,
      'lastModified': instance.lastModified?.toIso8601String(),
    };

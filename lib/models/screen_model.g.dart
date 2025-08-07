// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScreenModel _$ScreenModelFromJson(Map<String, dynamic> json) => _ScreenModel(
  id: json['id'] as String?,
  name: json['name'] as String,
  widgets:
      (json['widgets'] as List<dynamic>?)
          ?.map((e) => WidgetModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  isMain: json['isMain'] as bool? ?? false,
  route: json['route'] as String? ?? '',
  properties: json['properties'] as Map<String, dynamic>? ?? const {},
  deviceFrame: json['deviceFrame'] == null
      ? DeviceFrame.iphone14
      : const DeviceFrameConverter().fromJson(json['deviceFrame'] as String),
  backgroundColor: json['backgroundColor'] == null
      ? const Color(0xFFFFFFFF)
      : const ColorConverter().fromJson(
          (json['backgroundColor'] as num).toInt(),
        ),
  showAppBar: json['showAppBar'] as bool? ?? true,
  appBarTitle: json['appBarTitle'] as String? ?? '',
  showBottomNavBar: json['showBottomNavBar'] as bool? ?? false,
  navigationItems:
      (json['navigationItems'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  responsiveSettings:
      json['responsiveSettings'] as Map<String, dynamic>? ?? const {},
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  description: json['description'] as String?,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$ScreenModelToJson(
  _ScreenModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'widgets': instance.widgets,
  'isMain': instance.isMain,
  'route': instance.route,
  'properties': instance.properties,
  'deviceFrame': const DeviceFrameConverter().toJson(instance.deviceFrame),
  'backgroundColor': const ColorConverter().toJson(instance.backgroundColor),
  'showAppBar': instance.showAppBar,
  'appBarTitle': instance.appBarTitle,
  'showBottomNavBar': instance.showBottomNavBar,
  'navigationItems': instance.navigationItems,
  'responsiveSettings': instance.responsiveSettings,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'description': instance.description,
  'tags': instance.tags,
};

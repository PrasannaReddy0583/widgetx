// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WidgetModel _$WidgetModelFromJson(Map<String, dynamic> json) => _WidgetModel(
  id: json['id'] as String,
  type: $enumDecode(_$FlutterWidgetTypeEnumMap, json['type']),
  name: json['name'] as String,
  position: const OffsetConverter().fromJson(
    json['position'] as Map<String, dynamic>,
  ),
  size: const SizeConverter().fromJson(json['size'] as Map<String, dynamic>),
  properties: json['properties'] as Map<String, dynamic>? ?? const {},
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => WidgetModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  parentId: json['parentId'] as String?,
  zIndex: (json['zIndex'] as num?)?.toInt() ?? 0,
  isSelected: json['isSelected'] as bool? ?? false,
  isLocked: json['isLocked'] as bool? ?? false,
  isVisible: json['isVisible'] as bool? ?? true,
  opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
  rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
  responsiveProperties: json['responsiveProperties'] as Map<String, dynamic>?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$WidgetModelToJson(_WidgetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$FlutterWidgetTypeEnumMap[instance.type]!,
      'name': instance.name,
      'position': const OffsetConverter().toJson(instance.position),
      'size': const SizeConverter().toJson(instance.size),
      'properties': instance.properties,
      'children': instance.children,
      'parentId': instance.parentId,
      'zIndex': instance.zIndex,
      'isSelected': instance.isSelected,
      'isLocked': instance.isLocked,
      'isVisible': instance.isVisible,
      'opacity': instance.opacity,
      'rotation': instance.rotation,
      'responsiveProperties': instance.responsiveProperties,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$FlutterWidgetTypeEnumMap = {
  FlutterWidgetType.container: 'container',
  FlutterWidgetType.row: 'row',
  FlutterWidgetType.column: 'column',
  FlutterWidgetType.stack: 'stack',
  FlutterWidgetType.wrap: 'wrap',
  FlutterWidgetType.expanded: 'expanded',
  FlutterWidgetType.flexible: 'flexible',
  FlutterWidgetType.positioned: 'positioned',
  FlutterWidgetType.align: 'align',
  FlutterWidgetType.center: 'center',
  FlutterWidgetType.padding: 'padding',
  FlutterWidgetType.sizedBox: 'sizedBox',
  FlutterWidgetType.spacer: 'spacer',
  FlutterWidgetType.verticalDivider: 'verticalDivider',
  FlutterWidgetType.textField: 'textField',
  FlutterWidgetType.elevatedButton: 'elevatedButton',
  FlutterWidgetType.textButton: 'textButton',
  FlutterWidgetType.outlinedButton: 'outlinedButton',
  FlutterWidgetType.iconButton: 'iconButton',
  FlutterWidgetType.floatingActionButton: 'floatingActionButton',
  FlutterWidgetType.checkbox: 'checkbox',
  FlutterWidgetType.radio: 'radio',
  FlutterWidgetType.switchWidget: 'switchWidget',
  FlutterWidgetType.slider: 'slider',
  FlutterWidgetType.dropdownButton: 'dropdownButton',
  FlutterWidgetType.text: 'text',
  FlutterWidgetType.richText: 'richText',
  FlutterWidgetType.image: 'image',
  FlutterWidgetType.icon: 'icon',
  FlutterWidgetType.card: 'card',
  FlutterWidgetType.chip: 'chip',
  FlutterWidgetType.avatar: 'avatar',
  FlutterWidgetType.divider: 'divider',
  FlutterWidgetType.circularProgressIndicator: 'circularProgressIndicator',
  FlutterWidgetType.progressIndicator: 'progressIndicator',
  FlutterWidgetType.linearProgressIndicator: 'linearProgressIndicator',
  FlutterWidgetType.tooltip: 'tooltip',
  FlutterWidgetType.listTile: 'listTile',
  FlutterWidgetType.appBar: 'appBar',
  FlutterWidgetType.bottomNavigationBar: 'bottomNavigationBar',
  FlutterWidgetType.drawer: 'drawer',
  FlutterWidgetType.tabBar: 'tabBar',
  FlutterWidgetType.navigationRail: 'navigationRail',
  FlutterWidgetType.scaffold: 'scaffold',
  FlutterWidgetType.tabBarView: 'tabBarView',
  FlutterWidgetType.bottomSheet: 'bottomSheet',
  FlutterWidgetType.listView: 'listView',
  FlutterWidgetType.gridView: 'gridView',
  FlutterWidgetType.singleChildScrollView: 'singleChildScrollView',
  FlutterWidgetType.pageView: 'pageView',
  FlutterWidgetType.customScrollView: 'customScrollView',
  FlutterWidgetType.animatedContainer: 'animatedContainer',
  FlutterWidgetType.hero: 'hero',
  FlutterWidgetType.gestureDetector: 'gestureDetector',
  FlutterWidgetType.inkWell: 'inkWell',
  FlutterWidgetType.opacity: 'opacity',
  FlutterWidgetType.fadeTransition: 'fadeTransition',
  FlutterWidgetType.transform: 'transform',
};

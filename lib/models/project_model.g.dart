// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) =>
    _ProjectModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      screens:
          (json['screens'] as List<dynamic>?)
              ?.map((e) => ScreenModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      settings: json['settings'] as Map<String, dynamic>? ?? const {},
      version: json['version'] as String? ?? '1.0.0',
      packageName: json['packageName'] as String? ?? 'com.example.app',
      dependencies:
          (json['dependencies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      assets:
          (json['assets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      environment:
          (json['environment'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      thumbnailPath: json['thumbnailPath'] as String?,
      isTemplate: json['isTemplate'] as bool? ?? false,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      authorId: json['authorId'] as String?,
      authorName: json['authorName'] as String?,
    );

Map<String, dynamic> _$ProjectModelToJson(_ProjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'screens': instance.screens,
      'settings': instance.settings,
      'version': instance.version,
      'packageName': instance.packageName,
      'dependencies': instance.dependencies,
      'assets': instance.assets,
      'environment': instance.environment,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'thumbnailPath': instance.thumbnailPath,
      'isTemplate': instance.isTemplate,
      'tags': instance.tags,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
    };

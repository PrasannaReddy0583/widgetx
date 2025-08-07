// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectModel {

 String get id; String get name; String get description; List<ScreenModel> get screens; Map<String, dynamic> get settings; String get version; String get packageName; List<String> get dependencies; List<String> get assets; Map<String, String> get environment; DateTime? get createdAt; DateTime? get updatedAt; String? get thumbnailPath; bool get isTemplate; List<String> get tags; String? get authorId; String? get authorName;
/// Create a copy of ProjectModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectModelCopyWith<ProjectModel> get copyWith => _$ProjectModelCopyWithImpl<ProjectModel>(this as ProjectModel, _$identity);

  /// Serializes this ProjectModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.screens, screens)&&const DeepCollectionEquality().equals(other.settings, settings)&&(identical(other.version, version) || other.version == version)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&const DeepCollectionEquality().equals(other.dependencies, dependencies)&&const DeepCollectionEquality().equals(other.assets, assets)&&const DeepCollectionEquality().equals(other.environment, environment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.isTemplate, isTemplate) || other.isTemplate == isTemplate)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(screens),const DeepCollectionEquality().hash(settings),version,packageName,const DeepCollectionEquality().hash(dependencies),const DeepCollectionEquality().hash(assets),const DeepCollectionEquality().hash(environment),createdAt,updatedAt,thumbnailPath,isTemplate,const DeepCollectionEquality().hash(tags),authorId,authorName);

@override
String toString() {
  return 'ProjectModel(id: $id, name: $name, description: $description, screens: $screens, settings: $settings, version: $version, packageName: $packageName, dependencies: $dependencies, assets: $assets, environment: $environment, createdAt: $createdAt, updatedAt: $updatedAt, thumbnailPath: $thumbnailPath, isTemplate: $isTemplate, tags: $tags, authorId: $authorId, authorName: $authorName)';
}


}

/// @nodoc
abstract mixin class $ProjectModelCopyWith<$Res>  {
  factory $ProjectModelCopyWith(ProjectModel value, $Res Function(ProjectModel) _then) = _$ProjectModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, List<ScreenModel> screens, Map<String, dynamic> settings, String version, String packageName, List<String> dependencies, List<String> assets, Map<String, String> environment, DateTime? createdAt, DateTime? updatedAt, String? thumbnailPath, bool isTemplate, List<String> tags, String? authorId, String? authorName
});




}
/// @nodoc
class _$ProjectModelCopyWithImpl<$Res>
    implements $ProjectModelCopyWith<$Res> {
  _$ProjectModelCopyWithImpl(this._self, this._then);

  final ProjectModel _self;
  final $Res Function(ProjectModel) _then;

/// Create a copy of ProjectModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? screens = null,Object? settings = null,Object? version = null,Object? packageName = null,Object? dependencies = null,Object? assets = null,Object? environment = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? thumbnailPath = freezed,Object? isTemplate = null,Object? tags = null,Object? authorId = freezed,Object? authorName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,screens: null == screens ? _self.screens : screens // ignore: cast_nullable_to_non_nullable
as List<ScreenModel>,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,dependencies: null == dependencies ? _self.dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<String>,assets: null == assets ? _self.assets : assets // ignore: cast_nullable_to_non_nullable
as List<String>,environment: null == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as Map<String, String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,isTemplate: null == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectModel].
extension ProjectModelPatterns on ProjectModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectModel value)  $default,){
final _that = this;
switch (_that) {
case _ProjectModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  List<ScreenModel> screens,  Map<String, dynamic> settings,  String version,  String packageName,  List<String> dependencies,  List<String> assets,  Map<String, String> environment,  DateTime? createdAt,  DateTime? updatedAt,  String? thumbnailPath,  bool isTemplate,  List<String> tags,  String? authorId,  String? authorName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.screens,_that.settings,_that.version,_that.packageName,_that.dependencies,_that.assets,_that.environment,_that.createdAt,_that.updatedAt,_that.thumbnailPath,_that.isTemplate,_that.tags,_that.authorId,_that.authorName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  List<ScreenModel> screens,  Map<String, dynamic> settings,  String version,  String packageName,  List<String> dependencies,  List<String> assets,  Map<String, String> environment,  DateTime? createdAt,  DateTime? updatedAt,  String? thumbnailPath,  bool isTemplate,  List<String> tags,  String? authorId,  String? authorName)  $default,) {final _that = this;
switch (_that) {
case _ProjectModel():
return $default(_that.id,_that.name,_that.description,_that.screens,_that.settings,_that.version,_that.packageName,_that.dependencies,_that.assets,_that.environment,_that.createdAt,_that.updatedAt,_that.thumbnailPath,_that.isTemplate,_that.tags,_that.authorId,_that.authorName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  List<ScreenModel> screens,  Map<String, dynamic> settings,  String version,  String packageName,  List<String> dependencies,  List<String> assets,  Map<String, String> environment,  DateTime? createdAt,  DateTime? updatedAt,  String? thumbnailPath,  bool isTemplate,  List<String> tags,  String? authorId,  String? authorName)?  $default,) {final _that = this;
switch (_that) {
case _ProjectModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.screens,_that.settings,_that.version,_that.packageName,_that.dependencies,_that.assets,_that.environment,_that.createdAt,_that.updatedAt,_that.thumbnailPath,_that.isTemplate,_that.tags,_that.authorId,_that.authorName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectModel implements ProjectModel {
  const _ProjectModel({required this.id, required this.name, required this.description, final  List<ScreenModel> screens = const [], final  Map<String, dynamic> settings = const {}, this.version = '1.0.0', this.packageName = 'com.example.app', final  List<String> dependencies = const [], final  List<String> assets = const [], final  Map<String, String> environment = const {}, this.createdAt, this.updatedAt, this.thumbnailPath, this.isTemplate = false, final  List<String> tags = const [], this.authorId, this.authorName}): _screens = screens,_settings = settings,_dependencies = dependencies,_assets = assets,_environment = environment,_tags = tags;
  factory _ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
 final  List<ScreenModel> _screens;
@override@JsonKey() List<ScreenModel> get screens {
  if (_screens is EqualUnmodifiableListView) return _screens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_screens);
}

 final  Map<String, dynamic> _settings;
@override@JsonKey() Map<String, dynamic> get settings {
  if (_settings is EqualUnmodifiableMapView) return _settings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_settings);
}

@override@JsonKey() final  String version;
@override@JsonKey() final  String packageName;
 final  List<String> _dependencies;
@override@JsonKey() List<String> get dependencies {
  if (_dependencies is EqualUnmodifiableListView) return _dependencies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dependencies);
}

 final  List<String> _assets;
@override@JsonKey() List<String> get assets {
  if (_assets is EqualUnmodifiableListView) return _assets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assets);
}

 final  Map<String, String> _environment;
@override@JsonKey() Map<String, String> get environment {
  if (_environment is EqualUnmodifiableMapView) return _environment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_environment);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  String? thumbnailPath;
@override@JsonKey() final  bool isTemplate;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String? authorId;
@override final  String? authorName;

/// Create a copy of ProjectModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectModelCopyWith<_ProjectModel> get copyWith => __$ProjectModelCopyWithImpl<_ProjectModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._screens, _screens)&&const DeepCollectionEquality().equals(other._settings, _settings)&&(identical(other.version, version) || other.version == version)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&const DeepCollectionEquality().equals(other._dependencies, _dependencies)&&const DeepCollectionEquality().equals(other._assets, _assets)&&const DeepCollectionEquality().equals(other._environment, _environment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.isTemplate, isTemplate) || other.isTemplate == isTemplate)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,const DeepCollectionEquality().hash(_screens),const DeepCollectionEquality().hash(_settings),version,packageName,const DeepCollectionEquality().hash(_dependencies),const DeepCollectionEquality().hash(_assets),const DeepCollectionEquality().hash(_environment),createdAt,updatedAt,thumbnailPath,isTemplate,const DeepCollectionEquality().hash(_tags),authorId,authorName);

@override
String toString() {
  return 'ProjectModel(id: $id, name: $name, description: $description, screens: $screens, settings: $settings, version: $version, packageName: $packageName, dependencies: $dependencies, assets: $assets, environment: $environment, createdAt: $createdAt, updatedAt: $updatedAt, thumbnailPath: $thumbnailPath, isTemplate: $isTemplate, tags: $tags, authorId: $authorId, authorName: $authorName)';
}


}

/// @nodoc
abstract mixin class _$ProjectModelCopyWith<$Res> implements $ProjectModelCopyWith<$Res> {
  factory _$ProjectModelCopyWith(_ProjectModel value, $Res Function(_ProjectModel) _then) = __$ProjectModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, List<ScreenModel> screens, Map<String, dynamic> settings, String version, String packageName, List<String> dependencies, List<String> assets, Map<String, String> environment, DateTime? createdAt, DateTime? updatedAt, String? thumbnailPath, bool isTemplate, List<String> tags, String? authorId, String? authorName
});




}
/// @nodoc
class __$ProjectModelCopyWithImpl<$Res>
    implements _$ProjectModelCopyWith<$Res> {
  __$ProjectModelCopyWithImpl(this._self, this._then);

  final _ProjectModel _self;
  final $Res Function(_ProjectModel) _then;

/// Create a copy of ProjectModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? screens = null,Object? settings = null,Object? version = null,Object? packageName = null,Object? dependencies = null,Object? assets = null,Object? environment = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? thumbnailPath = freezed,Object? isTemplate = null,Object? tags = null,Object? authorId = freezed,Object? authorName = freezed,}) {
  return _then(_ProjectModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,screens: null == screens ? _self._screens : screens // ignore: cast_nullable_to_non_nullable
as List<ScreenModel>,settings: null == settings ? _self._settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,packageName: null == packageName ? _self.packageName : packageName // ignore: cast_nullable_to_non_nullable
as String,dependencies: null == dependencies ? _self._dependencies : dependencies // ignore: cast_nullable_to_non_nullable
as List<String>,assets: null == assets ? _self._assets : assets // ignore: cast_nullable_to_non_nullable
as List<String>,environment: null == environment ? _self._environment : environment // ignore: cast_nullable_to_non_nullable
as Map<String, String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,isTemplate: null == isTemplate ? _self.isTemplate : isTemplate // ignore: cast_nullable_to_non_nullable
as bool,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as String?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'widget_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WidgetModel {

 String get id; FlutterWidgetType get type; String get name;@OffsetConverter() Offset get position;@SizeConverter() Size get size; Map<String, dynamic> get properties; List<WidgetModel> get children; String? get parentId; int get zIndex; bool get isSelected; bool get isLocked; bool get isVisible; double get opacity; double get rotation; Map<String, dynamic>? get responsiveProperties; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of WidgetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WidgetModelCopyWith<WidgetModel> get copyWith => _$WidgetModelCopyWithImpl<WidgetModel>(this as WidgetModel, _$identity);

  /// Serializes this WidgetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WidgetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.size, size) || other.size == size)&&const DeepCollectionEquality().equals(other.properties, properties)&&const DeepCollectionEquality().equals(other.children, children)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.zIndex, zIndex) || other.zIndex == zIndex)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&const DeepCollectionEquality().equals(other.responsiveProperties, responsiveProperties)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,position,size,const DeepCollectionEquality().hash(properties),const DeepCollectionEquality().hash(children),parentId,zIndex,isSelected,isLocked,isVisible,opacity,rotation,const DeepCollectionEquality().hash(responsiveProperties),createdAt,updatedAt);

@override
String toString() {
  return 'WidgetModel(id: $id, type: $type, name: $name, position: $position, size: $size, properties: $properties, children: $children, parentId: $parentId, zIndex: $zIndex, isSelected: $isSelected, isLocked: $isLocked, isVisible: $isVisible, opacity: $opacity, rotation: $rotation, responsiveProperties: $responsiveProperties, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $WidgetModelCopyWith<$Res>  {
  factory $WidgetModelCopyWith(WidgetModel value, $Res Function(WidgetModel) _then) = _$WidgetModelCopyWithImpl;
@useResult
$Res call({
 String id, FlutterWidgetType type, String name,@OffsetConverter() Offset position,@SizeConverter() Size size, Map<String, dynamic> properties, List<WidgetModel> children, String? parentId, int zIndex, bool isSelected, bool isLocked, bool isVisible, double opacity, double rotation, Map<String, dynamic>? responsiveProperties, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$WidgetModelCopyWithImpl<$Res>
    implements $WidgetModelCopyWith<$Res> {
  _$WidgetModelCopyWithImpl(this._self, this._then);

  final WidgetModel _self;
  final $Res Function(WidgetModel) _then;

/// Create a copy of WidgetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? position = null,Object? size = null,Object? properties = null,Object? children = null,Object? parentId = freezed,Object? zIndex = null,Object? isSelected = null,Object? isLocked = null,Object? isVisible = null,Object? opacity = null,Object? rotation = null,Object? responsiveProperties = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FlutterWidgetType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Offset,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as Size,properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<WidgetModel>,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,zIndex: null == zIndex ? _self.zIndex : zIndex // ignore: cast_nullable_to_non_nullable
as int,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,responsiveProperties: freezed == responsiveProperties ? _self.responsiveProperties : responsiveProperties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WidgetModel].
extension WidgetModelPatterns on WidgetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WidgetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WidgetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WidgetModel value)  $default,){
final _that = this;
switch (_that) {
case _WidgetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WidgetModel value)?  $default,){
final _that = this;
switch (_that) {
case _WidgetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  FlutterWidgetType type,  String name, @OffsetConverter()  Offset position, @SizeConverter()  Size size,  Map<String, dynamic> properties,  List<WidgetModel> children,  String? parentId,  int zIndex,  bool isSelected,  bool isLocked,  bool isVisible,  double opacity,  double rotation,  Map<String, dynamic>? responsiveProperties,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WidgetModel() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.position,_that.size,_that.properties,_that.children,_that.parentId,_that.zIndex,_that.isSelected,_that.isLocked,_that.isVisible,_that.opacity,_that.rotation,_that.responsiveProperties,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  FlutterWidgetType type,  String name, @OffsetConverter()  Offset position, @SizeConverter()  Size size,  Map<String, dynamic> properties,  List<WidgetModel> children,  String? parentId,  int zIndex,  bool isSelected,  bool isLocked,  bool isVisible,  double opacity,  double rotation,  Map<String, dynamic>? responsiveProperties,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _WidgetModel():
return $default(_that.id,_that.type,_that.name,_that.position,_that.size,_that.properties,_that.children,_that.parentId,_that.zIndex,_that.isSelected,_that.isLocked,_that.isVisible,_that.opacity,_that.rotation,_that.responsiveProperties,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  FlutterWidgetType type,  String name, @OffsetConverter()  Offset position, @SizeConverter()  Size size,  Map<String, dynamic> properties,  List<WidgetModel> children,  String? parentId,  int zIndex,  bool isSelected,  bool isLocked,  bool isVisible,  double opacity,  double rotation,  Map<String, dynamic>? responsiveProperties,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WidgetModel() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.position,_that.size,_that.properties,_that.children,_that.parentId,_that.zIndex,_that.isSelected,_that.isLocked,_that.isVisible,_that.opacity,_that.rotation,_that.responsiveProperties,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WidgetModel implements WidgetModel {
  const _WidgetModel({required this.id, required this.type, required this.name, @OffsetConverter() required this.position, @SizeConverter() required this.size, final  Map<String, dynamic> properties = const {}, final  List<WidgetModel> children = const [], this.parentId, this.zIndex = 0, this.isSelected = false, this.isLocked = false, this.isVisible = true, this.opacity = 1.0, this.rotation = 0.0, final  Map<String, dynamic>? responsiveProperties, this.createdAt, this.updatedAt}): _properties = properties,_children = children,_responsiveProperties = responsiveProperties;
  factory _WidgetModel.fromJson(Map<String, dynamic> json) => _$WidgetModelFromJson(json);

@override final  String id;
@override final  FlutterWidgetType type;
@override final  String name;
@override@OffsetConverter() final  Offset position;
@override@SizeConverter() final  Size size;
 final  Map<String, dynamic> _properties;
@override@JsonKey() Map<String, dynamic> get properties {
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_properties);
}

 final  List<WidgetModel> _children;
@override@JsonKey() List<WidgetModel> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

@override final  String? parentId;
@override@JsonKey() final  int zIndex;
@override@JsonKey() final  bool isSelected;
@override@JsonKey() final  bool isLocked;
@override@JsonKey() final  bool isVisible;
@override@JsonKey() final  double opacity;
@override@JsonKey() final  double rotation;
 final  Map<String, dynamic>? _responsiveProperties;
@override Map<String, dynamic>? get responsiveProperties {
  final value = _responsiveProperties;
  if (value == null) return null;
  if (_responsiveProperties is EqualUnmodifiableMapView) return _responsiveProperties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of WidgetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WidgetModelCopyWith<_WidgetModel> get copyWith => __$WidgetModelCopyWithImpl<_WidgetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WidgetModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WidgetModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position)&&(identical(other.size, size) || other.size == size)&&const DeepCollectionEquality().equals(other._properties, _properties)&&const DeepCollectionEquality().equals(other._children, _children)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.zIndex, zIndex) || other.zIndex == zIndex)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.rotation, rotation) || other.rotation == rotation)&&const DeepCollectionEquality().equals(other._responsiveProperties, _responsiveProperties)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,position,size,const DeepCollectionEquality().hash(_properties),const DeepCollectionEquality().hash(_children),parentId,zIndex,isSelected,isLocked,isVisible,opacity,rotation,const DeepCollectionEquality().hash(_responsiveProperties),createdAt,updatedAt);

@override
String toString() {
  return 'WidgetModel(id: $id, type: $type, name: $name, position: $position, size: $size, properties: $properties, children: $children, parentId: $parentId, zIndex: $zIndex, isSelected: $isSelected, isLocked: $isLocked, isVisible: $isVisible, opacity: $opacity, rotation: $rotation, responsiveProperties: $responsiveProperties, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WidgetModelCopyWith<$Res> implements $WidgetModelCopyWith<$Res> {
  factory _$WidgetModelCopyWith(_WidgetModel value, $Res Function(_WidgetModel) _then) = __$WidgetModelCopyWithImpl;
@override @useResult
$Res call({
 String id, FlutterWidgetType type, String name,@OffsetConverter() Offset position,@SizeConverter() Size size, Map<String, dynamic> properties, List<WidgetModel> children, String? parentId, int zIndex, bool isSelected, bool isLocked, bool isVisible, double opacity, double rotation, Map<String, dynamic>? responsiveProperties, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$WidgetModelCopyWithImpl<$Res>
    implements _$WidgetModelCopyWith<$Res> {
  __$WidgetModelCopyWithImpl(this._self, this._then);

  final _WidgetModel _self;
  final $Res Function(_WidgetModel) _then;

/// Create a copy of WidgetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? position = null,Object? size = null,Object? properties = null,Object? children = null,Object? parentId = freezed,Object? zIndex = null,Object? isSelected = null,Object? isLocked = null,Object? isVisible = null,Object? opacity = null,Object? rotation = null,Object? responsiveProperties = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_WidgetModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as FlutterWidgetType,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Offset,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as Size,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<WidgetModel>,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,zIndex: null == zIndex ? _self.zIndex : zIndex // ignore: cast_nullable_to_non_nullable
as int,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,opacity: null == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double,rotation: null == rotation ? _self.rotation : rotation // ignore: cast_nullable_to_non_nullable
as double,responsiveProperties: freezed == responsiveProperties ? _self._responsiveProperties : responsiveProperties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

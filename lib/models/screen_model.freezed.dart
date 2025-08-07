// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScreenModel {

 String? get id; String get name; List<WidgetModel> get widgets; bool get isMain; String get route; Map<String, dynamic> get properties;@DeviceFrameConverter() DeviceFrame get deviceFrame;@ColorConverter() Color get backgroundColor; bool get showAppBar; String get appBarTitle; bool get showBottomNavBar; List<String> get navigationItems; Map<String, dynamic> get responsiveSettings; DateTime? get createdAt; DateTime? get updatedAt; String? get description; List<String> get tags;
/// Create a copy of ScreenModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenModelCopyWith<ScreenModel> get copyWith => _$ScreenModelCopyWithImpl<ScreenModel>(this as ScreenModel, _$identity);

  /// Serializes this ScreenModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.widgets, widgets)&&(identical(other.isMain, isMain) || other.isMain == isMain)&&(identical(other.route, route) || other.route == route)&&const DeepCollectionEquality().equals(other.properties, properties)&&(identical(other.deviceFrame, deviceFrame) || other.deviceFrame == deviceFrame)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.showAppBar, showAppBar) || other.showAppBar == showAppBar)&&(identical(other.appBarTitle, appBarTitle) || other.appBarTitle == appBarTitle)&&(identical(other.showBottomNavBar, showBottomNavBar) || other.showBottomNavBar == showBottomNavBar)&&const DeepCollectionEquality().equals(other.navigationItems, navigationItems)&&const DeepCollectionEquality().equals(other.responsiveSettings, responsiveSettings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(widgets),isMain,route,const DeepCollectionEquality().hash(properties),deviceFrame,backgroundColor,showAppBar,appBarTitle,showBottomNavBar,const DeepCollectionEquality().hash(navigationItems),const DeepCollectionEquality().hash(responsiveSettings),createdAt,updatedAt,description,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'ScreenModel(id: $id, name: $name, widgets: $widgets, isMain: $isMain, route: $route, properties: $properties, deviceFrame: $deviceFrame, backgroundColor: $backgroundColor, showAppBar: $showAppBar, appBarTitle: $appBarTitle, showBottomNavBar: $showBottomNavBar, navigationItems: $navigationItems, responsiveSettings: $responsiveSettings, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $ScreenModelCopyWith<$Res>  {
  factory $ScreenModelCopyWith(ScreenModel value, $Res Function(ScreenModel) _then) = _$ScreenModelCopyWithImpl;
@useResult
$Res call({
 String? id, String name, List<WidgetModel> widgets, bool isMain, String route, Map<String, dynamic> properties,@DeviceFrameConverter() DeviceFrame deviceFrame,@ColorConverter() Color backgroundColor, bool showAppBar, String appBarTitle, bool showBottomNavBar, List<String> navigationItems, Map<String, dynamic> responsiveSettings, DateTime? createdAt, DateTime? updatedAt, String? description, List<String> tags
});




}
/// @nodoc
class _$ScreenModelCopyWithImpl<$Res>
    implements $ScreenModelCopyWith<$Res> {
  _$ScreenModelCopyWithImpl(this._self, this._then);

  final ScreenModel _self;
  final $Res Function(ScreenModel) _then;

/// Create a copy of ScreenModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? widgets = null,Object? isMain = null,Object? route = null,Object? properties = null,Object? deviceFrame = null,Object? backgroundColor = null,Object? showAppBar = null,Object? appBarTitle = null,Object? showBottomNavBar = null,Object? navigationItems = null,Object? responsiveSettings = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? description = freezed,Object? tags = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,widgets: null == widgets ? _self.widgets : widgets // ignore: cast_nullable_to_non_nullable
as List<WidgetModel>,isMain: null == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,deviceFrame: null == deviceFrame ? _self.deviceFrame : deviceFrame // ignore: cast_nullable_to_non_nullable
as DeviceFrame,backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as Color,showAppBar: null == showAppBar ? _self.showAppBar : showAppBar // ignore: cast_nullable_to_non_nullable
as bool,appBarTitle: null == appBarTitle ? _self.appBarTitle : appBarTitle // ignore: cast_nullable_to_non_nullable
as String,showBottomNavBar: null == showBottomNavBar ? _self.showBottomNavBar : showBottomNavBar // ignore: cast_nullable_to_non_nullable
as bool,navigationItems: null == navigationItems ? _self.navigationItems : navigationItems // ignore: cast_nullable_to_non_nullable
as List<String>,responsiveSettings: null == responsiveSettings ? _self.responsiveSettings : responsiveSettings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ScreenModel].
extension ScreenModelPatterns on ScreenModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScreenModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScreenModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScreenModel value)  $default,){
final _that = this;
switch (_that) {
case _ScreenModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScreenModel value)?  $default,){
final _that = this;
switch (_that) {
case _ScreenModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String name,  List<WidgetModel> widgets,  bool isMain,  String route,  Map<String, dynamic> properties, @DeviceFrameConverter()  DeviceFrame deviceFrame, @ColorConverter()  Color backgroundColor,  bool showAppBar,  String appBarTitle,  bool showBottomNavBar,  List<String> navigationItems,  Map<String, dynamic> responsiveSettings,  DateTime? createdAt,  DateTime? updatedAt,  String? description,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScreenModel() when $default != null:
return $default(_that.id,_that.name,_that.widgets,_that.isMain,_that.route,_that.properties,_that.deviceFrame,_that.backgroundColor,_that.showAppBar,_that.appBarTitle,_that.showBottomNavBar,_that.navigationItems,_that.responsiveSettings,_that.createdAt,_that.updatedAt,_that.description,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String name,  List<WidgetModel> widgets,  bool isMain,  String route,  Map<String, dynamic> properties, @DeviceFrameConverter()  DeviceFrame deviceFrame, @ColorConverter()  Color backgroundColor,  bool showAppBar,  String appBarTitle,  bool showBottomNavBar,  List<String> navigationItems,  Map<String, dynamic> responsiveSettings,  DateTime? createdAt,  DateTime? updatedAt,  String? description,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _ScreenModel():
return $default(_that.id,_that.name,_that.widgets,_that.isMain,_that.route,_that.properties,_that.deviceFrame,_that.backgroundColor,_that.showAppBar,_that.appBarTitle,_that.showBottomNavBar,_that.navigationItems,_that.responsiveSettings,_that.createdAt,_that.updatedAt,_that.description,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String name,  List<WidgetModel> widgets,  bool isMain,  String route,  Map<String, dynamic> properties, @DeviceFrameConverter()  DeviceFrame deviceFrame, @ColorConverter()  Color backgroundColor,  bool showAppBar,  String appBarTitle,  bool showBottomNavBar,  List<String> navigationItems,  Map<String, dynamic> responsiveSettings,  DateTime? createdAt,  DateTime? updatedAt,  String? description,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _ScreenModel() when $default != null:
return $default(_that.id,_that.name,_that.widgets,_that.isMain,_that.route,_that.properties,_that.deviceFrame,_that.backgroundColor,_that.showAppBar,_that.appBarTitle,_that.showBottomNavBar,_that.navigationItems,_that.responsiveSettings,_that.createdAt,_that.updatedAt,_that.description,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScreenModel implements ScreenModel {
  const _ScreenModel({this.id, required this.name, final  List<WidgetModel> widgets = const [], this.isMain = false, this.route = '', final  Map<String, dynamic> properties = const {}, @DeviceFrameConverter() this.deviceFrame = DeviceFrame.iphone14, @ColorConverter() this.backgroundColor = const Color(0xFFFFFFFF), this.showAppBar = true, this.appBarTitle = '', this.showBottomNavBar = false, final  List<String> navigationItems = const [], final  Map<String, dynamic> responsiveSettings = const {}, this.createdAt, this.updatedAt, this.description, final  List<String> tags = const []}): _widgets = widgets,_properties = properties,_navigationItems = navigationItems,_responsiveSettings = responsiveSettings,_tags = tags;
  factory _ScreenModel.fromJson(Map<String, dynamic> json) => _$ScreenModelFromJson(json);

@override final  String? id;
@override final  String name;
 final  List<WidgetModel> _widgets;
@override@JsonKey() List<WidgetModel> get widgets {
  if (_widgets is EqualUnmodifiableListView) return _widgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_widgets);
}

@override@JsonKey() final  bool isMain;
@override@JsonKey() final  String route;
 final  Map<String, dynamic> _properties;
@override@JsonKey() Map<String, dynamic> get properties {
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_properties);
}

@override@JsonKey()@DeviceFrameConverter() final  DeviceFrame deviceFrame;
@override@JsonKey()@ColorConverter() final  Color backgroundColor;
@override@JsonKey() final  bool showAppBar;
@override@JsonKey() final  String appBarTitle;
@override@JsonKey() final  bool showBottomNavBar;
 final  List<String> _navigationItems;
@override@JsonKey() List<String> get navigationItems {
  if (_navigationItems is EqualUnmodifiableListView) return _navigationItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_navigationItems);
}

 final  Map<String, dynamic> _responsiveSettings;
@override@JsonKey() Map<String, dynamic> get responsiveSettings {
  if (_responsiveSettings is EqualUnmodifiableMapView) return _responsiveSettings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_responsiveSettings);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  String? description;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of ScreenModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScreenModelCopyWith<_ScreenModel> get copyWith => __$ScreenModelCopyWithImpl<_ScreenModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScreenModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScreenModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._widgets, _widgets)&&(identical(other.isMain, isMain) || other.isMain == isMain)&&(identical(other.route, route) || other.route == route)&&const DeepCollectionEquality().equals(other._properties, _properties)&&(identical(other.deviceFrame, deviceFrame) || other.deviceFrame == deviceFrame)&&(identical(other.backgroundColor, backgroundColor) || other.backgroundColor == backgroundColor)&&(identical(other.showAppBar, showAppBar) || other.showAppBar == showAppBar)&&(identical(other.appBarTitle, appBarTitle) || other.appBarTitle == appBarTitle)&&(identical(other.showBottomNavBar, showBottomNavBar) || other.showBottomNavBar == showBottomNavBar)&&const DeepCollectionEquality().equals(other._navigationItems, _navigationItems)&&const DeepCollectionEquality().equals(other._responsiveSettings, _responsiveSettings)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_widgets),isMain,route,const DeepCollectionEquality().hash(_properties),deviceFrame,backgroundColor,showAppBar,appBarTitle,showBottomNavBar,const DeepCollectionEquality().hash(_navigationItems),const DeepCollectionEquality().hash(_responsiveSettings),createdAt,updatedAt,description,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'ScreenModel(id: $id, name: $name, widgets: $widgets, isMain: $isMain, route: $route, properties: $properties, deviceFrame: $deviceFrame, backgroundColor: $backgroundColor, showAppBar: $showAppBar, appBarTitle: $appBarTitle, showBottomNavBar: $showBottomNavBar, navigationItems: $navigationItems, responsiveSettings: $responsiveSettings, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$ScreenModelCopyWith<$Res> implements $ScreenModelCopyWith<$Res> {
  factory _$ScreenModelCopyWith(_ScreenModel value, $Res Function(_ScreenModel) _then) = __$ScreenModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name, List<WidgetModel> widgets, bool isMain, String route, Map<String, dynamic> properties,@DeviceFrameConverter() DeviceFrame deviceFrame,@ColorConverter() Color backgroundColor, bool showAppBar, String appBarTitle, bool showBottomNavBar, List<String> navigationItems, Map<String, dynamic> responsiveSettings, DateTime? createdAt, DateTime? updatedAt, String? description, List<String> tags
});




}
/// @nodoc
class __$ScreenModelCopyWithImpl<$Res>
    implements _$ScreenModelCopyWith<$Res> {
  __$ScreenModelCopyWithImpl(this._self, this._then);

  final _ScreenModel _self;
  final $Res Function(_ScreenModel) _then;

/// Create a copy of ScreenModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? widgets = null,Object? isMain = null,Object? route = null,Object? properties = null,Object? deviceFrame = null,Object? backgroundColor = null,Object? showAppBar = null,Object? appBarTitle = null,Object? showBottomNavBar = null,Object? navigationItems = null,Object? responsiveSettings = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? description = freezed,Object? tags = null,}) {
  return _then(_ScreenModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,widgets: null == widgets ? _self._widgets : widgets // ignore: cast_nullable_to_non_nullable
as List<WidgetModel>,isMain: null == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool,route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as String,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,deviceFrame: null == deviceFrame ? _self.deviceFrame : deviceFrame // ignore: cast_nullable_to_non_nullable
as DeviceFrame,backgroundColor: null == backgroundColor ? _self.backgroundColor : backgroundColor // ignore: cast_nullable_to_non_nullable
as Color,showAppBar: null == showAppBar ? _self.showAppBar : showAppBar // ignore: cast_nullable_to_non_nullable
as bool,appBarTitle: null == appBarTitle ? _self.appBarTitle : appBarTitle // ignore: cast_nullable_to_non_nullable
as String,showBottomNavBar: null == showBottomNavBar ? _self.showBottomNavBar : showBottomNavBar // ignore: cast_nullable_to_non_nullable
as bool,navigationItems: null == navigationItems ? _self._navigationItems : navigationItems // ignore: cast_nullable_to_non_nullable
as List<String>,responsiveSettings: null == responsiveSettings ? _self._responsiveSettings : responsiveSettings // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on

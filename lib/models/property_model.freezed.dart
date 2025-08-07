// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PropertyDefinition {

 String get name; String get displayName; PropertyType get type; dynamic get defaultValue; String? get description; bool get isRequired; bool get isEditable; List<dynamic> get options; double? get minValue; double? get maxValue; String? get category; Map<String, dynamic> get metadata;
/// Create a copy of PropertyDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyDefinitionCopyWith<PropertyDefinition> get copyWith => _$PropertyDefinitionCopyWithImpl<PropertyDefinition>(this as PropertyDefinition, _$identity);

  /// Serializes this PropertyDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertyDefinition&&(identical(other.name, name) || other.name == name)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue)&&(identical(other.description, description) || other.description == description)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.isEditable, isEditable) || other.isEditable == isEditable)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,displayName,type,const DeepCollectionEquality().hash(defaultValue),description,isRequired,isEditable,const DeepCollectionEquality().hash(options),minValue,maxValue,category,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'PropertyDefinition(name: $name, displayName: $displayName, type: $type, defaultValue: $defaultValue, description: $description, isRequired: $isRequired, isEditable: $isEditable, options: $options, minValue: $minValue, maxValue: $maxValue, category: $category, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $PropertyDefinitionCopyWith<$Res>  {
  factory $PropertyDefinitionCopyWith(PropertyDefinition value, $Res Function(PropertyDefinition) _then) = _$PropertyDefinitionCopyWithImpl;
@useResult
$Res call({
 String name, String displayName, PropertyType type, dynamic defaultValue, String? description, bool isRequired, bool isEditable, List<dynamic> options, double? minValue, double? maxValue, String? category, Map<String, dynamic> metadata
});




}
/// @nodoc
class _$PropertyDefinitionCopyWithImpl<$Res>
    implements $PropertyDefinitionCopyWith<$Res> {
  _$PropertyDefinitionCopyWithImpl(this._self, this._then);

  final PropertyDefinition _self;
  final $Res Function(PropertyDefinition) _then;

/// Create a copy of PropertyDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? displayName = null,Object? type = null,Object? defaultValue = freezed,Object? description = freezed,Object? isRequired = null,Object? isEditable = null,Object? options = null,Object? minValue = freezed,Object? maxValue = freezed,Object? category = freezed,Object? metadata = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PropertyType,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as dynamic,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,isEditable: null == isEditable ? _self.isEditable : isEditable // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<dynamic>,minValue: freezed == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as double?,maxValue: freezed == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as double?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [PropertyDefinition].
extension PropertyDefinitionPatterns on PropertyDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PropertyDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PropertyDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PropertyDefinition value)  $default,){
final _that = this;
switch (_that) {
case _PropertyDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PropertyDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _PropertyDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String displayName,  PropertyType type,  dynamic defaultValue,  String? description,  bool isRequired,  bool isEditable,  List<dynamic> options,  double? minValue,  double? maxValue,  String? category,  Map<String, dynamic> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PropertyDefinition() when $default != null:
return $default(_that.name,_that.displayName,_that.type,_that.defaultValue,_that.description,_that.isRequired,_that.isEditable,_that.options,_that.minValue,_that.maxValue,_that.category,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String displayName,  PropertyType type,  dynamic defaultValue,  String? description,  bool isRequired,  bool isEditable,  List<dynamic> options,  double? minValue,  double? maxValue,  String? category,  Map<String, dynamic> metadata)  $default,) {final _that = this;
switch (_that) {
case _PropertyDefinition():
return $default(_that.name,_that.displayName,_that.type,_that.defaultValue,_that.description,_that.isRequired,_that.isEditable,_that.options,_that.minValue,_that.maxValue,_that.category,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String displayName,  PropertyType type,  dynamic defaultValue,  String? description,  bool isRequired,  bool isEditable,  List<dynamic> options,  double? minValue,  double? maxValue,  String? category,  Map<String, dynamic> metadata)?  $default,) {final _that = this;
switch (_that) {
case _PropertyDefinition() when $default != null:
return $default(_that.name,_that.displayName,_that.type,_that.defaultValue,_that.description,_that.isRequired,_that.isEditable,_that.options,_that.minValue,_that.maxValue,_that.category,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PropertyDefinition implements PropertyDefinition {
  const _PropertyDefinition({required this.name, required this.displayName, required this.type, required this.defaultValue, this.description, this.isRequired = false, this.isEditable = true, final  List<dynamic> options = const [], this.minValue, this.maxValue, this.category, final  Map<String, dynamic> metadata = const {}}): _options = options,_metadata = metadata;
  factory _PropertyDefinition.fromJson(Map<String, dynamic> json) => _$PropertyDefinitionFromJson(json);

@override final  String name;
@override final  String displayName;
@override final  PropertyType type;
@override final  dynamic defaultValue;
@override final  String? description;
@override@JsonKey() final  bool isRequired;
@override@JsonKey() final  bool isEditable;
 final  List<dynamic> _options;
@override@JsonKey() List<dynamic> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  double? minValue;
@override final  double? maxValue;
@override final  String? category;
 final  Map<String, dynamic> _metadata;
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of PropertyDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyDefinitionCopyWith<_PropertyDefinition> get copyWith => __$PropertyDefinitionCopyWithImpl<_PropertyDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PropertyDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PropertyDefinition&&(identical(other.name, name) || other.name == name)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.defaultValue, defaultValue)&&(identical(other.description, description) || other.description == description)&&(identical(other.isRequired, isRequired) || other.isRequired == isRequired)&&(identical(other.isEditable, isEditable) || other.isEditable == isEditable)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.minValue, minValue) || other.minValue == minValue)&&(identical(other.maxValue, maxValue) || other.maxValue == maxValue)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,displayName,type,const DeepCollectionEquality().hash(defaultValue),description,isRequired,isEditable,const DeepCollectionEquality().hash(_options),minValue,maxValue,category,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'PropertyDefinition(name: $name, displayName: $displayName, type: $type, defaultValue: $defaultValue, description: $description, isRequired: $isRequired, isEditable: $isEditable, options: $options, minValue: $minValue, maxValue: $maxValue, category: $category, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$PropertyDefinitionCopyWith<$Res> implements $PropertyDefinitionCopyWith<$Res> {
  factory _$PropertyDefinitionCopyWith(_PropertyDefinition value, $Res Function(_PropertyDefinition) _then) = __$PropertyDefinitionCopyWithImpl;
@override @useResult
$Res call({
 String name, String displayName, PropertyType type, dynamic defaultValue, String? description, bool isRequired, bool isEditable, List<dynamic> options, double? minValue, double? maxValue, String? category, Map<String, dynamic> metadata
});




}
/// @nodoc
class __$PropertyDefinitionCopyWithImpl<$Res>
    implements _$PropertyDefinitionCopyWith<$Res> {
  __$PropertyDefinitionCopyWithImpl(this._self, this._then);

  final _PropertyDefinition _self;
  final $Res Function(_PropertyDefinition) _then;

/// Create a copy of PropertyDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? displayName = null,Object? type = null,Object? defaultValue = freezed,Object? description = freezed,Object? isRequired = null,Object? isEditable = null,Object? options = null,Object? minValue = freezed,Object? maxValue = freezed,Object? category = freezed,Object? metadata = null,}) {
  return _then(_PropertyDefinition(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PropertyType,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as dynamic,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isRequired: null == isRequired ? _self.isRequired : isRequired // ignore: cast_nullable_to_non_nullable
as bool,isEditable: null == isEditable ? _self.isEditable : isEditable // ignore: cast_nullable_to_non_nullable
as bool,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<dynamic>,minValue: freezed == minValue ? _self.minValue : minValue // ignore: cast_nullable_to_non_nullable
as double?,maxValue: freezed == maxValue ? _self.maxValue : maxValue // ignore: cast_nullable_to_non_nullable
as double?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$PropertyValue {

 String get propertyName; dynamic get value; bool get isValid; String? get errorMessage; DateTime? get lastModified;
/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyValueCopyWith<PropertyValue> get copyWith => _$PropertyValueCopyWithImpl<PropertyValue>(this as PropertyValue, _$identity);

  /// Serializes this PropertyValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertyValue&&(identical(other.propertyName, propertyName) || other.propertyName == propertyName)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,propertyName,const DeepCollectionEquality().hash(value),isValid,errorMessage,lastModified);

@override
String toString() {
  return 'PropertyValue(propertyName: $propertyName, value: $value, isValid: $isValid, errorMessage: $errorMessage, lastModified: $lastModified)';
}


}

/// @nodoc
abstract mixin class $PropertyValueCopyWith<$Res>  {
  factory $PropertyValueCopyWith(PropertyValue value, $Res Function(PropertyValue) _then) = _$PropertyValueCopyWithImpl;
@useResult
$Res call({
 String propertyName, dynamic value, bool isValid, String? errorMessage, DateTime? lastModified
});




}
/// @nodoc
class _$PropertyValueCopyWithImpl<$Res>
    implements $PropertyValueCopyWith<$Res> {
  _$PropertyValueCopyWithImpl(this._self, this._then);

  final PropertyValue _self;
  final $Res Function(PropertyValue) _then;

/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? propertyName = null,Object? value = freezed,Object? isValid = null,Object? errorMessage = freezed,Object? lastModified = freezed,}) {
  return _then(_self.copyWith(
propertyName: null == propertyName ? _self.propertyName : propertyName // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PropertyValue].
extension PropertyValuePatterns on PropertyValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PropertyValue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PropertyValue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PropertyValue value)  $default,){
final _that = this;
switch (_that) {
case _PropertyValue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PropertyValue value)?  $default,){
final _that = this;
switch (_that) {
case _PropertyValue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String propertyName,  dynamic value,  bool isValid,  String? errorMessage,  DateTime? lastModified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PropertyValue() when $default != null:
return $default(_that.propertyName,_that.value,_that.isValid,_that.errorMessage,_that.lastModified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String propertyName,  dynamic value,  bool isValid,  String? errorMessage,  DateTime? lastModified)  $default,) {final _that = this;
switch (_that) {
case _PropertyValue():
return $default(_that.propertyName,_that.value,_that.isValid,_that.errorMessage,_that.lastModified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String propertyName,  dynamic value,  bool isValid,  String? errorMessage,  DateTime? lastModified)?  $default,) {final _that = this;
switch (_that) {
case _PropertyValue() when $default != null:
return $default(_that.propertyName,_that.value,_that.isValid,_that.errorMessage,_that.lastModified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PropertyValue implements PropertyValue {
  const _PropertyValue({required this.propertyName, required this.value, this.isValid = true, this.errorMessage, this.lastModified});
  factory _PropertyValue.fromJson(Map<String, dynamic> json) => _$PropertyValueFromJson(json);

@override final  String propertyName;
@override final  dynamic value;
@override@JsonKey() final  bool isValid;
@override final  String? errorMessage;
@override final  DateTime? lastModified;

/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyValueCopyWith<_PropertyValue> get copyWith => __$PropertyValueCopyWithImpl<_PropertyValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PropertyValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PropertyValue&&(identical(other.propertyName, propertyName) || other.propertyName == propertyName)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,propertyName,const DeepCollectionEquality().hash(value),isValid,errorMessage,lastModified);

@override
String toString() {
  return 'PropertyValue(propertyName: $propertyName, value: $value, isValid: $isValid, errorMessage: $errorMessage, lastModified: $lastModified)';
}


}

/// @nodoc
abstract mixin class _$PropertyValueCopyWith<$Res> implements $PropertyValueCopyWith<$Res> {
  factory _$PropertyValueCopyWith(_PropertyValue value, $Res Function(_PropertyValue) _then) = __$PropertyValueCopyWithImpl;
@override @useResult
$Res call({
 String propertyName, dynamic value, bool isValid, String? errorMessage, DateTime? lastModified
});




}
/// @nodoc
class __$PropertyValueCopyWithImpl<$Res>
    implements _$PropertyValueCopyWith<$Res> {
  __$PropertyValueCopyWithImpl(this._self, this._then);

  final _PropertyValue _self;
  final $Res Function(_PropertyValue) _then;

/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? propertyName = null,Object? value = freezed,Object? isValid = null,Object? errorMessage = freezed,Object? lastModified = freezed,}) {
  return _then(_PropertyValue(
propertyName: null == propertyName ? _self.propertyName : propertyName // ignore: cast_nullable_to_non_nullable
as String,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

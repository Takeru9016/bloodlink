// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'donation_camp_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DonationCampModel {

 String get name; String get description;@GeoPointConverter() GeoPoint get location;@TimestampConverter() Timestamp get date; String get hostName; String get createdBy; String get updatedBy;@NullableTimestampConverter() Timestamp? get updatedAt;
/// Create a copy of DonationCampModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonationCampModelCopyWith<DonationCampModel> get copyWith => _$DonationCampModelCopyWithImpl<DonationCampModel>(this as DonationCampModel, _$identity);

  /// Serializes this DonationCampModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonationCampModel&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.date, date) || other.date == date)&&(identical(other.hostName, hostName) || other.hostName == hostName)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,location,date,hostName,createdBy,updatedBy,updatedAt);

@override
String toString() {
  return 'DonationCampModel(name: $name, description: $description, location: $location, date: $date, hostName: $hostName, createdBy: $createdBy, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DonationCampModelCopyWith<$Res>  {
  factory $DonationCampModelCopyWith(DonationCampModel value, $Res Function(DonationCampModel) _then) = _$DonationCampModelCopyWithImpl;
@useResult
$Res call({
 String name, String description,@GeoPointConverter() GeoPoint location,@TimestampConverter() Timestamp date, String hostName, String createdBy, String updatedBy,@NullableTimestampConverter() Timestamp? updatedAt
});




}
/// @nodoc
class _$DonationCampModelCopyWithImpl<$Res>
    implements $DonationCampModelCopyWith<$Res> {
  _$DonationCampModelCopyWithImpl(this._self, this._then);

  final DonationCampModel _self;
  final $Res Function(DonationCampModel) _then;

/// Create a copy of DonationCampModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? location = null,Object? date = null,Object? hostName = null,Object? createdBy = null,Object? updatedBy = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as Timestamp,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}

}


/// Adds pattern-matching-related methods to [DonationCampModel].
extension DonationCampModelPatterns on DonationCampModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonationCampModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonationCampModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonationCampModel value)  $default,){
final _that = this;
switch (_that) {
case _DonationCampModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonationCampModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonationCampModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description, @GeoPointConverter()  GeoPoint location, @TimestampConverter()  Timestamp date,  String hostName,  String createdBy,  String updatedBy, @NullableTimestampConverter()  Timestamp? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonationCampModel() when $default != null:
return $default(_that.name,_that.description,_that.location,_that.date,_that.hostName,_that.createdBy,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description, @GeoPointConverter()  GeoPoint location, @TimestampConverter()  Timestamp date,  String hostName,  String createdBy,  String updatedBy, @NullableTimestampConverter()  Timestamp? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DonationCampModel():
return $default(_that.name,_that.description,_that.location,_that.date,_that.hostName,_that.createdBy,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description, @GeoPointConverter()  GeoPoint location, @TimestampConverter()  Timestamp date,  String hostName,  String createdBy,  String updatedBy, @NullableTimestampConverter()  Timestamp? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DonationCampModel() when $default != null:
return $default(_that.name,_that.description,_that.location,_that.date,_that.hostName,_that.createdBy,_that.updatedBy,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonationCampModel implements DonationCampModel {
  const _DonationCampModel({required this.name, required this.description, @GeoPointConverter() required this.location, @TimestampConverter() required this.date, required this.hostName, required this.createdBy, required this.updatedBy, @NullableTimestampConverter() this.updatedAt});
  factory _DonationCampModel.fromJson(Map<String, dynamic> json) => _$DonationCampModelFromJson(json);

@override final  String name;
@override final  String description;
@override@GeoPointConverter() final  GeoPoint location;
@override@TimestampConverter() final  Timestamp date;
@override final  String hostName;
@override final  String createdBy;
@override final  String updatedBy;
@override@NullableTimestampConverter() final  Timestamp? updatedAt;

/// Create a copy of DonationCampModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonationCampModelCopyWith<_DonationCampModel> get copyWith => __$DonationCampModelCopyWithImpl<_DonationCampModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonationCampModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonationCampModel&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.date, date) || other.date == date)&&(identical(other.hostName, hostName) || other.hostName == hostName)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,location,date,hostName,createdBy,updatedBy,updatedAt);

@override
String toString() {
  return 'DonationCampModel(name: $name, description: $description, location: $location, date: $date, hostName: $hostName, createdBy: $createdBy, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DonationCampModelCopyWith<$Res> implements $DonationCampModelCopyWith<$Res> {
  factory _$DonationCampModelCopyWith(_DonationCampModel value, $Res Function(_DonationCampModel) _then) = __$DonationCampModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String description,@GeoPointConverter() GeoPoint location,@TimestampConverter() Timestamp date, String hostName, String createdBy, String updatedBy,@NullableTimestampConverter() Timestamp? updatedAt
});




}
/// @nodoc
class __$DonationCampModelCopyWithImpl<$Res>
    implements _$DonationCampModelCopyWith<$Res> {
  __$DonationCampModelCopyWithImpl(this._self, this._then);

  final _DonationCampModel _self;
  final $Res Function(_DonationCampModel) _then;

/// Create a copy of DonationCampModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? location = null,Object? date = null,Object? hostName = null,Object? createdBy = null,Object? updatedBy = null,Object? updatedAt = freezed,}) {
  return _then(_DonationCampModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as Timestamp,hostName: null == hostName ? _self.hostName : hostName // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}


}


/// @nodoc
mixin _$CampRsvpModel {

@NullableTimestampConverter() Timestamp? get joinedAt;
/// Create a copy of CampRsvpModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CampRsvpModelCopyWith<CampRsvpModel> get copyWith => _$CampRsvpModelCopyWithImpl<CampRsvpModel>(this as CampRsvpModel, _$identity);

  /// Serializes this CampRsvpModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CampRsvpModel&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,joinedAt);

@override
String toString() {
  return 'CampRsvpModel(joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class $CampRsvpModelCopyWith<$Res>  {
  factory $CampRsvpModelCopyWith(CampRsvpModel value, $Res Function(CampRsvpModel) _then) = _$CampRsvpModelCopyWithImpl;
@useResult
$Res call({
@NullableTimestampConverter() Timestamp? joinedAt
});




}
/// @nodoc
class _$CampRsvpModelCopyWithImpl<$Res>
    implements $CampRsvpModelCopyWith<$Res> {
  _$CampRsvpModelCopyWithImpl(this._self, this._then);

  final CampRsvpModel _self;
  final $Res Function(CampRsvpModel) _then;

/// Create a copy of CampRsvpModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? joinedAt = freezed,}) {
  return _then(_self.copyWith(
joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}

}


/// Adds pattern-matching-related methods to [CampRsvpModel].
extension CampRsvpModelPatterns on CampRsvpModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CampRsvpModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CampRsvpModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CampRsvpModel value)  $default,){
final _that = this;
switch (_that) {
case _CampRsvpModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CampRsvpModel value)?  $default,){
final _that = this;
switch (_that) {
case _CampRsvpModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@NullableTimestampConverter()  Timestamp? joinedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CampRsvpModel() when $default != null:
return $default(_that.joinedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@NullableTimestampConverter()  Timestamp? joinedAt)  $default,) {final _that = this;
switch (_that) {
case _CampRsvpModel():
return $default(_that.joinedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@NullableTimestampConverter()  Timestamp? joinedAt)?  $default,) {final _that = this;
switch (_that) {
case _CampRsvpModel() when $default != null:
return $default(_that.joinedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CampRsvpModel implements CampRsvpModel {
  const _CampRsvpModel({@NullableTimestampConverter() this.joinedAt});
  factory _CampRsvpModel.fromJson(Map<String, dynamic> json) => _$CampRsvpModelFromJson(json);

@override@NullableTimestampConverter() final  Timestamp? joinedAt;

/// Create a copy of CampRsvpModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CampRsvpModelCopyWith<_CampRsvpModel> get copyWith => __$CampRsvpModelCopyWithImpl<_CampRsvpModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CampRsvpModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CampRsvpModel&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,joinedAt);

@override
String toString() {
  return 'CampRsvpModel(joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class _$CampRsvpModelCopyWith<$Res> implements $CampRsvpModelCopyWith<$Res> {
  factory _$CampRsvpModelCopyWith(_CampRsvpModel value, $Res Function(_CampRsvpModel) _then) = __$CampRsvpModelCopyWithImpl;
@override @useResult
$Res call({
@NullableTimestampConverter() Timestamp? joinedAt
});




}
/// @nodoc
class __$CampRsvpModelCopyWithImpl<$Res>
    implements _$CampRsvpModelCopyWith<$Res> {
  __$CampRsvpModelCopyWithImpl(this._self, this._then);

  final _CampRsvpModel _self;
  final $Res Function(_CampRsvpModel) _then;

/// Create a copy of CampRsvpModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? joinedAt = freezed,}) {
  return _then(_CampRsvpModel(
joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}


}

// dart format on

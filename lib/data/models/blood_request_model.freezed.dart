// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blood_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BloodRequestModel {

 String get requesterId; String get patientName; String get bloodGroup; int get units; String get hospital;@GeoPointConverter() GeoPoint get location; UrgencyWindow get urgencyWindow; BloodRequestStatus get status; List<String> get matchedPartnerIds;@TimestampConverter() Timestamp get createdAt;
/// Create a copy of BloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BloodRequestModelCopyWith<BloodRequestModel> get copyWith => _$BloodRequestModelCopyWithImpl<BloodRequestModel>(this as BloodRequestModel, _$identity);

  /// Serializes this BloodRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BloodRequestModel&&(identical(other.requesterId, requesterId) || other.requesterId == requesterId)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.units, units) || other.units == units)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.location, location) || other.location == location)&&(identical(other.urgencyWindow, urgencyWindow) || other.urgencyWindow == urgencyWindow)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.matchedPartnerIds, matchedPartnerIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requesterId,patientName,bloodGroup,units,hospital,location,urgencyWindow,status,const DeepCollectionEquality().hash(matchedPartnerIds),createdAt);

@override
String toString() {
  return 'BloodRequestModel(requesterId: $requesterId, patientName: $patientName, bloodGroup: $bloodGroup, units: $units, hospital: $hospital, location: $location, urgencyWindow: $urgencyWindow, status: $status, matchedPartnerIds: $matchedPartnerIds, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BloodRequestModelCopyWith<$Res>  {
  factory $BloodRequestModelCopyWith(BloodRequestModel value, $Res Function(BloodRequestModel) _then) = _$BloodRequestModelCopyWithImpl;
@useResult
$Res call({
 String requesterId, String patientName, String bloodGroup, int units, String hospital,@GeoPointConverter() GeoPoint location, UrgencyWindow urgencyWindow, BloodRequestStatus status, List<String> matchedPartnerIds,@TimestampConverter() Timestamp createdAt
});




}
/// @nodoc
class _$BloodRequestModelCopyWithImpl<$Res>
    implements $BloodRequestModelCopyWith<$Res> {
  _$BloodRequestModelCopyWithImpl(this._self, this._then);

  final BloodRequestModel _self;
  final $Res Function(BloodRequestModel) _then;

/// Create a copy of BloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? requesterId = null,Object? patientName = null,Object? bloodGroup = null,Object? units = null,Object? hospital = null,Object? location = null,Object? urgencyWindow = null,Object? status = null,Object? matchedPartnerIds = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
requesterId: null == requesterId ? _self.requesterId : requesterId // ignore: cast_nullable_to_non_nullable
as String,patientName: null == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String,bloodGroup: null == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,urgencyWindow: null == urgencyWindow ? _self.urgencyWindow : urgencyWindow // ignore: cast_nullable_to_non_nullable
as UrgencyWindow,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BloodRequestStatus,matchedPartnerIds: null == matchedPartnerIds ? _self.matchedPartnerIds : matchedPartnerIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}

}


/// Adds pattern-matching-related methods to [BloodRequestModel].
extension BloodRequestModelPatterns on BloodRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BloodRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BloodRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BloodRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _BloodRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BloodRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _BloodRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String requesterId,  String patientName,  String bloodGroup,  int units,  String hospital, @GeoPointConverter()  GeoPoint location,  UrgencyWindow urgencyWindow,  BloodRequestStatus status,  List<String> matchedPartnerIds, @TimestampConverter()  Timestamp createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BloodRequestModel() when $default != null:
return $default(_that.requesterId,_that.patientName,_that.bloodGroup,_that.units,_that.hospital,_that.location,_that.urgencyWindow,_that.status,_that.matchedPartnerIds,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String requesterId,  String patientName,  String bloodGroup,  int units,  String hospital, @GeoPointConverter()  GeoPoint location,  UrgencyWindow urgencyWindow,  BloodRequestStatus status,  List<String> matchedPartnerIds, @TimestampConverter()  Timestamp createdAt)  $default,) {final _that = this;
switch (_that) {
case _BloodRequestModel():
return $default(_that.requesterId,_that.patientName,_that.bloodGroup,_that.units,_that.hospital,_that.location,_that.urgencyWindow,_that.status,_that.matchedPartnerIds,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String requesterId,  String patientName,  String bloodGroup,  int units,  String hospital, @GeoPointConverter()  GeoPoint location,  UrgencyWindow urgencyWindow,  BloodRequestStatus status,  List<String> matchedPartnerIds, @TimestampConverter()  Timestamp createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BloodRequestModel() when $default != null:
return $default(_that.requesterId,_that.patientName,_that.bloodGroup,_that.units,_that.hospital,_that.location,_that.urgencyWindow,_that.status,_that.matchedPartnerIds,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BloodRequestModel implements BloodRequestModel {
  const _BloodRequestModel({required this.requesterId, required this.patientName, required this.bloodGroup, required this.units, required this.hospital, @GeoPointConverter() required this.location, required this.urgencyWindow, required this.status, required final  List<String> matchedPartnerIds, @TimestampConverter() required this.createdAt}): _matchedPartnerIds = matchedPartnerIds;
  factory _BloodRequestModel.fromJson(Map<String, dynamic> json) => _$BloodRequestModelFromJson(json);

@override final  String requesterId;
@override final  String patientName;
@override final  String bloodGroup;
@override final  int units;
@override final  String hospital;
@override@GeoPointConverter() final  GeoPoint location;
@override final  UrgencyWindow urgencyWindow;
@override final  BloodRequestStatus status;
 final  List<String> _matchedPartnerIds;
@override List<String> get matchedPartnerIds {
  if (_matchedPartnerIds is EqualUnmodifiableListView) return _matchedPartnerIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_matchedPartnerIds);
}

@override@TimestampConverter() final  Timestamp createdAt;

/// Create a copy of BloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BloodRequestModelCopyWith<_BloodRequestModel> get copyWith => __$BloodRequestModelCopyWithImpl<_BloodRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BloodRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BloodRequestModel&&(identical(other.requesterId, requesterId) || other.requesterId == requesterId)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.units, units) || other.units == units)&&(identical(other.hospital, hospital) || other.hospital == hospital)&&(identical(other.location, location) || other.location == location)&&(identical(other.urgencyWindow, urgencyWindow) || other.urgencyWindow == urgencyWindow)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._matchedPartnerIds, _matchedPartnerIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,requesterId,patientName,bloodGroup,units,hospital,location,urgencyWindow,status,const DeepCollectionEquality().hash(_matchedPartnerIds),createdAt);

@override
String toString() {
  return 'BloodRequestModel(requesterId: $requesterId, patientName: $patientName, bloodGroup: $bloodGroup, units: $units, hospital: $hospital, location: $location, urgencyWindow: $urgencyWindow, status: $status, matchedPartnerIds: $matchedPartnerIds, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BloodRequestModelCopyWith<$Res> implements $BloodRequestModelCopyWith<$Res> {
  factory _$BloodRequestModelCopyWith(_BloodRequestModel value, $Res Function(_BloodRequestModel) _then) = __$BloodRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String requesterId, String patientName, String bloodGroup, int units, String hospital,@GeoPointConverter() GeoPoint location, UrgencyWindow urgencyWindow, BloodRequestStatus status, List<String> matchedPartnerIds,@TimestampConverter() Timestamp createdAt
});




}
/// @nodoc
class __$BloodRequestModelCopyWithImpl<$Res>
    implements _$BloodRequestModelCopyWith<$Res> {
  __$BloodRequestModelCopyWithImpl(this._self, this._then);

  final _BloodRequestModel _self;
  final $Res Function(_BloodRequestModel) _then;

/// Create a copy of BloodRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? requesterId = null,Object? patientName = null,Object? bloodGroup = null,Object? units = null,Object? hospital = null,Object? location = null,Object? urgencyWindow = null,Object? status = null,Object? matchedPartnerIds = null,Object? createdAt = null,}) {
  return _then(_BloodRequestModel(
requesterId: null == requesterId ? _self.requesterId : requesterId // ignore: cast_nullable_to_non_nullable
as String,patientName: null == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String,bloodGroup: null == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String,units: null == units ? _self.units : units // ignore: cast_nullable_to_non_nullable
as int,hospital: null == hospital ? _self.hospital : hospital // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint,urgencyWindow: null == urgencyWindow ? _self.urgencyWindow : urgencyWindow // ignore: cast_nullable_to_non_nullable
as UrgencyWindow,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BloodRequestStatus,matchedPartnerIds: null == matchedPartnerIds ? _self._matchedPartnerIds : matchedPartnerIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}


}

// dart format on

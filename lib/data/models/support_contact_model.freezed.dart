// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_contact_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupportContactModel {

 String get email; String get updatedBy;@TimestampConverter() Timestamp get updatedAt;
/// Create a copy of SupportContactModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupportContactModelCopyWith<SupportContactModel> get copyWith => _$SupportContactModelCopyWithImpl<SupportContactModel>(this as SupportContactModel, _$identity);

  /// Serializes this SupportContactModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupportContactModel&&(identical(other.email, email) || other.email == email)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,updatedBy,updatedAt);

@override
String toString() {
  return 'SupportContactModel(email: $email, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $SupportContactModelCopyWith<$Res>  {
  factory $SupportContactModelCopyWith(SupportContactModel value, $Res Function(SupportContactModel) _then) = _$SupportContactModelCopyWithImpl;
@useResult
$Res call({
 String email, String updatedBy,@TimestampConverter() Timestamp updatedAt
});




}
/// @nodoc
class _$SupportContactModelCopyWithImpl<$Res>
    implements $SupportContactModelCopyWith<$Res> {
  _$SupportContactModelCopyWithImpl(this._self, this._then);

  final SupportContactModel _self;
  final $Res Function(SupportContactModel) _then;

/// Create a copy of SupportContactModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? updatedBy = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}

}


/// Adds pattern-matching-related methods to [SupportContactModel].
extension SupportContactModelPatterns on SupportContactModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupportContactModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupportContactModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupportContactModel value)  $default,){
final _that = this;
switch (_that) {
case _SupportContactModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupportContactModel value)?  $default,){
final _that = this;
switch (_that) {
case _SupportContactModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String updatedBy, @TimestampConverter()  Timestamp updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupportContactModel() when $default != null:
return $default(_that.email,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String updatedBy, @TimestampConverter()  Timestamp updatedAt)  $default,) {final _that = this;
switch (_that) {
case _SupportContactModel():
return $default(_that.email,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String updatedBy, @TimestampConverter()  Timestamp updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SupportContactModel() when $default != null:
return $default(_that.email,_that.updatedBy,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupportContactModel implements SupportContactModel {
  const _SupportContactModel({required this.email, required this.updatedBy, @TimestampConverter() required this.updatedAt});
  factory _SupportContactModel.fromJson(Map<String, dynamic> json) => _$SupportContactModelFromJson(json);

@override final  String email;
@override final  String updatedBy;
@override@TimestampConverter() final  Timestamp updatedAt;

/// Create a copy of SupportContactModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupportContactModelCopyWith<_SupportContactModel> get copyWith => __$SupportContactModelCopyWithImpl<_SupportContactModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupportContactModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupportContactModel&&(identical(other.email, email) || other.email == email)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,updatedBy,updatedAt);

@override
String toString() {
  return 'SupportContactModel(email: $email, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$SupportContactModelCopyWith<$Res> implements $SupportContactModelCopyWith<$Res> {
  factory _$SupportContactModelCopyWith(_SupportContactModel value, $Res Function(_SupportContactModel) _then) = __$SupportContactModelCopyWithImpl;
@override @useResult
$Res call({
 String email, String updatedBy,@TimestampConverter() Timestamp updatedAt
});




}
/// @nodoc
class __$SupportContactModelCopyWithImpl<$Res>
    implements _$SupportContactModelCopyWith<$Res> {
  __$SupportContactModelCopyWithImpl(this._self, this._then);

  final _SupportContactModel _self;
  final $Res Function(_SupportContactModel) _then;

/// Create a copy of SupportContactModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? updatedBy = null,Object? updatedAt = null,}) {
  return _then(_SupportContactModel(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}


}

// dart format on

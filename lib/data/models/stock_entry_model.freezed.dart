// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StockEntryModel {

 int get unitCount; String get lastUpdatedBy;@TimestampConverter() Timestamp? get lastUpdatedAt;
/// Create a copy of StockEntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockEntryModelCopyWith<StockEntryModel> get copyWith => _$StockEntryModelCopyWithImpl<StockEntryModel>(this as StockEntryModel, _$identity);

  /// Serializes this StockEntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockEntryModel&&(identical(other.unitCount, unitCount) || other.unitCount == unitCount)&&(identical(other.lastUpdatedBy, lastUpdatedBy) || other.lastUpdatedBy == lastUpdatedBy)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,unitCount,lastUpdatedBy,lastUpdatedAt);

@override
String toString() {
  return 'StockEntryModel(unitCount: $unitCount, lastUpdatedBy: $lastUpdatedBy, lastUpdatedAt: $lastUpdatedAt)';
}


}

/// @nodoc
abstract mixin class $StockEntryModelCopyWith<$Res>  {
  factory $StockEntryModelCopyWith(StockEntryModel value, $Res Function(StockEntryModel) _then) = _$StockEntryModelCopyWithImpl;
@useResult
$Res call({
 int unitCount, String lastUpdatedBy,@TimestampConverter() Timestamp? lastUpdatedAt
});




}
/// @nodoc
class _$StockEntryModelCopyWithImpl<$Res>
    implements $StockEntryModelCopyWith<$Res> {
  _$StockEntryModelCopyWithImpl(this._self, this._then);

  final StockEntryModel _self;
  final $Res Function(StockEntryModel) _then;

/// Create a copy of StockEntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unitCount = null,Object? lastUpdatedBy = null,Object? lastUpdatedAt = freezed,}) {
  return _then(_self.copyWith(
unitCount: null == unitCount ? _self.unitCount : unitCount // ignore: cast_nullable_to_non_nullable
as int,lastUpdatedBy: null == lastUpdatedBy ? _self.lastUpdatedBy : lastUpdatedBy // ignore: cast_nullable_to_non_nullable
as String,lastUpdatedAt: freezed == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}

}


/// Adds pattern-matching-related methods to [StockEntryModel].
extension StockEntryModelPatterns on StockEntryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockEntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockEntryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockEntryModel value)  $default,){
final _that = this;
switch (_that) {
case _StockEntryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockEntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _StockEntryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int unitCount,  String lastUpdatedBy, @TimestampConverter()  Timestamp? lastUpdatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockEntryModel() when $default != null:
return $default(_that.unitCount,_that.lastUpdatedBy,_that.lastUpdatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int unitCount,  String lastUpdatedBy, @TimestampConverter()  Timestamp? lastUpdatedAt)  $default,) {final _that = this;
switch (_that) {
case _StockEntryModel():
return $default(_that.unitCount,_that.lastUpdatedBy,_that.lastUpdatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int unitCount,  String lastUpdatedBy, @TimestampConverter()  Timestamp? lastUpdatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StockEntryModel() when $default != null:
return $default(_that.unitCount,_that.lastUpdatedBy,_that.lastUpdatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StockEntryModel implements StockEntryModel {
  const _StockEntryModel({required this.unitCount, required this.lastUpdatedBy, @TimestampConverter() this.lastUpdatedAt});
  factory _StockEntryModel.fromJson(Map<String, dynamic> json) => _$StockEntryModelFromJson(json);

@override final  int unitCount;
@override final  String lastUpdatedBy;
@override@TimestampConverter() final  Timestamp? lastUpdatedAt;

/// Create a copy of StockEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockEntryModelCopyWith<_StockEntryModel> get copyWith => __$StockEntryModelCopyWithImpl<_StockEntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StockEntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockEntryModel&&(identical(other.unitCount, unitCount) || other.unitCount == unitCount)&&(identical(other.lastUpdatedBy, lastUpdatedBy) || other.lastUpdatedBy == lastUpdatedBy)&&(identical(other.lastUpdatedAt, lastUpdatedAt) || other.lastUpdatedAt == lastUpdatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,unitCount,lastUpdatedBy,lastUpdatedAt);

@override
String toString() {
  return 'StockEntryModel(unitCount: $unitCount, lastUpdatedBy: $lastUpdatedBy, lastUpdatedAt: $lastUpdatedAt)';
}


}

/// @nodoc
abstract mixin class _$StockEntryModelCopyWith<$Res> implements $StockEntryModelCopyWith<$Res> {
  factory _$StockEntryModelCopyWith(_StockEntryModel value, $Res Function(_StockEntryModel) _then) = __$StockEntryModelCopyWithImpl;
@override @useResult
$Res call({
 int unitCount, String lastUpdatedBy,@TimestampConverter() Timestamp? lastUpdatedAt
});




}
/// @nodoc
class __$StockEntryModelCopyWithImpl<$Res>
    implements _$StockEntryModelCopyWith<$Res> {
  __$StockEntryModelCopyWithImpl(this._self, this._then);

  final _StockEntryModel _self;
  final $Res Function(_StockEntryModel) _then;

/// Create a copy of StockEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unitCount = null,Object? lastUpdatedBy = null,Object? lastUpdatedAt = freezed,}) {
  return _then(_StockEntryModel(
unitCount: null == unitCount ? _self.unitCount : unitCount // ignore: cast_nullable_to_non_nullable
as int,lastUpdatedBy: null == lastUpdatedBy ? _self.lastUpdatedBy : lastUpdatedBy // ignore: cast_nullable_to_non_nullable
as String,lastUpdatedAt: freezed == lastUpdatedAt ? _self.lastUpdatedAt : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp?,
  ));
}


}

// dart format on

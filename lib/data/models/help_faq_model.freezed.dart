// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'help_faq_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HelpFaqModel {

 String get question; String get answer; int get displayOrder; String get updatedBy;@TimestampConverter() Timestamp get updatedAt;
/// Create a copy of HelpFaqModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelpFaqModelCopyWith<HelpFaqModel> get copyWith => _$HelpFaqModelCopyWithImpl<HelpFaqModel>(this as HelpFaqModel, _$identity);

  /// Serializes this HelpFaqModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HelpFaqModel&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,answer,displayOrder,updatedBy,updatedAt);

@override
String toString() {
  return 'HelpFaqModel(question: $question, answer: $answer, displayOrder: $displayOrder, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $HelpFaqModelCopyWith<$Res>  {
  factory $HelpFaqModelCopyWith(HelpFaqModel value, $Res Function(HelpFaqModel) _then) = _$HelpFaqModelCopyWithImpl;
@useResult
$Res call({
 String question, String answer, int displayOrder, String updatedBy,@TimestampConverter() Timestamp updatedAt
});




}
/// @nodoc
class _$HelpFaqModelCopyWithImpl<$Res>
    implements $HelpFaqModelCopyWith<$Res> {
  _$HelpFaqModelCopyWithImpl(this._self, this._then);

  final HelpFaqModel _self;
  final $Res Function(HelpFaqModel) _then;

/// Create a copy of HelpFaqModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? question = null,Object? answer = null,Object? displayOrder = null,Object? updatedBy = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}

}


/// Adds pattern-matching-related methods to [HelpFaqModel].
extension HelpFaqModelPatterns on HelpFaqModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HelpFaqModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HelpFaqModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HelpFaqModel value)  $default,){
final _that = this;
switch (_that) {
case _HelpFaqModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HelpFaqModel value)?  $default,){
final _that = this;
switch (_that) {
case _HelpFaqModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String question,  String answer,  int displayOrder,  String updatedBy, @TimestampConverter()  Timestamp updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HelpFaqModel() when $default != null:
return $default(_that.question,_that.answer,_that.displayOrder,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String question,  String answer,  int displayOrder,  String updatedBy, @TimestampConverter()  Timestamp updatedAt)  $default,) {final _that = this;
switch (_that) {
case _HelpFaqModel():
return $default(_that.question,_that.answer,_that.displayOrder,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String question,  String answer,  int displayOrder,  String updatedBy, @TimestampConverter()  Timestamp updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _HelpFaqModel() when $default != null:
return $default(_that.question,_that.answer,_that.displayOrder,_that.updatedBy,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HelpFaqModel implements HelpFaqModel {
  const _HelpFaqModel({required this.question, required this.answer, required this.displayOrder, required this.updatedBy, @TimestampConverter() required this.updatedAt});
  factory _HelpFaqModel.fromJson(Map<String, dynamic> json) => _$HelpFaqModelFromJson(json);

@override final  String question;
@override final  String answer;
@override final  int displayOrder;
@override final  String updatedBy;
@override@TimestampConverter() final  Timestamp updatedAt;

/// Create a copy of HelpFaqModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelpFaqModelCopyWith<_HelpFaqModel> get copyWith => __$HelpFaqModelCopyWithImpl<_HelpFaqModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HelpFaqModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HelpFaqModel&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,answer,displayOrder,updatedBy,updatedAt);

@override
String toString() {
  return 'HelpFaqModel(question: $question, answer: $answer, displayOrder: $displayOrder, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$HelpFaqModelCopyWith<$Res> implements $HelpFaqModelCopyWith<$Res> {
  factory _$HelpFaqModelCopyWith(_HelpFaqModel value, $Res Function(_HelpFaqModel) _then) = __$HelpFaqModelCopyWithImpl;
@override @useResult
$Res call({
 String question, String answer, int displayOrder, String updatedBy,@TimestampConverter() Timestamp updatedAt
});




}
/// @nodoc
class __$HelpFaqModelCopyWithImpl<$Res>
    implements _$HelpFaqModelCopyWith<$Res> {
  __$HelpFaqModelCopyWithImpl(this._self, this._then);

  final _HelpFaqModel _self;
  final $Res Function(_HelpFaqModel) _then;

/// Create a copy of HelpFaqModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? question = null,Object? answer = null,Object? displayOrder = null,Object? updatedBy = null,Object? updatedAt = null,}) {
  return _then(_HelpFaqModel(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'education_article_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EducationArticleModel {

 String get title; String get body; EducationArticleCategory get category; int get displayOrder; String? get imageUrl; String get updatedBy;@TimestampConverter() Timestamp get updatedAt;
/// Create a copy of EducationArticleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EducationArticleModelCopyWith<EducationArticleModel> get copyWith => _$EducationArticleModelCopyWithImpl<EducationArticleModel>(this as EducationArticleModel, _$identity);

  /// Serializes this EducationArticleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EducationArticleModel&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.category, category) || other.category == category)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,body,category,displayOrder,imageUrl,updatedBy,updatedAt);

@override
String toString() {
  return 'EducationArticleModel(title: $title, body: $body, category: $category, displayOrder: $displayOrder, imageUrl: $imageUrl, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EducationArticleModelCopyWith<$Res>  {
  factory $EducationArticleModelCopyWith(EducationArticleModel value, $Res Function(EducationArticleModel) _then) = _$EducationArticleModelCopyWithImpl;
@useResult
$Res call({
 String title, String body, EducationArticleCategory category, int displayOrder, String? imageUrl, String updatedBy,@TimestampConverter() Timestamp updatedAt
});




}
/// @nodoc
class _$EducationArticleModelCopyWithImpl<$Res>
    implements $EducationArticleModelCopyWith<$Res> {
  _$EducationArticleModelCopyWithImpl(this._self, this._then);

  final EducationArticleModel _self;
  final $Res Function(EducationArticleModel) _then;

/// Create a copy of EducationArticleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? body = null,Object? category = null,Object? displayOrder = null,Object? imageUrl = freezed,Object? updatedBy = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EducationArticleCategory,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}

}


/// Adds pattern-matching-related methods to [EducationArticleModel].
extension EducationArticleModelPatterns on EducationArticleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EducationArticleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EducationArticleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EducationArticleModel value)  $default,){
final _that = this;
switch (_that) {
case _EducationArticleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EducationArticleModel value)?  $default,){
final _that = this;
switch (_that) {
case _EducationArticleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String body,  EducationArticleCategory category,  int displayOrder,  String? imageUrl,  String updatedBy, @TimestampConverter()  Timestamp updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EducationArticleModel() when $default != null:
return $default(_that.title,_that.body,_that.category,_that.displayOrder,_that.imageUrl,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String body,  EducationArticleCategory category,  int displayOrder,  String? imageUrl,  String updatedBy, @TimestampConverter()  Timestamp updatedAt)  $default,) {final _that = this;
switch (_that) {
case _EducationArticleModel():
return $default(_that.title,_that.body,_that.category,_that.displayOrder,_that.imageUrl,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String body,  EducationArticleCategory category,  int displayOrder,  String? imageUrl,  String updatedBy, @TimestampConverter()  Timestamp updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _EducationArticleModel() when $default != null:
return $default(_that.title,_that.body,_that.category,_that.displayOrder,_that.imageUrl,_that.updatedBy,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EducationArticleModel implements EducationArticleModel {
  const _EducationArticleModel({required this.title, required this.body, required this.category, required this.displayOrder, this.imageUrl, required this.updatedBy, @TimestampConverter() required this.updatedAt});
  factory _EducationArticleModel.fromJson(Map<String, dynamic> json) => _$EducationArticleModelFromJson(json);

@override final  String title;
@override final  String body;
@override final  EducationArticleCategory category;
@override final  int displayOrder;
@override final  String? imageUrl;
@override final  String updatedBy;
@override@TimestampConverter() final  Timestamp updatedAt;

/// Create a copy of EducationArticleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EducationArticleModelCopyWith<_EducationArticleModel> get copyWith => __$EducationArticleModelCopyWithImpl<_EducationArticleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EducationArticleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EducationArticleModel&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.category, category) || other.category == category)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,body,category,displayOrder,imageUrl,updatedBy,updatedAt);

@override
String toString() {
  return 'EducationArticleModel(title: $title, body: $body, category: $category, displayOrder: $displayOrder, imageUrl: $imageUrl, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EducationArticleModelCopyWith<$Res> implements $EducationArticleModelCopyWith<$Res> {
  factory _$EducationArticleModelCopyWith(_EducationArticleModel value, $Res Function(_EducationArticleModel) _then) = __$EducationArticleModelCopyWithImpl;
@override @useResult
$Res call({
 String title, String body, EducationArticleCategory category, int displayOrder, String? imageUrl, String updatedBy,@TimestampConverter() Timestamp updatedAt
});




}
/// @nodoc
class __$EducationArticleModelCopyWithImpl<$Res>
    implements _$EducationArticleModelCopyWith<$Res> {
  __$EducationArticleModelCopyWithImpl(this._self, this._then);

  final _EducationArticleModel _self;
  final $Res Function(_EducationArticleModel) _then;

/// Create a copy of EducationArticleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? body = null,Object? category = null,Object? displayOrder = null,Object? imageUrl = freezed,Object? updatedBy = null,Object? updatedAt = null,}) {
  return _then(_EducationArticleModel(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EducationArticleCategory,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}


}

// dart format on

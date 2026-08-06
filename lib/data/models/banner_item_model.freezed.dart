// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'banner_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BannerItemModel {

 String get imageUrl; String? get linkedPartnerId; int get displayOrder; bool get active; String get createdBy; String get updatedBy;@TimestampConverter() Timestamp get updatedAt;
/// Create a copy of BannerItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BannerItemModelCopyWith<BannerItemModel> get copyWith => _$BannerItemModelCopyWithImpl<BannerItemModel>(this as BannerItemModel, _$identity);

  /// Serializes this BannerItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BannerItemModel&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.linkedPartnerId, linkedPartnerId) || other.linkedPartnerId == linkedPartnerId)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.active, active) || other.active == active)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl,linkedPartnerId,displayOrder,active,createdBy,updatedBy,updatedAt);

@override
String toString() {
  return 'BannerItemModel(imageUrl: $imageUrl, linkedPartnerId: $linkedPartnerId, displayOrder: $displayOrder, active: $active, createdBy: $createdBy, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BannerItemModelCopyWith<$Res>  {
  factory $BannerItemModelCopyWith(BannerItemModel value, $Res Function(BannerItemModel) _then) = _$BannerItemModelCopyWithImpl;
@useResult
$Res call({
 String imageUrl, String? linkedPartnerId, int displayOrder, bool active, String createdBy, String updatedBy,@TimestampConverter() Timestamp updatedAt
});




}
/// @nodoc
class _$BannerItemModelCopyWithImpl<$Res>
    implements $BannerItemModelCopyWith<$Res> {
  _$BannerItemModelCopyWithImpl(this._self, this._then);

  final BannerItemModel _self;
  final $Res Function(BannerItemModel) _then;

/// Create a copy of BannerItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageUrl = null,Object? linkedPartnerId = freezed,Object? displayOrder = null,Object? active = null,Object? createdBy = null,Object? updatedBy = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,linkedPartnerId: freezed == linkedPartnerId ? _self.linkedPartnerId : linkedPartnerId // ignore: cast_nullable_to_non_nullable
as String?,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}

}


/// Adds pattern-matching-related methods to [BannerItemModel].
extension BannerItemModelPatterns on BannerItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BannerItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BannerItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BannerItemModel value)  $default,){
final _that = this;
switch (_that) {
case _BannerItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BannerItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _BannerItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String imageUrl,  String? linkedPartnerId,  int displayOrder,  bool active,  String createdBy,  String updatedBy, @TimestampConverter()  Timestamp updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BannerItemModel() when $default != null:
return $default(_that.imageUrl,_that.linkedPartnerId,_that.displayOrder,_that.active,_that.createdBy,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String imageUrl,  String? linkedPartnerId,  int displayOrder,  bool active,  String createdBy,  String updatedBy, @TimestampConverter()  Timestamp updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BannerItemModel():
return $default(_that.imageUrl,_that.linkedPartnerId,_that.displayOrder,_that.active,_that.createdBy,_that.updatedBy,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String imageUrl,  String? linkedPartnerId,  int displayOrder,  bool active,  String createdBy,  String updatedBy, @TimestampConverter()  Timestamp updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BannerItemModel() when $default != null:
return $default(_that.imageUrl,_that.linkedPartnerId,_that.displayOrder,_that.active,_that.createdBy,_that.updatedBy,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BannerItemModel implements BannerItemModel {
  const _BannerItemModel({required this.imageUrl, required this.linkedPartnerId, required this.displayOrder, required this.active, required this.createdBy, required this.updatedBy, @TimestampConverter() required this.updatedAt});
  factory _BannerItemModel.fromJson(Map<String, dynamic> json) => _$BannerItemModelFromJson(json);

@override final  String imageUrl;
@override final  String? linkedPartnerId;
@override final  int displayOrder;
@override final  bool active;
@override final  String createdBy;
@override final  String updatedBy;
@override@TimestampConverter() final  Timestamp updatedAt;

/// Create a copy of BannerItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BannerItemModelCopyWith<_BannerItemModel> get copyWith => __$BannerItemModelCopyWithImpl<_BannerItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BannerItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BannerItemModel&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.linkedPartnerId, linkedPartnerId) || other.linkedPartnerId == linkedPartnerId)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.active, active) || other.active == active)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,imageUrl,linkedPartnerId,displayOrder,active,createdBy,updatedBy,updatedAt);

@override
String toString() {
  return 'BannerItemModel(imageUrl: $imageUrl, linkedPartnerId: $linkedPartnerId, displayOrder: $displayOrder, active: $active, createdBy: $createdBy, updatedBy: $updatedBy, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BannerItemModelCopyWith<$Res> implements $BannerItemModelCopyWith<$Res> {
  factory _$BannerItemModelCopyWith(_BannerItemModel value, $Res Function(_BannerItemModel) _then) = __$BannerItemModelCopyWithImpl;
@override @useResult
$Res call({
 String imageUrl, String? linkedPartnerId, int displayOrder, bool active, String createdBy, String updatedBy,@TimestampConverter() Timestamp updatedAt
});




}
/// @nodoc
class __$BannerItemModelCopyWithImpl<$Res>
    implements _$BannerItemModelCopyWith<$Res> {
  __$BannerItemModelCopyWithImpl(this._self, this._then);

  final _BannerItemModel _self;
  final $Res Function(_BannerItemModel) _then;

/// Create a copy of BannerItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageUrl = null,Object? linkedPartnerId = freezed,Object? displayOrder = null,Object? active = null,Object? createdBy = null,Object? updatedBy = null,Object? updatedAt = null,}) {
  return _then(_BannerItemModel(
imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,linkedPartnerId: freezed == linkedPartnerId ? _self.linkedPartnerId : linkedPartnerId // ignore: cast_nullable_to_non_nullable
as String?,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as Timestamp,
  ));
}


}

// dart format on

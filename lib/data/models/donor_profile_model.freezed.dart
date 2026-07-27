// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'donor_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DonorProfileModel {

 BloodGroup get bloodGroup;@TimestampConverter() Timestamp get dob;@TimestampConverter() Timestamp? get lastDonationDate; VerificationStatus get verificationStatus; double get optInRadiusKm;
/// Create a copy of DonorProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DonorProfileModelCopyWith<DonorProfileModel> get copyWith => _$DonorProfileModelCopyWithImpl<DonorProfileModel>(this as DonorProfileModel, _$identity);

  /// Serializes this DonorProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DonorProfileModel&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.lastDonationDate, lastDonationDate) || other.lastDonationDate == lastDonationDate)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.optInRadiusKm, optInRadiusKm) || other.optInRadiusKm == optInRadiusKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bloodGroup,dob,lastDonationDate,verificationStatus,optInRadiusKm);

@override
String toString() {
  return 'DonorProfileModel(bloodGroup: $bloodGroup, dob: $dob, lastDonationDate: $lastDonationDate, verificationStatus: $verificationStatus, optInRadiusKm: $optInRadiusKm)';
}


}

/// @nodoc
abstract mixin class $DonorProfileModelCopyWith<$Res>  {
  factory $DonorProfileModelCopyWith(DonorProfileModel value, $Res Function(DonorProfileModel) _then) = _$DonorProfileModelCopyWithImpl;
@useResult
$Res call({
 BloodGroup bloodGroup,@TimestampConverter() Timestamp dob,@TimestampConverter() Timestamp? lastDonationDate, VerificationStatus verificationStatus, double optInRadiusKm
});




}
/// @nodoc
class _$DonorProfileModelCopyWithImpl<$Res>
    implements $DonorProfileModelCopyWith<$Res> {
  _$DonorProfileModelCopyWithImpl(this._self, this._then);

  final DonorProfileModel _self;
  final $Res Function(DonorProfileModel) _then;

/// Create a copy of DonorProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bloodGroup = null,Object? dob = null,Object? lastDonationDate = freezed,Object? verificationStatus = null,Object? optInRadiusKm = null,}) {
  return _then(_self.copyWith(
bloodGroup: null == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as BloodGroup,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as Timestamp,lastDonationDate: freezed == lastDonationDate ? _self.lastDonationDate : lastDonationDate // ignore: cast_nullable_to_non_nullable
as Timestamp?,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,optInRadiusKm: null == optInRadiusKm ? _self.optInRadiusKm : optInRadiusKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DonorProfileModel].
extension DonorProfileModelPatterns on DonorProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DonorProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DonorProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DonorProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _DonorProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DonorProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _DonorProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BloodGroup bloodGroup, @TimestampConverter()  Timestamp dob, @TimestampConverter()  Timestamp? lastDonationDate,  VerificationStatus verificationStatus,  double optInRadiusKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DonorProfileModel() when $default != null:
return $default(_that.bloodGroup,_that.dob,_that.lastDonationDate,_that.verificationStatus,_that.optInRadiusKm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BloodGroup bloodGroup, @TimestampConverter()  Timestamp dob, @TimestampConverter()  Timestamp? lastDonationDate,  VerificationStatus verificationStatus,  double optInRadiusKm)  $default,) {final _that = this;
switch (_that) {
case _DonorProfileModel():
return $default(_that.bloodGroup,_that.dob,_that.lastDonationDate,_that.verificationStatus,_that.optInRadiusKm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BloodGroup bloodGroup, @TimestampConverter()  Timestamp dob, @TimestampConverter()  Timestamp? lastDonationDate,  VerificationStatus verificationStatus,  double optInRadiusKm)?  $default,) {final _that = this;
switch (_that) {
case _DonorProfileModel() when $default != null:
return $default(_that.bloodGroup,_that.dob,_that.lastDonationDate,_that.verificationStatus,_that.optInRadiusKm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DonorProfileModel implements DonorProfileModel {
  const _DonorProfileModel({required this.bloodGroup, @TimestampConverter() required this.dob, @TimestampConverter() this.lastDonationDate, required this.verificationStatus, required this.optInRadiusKm});
  factory _DonorProfileModel.fromJson(Map<String, dynamic> json) => _$DonorProfileModelFromJson(json);

@override final  BloodGroup bloodGroup;
@override@TimestampConverter() final  Timestamp dob;
@override@TimestampConverter() final  Timestamp? lastDonationDate;
@override final  VerificationStatus verificationStatus;
@override final  double optInRadiusKm;

/// Create a copy of DonorProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DonorProfileModelCopyWith<_DonorProfileModel> get copyWith => __$DonorProfileModelCopyWithImpl<_DonorProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DonorProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DonorProfileModel&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.lastDonationDate, lastDonationDate) || other.lastDonationDate == lastDonationDate)&&(identical(other.verificationStatus, verificationStatus) || other.verificationStatus == verificationStatus)&&(identical(other.optInRadiusKm, optInRadiusKm) || other.optInRadiusKm == optInRadiusKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bloodGroup,dob,lastDonationDate,verificationStatus,optInRadiusKm);

@override
String toString() {
  return 'DonorProfileModel(bloodGroup: $bloodGroup, dob: $dob, lastDonationDate: $lastDonationDate, verificationStatus: $verificationStatus, optInRadiusKm: $optInRadiusKm)';
}


}

/// @nodoc
abstract mixin class _$DonorProfileModelCopyWith<$Res> implements $DonorProfileModelCopyWith<$Res> {
  factory _$DonorProfileModelCopyWith(_DonorProfileModel value, $Res Function(_DonorProfileModel) _then) = __$DonorProfileModelCopyWithImpl;
@override @useResult
$Res call({
 BloodGroup bloodGroup,@TimestampConverter() Timestamp dob,@TimestampConverter() Timestamp? lastDonationDate, VerificationStatus verificationStatus, double optInRadiusKm
});




}
/// @nodoc
class __$DonorProfileModelCopyWithImpl<$Res>
    implements _$DonorProfileModelCopyWith<$Res> {
  __$DonorProfileModelCopyWithImpl(this._self, this._then);

  final _DonorProfileModel _self;
  final $Res Function(_DonorProfileModel) _then;

/// Create a copy of DonorProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bloodGroup = null,Object? dob = null,Object? lastDonationDate = freezed,Object? verificationStatus = null,Object? optInRadiusKm = null,}) {
  return _then(_DonorProfileModel(
bloodGroup: null == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as BloodGroup,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as Timestamp,lastDonationDate: freezed == lastDonationDate ? _self.lastDonationDate : lastDonationDate // ignore: cast_nullable_to_non_nullable
as Timestamp?,verificationStatus: null == verificationStatus ? _self.verificationStatus : verificationStatus // ignore: cast_nullable_to_non_nullable
as VerificationStatus,optInRadiusKm: null == optInRadiusKm ? _self.optInRadiusKm : optInRadiusKm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  location: _$JsonConverterFromJson<GeoPoint, GeoPoint>(
    json['location'],
    const GeoPointConverter().fromJson,
  ),
  city: json['city'] as String?,
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  fcmToken: json['fcmToken'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'roles': instance.roles,
      'location': _$JsonConverterToJson<GeoPoint, GeoPoint>(
        instance.location,
        const GeoPointConverter().toJson,
      ),
      'city': instance.city,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'fcmToken': instance.fcmToken,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

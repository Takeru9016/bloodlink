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
  location: const GeoPointConverter().fromJson(json['location'] as GeoPoint),
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
      'location': const GeoPointConverter().toJson(instance.location),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'fcmToken': instance.fcmToken,
    };

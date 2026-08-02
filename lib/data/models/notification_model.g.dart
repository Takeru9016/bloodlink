// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      userId: json['userId'] as String,
      type: json['type'] as String,
      payload: json['payload'] as Map<String, dynamic>,
      readStatus: json['readStatus'] as bool,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'type': instance.type,
      'payload': instance.payload,
      'readStatus': instance.readStatus,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

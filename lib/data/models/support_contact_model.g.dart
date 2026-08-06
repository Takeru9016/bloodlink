// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SupportContactModel _$SupportContactModelFromJson(Map<String, dynamic> json) =>
    _SupportContactModel(
      email: json['email'] as String,
      updatedBy: json['updatedBy'] as String,
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$SupportContactModelToJson(
  _SupportContactModel instance,
) => <String, dynamic>{
  'email': instance.email,
  'updatedBy': instance.updatedBy,
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};

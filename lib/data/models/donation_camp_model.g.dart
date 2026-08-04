// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donation_camp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DonationCampModel _$DonationCampModelFromJson(Map<String, dynamic> json) =>
    _DonationCampModel(
      name: json['name'] as String,
      description: json['description'] as String,
      location: const GeoPointConverter().fromJson(
        json['location'] as GeoPoint,
      ),
      date: const TimestampConverter().fromJson(json['date'] as Timestamp),
      hostName: json['hostName'] as String,
      createdBy: json['createdBy'] as String,
      updatedBy: json['updatedBy'] as String,
      updatedAt: const NullableTimestampConverter().fromJson(
        json['updatedAt'] as Timestamp?,
      ),
    );

Map<String, dynamic> _$DonationCampModelToJson(
  _DonationCampModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'location': const GeoPointConverter().toJson(instance.location),
  'date': const TimestampConverter().toJson(instance.date),
  'hostName': instance.hostName,
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'updatedAt': const NullableTimestampConverter().toJson(instance.updatedAt),
};

_CampRsvpModel _$CampRsvpModelFromJson(Map<String, dynamic> json) =>
    _CampRsvpModel(
      joinedAt: const NullableTimestampConverter().fromJson(
        json['joinedAt'] as Timestamp?,
      ),
    );

Map<String, dynamic> _$CampRsvpModelToJson(_CampRsvpModel instance) =>
    <String, dynamic>{
      'joinedAt': const NullableTimestampConverter().toJson(instance.joinedAt),
    };

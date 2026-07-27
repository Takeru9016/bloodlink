// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PartnerModel _$PartnerModelFromJson(Map<String, dynamic> json) =>
    _PartnerModel(
      name: json['name'] as String,
      address: json['address'] as String,
      location: const GeoPointConverter().fromJson(
        json['location'] as GeoPoint,
      ),
      phone: json['phone'] as String,
      verificationStatus: $enumDecode(
        _$VerificationStatusEnumMap,
        json['verificationStatus'],
      ),
      updatedBy: json['updatedBy'] as String,
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$PartnerModelToJson(_PartnerModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'location': const GeoPointConverter().toJson(instance.location),
      'phone': instance.phone,
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus]!,
      'updatedBy': instance.updatedBy,
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'pending',
  VerificationStatus.verified: 'verified',
};

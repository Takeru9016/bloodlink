// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'donor_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DonorProfileModel _$DonorProfileModelFromJson(Map<String, dynamic> json) =>
    _DonorProfileModel(
      bloodGroup: $enumDecode(_$BloodGroupEnumMap, json['bloodGroup']),
      dob: const TimestampConverter().fromJson(json['dob'] as Timestamp),
      lastDonationDate: _$JsonConverterFromJson<Timestamp, Timestamp>(
        json['lastDonationDate'],
        const TimestampConverter().fromJson,
      ),
      verificationStatus: $enumDecode(
        _$VerificationStatusEnumMap,
        json['verificationStatus'],
      ),
      optInRadiusKm: (json['optInRadiusKm'] as num).toDouble(),
    );

Map<String, dynamic> _$DonorProfileModelToJson(_DonorProfileModel instance) =>
    <String, dynamic>{
      'bloodGroup': _$BloodGroupEnumMap[instance.bloodGroup]!,
      'dob': const TimestampConverter().toJson(instance.dob),
      'lastDonationDate': _$JsonConverterToJson<Timestamp, Timestamp>(
        instance.lastDonationDate,
        const TimestampConverter().toJson,
      ),
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus]!,
      'optInRadiusKm': instance.optInRadiusKm,
    };

const _$BloodGroupEnumMap = {
  BloodGroup.aPositive: 'A+',
  BloodGroup.aNegative: 'A-',
  BloodGroup.bPositive: 'B+',
  BloodGroup.bNegative: 'B-',
  BloodGroup.oPositive: 'O+',
  BloodGroup.oNegative: 'O-',
  BloodGroup.abPositive: 'AB+',
  BloodGroup.abNegative: 'AB-',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$VerificationStatusEnumMap = {
  VerificationStatus.unverified: 'unverified',
  VerificationStatus.pending: 'pending',
  VerificationStatus.verified: 'verified',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

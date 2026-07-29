// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BloodRequestModel _$BloodRequestModelFromJson(Map<String, dynamic> json) =>
    _BloodRequestModel(
      requesterId: json['requesterId'] as String,
      patientName: json['patientName'] as String,
      bloodGroup: json['bloodGroup'] as String,
      units: (json['units'] as num).toInt(),
      hospital: json['hospital'] as String,
      location: const GeoPointConverter().fromJson(
        json['location'] as GeoPoint,
      ),
      urgencyWindow: $enumDecode(_$UrgencyWindowEnumMap, json['urgencyWindow']),
      status: $enumDecode(_$BloodRequestStatusEnumMap, json['status']),
      matchedPartnerIds: (json['matchedPartnerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$BloodRequestModelToJson(_BloodRequestModel instance) =>
    <String, dynamic>{
      'requesterId': instance.requesterId,
      'patientName': instance.patientName,
      'bloodGroup': instance.bloodGroup,
      'units': instance.units,
      'hospital': instance.hospital,
      'location': const GeoPointConverter().toJson(instance.location),
      'urgencyWindow': _$UrgencyWindowEnumMap[instance.urgencyWindow]!,
      'status': _$BloodRequestStatusEnumMap[instance.status]!,
      'matchedPartnerIds': instance.matchedPartnerIds,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

const _$UrgencyWindowEnumMap = {
  UrgencyWindow.twoHours: '2h',
  UrgencyWindow.sixHours: '6h',
  UrgencyWindow.twentyFourHours: '24h',
  UrgencyWindow.oneWeek: '1w',
};

const _$BloodRequestStatusEnumMap = {
  BloodRequestStatus.pending: 'pending',
  BloodRequestStatus.matched: 'matched',
  BloodRequestStatus.fulfilled: 'fulfilled',
  BloodRequestStatus.expired: 'expired',
  BloodRequestStatus.cancelled: 'cancelled',
};

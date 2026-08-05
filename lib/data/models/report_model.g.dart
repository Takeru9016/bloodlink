// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => _ReportModel(
  reporterId: json['reporterId'] as String,
  targetType: $enumDecode(_$ReportTargetTypeEnumMap, json['targetType']),
  targetId: json['targetId'] as String,
  reason: json['reason'] as String,
  status: $enumDecode(_$ReportStatusEnumMap, json['status']),
  createdAt: const TimestampConverter().fromJson(
    json['createdAt'] as Timestamp,
  ),
  updatedBy: json['updatedBy'] as String?,
  updatedAt: _$JsonConverterFromJson<Timestamp, Timestamp>(
    json['updatedAt'],
    const TimestampConverter().fromJson,
  ),
);

Map<String, dynamic> _$ReportModelToJson(_ReportModel instance) =>
    <String, dynamic>{
      'reporterId': instance.reporterId,
      'targetType': _$ReportTargetTypeEnumMap[instance.targetType]!,
      'targetId': instance.targetId,
      'reason': instance.reason,
      'status': _$ReportStatusEnumMap[instance.status]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedBy': instance.updatedBy,
      'updatedAt': _$JsonConverterToJson<Timestamp, Timestamp>(
        instance.updatedAt,
        const TimestampConverter().toJson,
      ),
    };

const _$ReportTargetTypeEnumMap = {
  ReportTargetType.request: 'request',
  ReportTargetType.donor: 'donor',
  ReportTargetType.partner: 'partner',
};

const _$ReportStatusEnumMap = {
  ReportStatus.open: 'open',
  ReportStatus.reviewed: 'reviewed',
  ReportStatus.dismissed: 'dismissed',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

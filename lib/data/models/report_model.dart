import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'blood_request_model.dart' show TimestampConverter;

part 'report_model.freezed.dart';
part 'report_model.g.dart';

enum ReportTargetType {
  @JsonValue('request')
  request,
  @JsonValue('donor')
  donor,
  @JsonValue('partner')
  partner,
}

enum ReportStatus {
  @JsonValue('open')
  open,
  @JsonValue('reviewed')
  reviewed,
  @JsonValue('dismissed')
  dismissed,
}

@freezed
abstract class ReportModel with _$ReportModel {
  const factory ReportModel({
    required String reporterId,
    required ReportTargetType targetType,
    required String targetId,
    required String reason,
    required ReportStatus status,
    @TimestampConverter() required Timestamp createdAt,
    String? updatedBy,
    @TimestampConverter() Timestamp? updatedAt,
  }) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
}

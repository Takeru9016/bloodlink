import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'blood_request_model.freezed.dart';
part 'blood_request_model.g.dart';

class GeoPointConverter implements JsonConverter<GeoPoint, GeoPoint> {
  const GeoPointConverter();

  @override
  GeoPoint fromJson(GeoPoint json) => json;

  @override
  GeoPoint toJson(GeoPoint object) => object;
}

class TimestampConverter implements JsonConverter<Timestamp, Timestamp> {
  const TimestampConverter();

  @override
  Timestamp fromJson(Timestamp json) => json;

  @override
  Timestamp toJson(Timestamp object) => object;
}

enum UrgencyWindow {
  @JsonValue('2h')
  twoHours,
  @JsonValue('6h')
  sixHours,
  @JsonValue('24h')
  twentyFourHours,
  @JsonValue('1w')
  oneWeek,
}

enum BloodRequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('matched')
  matched,
  @JsonValue('fulfilled')
  fulfilled,
  @JsonValue('expired')
  expired,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
abstract class BloodRequestModel with _$BloodRequestModel {
  const factory BloodRequestModel({
    required String requesterId,
    required String patientName,
    required String bloodGroup,
    required int units,
    required String hospital,
    @GeoPointConverter() required GeoPoint location,
    required UrgencyWindow urgencyWindow,
    required BloodRequestStatus status,
    required List<String> matchedPartnerIds,
    @TimestampConverter() required Timestamp createdAt,
  }) = _BloodRequestModel;

  factory BloodRequestModel.fromJson(Map<String, dynamic> json) =>
      _$BloodRequestModelFromJson(json);
}

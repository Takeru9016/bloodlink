import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'partner_model.freezed.dart';
part 'partner_model.g.dart';

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

enum VerificationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('verified')
  verified,
}

@freezed
abstract class PartnerModel with _$PartnerModel {
  const factory PartnerModel({
    required String name,
    required String address,
    @GeoPointConverter() required GeoPoint location,
    required String phone,
    required VerificationStatus verificationStatus,
    required String updatedBy,
    @TimestampConverter() required Timestamp updatedAt,
  }) = _PartnerModel;

  factory PartnerModel.fromJson(Map<String, dynamic> json) =>
      _$PartnerModelFromJson(json);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'donation_camp_model.freezed.dart';
part 'donation_camp_model.g.dart';

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

class NullableTimestampConverter
    implements JsonConverter<Timestamp?, Timestamp?> {
  const NullableTimestampConverter();

  @override
  Timestamp? fromJson(Timestamp? json) => json;

  @override
  Timestamp? toJson(Timestamp? object) => object;
}

@freezed
abstract class DonationCampModel with _$DonationCampModel {
  const factory DonationCampModel({
    required String name,
    required String description,
    @GeoPointConverter() required GeoPoint location,
    @TimestampConverter() required Timestamp date,
    required String hostName,
    required String createdBy,
    // Set to the same uid as createdBy on creation, and to the acting admin
    // on every subsequent write (4A-3's edit flow) — CLAUDE.md §5 requires
    // updatedBy/updatedAt on every admin write, not just the first one.
    required String updatedBy,
    // Null immediately after a write, while FieldValue.serverTimestamp() is
    // still resolving on the writing device's own local snapshot.
    @NullableTimestampConverter() Timestamp? updatedAt,
  }) = _DonationCampModel;

  factory DonationCampModel.fromJson(Map<String, dynamic> json) =>
      _$DonationCampModelFromJson(json);
}

@freezed
abstract class CampRsvpModel with _$CampRsvpModel {
  const factory CampRsvpModel({
    // Null immediately after a write, while FieldValue.serverTimestamp() is
    // still resolving on the writing device's own local snapshot.
    @NullableTimestampConverter() Timestamp? joinedAt,
  }) = _CampRsvpModel;

  factory CampRsvpModel.fromJson(Map<String, dynamic> json) =>
      _$CampRsvpModelFromJson(json);
}

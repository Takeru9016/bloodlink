import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'donor_profile_model.freezed.dart';
part 'donor_profile_model.g.dart';

class TimestampConverter implements JsonConverter<Timestamp, Timestamp> {
  const TimestampConverter();

  @override
  Timestamp fromJson(Timestamp json) => json;

  @override
  Timestamp toJson(Timestamp object) => object;
}

enum BloodGroup {
  @JsonValue('A+')
  aPositive,
  @JsonValue('A-')
  aNegative,
  @JsonValue('B+')
  bPositive,
  @JsonValue('B-')
  bNegative,
  @JsonValue('O+')
  oPositive,
  @JsonValue('O-')
  oNegative,
  @JsonValue('AB+')
  abPositive,
  @JsonValue('AB-')
  abNegative,
}

enum VerificationStatus {
  @JsonValue('unverified')
  unverified,
  @JsonValue('pending')
  pending,
  @JsonValue('verified')
  verified,
}

@freezed
abstract class DonorProfileModel with _$DonorProfileModel {
  const factory DonorProfileModel({
    required BloodGroup bloodGroup,
    @TimestampConverter() required Timestamp dob,
    @TimestampConverter() Timestamp? lastDonationDate,
    required VerificationStatus verificationStatus,
    required double optInRadiusKm,
  }) = _DonorProfileModel;

  factory DonorProfileModel.fromJson(Map<String, dynamic> json) =>
      _$DonorProfileModelFromJson(json);
}

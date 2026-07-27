import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

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

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String name,
    required String email,
    String? phone,
    required List<String> roles,
    @GeoPointConverter() GeoPoint? location,
    String? city,
    @TimestampConverter() required Timestamp createdAt,
    // Reserved for Phase 2A push notification setup; not read or written until then.
    String? fcmToken,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

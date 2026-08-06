import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'partner_model.dart' show TimestampConverter;

part 'support_contact_model.freezed.dart';
part 'support_contact_model.g.dart';

@freezed
abstract class SupportContactModel with _$SupportContactModel {
  const factory SupportContactModel({
    required String email,
    required String updatedBy,
    @TimestampConverter() required Timestamp updatedAt,
  }) = _SupportContactModel;

  factory SupportContactModel.fromJson(Map<String, dynamic> json) =>
      _$SupportContactModelFromJson(json);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'partner_model.dart' show TimestampConverter;

part 'help_faq_model.freezed.dart';
part 'help_faq_model.g.dart';

@freezed
abstract class HelpFaqModel with _$HelpFaqModel {
  const factory HelpFaqModel({
    required String question,
    required String answer,
    required int displayOrder,
    required String updatedBy,
    @TimestampConverter() required Timestamp updatedAt,
  }) = _HelpFaqModel;

  factory HelpFaqModel.fromJson(Map<String, dynamic> json) =>
      _$HelpFaqModelFromJson(json);
}

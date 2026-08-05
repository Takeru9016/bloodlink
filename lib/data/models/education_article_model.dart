import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'partner_model.dart' show TimestampConverter;

part 'education_article_model.freezed.dart';
part 'education_article_model.g.dart';

enum EducationArticleCategory {
  @JsonValue('basics')
  basics,
  @JsonValue('eligibility')
  eligibility,
  @JsonValue('guidance')
  guidance,
  @JsonValue('faq')
  faq,
}

@freezed
abstract class EducationArticleModel with _$EducationArticleModel {
  const factory EducationArticleModel({
    required String title,
    required String body,
    required EducationArticleCategory category,
    required int displayOrder,
    String? imageUrl,
    required String updatedBy,
    @TimestampConverter() required Timestamp updatedAt,
  }) = _EducationArticleModel;

  factory EducationArticleModel.fromJson(Map<String, dynamic> json) =>
      _$EducationArticleModelFromJson(json);
}

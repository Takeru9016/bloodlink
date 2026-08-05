// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EducationArticleModel _$EducationArticleModelFromJson(
  Map<String, dynamic> json,
) => _EducationArticleModel(
  title: json['title'] as String,
  body: json['body'] as String,
  category: $enumDecode(_$EducationArticleCategoryEnumMap, json['category']),
  displayOrder: (json['displayOrder'] as num).toInt(),
  imageUrl: json['imageUrl'] as String?,
  updatedBy: json['updatedBy'] as String,
  updatedAt: const TimestampConverter().fromJson(
    json['updatedAt'] as Timestamp,
  ),
);

Map<String, dynamic> _$EducationArticleModelToJson(
  _EducationArticleModel instance,
) => <String, dynamic>{
  'title': instance.title,
  'body': instance.body,
  'category': _$EducationArticleCategoryEnumMap[instance.category]!,
  'displayOrder': instance.displayOrder,
  'imageUrl': instance.imageUrl,
  'updatedBy': instance.updatedBy,
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};

const _$EducationArticleCategoryEnumMap = {
  EducationArticleCategory.basics: 'basics',
  EducationArticleCategory.eligibility: 'eligibility',
  EducationArticleCategory.guidance: 'guidance',
  EducationArticleCategory.faq: 'faq',
};

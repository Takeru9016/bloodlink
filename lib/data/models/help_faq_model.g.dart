// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_faq_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HelpFaqModel _$HelpFaqModelFromJson(Map<String, dynamic> json) =>
    _HelpFaqModel(
      question: json['question'] as String,
      answer: json['answer'] as String,
      displayOrder: (json['displayOrder'] as num).toInt(),
      updatedBy: json['updatedBy'] as String,
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$HelpFaqModelToJson(_HelpFaqModel instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answer': instance.answer,
      'displayOrder': instance.displayOrder,
      'updatedBy': instance.updatedBy,
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

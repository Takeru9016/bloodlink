// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BannerItemModel _$BannerItemModelFromJson(Map<String, dynamic> json) =>
    _BannerItemModel(
      imageUrl: json['imageUrl'] as String,
      linkedPartnerId: json['linkedPartnerId'] as String?,
      displayOrder: (json['displayOrder'] as num).toInt(),
      active: json['active'] as bool,
      createdBy: json['createdBy'] as String,
      updatedBy: json['updatedBy'] as String,
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$BannerItemModelToJson(_BannerItemModel instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'linkedPartnerId': instance.linkedPartnerId,
      'displayOrder': instance.displayOrder,
      'active': instance.active,
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

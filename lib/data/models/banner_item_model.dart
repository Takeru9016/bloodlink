import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'partner_model.dart' show TimestampConverter;

part 'banner_item_model.freezed.dart';
part 'banner_item_model.g.dart';

@freezed
abstract class BannerItemModel with _$BannerItemModel {
  const factory BannerItemModel({
    required String imageUrl,
    required String? linkedPartnerId,
    required int displayOrder,
    required bool active,
    required String createdBy,
    required String updatedBy,
    @TimestampConverter() required Timestamp updatedAt,
  }) = _BannerItemModel;

  factory BannerItemModel.fromJson(Map<String, dynamic> json) =>
      _$BannerItemModelFromJson(json);
}

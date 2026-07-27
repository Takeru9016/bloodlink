// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StockEntryModel _$StockEntryModelFromJson(Map<String, dynamic> json) =>
    _StockEntryModel(
      unitCount: (json['unitCount'] as num).toInt(),
      lastUpdatedBy: json['lastUpdatedBy'] as String,
      lastUpdatedAt: const TimestampConverter().fromJson(
        json['lastUpdatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$StockEntryModelToJson(
  _StockEntryModel instance,
) => <String, dynamic>{
  'unitCount': instance.unitCount,
  'lastUpdatedBy': instance.lastUpdatedBy,
  'lastUpdatedAt': const TimestampConverter().toJson(instance.lastUpdatedAt),
};

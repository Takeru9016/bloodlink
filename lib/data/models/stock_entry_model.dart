import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_entry_model.freezed.dart';
part 'stock_entry_model.g.dart';

class TimestampConverter implements JsonConverter<Timestamp, Timestamp> {
  const TimestampConverter();

  @override
  Timestamp fromJson(Timestamp json) => json;

  @override
  Timestamp toJson(Timestamp object) => object;
}

@freezed
abstract class StockEntryModel with _$StockEntryModel {
  const factory StockEntryModel({
    required int unitCount,
    required String lastUpdatedBy,
    @TimestampConverter() required Timestamp lastUpdatedAt,
  }) = _StockEntryModel;

  factory StockEntryModel.fromJson(Map<String, dynamic> json) =>
      _$StockEntryModelFromJson(json);
}

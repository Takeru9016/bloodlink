import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/report_model.dart';

part 'report_repository.g.dart';

const _targetTypeJson = {
  ReportTargetType.request: 'request',
  ReportTargetType.donor: 'donor',
  ReportTargetType.partner: 'partner',
};

class ReportRepository {
  ReportRepository(FirebaseFirestore firestore)
    : _reports = firestore
          .collection('reports')
          .withConverter<ReportModel>(
            fromFirestore: (snapshot, _) =>
                ReportModel.fromJson(snapshot.data()!),
            toFirestore: (report, _) => report.toJson(),
          ),
      _rawReports = firestore.collection('reports');

  final CollectionReference<ReportModel> _reports;
  final CollectionReference<Map<String, dynamic>> _rawReports;

  Future<void> createReport(
    String reporterId,
    ReportTargetType targetType,
    String targetId,
    String reason,
  ) async {
    await _rawReports.add({
      'reporterId': reporterId,
      'targetType': _targetTypeJson[targetType],
      'targetId': targetId,
      'reason': reason,
      'status': 'open',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<({String id, ReportModel model})>> listOpenReports() async {
    final snapshot = await _reports.where('status', isEqualTo: 'open').get();
    return snapshot.docs.map((doc) => (id: doc.id, model: doc.data())).toList();
  }
}

@Riverpod(keepAlive: true)
ReportRepository reportRepository(Ref ref) {
  return ReportRepository(FirebaseFirestore.instance);
}

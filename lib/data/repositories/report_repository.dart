import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/report_model.dart';
import 'user_repository.dart';

part 'report_repository.g.dart';

const _targetTypeJson = {
  ReportTargetType.request: 'request',
  ReportTargetType.donor: 'donor',
  ReportTargetType.partner: 'partner',
};

const _statusJson = {
  ReportStatus.open: 'open',
  ReportStatus.reviewed: 'reviewed',
  ReportStatus.dismissed: 'dismissed',
};

class ReportPermissionDenied implements Exception {
  ReportPermissionDenied(this.adminUid);

  final String adminUid;

  @override
  String toString() => 'ReportPermissionDenied: user $adminUid is not an admin';
}

class ReportRepository {
  ReportRepository(FirebaseFirestore firestore, UserRepository userRepository)
    : _userRepository = userRepository,
      _reports = firestore
          .collection('reports')
          .withConverter<ReportModel>(
            fromFirestore: (snapshot, _) =>
                ReportModel.fromJson(snapshot.data()!),
            toFirestore: (report, _) => report.toJson(),
          ),
      _rawReports = firestore.collection('reports');

  final UserRepository _userRepository;
  final CollectionReference<ReportModel> _reports;
  final CollectionReference<Map<String, dynamic>> _rawReports;

  Future<void> _requireAdmin(String adminUid) async {
    final user = await _userRepository.getUser(adminUid);
    if (user == null || !user.roles.contains('admin')) {
      throw ReportPermissionDenied(adminUid);
    }
  }

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

  Future<void> _setStatus(
    String reportId,
    ReportStatus status,
    String adminUid,
  ) async {
    await _requireAdmin(adminUid);
    await _rawReports.doc(reportId).update({
      'status': _statusJson[status],
      'updatedBy': adminUid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> resolveReport(String reportId, String adminUid) =>
      _setStatus(reportId, ReportStatus.reviewed, adminUid);

  Future<void> dismissReport(String reportId, String adminUid) =>
      _setStatus(reportId, ReportStatus.dismissed, adminUid);
}

@Riverpod(keepAlive: true)
ReportRepository reportRepository(Ref ref) {
  return ReportRepository(
    FirebaseFirestore.instance,
    ref.watch(userRepositoryProvider),
  );
}

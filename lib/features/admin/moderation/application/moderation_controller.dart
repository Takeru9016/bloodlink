import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/report_model.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/repositories/report_repository.dart';
import '../../../../data/repositories/user_repository.dart';

part 'moderation_controller.g.dart';

@riverpod
Future<List<({String id, ReportModel model})>> openReports(Ref ref) {
  return ref.read(reportRepositoryProvider).listOpenReports();
}

@riverpod
Future<UserModel?> reportUser(Ref ref, String uid) {
  return ref.read(userRepositoryProvider).getUser(uid);
}

@riverpod
class ModerationController extends _$ModerationController {
  @override
  FutureOr<void> build() {}

  Future<void> _setStatus(
    String reportId,
    Future<void> Function(
      ReportRepository repo,
      String reportId,
      String adminUid,
    )
    action,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final adminUid = FirebaseAuth.instance.currentUser?.uid;
      if (adminUid == null) {
        throw StateError('No signed-in admin — cannot attribute this write.');
      }
      await action(ref.read(reportRepositoryProvider), reportId, adminUid);
      ref.invalidate(openReportsProvider);
    });
  }

  Future<void> resolve(String reportId) => _setStatus(
    reportId,
    (repo, id, adminUid) => repo.resolveReport(id, adminUid),
  );

  Future<void> dismiss(String reportId) => _setStatus(
    reportId,
    (repo, id, adminUid) => repo.dismissReport(id, adminUid),
  );
}

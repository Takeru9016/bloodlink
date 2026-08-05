import 'package:bloodlink/data/repositories/report_repository.dart';
import 'package:bloodlink/data/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _userJson({required List<String> roles}) {
  return {
    'name': 'Test User',
    'email': 'user@example.com',
    'roles': roles,
    'createdAt': Timestamp.now(),
  };
}

void main() {
  test(
    'resolveReport sets status, updatedBy, and updatedAt for an admin',
    () async {
      final firestore = FakeFirebaseFirestore();
      await firestore
          .collection('users')
          .doc('admin-1')
          .set(_userJson(roles: ['admin']));
      await firestore.collection('reports').doc('r1').set({
        'reporterId': 'reporter-1',
        'targetType': 'donor',
        'targetId': 'donor-1',
        'reason': 'Spam',
        'status': 'open',
        'createdAt': Timestamp.now(),
      });

      final repo = ReportRepository(firestore, UserRepository(firestore));
      await repo.resolveReport('r1', 'admin-1');

      final doc = await firestore.collection('reports').doc('r1').get();
      expect(doc.data()!['status'], 'reviewed');
      expect(doc.data()!['updatedBy'], 'admin-1');
      expect(doc.data()!['updatedAt'], isNotNull);
    },
  );

  test('dismissReport sets status to dismissed', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection('users')
        .doc('admin-1')
        .set(_userJson(roles: ['admin']));
    await firestore.collection('reports').doc('r1').set({
      'reporterId': 'reporter-1',
      'targetType': 'partner',
      'targetId': 'partner-1',
      'reason': 'Fake listing',
      'status': 'open',
      'createdAt': Timestamp.now(),
    });

    final repo = ReportRepository(firestore, UserRepository(firestore));
    await repo.dismissReport('r1', 'admin-1');

    final doc = await firestore.collection('reports').doc('r1').get();
    expect(doc.data()!['status'], 'dismissed');
    expect(doc.data()!['updatedBy'], 'admin-1');
  });

  test('non-admin cannot resolve or dismiss a report', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection('users')
        .doc('donor-1')
        .set(_userJson(roles: ['donor']));
    await firestore.collection('reports').doc('r1').set({
      'reporterId': 'reporter-1',
      'targetType': 'donor',
      'targetId': 'donor-2',
      'reason': 'Spam',
      'status': 'open',
      'createdAt': Timestamp.now(),
    });

    final repo = ReportRepository(firestore, UserRepository(firestore));

    expect(
      () => repo.resolveReport('r1', 'donor-1'),
      throwsA(isA<ReportPermissionDenied>()),
    );
  });

  test('listOpenReports only returns reports with status open', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('reports').doc('open-1').set({
      'reporterId': 'reporter-1',
      'targetType': 'donor',
      'targetId': 'donor-1',
      'reason': 'Spam',
      'status': 'open',
      'createdAt': Timestamp.now(),
    });
    await firestore.collection('reports').doc('reviewed-1').set({
      'reporterId': 'reporter-2',
      'targetType': 'donor',
      'targetId': 'donor-2',
      'reason': 'Spam',
      'status': 'reviewed',
      'createdAt': Timestamp.now(),
    });

    final repo = ReportRepository(firestore, UserRepository(firestore));
    final results = await repo.listOpenReports();

    expect(results, hasLength(1));
    expect(results.single.id, 'open-1');
  });
}

import 'package:bloodlink/data/repositories/support_contact_repository.dart';
import 'package:bloodlink/data/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _userJson({required List<String> roles}) {
  return {
    'name': 'Test User',
    'email': 'test@example.com',
    'phone': null,
    'roles': roles,
    'location': null,
    'city': null,
    'createdAt': Timestamp.fromDate(DateTime(2026, 1, 1)),
    'fcmToken': null,
  };
}

void main() {
  test('getSupportContact returns null before any admin has set one', () async {
    final firestore = FakeFirebaseFirestore();
    final repository = SupportContactRepository(
      firestore,
      UserRepository(firestore),
    );

    expect(await repository.getSupportContact(), isNull);
  });

  test('updateSupportContact rejects a non-admin caller', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection('users')
        .doc('donor-1')
        .set(_userJson(roles: ['donor']));
    final repository = SupportContactRepository(
      firestore,
      UserRepository(firestore),
    );

    expect(
      () => repository.updateSupportContact('support@example.com', 'donor-1'),
      throwsA(isA<SupportContactPermissionDenied>()),
    );
    expect(await repository.getSupportContact(), isNull);
  });

  test(
    'updateSupportContact stamps updatedBy and round-trips the email',
    () async {
      final firestore = FakeFirebaseFirestore();
      await firestore
          .collection('users')
          .doc('admin-1')
          .set(_userJson(roles: ['admin']));
      final repository = SupportContactRepository(
        firestore,
        UserRepository(firestore),
      );

      await repository.updateSupportContact('support@example.com', 'admin-1');
      final contact = await repository.getSupportContact();

      expect(contact!.email, 'support@example.com');
      expect(contact.updatedBy, 'admin-1');
    },
  );
}

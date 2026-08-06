import 'package:bloodlink/data/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    '4B-5: updateProfile writes name and phone without touching roles/email',
    () async {
      final firestore = FakeFirebaseFirestore();
      await firestore.collection('users').doc('user-1').set({
        'name': 'Old Name',
        'email': 'asha@example.com',
        'phone': null,
        'roles': ['donor'],
        'location': null,
        'city': null,
        'createdAt': Timestamp.now(),
        'fcmToken': null,
      });

      final repo = UserRepository(firestore);
      await repo.updateProfile(
        'user-1',
        name: 'Asha Verma',
        phone: '9998887777',
      );

      final user = await repo.getUser('user-1');
      expect(user!.name, 'Asha Verma');
      expect(user.phone, '9998887777');
      expect(user.email, 'asha@example.com');
      expect(user.roles, ['donor']);
    },
  );

  test('4B-5: updateProfile writes a null phone when cleared', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection('users').doc('user-1').set({
      'name': 'Old Name',
      'email': 'asha@example.com',
      'phone': '9998887777',
      'roles': <String>[],
      'location': null,
      'city': null,
      'createdAt': Timestamp.now(),
      'fcmToken': null,
    });

    final repo = UserRepository(firestore);
    await repo.updateProfile('user-1', name: 'Asha Verma', phone: null);

    final user = await repo.getUser('user-1');
    expect(user!.phone, isNull);
  });
}

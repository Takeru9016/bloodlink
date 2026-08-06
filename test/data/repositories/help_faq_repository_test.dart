import 'package:bloodlink/data/models/help_faq_model.dart';
import 'package:bloodlink/data/repositories/help_faq_repository.dart';
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

HelpFaqModel _faq({required String question, required int displayOrder}) {
  return HelpFaqModel(
    question: question,
    answer: 'Answer.',
    displayOrder: displayOrder,
    updatedBy: '',
    updatedAt: Timestamp.fromMillisecondsSinceEpoch(0),
  );
}

void main() {
  test('createFaq rejects a non-admin caller', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection('users')
        .doc('donor-1')
        .set(_userJson(roles: ['donor']));
    final repository = HelpFaqRepository(firestore, UserRepository(firestore));

    expect(
      () => repository.createFaq(
        _faq(question: 'How does matching work?', displayOrder: 1),
        'donor-1',
      ),
      throwsA(isA<HelpFaqPermissionDenied>()),
    );
  });

  test(
    'createFaq stamps updatedBy/updatedAt and listFaqs orders by displayOrder',
    () async {
      final firestore = FakeFirebaseFirestore();
      await firestore
          .collection('users')
          .doc('admin-1')
          .set(_userJson(roles: ['admin']));
      final repository = HelpFaqRepository(
        firestore,
        UserRepository(firestore),
      );

      await repository.createFaq(
        _faq(question: 'Second', displayOrder: 2),
        'admin-1',
      );
      await repository.createFaq(
        _faq(question: 'First', displayOrder: 1),
        'admin-1',
      );

      final faqs = await repository.listFaqs();

      expect(faqs.map((f) => f.model.question), ['First', 'Second']);
      expect(faqs.first.model.updatedBy, 'admin-1');
    },
  );

  test('updateFaq rejects a non-admin caller and preserves the doc', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection('users')
        .doc('admin-1')
        .set(_userJson(roles: ['admin']));
    final repository = HelpFaqRepository(firestore, UserRepository(firestore));
    final id = await repository.createFaq(
      _faq(question: 'Original', displayOrder: 1),
      'admin-1',
    );

    await firestore
        .collection('users')
        .doc('donor-1')
        .set(_userJson(roles: ['donor']));

    await expectLater(
      repository.updateFaq(
        id,
        _faq(question: 'Hijacked', displayOrder: 1),
        'donor-1',
      ),
      throwsA(isA<HelpFaqPermissionDenied>()),
    );

    final faq = await repository.getFaq(id);
    expect(faq!.question, 'Original');
  });
}

import 'package:bloodlink/data/models/education_article_model.dart';
import 'package:bloodlink/data/repositories/education_article_repository.dart';
import 'package:bloodlink/data/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _UnusedFirebaseStorage implements FirebaseStorage {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('this test must not touch Cloud Storage');
}

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
  test('createArticle rejects a non-admin caller', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection('users')
        .doc('donor-1')
        .set(_userJson(roles: ['donor']));
    final repository = EducationArticleRepository(
      firestore,
      _UnusedFirebaseStorage(),
      UserRepository(firestore),
    );

    expect(
      () => repository.createArticle(
        EducationArticleModel(
          title: 'What is blood?',
          body: 'Body text.',
          category: EducationArticleCategory.basics,
          displayOrder: 1,
          updatedBy: '',
          updatedAt: Timestamp.fromMillisecondsSinceEpoch(0),
        ),
        'donor-1',
      ),
      throwsA(isA<EducationArticlePermissionDenied>()),
    );
  });

  test('createArticle stamps updatedBy/updatedAt and listArticles orders by '
      'displayOrder', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection('users')
        .doc('admin-1')
        .set(_userJson(roles: ['admin']));
    final repository = EducationArticleRepository(
      firestore,
      _UnusedFirebaseStorage(),
      UserRepository(firestore),
    );

    await repository.createArticle(
      EducationArticleModel(
        title: 'Second',
        body: 'Body.',
        category: EducationArticleCategory.faq,
        displayOrder: 2,
        updatedBy: '',
        updatedAt: Timestamp.fromMillisecondsSinceEpoch(0),
      ),
      'admin-1',
    );
    await repository.createArticle(
      EducationArticleModel(
        title: 'First',
        body: 'Body.',
        category: EducationArticleCategory.basics,
        displayOrder: 1,
        updatedBy: '',
        updatedAt: Timestamp.fromMillisecondsSinceEpoch(0),
      ),
      'admin-1',
    );

    final articles = await repository.listArticles();

    expect(articles.map((a) => a.model.title), ['First', 'Second']);
    expect(articles.first.model.updatedBy, 'admin-1');
  });

  test('listArticles filters by category', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection('users')
        .doc('admin-1')
        .set(_userJson(roles: ['admin']));
    final repository = EducationArticleRepository(
      firestore,
      _UnusedFirebaseStorage(),
      UserRepository(firestore),
    );

    await repository.createArticle(
      EducationArticleModel(
        title: 'Basics article',
        body: 'Body.',
        category: EducationArticleCategory.basics,
        displayOrder: 1,
        updatedBy: '',
        updatedAt: Timestamp.fromMillisecondsSinceEpoch(0),
      ),
      'admin-1',
    );
    await repository.createArticle(
      EducationArticleModel(
        title: 'FAQ article',
        body: 'Body.',
        category: EducationArticleCategory.faq,
        displayOrder: 2,
        updatedBy: '',
        updatedAt: Timestamp.fromMillisecondsSinceEpoch(0),
      ),
      'admin-1',
    );

    final basicsOnly = await repository.listArticles(
      category: EducationArticleCategory.basics,
    );

    expect(basicsOnly, hasLength(1));
    expect(basicsOnly.single.model.title, 'Basics article');
  });

  test('createArticle round-trips a null and a non-null imageUrl', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore
        .collection('users')
        .doc('admin-1')
        .set(_userJson(roles: ['admin']));
    final repository = EducationArticleRepository(
      firestore,
      _UnusedFirebaseStorage(),
      UserRepository(firestore),
    );

    await repository.createArticle(
      EducationArticleModel(
        title: 'No image',
        body: 'Body.',
        category: EducationArticleCategory.basics,
        displayOrder: 1,
        updatedBy: '',
        updatedAt: Timestamp.fromMillisecondsSinceEpoch(0),
      ),
      'admin-1',
    );
    await repository.createArticle(
      EducationArticleModel(
        title: 'Has image',
        body: 'Body.',
        category: EducationArticleCategory.basics,
        displayOrder: 2,
        imageUrl: 'https://example.com/article.jpg',
        updatedBy: '',
        updatedAt: Timestamp.fromMillisecondsSinceEpoch(0),
      ),
      'admin-1',
    );

    final articles = await repository.listArticles();

    expect(articles[0].model.imageUrl, isNull);
    expect(articles[1].model.imageUrl, 'https://example.com/article.jpg');
  });
}

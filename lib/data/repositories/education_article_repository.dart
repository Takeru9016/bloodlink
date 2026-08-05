import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/education_article_model.dart';
import 'user_repository.dart';

part 'education_article_repository.g.dart';

class EducationArticlePermissionDenied implements Exception {
  EducationArticlePermissionDenied(this.adminUid);

  final String adminUid;

  @override
  String toString() =>
      'EducationArticlePermissionDenied: user $adminUid is not an admin';
}

class EducationArticleRepository {
  EducationArticleRepository(
    FirebaseFirestore firestore,
    FirebaseStorage storage,
    UserRepository userRepository,
  ) : _storage = storage,
      _userRepository = userRepository,
      _articles = firestore
          .collection('educationArticles')
          .withConverter<EducationArticleModel>(
            fromFirestore: (snapshot, _) =>
                EducationArticleModel.fromJson(snapshot.data()!),
            toFirestore: (article, _) => article.toJson(),
          ),
      _rawArticles = firestore.collection('educationArticles');

  final FirebaseStorage _storage;
  final UserRepository _userRepository;
  final CollectionReference<EducationArticleModel> _articles;
  final CollectionReference<Map<String, dynamic>> _rawArticles;

  Future<void> _requireAdmin(String adminUid) async {
    final user = await _userRepository.getUser(adminUid);
    if (user == null || !user.roles.contains('admin')) {
      throw EducationArticlePermissionDenied(adminUid);
    }
  }

  Future<EducationArticleModel?> getArticle(String id) async {
    final snapshot = await _articles.doc(id).get();
    return snapshot.data();
  }

  // Sorts client-side (rather than chaining .orderBy after the category
  // .where) so the filtered query doesn't require a composite Firestore
  // index — with only 6 articles total, an in-memory sort costs nothing.
  Future<List<({String id, EducationArticleModel model})>> listArticles({
    EducationArticleCategory? category,
  }) async {
    final query = category == null
        ? _articles
        : _articles.where('category', isEqualTo: category.name);
    final snapshot = await query.get();
    final results = snapshot.docs
        .map((doc) => (id: doc.id, model: doc.data()))
        .toList();
    results.sort(
      (a, b) => a.model.displayOrder.compareTo(b.model.displayOrder),
    );
    return results;
  }

  /// The path's ID is a fresh, unclaimed Firestore ID borrowed purely as a
  /// unique filename, same decoupled-upload pattern as
  /// BannerItemRepository.uploadBannerImage.
  Future<String> uploadArticleImage(File image) async {
    final id = _rawArticles.doc().id;
    final ref = _storage.ref('educationImages/$id.jpg');
    await ref.putFile(image, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  Future<String> createArticle(
    EducationArticleModel article,
    String adminUid,
  ) async {
    await _requireAdmin(adminUid);
    final doc = _rawArticles.doc();
    await doc.set({
      ...article.toJson(),
      'updatedBy': adminUid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> updateArticle(
    String id,
    EducationArticleModel article,
    String adminUid,
  ) async {
    await _requireAdmin(adminUid);
    await _rawArticles.doc(id).set({
      ...article.toJson(),
      'updatedBy': adminUid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteArticle(String id, String adminUid) async {
    await _requireAdmin(adminUid);
    await _rawArticles.doc(id).delete();
  }
}

@Riverpod(keepAlive: true)
EducationArticleRepository educationArticleRepository(Ref ref) {
  return EducationArticleRepository(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
    ref.watch(userRepositoryProvider),
  );
}

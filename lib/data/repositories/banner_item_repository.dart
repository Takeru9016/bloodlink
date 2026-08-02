import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/banner_item_model.dart';
import 'user_repository.dart';

part 'banner_item_repository.g.dart';

class BannerPermissionDenied implements Exception {
  BannerPermissionDenied(this.adminUid);

  final String adminUid;

  @override
  String toString() => 'BannerPermissionDenied: user $adminUid is not an admin';
}

class BannerItemRepository {
  BannerItemRepository(
    FirebaseFirestore firestore,
    FirebaseStorage storage,
    UserRepository userRepository,
  ) : _storage = storage,
      _userRepository = userRepository,
      _banners = firestore
          .collection('bannerItems')
          .withConverter<BannerItemModel>(
            fromFirestore: (snapshot, _) =>
                BannerItemModel.fromJson(snapshot.data()!),
            toFirestore: (banner, _) => banner.toJson(),
          ),
      _rawBanners = firestore.collection('bannerItems');

  final FirebaseStorage _storage;
  final UserRepository _userRepository;
  final CollectionReference<BannerItemModel> _banners;
  final CollectionReference<Map<String, dynamic>> _rawBanners;

  Future<void> _requireAdmin(String adminUid) async {
    final user = await _userRepository.getUser(adminUid);
    if (user == null || !user.roles.contains('admin')) {
      throw BannerPermissionDenied(adminUid);
    }
  }

  Future<List<({String id, BannerItemModel model})>> listActiveBanners() async {
    final snapshot = await _banners.where('active', isEqualTo: true).get();
    final results = snapshot.docs
        .map((doc) => (id: doc.id, model: doc.data()))
        .toList();
    results.sort(
      (a, b) => a.model.displayOrder.compareTo(b.model.displayOrder),
    );
    return results;
  }

  Future<List<({String id, BannerItemModel model})>> listAllBanners() async {
    final snapshot = await _banners.get();
    final results = snapshot.docs
        .map((doc) => (id: doc.id, model: doc.data()))
        .toList();
    results.sort(
      (a, b) => a.model.displayOrder.compareTo(b.model.displayOrder),
    );
    return results;
  }

  /// The path's ID is a fresh, unclaimed Firestore ID borrowed purely as a
  /// unique filename — it has no relationship to the ID the banner document
  /// eventually gets from [createBanner]. Decoupling upload from the
  /// Firestore write (per this task's spec) means the two ID spaces are
  /// independent; the returned URL is the only link a caller needs.
  Future<String> uploadBannerImage(File image) async {
    final id = _rawBanners.doc().id;
    final ref = _storage.ref('bannerImages/$id.jpg');
    await ref.putFile(image, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  Future<String> createBanner(BannerItemModel banner, String adminUid) async {
    await _requireAdmin(adminUid);
    final doc = _rawBanners.doc();
    await doc.set({
      ...banner.toJson(),
      'createdBy': adminUid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> updateBanner(
    String id,
    BannerItemModel banner,
    String adminUid,
  ) async {
    await _requireAdmin(adminUid);
    await _rawBanners.doc(id).set({
      ...banner.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setActive(String id, bool active, String adminUid) async {
    await _requireAdmin(adminUid);
    await _rawBanners.doc(id).update({
      'active': active,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

@Riverpod(keepAlive: true)
BannerItemRepository bannerItemRepository(Ref ref) {
  return BannerItemRepository(
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
    ref.watch(userRepositoryProvider),
  );
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/partner_model.dart';
import '../models/stock_entry_model.dart';
import 'user_repository.dart';

part 'partner_repository.g.dart';

class PartnerPermissionDenied implements Exception {
  PartnerPermissionDenied(this.adminUid);

  final String adminUid;

  @override
  String toString() =>
      'PartnerPermissionDenied: user $adminUid is not an admin';
}

class PartnerRepository {
  PartnerRepository(FirebaseFirestore firestore, UserRepository userRepository)
    : _userRepository = userRepository,
      _partners = firestore
          .collection('partners')
          .withConverter<PartnerModel>(
            fromFirestore: (snapshot, _) =>
                PartnerModel.fromJson(snapshot.data()!),
            toFirestore: (partner, _) => partner.toJson(),
          ),
      _rawPartners = firestore.collection('partners');

  final UserRepository _userRepository;
  final CollectionReference<PartnerModel> _partners;
  final CollectionReference<Map<String, dynamic>> _rawPartners;

  CollectionReference<StockEntryModel> _stockCollection(String partnerId) {
    return _rawPartners
        .doc(partnerId)
        .collection('stock')
        .withConverter<StockEntryModel>(
          fromFirestore: (snapshot, _) =>
              StockEntryModel.fromJson(snapshot.data()!),
          toFirestore: (entry, _) => entry.toJson(),
        );
  }

  CollectionReference<Map<String, dynamic>> _rawStockCollection(
    String partnerId,
  ) {
    return _rawPartners.doc(partnerId).collection('stock');
  }

  Future<void> _requireAdmin(String adminUid) async {
    final user = await _userRepository.getUser(adminUid);
    if (user == null || !user.roles.contains('admin')) {
      throw PartnerPermissionDenied(adminUid);
    }
  }

  Future<PartnerModel?> getPartner(String id) async {
    final snapshot = await _partners.doc(id).get();
    return snapshot.data();
  }

  Future<List<PartnerModel>> listPartners({bool verifiedOnly = false}) async {
    final query = verifiedOnly
        ? _partners.where('verificationStatus', isEqualTo: 'verified')
        : _partners;
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<String> createPartner(PartnerModel partner, String adminUid) async {
    await _requireAdmin(adminUid);
    final doc = await _partners.add(partner);
    return doc.id;
  }

  Future<void> updatePartner(
    String id,
    PartnerModel partner,
    String adminUid,
  ) async {
    await _requireAdmin(adminUid);
    await _partners.doc(id).set(partner);
  }

  Future<Map<String, StockEntryModel>> getStock(String partnerId) async {
    final snapshot = await _stockCollection(partnerId).get();
    return {for (final doc in snapshot.docs) doc.id: doc.data()};
  }

  Future<void> updateStock(
    String partnerId,
    String bloodGroup,
    int unitCount,
    String adminUid,
  ) async {
    await _requireAdmin(adminUid);
    await _rawStockCollection(partnerId).doc(bloodGroup).set({
      'unitCount': unitCount,
      'lastUpdatedBy': adminUid,
      'lastUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<Map<String, StockEntryModel>> watchStock(String partnerId) {
    return _stockCollection(partnerId).snapshots().map(
      (snapshot) => {for (final doc in snapshot.docs) doc.id: doc.data()},
    );
  }
}

@Riverpod(keepAlive: true)
PartnerRepository partnerRepository(Ref ref) {
  return PartnerRepository(
    FirebaseFirestore.instance,
    ref.watch(userRepositoryProvider),
  );
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/blood_request_model.dart';

part 'blood_request_repository.g.dart';

class BloodRequestRepository {
  BloodRequestRepository(FirebaseFirestore firestore)
    : _requests = firestore
          .collection('bloodRequests')
          .withConverter<BloodRequestModel>(
            fromFirestore: (snapshot, _) =>
                BloodRequestModel.fromJson(snapshot.data()!),
            toFirestore: (request, _) => request.toJson(),
          ),
      _rawRequests = firestore.collection('bloodRequests');

  final CollectionReference<BloodRequestModel> _requests;
  final CollectionReference<Map<String, dynamic>> _rawRequests;

  Future<String> createRequest(BloodRequestModel request) async {
    final doc = _rawRequests.doc();
    await doc.set({
      ...request.toJson(),
      'status': 'pending',
      'matchedPartnerIds': <String>[],
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<BloodRequestModel?> getRequest(String id) async {
    final snapshot = await _requests.doc(id).get();
    return snapshot.data();
  }

  Stream<BloodRequestModel?> watchRequest(String id) {
    return _requests.doc(id).snapshots().map((snapshot) => snapshot.data());
  }

  Future<List<({String id, BloodRequestModel request})>> listRequestsForUser(
    String uid,
  ) async {
    final snapshot = await _requests.where('requesterId', isEqualTo: uid).get();
    return snapshot.docs
        .map((doc) => (id: doc.id, request: doc.data()))
        .toList();
  }

  /// Count of pending requests within [radiusMeters] of [center] — a rough
  /// "local demand" stat, not a precise geo-query. Firestore has no native
  /// radius filter here, so this fetches all pending requests and filters
  /// client-side, same approach as `bank_locator_controller.dart`'s distance
  /// sort. Fine at this app's expected scale; revisit with geohashing if the
  /// `bloodRequests` collection ever grows large enough for this to matter.
  Future<int> countPendingNear(GeoPoint center, double radiusMeters) async {
    // 'pending' (not BloodRequestStatus.pending) — withConverter only runs
    // on document read/write, not on query filter values, so an enum here
    // would be sent to Firestore as-is and never match the stored string.
    final snapshot = await _requests
        .where('status', isEqualTo: 'pending')
        .get();
    return snapshot.docs.where((doc) {
      final location = doc.data().location;
      final distance = Geolocator.distanceBetween(
        center.latitude,
        center.longitude,
        location.latitude,
        location.longitude,
      );
      return distance <= radiusMeters;
    }).length;
  }
}

@Riverpod(keepAlive: true)
BloodRequestRepository bloodRequestRepository(Ref ref) {
  return BloodRequestRepository(FirebaseFirestore.instance);
}

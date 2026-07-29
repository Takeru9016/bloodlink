import 'package:cloud_firestore/cloud_firestore.dart';
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
}

@Riverpod(keepAlive: true)
BloodRequestRepository bloodRequestRepository(Ref ref) {
  return BloodRequestRepository(FirebaseFirestore.instance);
}

import 'package:bloodlink/data/repositories/blood_request_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _requestJson({
  required GeoPoint location,
  required String status,
}) {
  return {
    'requesterId': 'requester-1',
    'patientName': 'Test Patient',
    'bloodGroup': 'O+',
    'units': 1,
    'hospital': 'Test Hospital',
    'location': location,
    'urgencyWindow': '2h',
    'status': status,
    'matchedPartnerIds': <String>[],
    'createdAt': Timestamp.fromDate(DateTime(2026, 1, 1)),
  };
}

void main() {
  test(
    'countPendingNear counts only pending requests within the radius',
    () async {
      final firestore = FakeFirebaseFirestore();
      // ~15.7 km from (0, 0) — inside a 50 km radius.
      await firestore
          .collection('bloodRequests')
          .add(
            _requestJson(location: const GeoPoint(0.1, 0.1), status: 'pending'),
          );
      // Roughly 1,500+ km from (0, 0) — well outside the radius.
      await firestore
          .collection('bloodRequests')
          .add(
            _requestJson(location: const GeoPoint(10, 10), status: 'pending'),
          );
      // Nearby but not pending — must be excluded.
      await firestore
          .collection('bloodRequests')
          .add(
            _requestJson(
              location: const GeoPoint(0.1, 0.1),
              status: 'fulfilled',
            ),
          );

      final repository = BloodRequestRepository(firestore);
      final count = await repository.countPendingNear(
        const GeoPoint(0, 0),
        50000,
      );

      expect(count, 1);
    },
  );
}

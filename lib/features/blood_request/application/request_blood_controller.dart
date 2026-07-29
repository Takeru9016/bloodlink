import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/blood_request_model.dart';
import '../../../data/repositories/blood_request_repository.dart';

part 'request_blood_controller.g.dart';

@riverpod
class RequestBloodController extends _$RequestBloodController {
  @override
  FutureOr<void> build() {}

  /// Creates the request and returns its doc id, or null if the write failed
  /// (the error is left on [state] for the screen to surface).
  Future<String?> submit({
    required String patientName,
    required String bloodGroup,
    required int units,
    required String hospital,
    required GeoPoint location,
    required UrgencyWindow urgencyWindow,
  }) async {
    state = const AsyncLoading();
    String? resultId;
    state = await AsyncValue.guard(() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        throw StateError(
          'No signed-in user — cannot attribute this blood request.',
        );
      }

      resultId = await ref
          .read(bloodRequestRepositoryProvider)
          .createRequest(
            BloodRequestModel(
              requesterId: firebaseUser.uid,
              patientName: patientName,
              bloodGroup: bloodGroup,
              units: units,
              hospital: hospital,
              location: location,
              urgencyWindow: urgencyWindow,
              status: BloodRequestStatus.pending,
              matchedPartnerIds: const [],
              createdAt: Timestamp.now(),
            ),
          );
    });
    return state.hasError ? null : resultId;
  }
}

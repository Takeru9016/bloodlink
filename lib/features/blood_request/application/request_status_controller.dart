import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/blood_request_model.dart';
import '../../../data/repositories/blood_request_repository.dart';

part 'request_status_controller.g.dart';

typedef RequestStatusEntry = ({String id, BloodRequestModel request});

@riverpod
Future<List<RequestStatusEntry>> requestStatusList(Ref ref) async {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser == null) {
    throw StateError('No signed-in user — cannot list requests.');
  }
  return ref
      .read(bloodRequestRepositoryProvider)
      .listRequestsForUser(firebaseUser.uid);
}

// keepAlive: the screen never watches this provider (loading state is
// tracked locally per-request-id instead), so with autoDispose the provider
// had zero listeners and could be torn down while updateStatus's callable
// await was still in flight — the next `state = ...` write then threw
// "Ref used after being disposed". Matches FcmController's same rationale.
@Riverpod(keepAlive: true)
class RequestStatusController extends _$RequestStatusController {
  @override
  FutureOr<void> build() {}

  Future<bool> updateStatus({
    required String requestId,
    required BloodRequestStatus newStatus,
  }) async {
    assert(
      newStatus == BloodRequestStatus.fulfilled ||
          newStatus == BloodRequestStatus.cancelled,
      'updateRequestStatus only supports transitioning to fulfilled or cancelled.',
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final callable = FirebaseFunctions.instance.httpsCallable(
        'updateRequestStatus',
      );
      await callable.call({
        'requestId': requestId,
        'newStatus': newStatus.name,
      });
    });

    final succeeded = !state.hasError;
    if (succeeded) {
      ref.invalidate(requestStatusListProvider);
    }
    return succeeded;
  }
}

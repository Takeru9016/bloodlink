import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/notification_repository.dart';

part 'notification_center_controller.g.dart';

typedef NotificationCenterState = ({
  List<NotificationEntry> today,
  List<NotificationEntry> earlier,
});

@riverpod
Future<NotificationCenterState> notificationCenterList(Ref ref) async {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  if (firebaseUser == null) {
    throw StateError('No signed-in user — cannot list notifications.');
  }
  return ref.read(notificationRepositoryProvider).listForUser(firebaseUser.uid);
}

// keepAlive: same rationale as RequestStatusController — the screen doesn't
// watch this provider's own state (it watches notificationCenterListProvider
// instead), so with autoDispose it could be torn down mid-write.
@Riverpod(keepAlive: true)
class NotificationCenterController extends _$NotificationCenterController {
  @override
  FutureOr<void> build() {}

  Future<bool> markAsRead(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(notificationRepositoryProvider).markAsRead(id),
    );

    final succeeded = !state.hasError;
    if (succeeded) {
      ref.invalidate(notificationCenterListProvider);
    }
    return succeeded;
  }
}

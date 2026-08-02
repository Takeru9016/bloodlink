import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/notification_model.dart';

part 'notification_repository.g.dart';

/// Read-only for now — creation is Cloud-Function/admin driven per
/// `firestore.rules`, and there's no Notifications screen yet to mark items
/// read. Home only needs the unread count for its bell badge.
class NotificationRepository {
  NotificationRepository(FirebaseFirestore firestore)
    : _notifications = firestore
          .collection('notifications')
          .withConverter<NotificationModel>(
            fromFirestore: (snapshot, _) =>
                NotificationModel.fromJson(snapshot.data()!),
            toFirestore: (notification, _) => notification.toJson(),
          );

  final CollectionReference<NotificationModel> _notifications;

  Stream<int> watchUnreadCount(String uid) {
    return _notifications
        .where('userId', isEqualTo: uid)
        .where('readStatus', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(Ref ref) {
  return NotificationRepository(FirebaseFirestore.instance);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/notification_model.dart';

part 'notification_repository.g.dart';

typedef NotificationEntry = ({String id, NotificationModel model});

/// Creation is still Cloud-Function/admin driven per `firestore.rules` —
/// nothing here writes a new notification doc, only reads and marks-read.
class NotificationRepository {
  NotificationRepository(FirebaseFirestore firestore)
    : _notifications = firestore
          .collection('notifications')
          .withConverter<NotificationModel>(
            fromFirestore: (snapshot, _) =>
                NotificationModel.fromJson(snapshot.data()!),
            toFirestore: (notification, _) => notification.toJson(),
          ),
      _rawNotifications = firestore.collection('notifications');

  final CollectionReference<NotificationModel> _notifications;
  final CollectionReference<Map<String, dynamic>> _rawNotifications;

  Stream<int> watchUnreadCount(String uid) {
    return _notifications
        .where('userId', isEqualTo: uid)
        .where('readStatus', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// One-shot fetch, split into "today" / "earlier" by the *device's local*
  /// calendar day (not UTC) — matches how a user reads a "Today" section on
  /// their own phone, not the server's day boundary. A notification created
  /// at 11:59pm local time lands in "today"; one at 12:01am local time on
  /// the next calendar day lands in "earlier" once that next day arrives.
  ///
  /// [now] defaults to the real current time; overridable for tests so the
  /// day-boundary split doesn't depend on when the test happens to run.
  Future<({List<NotificationEntry> today, List<NotificationEntry> earlier})>
  listForUser(String uid, {DateTime? now}) async {
    final snapshot = await _notifications
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();

    final effectiveNow = now ?? DateTime.now();
    final startOfToday = DateTime(
      effectiveNow.year,
      effectiveNow.month,
      effectiveNow.day,
    );

    final today = <NotificationEntry>[];
    final earlier = <NotificationEntry>[];
    for (final doc in snapshot.docs) {
      final entry = (id: doc.id, model: doc.data());
      final createdAtLocal = entry.model.createdAt.toDate().toLocal();
      if (!createdAtLocal.isBefore(startOfToday)) {
        today.add(entry);
      } else {
        earlier.add(entry);
      }
    }
    return (today: today, earlier: earlier);
  }

  Future<void> markAsRead(String id) async {
    await _rawNotifications.doc(id).update({'readStatus': true});
  }
}

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(Ref ref) {
  return NotificationRepository(FirebaseFirestore.instance);
}

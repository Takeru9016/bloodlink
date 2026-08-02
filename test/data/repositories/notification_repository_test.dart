import 'package:bloodlink/data/repositories/notification_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _notificationJson({
  required DateTime createdAt,
  bool readStatus = false,
}) {
  return {
    'userId': 'donor-1',
    'type': 'request_status',
    'payload': {'requestId': 'req-1', 'status': 'matched'},
    'readStatus': readStatus,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}

void main() {
  test('listForUser splits by the device-local calendar day, not a fixed '
      '24-hour window', () async {
    final firestore = FakeFirebaseFirestore();

    // "Now" for this test: local Jan 2, 2026, 12:01am — one minute past
    // today's local midnight.
    final now = DateTime(2026, 1, 2, 0, 1);

    // 11:59pm local the previous day — one minute before local midnight.
    // A naive "within the last 24 hours" split would wrongly place this
    // in "today" (only 2 minutes before `now`); the local-calendar-day
    // split correctly places it in "earlier".
    await firestore
        .collection('notifications')
        .add(_notificationJson(createdAt: DateTime(2026, 1, 1, 23, 59)));

    // 12:01am local today — one minute after local midnight, and the
    // same clock time as `now`. Belongs in "today".
    await firestore
        .collection('notifications')
        .add(_notificationJson(createdAt: DateTime(2026, 1, 2, 0, 1)));

    // Several days earlier — unambiguously "earlier".
    await firestore
        .collection('notifications')
        .add(_notificationJson(createdAt: DateTime(2025, 12, 28, 12, 0)));

    final repository = NotificationRepository(firestore);
    final result = await repository.listForUser('donor-1', now: now);

    expect(result.today, hasLength(1));
    expect(
      result.today.single.model.createdAt.toDate(),
      DateTime(2026, 1, 2, 0, 1),
    );
    expect(result.earlier, hasLength(2));
  });
}

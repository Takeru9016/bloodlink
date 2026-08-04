import 'package:bloodlink/data/models/donation_camp_model.dart';
import 'package:bloodlink/data/repositories/donation_camp_repository.dart';
import 'package:bloodlink/data/repositories/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('watchRsvpCount emits the live count of rsvps as they change', () async {
    final firestore = FakeFirebaseFirestore();
    final repository = DonationCampRepository(
      firestore,
      UserRepository(firestore),
    );
    await firestore.collection('donationCamps').doc('camp-1').set({
      'name': 'Test Camp',
      'description': 'Description',
      'location': const GeoPoint(0, 0),
      'date': Timestamp.fromDate(DateTime(2026, 12, 1)),
      'hostName': 'Test Host',
      'createdBy': 'admin-1',
      'updatedBy': 'admin-1',
      'updatedAt': Timestamp.fromDate(DateTime(2026, 1, 1)),
    });

    final counts = <int>[];
    final subscription = repository.watchRsvpCount('camp-1').listen(counts.add);

    await Future<void>.delayed(Duration.zero);
    expect(counts.last, 0);

    await repository.rsvp('camp-1', 'donor-1');
    await Future<void>.delayed(Duration.zero);
    expect(counts.last, 1);

    await repository.rsvp('camp-1', 'donor-2');
    await Future<void>.delayed(Duration.zero);
    expect(counts.last, 2);

    await repository.cancelRsvp('camp-1', 'donor-1');
    await Future<void>.delayed(Duration.zero);
    expect(counts.last, 1);

    await subscription.cancel();
  });

  test('updateCamp stamps updatedBy/updatedAt and preserves createdBy; '
      'listAllCamps returns all camps regardless of date', () async {
    final firestore = FakeFirebaseFirestore();
    final repository = DonationCampRepository(
      firestore,
      UserRepository(firestore),
    );
    await firestore.collection('users').doc('admin-1').set({
      'name': 'Admin One',
      'email': 'admin1@example.com',
      'roles': ['admin'],
      'createdAt': Timestamp.now(),
    });
    await firestore.collection('users').doc('admin-2').set({
      'name': 'Admin Two',
      'email': 'admin2@example.com',
      'roles': ['admin'],
      'createdAt': Timestamp.now(),
    });

    final campId = await repository.createCamp(
      DonationCampModel(
        name: 'Past Camp',
        description: 'Description',
        location: const GeoPoint(0, 0),
        date: Timestamp.fromDate(DateTime(2020, 1, 1)),
        hostName: 'Test Host',
        createdBy: 'admin-1',
        updatedBy: 'admin-1',
        updatedAt: Timestamp.now(),
      ),
      'admin-1',
    );

    final created = await repository.getCamp(campId);
    expect(created!.createdBy, 'admin-1');

    await repository.updateCamp(
      campId,
      created.copyWith(name: 'Updated Camp'),
      'admin-2',
    );

    final updated = await repository.getCamp(campId);
    expect(updated!.name, 'Updated Camp');
    expect(updated.createdBy, 'admin-1');
    expect(updated.updatedBy, 'admin-2');

    final all = await repository.listAllCamps();
    expect(all.map((entry) => entry.id), contains(campId));
  });
}

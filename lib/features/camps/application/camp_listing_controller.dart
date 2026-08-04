import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/donation_camp_model.dart';
import '../../../data/repositories/donation_camp_repository.dart';

part 'camp_listing_controller.g.dart';

enum CampLocationStatus { resolving, available, unavailable }

typedef CampListingEntry = ({
  String id,
  DonationCampModel camp,
  double? distanceMeters,
});

typedef CampListingState = ({
  List<CampListingEntry> entries,
  CampLocationStatus locationStatus,
});

@riverpod
class CampListingController extends _$CampListingController {
  @override
  Future<CampListingState> build() async {
    final records = await ref
        .read(donationCampRepositoryProvider)
        .listUpcomingCamps();

    // Already date-sorted by the repository query — keep that order as-is;
    // distance is attached for display only, not used to re-sort.
    final entries = records
        .map<CampListingEntry>(
          (r) => (id: r.id, camp: r.camp, distanceMeters: null),
        )
        .toList();

    unawaited(_resolveDistances());

    return (entries: entries, locationStatus: CampLocationStatus.resolving);
  }

  Future<void> _resolveDistances() async {
    final position = await _requestPosition();
    if (!ref.mounted) return;

    final current = state.value;
    if (current == null) return;

    if (position == null) {
      state = AsyncData((
        entries: current.entries,
        locationStatus: CampLocationStatus.unavailable,
      ));
      return;
    }

    final withDistances = current.entries
        .map<CampListingEntry>(
          (entry) => (
            id: entry.id,
            camp: entry.camp,
            distanceMeters: Geolocator.distanceBetween(
              position.latitude,
              position.longitude,
              entry.camp.location.latitude,
              entry.camp.location.longitude,
            ),
          ),
        )
        .toList();

    if (!ref.mounted) return;
    state = AsyncData((
      entries: withDistances,
      locationStatus: CampLocationStatus.available,
    ));
  }

  Future<Position?> _requestPosition() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled ||
          permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      return await Geolocator.getCurrentPosition();
    } catch (_) {
      return null;
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

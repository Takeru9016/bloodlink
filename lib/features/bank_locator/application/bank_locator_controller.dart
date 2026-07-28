import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/partner_model.dart';
import '../../../data/repositories/partner_repository.dart';

part 'bank_locator_controller.g.dart';

enum BankLocationStatus { resolving, available, unavailable }

typedef BankLocatorEntry = ({
  String id,
  PartnerModel partner,
  double? distanceMeters,
});

typedef BankLocatorState = ({
  List<BankLocatorEntry> entries,
  BankLocationStatus locationStatus,
});

@riverpod
class BankLocatorController extends _$BankLocatorController {
  @override
  Future<BankLocatorState> build() async {
    final records = await ref
        .read(partnerRepositoryProvider)
        .listPartners(verifiedOnly: true);

    // Deterministic ordering for the gap between "list loaded" and "position
    // resolved": alphabetical by name, not whatever order Firestore returns.
    // Re-sorted by distance once _resolveLocationAndReorder finishes below.
    final sorted = [...records]
      ..sort((a, b) => a.partner.name.compareTo(b.partner.name));
    final entries = sorted
        .map<BankLocatorEntry>(
          (r) => (id: r.id, partner: r.partner, distanceMeters: null),
        )
        .toList();

    unawaited(_resolveLocationAndReorder());

    return (entries: entries, locationStatus: BankLocationStatus.resolving);
  }

  Future<void> _resolveLocationAndReorder() async {
    final position = await _requestPosition();
    if (!ref.mounted) return;

    final current = state.value;
    if (current == null) return;

    if (position == null) {
      state = AsyncData((
        entries: current.entries,
        locationStatus: BankLocationStatus.unavailable,
      ));
      return;
    }

    // Non-nullable distanceMeters throughout this intermediate step, so the
    // sort below never needs to force-unwrap a nullable field.
    final withDistances =
        current.entries
            .map(
              (entry) => (
                entry: entry,
                distanceMeters: Geolocator.distanceBetween(
                  position.latitude,
                  position.longitude,
                  entry.partner.location.latitude,
                  entry.partner.location.longitude,
                ),
              ),
            )
            .toList()
          ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));

    if (!ref.mounted) return;
    state = AsyncData((
      entries: withDistances
          .map<BankLocatorEntry>(
            (d) => (
              id: d.entry.id,
              partner: d.entry.partner,
              distanceMeters: d.distanceMeters,
            ),
          )
          .toList(),
      locationStatus: BankLocationStatus.available,
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

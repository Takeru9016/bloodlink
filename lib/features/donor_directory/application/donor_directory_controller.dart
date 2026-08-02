import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/donor_profile_model.dart';
import '../../../data/repositories/donor_profile_repository.dart';
import '../../../data/repositories/user_repository.dart';

part 'donor_directory_controller.g.dart';

enum DonorDirectoryLocationStatus { resolving, available, unavailable }

typedef DonorDirectoryEntry = ({
  String id,
  DonorProfileModel profile,
  String name,
  double? distanceMeters,
});

typedef DonorDirectoryState = ({
  String? bloodGroup,
  double? radiusKm,
  List<DonorDirectoryEntry> entries,
  DonorDirectoryLocationStatus locationStatus,
});

@riverpod
class DonorDirectoryController extends _$DonorDirectoryController {
  String? _bloodGroup;
  double? _radiusKm;
  Position? _position;

  @override
  Future<DonorDirectoryState> build() async {
    unawaited(_resolvePosition());
    return (
      bloodGroup: null,
      radiusKm: null,
      entries: const <DonorDirectoryEntry>[],
      locationStatus: DonorDirectoryLocationStatus.resolving,
    );
  }

  Future<void> _resolvePosition() async {
    final position = await _requestPosition();
    if (!ref.mounted) return;
    _position = position;

    // A blood group may already be selected by the time location resolves —
    // re-run so radius filtering (which needs both) takes effect.
    if (_bloodGroup != null) {
      await _runQuery();
      return;
    }

    final current = state.value;
    if (current == null) return;
    state = AsyncData((
      bloodGroup: current.bloodGroup,
      radiusKm: current.radiusKm,
      entries: current.entries,
      locationStatus: position == null
          ? DonorDirectoryLocationStatus.unavailable
          : DonorDirectoryLocationStatus.available,
    ));
  }

  Future<void> setBloodGroup(String bloodGroup) async {
    _bloodGroup = bloodGroup;
    await _runQuery();
  }

  Future<void> setRadiusKm(double? radiusKm) async {
    _radiusKm = radiusKm;
    if (_bloodGroup != null) {
      await _runQuery();
      return;
    }
    final current = state.value;
    if (current == null) return;
    state = AsyncData((
      bloodGroup: current.bloodGroup,
      radiusKm: radiusKm,
      entries: current.entries,
      locationStatus: current.locationStatus,
    ));
  }

  Future<void> _runQuery() async {
    final bloodGroup = _bloodGroup;
    if (bloodGroup == null) return;

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final position = _position;
      final radiusKm = _radiusKm;
      final near = (position != null && radiusKm != null)
          ? GeoPoint(position.latitude, position.longitude)
          : null;

      final results = await ref
          .read(donorProfileRepositoryProvider)
          .queryVerifiedDonors(
            bloodGroup: bloodGroup,
            near: near,
            radiusKm: near != null ? radiusKm : null,
          );

      final userRepository = ref.read(userRepositoryProvider);
      final entries = await Future.wait(
        results.map((result) async {
          final user = await userRepository.getUser(result.id);
          final location = user?.location;
          final distanceMeters = (position != null && location != null)
              ? Geolocator.distanceBetween(
                  position.latitude,
                  position.longitude,
                  location.latitude,
                  location.longitude,
                )
              : null;
          return (
            id: result.id,
            profile: result.profile,
            name: user?.name ?? 'Unknown donor',
            distanceMeters: distanceMeters,
          );
        }),
      );

      entries.sort((a, b) {
        final aDistance = a.distanceMeters;
        final bDistance = b.distanceMeters;
        if (aDistance == null && bDistance == null) return 0;
        if (aDistance == null) return 1;
        if (bDistance == null) return -1;
        return aDistance.compareTo(bDistance);
      });

      return (
        bloodGroup: bloodGroup,
        radiusKm: radiusKm,
        entries: entries,
        locationStatus: position == null
            ? DonorDirectoryLocationStatus.unavailable
            : DonorDirectoryLocationStatus.available,
      );
    });
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
}

import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repositories/donation_camp_repository.dart';

part 'manage_camps_controller.g.dart';

@riverpod
class ManageCampsController extends _$ManageCampsController {
  @override
  Future<List<DonationCampEntry>> build() {
    return ref.read(donationCampRepositoryProvider).listAllCamps();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

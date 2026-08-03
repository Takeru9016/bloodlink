import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/donor_profile_model.dart';
import '../../../data/repositories/donor_profile_repository.dart';

part 'donor_verification_controller.g.dart';

@riverpod
Stream<DonorProfileModel?> myDonorProfile(Ref ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return const Stream.empty();
  return ref.read(donorProfileRepositoryProvider).watchProfile(uid);
}

@riverpod
class DonorVerificationController extends _$DonorVerificationController {
  final _imagePicker = ImagePicker();

  @override
  FutureOr<void> build() {}

  /// Picks an ID photo and submits it. Safe to call again while already
  /// "pending" or after a rejection — each call overwrites the previous
  /// submission rather than appending to it (see [DonorProfileRepository]).
  Future<void> pickAndSubmit(ImageSource source) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('No signed-in user');

    var picked = await _imagePicker.pickImage(source: source, imageQuality: 85);
    if (picked == null) {
      // On Android, the picker's host Activity can be recreated while the
      // system photo picker is in front (low memory, or "Don't keep
      // activities"), which silently drops the in-flight pickImage() result
      // instead of returning it or throwing. retrieveLostData() recovers it
      // — without this, the picker looks like a no-op.
      final lost = await _imagePicker.retrieveLostData();
      if (lost.isEmpty || lost.file == null) return;
      picked = lost.file;
    }
    if (picked == null) return;

    final imagePath = picked.path;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(donorProfileRepositoryProvider);
      final docUrl = await repo.uploadVerificationDoc(uid, File(imagePath));
      await repo.submitVerification(uid, docUrl);
    });
  }
}

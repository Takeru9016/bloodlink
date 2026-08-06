import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/support_contact_model.dart';
import '../../../../data/repositories/support_contact_repository.dart';

part 'support_contact_admin_controller.g.dart';

@riverpod
class SupportContactAdminController extends _$SupportContactAdminController {
  @override
  Future<SupportContactModel?> build() {
    return ref.read(supportContactRepositoryProvider).getSupportContact();
  }

  Future<void> save(String email) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(supportContactRepositoryProvider)
          .updateSupportContact(email, firebaseUser.uid);
      return ref.read(supportContactRepositoryProvider).getSupportContact();
    });
  }
}

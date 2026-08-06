import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/help_faq_model.dart';
import '../../../../data/repositories/help_faq_repository.dart';

part 'faq_form_controller.g.dart';

@riverpod
Future<HelpFaqModel?> faqById(Ref ref, String faqId) {
  return ref.read(helpFaqRepositoryProvider).getFaq(faqId);
}

@riverpod
class FaqFormController extends _$FaqFormController {
  @override
  FutureOr<void> build() {}

  /// Creates or updates the FAQ and returns its doc id, or null if the
  /// write failed (the error is left on [state] for the screen to surface).
  Future<String?> submit({
    required String? faqId,
    required String question,
    required String answer,
    required int displayOrder,
  }) async {
    state = const AsyncLoading();
    String? resultId = faqId;
    state = await AsyncValue.guard(() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        throw StateError(
          'No signed-in admin — cannot attribute this FAQ write.',
        );
      }
      final adminUid = firebaseUser.uid;
      final repo = ref.read(helpFaqRepositoryProvider);
      final faq = HelpFaqModel(
        question: question,
        answer: answer,
        displayOrder: displayOrder,
        // Overwritten by HelpFaqRepository with the acting admin's
        // uid/server timestamp — never persisted as-is.
        updatedBy: '',
        updatedAt: Timestamp.now(),
      );

      if (faqId == null) {
        resultId = await repo.createFaq(faq, adminUid);
      } else {
        await repo.updateFaq(faqId, faq, adminUid);
      }
    });
    return state.hasError ? null : resultId;
  }
}

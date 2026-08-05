import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/education_article_model.dart';
import '../../../../data/repositories/education_article_repository.dart';

part 'article_form_controller.g.dart';

@riverpod
Future<EducationArticleModel?> articleById(Ref ref, String articleId) {
  return ref.read(educationArticleRepositoryProvider).getArticle(articleId);
}

@riverpod
class ArticleFormController extends _$ArticleFormController {
  @override
  FutureOr<void> build() {}

  /// Creates or updates the article and returns its doc id, or null if the
  /// write failed (the error is left on [state] for the screen to surface).
  Future<String?> submit({
    required String? articleId,
    required EducationArticleModel article,
    required File? image,
  }) async {
    state = const AsyncLoading();
    String? resultId = articleId;
    state = await AsyncValue.guard(() async {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        throw StateError(
          'No signed-in admin — cannot attribute this article write.',
        );
      }
      final adminUid = firebaseUser.uid;
      final repo = ref.read(educationArticleRepositoryProvider);

      var imageUrl = article.imageUrl;
      if (image != null) {
        imageUrl = await repo.uploadArticleImage(image);
      }
      final withImage = article.copyWith(imageUrl: imageUrl);

      if (articleId == null) {
        resultId = await repo.createArticle(withImage, adminUid);
      } else {
        await repo.updateArticle(articleId, withImage, adminUid);
      }
    });
    return state.hasError ? null : resultId;
  }
}

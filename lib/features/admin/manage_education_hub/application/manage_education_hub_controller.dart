import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/education_article_model.dart';
import '../../../../data/repositories/education_article_repository.dart';

part 'manage_education_hub_controller.g.dart';

@riverpod
class ManageEducationHubController extends _$ManageEducationHubController {
  @override
  Future<List<({String id, EducationArticleModel model})>> build() {
    return ref.read(educationArticleRepositoryProvider).listArticles();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

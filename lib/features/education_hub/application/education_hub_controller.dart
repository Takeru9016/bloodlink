import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/education_article_model.dart';
import '../../../data/repositories/education_article_repository.dart';

part 'education_hub_controller.g.dart';

typedef EducationArticleEntry = ({String id, EducationArticleModel model});

@riverpod
class EducationHubController extends _$EducationHubController {
  @override
  Future<List<EducationArticleEntry>> build() {
    return ref.watch(educationArticleRepositoryProvider).listArticles();
  }
}

@riverpod
Future<EducationArticleModel?> educationArticle(Ref ref, String articleId) {
  return ref.watch(educationArticleRepositoryProvider).getArticle(articleId);
}

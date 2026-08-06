import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/models/help_faq_model.dart';
import '../../../../data/repositories/help_faq_repository.dart';

part 'manage_help_faqs_controller.g.dart';

@riverpod
class ManageHelpFaqsController extends _$ManageHelpFaqsController {
  @override
  Future<List<({String id, HelpFaqModel model})>> build() {
    return ref.read(helpFaqRepositoryProvider).listFaqs();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/help_faq_model.dart';
import '../../../data/models/support_contact_model.dart';
import '../../../data/repositories/help_faq_repository.dart';
import '../../../data/repositories/support_contact_repository.dart';

part 'help_support_controller.g.dart';

typedef HelpSupportState = ({
  List<({String id, HelpFaqModel model})> faqs,
  SupportContactModel? supportContact,
});

@riverpod
class HelpSupportController extends _$HelpSupportController {
  @override
  Future<HelpSupportState> build() async {
    final faqs = await ref.watch(helpFaqRepositoryProvider).listFaqs();
    final supportContact = await ref
        .watch(supportContactRepositoryProvider)
        .getSupportContact();
    return (faqs: faqs, supportContact: supportContact);
  }
}

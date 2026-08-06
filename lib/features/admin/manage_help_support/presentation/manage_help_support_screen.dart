import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/help_faq_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_input.dart';
import '../application/manage_help_faqs_controller.dart';
import '../application/support_contact_admin_controller.dart';

class ManageHelpSupportScreen extends ConsumerWidget {
  const ManageHelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final faqsAsync = ref.watch(manageHelpFaqsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage help & support')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoute.adminHelpFaqNewName),
        icon: const Icon(Icons.add),
        label: const Text('New FAQ'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(manageHelpFaqsControllerProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            children: [
              Text('Support contact', style: textTheme.titleMedium),
              const SizedBox(height: 12),
              const _SupportContactSection(),
              const SizedBox(height: 24),
              Text('FAQs', style: textTheme.titleMedium),
              const SizedBox(height: 12),
              faqsAsync.when(
                data: (faqs) {
                  if (faqs.isEmpty) {
                    return Text(
                      'No FAQs yet',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colors.textSecondary,
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final entry in faqs) ...[
                        _FaqRow(id: entry.id, faq: entry.model),
                        const SizedBox(height: 12),
                      ],
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text('Failed to load FAQs: $error'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportContactSection extends ConsumerStatefulWidget {
  const _SupportContactSection();

  @override
  ConsumerState<_SupportContactSection> createState() =>
      _SupportContactSectionState();
}

class _SupportContactSectionState
    extends ConsumerState<_SupportContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _prefilled = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(supportContactAdminControllerProvider.notifier)
        .save(_emailController.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Support contact updated')));
  }

  @override
  Widget build(BuildContext context) {
    final contactAsync = ref.watch(supportContactAdminControllerProvider);

    return contactAsync.when(
      data: (contact) {
        if (!_prefilled) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _prefilled) return;
            setState(() {
              _emailController.text = contact?.email ?? '';
              _prefilled = true;
            });
          });
          return const Center(child: CircularProgressIndicator());
        }
        return AppCard(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInput(
                  label: 'Support email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'e.g. support@example.com',
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.isEmpty) return 'Email is required';
                    if (!trimmed.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Save',
                  isLoading: contactAsync.isLoading,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Text('Failed to load support contact: $error'),
    );
  }
}

class _FaqRow extends StatelessWidget {
  const _FaqRow({required this.id, required this.faq});

  final String id;
  final HelpFaqModel faq;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(faq.question, style: textTheme.bodyLarge),
                const SizedBox(height: 6),
                Text('Order ${faq.displayOrder}', style: textTheme.labelSmall),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.goNamed(
              AppRoute.adminHelpFaqEditName,
              pathParameters: {'faqId': id},
            ),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}

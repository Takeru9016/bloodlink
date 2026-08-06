import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/help_faq_model.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/help_support_controller.dart';

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  Future<void> _emailSupport(BuildContext context, String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open a mail app for $email')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final stateAsync = ref.watch(helpSupportControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Help & support')),
      body: SafeArea(
        child: stateAsync.when(
          data: (state) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('Frequently asked questions', style: textTheme.titleMedium),
              const SizedBox(height: 12),
              if (state.faqs.isEmpty)
                Text(
                  'No questions added yet.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                )
              else
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: Column(
                      children: [
                        for (final entry in state.faqs)
                          _FaqTile(faq: entry.model),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Text('Contact us', style: textTheme.titleMedium),
              const SizedBox(height: 12),
              AppCard(
                child: state.supportContact == null
                    ? Text(
                        'Support contact not set up yet.',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colors.textSecondary,
                        ),
                      )
                    : Row(
                        children: [
                          Icon(Icons.email_outlined, color: colors.brandRed),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email support',
                                  style: textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  state.supportContact!.email,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => _emailSupport(
                              context,
                              state.supportContact!.email,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              'Failed to load help content: $error',
              style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.faq});

  final HelpFaqModel faq;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;

    return ExpansionTile(
      title: Text(faq.question, style: textTheme.bodyLarge),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          faq.answer,
          style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
        ),
      ],
    );
  }
}

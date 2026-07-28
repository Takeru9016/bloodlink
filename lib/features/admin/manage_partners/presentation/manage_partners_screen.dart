import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/partner_model.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_card.dart';
import '../application/manage_partners_controller.dart';

class ManagePartnersScreen extends ConsumerWidget {
  const ManagePartnersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final partnersAsync = ref.watch(managePartnersControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage partners')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed(AppRoute.adminPartnerNewName),
        icon: const Icon(Icons.add),
        label: const Text('Add new partner'),
      ),
      body: SafeArea(
        child: partnersAsync.when(
          data: (partners) {
            if (partners.isEmpty) {
              return Center(
                child: Text(
                  'No partner banks yet',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(managePartnersControllerProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                itemCount: partners.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final record = partners[index];
                  final isVerified =
                      record.partner.verificationStatus ==
                      VerificationStatus.verified;
                  return AppCard(
                    onTap: () => context.goNamed(
                      AppRoute.adminPartnerEditName,
                      pathParameters: {'partnerId': record.id},
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            record.partner.name,
                            style: textTheme.bodyLarge,
                          ),
                        ),
                        const SizedBox(width: 12),
                        AppBadge(
                          label: isVerified ? 'Verified' : 'Pending',
                          variant: isVerified
                              ? AppBadgeVariant.verified
                              : AppBadgeVariant.pending,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Failed to load partners: $error')),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/partner_model.dart';
import '../../../data/models/stock_entry_model.dart';
import '../../../shared/widgets/app_badge.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/bank_profile_controller.dart';

const _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

String _formatTimestamp(Timestamp timestamp) {
  final date = timestamp.toDate().toLocal();
  final datePart =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
  final timePart =
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
  return '$datePart at $timePart';
}

class BankProfileScreen extends ConsumerWidget {
  const BankProfileScreen({super.key, required this.bankId});

  final String bankId;

  Future<void> _callBank(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open dialer for $phone')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partnerAsync = ref.watch(bankProfilePartnerProvider(bankId));

    return Scaffold(
      body: partnerAsync.when(
        data: (partner) {
          if (partner == null) {
            return const _CenteredMessage(message: 'Bank not found');
          }
          return _BankProfileBody(bankId: bankId, partner: partner);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            _CenteredMessage(message: 'Failed to load bank: $error'),
      ),
      bottomNavigationBar: partnerAsync.maybeWhen(
        data: (partner) => partner == null
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AppButton(
                    label: 'Contact ${partner.phone}',
                    onPressed: () => _callBank(context, partner.phone),
                  ),
                ),
              ),
        orElse: () => null,
      ),
    );
  }
}

class _BankProfileBody extends ConsumerWidget {
  const _BankProfileBody({required this.bankId, required this.partner});

  final String bankId;
  final PartnerModel partner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final stockAsync = ref.watch(bankProfileStockProvider(bankId));

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 160,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Text(
              partner.name,
              style: textTheme.titleLarge?.copyWith(color: colors.surface),
            ),
            background: Container(color: colors.brandRed),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              AppBadge(
                label: partner.verificationStatus == VerificationStatus.verified
                    ? 'Verified'
                    : 'Pending',
                variant:
                    partner.verificationStatus == VerificationStatus.verified
                    ? AppBadgeVariant.verified
                    : AppBadgeVariant.pending,
              ),
              const SizedBox(height: 16),
              _InfoRow(
                icon: Icons.location_on_outlined,
                label: partner.address,
              ),
              const SizedBox(height: 8),
              _InfoRow(icon: Icons.phone_outlined, label: partner.phone),
              const SizedBox(height: 24),
              Text('Blood stock', style: textTheme.titleMedium),
              const SizedBox(height: 12),
              stockAsync.when(
                data: (stock) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StockGrid(stock: stock),
                    const SizedBox(height: 12),
                    Text(
                      _lastUpdatedLabel(stock),
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Text('Failed to load stock: $error'),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  String _lastUpdatedLabel(Map<String, StockEntryModel> stock) {
    final mostRecent = mostRecentStockUpdate(stock);
    if (mostRecent == null) return 'Stock last updated: —';
    return 'Stock last updated: ${_formatTimestamp(mostRecent)}';
  }
}

class _StockGrid extends StatelessWidget {
  const _StockGrid({required this.stock});

  final Map<String, StockEntryModel> stock;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.4,
      children: [
        for (final group in _bloodGroups)
          AppCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(group, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '${stock[group]?.unitCount ?? 0} units',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Center(
      child: Text(
        message,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/blood_request_model.dart';
import '../../../shared/widgets/app_card.dart';
import '../application/matched_banks_controller.dart';

// onRequestCreated (2A-2) resolves within a couple of seconds of the doc
// being created; 15s is a generous buffer for Cloud Function cold starts
// before treating a still-pending, still-empty-matches request as
// "no banks found" rather than leaving a spinner up forever.
const _matchTimeout = Duration(seconds: 15);

class MatchedBanksScreen extends ConsumerStatefulWidget {
  const MatchedBanksScreen({super.key, required this.requestId});

  final String requestId;

  @override
  ConsumerState<MatchedBanksScreen> createState() => _MatchedBanksScreenState();
}

class _MatchedBanksScreenState extends ConsumerState<MatchedBanksScreen> {
  Timer? _timeoutTimer;
  bool _timedOut = false;

  @override
  void initState() {
    super.initState();
    _timeoutTimer = Timer(_matchTimeout, () {
      if (!mounted) return;
      // Re-read the live value at fire time rather than trusting whatever
      // was true when the timer was scheduled — if a match already landed,
      // this must stay a no-op so the matched branch (checked first in
      // build()) keeps winning instead of this flag ever hiding it.
      final request = ref
          .read(matchedBanksRequestProvider(widget.requestId))
          .value;
      if (request != null &&
          request.status == BloodRequestStatus.pending &&
          request.matchedPartnerIds.isEmpty) {
        setState(() => _timedOut = true);
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _openBankProfile(String bankId) {
    context.goNamed(
      AppRoute.bankProfileName,
      pathParameters: {'bankId': bankId},
    );
  }

  static String _formatDistance(double meters) {
    if (meters < 1000) return '${meters.round()} m away';
    return '${(meters / 1000).toStringAsFixed(1)} km away';
  }

  @override
  Widget build(BuildContext context) {
    final requestAsync = ref.watch(
      matchedBanksRequestProvider(widget.requestId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Matched banks')),
      body: SafeArea(
        child: requestAsync.when(
          data: (request) {
            if (request == null) {
              return const _CenteredMessage(message: 'Request not found');
            }

            switch (request.status) {
              case BloodRequestStatus.matched:
                return _MatchedList(
                  request: request,
                  onTap: _openBankProfile,
                  formatDistance: _formatDistance,
                );
              case BloodRequestStatus.fulfilled:
              case BloodRequestStatus.cancelled:
              case BloodRequestStatus.expired:
                // 2A-5 owns the real status-tracking UI for terminal
                // states — this just keeps the requester from being
                // stranded here if status changes away from
                // pending/matched while this screen is still open.
                return _CenteredMessage(
                  message: 'This request is now ${request.status.name}.',
                );
              case BloodRequestStatus.pending:
                return _timedOut
                    ? const _CenteredMessage(
                        message:
                            'No banks currently have matching stock '
                            'nearby. Please check back later.',
                      )
                    : const _MatchingIndicator();
            }
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              _CenteredMessage(message: 'Failed to load request: $error'),
        ),
      ),
    );
  }
}

class _MatchedList extends ConsumerWidget {
  const _MatchedList({
    required this.request,
    required this.onTap,
    required this.formatDistance,
  });

  final BloodRequestModel request;
  final ValueChanged<String> onTap;
  final String Function(double) formatDistance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(
      matchedBankEntriesProvider((
        partnerIds: request.matchedPartnerIds,
        requestLocation: request.location,
        bloodGroup: request.bloodGroup,
      )),
    );

    return entriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return const _CenteredMessage(
            message: 'No banks currently have matching stock nearby.',
          );
        }

        final textTheme = Theme.of(context).textTheme;
        final colors = Theme.of(context).extension<AppColors>()!;

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final entry = entries[index];
            return AppCard(
              onTap: () => onTap(entry.id),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.partner.name, style: textTheme.bodyLarge),
                  const SizedBox(height: 4),
                  Text(
                    formatDistance(entry.distanceMeters),
                    style: textTheme.labelSmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${entry.stockUnits} units of ${request.bloodGroup} available',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          _CenteredMessage(message: 'Failed to load banks: $error'),
    );
  }
}

class _MatchingIndicator extends StatelessWidget {
  const _MatchingIndicator();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Matching you to nearby banks…',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
        ),
      ),
    );
  }
}

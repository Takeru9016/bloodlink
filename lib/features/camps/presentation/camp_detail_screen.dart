import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/donation_camp_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../application/camp_detail_controller.dart';

String _formatDate(Timestamp timestamp) {
  final date = timestamp.toDate().toLocal();
  final datePart =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
  final timePart =
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
  return '$datePart at $timePart';
}

Future<void> _openDirections(BuildContext context, GeoPoint location) async {
  final uri = Uri.parse(
    'https://www.google.com/maps/search/?api=1'
    '&query=${location.latitude},${location.longitude}',
  );
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Could not open Maps')));
  }
}

class CampDetailScreen extends ConsumerWidget {
  const CampDetailScreen({super.key, required this.campId});

  final String campId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campAsync = ref.watch(campDetailProvider(campId));

    return Scaffold(
      body: campAsync.when(
        data: (camp) {
          if (camp == null) {
            return const _CenteredMessage(message: 'Camp not found');
          }
          return _CampDetailBody(campId: campId, camp: camp);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            const AppErrorView(message: "Couldn't load this camp."),
      ),
    );
  }
}

class _CampDetailBody extends ConsumerWidget {
  const _CampDetailBody({required this.campId, required this.camp});

  final String campId;
  final DonationCampModel camp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final rsvpCountAsync = ref.watch(campRsvpCountProvider(campId));
    final rsvpStatusAsync = ref.watch(campRsvpStatusProvider(campId));
    final rsvpControllerState = ref.watch(campRsvpControllerProvider);
    final isRsvped = rsvpStatusAsync.value ?? false;
    final markerPosition = LatLng(
      camp.location.latitude,
      camp.location.longitude,
    );

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            title: Text(
              camp.name,
              style: textTheme.titleLarge?.copyWith(color: colors.surface),
            ),
            background: camp.imageUrl != null
                ? Image.network(
                    camp.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: colors.brandRed),
                  )
                : Container(color: colors.brandRed),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _InfoRow(icon: Icons.location_on_outlined, label: camp.address),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.event_outlined,
                label: _formatDate(camp.date),
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.groups_outlined,
                label: 'Hosted by ${camp.hostName}',
              ),
              const SizedBox(height: 20),
              Text('About this camp', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(camp.description, style: textTheme.bodyMedium),
              const SizedBox(height: 20),
              Text('Location', style: textTheme.titleMedium),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: SizedBox(
                  height: 180,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: markerPosition,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('camp-location'),
                        position: markerPosition,
                      ),
                    },
                    zoomControlsEnabled: false,
                    scrollGesturesEnabled: false,
                    onTap: (_) => _openDirections(context, camp.location),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _openDirections(context, camp.location),
                  icon: const Icon(Icons.directions_outlined, size: 18),
                  label: const Text('Get directions'),
                ),
              ),
              const SizedBox(height: 12),
              rsvpCountAsync.when(
                data: (rsvpCount) => Text(
                  '$rsvpCount ${rsvpCount == 1 ? 'person has' : 'people have'} '
                  "RSVP'd",
                  style: textTheme.bodyMedium,
                ),
                loading: () => Text(
                  'Loading RSVP count…',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                error: (error, _) => Text(
                  'Failed to load RSVP count',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: isRsvped ? 'Cancel RSVP' : 'RSVP',
                variant: isRsvped
                    ? AppButtonVariant.outline
                    : AppButtonVariant.filled,
                isLoading: rsvpControllerState.isLoading,
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final succeeded = await ref
                      .read(campRsvpControllerProvider.notifier)
                      .toggle(campId: campId, isRsvped: isRsvped);
                  if (!succeeded) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          isRsvped ? 'Failed to cancel RSVP' : 'Failed to RSVP',
                        ),
                      ),
                    );
                  }
                },
              ),
            ]),
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

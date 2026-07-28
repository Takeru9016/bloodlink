import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_input.dart';
import '../application/bank_locator_controller.dart';

const _defaultCameraTarget = LatLng(0, 0);
const _defaultCameraZoom = 2.0;
const _pinsCameraZoom = 12.0;

enum _ViewMode { list, map }

class BankLocatorScreen extends ConsumerStatefulWidget {
  const BankLocatorScreen({super.key});

  @override
  ConsumerState<BankLocatorScreen> createState() => _BankLocatorScreenState();
}

class _BankLocatorScreenState extends ConsumerState<BankLocatorScreen> {
  final _searchController = TextEditingController();
  _ViewMode _viewMode = _ViewMode.list;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BankLocatorEntry> _filter(List<BankLocatorEntry> entries) {
    if (_query.isEmpty) return entries;
    return entries
        .where(
          (entry) =>
              entry.partner.name.toLowerCase().contains(_query) ||
              entry.partner.address.toLowerCase().contains(_query),
        )
        .toList();
  }

  String _formatDistance(double? meters) {
    if (meters == null) return 'Distance unavailable';
    if (meters < 1000) return '${meters.round()} m away';
    return '${(meters / 1000).toStringAsFixed(1)} km away';
  }

  void _openBankProfile(String bankId) {
    context.goNamed(
      AppRoute.bankProfileName,
      pathParameters: {'bankId': bankId},
    );
  }

  void _showPinSheet(BankLocatorEntry entry) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        final textTheme = Theme.of(sheetContext).textTheme;
        final colors = Theme.of(sheetContext).extension<AppColors>()!;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.partner.name, style: textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(entry.partner.address, style: textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  _formatDistance(entry.distanceMeters),
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'View profile',
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    _openBankProfile(entry.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(List<BankLocatorEntry> entries) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No banks found',
          style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: entries.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return AppCard(
          onTap: () => _openBankProfile(entry.id),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.partner.name, style: textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(entry.partner.address, style: textTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                _formatDistance(entry.distanceMeters),
                style: textTheme.labelSmall,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMap(List<BankLocatorEntry> entries) {
    final markers = entries
        .map(
          (entry) => Marker(
            markerId: MarkerId(entry.id),
            position: LatLng(
              entry.partner.location.latitude,
              entry.partner.location.longitude,
            ),
            infoWindow: InfoWindow(title: entry.partner.name),
            onTap: () => _showPinSheet(entry),
          ),
        )
        .toSet();

    final initialTarget = entries.isNotEmpty
        ? LatLng(
            entries.first.partner.location.latitude,
            entries.first.partner.location.longitude,
          )
        : _defaultCameraTarget;

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialTarget,
        zoom: entries.isEmpty ? _defaultCameraZoom : _pinsCameraZoom,
      ),
      markers: markers,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).extension<AppColors>()!;
    final stateAsync = ref.watch(bankLocatorControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank locator'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(AppRadius.button),
              constraints: const BoxConstraints(minHeight: 36, minWidth: 44),
              isSelected: [
                _viewMode == _ViewMode.list,
                _viewMode == _ViewMode.map,
              ],
              onPressed: (index) =>
                  setState(() => _viewMode = _ViewMode.values[index]),
              children: const [Icon(Icons.list), Icon(Icons.map_outlined)],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: stateAsync.when(
          data: (state) {
            final filtered = _filter(state.entries);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: AppInput(
                    label: 'Search',
                    controller: _searchController,
                    hintText: 'Search by name or location',
                  ),
                ),
                if (state.locationStatus == BankLocationStatus.resolving)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Row(
                      children: [
                        const SizedBox(
                          height: 14,
                          width: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Finding your location…',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: _viewMode == _ViewMode.list
                      ? _buildList(filtered)
                      : _buildMap(filtered),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              'Failed to load bank locations: $error',
              style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

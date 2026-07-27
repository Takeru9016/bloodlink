import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/donor_profile_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../application/donor_profile_setup_controller.dart';

const _minDonorAgeYears = 18;

const _bloodGroupLabels = {
  BloodGroup.aPositive: 'A+',
  BloodGroup.aNegative: 'A-',
  BloodGroup.bPositive: 'B+',
  BloodGroup.bNegative: 'B-',
  BloodGroup.oPositive: 'O+',
  BloodGroup.oNegative: 'O-',
  BloodGroup.abPositive: 'AB+',
  BloodGroup.abNegative: 'AB-',
};

enum _LocationStatus { notRequested, requesting, granted, denied }

bool _isAtLeastMinimumAge(DateTime dob) {
  final now = DateTime.now();
  var age = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    age--;
  }
  return age >= _minDonorAgeYears;
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

class DonorProfileSetupScreen extends ConsumerStatefulWidget {
  const DonorProfileSetupScreen({super.key});

  @override
  ConsumerState<DonorProfileSetupScreen> createState() =>
      _DonorProfileSetupScreenState();
}

class _DonorProfileSetupScreenState
    extends ConsumerState<DonorProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();

  BloodGroup? _bloodGroup;
  DateTime? _dob;
  DateTime? _lastDonationDate;

  _LocationStatus _locationStatus = _LocationStatus.notRequested;
  GeoPoint? _deviceLocation;

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _dob ?? DateTime(now.year - _minDonorAgeYears, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _pickLastDonationDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _lastDonationDate ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _lastDonationDate = picked);
  }

  Future<void> _requestLocation() async {
    setState(() => _locationStatus = _LocationStatus.requesting);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled ||
          permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() => _locationStatus = _LocationStatus.denied);
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _deviceLocation = GeoPoint(position.latitude, position.longitude);
        _locationStatus = _LocationStatus.granted;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _locationStatus = _LocationStatus.denied);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_dob == null) {
      _showMessage('Date of birth is required');
      return;
    }
    if (!_isAtLeastMinimumAge(_dob!)) {
      _showMessage('You must be at least 18 years old to register as a donor');
      return;
    }

    await ref
        .read(donorProfileSetupControllerProvider.notifier)
        .submit(
          bloodGroup: _bloodGroup!,
          dob: _dob!,
          lastDonationDate: _lastDonationDate,
          location: _deviceLocation,
          city:
              _deviceLocation == null && _cityController.text.trim().isNotEmpty
              ? _cityController.text.trim()
              : null,
        );

    if (!mounted) return;
    final state = ref.read(donorProfileSetupControllerProvider);
    if (!state.hasError) {
      context.goNamed(AppRoute.homeName);
    }
  }

  Future<void> _skip() async {
    await ref.read(donorProfileSetupControllerProvider.notifier).skip();
    if (!mounted) return;
    final state = ref.read(donorProfileSetupControllerProvider);
    if (!state.hasError) {
      context.goNamed(AppRoute.homeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final controllerState = ref.watch(donorProfileSetupControllerProvider);

    ref.listen(donorProfileSetupControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        _showMessage(error.toString());
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Donor profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Blood group', style: textTheme.labelSmall),
                const SizedBox(height: 6),
                DropdownButtonFormField<BloodGroup>(
                  initialValue: _bloodGroup,
                  items: _bloodGroupLabels.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _bloodGroup = value),
                  validator: (value) =>
                      value == null ? 'Blood group is required' : null,
                ),
                const SizedBox(height: 16),
                _DateField(
                  label: 'Date of birth',
                  value: _dob,
                  onTap: _pickDob,
                ),
                const SizedBox(height: 16),
                _DateField(
                  label: 'Last donation date (optional)',
                  value: _lastDonationDate,
                  onTap: _pickLastDonationDate,
                  onClear: () => setState(() => _lastDonationDate = null),
                ),
                const SizedBox(height: 16),
                Text('City / location', style: textTheme.labelSmall),
                const SizedBox(height: 6),
                AppButton(
                  label: _locationStatus == _LocationStatus.granted
                      ? 'Location detected'
                      : 'Use my current location',
                  variant: AppButtonVariant.outline,
                  isLoading: _locationStatus == _LocationStatus.requesting,
                  onPressed: _requestLocation,
                ),
                if (_locationStatus == _LocationStatus.denied) ...[
                  const SizedBox(height: 8),
                  Text(
                    "Couldn't access your location — enter your city instead.",
                    style: textTheme.bodyMedium?.copyWith(color: colors.error),
                  ),
                ],
                const SizedBox(height: 12),
                AppInput(
                  label: 'City (used if location isn\'t available)',
                  controller: _cityController,
                  hintText: 'e.g. Pune',
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Save donor profile',
                  isLoading: controllerState.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Skip — I only want to request blood',
                  variant: AppButtonVariant.outline,
                  isLoading: controllerState.isLoading,
                  onPressed: _skip,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelSmall),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.input),
          child: Container(
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value == null ? 'Select date' : _formatDate(value!),
                    style: textTheme.bodyLarge?.copyWith(
                      color: value == null
                          ? colors.textSecondary
                          : colors.textPrimary,
                    ),
                  ),
                ),
                if (onClear != null && value != null)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: onClear,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                const SizedBox(width: 4),
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

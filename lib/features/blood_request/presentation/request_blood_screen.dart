import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/blood_request_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../application/request_blood_controller.dart';

const _defaultCameraTarget = LatLng(0, 0);
const _defaultCameraZoom = 2.0;
const _pinnedCameraZoom = 14.0;

const _minRequestUnits = 1;
// Real input to 2A-2's matching function — capped so a stray tap/paste can't
// feed an unbounded number into the ranking query.
const _maxRequestUnits = 20;

const _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

// Labels only — the value stored/sent per option is the enum itself, so
// serialization always goes through BloodRequestModel's @JsonValue
// annotations (2h/6h/24h/1w). Never re-derive the wire string from this map.
const _urgencyLabels = {
  UrgencyWindow.twoHours: 'Within 2 hours',
  UrgencyWindow.sixHours: 'Within 6 hours',
  UrgencyWindow.twentyFourHours: 'Within 24 hours',
  UrgencyWindow.oneWeek: 'Within a week',
};

class RequestBloodScreen extends ConsumerStatefulWidget {
  const RequestBloodScreen({super.key});

  @override
  ConsumerState<RequestBloodScreen> createState() => _RequestBloodScreenState();
}

class _RequestBloodScreenState extends ConsumerState<RequestBloodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _hospitalController = TextEditingController();

  String? _bloodGroup;
  int _units = _minRequestUnits;
  UrgencyWindow? _urgencyWindow;
  LatLng? _pinnedLocation;

  @override
  void dispose() {
    _patientNameController.dispose();
    _hospitalController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pinnedLocation == null) {
      _showMessage("Tap the map to set the hospital's location");
      return;
    }
    if (_urgencyWindow == null) {
      _showMessage('Urgency is required');
      return;
    }

    final requestId = await ref
        .read(requestBloodControllerProvider.notifier)
        .submit(
          patientName: _patientNameController.text.trim(),
          bloodGroup: _bloodGroup!,
          units: _units,
          hospital: _hospitalController.text.trim(),
          location: GeoPoint(
            _pinnedLocation!.latitude,
            _pinnedLocation!.longitude,
          ),
          urgencyWindow: _urgencyWindow!,
        );

    if (!mounted || requestId == null) return;
    context.goNamed(
      AppRoute.requestResultsName,
      pathParameters: {'requestId': requestId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controllerState = ref.watch(requestBloodControllerProvider);

    ref.listen(requestBloodControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        _showMessage(error.toString());
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Request blood')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppInput(
                  label: 'Patient name',
                  controller: _patientNameController,
                  hintText: "e.g. patient's full name",
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Patient name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                Text('Blood group', style: textTheme.labelSmall),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _bloodGroup,
                  items: _bloodGroups
                      .map(
                        (group) =>
                            DropdownMenuItem(value: group, child: Text(group)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _bloodGroup = value),
                  validator: (value) =>
                      value == null ? 'Blood group is required' : null,
                ),
                const SizedBox(height: 16),
                Text('Units needed', style: textTheme.labelSmall),
                const SizedBox(height: 6),
                _UnitsStepper(
                  value: _units,
                  min: _minRequestUnits,
                  max: _maxRequestUnits,
                  onChanged: (value) => setState(() => _units = value),
                ),
                const SizedBox(height: 16),
                Text('Urgency', style: textTheme.labelSmall),
                const SizedBox(height: 6),
                DropdownButtonFormField<UrgencyWindow>(
                  initialValue: _urgencyWindow,
                  items: _urgencyLabels.entries
                      .map(
                        (entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _urgencyWindow = value),
                  validator: (value) =>
                      value == null ? 'Urgency is required' : null,
                ),
                const SizedBox(height: 16),
                AppInput(
                  label: 'Hospital / location',
                  controller: _hospitalController,
                  hintText: 'Hospital name or address',
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Hospital / location is required'
                      : null,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the map to drop a pin at the hospital\'s location.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  child: SizedBox(
                    height: 240,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _pinnedLocation ?? _defaultCameraTarget,
                        zoom: _pinnedLocation != null
                            ? _pinnedCameraZoom
                            : _defaultCameraZoom,
                      ),
                      onTap: (position) =>
                          setState(() => _pinnedLocation = position),
                      markers: _pinnedLocation == null
                          ? const {}
                          : {
                              Marker(
                                markerId: const MarkerId('request-location'),
                                position: _pinnedLocation!,
                              ),
                            },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Submit request',
                  isLoading: controllerState.isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnitsStepper extends StatelessWidget {
  const _UnitsStepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.input),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: value > min ? () => onChanged(value - 1) : null,
          ),
          Expanded(
            child: Center(child: Text('$value', style: textTheme.bodyLarge)),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

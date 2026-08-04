import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/donation_camp_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../application/camp_form_controller.dart';
import '../application/manage_camps_controller.dart';

const _defaultCameraTarget = LatLng(0, 0);
const _defaultCameraZoom = 2.0;
const _pinnedCameraZoom = 14.0;

String _formatDateTime(DateTime date) {
  final datePart =
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
  final timePart =
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
  return '$datePart at $timePart';
}

class CampFormScreen extends ConsumerStatefulWidget {
  const CampFormScreen({super.key, this.campId});

  final String? campId;

  bool get isEditMode => campId != null;

  @override
  ConsumerState<CampFormScreen> createState() => _CampFormScreenState();
}

class _CampFormScreenState extends ConsumerState<CampFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _hostNameController = TextEditingController();

  LatLng? _pinnedLocation;
  DateTime? _date;
  String? _createdBy;
  bool _prefilled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _hostNameController.dispose();
    super.dispose();
  }

  void _prefillFrom(DonationCampModel camp) {
    _nameController.text = camp.name;
    _descriptionController.text = camp.description;
    _hostNameController.text = camp.hostName;
    _pinnedLocation = LatLng(camp.location.latitude, camp.location.longitude);
    _date = camp.date.toDate();
    _createdBy = camp.createdBy;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _date ?? now;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(now) ? now : initial,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate == null || !mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (pickedTime == null) return;
    setState(() {
      _date = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pinnedLocation == null) {
      _showMessage("Tap the map to set the camp's location");
      return;
    }
    if (_date == null) {
      _showMessage('Pick a date and time for the camp');
      return;
    }

    final firebaseUser = FirebaseAuth.instance.currentUser;
    final camp = DonationCampModel(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      location: GeoPoint(_pinnedLocation!.latitude, _pinnedLocation!.longitude),
      date: Timestamp.fromDate(_date!),
      hostName: _hostNameController.text.trim(),
      // createdBy is set once at creation and never overwritten; on edit,
      // carry forward the value loaded from the existing doc.
      createdBy: widget.isEditMode
          ? (_createdBy ?? '')
          : (firebaseUser?.uid ?? ''),
      // Overwritten by DonationCampRepository with the acting admin's
      // uid/server timestamp — these placeholders are never persisted as-is.
      updatedBy: '',
      updatedAt: Timestamp.now(),
    );

    final resultId = await ref
        .read(campFormControllerProvider.notifier)
        .submit(campId: widget.campId, camp: camp);

    if (!mounted || resultId == null) return;
    ref.invalidate(manageCampsControllerProvider);
    context.goNamed(AppRoute.adminCampsName);
  }

  Widget _buildForm(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formState = ref.watch(campFormControllerProvider);

    ref.listen(campFormControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        _showMessage(error.toString());
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit camp' : 'Add new camp'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppInput(
                  label: 'Name',
                  controller: _nameController,
                  hintText: 'e.g. City Community Blood Drive',
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                AppInput(
                  label: 'Description',
                  controller: _descriptionController,
                  hintText: 'What donors should expect at this camp',
                  maxLines: 4,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Description is required'
                      : null,
                ),
                const SizedBox(height: 16),
                AppInput(
                  label: 'Host name',
                  controller: _hostNameController,
                  hintText: 'e.g. City Blood Bank',
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Host name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                Text('Date & time', style: textTheme.labelSmall),
                const SizedBox(height: 6),
                OutlinedButton(
                  onPressed: _pickDate,
                  child: Text(
                    _date == null
                        ? 'Pick date & time'
                        : _formatDateTime(_date!),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Location', style: textTheme.labelSmall),
                const SizedBox(height: 6),
                Text(
                  'Tap the map to drop a pin at the camp\'s location.',
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
                                markerId: const MarkerId('camp-location'),
                                position: _pinnedLocation!,
                              ),
                            },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: widget.isEditMode ? 'Save changes' : 'Add camp',
                  isLoading: formState.isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditMode && !_prefilled) {
      final campAsync = ref.watch(campByIdProvider(widget.campId!));
      return campAsync.when(
        data: (camp) {
          if (camp == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Edit camp')),
              body: const Center(child: Text('Camp not found')),
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _prefilled) return;
            setState(() {
              _prefillFrom(camp);
              _prefilled = true;
            });
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, _) => Scaffold(
          appBar: AppBar(title: const Text('Edit camp')),
          body: Center(child: Text('Failed to load camp: $error')),
        ),
      );
    }

    return _buildForm(context);
  }
}

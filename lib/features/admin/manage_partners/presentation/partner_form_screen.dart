import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/partner_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../application/manage_partners_controller.dart';
import '../application/partner_form_controller.dart';

const _defaultCameraTarget = LatLng(0, 0);
const _defaultCameraZoom = 2.0;
const _pinnedCameraZoom = 14.0;

class PartnerFormScreen extends ConsumerStatefulWidget {
  const PartnerFormScreen({super.key, this.partnerId});

  final String? partnerId;

  bool get isEditMode => partnerId != null;

  @override
  ConsumerState<PartnerFormScreen> createState() => _PartnerFormScreenState();
}

class _PartnerFormScreenState extends ConsumerState<PartnerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  LatLng? _pinnedLocation;
  VerificationStatus _verificationStatus = VerificationStatus.pending;
  bool _prefilled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _prefillFrom(PartnerModel partner) {
    _nameController.text = partner.name;
    _addressController.text = partner.address;
    _phoneController.text = partner.phone;
    _pinnedLocation = LatLng(
      partner.location.latitude,
      partner.location.longitude,
    );
    _verificationStatus = partner.verificationStatus;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pinnedLocation == null) {
      _showMessage("Tap the map to set the partner's location");
      return;
    }

    final partner = PartnerModel(
      name: _nameController.text.trim(),
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim(),
      location: GeoPoint(_pinnedLocation!.latitude, _pinnedLocation!.longitude),
      verificationStatus: _verificationStatus,
      // Overwritten by PartnerRepository with the acting admin's uid/server
      // timestamp — these placeholders are never persisted as-is.
      updatedBy: '',
      updatedAt: Timestamp.now(),
    );

    final resultId = await ref
        .read(partnerFormControllerProvider.notifier)
        .submit(partnerId: widget.partnerId, partner: partner);

    if (!mounted || resultId == null) return;
    ref.invalidate(managePartnersControllerProvider);
    context.goNamed(AppRoute.adminPartnersName);
  }

  Widget _buildForm(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formState = ref.watch(partnerFormControllerProvider);

    ref.listen(partnerFormControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        _showMessage(error.toString());
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit partner' : 'Add new partner'),
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
                  hintText: 'e.g. City Blood Bank',
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                AppInput(
                  label: 'Address',
                  controller: _addressController,
                  hintText: 'Street, city',
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Address is required'
                      : null,
                ),
                const SizedBox(height: 16),
                AppInput(
                  label: 'Phone',
                  controller: _phoneController,
                  hintText: 'e.g. +91 98765 43210',
                  keyboardType: TextInputType.phone,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Phone is required'
                      : null,
                ),
                const SizedBox(height: 16),
                Text('Location', style: textTheme.labelSmall),
                const SizedBox(height: 6),
                Text(
                  'Tap the map to drop a pin at the partner\'s location.',
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
                                markerId: const MarkerId('partner-location'),
                                position: _pinnedLocation!,
                              ),
                            },
                    ),
                  ),
                ),
                if (widget.isEditMode) ...[
                  const SizedBox(height: 24),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Verified'),
                    subtitle: Text(
                      _verificationStatus == VerificationStatus.verified
                          ? 'This partner is verified and visible to consumers.'
                          : 'This partner is pending verification.',
                    ),
                    value: _verificationStatus == VerificationStatus.verified,
                    onChanged: (value) => setState(() {
                      _verificationStatus = value
                          ? VerificationStatus.verified
                          : VerificationStatus.pending;
                    }),
                  ),
                ],
                const SizedBox(height: 24),
                AppButton(
                  label: widget.isEditMode ? 'Save changes' : 'Add partner',
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
      final partnerAsync = ref.watch(partnerByIdProvider(widget.partnerId!));
      return partnerAsync.when(
        data: (partner) {
          if (partner == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Edit partner')),
              body: const Center(child: Text('Partner not found')),
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _prefilled) return;
            setState(() {
              _prefillFrom(partner);
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
          appBar: AppBar(title: const Text('Edit partner')),
          body: Center(child: Text('Failed to load partner: $error')),
        ),
      );
    }

    return _buildForm(context);
  }
}

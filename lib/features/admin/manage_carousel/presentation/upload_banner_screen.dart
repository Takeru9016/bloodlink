import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../application/manage_carousel_controller.dart';
import '../application/upload_banner_controller.dart';

class UploadBannerScreen extends ConsumerStatefulWidget {
  const UploadBannerScreen({super.key});

  @override
  ConsumerState<UploadBannerScreen> createState() => _UploadBannerScreenState();
}

class _UploadBannerScreenState extends ConsumerState<UploadBannerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayOrderController = TextEditingController(text: '0');

  File? _pickedImage;
  String? _linkedPartnerId;

  @override
  void dispose() {
    _displayOrderController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickSource() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() => _pickedImage = File(picked.path));
  }

  Future<void> _submit() async {
    final image = _pickedImage;
    if (image == null) {
      _showMessage('Pick an image first');
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final displayOrder = int.parse(_displayOrderController.text.trim());
    final success = await ref
        .read(uploadBannerControllerProvider.notifier)
        .submit(
          image: image,
          linkedPartnerId: _linkedPartnerId,
          displayOrder: displayOrder,
        );

    if (!mounted || !success) return;
    ref.invalidate(manageCarouselControllerProvider);
    context.goNamed(AppRoute.adminCarouselName);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final partnersAsync = ref.watch(partnersForBannerLinkProvider);
    final uploadState = ref.watch(uploadBannerControllerProvider);

    ref.listen(uploadBannerControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        _showMessage('Upload failed: $error');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Upload banner')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Image', style: textTheme.labelSmall),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickSource,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    child: _pickedImage == null
                        ? Container(
                            height: 160,
                            width: double.infinity,
                            color: colors.surfaceMuted,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 32,
                            ),
                          )
                        : Image.file(
                            _pickedImage!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Link to partner (optional)', style: textTheme.labelSmall),
                const SizedBox(height: 6),
                partnersAsync.when(
                  data: (partners) => DropdownButtonFormField<String>(
                    initialValue: _linkedPartnerId ?? '',
                    items: [
                      const DropdownMenuItem(value: '', child: Text('None')),
                      ...partners.map(
                        (record) => DropdownMenuItem(
                          value: record.id,
                          child: Text(record.partner.name),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() {
                      _linkedPartnerId = (value == null || value.isEmpty)
                          ? null
                          : value;
                    }),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Text('Failed to load partners: $error'),
                ),
                const SizedBox(height: 16),
                AppInput(
                  label: 'Display order',
                  controller: _displayOrderController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final parsed = int.tryParse(value?.trim() ?? '');
                    if (parsed == null || parsed < 0) {
                      return 'Enter a valid display order';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Upload banner',
                  isLoading: uploadState.isLoading,
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

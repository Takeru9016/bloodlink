import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../data/models/education_article_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../application/article_form_controller.dart';
import '../application/manage_education_hub_controller.dart';

String _categoryLabel(EducationArticleCategory category) {
  return switch (category) {
    EducationArticleCategory.basics => 'Basics',
    EducationArticleCategory.eligibility => 'Eligibility',
    EducationArticleCategory.guidance => 'Guidance',
    EducationArticleCategory.faq => 'FAQ',
  };
}

class ArticleFormScreen extends ConsumerStatefulWidget {
  const ArticleFormScreen({super.key, this.articleId});

  final String? articleId;

  bool get isEditMode => articleId != null;

  @override
  ConsumerState<ArticleFormScreen> createState() => _ArticleFormScreenState();
}

class _ArticleFormScreenState extends ConsumerState<ArticleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _displayOrderController = TextEditingController(text: '0');
  final _imagePicker = ImagePicker();

  EducationArticleCategory _category = EducationArticleCategory.basics;
  File? _pickedImage;
  String? _existingImageUrl;
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    // On Android, the picker's host Activity can be recreated while the
    // system photo picker is in front (low memory, or "Don't keep
    // activities"), which silently drops the in-flight pickImage() result
    // instead of returning it or throwing. retrieveLostData() recovers it
    // on the next launch — without this, the picker looks like a no-op.
    _recoverLostData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _displayOrderController.dispose();
    super.dispose();
  }

  void _prefillFrom(EducationArticleModel article) {
    _titleController.text = article.title;
    _bodyController.text = article.body;
    _displayOrderController.text = article.displayOrder.toString();
    _category = article.category;
    _existingImageUrl = article.imageUrl;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _recoverLostData() async {
    final response = await _imagePicker.retrieveLostData();
    if (response.isEmpty || !mounted) return;
    if (response.file != null) {
      setState(() => _pickedImage = File(response.file!.path));
    } else if (response.exception != null) {
      _showMessage('Image pick failed: ${response.exception!.code}');
    }
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
    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
    );
    if (picked == null) {
      await _recoverLostData();
      return;
    }
    setState(() => _pickedImage = File(picked.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final displayOrder = int.parse(_displayOrderController.text.trim());
    final article = EducationArticleModel(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      category: _category,
      displayOrder: displayOrder,
      imageUrl: _existingImageUrl,
      // Overwritten by ArticleFormController/EducationArticleRepository with
      // the acting admin's uid/server timestamp — never persisted as-is.
      updatedBy: '',
      updatedAt: Timestamp.now(),
    );

    final resultId = await ref
        .read(articleFormControllerProvider.notifier)
        .submit(
          articleId: widget.articleId,
          article: article,
          image: _pickedImage,
        );

    if (!mounted || resultId == null) return;
    ref.invalidate(manageEducationHubControllerProvider);
    context.goNamed(AppRoute.adminEducationName);
  }

  Widget _buildForm(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;
    final formState = ref.watch(articleFormControllerProvider);

    ref.listen(articleFormControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        _showMessage(error.toString());
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit article' : 'New article'),
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
                  label: 'Title',
                  controller: _titleController,
                  hintText: 'e.g. What is blood?',
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: 16),
                Text('Category', style: textTheme.labelSmall),
                const SizedBox(height: 6),
                DropdownButtonFormField<EducationArticleCategory>(
                  initialValue: _category,
                  items: EducationArticleCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(_categoryLabel(category)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _category = value);
                  },
                ),
                const SizedBox(height: 16),
                AppInput(
                  label: 'Body',
                  controller: _bodyController,
                  hintText: 'Plain-language article content',
                  maxLines: 8,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Body is required'
                      : null,
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
                const SizedBox(height: 16),
                Text('Image (optional)', style: textTheme.labelSmall),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickSource,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    child: _pickedImage != null
                        ? Image.file(
                            _pickedImage!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : _existingImageUrl != null
                        ? Image.network(
                            _existingImageUrl!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  height: 160,
                                  width: double.infinity,
                                  color: colors.surfaceMuted,
                                  child: const Icon(
                                    Icons.broken_image_outlined,
                                  ),
                                ),
                          )
                        : Container(
                            height: 160,
                            width: double.infinity,
                            color: colors.surfaceMuted,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 32,
                            ),
                          ),
                  ),
                ),
                if (_pickedImage != null || _existingImageUrl != null) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => setState(() {
                        _pickedImage = null;
                        _existingImageUrl = null;
                      }),
                      child: const Text('Remove image'),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                AppButton(
                  label: widget.isEditMode ? 'Save changes' : 'Publish article',
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
      final articleAsync = ref.watch(articleByIdProvider(widget.articleId!));
      return articleAsync.when(
        data: (article) {
          if (article == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Edit article')),
              body: const Center(child: Text('Article not found')),
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _prefilled) return;
            setState(() {
              _prefillFrom(article);
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
          appBar: AppBar(title: const Text('Edit article')),
          body: Center(child: Text('Failed to load article: $error')),
        ),
      );
    }

    return _buildForm(context);
  }
}

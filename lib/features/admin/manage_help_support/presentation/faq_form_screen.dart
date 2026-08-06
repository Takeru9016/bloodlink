import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../data/models/help_faq_model.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_input.dart';
import '../application/faq_form_controller.dart';
import '../application/manage_help_faqs_controller.dart';

class FaqFormScreen extends ConsumerStatefulWidget {
  const FaqFormScreen({super.key, this.faqId});

  final String? faqId;

  bool get isEditMode => faqId != null;

  @override
  ConsumerState<FaqFormScreen> createState() => _FaqFormScreenState();
}

class _FaqFormScreenState extends ConsumerState<FaqFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _displayOrderController = TextEditingController(text: '0');
  bool _prefilled = false;

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _displayOrderController.dispose();
    super.dispose();
  }

  void _prefillFrom(HelpFaqModel faq) {
    _questionController.text = faq.question;
    _answerController.text = faq.answer;
    _displayOrderController.text = faq.displayOrder.toString();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final displayOrder = int.parse(_displayOrderController.text.trim());
    final resultId = await ref
        .read(faqFormControllerProvider.notifier)
        .submit(
          faqId: widget.faqId,
          question: _questionController.text.trim(),
          answer: _answerController.text.trim(),
          displayOrder: displayOrder,
        );

    if (!mounted || resultId == null) return;
    ref.invalidate(manageHelpFaqsControllerProvider);
    context.goNamed(AppRoute.adminHelpSupportName);
  }

  Widget _buildForm(BuildContext context) {
    final formState = ref.watch(faqFormControllerProvider);

    ref.listen(faqFormControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        _showMessage(error.toString());
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(widget.isEditMode ? 'Edit FAQ' : 'New FAQ')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppInput(
                  label: 'Question',
                  controller: _questionController,
                  hintText: 'e.g. How does blood request matching work?',
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Question is required'
                      : null,
                ),
                const SizedBox(height: 16),
                AppInput(
                  label: 'Answer',
                  controller: _answerController,
                  hintText: 'Plain-language answer',
                  maxLines: 6,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Answer is required'
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
                const SizedBox(height: 24),
                AppButton(
                  label: widget.isEditMode ? 'Save changes' : 'Publish FAQ',
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
      final faqAsync = ref.watch(faqByIdProvider(widget.faqId!));
      return faqAsync.when(
        data: (faq) {
          if (faq == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Edit FAQ')),
              body: const Center(child: Text('FAQ not found')),
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted || _prefilled) return;
            setState(() {
              _prefillFrom(faq);
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
          appBar: AppBar(title: const Text('Edit FAQ')),
          body: Center(child: Text('Failed to load FAQ: $error')),
        ),
      );
    }

    return _buildForm(context);
  }
}

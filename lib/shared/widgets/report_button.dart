import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/report_model.dart';
import '../../data/repositories/report_repository.dart';
import 'app_button.dart';
import 'app_input.dart';

class ReportButton extends ConsumerWidget {
  const ReportButton({
    super.key,
    required this.targetType,
    required this.targetId,
  });

  final ReportTargetType targetType;
  final String targetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppButton(
      label: 'Report',
      variant: AppButtonVariant.outline,
      onPressed: () => showDialog<void>(
        context: context,
        builder: (_) =>
            _ReportDialog(targetType: targetType, targetId: targetId),
      ),
    );
  }
}

class _ReportDialog extends ConsumerStatefulWidget {
  const _ReportDialog({required this.targetType, required this.targetId});

  final ReportTargetType targetType;
  final String targetId;

  @override
  ConsumerState<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends ConsumerState<_ReportDialog> {
  final _reasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) return;

    final reporterId = FirebaseAuth.instance.currentUser?.uid;
    if (reporterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to report')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(reportRepositoryProvider)
          .createReport(reporterId, widget.targetType, widget.targetId, reason);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Report submitted')));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not submit report')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Report'),
      content: AppInput(
        label: 'Reason',
        controller: _reasonController,
        hintText: 'Describe the issue',
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Submit',
          isLoading: _isSubmitting,
          onPressed: _submit,
        ),
      ],
    );
  }
}

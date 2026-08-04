import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final textTheme = Theme.of(context).textTheme;

    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: BorderSide(color: color),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelSmall),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: colors.surface,
            constraints: const BoxConstraints(minHeight: 44),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: border(colors.border),
            enabledBorder: border(colors.border),
            focusedBorder: border(colors.brandRed),
            errorBorder: border(colors.error),
            focusedErrorBorder: border(colors.error),
            errorStyle: TextStyle(color: colors.error, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

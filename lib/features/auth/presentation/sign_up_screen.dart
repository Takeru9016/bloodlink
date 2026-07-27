import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../application/auth_controller.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToDonorProfileSetupIfSucceeded() {
    if (!mounted) return;
    final state = ref.read(authControllerProvider);
    if (!state.hasError) {
      context.goNamed(AppRoute.donorProfileSetupName);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authControllerProvider.notifier)
        .signUp(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    _goToDonorProfileSetupIfSucceeded();
  }

  Future<void> _continueWithGoogle() async {
    await ref.read(authControllerProvider.notifier).signInWithGoogle();
    _goToDonorProfileSetupIfSucceeded();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Email is required';
    if (!_emailPattern.hasMatch(trimmed)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && !next.isLoading) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_errorMessage(error))));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppInput(
                  label: 'Full name',
                  controller: _nameController,
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                AppInput(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),
                AppInput(
                  label: 'Password',
                  controller: _passwordController,
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Sign up',
                  isLoading: authState.isLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Continue with Google',
                  variant: AppButtonVariant.outline,
                  isLoading: authState.isLoading,
                  onPressed: _continueWithGoogle,
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => context.goNamed(AppRoute.signInName),
                    child: const Text('Already have an account? Sign in'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _errorMessage(Object error) {
  if (error is FirebaseAuthException) return error.message ?? error.code;
  return error.toString();
}

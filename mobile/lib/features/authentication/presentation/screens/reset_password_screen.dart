import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/utils/validators.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

/// UI_UX_SPECIFICATION.md Part F.4 / SRS SCR-04. Reachable only via the
/// deep-linked reset email — see AppServiceProvider (backend) for the URL.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, required this.token, required this.email});

  final String token;
  final String email;

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Les mots de passe ne correspondent pas.')));
      return;
    }

    setState(() => _isSubmitting = true);
    final state = await ref
        .read(authControllerProvider.notifier)
        .resetPassword(token: widget.token, email: widget.email, password: _passwordController.text);
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    state.whenOrNull(
      unauthenticated: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Mot de passe réinitialisé.')));
        context.go(RoutePaths.login);
      },
      error: (failure) =>
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Réinitialiser le mot de passe')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.marginMobile),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Nouveau mot de passe'),
                    validator: validatePassword,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _confirmController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
                    validator: (value) => (value == null || value.isEmpty) ? 'Champ requis' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Réinitialiser'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/user_entity.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

/// UI_UX_SPECIFICATION.md Part F.3 / SRS SCR-02, FR-AUTH-01..08.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole? _selectedRole;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedRole == null || !(_formKey.currentState?.validate() ?? false)) return;

    await ref
        .read(authControllerProvider.notifier)
        .login(email: _emailController.text.trim(), password: _passwordController.text, role: _selectedRole!);

    if (!mounted) return;

    final state = ref.read(authControllerProvider);
    state.whenOrNull(
      authenticated: (user) => context.go(_dashboardFor(user.role)),
      error: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
      },
    );
  }

  String _dashboardFor(UserRole role) => switch (role) {
    UserRole.client => RoutePaths.clientHome,
    UserRole.technicien => RoutePaths.technicianMissions,
    UserRole.admin => RoutePaths.supervisorDashboard,
  };

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.maybeWhen(loading: () => true, orElse: () => false);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    const Icon(Icons.security, size: 56, color: AppColors.primary),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'MSIS',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // SRS FR-AUTH-03: trust banner.
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusStandard),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.lock, size: 16, color: AppColors.success),
                          SizedBox(width: AppSpacing.xs),
                          Flexible(
                            child: Text(
                              'Connecté et sécurisé — Chiffrement SSL 256-bit',
                              style: TextStyle(fontSize: 12, color: AppColors.success),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // SRS FR-AUTH-01: role selector.
                    SegmentedButton<UserRole>(
                      segments: const [
                        ButtonSegment(
                          value: UserRole.client,
                          label: Text('Client'),
                          icon: Icon(Icons.person),
                        ),
                        ButtonSegment(
                          value: UserRole.technicien,
                          label: Text('Technicien'),
                          icon: Icon(Icons.build),
                        ),
                        ButtonSegment(
                          value: UserRole.admin,
                          label: Text('Superviseur'),
                          icon: Icon(Icons.bar_chart),
                        ),
                      ],
                      selected: _selectedRole == null ? {} : {_selectedRole!},
                      emptySelectionAllowed: true,
                      onSelectionChanged: (selection) {
                        setState(() => _selectedRole = selection.isEmpty ? null : selection.first);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Champ requis';
                        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                          return 'Email invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? 'Champ requis' : null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push(RoutePaths.forgotPassword),
                        child: const Text('Mot de passe oublié ?'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    FilledButton(
                      onPressed: isLoading || _selectedRole == null ? null : _submit,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Se connecter'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () => context.push(RoutePaths.register),
                        child: const Text("Pas encore de compte ? S'inscrire"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

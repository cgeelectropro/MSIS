import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/user_entity.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

/// SRS SCR-12 — reachable from every role's home AppBar. Was previously a
/// route constant (RoutePaths.profile) with no screen and no route entry.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  String _roleLabel(UserRole role) => switch (role) {
    UserRole.admin => 'Superviseur / Administrateur',
    UserRole.technicien => 'Technicien',
    UserRole.client => 'Client',
  };

  Future<void> _confirmAndLogout(BuildContext context, WidgetRef ref, {required bool allDevices}) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              allDevices ? 'Se déconnecter de tous les appareils ?' : 'Se déconnecter ?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Confirmer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final notifier = ref.read(authControllerProvider.notifier);
    if (allDevices) {
      await notifier.logoutAllDevices();
    } else {
      await notifier.logout();
    }
    if (context.mounted) context.go(RoutePaths.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.maybeWhen(authenticated: (u) => u, orElse: () => null);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              children: [
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Theme.of(context).colorScheme.primary, AppColors.primaryContainer],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      user.nom.isNotEmpty ? user.nom[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: Text(user.nom, style: Theme.of(context).textTheme.titleLarge),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Text(
                      _roleLabel(user.role),
                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Card(
                  child: Column(
                    children: [
                      ListTile(leading: const Icon(Icons.email_outlined), title: const Text('Email'), subtitle: Text(user.email)),
                      if (user.telephone != null && user.telephone!.isNotEmpty) ...[
                        const Divider(height: 1, indent: AppSpacing.md, endIndent: AppSpacing.md),
                        ListTile(
                          leading: const Icon(Icons.phone_outlined),
                          title: const Text('Téléphone'),
                          subtitle: Text(user.telephone!),
                        ),
                      ],
                      const Divider(height: 1, indent: AppSpacing.md, endIndent: AppSpacing.md),
                      ListTile(
                        leading: Icon(
                          user.actif ? Icons.check_circle_outline : Icons.block_outlined,
                          color: user.actif ? AppColors.success : AppColors.danger,
                        ),
                        title: const Text('Statut du compte'),
                        subtitle: Text(user.actif ? 'Actif' : 'Désactivé'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                OutlinedButton.icon(
                  onPressed: () => _confirmAndLogout(context, ref, allDevices: false),
                  icon: const Icon(Icons.logout),
                  label: const Text('Se déconnecter'),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                  ),
                  onPressed: () => _confirmAndLogout(context, ref, allDevices: true),
                  icon: const Icon(Icons.logout),
                  label: const Text('Se déconnecter de tous les appareils'),
                ),
              ],
            ),
    );
  }
}

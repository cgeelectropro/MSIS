import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/intervention_card.dart';
import '../../../../shared/widgets/notification_bell_action.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../../authentication/presentation/controllers/auth_controller.dart';
import '../../../interventions/presentation/controllers/interventions_controller.dart';
import '../../../interventions/presentation/controllers/interventions_state.dart';
import '../../../interventions/presentation/screens/intervention_detail_screen.dart';
import '../../../reports/presentation/screens/reports_tab.dart';
import '../../../users/presentation/controllers/users_controller.dart';
import '../../../users/presentation/controllers/users_state.dart';

/// SRS SCR-09/SCR-10/SCR-11: Supervisor dashboard — Interventions, Utilisateurs,
/// and Rapports tabs.
class SupervisorDashboardScreen extends ConsumerStatefulWidget {
  const SupervisorDashboardScreen({super.key});

  @override
  ConsumerState<SupervisorDashboardScreen> createState() => _SupervisorDashboardScreenState();
}

class _SupervisorDashboardScreenState extends ConsumerState<SupervisorDashboardScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(interventionsControllerProvider.notifier).load();
      ref.read(usersControllerProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          const NotificationBellAction(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) context.go(RoutePaths.login);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Interventions'), Tab(text: 'Utilisateurs'), Tab(text: 'Rapports')],
        ),
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [_InterventionsTab(), _UsersTab(), ReportsTab()],
            ),
          ),
        ],
      ),
    );
  }
}

class _InterventionsTab extends ConsumerWidget {
  const _InterventionsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(interventionsControllerProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(interventionsControllerProvider.notifier).load(),
      child: state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (failure) => Center(child: Text(failure.message)),
        loaded: (items) => items.isEmpty
            ? ListView(children: const [SizedBox(height: 120), Center(child: Text('Aucune intervention'))])
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InterventionCard(
                    intervention: item,
                    subtitle: item.client != null ? 'Client : ${item.client!.nom}' : null,
                    onTap: () async {
                      await Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => InterventionDetailScreen(interventionId: item.id)));
                      ref.read(interventionsControllerProvider.notifier).load();
                    },
                  );
                },
              ),
      ),
    );
  }
}

class _UsersTab extends ConsumerWidget {
  const _UsersTab();

  Future<void> _createTechnician(BuildContext context, WidgetRef ref) async {
    final nomController = TextEditingController();
    final emailController = TextEditingController();

    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.marginMobile,
          right: AppSpacing.marginMobile,
          top: AppSpacing.marginMobile,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.marginMobile,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Nouveau compte technicien', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            TextField(controller: nomController, decoration: const InputDecoration(labelText: 'Nom')),
            const SizedBox(height: AppSpacing.sm),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () async {
                final success = await ref
                    .read(usersControllerProvider.notifier)
                    .createTechnician(nom: nomController.text.trim(), email: emailController.text.trim());
                if (context.mounted) Navigator.pop(context, success);
              },
              child: const Text('Créer'),
            ),
          ],
        ),
      ),
    );

    if (created == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compte créé, invitation envoyée.')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(usersControllerProvider);

    return Scaffold(
      body: state.when(
        initial: () => const SizedBox.shrink(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (failure) => Center(child: Text(failure.message)),
        loaded: (users) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text(user.nom.isNotEmpty ? user.nom[0].toUpperCase() : '?')),
                title: Text(user.nom),
                subtitle: Text('${user.email} · ${user.role == UserRole.technicien ? "Technicien" : "Client"}'),
                trailing: Switch(
                  value: user.actif,
                  onChanged: (value) async {
                    final confirmed = value
                        ? true
                        : await showModalBottomSheet<bool>(
                                context: context,
                                builder: (context) => Padding(
                                  padding: const EdgeInsets.all(AppSpacing.marginMobile),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const Text('Désactiver ce compte ?'),
                                      const SizedBox(height: AppSpacing.sm),
                                      const Text(
                                        'Ses interventions en attente non commencées seront libérées pour réaffectation.',
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                      FilledButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: const Text('Confirmer'),
                                      ),
                                    ],
                                  ),
                                ),
                              ) ??
                              false;

                    if (confirmed) {
                      await ref.read(usersControllerProvider.notifier).updateStatus(userId: user.id, actif: value);
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createTechnician(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }
}

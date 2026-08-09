import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../shared/widgets/empty_state_view.dart';
import '../../../../shared/widgets/intervention_card.dart';
import '../../../../shared/widgets/notification_bell_action.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../../shared/widgets/status_filter_chips.dart';
import '../../../authentication/presentation/controllers/auth_controller.dart';
import '../../../interventions/domain/entities/intervention_entity.dart';
import '../../../interventions/presentation/controllers/interventions_controller.dart';
import '../../../interventions/presentation/controllers/interventions_state.dart';
import '../../../interventions/presentation/screens/create_intervention_screen.dart';
import '../../../interventions/presentation/screens/intervention_detail_screen.dart';

/// SRS SCR-05: Client's own tickets (FR-TRV-01 — server scopes to `id_client`).
class ClientHomeScreen extends ConsumerStatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  ConsumerState<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends ConsumerState<ClientHomeScreen> {
  InterventionStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(interventionsControllerProvider.notifier).load(),
    );
  }

  void _onFilterChanged(InterventionStatus? status) {
    setState(() => _statusFilter = status);
    ref.read(interventionsControllerProvider.notifier).load(status: status);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(interventionsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes interventions'),
        actions: [
          const NotificationBellAction(),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profil',
            onPressed: () => context.push(RoutePaths.profile),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) context.go(RoutePaths.login);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          const SizedBox(height: 8),
          StatusFilterChips(
            selected: _statusFilter,
            onSelected: _onFilterChanged,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref
                  .read(interventionsControllerProvider.notifier)
                  .load(status: _statusFilter),
              child: state.when(
                initial: () => const SizedBox.shrink(),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (failure) => Center(child: Text(failure.message)),
                loaded: (items) => items.isEmpty
                    ? ListView(
                        children: [
                          EmptyStateView(
                            icon: Icons.build_circle_outlined,
                            title: 'Aucune intervention',
                            subtitle: 'Créez votre première demande d\'intervention.',
                            actionLabel: 'Nouvelle demande',
                            onAction: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const CreateInterventionScreen()),
                              );
                              ref.read(interventionsControllerProvider.notifier).load(status: _statusFilter);
                            },
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return InterventionCard(
                            intervention: item,
                            subtitle: item.technicien != null
                                ? 'Technicien : ${item.technicien!.nom}'
                                : null,
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => InterventionDetailScreen(
                                    interventionId: item.id,
                                  ),
                                ),
                              );
                              ref
                                  .read(
                                    interventionsControllerProvider.notifier,
                                  )
                                  .load(status: _statusFilter);
                            },
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateInterventionScreen()),
          );
          ref
              .read(interventionsControllerProvider.notifier)
              .load(status: _statusFilter);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

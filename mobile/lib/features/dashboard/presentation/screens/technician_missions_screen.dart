import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../shared/widgets/intervention_card.dart';
import '../../../../shared/widgets/notification_bell_action.dart';
import '../../../../shared/widgets/offline_banner.dart';
import '../../../authentication/presentation/controllers/auth_controller.dart';
import '../../../interventions/presentation/controllers/interventions_controller.dart';
import '../../../interventions/presentation/controllers/interventions_state.dart';
import '../../../interventions/presentation/screens/intervention_detail_screen.dart';

/// SRS SCR-07: Technician's assigned missions (FR-TECH-01/02 — server scopes
/// to `id_technicien`, BRULE-001).
class TechnicianMissionsScreen extends ConsumerStatefulWidget {
  const TechnicianMissionsScreen({super.key});

  @override
  ConsumerState<TechnicianMissionsScreen> createState() => _TechnicianMissionsScreenState();
}

class _TechnicianMissionsScreenState extends ConsumerState<TechnicianMissionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(interventionsControllerProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(interventionsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes missions'),
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
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(interventionsControllerProvider.notifier).load(),
              child: state.when(
                initial: () => const SizedBox.shrink(),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (failure) => Center(child: Text(failure.message)),
                loaded: (items) => items.isEmpty
                    ? ListView(children: const [SizedBox(height: 120), Center(child: Text('Aucune mission assignée'))])
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return InterventionCard(
                            intervention: item,
                            subtitle: item.client != null ? 'Client : ${item.client!.nom}' : null,
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => InterventionDetailScreen(interventionId: item.id)),
                              );
                              ref.read(interventionsControllerProvider.notifier).load();
                            },
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

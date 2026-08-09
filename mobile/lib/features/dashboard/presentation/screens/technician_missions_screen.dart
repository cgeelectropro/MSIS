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
import '../../../interventions/presentation/screens/intervention_detail_screen.dart';
import '../../../messages/presentation/screens/conversations_list_tab.dart';

/// SRS SCR-07 (FR-TECH-01/02, server-scoped to `id_technicien`, BRULE-001)
/// + SCR-12 nav map (FR-TECH-03, Must-have): bottom nav across
/// Missions/Messages/Profile — previously there was no bottom navigation
/// anywhere in the app and no standalone way to reach a conversation without
/// first opening a specific ticket.
class TechnicianMissionsScreen extends ConsumerStatefulWidget {
  const TechnicianMissionsScreen({super.key});

  @override
  ConsumerState<TechnicianMissionsScreen> createState() => _TechnicianMissionsScreenState();
}

class _TechnicianMissionsScreenState extends ConsumerState<TechnicianMissionsScreen> {
  InterventionStatus? _statusFilter;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(interventionsControllerProvider.notifier).load());
  }

  void _onFilterChanged(InterventionStatus? status) {
    setState(() => _statusFilter = status);
    ref.read(interventionsControllerProvider.notifier).load(status: status);
  }

  void _onDestinationSelected(int index) {
    // Profile isn't an embedded tab body (it's the same pushed screen every
    // other role reaches via an AppBar action) — keep the nav bar's
    // highlighted index on the tab actually showing.
    if (index == 2) {
      context.push(RoutePaths.profile);
      return;
    }
    setState(() => _tabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(interventionsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_tabIndex == 0 ? 'Mes missions' : 'Messages'),
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
      body: _tabIndex == 0
          ? Column(
              children: [
                const OfflineBanner(),
                const SizedBox(height: 8),
                StatusFilterChips(selected: _statusFilter, onSelected: _onFilterChanged),
                const SizedBox(height: 8),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => ref.read(interventionsControllerProvider.notifier).load(status: _statusFilter),
                    child: state.when(
                      initial: () => const SizedBox.shrink(),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (failure) => Center(child: Text(failure.message)),
                      loaded: (items) => items.isEmpty
                          ? ListView(
                              children: const [
                                EmptyStateView(
                                  icon: Icons.assignment_turned_in_outlined,
                                  title: 'Aucune mission assignée',
                                  subtitle: 'Vos prochaines interventions apparaîtront ici.',
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
                                  subtitle: item.client != null ? 'Client : ${item.client!.nom}' : null,
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => InterventionDetailScreen(interventionId: item.id),
                                      ),
                                    );
                                    ref.read(interventionsControllerProvider.notifier).load(status: _statusFilter);
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ),
              ],
            )
          : const ConversationsListTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.assignment_outlined), selectedIcon: Icon(Icons.assignment), label: 'Missions'),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

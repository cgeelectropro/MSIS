import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/empty_state_view.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../interventions/domain/entities/intervention_entity.dart';
import '../../../interventions/presentation/controllers/interventions_controller.dart';
import '../../../interventions/presentation/controllers/interventions_state.dart';
import 'conversation_screen.dart';

/// SRS §12.3 (Must-have, FR-TECH-03): a standalone Messages entry point —
/// previously conversations were only reachable by drilling into a specific
/// ticket's detail screen first. Messaging in this app is scoped per
/// intervention (no cross-ticket unified inbox on the backend), so this is
/// the technician's own ticket list re-rendered as conversation entries
/// rather than a new backend concept.
class ConversationsListTab extends ConsumerWidget {
  const ConversationsListTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(interventionsControllerProvider);

    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (failure) => Center(child: Text(failure.message)),
      loaded: (items) => items.isEmpty
          ? const EmptyStateView(
              icon: Icons.chat_bubble_outline,
              title: 'Aucune conversation',
              subtitle: 'Les échanges liés à vos interventions apparaîtront ici.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.marginMobile),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final closed =
                    item.statut == InterventionStatus.cloturee || item.statut == InterventionStatus.annulee;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(Icons.chat_bubble_outline, size: 20),
                      ),
                      title: Text(item.titre, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            StatusBadge(status: item.statut),
                            const SizedBox(width: AppSpacing.xs),
                            if (item.client != null)
                              Expanded(child: Text(item.client!.nom, overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ConversationScreen(interventionId: item.id, isClosed: closed),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

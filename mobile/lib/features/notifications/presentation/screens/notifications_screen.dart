import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/empty_state_view.dart';
import '../../../interventions/presentation/screens/intervention_detail_screen.dart';
import '../../domain/entities/notification_entity.dart';
import '../controllers/notifications_controller.dart';
import '../controllers/notifications_state.dart';

/// UI_UX_SPECIFICATION.md Part F.9 / SRS SCR-14.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(notificationsControllerProvider.notifier).load());
  }

  void _openNotification(NotificationEntity notification) {
    ref.read(notificationsControllerProvider.notifier).markRead(notification.id);
    if (notification.idIntervention != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => InterventionDetailScreen(interventionId: notification.idIntervention!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => ref.read(notificationsControllerProvider.notifier).markAllRead(),
            child: const Text('Tout marquer lu'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(notificationsControllerProvider.notifier).load(),
        child: switch (state) {
          NotificationsInitial() || NotificationsLoading() => const Center(child: CircularProgressIndicator()),
          NotificationsError(:final failure) => Center(child: Text(failure.message)),
          NotificationsLoaded(:final items) => items.isEmpty
              ? ListView(
                  children: const [
                    EmptyStateView(
                      icon: Icons.notifications_none_rounded,
                      title: 'Aucune notification',
                      subtitle: 'Vous serez averti ici des mises à jour importantes.',
                    ),
                  ],
                )
              : _buildGroupedList(items),
        },
      ),
    );
  }

  Widget _buildGroupedList(List<NotificationEntity> items) {
    final groups = _groupByDate(items);

    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xs),
              child: Text(
                group.label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            for (final n in group.items)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: n.lu ? null : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusStandard),
                ),
                child: ListTile(
                  leading: Icon(
                    n.lu ? Icons.circle_outlined : Icons.circle,
                    size: 10,
                    color: n.lu ? Theme.of(context).colorScheme.onSurfaceVariant : Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    n.contenu,
                    style: TextStyle(fontWeight: n.lu ? FontWeight.normal : FontWeight.w700),
                  ),
                  subtitle: Text('${n.createdAt.hour.toString().padLeft(2, '0')}:${n.createdAt.minute.toString().padLeft(2, '0')}'),
                  onTap: () => _openNotification(n),
                ),
              ),
          ],
        );
      },
    );
  }

  List<_NotificationGroup> _groupByDate(List<NotificationEntity> items) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final groups = <String, List<NotificationEntity>>{};
    for (final item in items) {
      final date = DateTime(item.createdAt.year, item.createdAt.month, item.createdAt.day);
      final label = date == today ? "Aujourd'hui" : (date == yesterday ? 'Hier' : 'Plus ancien');
      groups.putIfAbsent(label, () => []).add(item);
    }

    return [
      for (final label in ["Aujourd'hui", 'Hier', 'Plus ancien'])
        if (groups[label] != null) _NotificationGroup(label, groups[label]!),
    ];
  }
}

class _NotificationGroup {
  _NotificationGroup(this.label, this.items);
  final String label;
  final List<NotificationEntity> items;
}

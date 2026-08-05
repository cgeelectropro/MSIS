import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../features/notifications/presentation/controllers/notifications_controller.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';

/// UI_UX_SPECIFICATION.md Part B.11: "AppBar ... notifications-bell icon with
/// unread-count badge on the right", present on every authenticated screen —
/// one shared widget so SCR-05/07/09 (and any future screen) wire it
/// identically instead of re-implementing the badge each time.
class NotificationBellAction extends ConsumerStatefulWidget {
  const NotificationBellAction({super.key});

  @override
  ConsumerState<NotificationBellAction> createState() => _NotificationBellActionState();
}

class _NotificationBellActionState extends ConsumerState<NotificationBellAction> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(notificationsControllerProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(notificationsControllerProvider); // rebuild on load()/markRead() changes
    final unread = ref.read(notificationsControllerProvider.notifier).unreadCount;

    return IconButton(
      tooltip: 'Notifications',
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationsScreen())),
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text('$unread'),
        backgroundColor: AppColors.danger,
        child: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}

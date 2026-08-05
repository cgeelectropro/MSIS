import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/interventions/presentation/screens/intervention_detail_screen.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'MSIS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system, // SRS FR-PROF-06: manual override lands with Settings (SCR-13).
      routerConfig: router,
    );
  }
}

/// SRS FR-NOTIF-02: a push-notification tap deep-links straight to the
/// relevant ticket. Intervention detail is reached via `Navigator.push`
/// everywhere else in this app (not a GoRouter route, see
/// intervention_detail_screen.dart's existing call sites), so this uses the
/// same root navigator key GoRouter itself is configured with (app_router.dart)
/// to reach it from PushNotificationService's tap callback, which is
/// registered in main.dart before any BuildContext exists.
void openInterventionFromNotification(String interventionId) {
  final id = int.tryParse(interventionId);
  if (id == null) return;

  rootNavigatorKey.currentState?.push(
    MaterialPageRoute(builder: (_) => InterventionDetailScreen(interventionId: id)),
  );
}

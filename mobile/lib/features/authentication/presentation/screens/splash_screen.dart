import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../app/theme/app_colors.dart';
import '../../domain/entities/user_entity.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

/// UI_UX_SPECIFICATION.md Part F.1 / SRS SCR-01.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    await ref.read(authControllerProvider.notifier).restoreSession();
    if (!mounted) return;

    final state = ref.read(authControllerProvider);
    state.when(
      initial: () => context.go(RoutePaths.login),
      loading: () => context.go(RoutePaths.login),
      unauthenticated: () => context.go(RoutePaths.login),
      error: (_) => context.go(RoutePaths.login),
      authenticated: (user) => context.go(_dashboardFor(user.role)),
    );
  }

  String _dashboardFor(UserRole role) => switch (role) {
    UserRole.client => RoutePaths.clientHome,
    UserRole.technicien => RoutePaths.technicianMissions,
    UserRole.admin => RoutePaths.supervisorDashboard,
  };

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Text(
          'MSIS',
          style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

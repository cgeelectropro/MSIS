import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../shared/widgets/app_logo_mark.dart';
import '../../../../shared/widgets/brand_gradient_background.dart';
import '../../domain/entities/user_entity.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

/// UI_UX_SPECIFICATION.md Part F.1 / SRS SCR-01.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();
  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  late final Animation<double> _scale = Tween(begin: 0.9, end: 1.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    return Scaffold(
      body: BrandGradientBackground(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLogoMark(size: 96, onGradient: true),
                  const SizedBox(height: 24),
                  Text(
                    'MSIS',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Interventions techniques sécurisées',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.75)),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(Colors.white.withValues(alpha: 0.8)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

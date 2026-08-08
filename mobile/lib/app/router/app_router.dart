import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injector.dart';
import '../../core/storage/auth_session_store.dart';
import '../../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/profile_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/reset_password_screen.dart';
import '../../features/authentication/presentation/screens/splash_screen.dart';
import '../../features/dashboard/presentation/screens/client_home_screen.dart';
import '../../features/dashboard/presentation/screens/supervisor_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/technician_missions_screen.dart';
import 'route_paths.dart';

/// SRS FR-NOTIF-02: shared with `app/app.dart`'s notification-tap deep-link
/// handler, which has no BuildContext of its own (registered from main.dart).
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Implementation Plan §10: a single top-level router with one `redirect`
/// callback, evaluated on every navigation event (SRS §16.4) — not only at
/// login. Listens to [AuthSessionStore] (a plain ChangeNotifier in `core`,
/// not Riverpod) so a session invalidated by the RefreshInterceptor
/// (SRS BRULE-013 deactivation, or an unrecoverable 401) forces an
/// immediate redirect without any feature-level wiring.
final appRouterProvider = Provider<GoRouter>((ref) {
  final sessionStore = getIt<AuthSessionStore>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    refreshListenable: sessionStore,
    redirect: (context, state) {
      final isAuthRoute = {
        RoutePaths.login,
        RoutePaths.register,
        RoutePaths.forgotPassword,
      }.contains(state.matchedLocation);
      final isResetRoute = state.matchedLocation == RoutePaths.resetPassword;
      final isSplash = state.matchedLocation == RoutePaths.splash;

      if (!sessionStore.isAuthenticated && !isAuthRoute && !isResetRoute && !isSplash) {
        return RoutePaths.login;
      }

      // The server re-verifies role on every request regardless (CLAUDE.md's
      // stated model), but a deep link or stale notification tap could still
      // land an authenticated user on a route meant for a different role
      // with no UI affordance ever pointing them there otherwise — this
      // keeps the client-side experience coherent, matching the other roles.
      if (sessionStore.isAuthenticated) {
        final homeForRole = switch (sessionStore.role) {
          'CLIENT' => RoutePaths.clientHome,
          'TECHNICIEN' => RoutePaths.technicianMissions,
          'ADMIN' => RoutePaths.supervisorDashboard,
          _ => null,
        };
        const roleHomes = {RoutePaths.clientHome, RoutePaths.technicianMissions, RoutePaths.supervisorDashboard};
        if (homeForRole != null &&
            roleHomes.contains(state.matchedLocation) &&
            state.matchedLocation != homeForRole) {
          return homeForRole;
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: RoutePaths.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: RoutePaths.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: RoutePaths.register, builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: RoutePaths.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RoutePaths.resetPassword,
        builder: (context, state) => ResetPasswordScreen(
          token: state.uri.queryParameters['token'] ?? '',
          email: state.uri.queryParameters['email'] ?? '',
        ),
      ),
      GoRoute(path: RoutePaths.clientHome, builder: (context, state) => const ClientHomeScreen()),
      GoRoute(
        path: RoutePaths.technicianMissions,
        builder: (context, state) => const TechnicianMissionsScreen(),
      ),
      GoRoute(
        path: RoutePaths.supervisorDashboard,
        builder: (context, state) => const SupervisorDashboardScreen(),
      ),
      GoRoute(path: RoutePaths.profile, builder: (context, state) => const ProfileScreen()),
    ],
    debugLogDiagnostics: kDebugMode,
  );
});

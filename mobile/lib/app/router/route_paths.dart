/// SRS §15/§16.4 — typed route path constants, matching the SCR-## screen IDs.
class RoutePaths {
  RoutePaths._();

  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';

  static const clientHome = '/client'; // SCR-05
  static const technicianMissions = '/technician'; // SCR-07
  static const supervisorDashboard = '/supervisor'; // SCR-09

  static const profile = '/profile'; // SCR-12
}

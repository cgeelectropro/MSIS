/// SRS §18.5 Data Access Contract — every route string lives here so the
/// endpoint surface stays auditable against the SRS in one file (Plan §11).
class ApiEndpoints {
  ApiEndpoints._();

  static const login = '/auth/login';
  static const register = '/auth/register';
  static const logout = '/auth/logout';
  static const logoutAll = '/auth/logout-all';
  static const refresh = '/auth/refresh';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';
  static const me = '/auth/me';

  static const profile = '/profile';
  static const profilePassword = '/profile/password';

  static const interventions = '/interventions';
  static String intervention(int id) => '/interventions/$id';
  static String interventionStatus(int id) => '/interventions/$id/statut';
  static String interventionAssign(int id) => '/interventions/$id/assigner';
  static String interventionClose(int id) => '/interventions/$id/cloturer';
  static String interventionCancel(int id) => '/interventions/$id/annuler';
  static String interventionAttachments(int id) => '/interventions/$id/pieces-jointes';
  static String interventionMessages(int id) => '/interventions/$id/messages';
  static String messageSeen(int id) => '/messages/$id/seen';
  static const messagesUnread = '/messages/unread';
  static const broadcastingAuth = '/broadcasting/auth';

  static const users = '/users';
  static String userStatus(int id) => '/users/$id/statut';

  static const notifications = '/notifications';
  static String notificationRead(int id) => '/notifications/$id/lu';
  static const notificationsReadAll = '/notifications/read-all';

  static const deviceRegister = '/device/register';
  static const deviceUnregister = '/device/unregister';

  static const reportsDashboard = '/reports/dashboard';
  static const reportsExport = '/reports/export';

  static const health = '/health';
}

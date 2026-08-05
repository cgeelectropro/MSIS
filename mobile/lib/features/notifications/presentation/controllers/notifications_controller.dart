import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injector.dart';
import '../../../../shared/models/result.dart';
import '../../domain/repositories/notification_repository.dart';
import 'notifications_state.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => getIt<NotificationRepository>(),
);

final notificationsControllerProvider = StateNotifierProvider<NotificationsController, NotificationsState>(
  (ref) => NotificationsController(ref.watch(notificationRepositoryProvider)),
);

/// SRS SCR-14. Also exposes [unreadCount] for the app bar bell badge
/// (present on every authenticated screen per SRS §16.4/UI_UX_SPECIFICATION.md B.11).
class NotificationsController extends StateNotifier<NotificationsState> {
  NotificationsController(this._repository) : super(const NotificationsState.initial());

  final NotificationRepository _repository;

  int get unreadCount => state.maybeWhen(
    loaded: (items) => items.where((n) => !n.lu).length,
    orElse: () => 0,
  );

  Future<void> load() async {
    state = const NotificationsState.loading();
    final result = await _repository.list();
    state = switch (result) {
      Success(:final data) => NotificationsState.loaded(data),
      ResultFailure(:final failure) => NotificationsState.error(failure),
    };
  }

  Future<void> markRead(int id) async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    await _repository.markRead(id);
    state = NotificationsState.loaded([
      for (final n in current.items) n.id == id ? n.copyWith(lu: true) : n,
    ]);
  }

  Future<void> markAllRead() async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    await _repository.markAllRead();
    state = NotificationsState.loaded([for (final n in current.items) n.copyWith(lu: true)]);
  }
}

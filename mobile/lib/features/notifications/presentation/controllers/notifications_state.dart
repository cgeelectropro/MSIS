import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/notification_entity.dart';

part 'notifications_state.freezed.dart';

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = NotificationsInitial;
  const factory NotificationsState.loading() = NotificationsLoading;
  const factory NotificationsState.loaded(List<NotificationEntity> items) = NotificationsLoaded;
  const factory NotificationsState.error(Failure failure) = NotificationsError;
}

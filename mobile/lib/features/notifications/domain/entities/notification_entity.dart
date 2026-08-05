import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entity.freezed.dart';

/// SRS §18.3 `notifications` / SCR-14.
@freezed
abstract class NotificationEntity with _$NotificationEntity {
  const factory NotificationEntity({
    required int id,
    required String type,
    required String contenu,
    int? idIntervention,
    required bool lu,
    required DateTime createdAt,
  }) = _NotificationEntity;
}

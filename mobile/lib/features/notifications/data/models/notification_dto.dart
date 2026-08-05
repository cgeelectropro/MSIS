import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification_entity.dart';

part 'notification_dto.freezed.dart';
part 'notification_dto.g.dart';

/// Wire format for `App\Http\Resources\NotificationResource` (SRS §18.5).
@freezed
abstract class NotificationDto with _$NotificationDto {
  const factory NotificationDto({
    required int id,
    required String type,
    required String canal,
    required String contenu,
    @JsonKey(name: 'id_intervention') int? idIntervention,
    required bool lu,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _NotificationDto;

  factory NotificationDto.fromJson(Map<String, dynamic> json) => _$NotificationDtoFromJson(json);
}

extension NotificationDtoMapper on NotificationDto {
  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    type: type,
    contenu: contenu,
    idIntervention: idIntervention,
    lu: lu,
    createdAt: DateTime.parse(createdAt),
  );
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationDto _$NotificationDtoFromJson(Map<String, dynamic> json) =>
    _NotificationDto(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String,
      canal: json['canal'] as String,
      contenu: json['contenu'] as String,
      idIntervention: (json['id_intervention'] as num?)?.toInt(),
      lu: json['lu'] as bool,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$NotificationDtoToJson(_NotificationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'canal': instance.canal,
      'contenu': instance.contenu,
      'id_intervention': instance.idIntervention,
      'lu': instance.lu,
      'created_at': instance.createdAt,
    };

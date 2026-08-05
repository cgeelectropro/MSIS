// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttachmentDto _$AttachmentDtoFromJson(Map<String, dynamic> json) =>
    _AttachmentDto(
      id: (json['id'] as num).toInt(),
      typeMime: json['type_mime'] as String,
      tailleOctets: (json['taille_octets'] as num).toInt(),
      url: json['url'] as String,
    );

Map<String, dynamic> _$AttachmentDtoToJson(_AttachmentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type_mime': instance.typeMime,
      'taille_octets': instance.tailleOctets,
      'url': instance.url,
    };

_MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => _MessageDto(
  idMessage: (json['id_message'] as num).toInt(),
  idIntervention: (json['id_intervention'] as num).toInt(),
  idExpediteur: (json['id_expediteur'] as num).toInt(),
  expediteur: json['expediteur'] as Map<String, dynamic>?,
  contenu: json['contenu'] as String,
  attachments: (json['attachments'] as List<dynamic>?)
      ?.map((e) => AttachmentDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  livre: json['livre'] as bool,
  lu: json['lu'] as bool,
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$MessageDtoToJson(_MessageDto instance) =>
    <String, dynamic>{
      'id_message': instance.idMessage,
      'id_intervention': instance.idIntervention,
      'id_expediteur': instance.idExpediteur,
      'expediteur': instance.expediteur,
      'contenu': instance.contenu,
      'attachments': instance.attachments,
      'livre': instance.livre,
      'lu': instance.lu,
      'created_at': instance.createdAt,
    };

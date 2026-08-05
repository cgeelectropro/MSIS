import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/message_entity.dart';

part 'message_dto.freezed.dart';
part 'message_dto.g.dart';

/// Wire format for `App\Http\Resources\MessageResource` / `PieceJointeResource`
/// (SRS §18.5). Explicit `@JsonKey` per snake_case field, matching the
/// convention already established in `intervention_dto.dart` — this project
/// has no global `field_rename: snake` build.yaml config, so every
/// non-single-word field needs one or it silently deserializes as null.

@freezed
abstract class AttachmentDto with _$AttachmentDto {
  const factory AttachmentDto({
    required int id,
    @JsonKey(name: 'type_mime') required String typeMime,
    @JsonKey(name: 'taille_octets') required int tailleOctets,
    required String url,
  }) = _AttachmentDto;

  factory AttachmentDto.fromJson(Map<String, dynamic> json) => _$AttachmentDtoFromJson(json);
}

@freezed
abstract class MessageDto with _$MessageDto {
  const factory MessageDto({
    @JsonKey(name: 'id_message') required int idMessage,
    @JsonKey(name: 'id_intervention') required int idIntervention,
    @JsonKey(name: 'id_expediteur') required int idExpediteur,
    Map<String, dynamic>? expediteur,
    required String contenu,
    List<AttachmentDto>? attachments,
    required bool livre,
    required bool lu,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);
}

extension MessageDtoMapper on MessageDto {
  MessageEntity toEntity() => MessageEntity(
    id: idMessage,
    idIntervention: idIntervention,
    idExpediteur: idExpediteur,
    expediteurNom: expediteur?['nom'] as String?,
    contenu: contenu,
    attachment: (attachments != null && attachments!.isNotEmpty)
        ? AttachmentEntity(
            id: attachments!.first.id,
            typeMime: attachments!.first.typeMime,
            tailleOctets: attachments!.first.tailleOctets,
            url: attachments!.first.url,
          )
        : null,
    livre: livre,
    lu: lu,
    createdAt: DateTime.parse(createdAt),
  );
}

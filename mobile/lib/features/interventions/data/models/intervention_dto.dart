import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../authentication/data/models/user_dto.dart';
import '../../../messages/data/models/message_dto.dart' show AttachmentDto;
import '../../../messages/domain/entities/message_entity.dart' show AttachmentEntity;
import '../../domain/entities/intervention_entity.dart';

part 'intervention_dto.freezed.dart';
part 'intervention_dto.g.dart';

/// Wire format for `App\Http\Resources\InterventionResource` (SRS §18.5).
@freezed
abstract class InterventionDto with _$InterventionDto {
  const factory InterventionDto({
    @JsonKey(name: 'id_intervention') required int idIntervention,
    required String titre,
    required String description,
    required String statut,
    required String priorite,
    @JsonKey(name: 'id_client') required int idClient,
    @JsonKey(name: 'id_technicien') int? idTechnicien,
    UserDto? client,
    UserDto? technicien,
    @JsonKey(name: 'motif_blocage') String? motifBlocage,
    @JsonKey(name: 'rapport_technique') String? rapportTechnique,
    @JsonKey(name: 'note_satisfaction') int? noteSatisfaction,
    @JsonKey(name: 'date_cloture') DateTime? dateCloture,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    List<AttachmentDto>? attachments,
  } ) = _InterventionDto;

  factory InterventionDto.fromJson(Map<String, dynamic> json) => _$InterventionDtoFromJson(json);
}

extension InterventionDtoMapper on InterventionDto {
  InterventionEntity toEntity() => InterventionEntity(
    id: idIntervention,
    titre: titre,
    description: description,
    statut: InterventionStatusApi.fromApi(statut),
    priorite: InterventionPriorityApi.fromApi(priorite),
    idClient: idClient,
    idTechnicien: idTechnicien,
    client: client?.toEntity(),
    technicien: technicien?.toEntity(),
    motifBlocage: motifBlocage,
    rapportTechnique: rapportTechnique,
    noteSatisfaction: noteSatisfaction,
    dateCloture: dateCloture,
    createdAt: createdAt,
    attachments: (attachments ?? [])
        .map(
          (a) => AttachmentEntity(id: a.id, typeMime: a.typeMime, tailleOctets: a.tailleOctets, url: a.url),
        )
        .toList(),
  );
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intervention_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InterventionDto _$InterventionDtoFromJson(Map<String, dynamic> json) =>
    _InterventionDto(
      idIntervention: (json['id_intervention'] as num).toInt(),
      titre: json['titre'] as String,
      description: json['description'] as String,
      statut: json['statut'] as String,
      priorite: json['priorite'] as String,
      idClient: (json['id_client'] as num).toInt(),
      idTechnicien: (json['id_technicien'] as num?)?.toInt(),
      client: json['client'] == null
          ? null
          : UserDto.fromJson(json['client'] as Map<String, dynamic>),
      technicien: json['technicien'] == null
          ? null
          : UserDto.fromJson(json['technicien'] as Map<String, dynamic>),
      motifBlocage: json['motif_blocage'] as String?,
      rapportTechnique: json['rapport_technique'] as String?,
      noteSatisfaction: (json['note_satisfaction'] as num?)?.toInt(),
      dateCloture: json['date_cloture'] == null
          ? null
          : DateTime.parse(json['date_cloture'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$InterventionDtoToJson(_InterventionDto instance) =>
    <String, dynamic>{
      'id_intervention': instance.idIntervention,
      'titre': instance.titre,
      'description': instance.description,
      'statut': instance.statut,
      'priorite': instance.priorite,
      'id_client': instance.idClient,
      'id_technicien': instance.idTechnicien,
      'client': instance.client,
      'technicien': instance.technicien,
      'motif_blocage': instance.motifBlocage,
      'rapport_technique': instance.rapportTechnique,
      'note_satisfaction': instance.noteSatisfaction,
      'date_cloture': instance.dateCloture?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

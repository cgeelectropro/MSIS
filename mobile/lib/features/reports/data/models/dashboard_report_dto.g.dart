// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TechnicianWorkloadDto _$TechnicianWorkloadDtoFromJson(
  Map<String, dynamic> json,
) => _TechnicianWorkloadDto(
  idTechnicien: (json['id_technicien'] as num).toInt(),
  nom: json['nom'] as String,
  charge: (json['charge'] as num).toInt(),
);

Map<String, dynamic> _$TechnicianWorkloadDtoToJson(
  _TechnicianWorkloadDto instance,
) => <String, dynamic>{
  'id_technicien': instance.idTechnicien,
  'nom': instance.nom,
  'charge': instance.charge,
};

_WeekTrendPointDto _$WeekTrendPointDtoFromJson(Map<String, dynamic> json) =>
    _WeekTrendPointDto(
      semaine: json['semaine'] as String,
      creees: (json['creees'] as num).toInt(),
      cloturees: (json['cloturees'] as num).toInt(),
    );

Map<String, dynamic> _$WeekTrendPointDtoToJson(_WeekTrendPointDto instance) =>
    <String, dynamic>{
      'semaine': instance.semaine,
      'creees': instance.creees,
      'cloturees': instance.cloturees,
    };

_DashboardKpisDto _$DashboardKpisDtoFromJson(Map<String, dynamic> json) =>
    _DashboardKpisDto(
      total: (json['total'] as num).toInt(),
      parStatut: json['par_statut'] as Map<String, dynamic>,
      parPriorite: json['par_priorite'] as Map<String, dynamic>,
      delaiMoyenPriseEnChargeMinutes:
          (json['delai_moyen_prise_en_charge_minutes'] as num?)?.toDouble(),
      delaiMoyenResolutionMinutes:
          (json['delai_moyen_resolution_minutes'] as num?)?.toDouble(),
      chargeParTechnicien: (json['charge_par_technicien'] as List<dynamic>)
          .map((e) => TechnicianWorkloadDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      satisfactionMoyenne: (json['satisfaction_moyenne'] as num).toDouble(),
    );

Map<String, dynamic> _$DashboardKpisDtoToJson(_DashboardKpisDto instance) =>
    <String, dynamic>{
      'total': instance.total,
      'par_statut': instance.parStatut,
      'par_priorite': instance.parPriorite,
      'delai_moyen_prise_en_charge_minutes':
          instance.delaiMoyenPriseEnChargeMinutes,
      'delai_moyen_resolution_minutes': instance.delaiMoyenResolutionMinutes,
      'charge_par_technicien': instance.chargeParTechnicien,
      'satisfaction_moyenne': instance.satisfactionMoyenne,
    };

_DashboardReportDto _$DashboardReportDtoFromJson(Map<String, dynamic> json) =>
    _DashboardReportDto(
      kpis: DashboardKpisDto.fromJson(json['kpis'] as Map<String, dynamic>),
      tendanceHebdomadaire: (json['tendance_hebdomadaire'] as List<dynamic>)
          .map((e) => WeekTrendPointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardReportDtoToJson(_DashboardReportDto instance) =>
    <String, dynamic>{
      'kpis': instance.kpis,
      'tendance_hebdomadaire': instance.tendanceHebdomadaire,
    };

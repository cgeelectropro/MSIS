import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/dashboard_report_entity.dart';

part 'dashboard_report_dto.freezed.dart';
part 'dashboard_report_dto.g.dart';

/// Wire format for `ReportController::dashboard` (SRS §18.5). Field names
/// mirror the backend's French keys exactly (`ReportingService::dashboard`)
/// via explicit `@JsonKey` — see message_dto.dart's doc comment for why this
/// project always does this rather than relying on a naming convention.

@freezed
abstract class TechnicianWorkloadDto with _$TechnicianWorkloadDto {
  const factory TechnicianWorkloadDto({
    @JsonKey(name: 'id_technicien') required int idTechnicien,
    required String nom,
    required int charge,
  }) = _TechnicianWorkloadDto;

  factory TechnicianWorkloadDto.fromJson(Map<String, dynamic> json) => _$TechnicianWorkloadDtoFromJson(json);
}

@freezed
abstract class WeekTrendPointDto with _$WeekTrendPointDto {
  const factory WeekTrendPointDto({required String semaine, required int creees, required int cloturees}) =
      _WeekTrendPointDto;

  factory WeekTrendPointDto.fromJson(Map<String, dynamic> json) => _$WeekTrendPointDtoFromJson(json);
}

@freezed
abstract class DashboardKpisDto with _$DashboardKpisDto {
  const factory DashboardKpisDto({
    required int total,
    @JsonKey(name: 'par_statut') required Map<String, dynamic> parStatut,
    @JsonKey(name: 'par_priorite') required Map<String, dynamic> parPriorite,
    @JsonKey(name: 'delai_moyen_prise_en_charge_minutes') double? delaiMoyenPriseEnChargeMinutes,
    @JsonKey(name: 'delai_moyen_resolution_minutes') double? delaiMoyenResolutionMinutes,
    @JsonKey(name: 'charge_par_technicien') required List<TechnicianWorkloadDto> chargeParTechnicien,
    @JsonKey(name: 'satisfaction_moyenne') required double satisfactionMoyenne,
  }) = _DashboardKpisDto;

  factory DashboardKpisDto.fromJson(Map<String, dynamic> json) => _$DashboardKpisDtoFromJson(json);
}

@freezed
abstract class DashboardReportDto with _$DashboardReportDto {
  const factory DashboardReportDto({
    required DashboardKpisDto kpis,
    @JsonKey(name: 'tendance_hebdomadaire') required List<WeekTrendPointDto> tendanceHebdomadaire,
  }) = _DashboardReportDto;

  factory DashboardReportDto.fromJson(Map<String, dynamic> json) => _$DashboardReportDtoFromJson(json);
}

extension DashboardReportDtoMapper on DashboardReportDto {
  DashboardReportEntity toEntity() => DashboardReportEntity(
    total: kpis.total,
    parStatut: kpis.parStatut.map((k, v) => MapEntry(k, v as int)),
    parPriorite: kpis.parPriorite.map((k, v) => MapEntry(k, v as int)),
    delaiMoyenPriseEnChargeMinutes: kpis.delaiMoyenPriseEnChargeMinutes,
    delaiMoyenResolutionMinutes: kpis.delaiMoyenResolutionMinutes,
    chargeParTechnicien: kpis.chargeParTechnicien
        .map((t) => TechnicianWorkload(idTechnicien: t.idTechnicien, nom: t.nom, charge: t.charge))
        .toList(),
    satisfactionMoyenne: kpis.satisfactionMoyenne,
    tendanceHebdomadaire: tendanceHebdomadaire
        .map((w) => WeekTrendPoint(semaine: w.semaine, creees: w.creees, cloturees: w.cloturees))
        .toList(),
  );
}

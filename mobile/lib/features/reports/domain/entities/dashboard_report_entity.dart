import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_report_entity.freezed.dart';

/// SRS §19.1/§23. Pure domain entity for the Supervisor's Rapports tab (SCR-11).
@freezed
abstract class TechnicianWorkload with _$TechnicianWorkload {
  const factory TechnicianWorkload({required int idTechnicien, required String nom, required int charge}) =
      _TechnicianWorkload;
}

@freezed
abstract class WeekTrendPoint with _$WeekTrendPoint {
  const factory WeekTrendPoint({required String semaine, required int creees, required int cloturees}) =
      _WeekTrendPoint;
}

@freezed
abstract class DashboardReportEntity with _$DashboardReportEntity {
  const factory DashboardReportEntity({
    required int total,
    required Map<String, int> parStatut,
    required Map<String, int> parPriorite,
    double? delaiMoyenPriseEnChargeMinutes,
    double? delaiMoyenResolutionMinutes,
    required List<TechnicianWorkload> chargeParTechnicien,
    required double satisfactionMoyenne,
    required List<WeekTrendPoint> tendanceHebdomadaire,
  }) = _DashboardReportEntity;
}

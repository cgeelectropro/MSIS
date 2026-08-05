import '../../../../shared/models/result.dart';
import '../entities/dashboard_report_entity.dart';

abstract class ReportRepository {
  Future<Result<DashboardReportEntity>> dashboard();

  /// SRS §23.3: returns the exported file's bytes; the screen handles saving/sharing.
  Future<Result<List<int>>> export({required String format, String? statut, String? priorite});
}

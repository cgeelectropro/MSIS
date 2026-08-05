import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/dashboard_report_dto.dart';

class ReportRemoteDataSource {
  ReportRemoteDataSource(this._dio);

  final Dio _dio;

  Future<DashboardReportDto> dashboard() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.reportsDashboard);
    return DashboardReportDto.fromJson(response.data!);
  }

  Future<List<int>> export({required String format, String? statut, String? priorite}) async {
    final response = await _dio.get<List<int>>(
      ApiEndpoints.reportsExport,
      queryParameters: {'format': format, 'statut': ?statut, 'priorite': ?priorite},
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data!;
  }
}

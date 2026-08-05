import 'package:dio/dio.dart';

import '../../../../core/network/interceptors/error_interceptor.dart';
import '../../../../shared/models/result.dart';
import '../../domain/entities/dashboard_report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_data_source.dart';
import '../models/dashboard_report_dto.dart';

class ReportRepositoryImpl implements ReportRepository {
  ReportRepositoryImpl(this._remote);

  final ReportRemoteDataSource _remote;

  @override
  Future<Result<DashboardReportEntity>> dashboard() async {
    try {
      final dto = await _remote.dashboard();
      return Result.success(dto.toEntity());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<List<int>>> export({required String format, String? statut, String? priorite}) async {
    try {
      final bytes = await _remote.export(format: format, statut: statut, priorite: priorite);
      return Result.success(bytes);
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }
}

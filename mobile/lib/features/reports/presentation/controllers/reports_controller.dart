import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injector.dart';
import '../../../../shared/models/result.dart';
import '../../domain/repositories/report_repository.dart';
import 'reports_state.dart';

final reportRepositoryProvider = Provider<ReportRepository>((ref) => getIt<ReportRepository>());

final reportsControllerProvider = StateNotifierProvider<ReportsController, ReportsState>(
  (ref) => ReportsController(ref.watch(reportRepositoryProvider)),
);

/// SRS SCR-11.
class ReportsController extends StateNotifier<ReportsState> {
  ReportsController(this._repository) : super(const ReportsState.initial());

  final ReportRepository _repository;

  Future<void> load() async {
    state = const ReportsState.loading();
    final result = await _repository.dashboard();
    state = switch (result) {
      Success(:final data) => ReportsState.loaded(data),
      ResultFailure(:final failure) => ReportsState.error(failure),
    };
  }

  Future<Result<List<int>>> export({required String format}) => _repository.export(format: format);
}

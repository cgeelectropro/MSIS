import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/dashboard_report_entity.dart';

part 'reports_state.freezed.dart';

@freezed
sealed class ReportsState with _$ReportsState {
  const factory ReportsState.initial() = ReportsInitial;
  const factory ReportsState.loading() = ReportsLoading;
  const factory ReportsState.loaded(DashboardReportEntity report) = ReportsLoaded;
  const factory ReportsState.error(Failure failure) = ReportsError;
}

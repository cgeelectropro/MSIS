import 'package:dio/dio.dart';

import '../../../../core/network/interceptors/error_interceptor.dart';
import '../../../../shared/models/result.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';
import '../models/notification_dto.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._remote);

  final NotificationRemoteDataSource _remote;

  @override
  Future<Result<List<NotificationEntity>>> list() async {
    try {
      final dtos = await _remote.list();
      return Result.success(dtos.map((d) => d.toEntity()).toList());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<void>> markRead(int id) async {
    try {
      await _remote.markRead(id);
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<void>> markAllRead() async {
    try {
      await _remote.markAllRead();
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }
}

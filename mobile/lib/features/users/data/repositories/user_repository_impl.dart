import 'package:dio/dio.dart';

import '../../../../core/network/interceptors/error_interceptor.dart';
import '../../../../shared/models/result.dart';
import '../../../authentication/data/models/user_dto.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._remote);

  final UserRemoteDataSource _remote;

  @override
  Future<Result<List<UserEntity>>> list({UserRole? role, String? search}) async {
    try {
      final dtos = await _remote.list(role: role?.apiValue, search: search);
      return Result.success(dtos.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<UserEntity>> createTechnician({required String nom, required String email, String? telephone}) async {
    try {
      final dto = await _remote.createTechnician(nom: nom, email: email, telephone: telephone);
      return Result.success(dto.toEntity());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<UserEntity>> updateStatus({required int userId, required bool actif}) async {
    try {
      final dto = await _remote.updateStatus(userId: userId, actif: actif);
      return Result.success(dto.toEntity());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }
}

import 'package:dio/dio.dart';

import '../../../../core/network/interceptors/error_interceptor.dart';
import '../../../../shared/models/result.dart';
import '../../domain/entities/intervention_entity.dart';
import '../../domain/repositories/intervention_repository.dart';
import '../datasources/intervention_remote_data_source.dart';
import '../models/intervention_dto.dart';

class InterventionRepositoryImpl implements InterventionRepository {
  InterventionRepositoryImpl(this._remote);

  final InterventionRemoteDataSource _remote;

  @override
  Future<Result<List<InterventionEntity>>> list({InterventionStatus? status, String? search}) async {
    try {
      final dtos = await _remote.list(status: status?.apiValue, search: search);
      return Result.success(dtos.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<InterventionEntity>> create({
    required String titre,
    required String description,
    InterventionPriority? priorite,
  }) async {
    try {
      final dto = await _remote.create(titre: titre, description: description, priorite: priorite?.apiValue);
      return Result.success(dto.toEntity());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<InterventionEntity>> show(int id) async {
    try {
      return Result.success((await _remote.show(id)).toEntity());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<InterventionEntity>> assign({required int interventionId, required int technicienId}) async {
    try {
      return Result.success(
        (await _remote.assign(interventionId: interventionId, technicienId: technicienId)).toEntity(),
      );
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<InterventionEntity>> updateStatus({
    required int interventionId,
    required InterventionStatus statut,
    String? motifBlocage,
    String? rapportTechnique,
  }) async {
    try {
      final dto = await _remote.updateStatus(
        interventionId: interventionId,
        statut: statut.apiValue,
        motifBlocage: motifBlocage,
        rapportTechnique: rapportTechnique,
      );
      return Result.success(dto.toEntity());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<InterventionEntity>> close({required int interventionId, int? noteSatisfaction}) async {
    try {
      final dto = await _remote.close(interventionId: interventionId, noteSatisfaction: noteSatisfaction);
      return Result.success(dto.toEntity());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<InterventionEntity>> cancel(int interventionId) async {
    try {
      return Result.success((await _remote.cancel(interventionId)).toEntity());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }

  @override
  Future<Result<InterventionEntity>> addAttachment({required int interventionId, required String filePath}) async {
    try {
      final dto = await _remote.addAttachment(interventionId: interventionId, filePath: filePath);
      return Result.success(dto.toEntity());
    } on DioException catch (e) {
      return Result.failure(ErrorMapper.map(e));
    }
  }
}

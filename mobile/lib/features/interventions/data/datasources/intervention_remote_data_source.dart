import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/intervention_dto.dart';

class InterventionRemoteDataSource {
  InterventionRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<InterventionDto>> list({String? status, String? search}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.interventions,
      queryParameters: {'statut': ?status, 'search': ?search},
    );
    final data = response.data!['data'] as List;
    return data.map((e) => InterventionDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<InterventionDto> create({required String titre, required String description, String? priorite}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.interventions,
      data: {'titre': titre, 'description': description, 'priorite': ?priorite},
    );
    return InterventionDto.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<InterventionDto> show(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.intervention(id));
    return InterventionDto.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<InterventionDto> assign({required int interventionId, required int technicienId}) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.interventionAssign(interventionId),
      data: {'id_technicien': technicienId},
    );
    return InterventionDto.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<InterventionDto> updateStatus({
    required int interventionId,
    required String statut,
    String? motifBlocage,
    String? rapportTechnique,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.interventionStatus(interventionId),
      data: {
        'statut': statut,
        'motif_blocage': ?motifBlocage,
        'rapport_technique': ?rapportTechnique,
      },
    );
    return InterventionDto.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<InterventionDto> close({required int interventionId, int? noteSatisfaction}) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.interventionClose(interventionId),
      data: {'note_satisfaction': ?noteSatisfaction},
    );
    return InterventionDto.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  Future<InterventionDto> cancel(int interventionId) async {
    final response = await _dio.patch<Map<String, dynamic>>(ApiEndpoints.interventionCancel(interventionId));
    return InterventionDto.fromJson(response.data!['data'] as Map<String, dynamic>);
  }

  /// SRS FR-CRT-04/§17.2. Returns the intervention as it stands after the
  /// upload, re-fetched rather than assembled client-side — simplest way to
  /// get the authoritative `attachments` list back in one round trip.
  Future<InterventionDto> addAttachment({required int interventionId, required String filePath}) async {
    await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.interventionAttachments(interventionId),
      data: FormData.fromMap({'fichier': await MultipartFile.fromFile(filePath)}),
    );
    return show(interventionId);
  }
}

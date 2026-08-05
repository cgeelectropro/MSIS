import '../../../../shared/models/result.dart';
import '../entities/intervention_entity.dart';

abstract class InterventionRepository {
  Future<Result<List<InterventionEntity>>> list({InterventionStatus? status, String? search});

  Future<Result<InterventionEntity>> create({
    required String titre,
    required String description,
    InterventionPriority? priorite,
  });

  Future<Result<InterventionEntity>> show(int id);

  Future<Result<InterventionEntity>> assign({required int interventionId, required int technicienId});

  Future<Result<InterventionEntity>> updateStatus({
    required int interventionId,
    required InterventionStatus statut,
    String? motifBlocage,
    String? rapportTechnique,
  });

  Future<Result<InterventionEntity>> close({required int interventionId, int? noteSatisfaction});

  Future<Result<InterventionEntity>> cancel(int interventionId);
}

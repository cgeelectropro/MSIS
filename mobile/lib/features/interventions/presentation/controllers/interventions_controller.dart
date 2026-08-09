import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injector.dart';
import '../../../../shared/models/result.dart';
import '../../domain/entities/intervention_entity.dart';
import '../../domain/repositories/intervention_repository.dart';
import 'interventions_state.dart';

final interventionRepositoryProvider = Provider<InterventionRepository>(
  (ref) => getIt<InterventionRepository>(),
);

final interventionsControllerProvider =
    StateNotifierProvider<InterventionsController, InterventionsState>(
      (ref) => InterventionsController(ref.watch(interventionRepositoryProvider)),
    );

/// SRS §9.3/§9.4/§14.2. Backs SCR-05 (Client), SCR-07 (Technicien), SCR-09
/// (Supervisor) — scoping by role happens server-side (BRULE-001), this
/// controller just fetches whatever the API returns for the current session.
class InterventionsController extends StateNotifier<InterventionsState> {
  InterventionsController(this._repository) : super(const InterventionsState.initial());

  final InterventionRepository _repository;

  Future<void> load({InterventionStatus? status, String? search}) async {
    state = const InterventionsState.loading();
    final result = await _repository.list(status: status, search: search);
    state = switch (result) {
      Success(:final data) => InterventionsState.loaded(data),
      ResultFailure(:final failure) => InterventionsState.error(failure),
    };
  }

  /// Returns the created ticket (so the caller can immediately attach files
  /// to it, SRS FR-CRT-04 — needs the server-assigned id) or null on failure.
  Future<InterventionEntity?> create({
    required String titre,
    required String description,
    InterventionPriority? priorite,
  }) async {
    final result = await _repository.create(titre: titre, description: description, priorite: priorite);
    if (result case Success(:final data)) {
      await load();
      return data;
    }
    return null;
  }

  Future<Result<InterventionEntity>> addAttachment({required int interventionId, required String filePath}) =>
      _repository.addAttachment(interventionId: interventionId, filePath: filePath);

  Future<bool> cancel(int id) async {
    final result = await _repository.cancel(id);
    if (result.isSuccess) {
      await load();
      return true;
    }
    return false;
  }
}

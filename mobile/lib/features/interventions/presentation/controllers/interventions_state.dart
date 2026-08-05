import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/intervention_entity.dart';

part 'interventions_state.freezed.dart';

@freezed
sealed class InterventionsState with _$InterventionsState {
  const factory InterventionsState.initial() = InterventionsInitial;
  const factory InterventionsState.loading() = InterventionsLoading;
  const factory InterventionsState.loaded(List<InterventionEntity> items) = InterventionsLoaded;
  const factory InterventionsState.error(Failure failure) = InterventionsError;
}

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../authentication/domain/entities/user_entity.dart';
import '../../../messages/domain/entities/message_entity.dart' show AttachmentEntity;

part 'intervention_entity.freezed.dart';

/// SRS §18.3 `interventions.statut` / BRULE-002. Pure Dart — no Flutter
/// import here (Implementation Plan §1.1: domain has zero Flutter deps).
/// Color/label mapping for the UI lives in `app/theme/status_colors.dart`.
enum InterventionStatus { enAttente, enCours, bloque, resolue, cloturee, annulee }

enum InterventionPriority { basse, normale, haute }

extension InterventionStatusApi on InterventionStatus {
  static InterventionStatus fromApi(String value) => switch (value) {
    'EN_ATTENTE' => InterventionStatus.enAttente,
    'EN_COURS' => InterventionStatus.enCours,
    'BLOQUE' => InterventionStatus.bloque,
    'RESOLUE' => InterventionStatus.resolue,
    'CLOTUREE' => InterventionStatus.cloturee,
    'ANNULEE' => InterventionStatus.annulee,
    _ => throw ArgumentError('Unknown status: $value'),
  };

  String get apiValue => switch (this) {
    InterventionStatus.enAttente => 'EN_ATTENTE',
    InterventionStatus.enCours => 'EN_COURS',
    InterventionStatus.bloque => 'BLOQUE',
    InterventionStatus.resolue => 'RESOLUE',
    InterventionStatus.cloturee => 'CLOTUREE',
    InterventionStatus.annulee => 'ANNULEE',
  };
}

extension InterventionPriorityApi on InterventionPriority {
  static InterventionPriority fromApi(String value) => switch (value) {
    'BASSE' => InterventionPriority.basse,
    'NORMALE' => InterventionPriority.normale,
    'HAUTE' => InterventionPriority.haute,
    _ => throw ArgumentError('Unknown priority: $value'),
  };

  String get apiValue => switch (this) {
    InterventionPriority.basse => 'BASSE',
    InterventionPriority.normale => 'NORMALE',
    InterventionPriority.haute => 'HAUTE',
  };
}

@freezed
abstract class InterventionEntity with _$InterventionEntity {
  const factory InterventionEntity({
    required int id,
    required String titre,
    required String description,
    required InterventionStatus statut,
    required InterventionPriority priorite,
    required int idClient,
    int? idTechnicien,
    UserEntity? client,
    UserEntity? technicien,
    String? motifBlocage,
    String? rapportTechnique,
    int? noteSatisfaction,
    DateTime? dateCloture,
    required DateTime createdAt,
    @Default([]) List<AttachmentEntity> attachments,
  }) = _InterventionEntity;
}

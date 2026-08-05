import 'package:flutter/material.dart';

import '../../features/interventions/domain/entities/intervention_entity.dart';
import 'app_colors.dart';

/// UI_UX_SPECIFICATION.md Part B.1 color mapping, layered on top of the pure-Dart
/// domain enums in `features/interventions/domain/entities/intervention_entity.dart`
/// — kept here (in `app/theme`, not `domain`) specifically so the domain layer
/// never imports Flutter (Implementation Plan §1.1).
extension InterventionStatusUi on InterventionStatus {
  String get labelFr => switch (this) {
    InterventionStatus.enAttente => 'En attente',
    InterventionStatus.enCours => 'En cours',
    InterventionStatus.bloque => 'Bloqué',
    InterventionStatus.resolue => 'Résolue',
    InterventionStatus.cloturee => 'Clôturée',
    InterventionStatus.annulee => 'Annulée',
  };

  Color get color => switch (this) {
    InterventionStatus.enAttente => AppColors.warning,
    InterventionStatus.enCours => AppColors.primary,
    InterventionStatus.bloque => AppColors.statusBloque,
    InterventionStatus.resolue => AppColors.success,
    InterventionStatus.cloturee => AppColors.statusCloturee,
    InterventionStatus.annulee => AppColors.outlineLight,
  };
}

extension InterventionPriorityUi on InterventionPriority {
  String get labelFr => switch (this) {
    InterventionPriority.basse => 'Basse',
    InterventionPriority.normale => 'Normale',
    InterventionPriority.haute => 'Haute',
  };

  Color get color => switch (this) {
    InterventionPriority.basse => AppColors.success,
    InterventionPriority.normale => AppColors.warning,
    InterventionPriority.haute => AppColors.danger,
  };
}

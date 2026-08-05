import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/status_colors.dart';
import '../../features/interventions/domain/entities/intervention_entity.dart';

/// UI_UX_SPECIFICATION.md Part B.7 / Component C.1.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final InterventionStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        status.labelFr,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

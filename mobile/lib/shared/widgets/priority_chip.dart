import 'package:flutter/material.dart';

import '../../app/theme/status_colors.dart';
import '../../features/interventions/domain/entities/intervention_entity.dart';

/// UI_UX_SPECIFICATION.md Component C.2.
class PriorityChip extends StatelessWidget {
  const PriorityChip({super.key, required this.priority});

  final InterventionPriority priority;

  @override
  Widget build(BuildContext context) {
    final color = priority.color;
    return Chip(
      avatar: Icon(Icons.flag_rounded, size: 14, color: color),
      label: Text(priority.labelFr, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

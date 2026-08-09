import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/status_colors.dart';
import '../../features/interventions/domain/entities/intervention_entity.dart';

/// SRS §13.3 "filtres par statut" (FR-DASH-03/FR-TECH-02, Must-have) — the
/// repository/controller already accepted a status filter param; this was
/// the missing UI. `statuses` lets each screen scope which chips are
/// relevant (e.g. a client rarely needs to filter by BLOQUE).
class StatusFilterChips extends StatelessWidget {
  const StatusFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
    this.statuses = InterventionStatus.values,
  });

  final InterventionStatus? selected;
  final ValueChanged<InterventionStatus?> onSelected;
  final List<InterventionStatus> statuses;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.marginMobile),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: ChoiceChip(
              label: const Text('Toutes'),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          for (final status in statuses)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: ChoiceChip(
                label: Text(status.labelFr),
                selected: selected == status,
                selectedColor: status.color.withValues(alpha: 0.25),
                onSelected: (_) => onSelected(status),
              ),
            ),
        ],
      ),
    );
  }
}

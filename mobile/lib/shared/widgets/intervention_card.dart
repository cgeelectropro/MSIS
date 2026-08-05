import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/status_colors.dart';
import '../../features/interventions/domain/entities/intervention_entity.dart';
import 'priority_chip.dart';
import 'status_badge.dart';

/// UI_UX_SPECIFICATION.md Component C.4 — the primary list item across
/// SCR-05/07/09. `subtitle` carries the counterpart name (technicien for a
/// client's view, client for a technicien's/supervisor's view).
class InterventionCard extends StatelessWidget {
  const InterventionCard({super.key, required this.intervention, this.subtitle, this.onTap});

  final InterventionEntity intervention;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusStandard),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(width: 4, height: 48, color: intervention.priorite.color),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      intervention.titre,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        StatusBadge(status: intervention.statut),
                        const SizedBox(width: AppSpacing.xs),
                        PriorityChip(priority: intervention.priorite),
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariantLight),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

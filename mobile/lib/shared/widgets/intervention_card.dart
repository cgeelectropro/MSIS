import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusStandard),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusStandard),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusStandard),
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(AppSpacing.radiusStandard)),
                    child: Container(width: 4, color: intervention.priorite.color),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            intervention.titre,
                            style: theme.textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.xs,
                            runSpacing: AppSpacing.xs,
                            children: [
                              StatusBadge(status: intervention.statut),
                              PriorityChip(priority: intervention.priorite),
                            ],
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Row(
                              children: [
                                Icon(Icons.person_outline, size: 14, color: theme.colorScheme.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Text(
                                  subtitle!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

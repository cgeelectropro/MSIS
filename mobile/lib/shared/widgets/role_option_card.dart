import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../features/authentication/domain/entities/user_entity.dart';

/// Replaces a bare `SegmentedButton` for role selection on the login screen
/// with three tappable cards carrying an icon + label — more scannable and
/// considerably more visually substantial for a screen the user sees first.
class RoleOptionCard extends StatelessWidget {
  const RoleOptionCard({required this.role, required this.selected, required this.onTap, super.key});

  final UserRole role;
  final bool selected;
  final VoidCallback onTap;

  (IconData, String) get _content => switch (role) {
    UserRole.client => (Icons.person_outline, 'Client'),
    UserRole.technicien => (Icons.build_outlined, 'Technicien'),
    UserRole.admin => (Icons.insights_outlined, 'Superviseur'),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, label) = _content;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: Material(
        color: selected ? theme.colorScheme.primary.withValues(alpha: 0.1) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusStandard),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusStandard),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusStandard),
              border: Border.all(
                color: selected ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.4),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: selected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/di/injector.dart';
import '../../core/network/connectivity_service.dart';

/// Component C.10 (UI_UX_SPECIFICATION.md Part C.10) / SRS §16.5: persistent,
/// non-blocking indicator shown wherever cached data may be stale.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: getIt<ConnectivityService>().onStatusChange,
      initialData: true,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;
        if (isOnline) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          color: AppColors.warning.withValues(alpha: 0.15),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_off, size: 14, color: AppColors.warning),
              SizedBox(width: AppSpacing.xs),
              Text('Hors ligne — les données affichées peuvent être obsolètes', style: TextStyle(fontSize: 11)),
            ],
          ),
        );
      },
    );
  }
}

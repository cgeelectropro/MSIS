import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/models/result.dart';
import '../../domain/entities/dashboard_report_entity.dart';
import '../controllers/reports_controller.dart';
import '../controllers/reports_state.dart';

/// SRS SCR-11 / §19/§23. Charts are simple proportional-bar widgets rather
/// than a dedicated charting package — no such dependency exists in this
/// project yet, and the data volumes here (a handful of statuses/technicians)
/// don't need one; every value is also shown as text (RPT-13 accessibility
/// requirement — a bar's height alone is never the only way to read a value).
class ReportsTab extends ConsumerStatefulWidget {
  const ReportsTab({super.key});

  @override
  ConsumerState<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends ConsumerState<ReportsTab> {
  bool _exporting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(reportsControllerProvider.notifier).load());
  }

  Future<void> _export(String format) async {
    setState(() => _exporting = true);
    final result = await ref.read(reportsControllerProvider.notifier).export(format: format);
    setState(() => _exporting = false);

    // Every await this method still needs to perform (file I/O) happens here,
    // before the single `mounted` check that guards every subsequent use of
    // `context` — the earlier version re-awaited *after* that check, which is
    // exactly the unsafe pattern `use_build_context_synchronously` catches.
    String message;
    switch (result) {
      case Success(:final data):
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/rapport_interventions.$format');
        await file.writeAsBytes(data);
        message = 'Export enregistré : ${file.path}';
      case ResultFailure(:final failure):
        message = failure.message;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportsControllerProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(reportsControllerProvider.notifier).load(),
      child: switch (state) {
        ReportsInitial() || ReportsLoading() => const Center(child: CircularProgressIndicator()),
        ReportsError(:final failure) => Center(child: Text(failure.message)),
        ReportsLoaded(:final report) => _buildReport(report),
      },
    );
  }

  Widget _buildReport(DashboardReportEntity report) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      children: [
        _kpiGrid(report),
        const SizedBox(height: AppSpacing.lg),
        Text('Répartition par statut', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _barChart(report.parStatut),
        const SizedBox(height: AppSpacing.lg),
        Text('Charge par technicien', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        _barChart({for (final t in report.chargeParTechnicien) t.nom: t.charge}),
        const SizedBox(height: AppSpacing.lg),
        Text('Export', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _exporting ? null : () => _export('csv'),
                child: const Text('Exporter en CSV'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: FilledButton(
                onPressed: _exporting ? null : () => _export('pdf'),
                child: _exporting
                    ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Exporter en PDF'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _kpiGrid(DashboardReportEntity report) {
    final tiles = [
      _KpiTile('Total', '${report.total}', Icons.list_alt_outlined, AppColors.primary),
      _KpiTile('En attente', '${report.parStatut['EN_ATTENTE'] ?? 0}', Icons.hourglass_empty, AppColors.warning),
      _KpiTile('En cours', '${report.parStatut['EN_COURS'] ?? 0}', Icons.autorenew, AppColors.primary),
      _KpiTile('Clôturées', '${report.parStatut['CLOTUREE'] ?? 0}', Icons.check_circle_outline, AppColors.success),
      _KpiTile(
        'Délai moyen de prise en charge',
        report.delaiMoyenPriseEnChargeMinutes != null ? '${report.delaiMoyenPriseEnChargeMinutes!.round()} min' : '—',
        Icons.timer_outlined,
        AppColors.secondary,
      ),
      _KpiTile(
        'Délai moyen de résolution',
        report.delaiMoyenResolutionMinutes != null ? '${report.delaiMoyenResolutionMinutes!.round()} min' : '—',
        Icons.task_alt,
        AppColors.secondary,
      ),
      _KpiTile('Satisfaction moyenne', '${report.satisfactionMoyenne.toStringAsFixed(1)} / 5', Icons.star_outline, AppColors.warning),
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: tiles.map((t) => SizedBox(width: 160, child: t)).toList(),
    );
  }

  Widget _barChart(Map<String, int> data) {
    if (data.isEmpty) {
      return Text('Aucune donnée', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant));
    }
    final maxValue = data.values.fold(0, (a, b) => a > b ? a : b).clamp(1, 1 << 30);

    return Column(
      children: data.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(entry.key, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500)),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: entry.value / maxValue,
                      child: Container(
                        height: 18,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary.withValues(alpha: 0.7), AppColors.primary],
                          ),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: 28,
                child: Text('${entry.value}', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile(this.label, this.value, this.icon, this.color);
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSpacing.radiusSmall)),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

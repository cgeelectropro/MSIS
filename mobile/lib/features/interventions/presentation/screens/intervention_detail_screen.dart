import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/models/result.dart';
import '../../../../shared/widgets/empty_state_view.dart';
import '../../../../shared/widgets/priority_chip.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../../authentication/presentation/controllers/auth_state.dart';
import '../../../authentication/presentation/controllers/auth_controller.dart';
import '../../../messages/presentation/screens/conversation_screen.dart';
import '../../../users/presentation/controllers/users_controller.dart';
import '../../../users/presentation/controllers/users_state.dart';
import '../../domain/entities/intervention_entity.dart';
import '../controllers/interventions_controller.dart';

/// SRS SCR-08 — shared across Client/Technicien/Superviseur, action button
/// contextual on role + current status (BRULE-001..003).
class InterventionDetailScreen extends ConsumerStatefulWidget {
  const InterventionDetailScreen({super.key, required this.interventionId});

  final int interventionId;

  @override
  ConsumerState<InterventionDetailScreen> createState() => _InterventionDetailScreenState();
}

class _InterventionDetailScreenState extends ConsumerState<InterventionDetailScreen> {
  InterventionEntity? _intervention;
  bool _loading = true;
  bool _acting = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    final result = await ref.read(interventionRepositoryProvider).show(widget.interventionId);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _intervention = result.dataOrNull;
    });
    if (result.failureOrNull != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.failureOrNull!.message)));
    }
  }

  Future<void> _runAction(Future<Result<InterventionEntity>> Function() action) async {
    setState(() => _acting = true);
    final result = await action();
    if (!mounted) return;
    setState(() {
      _acting = false;
      if (result.isSuccess) _intervention = result.dataOrNull;
    });
    final failure = result.failureOrNull;
    if (failure != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failure.message)));
    }
  }

  Future<String?> _promptText(String title, String label) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  /// SRS FR-DET-02/UC-05: 1-5 satisfaction rating on closure. Returns null if
  /// the client dismisses without picking a rating (note_satisfaction stays
  /// optional server-side either way).
  Future<int?> _promptRating(String title, String body) {
    int selected = 0;
    return showModalBottomSheet<int>(
      context: context,
      isDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.all(AppSpacing.marginMobile),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(body),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final starValue = i + 1;
                  return IconButton(
                    iconSize: 36,
                    icon: Icon(
                      starValue <= selected ? Icons.star : Icons.star_border,
                      color: AppColors.warning,
                    ),
                    onPressed: () => setSheetState(() => selected = starValue),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Passer'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton(
                      onPressed: selected == 0 ? null : () => Navigator.pop(context, selected),
                      child: const Text('Confirmer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirm(String title, String body) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(body),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Confirmer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _pickTechnicianAndAssign() async {
    await ref.read(usersControllerProvider.notifier).load(role: UserRole.technicien);
    final usersState = ref.read(usersControllerProvider);
    final technicians = usersState.maybeWhen(loaded: (items) => items, orElse: () => const []);

    if (!mounted) return;
    final selected = await showModalBottomSheet<int>(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: technicians
            .map((t) => ListTile(title: Text(t.nom), subtitle: Text(t.email), onTap: () => Navigator.pop(context, t.id)))
            .toList(),
      ),
    );

    if (selected != null) {
      await _runAction(
        () => ref.read(interventionRepositoryProvider).assign(interventionId: widget.interventionId, technicienId: selected),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final currentUser = authState.maybeWhen(authenticated: (u) => u, orElse: () => null);

    return Scaffold(
      appBar: AppBar(
        title: Text('INT-${widget.interventionId}'),
        actions: [
          if (_canSeeMessaging(currentUser))
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              tooltip: 'Messagerie',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ConversationScreen(
                    interventionId: widget.interventionId,
                    isClosed:
                        _intervention?.statut == InterventionStatus.cloturee ||
                        _intervention?.statut == InterventionStatus.annulee,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _intervention == null
          ? const EmptyStateView(icon: Icons.error_outline, title: 'Ticket introuvable')
          : _buildBody(context, currentUser),
    );
  }

  /// SRS FR-DET-01 "pièces jointes en galerie miniature" — thumbnails for
  /// images, a generic file tile for documents (PDF), both opening the
  /// signed download URL already embedded in each AttachmentEntity.
  Widget _buildAttachmentGallery(InterventionEntity intervention) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: intervention.attachments.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final attachment = intervention.attachments[index];
          final isImage = attachment.typeMime.startsWith('image/');
          return GestureDetector(
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => Dialog(
                child: isImage
                    ? InteractiveViewer(child: Image.network(attachment.url))
                    : Padding(
                        padding: const EdgeInsets.all(AppSpacing.marginMobile),
                        child: Text('Document : ${attachment.typeMime}'),
                      ),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              child: isImage
                  ? Image.network(
                      attachment.url,
                      width: 88,
                      height: 88,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(Icons.broken_image_outlined, size: 40),
                    )
                  : Container(
                      width: 88,
                      height: 88,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Icon(Icons.picture_as_pdf_outlined, size: 32, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, UserEntity? currentUser) {
    final i = _intervention!;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.marginMobile),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [StatusBadge(status: i.statut), const SizedBox(width: AppSpacing.sm), PriorityChip(priority: i.priorite)]),
          const SizedBox(height: AppSpacing.md),
          Text(i.titre, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(i.description, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.lg),
          if (i.client != null || i.technicien != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (i.client != null) _personRow(context, Icons.person_outline, 'Client', i.client!.nom),
                    if (i.client != null && i.technicien != null) const SizedBox(height: AppSpacing.sm),
                    if (i.technicien != null) _personRow(context, Icons.engineering_outlined, 'Technicien', i.technicien!.nom),
                  ],
                ),
              ),
            ),
          if (i.motifBlocage != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _noteCard(context, icon: Icons.block, color: AppColors.statusBloque, label: 'Motif du blocage', text: i.motifBlocage!),
          ],
          if (i.rapportTechnique != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _noteCard(context, icon: Icons.description_outlined, color: AppColors.success, label: 'Rapport technique', text: i.rapportTechnique!),
          ],
          if (i.attachments.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Text('Pièces jointes', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            _buildAttachmentGallery(i),
          ],
          const SizedBox(height: AppSpacing.lg),
          if (_acting) const Center(child: CircularProgressIndicator()) else _buildActions(currentUser, i),
        ],
      ),
    );
  }

  Widget _personRow(BuildContext context, IconData icon, String label, String name) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.sm),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const Spacer(),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _noteCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusStandard),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: AppSpacing.xs),
              Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 13)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(text),
        ],
      ),
    );
  }

  // SRS BRULE-004: owning client, assigned technicien, or admin (audit) only.
  bool _canSeeMessaging(UserEntity? user) {
    final i = _intervention;
    if (user == null || i == null) return false;
    return user.id == i.idClient || user.id == i.idTechnicien || user.role == UserRole.admin;
  }

  Widget _buildActions(UserEntity? user, InterventionEntity i) {
    if (user == null) return const SizedBox.shrink();

    final buttons = <Widget>[];

    // SRS UC-03 / FR-TRV-03: Supervisor can assign/reassign at any active stage.
    if (user.role == UserRole.admin && i.statut != InterventionStatus.cloturee && i.statut != InterventionStatus.annulee) {
      buttons.add(
        FilledButton.icon(
          onPressed: _pickTechnicianAndAssign,
          icon: const Icon(Icons.person_add),
          label: Text(i.idTechnicien == null ? 'Assigner un technicien' : 'Réassigner'),
        ),
      );
    }

    final isOwnTechnician = user.role == UserRole.technicien && user.id == i.idTechnicien;

    if (isOwnTechnician && i.statut == InterventionStatus.enCours) {
      buttons.add(
        OutlinedButton.icon(
          onPressed: () async {
            final reason = await _promptText('Signaler un blocage', 'Motif du blocage');
            if (reason != null && reason.isNotEmpty) {
              await _runAction(
                () => ref
                    .read(interventionRepositoryProvider)
                    .updateStatus(interventionId: i.id, statut: InterventionStatus.bloque, motifBlocage: reason),
              );
            }
          },
          icon: const Icon(Icons.block),
          label: const Text('Signaler un blocage'),
        ),
      );
      buttons.add(
        FilledButton.icon(
          onPressed: () async {
            final report = await _promptText('Marquer résolu', 'Rapport technique');
            if (report != null && report.isNotEmpty) {
              await _runAction(
                () => ref
                    .read(interventionRepositoryProvider)
                    .updateStatus(interventionId: i.id, statut: InterventionStatus.resolue, rapportTechnique: report),
              );
            }
          },
          icon: const Icon(Icons.check_circle),
          label: const Text('Marquer résolu'),
        ),
      );
    }

    if (isOwnTechnician && i.statut == InterventionStatus.bloque) {
      buttons.add(
        FilledButton.icon(
          onPressed: () => _runAction(
            () => ref.read(interventionRepositoryProvider).updateStatus(interventionId: i.id, statut: InterventionStatus.enCours),
          ),
          icon: const Icon(Icons.play_arrow),
          label: const Text('Reprendre'),
        ),
      );
    }

    final isOwningClient = user.role == UserRole.client && user.id == i.idClient;

    if (isOwningClient && i.statut == InterventionStatus.resolue) {
      buttons.add(
        FilledButton.icon(
          onPressed: () async {
            final confirmed = await _confirm('Confirmer la clôture', 'Le technicien a marqué cette intervention comme résolue.');
            if (!confirmed || !mounted) return;
            final rating = await _promptRating('Votre satisfaction', 'Comment évaluez-vous cette intervention ?');
            if (!mounted) return;
            await _runAction(() => ref.read(interventionRepositoryProvider).close(interventionId: i.id, noteSatisfaction: rating));
          },
          icon: const Icon(Icons.task_alt),
          label: const Text('Confirmer la clôture'),
        ),
      );
    }

    if (isOwningClient && i.statut == InterventionStatus.enAttente) {
      buttons.add(
        OutlinedButton.icon(
          onPressed: () async {
            final confirmed = await _confirm('Annuler le ticket', 'Cette action est définitive.');
            if (confirmed) {
              await _runAction(() => ref.read(interventionRepositoryProvider).cancel(i.id));
            }
          },
          icon: const Icon(Icons.cancel_outlined),
          label: const Text('Annuler'),
        ),
      );
    }

    return Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: buttons);
  }
}

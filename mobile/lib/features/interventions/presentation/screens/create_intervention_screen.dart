import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/status_colors.dart';
import '../../../../shared/models/result.dart';
import '../../domain/entities/intervention_entity.dart';
import '../controllers/interventions_controller.dart';

/// SRS SCR-06 / FR-CRT-01..07 / BRULE-007.
class CreateInterventionScreen extends ConsumerStatefulWidget {
  const CreateInterventionScreen({super.key});

  @override
  ConsumerState<CreateInterventionScreen> createState() => _CreateInterventionScreenState();
}

class _CreateInterventionScreenState extends ConsumerState<CreateInterventionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _picker = ImagePicker();
  InterventionPriority _priorite = InterventionPriority.normale;
  final List<XFile> _attachments = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    // SRS §22 FILE-05: client-side recompression before upload, same as the
    // messaging composer (conversation_screen.dart).
    final picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1920, imageQuality: 80);
    if (picked != null && mounted) {
      if (_attachments.length >= 5) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Maximum 5 pièces jointes.')));
        return;
      }
      setState(() => _attachments.add(picked));
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);

    final controller = ref.read(interventionsControllerProvider.notifier);
    final created = await controller.create(
      titre: _titreController.text.trim(),
      description: _descriptionController.text.trim(),
      priorite: _priorite,
    );

    if (created == null) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Impossible de créer le ticket, vérifiez votre connexion.')));
      return;
    }

    // Attachments are a separate call per file (§17.2's endpoint takes one
    // file at a time) — the ticket itself already exists at this point
    // regardless of whether any of these succeed, so a partial failure here
    // is surfaced but doesn't roll back ticket creation.
    var attachmentFailures = 0;
    for (final file in _attachments) {
      final result = await controller.addAttachment(interventionId: created.id, filePath: file.path);
      if (!result.isSuccess) attachmentFailures++;
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (attachmentFailures > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket créé, mais $attachmentFailures pièce(s) jointe(s) n\'ont pas pu être envoyées.')),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle intervention')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Décrivez le problème rencontré', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Un technicien sera assigné dès que possible.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _titreController,
                maxLength: 150,
                decoration: const InputDecoration(
                  labelText: 'Titre de l\'intervention',
                  prefixIcon: Icon(Icons.title_outlined),
                ),
                validator: (v) {
                  if (v == null || v.length < 5) return 'Minimum 5 caractères';
                  if (v.length > 150) return 'Maximum 150 caractères';
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                maxLength: 3000,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Description détaillée',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (v) {
                  if (v == null || v.length < 10) return 'Minimum 10 caractères';
                  if (v.length > 3000) return 'Maximum 3000 caractères';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Priorité', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                children: InterventionPriority.values.map((p) {
                  final selected = _priorite == p;
                  return ChoiceChip(
                    avatar: Icon(Icons.flag_rounded, size: 16, color: p.color),
                    label: Text(_priorityLabel(p)),
                    selected: selected,
                    onSelected: (_) => setState(() => _priorite = p),
                    selectedColor: p.color.withValues(alpha: 0.15),
                    labelStyle: TextStyle(color: selected ? p.color : null, fontWeight: selected ? FontWeight.w700 : null),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Text('Pièces jointes', style: Theme.of(context).textTheme.titleSmall),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _isSubmitting ? null : _pickPhoto,
                    icon: const Icon(Icons.add_a_photo_outlined),
                    label: const Text('Ajouter'),
                  ),
                ],
              ),
              if (_attachments.isNotEmpty)
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _attachments.length,
                    separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
                    itemBuilder: (context, index) {
                      final file = _attachments[index];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                            child: Image.file(File(file.path), width: 80, height: 80, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => setState(() => _attachments.removeAt(index)),
                              child: const CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.black54,
                                child: Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Créer le ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _priorityLabel(InterventionPriority p) => switch (p) {
    InterventionPriority.basse => 'Basse',
    InterventionPriority.normale => 'Normale',
    InterventionPriority.haute => 'Haute',
  };
}

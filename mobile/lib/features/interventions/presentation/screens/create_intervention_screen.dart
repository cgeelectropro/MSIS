import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
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
  InterventionPriority _priorite = InterventionPriority.normale;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSubmitting = true);

    final success = await ref
        .read(interventionsControllerProvider.notifier)
        .create(
          titre: _titreController.text.trim(),
          description: _descriptionController.text.trim(),
          priorite: _priorite,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Impossible de créer le ticket, vérifiez votre connexion.')));
    }
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
              TextFormField(
                controller: _titreController,
                maxLength: 150,
                decoration: const InputDecoration(labelText: 'Titre de l\'intervention'),
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
                decoration: const InputDecoration(labelText: 'Description détaillée'),
                validator: (v) {
                  if (v == null || v.length < 10) return 'Minimum 10 caractères';
                  if (v.length > 3000) return 'Maximum 3000 caractères';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: InterventionPriority.values.map((p) {
                  return ChoiceChip(
                    label: Text(_priorityLabel(p)),
                    selected: _priorite == p,
                    onSelected: (_) => setState(() => _priorite = p),
                  );
                }).toList(),
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

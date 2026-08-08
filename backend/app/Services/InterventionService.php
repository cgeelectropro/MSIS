<?php

namespace App\Services;

use App\Enums\InterventionStatus;
use App\Enums\UserRole;
use App\Models\Intervention;
use App\Models\InterventionStatusHistory;
use App\Models\User;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

/**
 * SRS §14.2 Ticket Lifecycle Workflow. Every status write happens inside a
 * transaction that also writes the `intervention_status_history` row
 * (Gap Analysis D-20b) — see `recordTransition()`.
 */
class InterventionService
{
    public function __construct(
        private readonly AuditLogger $auditLogger,
        private readonly NotificationService $notifications
    ) {}

    /** SRS §9.5/BRULE-001: list is scoped by the caller's role. */
    public function list(User $user, ?InterventionStatus $status, ?string $search, ?string $priority): LengthAwarePaginator
    {
        return Intervention::query()
            ->when($user->isClient(), fn ($q) => $q->where('id_client', $user->id))
            ->when($user->isTechnicien(), fn ($q) => $q->where('id_technicien', $user->id))
            ->when($status, fn ($q) => $q->where('statut', $status))
            ->when($priority, fn ($q) => $q->where('priorite', $priority))
            ->when($search, fn ($q) => $q->where('titre', 'like', "%{$search}%"))
            ->orderByDesc('created_at')
            ->paginate(20); // SRS §18.5 D-21
    }

    /** SRS FR-CRT-01..07 / FR-CRT-09. */
    public function create(array $data, User $actor): Intervention
    {
        $clientId = $actor->isAdmin() ? $data['id_client'] : $actor->id;

        $intervention = Intervention::create([
            'titre' => $data['titre'],
            'description' => $data['description'],
            'priorite' => $data['priorite'] ?? 'NORMALE',
            'statut' => InterventionStatus::EnAttente,
            'id_client' => $clientId,
        ]);

        $this->recordTransition($intervention, null, InterventionStatus::EnAttente, $actor);

        // FR-CRT-07: notify every active Supervisor.
        $this->notifications->notifyAll(
            User::where('role', UserRole::Admin)->where('actif', true)->get(),
            'ticket_cree',
            "Nouveau ticket : {$intervention->titre}",
            $intervention->id_intervention
        );

        $this->auditLogger->log('intervention_created', $actor, entite: 'intervention', entiteId: $intervention->id_intervention);

        return $intervention;
    }

    /** SRS §14.3 Assignment Workflow / BRULE-016. */
    public function assign(Intervention $intervention, User $technicien, User $actor): Intervention
    {
        if (! $technicien->isTechnicien() || ! $technicien->actif) {
            throw ValidationException::withMessages([
                'id_technicien' => 'Ce technicien n\'est plus disponible.',
            ]);
        }

        $previousTechnicienId = $intervention->id_technicien;

        DB::transaction(function () use ($intervention, $technicien, $actor) {
            $wasWaiting = $intervention->statut === InterventionStatus::EnAttente;

            $intervention->update([
                'id_technicien' => $technicien->id,
                'statut' => $wasWaiting ? InterventionStatus::EnCours : $intervention->statut,
            ]);

            if ($wasWaiting) {
                $this->recordTransition($intervention, InterventionStatus::EnAttente, InterventionStatus::EnCours, $actor);
            }

            $this->auditLogger->log('intervention_assigned', $actor, entite: 'intervention', entiteId: $intervention->id_intervention);
        });

        $this->notifications->notify($technicien, 'intervention_assignee', "Mission assignée : {$intervention->titre}", $intervention->id_intervention);

        if ($previousTechnicienId && $previousTechnicienId !== $technicien->id) {
            $previous = User::find($previousTechnicienId);
            if ($previous) {
                $this->notifications->notify($previous, 'intervention_reassignee', "Réassignée : {$intervention->titre}", $intervention->id_intervention);
            }
        }

        return $intervention->fresh();
    }

    /** SRS FR-DET-02/BRULE-002/003 — state-machine legality already checked in UpdateInterventionStatusRequest, actor ownership already checked by InterventionPolicy::updateStatus. */
    public function updateStatus(Intervention $intervention, InterventionStatus $target, ?string $motifBlocage, ?string $rapportTechnique, User $actor): Intervention
    {
        if ($target === InterventionStatus::Bloque && blank($motifBlocage)) {
            throw ValidationException::withMessages(['motif_blocage' => 'Un motif est requis pour bloquer une intervention.']);
        }

        if ($target === InterventionStatus::Resolue && blank($rapportTechnique)) {
            throw ValidationException::withMessages(['rapport_technique' => 'Un rapport technique est requis.']);
        }

        $previous = $intervention->statut;

        DB::transaction(function () use ($intervention, $target, $motifBlocage, $rapportTechnique, $previous, $actor) {
            $intervention->update([
                'statut' => $target,
                'motif_blocage' => $target === InterventionStatus::Bloque ? $motifBlocage : $intervention->motif_blocage,
                'rapport_technique' => $target === InterventionStatus::Resolue ? $rapportTechnique : $intervention->rapport_technique,
            ]);

            $this->recordTransition($intervention, $previous, $target, $actor);
            $this->auditLogger->log('status_change', $actor, entite: 'intervention', entiteId: $intervention->id_intervention);
        });

        $this->notifications->notify(
            $intervention->client,
            'statut_modifie',
            "Statut mis à jour : {$intervention->titre} → {$target->labelFr()}",
            $intervention->id_intervention
        );

        return $intervention->fresh();
    }

    /** SRS UC-05 / BRULE-003. */
    public function close(Intervention $intervention, ?int $note, User $actor): Intervention
    {
        $previous = $intervention->statut;

        DB::transaction(function () use ($intervention, $note, $previous, $actor) {
            $intervention->update([
                'statut' => InterventionStatus::Cloturee,
                'note_satisfaction' => $note,
                'date_cloture' => now(),
            ]);

            $this->recordTransition($intervention, $previous, InterventionStatus::Cloturee, $actor);
            $this->auditLogger->log('intervention_closed', $actor, entite: 'intervention', entiteId: $intervention->id_intervention);
        });

        if ($intervention->technicien) {
            $this->notifications->notify($intervention->technicien, 'intervention_cloturee', "Clôturée : {$intervention->titre}", $intervention->id_intervention);
        }

        return $intervention->fresh();
    }

    /** SRS FR-CRT-08 (D-17). */
    public function cancel(Intervention $intervention, User $actor): Intervention
    {
        $previous = $intervention->statut;

        DB::transaction(function () use ($intervention, $previous, $actor) {
            $intervention->update(['statut' => InterventionStatus::Annulee]);
            $this->recordTransition($intervention, $previous, InterventionStatus::Annulee, $actor);
            $this->auditLogger->log('intervention_cancelled', $actor, entite: 'intervention', entiteId: $intervention->id_intervention);
        });

        return $intervention->fresh();
    }

    private function recordTransition(Intervention $intervention, ?InterventionStatus $from, InterventionStatus $to, User $actor): void
    {
        InterventionStatusHistory::create([
            'id_intervention' => $intervention->id_intervention,
            'ancien_statut' => $from,
            'nouveau_statut' => $to,
            'id_user' => $actor->id,
        ]);
    }
}

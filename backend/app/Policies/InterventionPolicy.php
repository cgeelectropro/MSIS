<?php

namespace App\Policies;

use App\Enums\InterventionStatus;
use App\Models\Intervention;
use App\Models\User;

/** SRS §19.2 / BRULE-001/002/003/005. */
class InterventionPolicy
{
    public function viewAny(User $user): bool
    {
        return true; // scoping to "own"/"assigned" happens in InterventionService::list, per role.
    }

    public function view(User $user, Intervention $intervention): bool
    {
        return $user->id === $intervention->id_client
            || $user->id === $intervention->id_technicien
            || $user->isAdmin();
    }

    /** SRS FR-CRT-09: a Supervisor may create on behalf of a client. */
    public function create(User $user): bool
    {
        return $user->isClient() || $user->isAdmin();
    }

    public function assign(User $user): bool
    {
        return $user->isAdmin();
    }

    /**
     * SRS BRULE-003: ownership AND transition legality. Ownership rule mirrors
     * §8.4 exactly — a Client may only ever trigger the terminal closure step
     * (handled separately by `close()`), a Technicien only their own assigned
     * tickets, an Admin anything.
     */
    public function updateStatus(User $user, Intervention $intervention, InterventionStatus $target): bool
    {
        if (! $intervention->statut->canTransitionTo($target)) {
            return false;
        }

        if ($user->isAdmin()) {
            return true;
        }

        if ($user->isTechnicien()) {
            return $user->id === $intervention->id_technicien
                && in_array($target, [InterventionStatus::EnCours, InterventionStatus::Bloque, InterventionStatus::Resolue], true);
        }

        return false; // Clients change status only via close()/cancel().
    }

    public function close(User $user, Intervention $intervention): bool
    {
        return $user->id === $intervention->id_client
            && $intervention->statut === InterventionStatus::Resolue;
    }

    /** SRS FR-CRT-08 (D-17). */
    public function cancel(User $user, Intervention $intervention): bool
    {
        return $user->id === $intervention->id_client
            && $intervention->statut === InterventionStatus::EnAttente;
    }
}

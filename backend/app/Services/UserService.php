<?php

namespace App\Services;

use App\Enums\InterventionStatus;
use App\Enums\UserRole;
use App\Models\Intervention;
use App\Models\User;
use App\Notifications\TechnicianInvitation;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** SRS §14.7 Administration Workflow / §9.6. */
class UserService
{
    public function __construct(private readonly AuditLogger $auditLogger) {}

    /** SRS FR-USR-01/06, pagination per §18.5 D-21 (20/page, offset-based). */
    public function list(?UserRole $role, ?string $search): LengthAwarePaginator
    {
        return User::query()
            ->when($role, fn ($q) => $q->where('role', $role))
            ->when(
                $search,
                fn ($q) => $q->where(
                    fn ($q) => $q->where('nom', 'like', "%{$search}%")->orWhere('email', 'like', "%{$search}%")
                )
            )
            ->orderBy('nom')
            ->paginate(20);
    }

    /** SRS FR-USR-05: Supervisor-created technician account with invitation email. */
    public function createTechnician(array $data, User $actor): User
    {
        $temporaryPassword = Str::password(12);

        $user = User::create([
            'nom' => $data['nom'],
            'email' => $data['email'],
            'password' => $temporaryPassword,
            'role' => UserRole::Technicien,
            'telephone' => $data['telephone'] ?? null,
            'actif' => true,
        ]);

        $user->notify(new TechnicianInvitation($temporaryPassword));
        $this->auditLogger->log('technician_created', $actor, entite: 'user', entiteId: $user->id);

        return $user;
    }

    /**
     * SRS FR-USR-03/04, BRULE-008/013. Deactivation is a single transaction:
     * revoke tokens, release un-started tickets, keep in-progress ones assigned
     * but access-revoked (the token revocation above already achieves that).
     */
    public function updateStatus(User $target, bool $active, User $actor): User
    {
        DB::transaction(function () use ($target, $active, $actor) {
            $target->update(['actif' => $active]);

            if (! $active) {
                $target->tokens()->delete(); // BRULE-013

                if ($target->role === UserRole::Technicien) {
                    Intervention::where('id_technicien', $target->id)
                        ->where('statut', InterventionStatus::EnAttente)
                        ->update(['id_technicien' => null]); // BRULE-008
                }
            }

            $this->auditLogger->log(
                $active ? 'account_activated' : 'account_deactivated',
                $actor,
                entite: 'user',
                entiteId: $target->id
            );
        });

        return $target->fresh();
    }

    public function updateProfile(User $user, array $data): User
    {
        $user->update(array_filter($data, fn ($v) => $v !== null));

        return $user->fresh();
    }

    public function updatePassword(User $user, string $newPassword): void
    {
        $user->forceFill(['password' => $newPassword])->save();
    }
}

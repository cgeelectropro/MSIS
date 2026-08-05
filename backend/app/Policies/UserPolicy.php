<?php

namespace App\Policies;

use App\Models\User;

/** SRS BRULE-005 RBAC matrix — "Manage user accounts": Admin only. */
class UserPolicy
{
    public function viewAny(User $user): bool
    {
        return $user->isAdmin();
    }

    public function create(User $user): bool
    {
        return $user->isAdmin();
    }

    public function updateStatus(User $user, User $target): bool
    {
        return $user->isAdmin();
    }

    /** SRS §9.2: a user may always view/edit their own profile. */
    public function viewProfile(User $user, User $target): bool
    {
        return $user->is($target) || $user->isAdmin();
    }

    public function updateProfile(User $user, User $target): bool
    {
        return $user->is($target);
    }
}

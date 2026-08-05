<?php

namespace App\Policies;

use App\Models\Intervention;
use App\Models\Message;
use App\Models\User;

/**
 * SRS §19.2 MessagePolicy / BRULE-004: mirrors InterventionPolicy::view at
 * the parent-ticket level. Admin access is read-only audit (enforced in
 * MessageService::send / MessageController, not here — `view` intentionally
 * allows Admin so audit reads succeed; `send` explicitly excludes Admin).
 */
class MessagePolicy
{
    public function viewConversation(User $user, Intervention $intervention): bool
    {
        return $user->id === $intervention->id_client
            || $user->id === $intervention->id_technicien
            || $user->isAdmin();
    }

    /** SRS BRULE-017: no client/technicien beyond CLOTUREE; Admin never sends (audit is read-only). */
    public function send(User $user, Intervention $intervention): bool
    {
        if ($user->isAdmin()) {
            return false;
        }

        $isParty = $user->id === $intervention->id_client || $user->id === $intervention->id_technicien;

        return $isParty && ! in_array($intervention->statut->value, ['CLOTUREE', 'ANNULEE'], true);
    }

    public function view(User $user, Message $message): bool
    {
        return $this->viewConversation($user, $message->intervention);
    }
}

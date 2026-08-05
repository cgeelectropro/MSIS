<?php

namespace App\Services;

use App\Enums\NotificationChannel;
use App\Models\AppNotification;
use App\Models\User;

/**
 * SRS §20/§14.5. Single dispatch point for both the in-app feed (`notifications`
 * table, SCR-14) and push (FCM, via PushNotificationService) — every call site
 * (InterventionService's create/assign/status-change triggers, the messaging
 * listener) gets both channels automatically rather than each caller having to
 * remember to invoke two services.
 */
class NotificationService
{
    public function __construct(private readonly PushNotificationService $push) {}

    public function notify(User $recipient, string $type, string $content, ?int $interventionId = null): void
    {
        AppNotification::create([
            'id_user' => $recipient->id,
            'type' => $type,
            'canal' => NotificationChannel::InApp,
            'contenu' => $content,
            'id_intervention' => $interventionId,
        ]);

        $this->push->sendToUser($recipient, 'MSIS', $content, [
            'type' => $type,
            'id_intervention' => $interventionId !== null ? (string) $interventionId : '',
        ]);
    }

    public function notifyAll(iterable $recipients, string $type, string $content, ?int $interventionId = null): void
    {
        foreach ($recipients as $recipient) {
            $this->notify($recipient, $type, $content, $interventionId);
        }
    }
}

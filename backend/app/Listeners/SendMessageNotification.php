<?php

namespace App\Listeners;

use App\Events\MessageSent;
use App\Models\User;
use App\Services\NotificationService;
use Illuminate\Contracts\Queue\ShouldQueue;

/**
 * SRS §14.5/§20.2 "Nouveau message reçu" trigger. Queued so notification
 * fan-out never adds latency to the message-send request/response cycle
 * (NFR-PERF-01). NotificationService itself fans out to both the in-app feed
 * and push (FCM) — this listener only resolves who the recipient is.
 */
class SendMessageNotification implements ShouldQueue
{
    public function __construct(private readonly NotificationService $notifications) {}

    public function handle(MessageSent $event): void
    {
        $message = $event->message;
        $intervention = $message->intervention;

        $recipientId = $message->id_expediteur === $intervention->id_client
            ? $intervention->id_technicien
            : $intervention->id_client;

        if (! $recipientId) {
            return;
        }

        $recipient = User::find($recipientId);
        if (! $recipient) {
            return;
        }

        $this->notifications->notify(
            $recipient,
            'nouveau_message',
            "Nouveau message : {$intervention->titre}",
            $intervention->id_intervention
        );
    }
}

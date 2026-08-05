<?php

namespace App\Services;

use App\Events\MessageRead;
use App\Events\MessageSent;
use App\Models\Intervention;
use App\Models\Message;
use App\Models\PieceJointe;
use App\Models\User;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;

/**
 * SRS §14.4 Messaging Workflow. `Message::contenu` is encrypted at rest via
 * the model's `encrypted` cast (SEC-25) — this Service never handles
 * encryption directly, it just persists through Eloquent as normal.
 */
class MessageService
{
    public function __construct(private readonly AuditLogger $auditLogger) {}

    /** SRS §18.5 GET /interventions/{id}/messages, paginated per D-21. */
    public function list(Intervention $intervention): LengthAwarePaginator
    {
        return $intervention->messages()
            ->with(['expediteur', 'attachments'])
            ->orderBy('created_at')
            ->paginate(20);
    }

    public function send(Intervention $intervention, User $sender, ?string $contenu, ?UploadedFile $attachment): Message
    {
        return DB::transaction(function () use ($intervention, $sender, $contenu, $attachment) {
            $message = Message::create([
                'id_intervention' => $intervention->id_intervention,
                'id_expediteur' => $sender->id,
                'contenu' => $contenu ?? '',
            ]);

            if ($attachment) {
                $path = $attachment->store('messages/'.$intervention->id_intervention, 'local');

                PieceJointe::create([
                    'id_message' => $message->id_message,
                    'chemin_fichier' => $path,
                    'type_mime' => $attachment->getMimeType(),
                    'taille_octets' => $attachment->getSize(),
                    'uploaded_by' => $sender->id,
                ]);
            }

            $message->load(['expediteur', 'attachments']);

            broadcast(new MessageSent($message))->toOthers();

            return $message;
        });
    }

    /** SRS FR-DET-07 "seen" indicator. */
    public function markSeen(Message $message, User $reader): Message
    {
        if (! $message->lu && $message->id_expediteur !== $reader->id) {
            $message->update(['lu' => true, 'lu_at' => now()]);
            broadcast(new MessageRead($message))->toOthers();
        }

        return $message;
    }

    /** SRS §18.5 GET /messages/unread — count across all of the user's active conversations. */
    public function unreadCount(User $user): int
    {
        return Message::query()
            ->whereHas('intervention', function ($q) use ($user) {
                $q->where('id_client', $user->id)->orWhere('id_technicien', $user->id);
            })
            ->where('id_expediteur', '!=', $user->id)
            ->where('lu', false)
            ->count();
    }

    /** SRS §20.3: every Admin audit-mode read is logged. */
    public function logAuditRead(Intervention $intervention, User $admin): void
    {
        $this->auditLogger->log('message_audit_read', $admin, entite: 'intervention', entiteId: $intervention->id_intervention);
    }
}

<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Message\SendMessageRequest;
use App\Http\Resources\MessageResource;
use App\Models\Intervention;
use App\Models\Message;
use App\Services\MessageService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/** SRS §18.5 Messaging routes / §14.4. */
class MessageController extends Controller
{
    public function __construct(private readonly MessageService $messageService) {}

    public function index(Request $request, Intervention $intervention): mixed
    {
        $this->authorize('viewConversation', [Message::class, $intervention]);

        if ($request->user()->isAdmin()) {
            $this->messageService->logAuditRead($intervention, $request->user()); // SRS §20.3
        }

        return MessageResource::collection($this->messageService->list($intervention));
    }

    public function store(SendMessageRequest $request, Intervention $intervention): JsonResponse
    {
        $message = $this->messageService->send(
            $intervention,
            $request->user(),
            $request->string('contenu')->toString() ?: null,
            $request->file('attachment')
        );

        return (new MessageResource($message))->response()->setStatusCode(201);
    }

    public function markSeen(Request $request, Message $message): MessageResource
    {
        $this->authorize('view', $message);

        return new MessageResource($this->messageService->markSeen($message, $request->user()));
    }

    public function unread(Request $request): JsonResponse
    {
        return response()->json(['count' => $this->messageService->unreadCount($request->user())]);
    }
}

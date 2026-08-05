<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\NotificationResource;
use App\Models\AppNotification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/** SRS §18.5 Notifications table / SCR-14. */
class NotificationController extends Controller
{
    public function index(Request $request): mixed
    {
        $notifications = AppNotification::where('id_user', $request->user()->id)
            ->orderBy('lu') // unread (false=0) first, per §18.5 "non lues en premier"
            ->orderByDesc('created_at')
            ->paginate(20);

        return NotificationResource::collection($notifications);
    }

    public function markRead(Request $request, AppNotification $notification): NotificationResource
    {
        abort_unless($notification->id_user === $request->user()->id, 403);

        $notification->update(['lu' => true]);

        return new NotificationResource($notification);
    }

    /** Engineering Recommendation: bulk "mark all read," a standard notification-feed affordance. */
    public function markAllRead(Request $request): JsonResponse
    {
        AppNotification::where('id_user', $request->user()->id)->where('lu', false)->update(['lu' => true]);

        return response()->json(['message' => 'Toutes les notifications ont été marquées comme lues.']);
    }
}

<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\DeviceToken;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * Engineering Recommendation: FCM device-token registration, supporting SRS
 * §18.4's multi-device session model — a user's push notifications follow
 * every device they're logged in on, not just the most recent one.
 */
class DeviceTokenController extends Controller
{
    public function register(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'token' => ['required', 'string', 'max:255'],
            'platform' => ['sometimes', 'string', 'in:android,ios'],
        ]);

        DeviceToken::updateOrCreate(
            ['token' => $validated['token']],
            ['id_user' => $request->user()->id, 'platform' => $validated['platform'] ?? 'android']
        );

        return response()->json(['message' => 'Appareil enregistré.'], 201);
    }

    public function unregister(Request $request): JsonResponse
    {
        $validated = $request->validate(['token' => ['required', 'string']]);

        DeviceToken::where('id_user', $request->user()->id)->where('token', $validated['token'])->delete();

        return response()->json(['message' => 'Appareil désenregistré.']);
    }
}

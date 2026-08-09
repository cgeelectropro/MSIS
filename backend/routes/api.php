<?php

use App\Http\Controllers\Api\V1\AttachmentController;
use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\DeviceTokenController;
use App\Http\Controllers\Api\V1\InterventionController;
use App\Http\Controllers\Api\V1\MessageController;
use App\Http\Controllers\Api\V1\NotificationController;
use App\Http\Controllers\Api\V1\ProfileController;
use App\Http\Controllers\Api\V1\ReportController;
use App\Http\Controllers\Api\V1\UserController;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\Route;

/**
 * SRS §18.5 Data Access Contract. Every route is prefixed /api/v1, per the SRS's
 * base-path convention (production domain itself is D-02, pending).
 */
Route::prefix('v1')->group(function () {

    // --- Authentication (SRS §18.5 "Authentication" table) ---
    Route::prefix('auth')->group(function () {
        Route::post('register', [AuthController::class, 'register'])
            ->middleware('throttle:20,60'); // generic abuse guard; login has its own stricter limit below

        Route::post('login', [AuthController::class, 'login'])
            ->middleware('throttle:5,15'); // BRULE-014

        Route::post('forgot-password', [AuthController::class, 'forgotPassword'])
            ->middleware('throttle:3,60'); // BRULE-014

        Route::post('reset-password', [AuthController::class, 'resetPassword'])
            ->middleware('throttle:5,60');

        Route::middleware('auth:sanctum')->group(function () {
            Route::post('logout', [AuthController::class, 'logout']);
            Route::post('logout-all', [AuthController::class, 'logoutAllDevices']); // FR-AUTH-09
            Route::post('refresh', [AuthController::class, 'refresh']); // SEC-22
            Route::get('me', [AuthController::class, 'me']);
        });
    });

    // --- Users & Profile (SRS §18.5 "Users" table / §9.6) ---
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('users', [UserController::class, 'index'])->middleware('role:ADMIN');
        Route::post('users', [UserController::class, 'store'])->middleware('role:ADMIN');
        Route::patch('users/{user}/statut', [UserController::class, 'updateStatus'])->middleware('role:ADMIN');

        Route::get('profile', [ProfileController::class, 'show']);
        Route::patch('profile', [ProfileController::class, 'update']);
        Route::patch('profile/password', [ProfileController::class, 'updatePassword']);
    });

    // --- Interventions (SRS §18.5 "Interventions" table / §9.3-9.4) ---
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('interventions', [InterventionController::class, 'index']);
        Route::post('interventions', [InterventionController::class, 'store'])
            ->middleware('throttle:20,60'); // BRULE-014
        Route::get('interventions/{intervention}', [InterventionController::class, 'show']);
        Route::post('interventions/{intervention}/pieces-jointes', [InterventionController::class, 'storeAttachment']); // §17.2/FR-CRT-04
        Route::patch('interventions/{intervention}/statut', [InterventionController::class, 'updateStatus']);
        Route::patch('interventions/{intervention}/assigner', [InterventionController::class, 'assign']);
        Route::patch('interventions/{intervention}/cloturer', [InterventionController::class, 'close']);
        Route::patch('interventions/{intervention}/annuler', [InterventionController::class, 'cancel']); // D-17
    });

    // --- Messaging (SRS §18.5 "Messagerie" table / §14.4 / §20-21) ---
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('interventions/{intervention}/messages', [MessageController::class, 'index']);
        Route::post('interventions/{intervention}/messages', [MessageController::class, 'store'])
            ->middleware('throttle:60,1'); // BRULE-014
        Route::patch('messages/{message}/seen', [MessageController::class, 'markSeen']);
        Route::get('messages/unread', [MessageController::class, 'unread']);

        // SRS §21.1: Reverb (Pusher-protocol) channel authorization for the
        // mobile client's WSS connection. Sanctum-guarded since this API has
        // no session/cookie auth to fall back on.
        Broadcast::routes(['middleware' => ['auth:sanctum']]);
    });

    // --- Notifications (SRS §18.5 "Notifications et rapports" table / §20) ---
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('notifications', [NotificationController::class, 'index']);
        Route::patch('notifications/{notification}/lu', [NotificationController::class, 'markRead']);
        Route::patch('notifications/read-all', [NotificationController::class, 'markAllRead']); // Engineering Recommendation

        Route::post('device/register', [DeviceTokenController::class, 'register']);
        Route::delete('device/unregister', [DeviceTokenController::class, 'unregister']);
    });

    // --- Reports (SRS §18.5 "Notifications et rapports" table / §19/§23) ---
    Route::middleware(['auth:sanctum', 'role:ADMIN'])->group(function () {
        Route::get('reports/dashboard', [ReportController::class, 'dashboard']);
        Route::get('reports/export', [ReportController::class, 'export']);
    });

    // SRS §22 FILE-09: signed, time-limited attachment download — auth is the
    // signature itself (see AttachmentController), not a bearer token.
    Route::get('attachments/{pieceJointe}', [AttachmentController::class, 'download'])
        ->middleware('signed')
        ->name('attachments.download');

    // Health check — SRS §18.5 "Operational" table / DEP-08. Kept separate from the
    // framework's own /up probe so the documented API-contract path is real.
    Route::get('health', fn () => response()->json(['status' => 'ok']));
});

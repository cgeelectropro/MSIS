<?php

use App\Models\AppNotification;
use App\Models\DeviceToken;
use App\Models\User;
use App\Services\NotificationService;

// SRS §18.5 GET /notifications — a user only ever sees their own.
test('a user only sees their own notifications', function () {
    $user = User::factory()->create();
    $other = User::factory()->create();
    AppNotification::create(['id_user' => $user->id, 'type' => 'nouveau_message', 'canal' => 'in_app', 'contenu' => 'mine']);
    AppNotification::create(['id_user' => $other->id, 'type' => 'nouveau_message', 'canal' => 'in_app', 'contenu' => 'not mine']);

    $response = $this->actingAs($user, 'sanctum')->getJson('/api/v1/notifications');

    $response->assertOk();
    expect($response->json('data'))->toHaveCount(1);
    expect($response->json('data.0.contenu'))->toBe('mine');
});

test('unread notifications are ordered first', function () {
    $user = User::factory()->create();
    AppNotification::create(['id_user' => $user->id, 'type' => 'x', 'canal' => 'in_app', 'contenu' => 'old read', 'lu' => true]);
    AppNotification::create(['id_user' => $user->id, 'type' => 'x', 'canal' => 'in_app', 'contenu' => 'new unread', 'lu' => false]);

    $response = $this->actingAs($user, 'sanctum')->getJson('/api/v1/notifications');

    expect($response->json('data.0.contenu'))->toBe('new unread');
});

test('a user cannot mark another user\'s notification as read', function () {
    $owner = User::factory()->create();
    $stranger = User::factory()->create();
    $notification = AppNotification::create(['id_user' => $owner->id, 'type' => 'x', 'canal' => 'in_app', 'contenu' => 'x']);

    $this->actingAs($stranger, 'sanctum')
        ->patchJson("/api/v1/notifications/{$notification->id}/lu")
        ->assertForbidden();
});

test('marking a notification read sets lu to true', function () {
    $user = User::factory()->create();
    $notification = AppNotification::create(['id_user' => $user->id, 'type' => 'x', 'canal' => 'in_app', 'contenu' => 'x']);

    $this->actingAs($user, 'sanctum')
        ->patchJson("/api/v1/notifications/{$notification->id}/lu")
        ->assertOk()
        ->assertJsonPath('data.lu', true);
});

test('mark-all-read only affects the requesting user\'s notifications', function () {
    $user = User::factory()->create();
    $other = User::factory()->create();
    AppNotification::create(['id_user' => $user->id, 'type' => 'x', 'canal' => 'in_app', 'contenu' => 'a']);
    AppNotification::create(['id_user' => $user->id, 'type' => 'x', 'canal' => 'in_app', 'contenu' => 'b']);
    $otherNotification = AppNotification::create(['id_user' => $other->id, 'type' => 'x', 'canal' => 'in_app', 'contenu' => 'c']);

    $this->actingAs($user, 'sanctum')->patchJson('/api/v1/notifications/read-all')->assertOk();

    expect(AppNotification::where('id_user', $user->id)->where('lu', false)->count())->toBe(0);
    expect($otherNotification->fresh()->lu)->toBeFalse();
});

// Engineering Recommendation: FCM device-token registration (SRS §18.4 multi-device model).
test('registering a device token stores it against the authenticated user', function () {
    $user = User::factory()->create();

    $this->actingAs($user, 'sanctum')
        ->postJson('/api/v1/device/register', ['token' => 'fcm-token-123', 'platform' => 'android'])
        ->assertCreated();

    expect(DeviceToken::where('id_user', $user->id)->where('token', 'fcm-token-123')->exists())->toBeTrue();
});

test('registering the same token twice updates ownership instead of duplicating', function () {
    $userA = User::factory()->create();
    $userB = User::factory()->create();

    $this->actingAs($userA, 'sanctum')->postJson('/api/v1/device/register', ['token' => 'shared-device']);
    $this->actingAs($userB, 'sanctum')->postJson('/api/v1/device/register', ['token' => 'shared-device']);

    expect(DeviceToken::where('token', 'shared-device')->count())->toBe(1);
    expect(DeviceToken::where('token', 'shared-device')->first()->id_user)->toBe($userB->id);
});

test('unregistering a device token removes it', function () {
    $user = User::factory()->create();
    DeviceToken::create(['id_user' => $user->id, 'token' => 'to-remove', 'platform' => 'android']);

    $this->actingAs($user, 'sanctum')
        ->deleteJson('/api/v1/device/unregister', ['token' => 'to-remove'])
        ->assertOk();

    expect(DeviceToken::where('token', 'to-remove')->exists())->toBeFalse();
});

// SRS §14.5: NotificationService fans out to both in-app and (safely no-op
// without FCM credentials) push from a single call site.
test('NotificationService::notify writes an in-app row without throwing when FCM is unconfigured', function () {
    $user = User::factory()->create();

    app(NotificationService::class)->notify($user, 'nouveau_message', 'Test message', null);

    expect(AppNotification::where('id_user', $user->id)->where('contenu', 'Test message')->exists())->toBeTrue();
});

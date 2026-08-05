<?php

use App\Models\User;

// SRS AC-04 / TR: expired or missing token rejected with 401.
test('an unauthenticated request to a protected route is rejected', function () {
    $this->getJson('/api/v1/auth/me')->assertUnauthorized();
});

test('me returns the authenticated user profile', function () {
    $user = User::factory()->create();

    $this->actingAs($user, 'sanctum')
        ->getJson('/api/v1/auth/me')
        ->assertOk()
        ->assertJsonPath('data.email', $user->email);
});

// SRS FR-AUTH-09: standard logout revokes only the current device's token.
test('logout revokes the current token', function () {
    $user = User::factory()->create();
    $token = $user->createToken('mobile')->plainTextToken;

    $response = $this->withHeader('Authorization', "Bearer $token")
        ->postJson('/api/v1/auth/logout');

    $response->assertOk();
    expect($user->tokens()->count())->toBe(0);
});

// SRS FR-AUTH-09: "log out of all devices" revokes every token.
test('logout-all revokes every token for the account', function () {
    $user = User::factory()->create();
    $user->createToken('device-1');
    $tokenB = $user->createToken('device-2')->plainTextToken;

    $response = $this->withHeader('Authorization', "Bearer $tokenB")
        ->postJson('/api/v1/auth/logout-all');

    $response->assertOk();
    expect($user->fresh()->tokens()->count())->toBe(0);
});

// SRS SEC-22: refresh revokes the presented token and issues a new one.
test('refresh issues a new token and invalidates the old one', function () {
    $user = User::factory()->create();
    $oldToken = $user->createToken('mobile')->plainTextToken;

    $response = $this->withHeader('Authorization', "Bearer $oldToken")
        ->postJson('/api/v1/auth/refresh');

    $response->assertOk()->assertJsonStructure(['token']);
    expect($response->json('token'))->not->toBe($oldToken);

    // Sanctum's guard is memoized per-container across sequential test requests;
    // force re-resolution so this second call actually re-authenticates against
    // the (now-deleted) old token instead of reusing the first call's cached user.
    $this->app['auth']->forgetGuards();

    $this->withHeader('Authorization', "Bearer $oldToken")
        ->getJson('/api/v1/auth/me')
        ->assertUnauthorized();
});

<?php

use App\Enums\UserRole;
use App\Models\User;

// SRS TR-01/AC-01
test('login with valid credentials and matching role returns a token', function () {
    $user = User::factory()->create(['password' => 'Password123!']);

    $response = $this->postJson('/api/v1/auth/login', [
        'email' => $user->email,
        'password' => 'Password123!',
        'role' => UserRole::Client->value,
    ]);

    $response->assertOk()->assertJsonStructure(['token', 'user' => ['id', 'email', 'role']]);
});

// SRS TR-02/AC generic-error rule (BRULE-015)
test('login with an incorrect password returns a generic error', function () {
    $user = User::factory()->create(['password' => 'Password123!']);

    $response = $this->postJson('/api/v1/auth/login', [
        'email' => $user->email,
        'password' => 'wrong-password',
        'role' => UserRole::Client->value,
    ]);

    $response->assertStatus(422);
    expect($response->json('errors.email.0'))->toBe('Email ou mot de passe incorrect.');
});

// SRS FR-AUTH-06: server re-verifies the selected role, never trusts the client.
test('login rejects a role mismatch with the same generic message', function () {
    $user = User::factory()->create(['password' => 'Password123!']); // CLIENT by default

    $response = $this->postJson('/api/v1/auth/login', [
        'email' => $user->email,
        'password' => 'Password123!',
        'role' => UserRole::Admin->value,
    ]);

    $response->assertStatus(422);
    expect($response->json('errors.email.0'))->toBe('Email ou mot de passe incorrect.');
});

// SRS TR-03
test('login on a disabled account is explicitly rejected', function () {
    $user = User::factory()->inactive()->create(['password' => 'Password123!']);

    $response = $this->postJson('/api/v1/auth/login', [
        'email' => $user->email,
        'password' => 'Password123!',
        'role' => UserRole::Client->value,
    ]);

    $response->assertForbidden();
});

// SRS FR-AUTH-07 / BRULE-014: 5 attempts / 15 minutes.
test('login is rate limited after repeated failures', function () {
    $user = User::factory()->create(['password' => 'Password123!']);

    for ($i = 0; $i < 5; $i++) {
        $this->postJson('/api/v1/auth/login', [
            'email' => $user->email,
            'password' => 'wrong',
            'role' => UserRole::Client->value,
        ]);
    }

    $response = $this->postJson('/api/v1/auth/login', [
        'email' => $user->email,
        'password' => 'wrong',
        'role' => UserRole::Client->value,
    ]);

    $response->assertStatus(429);
});

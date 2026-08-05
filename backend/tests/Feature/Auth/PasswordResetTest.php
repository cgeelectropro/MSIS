<?php

use App\Models\User;
use Illuminate\Support\Facades\Password;

// SRS BRULE-015: identical response whether or not the account exists.
test('forgot-password returns the same response for an existing and a non-existing email', function () {
    $user = User::factory()->create();

    $existing = $this->postJson('/api/v1/auth/forgot-password', ['email' => $user->email]);
    $nonExisting = $this->postJson('/api/v1/auth/forgot-password', ['email' => 'nobody@example.com']);

    expect($existing->status())->toBe($nonExisting->status());
    expect($existing->json('message'))->toBe($nonExisting->json('message'));
});

// SRS §18.2: successful reset revokes every existing token for the account.
test('resetting the password revokes all existing tokens', function () {
    $user = User::factory()->create();
    $user->createToken('mobile');
    expect($user->tokens()->count())->toBe(1);

    $token = Password::createToken($user);

    $response = $this->postJson('/api/v1/auth/reset-password', [
        'token' => $token,
        'email' => $user->email,
        'password' => 'NewPassword123!',
        'password_confirmation' => 'NewPassword123!',
    ]);

    $response->assertOk();
    expect($user->fresh()->tokens()->count())->toBe(0);
});

test('resetting the password with an invalid token fails', function () {
    $user = User::factory()->create();

    $response = $this->postJson('/api/v1/auth/reset-password', [
        'token' => 'not-a-real-token',
        'email' => $user->email,
        'password' => 'NewPassword123!',
        'password_confirmation' => 'NewPassword123!',
    ]);

    $response->assertStatus(422);
});

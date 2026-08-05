<?php

use App\Enums\UserRole;
use App\Models\User;

// SRS FR-AUTH-11 (D-01)
test('client self-registration creates a CLIENT account regardless of any submitted role', function () {
    $response = $this->postJson('/api/v1/auth/register', [
        'nom' => 'Jean Dupont',
        'email' => 'jean@example.com',
        'password' => 'Password123!',
        'password_confirmation' => 'Password123!',
        'role' => 'ADMIN', // must be ignored — see AuthService::register
    ]);

    $response->assertCreated();

    $user = User::where('email', 'jean@example.com')->firstOrFail();
    expect($user->role)->toBe(UserRole::Client);
});

test('registration enforces the password complexity policy', function () {
    $response = $this->postJson('/api/v1/auth/register', [
        'nom' => 'Jean Dupont',
        'email' => 'jean2@example.com',
        'password' => 'weak',
        'password_confirmation' => 'weak',
    ]);

    $response->assertStatus(422)->assertJsonValidationErrors('password');
});

test('registration rejects a duplicate email', function () {
    User::factory()->create(['email' => 'taken@example.com']);

    $response = $this->postJson('/api/v1/auth/register', [
        'nom' => 'Jean Dupont',
        'email' => 'taken@example.com',
        'password' => 'Password123!',
        'password_confirmation' => 'Password123!',
    ]);

    $response->assertStatus(422)->assertJsonValidationErrors('email');
});

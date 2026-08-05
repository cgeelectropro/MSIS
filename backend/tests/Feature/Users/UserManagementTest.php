<?php

use App\Enums\InterventionStatus;
use App\Enums\UserRole;
use App\Models\Intervention;
use App\Models\User;
use App\Notifications\TechnicianInvitation;
use Illuminate\Support\Facades\Notification;

// SRS BRULE-005: only Admin may list accounts.
test('a non-admin cannot list users', function () {
    $client = User::factory()->create();

    $this->actingAs($client, 'sanctum')->getJson('/api/v1/users')->assertForbidden();
});

test('an admin can list users filtered by role', function () {
    $admin = User::factory()->admin()->create();
    User::factory()->technicien()->count(2)->create();
    User::factory()->count(3)->create(); // clients

    $response = $this->actingAs($admin, 'sanctum')->getJson('/api/v1/users?role=TECHNICIEN');

    $response->assertOk();
    expect($response->json('data'))->toHaveCount(2);
});

// SRS FR-USR-05
test('an admin can create a technician account and an invitation is sent', function () {
    Notification::fake();
    $admin = User::factory()->admin()->create();

    $response = $this->actingAs($admin, 'sanctum')->postJson('/api/v1/users', [
        'nom' => 'Paul Technicien',
        'email' => 'paul@example.com',
        'telephone' => '+237600000000',
    ]);

    $response->assertCreated();
    $technicien = User::where('email', 'paul@example.com')->firstOrFail();
    expect($technicien->role)->toBe(UserRole::Technicien);
    expect($technicien->actif)->toBeTrue();
    Notification::assertSentTo($technicien, TechnicianInvitation::class);
});

test('a non-admin cannot create a technician account', function () {
    $client = User::factory()->create();

    $this->actingAs($client, 'sanctum')->postJson('/api/v1/users', [
        'nom' => 'Paul Technicien',
        'email' => 'paul2@example.com',
    ])->assertForbidden();
});

// SRS FR-USR-03/BRULE-013
test('deactivating an account revokes all of its tokens', function () {
    $admin = User::factory()->admin()->create();
    $technicien = User::factory()->technicien()->create();
    $technicien->createToken('mobile');

    $this->actingAs($admin, 'sanctum')
        ->patchJson("/api/v1/users/{$technicien->id}/statut", ['actif' => false])
        ->assertOk();

    expect($technicien->fresh()->actif)->toBeFalse();
    expect($technicien->fresh()->tokens()->count())->toBe(0);
});

// SRS FR-USR-04/BRULE-008
test('deactivating a technician releases their un-started tickets but keeps in-progress ones assigned', function () {
    $admin = User::factory()->admin()->create();
    $technicien = User::factory()->technicien()->create();
    $client = User::factory()->create();

    $pending = Intervention::create([
        'titre' => 'Ticket en attente',
        'description' => str_repeat('a', 20),
        'statut' => InterventionStatus::EnAttente,
        'id_client' => $client->id,
        'id_technicien' => $technicien->id,
    ]);
    $inProgress = Intervention::create([
        'titre' => 'Ticket en cours',
        'description' => str_repeat('a', 20),
        'statut' => InterventionStatus::EnCours,
        'id_client' => $client->id,
        'id_technicien' => $technicien->id,
    ]);

    $this->actingAs($admin, 'sanctum')
        ->patchJson("/api/v1/users/{$technicien->id}/statut", ['actif' => false])
        ->assertOk();

    expect($pending->fresh()->id_technicien)->toBeNull();
    expect($inProgress->fresh()->id_technicien)->toBe($technicien->id);
});

// SRS §9.2
test('a user can view and update their own profile', function () {
    $user = User::factory()->create(['nom' => 'Old Name']);

    $this->actingAs($user, 'sanctum')
        ->patchJson('/api/v1/profile', ['nom' => 'New Name'])
        ->assertOk()
        ->assertJsonPath('data.nom', 'New Name');
});

// SRS FR-AUTH-10
test('changing password requires the correct current password', function () {
    $user = User::factory()->create(['password' => 'Password123!']);

    $this->actingAs($user, 'sanctum')->patchJson('/api/v1/profile/password', [
        'current_password' => 'wrong',
        'password' => 'NewPassword123!',
        'password_confirmation' => 'NewPassword123!',
    ])->assertStatus(422)->assertJsonValidationErrors('current_password');
});

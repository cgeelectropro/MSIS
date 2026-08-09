<?php

use App\Enums\InterventionStatus;
use App\Models\AppNotification;
use App\Models\Intervention;
use App\Models\PieceJointe;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

function makeIntervention(array $overrides = []): Intervention
{
    return Intervention::create(array_merge([
        'titre' => 'Ecran bleu au démarrage',
        'description' => str_repeat('a', 20),
        'statut' => InterventionStatus::EnAttente,
        'priorite' => 'NORMALE',
        'id_client' => User::factory()->create()->id,
    ], $overrides));
}

// SRS AC-05
test('a client can create a ticket which starts EN_ATTENTE', function () {
    $client = User::factory()->create();

    $response = $this->actingAs($client, 'sanctum')->postJson('/api/v1/interventions', [
        'titre' => 'Ecran bleu au démarrage',
        'description' => 'Le poste affiche un écran bleu depuis ce matin.',
        'priorite' => 'HAUTE',
    ]);

    $response->assertCreated()->assertJsonPath('data.statut', 'EN_ATTENTE');
});

// SRS AC-06 / BRULE-007
test('ticket creation enforces title and description length limits', function () {
    $client = User::factory()->create();

    $this->actingAs($client, 'sanctum')->postJson('/api/v1/interventions', [
        'titre' => 'abc', // too short
        'description' => 'short',
    ])->assertStatus(422)->assertJsonValidationErrors(['titre', 'description']);
});

// SRS FR-CRT-07
test('creating a ticket notifies every active supervisor in-app', function () {
    $client = User::factory()->create();
    $admin = User::factory()->admin()->create();

    $this->actingAs($client, 'sanctum')->postJson('/api/v1/interventions', [
        'titre' => 'Ecran bleu au démarrage',
        'description' => 'Le poste affiche un écran bleu depuis ce matin.',
    ])->assertCreated();

    expect(AppNotification::where('id_user', $admin->id)->where('type', 'ticket_cree')->exists())->toBeTrue();
});

// SRS BRULE-001: a client only sees their own tickets.
test('a client cannot view another clients ticket', function () {
    $owner = User::factory()->create();
    $intruder = User::factory()->create();
    $intervention = makeIntervention(['id_client' => $owner->id]);

    $this->actingAs($intruder, 'sanctum')
        ->getJson("/api/v1/interventions/{$intervention->id_intervention}")
        ->assertForbidden();
});

// SRS AC-07 / UC-03
test('assigning a technician to a pending ticket moves it to EN_COURS', function () {
    $admin = User::factory()->admin()->create();
    $technicien = User::factory()->technicien()->create();
    $intervention = makeIntervention();

    $response = $this->actingAs($admin, 'sanctum')
        ->patchJson("/api/v1/interventions/{$intervention->id_intervention}/assigner", [
            'id_technicien' => $technicien->id,
        ]);

    $response->assertOk()->assertJsonPath('data.statut', 'EN_COURS');
    expect($intervention->fresh()->id_technicien)->toBe($technicien->id);
});

test('a non-admin cannot assign a technician', function () {
    $technicien = User::factory()->technicien()->create();
    $other = User::factory()->technicien()->create();
    $intervention = makeIntervention();

    $this->actingAs($technicien, 'sanctum')
        ->patchJson("/api/v1/interventions/{$intervention->id_intervention}/assigner", [
            'id_technicien' => $other->id,
        ])->assertForbidden();
});

// SRS TR-05: a technician cannot act on a ticket not assigned to them.
test('a technician cannot change the status of a ticket not assigned to them', function () {
    $technicien = User::factory()->technicien()->create();
    $intervention = makeIntervention(['statut' => InterventionStatus::EnCours, 'id_technicien' => User::factory()->technicien()->create()->id]);

    $this->actingAs($technicien, 'sanctum')
        ->patchJson("/api/v1/interventions/{$intervention->id_intervention}/statut", ['statut' => 'RESOLUE', 'rapport_technique' => 'x'])
        ->assertForbidden();
});

// SRS §6.6/§8.3/UC-04/§29.4: illegal transition rejected 422, regardless of
// actor — EN_ATTENTE -> RESOLUE isn't a legal edge in the state machine for
// anyone. Previously asserted 403 here (a real bug: state-skip and
// wrong-actor were conflated into one Policy check that only ever returned
// 403 — see UpdateInterventionStatusRequest::after()).
test('a client cannot force EN_ATTENTE directly to RESOLUE', function () {
    $client = User::factory()->create();
    $intervention = makeIntervention(['id_client' => $client->id]);

    $this->actingAs($client, 'sanctum')
        ->patchJson("/api/v1/interventions/{$intervention->id_intervention}/statut", ['statut' => 'RESOLUE'])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['statut']);
});

// Same state-skip case, but with an actor (admin) who WOULD otherwise be
// allowed to make this transition if it existed — confirms 422 fires before
// authorization even runs, i.e. it's a true actor-independent validation
// failure, not a lucky side-effect of the client also lacking permission.
test('an admin also cannot force EN_ATTENTE directly to RESOLUE', function () {
    $admin = User::factory()->admin()->create();
    $intervention = makeIntervention();

    $this->actingAs($admin, 'sanctum')
        ->patchJson("/api/v1/interventions/{$intervention->id_intervention}/statut", ['statut' => 'RESOLUE'])
        ->assertUnprocessable()
        ->assertJsonValidationErrors(['statut']);
});

// SRS BRULE-003: BLOQUE requires a reason.
test('blocking a ticket without a reason is rejected', function () {
    $technicien = User::factory()->technicien()->create();
    $intervention = makeIntervention(['statut' => InterventionStatus::EnCours, 'id_technicien' => $technicien->id]);

    $this->actingAs($technicien, 'sanctum')
        ->patchJson("/api/v1/interventions/{$intervention->id_intervention}/statut", ['statut' => 'BLOQUE'])
        ->assertStatus(422)
        ->assertJsonValidationErrors('motif_blocage');
});

// SRS AC-09 / BRULE-003: RESOLUE requires a technical report.
test('resolving a ticket requires a technical report', function () {
    $technicien = User::factory()->technicien()->create();
    $intervention = makeIntervention(['statut' => InterventionStatus::EnCours, 'id_technicien' => $technicien->id]);

    $this->actingAs($technicien, 'sanctum')
        ->patchJson("/api/v1/interventions/{$intervention->id_intervention}/statut", ['statut' => 'RESOLUE'])
        ->assertStatus(422)
        ->assertJsonValidationErrors('rapport_technique');
});

test('resolving with a report succeeds and records status history', function () {
    $technicien = User::factory()->technicien()->create();
    $intervention = makeIntervention(['statut' => InterventionStatus::EnCours, 'id_technicien' => $technicien->id]);

    $this->actingAs($technicien, 'sanctum')
        ->patchJson("/api/v1/interventions/{$intervention->id_intervention}/statut", [
            'statut' => 'RESOLUE',
            'rapport_technique' => 'Remplacement du disque dur.',
        ])
        ->assertOk()
        ->assertJsonPath('data.statut', 'RESOLUE');

    expect($intervention->statusHistory()->where('nouveau_statut', 'RESOLUE')->exists())->toBeTrue();
});

// SRS AC-08: only the client may close, not the technician.
test('a technician cannot close their own ticket', function () {
    $technicien = User::factory()->technicien()->create();
    $intervention = makeIntervention(['statut' => InterventionStatus::Resolue, 'id_technicien' => $technicien->id]);

    $this->actingAs($technicien, 'sanctum')
        ->patchJson("/api/v1/interventions/{$intervention->id_intervention}/cloturer", [])
        ->assertForbidden();
});

test('the owning client can close a resolved ticket with a rating', function () {
    $client = User::factory()->create();
    $intervention = makeIntervention(['statut' => InterventionStatus::Resolue, 'id_client' => $client->id]);

    $response = $this->actingAs($client, 'sanctum')
        ->patchJson("/api/v1/interventions/{$intervention->id_intervention}/cloturer", ['note_satisfaction' => 5]);

    $response->assertOk()->assertJsonPath('data.statut', 'CLOTUREE');
    expect($intervention->fresh()->note_satisfaction)->toBe(5);
    expect($intervention->fresh()->date_cloture)->not->toBeNull();
});

// SRS FR-CRT-08 (D-17)
test('a client can cancel a ticket that is still EN_ATTENTE', function () {
    $client = User::factory()->create();
    $intervention = makeIntervention(['id_client' => $client->id]);

    $this->actingAs($client, 'sanctum')
        ->patchJson("/api/v1/interventions/{$intervention->id_intervention}/annuler", [])
        ->assertOk()
        ->assertJsonPath('data.statut', 'ANNULEE');
});

test('a ticket already EN_COURS cannot be cancelled', function () {
    $client = User::factory()->create();
    $intervention = makeIntervention(['statut' => InterventionStatus::EnCours, 'id_client' => $client->id]);

    $this->actingAs($client, 'sanctum')
        ->patchJson("/api/v1/interventions/{$intervention->id_intervention}/annuler", [])
        ->assertForbidden();
});

// SRS BRULE-001: scoped listing per role.
test('a technician only sees interventions assigned to them in the list', function () {
    $technicien = User::factory()->technicien()->create();
    makeIntervention(['statut' => InterventionStatus::EnCours, 'id_technicien' => $technicien->id]);
    makeIntervention(); // not assigned to this technician

    $response = $this->actingAs($technicien, 'sanctum')->getJson('/api/v1/interventions');

    $response->assertOk();
    expect($response->json('data'))->toHaveCount(1);
});

// SRS FR-CRT-04/§17.2: ticket-creation-time attachments (previously unimplemented).
test('the owning client can attach a photo to their ticket', function () {
    Storage::fake('local');
    $client = User::factory()->create();
    $intervention = makeIntervention(['id_client' => $client->id]);
    $file = UploadedFile::fake()->image('panne.jpg', 800, 600)->size(500);

    $response = $this->actingAs($client, 'sanctum')
        ->post("/api/v1/interventions/{$intervention->id_intervention}/pieces-jointes", ['fichier' => $file]);

    $response->assertCreated()->assertJsonPath('data.type_mime', 'image/jpeg');
    expect(PieceJointe::where('id_intervention', $intervention->id_intervention)->count())->toBe(1);
});

test('a user unrelated to the ticket cannot attach a file to it', function () {
    Storage::fake('local');
    $intruder = User::factory()->create();
    $intervention = makeIntervention();
    $file = UploadedFile::fake()->image('panne.jpg');

    $this->actingAs($intruder, 'sanctum')
        ->post("/api/v1/interventions/{$intervention->id_intervention}/pieces-jointes", ['fichier' => $file])
        ->assertForbidden();
});

test('attachments are rejected once the ticket is closed', function () {
    Storage::fake('local');
    $client = User::factory()->create();
    $intervention = makeIntervention(['id_client' => $client->id, 'statut' => InterventionStatus::Cloturee]);
    $file = UploadedFile::fake()->image('panne.jpg');

    $this->actingAs($client, 'sanctum')
        ->post("/api/v1/interventions/{$intervention->id_intervention}/pieces-jointes", ['fichier' => $file])
        ->assertForbidden();
});

test('a disallowed file type is rejected', function () {
    Storage::fake('local');
    $client = User::factory()->create();
    $intervention = makeIntervention(['id_client' => $client->id]);
    $file = UploadedFile::fake()->create('malware.exe', 100, 'application/x-msdownload');

    $this->actingAs($client, 'sanctum')
        ->post("/api/v1/interventions/{$intervention->id_intervention}/pieces-jointes", ['fichier' => $file])
        ->assertUnprocessable();
});

test('the per-ticket attachment limit is enforced', function () {
    Storage::fake('local');
    $client = User::factory()->create();
    $intervention = makeIntervention(['id_client' => $client->id]);

    for ($i = 0; $i < 5; $i++) {
        PieceJointe::create([
            'id_intervention' => $intervention->id_intervention,
            'chemin_fichier' => "interventions/{$intervention->id_intervention}/existing-{$i}.jpg",
            'type_mime' => 'image/jpeg',
            'taille_octets' => 100,
            'uploaded_by' => $client->id,
        ]);
    }
    $file = UploadedFile::fake()->image('one-too-many.jpg');

    $this->actingAs($client, 'sanctum')
        ->post("/api/v1/interventions/{$intervention->id_intervention}/pieces-jointes", ['fichier' => $file])
        ->assertUnprocessable();
});

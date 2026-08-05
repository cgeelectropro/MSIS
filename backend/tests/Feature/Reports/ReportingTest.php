<?php

use App\Enums\InterventionStatus;
use App\Models\Intervention;
use App\Models\InterventionStatusHistory;
use App\Models\User;

// SRS §19: only the Supervisor may view aggregate reports.
test('a non-admin cannot view the dashboard', function () {
    $client = User::factory()->create();

    $this->actingAs($client, 'sanctum')->getJson('/api/v1/reports/dashboard')->assertForbidden();
});

// SRS FR-DASH-01
test('the dashboard reports correct totals by status', function () {
    $admin = User::factory()->admin()->create();
    $client = User::factory()->create();

    Intervention::create(['titre' => 'a', 'description' => str_repeat('x', 20), 'statut' => InterventionStatus::EnAttente, 'priorite' => 'NORMALE', 'id_client' => $client->id]);
    Intervention::create(['titre' => 'b', 'description' => str_repeat('x', 20), 'statut' => InterventionStatus::EnCours, 'priorite' => 'HAUTE', 'id_client' => $client->id]);
    Intervention::create(['titre' => 'c', 'description' => str_repeat('x', 20), 'statut' => InterventionStatus::EnCours, 'priorite' => 'HAUTE', 'id_client' => $client->id]);

    $response = $this->actingAs($admin, 'sanctum')->getJson('/api/v1/reports/dashboard');

    $response->assertOk();
    expect($response->json('kpis.total'))->toBe(3);
    expect($response->json('kpis.par_statut.EN_ATTENTE'))->toBe(1);
    expect($response->json('kpis.par_statut.EN_COURS'))->toBe(2);
});

// SRS RPT-04 / Gap Analysis D-20b: pickup time is computable from status history.
test('average pickup time is computed from intervention_status_history', function () {
    $admin = User::factory()->admin()->create();
    $client = User::factory()->create();
    $technicien = User::factory()->technicien()->create();

    $intervention = Intervention::create([
        'titre' => 'a', 'description' => str_repeat('x', 20),
        'statut' => InterventionStatus::EnCours, 'priorite' => 'NORMALE',
        'id_client' => $client->id, 'id_technicien' => $technicien->id,
    ]);
    // `created_at` is not mass-assignable (by design, §18.6) — backdate it
    // directly to simulate a ticket created 30 minutes ago.
    $intervention->forceFill(['created_at' => now()->subMinutes(30)])->save();

    InterventionStatusHistory::create([
        'id_intervention' => $intervention->id_intervention,
        'ancien_statut' => InterventionStatus::EnAttente,
        'nouveau_statut' => InterventionStatus::EnCours,
        'id_user' => $admin->id,
        'created_at' => now(), // 30 minutes after creation
    ]);

    $response = $this->actingAs($admin, 'sanctum')->getJson('/api/v1/reports/dashboard');

    expect($response->json('kpis.delai_moyen_prise_en_charge_minutes'))->toBeGreaterThanOrEqual(29.0);
    expect($response->json('kpis.delai_moyen_prise_en_charge_minutes'))->toBeLessThanOrEqual(31.0);
});

test('per-technician workload only counts active tickets', function () {
    $admin = User::factory()->admin()->create();
    $client = User::factory()->create();
    $technicien = User::factory()->technicien()->create();

    Intervention::create(['titre' => 'a', 'description' => str_repeat('x', 20), 'statut' => InterventionStatus::EnCours, 'priorite' => 'NORMALE', 'id_client' => $client->id, 'id_technicien' => $technicien->id]);
    Intervention::create(['titre' => 'b', 'description' => str_repeat('x', 20), 'statut' => InterventionStatus::Cloturee, 'priorite' => 'NORMALE', 'id_client' => $client->id, 'id_technicien' => $technicien->id, 'date_cloture' => now()]);

    $response = $this->actingAs($admin, 'sanctum')->getJson('/api/v1/reports/dashboard');

    $workload = collect($response->json('kpis.charge_par_technicien'))->firstWhere('id_technicien', $technicien->id);
    expect($workload['charge'])->toBe(1);
});

// SRS §23.3 CSV export
test('a supervisor can export interventions as csv', function () {
    $admin = User::factory()->admin()->create();
    $client = User::factory()->create();
    Intervention::create(['titre' => 'Export test', 'description' => str_repeat('x', 20), 'statut' => InterventionStatus::EnAttente, 'priorite' => 'NORMALE', 'id_client' => $client->id]);

    $response = $this->actingAs($admin, 'sanctum')->get('/api/v1/reports/export?format=csv');

    $response->assertOk();
    expect($response->headers->get('Content-Type'))->toContain('text/csv');
    expect($response->getContent())->toContain('Export test');
});

test('a supervisor can export interventions as pdf', function () {
    $admin = User::factory()->admin()->create();
    $client = User::factory()->create();
    Intervention::create(['titre' => 'PDF test', 'description' => str_repeat('x', 20), 'statut' => InterventionStatus::EnAttente, 'priorite' => 'NORMALE', 'id_client' => $client->id]);

    $response = $this->actingAs($admin, 'sanctum')->get('/api/v1/reports/export?format=pdf');

    $response->assertOk();
    expect($response->headers->get('Content-Type'))->toContain('application/pdf');
});

test('export rejects an unsupported format', function () {
    $admin = User::factory()->admin()->create();

    $this->actingAs($admin, 'sanctum')->get('/api/v1/reports/export?format=xlsx')->assertStatus(422);
});

test('export can be filtered by status', function () {
    $admin = User::factory()->admin()->create();
    $client = User::factory()->create();
    Intervention::create(['titre' => 'Pending one', 'description' => str_repeat('x', 20), 'statut' => InterventionStatus::EnAttente, 'priorite' => 'NORMALE', 'id_client' => $client->id]);
    Intervention::create(['titre' => 'Closed one', 'description' => str_repeat('x', 20), 'statut' => InterventionStatus::Cloturee, 'priorite' => 'NORMALE', 'id_client' => $client->id, 'date_cloture' => now()]);

    $response = $this->actingAs($admin, 'sanctum')->get('/api/v1/reports/export?format=csv&statut=EN_ATTENTE');

    expect($response->getContent())->toContain('Pending one');
    expect($response->getContent())->not->toContain('Closed one');
});

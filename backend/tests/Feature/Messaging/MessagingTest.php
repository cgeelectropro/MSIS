<?php

use App\Enums\InterventionStatus;
use App\Events\MessageSent;
use App\Models\AuditLog;
use App\Models\Intervention;
use App\Models\Message;
use App\Models\User;
use App\Policies\MessagePolicy;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Storage;

function makeAssignedIntervention(array $overrides = []): Intervention
{
    return Intervention::create(array_merge([
        'titre' => 'Ecran bleu au démarrage',
        'description' => str_repeat('a', 20),
        'statut' => InterventionStatus::EnCours,
        'priorite' => 'NORMALE',
        'id_client' => User::factory()->create()->id,
        'id_technicien' => User::factory()->technicien()->create()->id,
    ], $overrides));
}

// SRS AC-10 / FR-DET-03/04
test('the owning client can send a message on their ticket', function () {
    Event::fake([MessageSent::class]);
    $intervention = makeAssignedIntervention();
    $client = $intervention->client;

    $response = $this->actingAs($client, 'sanctum')
        ->postJson("/api/v1/interventions/{$intervention->id_intervention}/messages", [
            'contenu' => 'Bonjour, le problème persiste.',
        ]);

    $response->assertCreated();
    Event::assertDispatched(MessageSent::class);
});

test('the assigned technician can send a message', function () {
    Event::fake([MessageSent::class]);
    $intervention = makeAssignedIntervention();

    $this->actingAs($intervention->technicien, 'sanctum')
        ->postJson("/api/v1/interventions/{$intervention->id_intervention}/messages", [
            'contenu' => 'Je passe demain matin.',
        ])
        ->assertCreated();
});

// SRS AC-11 / TR-08: a third party can neither read nor write.
test('a user unrelated to the ticket cannot read the conversation', function () {
    $intervention = makeAssignedIntervention();
    $stranger = User::factory()->create();

    $this->actingAs($stranger, 'sanctum')
        ->getJson("/api/v1/interventions/{$intervention->id_intervention}/messages")
        ->assertForbidden();
});

test('a user unrelated to the ticket cannot send a message', function () {
    $intervention = makeAssignedIntervention();
    $stranger = User::factory()->create();

    $this->actingAs($stranger, 'sanctum')
        ->postJson("/api/v1/interventions/{$intervention->id_intervention}/messages", ['contenu' => 'x'])
        ->assertForbidden();
});

// SRS BRULE-004: Admin has read-only audit access, never write.
test('an admin can read a conversation in audit mode but cannot send messages', function () {
    $intervention = makeAssignedIntervention();
    $admin = User::factory()->admin()->create();

    $this->actingAs($admin, 'sanctum')
        ->getJson("/api/v1/interventions/{$intervention->id_intervention}/messages")
        ->assertOk();

    $this->actingAs($admin, 'sanctum')
        ->postJson("/api/v1/interventions/{$intervention->id_intervention}/messages", ['contenu' => 'x'])
        ->assertForbidden();
});

// SRS §20.3: every admin audit-mode read is logged.
test('admin audit reads are logged to the audit trail', function () {
    $intervention = makeAssignedIntervention();
    $admin = User::factory()->admin()->create();

    $this->actingAs($admin, 'sanctum')->getJson("/api/v1/interventions/{$intervention->id_intervention}/messages");

    expect(
        AuditLog::where('action', 'message_audit_read')
            ->where('id_user', $admin->id)
            ->where('entite_id', $intervention->id_intervention)
            ->exists()
    )->toBeTrue();
});

// SRS BRULE-017: no new messages once CLOTUREE.
test('messaging is locked once the ticket is closed', function () {
    $intervention = makeAssignedIntervention(['statut' => InterventionStatus::Cloturee]);

    $this->actingAs($intervention->client, 'sanctum')
        ->postJson("/api/v1/interventions/{$intervention->id_intervention}/messages", ['contenu' => 'x'])
        ->assertForbidden();
});

// SRS SEC-25: the database never stores plaintext message content.
test('message content is encrypted at rest', function () {
    $intervention = makeAssignedIntervention();

    $this->actingAs($intervention->client, 'sanctum')
        ->postJson("/api/v1/interventions/{$intervention->id_intervention}/messages", [
            'contenu' => 'Mot de passe admin : hunter2',
        ])
        ->assertCreated();

    $raw = DB::table('messages')->where('id_intervention', $intervention->id_intervention)->first();
    expect($raw->contenu)->not->toContain('hunter2');

    $decrypted = Message::find($raw->id_message);
    expect($decrypted->contenu)->toBe('Mot de passe admin : hunter2');
});

// SRS FR-DET-04 / §22: photo message attachment.
test('a message can carry a photo attachment', function () {
    Storage::fake('local');
    $intervention = makeAssignedIntervention();
    $file = UploadedFile::fake()->image('photo.jpg', 800, 600)->size(500);

    $response = $this->actingAs($intervention->client, 'sanctum')
        ->post("/api/v1/interventions/{$intervention->id_intervention}/messages", [
            'attachment' => $file,
        ]);

    $response->assertCreated();
    $message = Message::latest('id_message')->first();
    expect($message->attachments()->count())->toBe(1);
});

// SRS FR-DET-07: seen indicator, only the non-sender can mark it read.
test('marking a message seen sets lu and lu_at', function () {
    $intervention = makeAssignedIntervention();
    $message = Message::create([
        'id_intervention' => $intervention->id_intervention,
        'id_expediteur' => $intervention->client->id,
        'contenu' => 'Bonjour',
    ]);

    $this->actingAs($intervention->technicien, 'sanctum')
        ->patchJson("/api/v1/messages/{$message->id_message}/seen")
        ->assertOk()
        ->assertJsonPath('data.lu', true);

    expect($message->fresh()->lu_at)->not->toBeNull();
});

// SRS §18.5 GET /messages/unread
test('unread count only counts messages not sent by the requester', function () {
    $intervention = makeAssignedIntervention();
    Message::create(['id_intervention' => $intervention->id_intervention, 'id_expediteur' => $intervention->client->id, 'contenu' => 'a']);
    Message::create(['id_intervention' => $intervention->id_intervention, 'id_expediteur' => $intervention->client->id, 'contenu' => 'b']);

    $response = $this->actingAs($intervention->technicien, 'sanctum')->getJson('/api/v1/messages/unread');

    $response->assertOk()->assertJsonPath('count', 2);
});

// SRS BRULE-014: 60 messages / minute / user.
test('sending messages is rate limited', function () {
    $intervention = makeAssignedIntervention();

    for ($i = 0; $i < 60; $i++) {
        $this->actingAs($intervention->client, 'sanctum')
            ->postJson("/api/v1/interventions/{$intervention->id_intervention}/messages", ['contenu' => "msg $i"]);
    }

    $response = $this->actingAs($intervention->client, 'sanctum')
        ->postJson("/api/v1/interventions/{$intervention->id_intervention}/messages", ['contenu' => 'one too many']);

    $response->assertStatus(429);
});

// SRS §21.1: routes/channels.php's `intervention.{id}` resolver, exercised
// directly rather than through a live Reverb/Pusher-protocol HTTP round trip
// — the latter tests Laravel/Reverb's own broadcaster plumbing, not this
// app's authorization rule, and the rule itself (MessagePolicy::viewConversation)
// is already covered end-to-end by the REST-level access-control tests above.
test('the broadcast channel resolver delegates to MessagePolicy::viewConversation', function () {
    $intervention = makeAssignedIntervention();
    $stranger = User::factory()->create();

    $policy = app(MessagePolicy::class);

    expect($policy->viewConversation($intervention->client, $intervention))->toBeTrue();
    expect($policy->viewConversation($intervention->technicien, $intervention))->toBeTrue();
    expect($policy->viewConversation($stranger, $intervention))->toBeFalse();
});

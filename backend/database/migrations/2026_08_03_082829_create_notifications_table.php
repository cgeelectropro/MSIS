<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SRS §18.3 `notifications` — the app's own in-app notification feed (SCR-14),
 * NOT Laravel's built-in `database` notification channel table (which uses a
 * different, UUID-based schema). This app never dispatches the `database`
 * channel for that exact reason — only `mail` (see TechnicianInvitation) and,
 * from the Intervention/Messaging modules onward, this custom table directly
 * via NotificationService, per SRS §20/§14.5.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('notifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_user')->constrained('users')->cascadeOnDelete();
            $table->string('type', 50);
            $table->string('canal', 20); // App\Enums\NotificationChannel
            $table->string('contenu', 255);
            $table->foreignId('id_intervention')->nullable()->constrained('interventions', 'id_intervention')->nullOnDelete();
            $table->boolean('lu')->default(false);
            $table->timestamp('created_at')->nullable();

            $table->index(['id_user', 'lu'], 'idx_notif_user');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('notifications');
    }
};

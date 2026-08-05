<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Engineering Recommendation (not in `cahier_de_charge.txt`'s original schema):
 * stores per-device FCM registration tokens so PushNotificationService can
 * target a user across multiple installed devices, consistent with SRS §18.4
 * "un utilisateur peut être connecté sur plusieurs appareils simultanément."
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('device_tokens', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_user')->constrained('users')->cascadeOnDelete();
            $table->string('token', 255)->unique();
            $table->string('platform', 20)->default('android');
            $table->timestamps();

            $table->index('id_user', 'idx_device_tokens_user');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('device_tokens');
    }
};

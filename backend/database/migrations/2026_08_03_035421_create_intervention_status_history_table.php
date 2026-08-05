<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/** SRS §18.3 — Gap Analysis D-20b, Must-priority: the sole source for the
 * pickup-time/resolution-time KPIs in SRS §19.1. */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('intervention_status_history', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_intervention')->constrained('interventions', 'id_intervention')->cascadeOnDelete();
            $table->string('ancien_statut', 20)->nullable();
            $table->string('nouveau_statut', 20);
            $table->foreignId('id_user')->constrained('users');
            $table->timestamp('created_at')->nullable();

            $table->index(['id_intervention', 'created_at'], 'idx_history_intervention');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('intervention_status_history');
    }
};

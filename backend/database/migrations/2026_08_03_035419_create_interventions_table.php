<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SRS §18.3 `interventions` — Official Requirement (Report/Client). `ANNULEE`
 * included in the status enum per D-17's accepted resolution (see FR-CRT-08).
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('interventions', function (Blueprint $table) {
            $table->id('id_intervention');
            $table->string('titre', 255);
            $table->text('description');
            $table->string('statut', 20)->default('EN_ATTENTE'); // App\Enums\InterventionStatus
            $table->string('priorite', 20)->default('NORMALE'); // App\Enums\InterventionPriority
            $table->foreignId('id_client')->constrained('users')->cascadeOnDelete();
            $table->foreignId('id_technicien')->nullable()->constrained('users')->nullOnDelete();
            $table->string('motif_blocage')->nullable();
            $table->text('rapport_technique')->nullable();
            $table->tinyInteger('note_satisfaction')->nullable();
            $table->timestamp('date_cloture')->nullable();
            $table->timestamps();

            $table->index('id_client', 'idx_interv_client');
            $table->index('id_technicien', 'idx_interv_technicien');
            $table->index('statut', 'idx_interv_statut');
            // GAP_ANALYSIS.md §3 recommendation: composite index for the technician's
            // filtered mission list (FR-TECH-02), the most common query shape.
            $table->index(['id_technicien', 'statut'], 'idx_interv_technicien_statut');
        });

        // SRS DR-02: note_satisfaction must be NULL or between 1 and 5. Skipped on
        // sqlite (test suite only) — CHECK constraints added post-creation are not
        // reliably supported across sqlite versions in CI; enforced app-side there.
        if (Schema::getConnection()->getDriverName() !== 'sqlite') {
            Schema::getConnection()->statement(
                'ALTER TABLE interventions ADD CONSTRAINT chk_note CHECK (note_satisfaction IS NULL OR note_satisfaction BETWEEN 1 AND 5)'
            );
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('interventions');
    }
};

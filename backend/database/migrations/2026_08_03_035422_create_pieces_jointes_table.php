<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/** SRS §18.3 `pieces_jointes`, XOR-parent constraint per Gap Analysis D-20c. */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('pieces_jointes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_intervention')->nullable()->constrained('interventions', 'id_intervention')->cascadeOnDelete();
            $table->foreignId('id_message')->nullable()->constrained('messages', 'id_message')->cascadeOnDelete();
            $table->string('chemin_fichier', 500);
            $table->string('type_mime', 100);
            $table->unsignedInteger('taille_octets');
            $table->foreignId('uploaded_by')->constrained('users');
            $table->timestamp('created_at')->nullable();
        });

        // SRS DR-01: exactly one parent must be set. Skipped on sqlite (test-only)
        // for the same reason as interventions.chk_note.
        if (Schema::getConnection()->getDriverName() !== 'sqlite') {
            Schema::getConnection()->statement(
                'ALTER TABLE pieces_jointes ADD CONSTRAINT chk_pj_xor_parent CHECK ((id_intervention IS NULL) <> (id_message IS NULL))'
            );
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('pieces_jointes');
    }
};

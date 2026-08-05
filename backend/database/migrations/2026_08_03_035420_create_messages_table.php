<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SRS §18.3 `messages`. `livre`/`livre_at` added per Gap Analysis D-20d,
 * closing the gap between UC-06's delivered->read progression and a schema
 * that previously modeled only "read." `contenu` is encrypted at rest via
 * an Eloquent cast (see App\Models\Message), not at the column-type level.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('messages', function (Blueprint $table) {
            $table->id('id_message');
            $table->foreignId('id_intervention')->constrained('interventions', 'id_intervention')->cascadeOnDelete();
            $table->foreignId('id_expediteur')->constrained('users');
            $table->text('contenu');
            $table->boolean('livre')->default(false);
            $table->timestamp('livre_at')->nullable();
            $table->boolean('lu')->default(false);
            $table->timestamp('lu_at')->nullable();
            $table->timestamp('created_at')->nullable();

            $table->index(['id_intervention', 'created_at'], 'idx_msg_intervention');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('messages');
    }
};

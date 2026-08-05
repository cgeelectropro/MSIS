<?php

namespace App\Models;

use App\Enums\InterventionPriority;
use App\Enums\InterventionStatus;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/** SRS §18.3 `interventions`. No soft deletes by design (§18.6). */
class Intervention extends Model
{
    protected $table = 'interventions';

    protected $primaryKey = 'id_intervention';

    protected $fillable = [
        'titre',
        'description',
        'statut',
        'priorite',
        'id_client',
        'id_technicien',
        'motif_blocage',
        'rapport_technique',
        'note_satisfaction',
        'date_cloture',
    ];

    protected function casts(): array
    {
        return [
            'statut' => InterventionStatus::class,
            'priorite' => InterventionPriority::class,
            'date_cloture' => 'datetime',
        ];
    }

    public function client(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_client');
    }

    public function technicien(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_technicien');
    }

    public function statusHistory(): HasMany
    {
        return $this->hasMany(InterventionStatusHistory::class, 'id_intervention', 'id_intervention');
    }

    public function messages(): HasMany
    {
        return $this->hasMany(Message::class, 'id_intervention', 'id_intervention');
    }

    public function attachments(): HasMany
    {
        return $this->hasMany(PieceJointe::class, 'id_intervention', 'id_intervention');
    }
}

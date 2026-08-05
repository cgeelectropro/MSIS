<?php

namespace App\Models;

use App\Enums\InterventionStatus;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/** SRS §18.3, Gap Analysis D-20b — write-once, no `updated_at`. */
class InterventionStatusHistory extends Model
{
    const UPDATED_AT = null;

    protected $table = 'intervention_status_history';

    protected $fillable = ['id_intervention', 'ancien_statut', 'nouveau_statut', 'id_user'];

    protected function casts(): array
    {
        return [
            'ancien_statut' => InterventionStatus::class,
            'nouveau_statut' => InterventionStatus::class,
        ];
    }

    public function intervention(): BelongsTo
    {
        return $this->belongsTo(Intervention::class, 'id_intervention', 'id_intervention');
    }
}

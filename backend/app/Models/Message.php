<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * SRS §18.3 `messages` / SEC-25: `contenu` uses Laravel's `encrypted` cast
 * (AES-256-CBC via APP_KEY) so the database never stores plaintext message
 * content — this is the concrete implementation of §17.5, not a separate
 * mechanism.
 */
class Message extends Model
{
    const UPDATED_AT = null;

    protected $table = 'messages';

    protected $primaryKey = 'id_message';

    protected $fillable = ['id_intervention', 'id_expediteur', 'contenu', 'livre', 'livre_at', 'lu', 'lu_at'];

    protected function casts(): array
    {
        return [
            'contenu' => 'encrypted',
            'livre' => 'boolean',
            'livre_at' => 'datetime',
            'lu' => 'boolean',
            'lu_at' => 'datetime',
        ];
    }

    public function intervention(): BelongsTo
    {
        return $this->belongsTo(Intervention::class, 'id_intervention', 'id_intervention');
    }

    public function expediteur(): BelongsTo
    {
        return $this->belongsTo(User::class, 'id_expediteur');
    }

    public function attachments(): HasMany
    {
        return $this->hasMany(PieceJointe::class, 'id_message', 'id_message');
    }
}

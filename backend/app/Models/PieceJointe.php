<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\Storage;

/** SRS §18.3 `pieces_jointes`. */
class PieceJointe extends Model
{
    const UPDATED_AT = null;

    protected $table = 'pieces_jointes';

    protected $fillable = ['id_intervention', 'id_message', 'chemin_fichier', 'type_mime', 'taille_octets', 'uploaded_by'];

    public function intervention(): BelongsTo
    {
        return $this->belongsTo(Intervention::class, 'id_intervention', 'id_intervention');
    }

    public function message(): BelongsTo
    {
        return $this->belongsTo(Message::class, 'id_message', 'id_message');
    }

    /** Gap Analysis D-30: the physical file is deleted whenever this row is,
     *  regardless of what triggered the cascade. Registered in AppServiceProvider. */
    public function deleteFile(): void
    {
        Storage::disk('local')->delete($this->chemin_fichier);
    }
}

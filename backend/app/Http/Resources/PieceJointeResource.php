<?php

namespace App\Http\Resources;

use App\Models\PieceJointe;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\URL;

/**
 * SRS §22 FILE-09: never a permanent/direct public URL — the `url` field is
 * a signed, time-limited route (1 hour), matching the "signed temporary
 * route" requirement exactly.
 *
 * @mixin PieceJointe
 */
class PieceJointeResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'type_mime' => $this->type_mime,
            'taille_octets' => $this->taille_octets,
            'url' => URL::temporarySignedRoute('attachments.download', now()->addHour(), ['pieceJointe' => $this->id]),
            'created_at' => $this->created_at,
        ];
    }
}

<?php

namespace App\Http\Resources;

use App\Models\Message;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin Message */
class MessageResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id_message' => $this->id_message,
            'id_intervention' => $this->id_intervention,
            'id_expediteur' => $this->id_expediteur,
            'expediteur' => new UserResource($this->whenLoaded('expediteur')),
            'contenu' => $this->contenu,
            'attachments' => PieceJointeResource::collection($this->whenLoaded('attachments')),
            'livre' => $this->livre,
            'livre_at' => $this->livre_at,
            'lu' => $this->lu,
            'lu_at' => $this->lu_at,
            'created_at' => $this->created_at,
        ];
    }
}

<?php

namespace App\Http\Resources;

use App\Models\Intervention;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin Intervention */
class InterventionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id_intervention' => $this->id_intervention,
            'titre' => $this->titre,
            'description' => $this->description,
            'statut' => $this->statut->value,
            'priorite' => $this->priorite->value,
            'id_client' => $this->id_client,
            'id_technicien' => $this->id_technicien,
            'client' => new UserResource($this->whenLoaded('client')),
            'technicien' => new UserResource($this->whenLoaded('technicien')),
            'attachments' => PieceJointeResource::collection($this->whenLoaded('attachments')),
            'motif_blocage' => $this->motif_blocage,
            'rapport_technique' => $this->rapport_technique,
            'note_satisfaction' => $this->note_satisfaction,
            'date_cloture' => $this->date_cloture,
            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}

<?php

namespace App\Http\Resources;

use App\Models\AppNotification;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin AppNotification */
class NotificationResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'type' => $this->type,
            'canal' => $this->canal->value,
            'contenu' => $this->contenu,
            'id_intervention' => $this->id_intervention,
            'lu' => $this->lu,
            'created_at' => $this->created_at,
        ];
    }
}

<?php

namespace App\Http\Resources;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/** @mixin User */
class UserResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'nom' => $this->nom,
            'email' => $this->email,
            'role' => $this->role->value,
            // SRS D-08: phone visibility is Service-level scoped for other actors; the
            // owner always sees their own number, so no gating is applied here — /profile
            // and /auth/me are always "self."
            'telephone' => $this->telephone,
            'actif' => $this->actif,
            'created_at' => $this->created_at,
        ];
    }
}

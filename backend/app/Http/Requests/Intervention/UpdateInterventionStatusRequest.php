<?php

namespace App\Http\Requests\Intervention;

use App\Enums\InterventionStatus;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Enum;

/** SRS FR-DET-02 / BRULE-002/003. Authorization (ownership + transition legality) is checked in the Controller via InterventionPolicy::updateStatus, since it needs the target enum value parsed first. */
class UpdateInterventionStatusRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'statut' => ['required', new Enum(InterventionStatus::class)],
            'motif_blocage' => ['sometimes', 'nullable', 'string', 'max:255'],
            'rapport_technique' => ['sometimes', 'nullable', 'string'],
        ];
    }
}

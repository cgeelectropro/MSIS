<?php

namespace App\Http\Requests\Intervention;

use Illuminate\Foundation\Http\FormRequest;

/** SRS §18.5 PATCH /interventions/{id}/cloturer / UC-05. */
class CloseInterventionRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('close', $this->route('intervention'));
    }

    public function rules(): array
    {
        return [
            'note_satisfaction' => ['sometimes', 'nullable', 'integer', 'min:1', 'max:5'],
            'commentaire' => ['sometimes', 'nullable', 'string', 'max:2000'],
        ];
    }
}

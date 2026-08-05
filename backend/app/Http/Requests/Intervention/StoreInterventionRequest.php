<?php

namespace App\Http\Requests\Intervention;

use App\Models\Intervention;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/** SRS BRULE-007 / FR-CRT-01..03/09. */
class StoreInterventionRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('create', Intervention::class);
    }

    public function rules(): array
    {
        $rules = [
            'titre' => ['required', 'string', 'min:5', 'max:150'],
            'description' => ['required', 'string', 'min:10', 'max:3000'],
            'priorite' => ['sometimes', Rule::in(['BASSE', 'NORMALE', 'HAUTE'])],
        ];

        if ($this->user()->isAdmin()) {
            $rules['id_client'] = ['required', 'exists:users,id'];
        }

        return $rules;
    }
}

<?php

namespace App\Http\Requests\Intervention;

use App\Models\Intervention;
use Illuminate\Foundation\Http\FormRequest;

/** SRS §18.5 PATCH /interventions/{id}/assigner. */
class AssignInterventionRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('assign', Intervention::class);
    }

    public function rules(): array
    {
        return ['id_technicien' => ['required', 'exists:users,id']];
    }
}

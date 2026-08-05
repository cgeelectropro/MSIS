<?php

namespace App\Http\Requests\User;

use Illuminate\Foundation\Http\FormRequest;

/** SRS FR-PROF-02. */
class UpdateProfileRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // always self — see ProfileController.
    }

    public function rules(): array
    {
        return [
            'nom' => ['sometimes', 'string', 'min:2', 'max:100'],
            'telephone' => ['sometimes', 'nullable', 'string', 'max:20'],
        ];
    }
}

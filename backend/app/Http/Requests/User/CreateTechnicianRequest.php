<?php

namespace App\Http\Requests\User;

use App\Models\User;
use Illuminate\Foundation\Http\FormRequest;

/** SRS FR-USR-05. */
class CreateTechnicianRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('create', User::class);
    }

    public function rules(): array
    {
        return [
            'nom' => ['required', 'string', 'min:2', 'max:100'],
            'email' => ['required', 'email', 'max:100', 'unique:users,email'],
            'telephone' => ['nullable', 'string', 'max:20'],
        ];
    }
}

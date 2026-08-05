<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Password;

/**
 * SRS FR-AUTH-11 (Engineering Recommendation, D-01): client self-registration.
 * Role is intentionally not accepted from the client — always CLIENT (AuthService).
 */
class RegisterRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'nom' => ['required', 'string', 'min:2', 'max:100'],
            'email' => ['required', 'email', 'max:100', 'unique:users,email'],
            // SRS FR-AUTH-08 / BRULE-006.
            'password' => ['required', 'confirmed', Password::min(8)->mixedCase()->numbers()->symbols()],
            'telephone' => ['nullable', 'string', 'max:20'],
        ];
    }
}

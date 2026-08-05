<?php

namespace App\Http\Requests\User;

use Illuminate\Foundation\Http\FormRequest;

/** SRS FR-USR-03. */
class UpdateUserStatusRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('updateStatus', $this->route('user'));
    }

    public function rules(): array
    {
        return ['actif' => ['required', 'boolean']];
    }
}

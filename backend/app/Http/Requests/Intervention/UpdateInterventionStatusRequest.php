<?php

namespace App\Http\Requests\Intervention;

use App\Enums\InterventionStatus;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Enum;

/**
 * SRS FR-DET-02 / BRULE-002/003. Two distinct failure modes, two distinct
 * status codes, per §6.6/§8.3/UC-04/§29.4 (repeated four times in the cahier
 * de charge, all specifying 422 for the state-skip case):
 *   - "this transition doesn't exist in the state machine at all" (e.g.
 *     EN_ATTENTE -> RESOLUE) is a validation failure, actor-independent ->
 *     checked HERE, 422.
 *   - "this transition exists, but you're not allowed to make it" (e.g. a
 *     technician not assigned to this ticket) is an authorization failure ->
 *     checked in InterventionPolicy::updateStatus, 403.
 * These were previously conflated into one Policy check that always returned
 * 403 regardless of which failure occurred.
 */
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

    public function after(): array
    {
        return [
            function ($validator) {
                $intervention = $this->route('intervention');
                $target = $this->input('statut');

                if (! $intervention || ! $target) {
                    return; // already failed basic validation, nothing more to check
                }

                $targetEnum = InterventionStatus::tryFrom($target);
                if ($targetEnum && ! $intervention->statut->canTransitionTo($targetEnum)) {
                    $validator->errors()->add(
                        'statut',
                        "Transition illegale : {$intervention->statut->value} -> {$targetEnum->value}."
                    );
                }
            },
        ];
    }
}

<?php

namespace App\Http\Requests\Intervention;

use App\Models\Intervention;
use Illuminate\Foundation\Http\FormRequest;

/** SRS FR-CRT-04/§22 FILE-02/FILE-05: ticket-creation-time attachments (previously unimplemented). */
class StoreInterventionAttachmentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('addAttachment', $this->route('intervention'));
    }

    public function rules(): array
    {
        $allowed = array_merge(
            config('msis.uploads.allowed_image_mimes'),
            config('msis.uploads.allowed_document_mimes')
        );

        return [
            'fichier' => [
                'required',
                'file',
                'max:'.config('msis.uploads.max_size_kb'),
                function ($attribute, $value, $fail) use ($allowed) {
                    if ($value && ! in_array($value->getMimeType(), $allowed, true)) {
                        $fail('Type de fichier non autorisé.');
                    }
                },
            ],
        ];
    }

    public function after(): array
    {
        return [
            function ($validator) {
                /** @var Intervention|null $intervention */
                $intervention = $this->route('intervention');
                $limit = config('msis.uploads.max_attachments_per_ticket');

                if ($intervention && $intervention->attachments()->count() >= $limit) {
                    $validator->errors()->add('fichier', "Limite de {$limit} pièces jointes par ticket atteinte.");
                }
            },
        ];
    }
}

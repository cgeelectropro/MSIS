<?php

namespace App\Http\Requests\Message;

use App\Models\Message;
use Illuminate\Foundation\Http\FormRequest;

/** SRS FR-DET-04 / §22: text and/or one photo attachment per message. */
class SendMessageRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()->can('send', [Message::class, $this->route('intervention')]);
    }

    public function rules(): array
    {
        $allowed = array_merge(
            config('msis.uploads.allowed_image_mimes'),
            config('msis.uploads.allowed_document_mimes')
        );

        return [
            'contenu' => ['required_without:attachment', 'nullable', 'string', 'max:5000'],
            'attachment' => [
                'sometimes',
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
}
